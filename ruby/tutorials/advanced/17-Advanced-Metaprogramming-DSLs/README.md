# Tutorial 17: Advanced Metaprogramming & DSLs

Welcome to the advanced tier! This tutorial explores Ruby's most powerful metaprogramming features for building Domain Specific Languages (DSLs) - the foundation of frameworks like Rails, RSpec, and Sinatra.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master `instance_eval` and `class_eval` for context manipulation
- Use `Binding` to capture and manipulate execution context
- Apply `Refinements` for scoped monkey-patching
- Build production-ready DSLs
- Understand the internals of Rails-style DSLs
- Know when metaprogramming enhances vs. obscures code

## 🐍➡️🔴 Coming from Python

Python has metaprogramming through metaclasses and descriptors, but Ruby's approach is more dynamic and pervasive:

| Concept | Python | Ruby |
|---------|--------|------|
| Eval in instance context | No direct equivalent | `instance_eval` |
| Eval in class context | `type()` manipulation | `class_eval` |
| Execution context | `locals()`, `globals()` | `Binding` object |
| Scoped patches | No built-in (can use context managers) | `Refinements` |
| Metaclasses | `class Meta(type):` | Class methods + `class_eval` |
| DSL building | Decorator chains, context managers | `instance_eval` + blocks |

> **📘 Python Note:** Python's metaclasses are powerful but complex. Ruby achieves similar results with simpler, more dynamic approaches. Think of `instance_eval` as a supercharged context manager that can modify the object itself.

## 📝 Deep Dive: instance_eval vs class_eval

### instance_eval - Change self and Scope

`instance_eval` executes a block in the context of a specific object instance:

```ruby
class Person
  def initialize(name)
    @name = name
    @secret = "top secret"
  end
  
  private
  
  def private_method
    "You found me!"
  end
end

person = Person.new("Alice")

# Access private instance variables
person.instance_eval do
  puts @name      # => "Alice"
  puts @secret    # => "top secret"
  
  # Can even call private methods!
  puts private_method  # => "You found me!"
end

# Add singleton methods (methods only on this instance)
person.instance_eval do
  def greet
    "Hello, I'm #{@name}!"
  end
end

puts person.greet  # => "Hello, I'm Alice!"

# This method only exists on this one instance
person2 = Person.new("Bob")
# person2.greet  # NoMethodError!
```

> **📘 Python Note:** This is like combining `setattr`, accessing `__dict__`, and modifying `__class__` all at once. Python would require:
> ```python
> # Access privates
> person._Person__secret
> # Add instance method
> from types import MethodType
> person.greet = MethodType(lambda self: f"Hello, {self._name}", person)
> ```

### class_eval - Modify Class Definition

`class_eval` (also `module_eval`) executes code in the context of a class:

```ruby
class Person
  # Initial empty class
end

# Add methods to the class dynamically
Person.class_eval do
  attr_accessor :name, :age
  
  def introduce
    "I'm #{name}, age #{age}"
  end
  
  # Can define class methods too
  def self.species
    "Homo sapiens"
  end
end

person = Person.new
person.name = "Alice"
person.age = 30
puts person.introduce  # => "I'm Alice, age 30"
puts Person.species    # => "Homo sapiens"
```

### Practical Use: Configuration DSL

```ruby
class Configuration
  def self.configure(&block)
    instance_eval(&block)
  end
  
  def self.option(name, default: nil)
    # Create class-level storage
    @options ||= {}
    @options[name] = default
    
    # Create setter
    define_singleton_method(name) do |value|
      @options[name] = value
    end
    
    # Create getter
    define_singleton_method("get_#{name}") do
      @options[name]
    end
  end
end

# Using the DSL
class AppConfig < Configuration
  option :api_key, default: nil
  option :timeout, default: 30
  option :retry_count, default: 3
end

# Configuration syntax looks like a DSL!
AppConfig.configure do
  api_key "sk-12345"
  timeout 60
  retry_count 5
end

puts AppConfig.get_api_key     # => "sk-12345"
puts AppConfig.get_timeout     # => 60
puts AppConfig.get_retry_count # => 5
```

> **📘 Python Note:** Similar to how Django settings or Flask configuration works, but more flexible. Python would typically use class attributes or a dictionary.

## 📝 Binding - Capturing Execution Context

A `Binding` encapsulates the entire execution context at a point in code:

```ruby
def outer_method
  local_var = "I'm local!"
  @instance_var = "I'm an instance variable"
  
  # Capture the binding here
  binding
end

# Get the binding from the method
captured = outer_method

# Eval code in that context
captured.eval("local_var")       # => "I'm local!"
captured.eval("@instance_var")   # => "I'm an instance variable"
captured.eval("local_var = 'changed!'")
captured.eval("local_var")       # => "changed!"

# Can see local variables
puts captured.local_variables    # => [:local_var]
```

### Practical Example: Template Engine

```ruby
class Template
  def initialize(template_string)
    @template = template_string
  end
  
  def render(context_binding)
    # Evaluate template in the given binding
    context_binding.eval("\"#{@template}\"")
  end
end

class User
  attr_accessor :name, :role
  
  def initialize(name, role)
    @name = name
    @role = role
  end
  
  def render_profile(template)
    # Pass our binding to the template
    template.render(binding)
  end
end

template = Template.new("Name: #{@name}, Role: #{@role.upcase}")
user = User.new("Alice", "admin")

puts user.render_profile(template)
# => "Name: Alice, Role: ADMIN"
```

> **📘 Python Note:** Python's `eval()` with `locals()` and `globals()` provides similar functionality, but Binding is a first-class object that can be passed around more easily.

## 📝 Refinements - Scoped Monkey Patching

Refinements let you modify classes safely without affecting the entire application:

```ruby
# Without refinements - DANGEROUS!
# This affects String everywhere in your app
class String
  def shout
    upcase + "!"
  end
end

# Better: Use refinements for scoped changes
module StringExtensions
  refine String do
    def shout
      upcase + "!"
    end
    
    def whisper
      downcase + "..."
    end
  end
end

# Without using the refinement, methods don't exist
# "hello".shout  # NoMethodError!

# Activate refinement only in this scope
class MyClass
  using StringExtensions
  
  def process(text)
    text.shout  # Works here!
  end
end

obj = MyClass.new
puts obj.process("hello")  # => "HELLO!"

# Outside the class, refinement doesn't apply
# "test".shout  # NoMethodError!
```

### Refinements for Math Operations

```ruby
module MathRefinements
  refine Integer do
    def factorial
      return 1 if self <= 1
      self * (self - 1).factorial
    end
    
    def squared
      self * self
    end
  end
  
  refine Array do
    def sum
      reduce(0, :+)
    end
    
    def average
      sum.to_f / size
    end
  end
end

class Calculator
  using MathRefinements
  
  def self.calculate
    puts 5.factorial    # => 120
    puts 4.squared      # => 16
    puts [1, 2, 3, 4, 5].average  # => 3.0
  end
end

Calculator.calculate

# Outside the class, these methods don't exist
# 5.factorial  # NoMethodError!
```

> **📘 Python Note:** No direct equivalent in Python. The closest would be creating wrapper classes or using context managers, but refinements are more elegant for temporary class modifications.

## 📝 Building a Real DSL: Route Mapper

Let's build a Rails-style routing DSL:

```ruby
class Router
  def initialize
    @routes = []
  end
  
  def get(path, to: nil, &block)
    add_route(:GET, path, to, block)
  end
  
  def post(path, to: nil, &block)
    add_route(:POST, path, to, block)
  end
  
  def put(path, to: nil, &block)
    add_route(:PUT, path, to, block)
  end
  
  def delete(path, to: nil, &block)
    add_route(:DELETE, path, to, block)
  end
  
  def resource(name)
    base = "/#{name}"
    get "#{base}", to: "#{name}#index"
    get "#{base}/:id", to: "#{name}#show"
    post "#{base}", to: "#{name}#create"
    put "#{base}/:id", to: "#{name}#update"
    delete "#{base}/:id", to: "#{name}#destroy"
  end
  
  def namespace(path, &block)
    old_prefix = @prefix
    @prefix = "#{@prefix}#{path}"
    instance_eval(&block)
    @prefix = old_prefix
  end
  
  def routes
    @routes
  end
  
  private
  
  def add_route(method, path, controller, block)
    full_path = "#{@prefix}#{path}"
    @routes << {
      method: method,
      path: full_path,
      controller: controller,
      handler: block
    }
  end
  
  def self.draw(&block)
    router = new
    router.instance_variable_set(:@prefix, "")
    router.instance_eval(&block)
    router.routes
  end
end

# Use the DSL!
routes = Router.draw do
  get "/", to: "home#index"
  
  resource :users
  resource :posts
  
  namespace "/api/v1" do
    get "/status", to: "api#status"
    resource :posts
  end
  
  get "/custom" do
    "Custom handler!"
  end
end

# Display routes
routes.each do |route|
  puts "#{route[:method].to_s.ljust(7)} #{route[:path].ljust(25)} => #{route[:controller]}"
end
```

Output:
```
GET     /                         => home#index
GET     /users                    => users#index
GET     /users/:id                => users#show
POST    /users                    => users#create
PUT     /users/:id                => users#update
DELETE  /users/:id                => users#destroy
...
```

> **📘 Python Note:** Flask and Django use decorators for routing. Ruby's approach with `instance_eval` allows a cleaner, more declarative syntax without needing @ symbols everywhere.

## 📝 Advanced Pattern: Builder DSL

```ruby
class HTMLBuilder
  def initialize
    @html = []
    @indent = 0
  end
  
  def method_missing(tag, *args, &block)
    attributes = args.first.is_a?(Hash) ? args.first : {}
    content = args.last.is_a?(String) ? args.last : nil
    
    # Opening tag
    attrs = attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    opening = "<#{tag}#{attrs.empty? ? '' : ' ' + attrs}>"
    
    if block
      @html << "  " * @indent + opening
      @indent += 1
      instance_eval(&block)
      @indent -= 1
      @html << "  " * @indent + "</#{tag}>"
    elsif content
      @html << "  " * @indent + opening + content + "</#{tag}>"
    else
      @html << "  " * @indent + opening + "</#{tag}>"
    end
  end
  
  def text(content)
    @html << "  " * @indent + content
  end
  
  def to_s
    @html.join("\n")
  end
  
  def self.build(&block)
    builder = new
    builder.instance_eval(&block)
    builder.to_s
  end
end

# Use the HTML DSL
html = HTMLBuilder.build do
  html do
    head do
      title "My Page"
      meta charset: "utf-8"
    end
    body do
      h1 "Welcome!"
      div class: "content" do
        p "This is a paragraph."
        p "Another paragraph."
        ul do
          li "Item 1"
          li "Item 2"
          li "Item 3"
        end
      end
    end
  end
end

puts html
```

## 📝 Advanced Pattern: Validation DSL

```ruby
class Validator
  def initialize
    @rules = []
  end
  
  def validates(field, **options)
    @rules << { field: field, options: options }
  end
  
  def check(object)
    errors = []
    
    @rules.each do |rule|
      field = rule[:field]
      value = object.send(field)
      options = rule[:options]
      
      # Presence check
      if options[:presence]
        if value.nil? || (value.respond_to?(:empty?) && value.empty?)
          errors << "#{field} is required"
        end
      end
      
      # Length check
      if options[:length] && value
        min = options[:length][:min]
        max = options[:length][:max]
        
        if min && value.to_s.length < min
          errors << "#{field} must be at least #{min} characters"
        end
        
        if max && value.to_s.length > max
          errors << "#{field} must be at most #{max} characters"
        end
      end
      
      # Format check
      if options[:format] && value
        unless value.to_s.match?(options[:format])
          errors << "#{field} has invalid format"
        end
      end
      
      # Custom validation
      if options[:validate]
        result = options[:validate].call(value)
        errors << "#{field} #{result}" unless result == true
      end
    end
    
    errors
  end
  
  def self.define(&block)
    validator = new
    validator.instance_eval(&block)
    validator
  end
end

# Define validation rules
user_validator = Validator.define do
  validates :email, 
    presence: true, 
    format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :password, 
    presence: true, 
    length: { min: 8 }
  
  validates :age, 
    validate: ->(val) { val.nil? || (val >= 18 ? true : "must be 18 or older") }
end

# Test with a user object
User = Struct.new(:email, :password, :age)

user1 = User.new("alice@example.com", "secret123", 25)
errors1 = user_validator.check(user1)
puts "User 1 valid!" if errors1.empty?

user2 = User.new("invalid-email", "short", 16)
errors2 = user_validator.check(user2)
puts "User 2 errors:"
errors2.each { |e| puts "  - #{e}" }
```

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/advanced/17-Advanced-Metaprogramming-DSLs/exercises/dsl_practice.rb
```

## 📚 What You Learned

✅ Using `instance_eval` to change execution context
✅ Using `class_eval` to modify class definitions
✅ Capturing context with `Binding`
✅ Safe monkey-patching with `Refinements`
✅ Building production-ready DSLs
✅ Understanding Rails' "magic"
✅ When to use (and avoid) advanced metaprogramming

## 🔜 Next Steps

**Next tutorial: 18-Concurrency-and-Parallelism** - Master Ruby's threading model, Ractors, and Fibers.

## 💡 Key Takeaways for Python Developers

1. **instance_eval**: Changes `self` and scope - no Python equivalent
2. **class_eval**: Modifies classes dynamically - like metaclasses but simpler
3. **Binding**: First-class execution context - cleaner than `locals()`/`globals()`
4. **Refinements**: Scoped monkey-patching - Python has no equivalent
5. **DSLs**: Ruby's syntax makes them natural - Python uses decorators/context managers
6. **Use wisely**: Great for frameworks, but can make code harder to understand

## 🆘 Common Pitfalls

### Pitfall 1: Confusing instance_eval and class_eval

```ruby
# instance_eval on a class defines class methods (singleton methods)
Person.instance_eval do
  def species  # This is a CLASS method
    "Homo sapiens"
  end
end
Person.species  # Works!

# class_eval defines instance methods
Person.class_eval do
  def greet  # This is an INSTANCE method
    "Hello!"
  end
end
Person.new.greet  # Works!
```

### Pitfall 2: Refinement Scope

```ruby
module Extensions
  refine String do
    def shout
      upcase
    end
  end
end

class A
  using Extensions
  def test
    "hello".shout  # Works!
  end
end

class B
  def test
    "hello".shout  # NoMethodError! Refinement not active here
  end
end
```

### Pitfall 3: Overusing Metaprogramming

```ruby
# Bad - Too clever
class Bad
  def self.method_missing(name, *args, &block)
    define_method(name) do
      # Complex logic
    end
  end
end

# Good - Explicit
class Good
  def self.define_accessor(name)
    define_method(name) do
      instance_variable_get("@#{name}")
    end
  end
end
```

## 📖 Additional Resources

- [Ruby Metaprogramming](https://pragprog.com/titles/ppmetr2/metaprogramming-ruby-2/)
- [Refinements Guide](https://docs.ruby-lang.org/en/master/syntax/refinements_rdoc.html)
- [Building DSLs in Ruby](https://www.leighhalliday.com/creating-ruby-dsl)
- [Rails Guides on Metaprogramming](https://guides.rubyonrails.org/)

---

Ready to build your own DSL? Run the exercises and master advanced metaprogramming!
