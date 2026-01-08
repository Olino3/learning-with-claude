# Tutorial 14: Metaprogramming Fundamentals

Welcome to Ruby's most powerful feature: metaprogramming! This is where Ruby truly shines - writing code that writes code. This is how Rails "magically" creates methods and provides its elegant DSL.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use `send` to call methods dynamically
- Create methods at runtime with `define_method`
- Implement `method_missing` for dynamic method handling
- Use `class_eval` and `instance_eval` to change context
- Understand `const_missing` for dynamic constants
- Create DSLs (Domain Specific Languages)
- Master `attr_accessor` and similar metaprogramming patterns
- Understand when and when not to use metaprogramming

## 🐍➡️🔴 Coming from Python

Python has metaprogramming, but Ruby's is more powerful and commonly used:

| Concept | Python | Ruby |
|---------|--------|------|
| Dynamic method call | `getattr(obj, name)()` | `obj.send(:name)` |
| Add method at runtime | `setattr(class, name, fn)` | `define_method` |
| Missing method handler | `__getattr__` | `method_missing` |
| Missing attribute | `__getattribute__` | `method_missing` |
| Eval code | `eval(string)` | `eval`, `instance_eval`, `class_eval` |
| Property decorator | `@property` | `attr_reader`, `attr_accessor` |
| Class decorator | `@decorator` | Modules or class methods |

> **📘 Python Note:** Ruby's metaprogramming is more integrated into the language. Features like `attr_accessor` are metaprogramming built into the core!

## 📝 Send - Dynamic Method Calls

`send` calls a method by name (as a string or symbol):

```ruby
class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  private

  def secret
    "secret method"
  end
end

calc = Calculator.new

# Normal call
puts calc.add(5, 3)  # => 8

# Dynamic call with send
method_name = :add
puts calc.send(method_name, 5, 3)  # => 8

# send can call private methods!
puts calc.send(:secret)  # => "secret method"

# public_send only calls public methods
# calc.public_send(:secret)  # NoMethodError!
```

### Practical Example: Dynamic Dispatch

```ruby
class API
  def get_users
    "Getting users"
  end

  def get_posts
    "Getting posts"
  end

  def get_comments
    "Getting comments"
  end

  def fetch(resource)
    method_name = "get_#{resource}"
    if respond_to?(method_name)
      send(method_name)
    else
      "Unknown resource: #{resource}"
    end
  end
end

api = API.new
puts api.fetch("users")     # => "Getting users"
puts api.fetch("posts")     # => "Getting posts"
puts api.fetch("unknown")   # => "Unknown resource: unknown"
```

> **📘 Python Note:** Like `getattr(obj, method_name)()`, but more commonly used in Ruby. Rails uses this extensively for dynamic routing.

## 📝 Define Method - Creating Methods Dynamically

`define_method` creates methods at runtime:

```ruby
class DynamicClass
  # Create methods dynamically
  [:add, :subtract, :multiply].each do |operation|
    define_method(operation) do |a, b|
      case operation
      when :add
        a + b
      when :subtract
        a - b
      when :multiply
        a * b
      end
    end
  end
end

calc = DynamicClass.new
puts calc.add(10, 5)       # => 15
puts calc.subtract(10, 5)  # => 5
puts calc.multiply(10, 5)  # => 50
```

### Creating Getter/Setter Methods

```ruby
class Person
  # This is how attr_accessor works!
  [:name, :age, :email].each do |attribute|
    # Getter
    define_method(attribute) do
      instance_variable_get("@#{attribute}")
    end

    # Setter
    define_method("#{attribute}=") do |value|
      instance_variable_set("@#{attribute}", value)
    end
  end
end

person = Person.new
person.name = "Alice"
person.age = 30
puts "#{person.name} is #{person.age} years old"
```

> **📘 Python Note:** This is how `@property` works internally in Python, but Ruby makes it a first-class feature with `attr_accessor`.

## 📝 Method Missing - The Magic Method

`method_missing` catches calls to non-existent methods:

```ruby
class SmartHash
  def initialize
    @data = {}
  end

  def method_missing(method_name, *args)
    method_str = method_name.to_s

    if method_str.end_with?("=")
      # Setter: name= becomes @data[:name] = value
      key = method_str.chop.to_sym
      @data[key] = args.first
    else
      # Getter: name becomes @data[:name]
      @data[method_name]
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true  # We respond to everything!
  end
end

obj = SmartHash.new
obj.name = "Alice"
obj.age = 30
obj.email = "alice@example.com"

puts obj.name   # => "Alice"
puts obj.age    # => 30
puts obj.email  # => "alice@example.com"
```

### ActiveRecord-style Dynamic Finders

```ruby
class Database
  def initialize(data)
    @data = data
  end

  def method_missing(method_name, *args)
    method_str = method_name.to_s

    if method_str.start_with?("find_by_")
      attribute = method_str.sub("find_by_", "").to_sym
      @data.find { |record| record[attribute] == args.first }
    elsif method_str.start_with?("find_all_by_")
      attribute = method_str.sub("find_all_by_", "").to_sym
      @data.select { |record| record[attribute] == args.first }
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_str = method_name.to_s
    method_str.start_with?("find_by_", "find_all_by_") || super
  end
end

users = [
  { id: 1, name: "Alice", role: "admin" },
  { id: 2, name: "Bob", role: "user" },
  { id: 3, name: "Charlie", role: "user" }
]

db = Database.new(users)
puts db.find_by_name("Alice").inspect
puts db.find_all_by_role("user").inspect
```

> **📘 Python Note:** Like `__getattr__` in Python, but more commonly used. This is how ActiveRecord creates `find_by_name`, `find_by_email`, etc.

## 📝 Class Eval and Instance Eval

`class_eval` and `instance_eval` execute code in different contexts:

### instance_eval - Change self

```ruby
class Person
  def initialize(name)
    @name = name
    @secret = "secret value"
  end
end

person = Person.new("Alice")

# Access private instance variables
person.instance_eval do
  puts @name    # => "Alice"
  puts @secret  # => "secret value"
end

# Add methods to a specific instance
person.instance_eval do
  def greet
    "Hello, I'm #{@name}"
  end
end

puts person.greet  # => "Hello, I'm Alice"
```

### class_eval - Change class context

```ruby
class Person
end

# Add methods to the class
Person.class_eval do
  attr_accessor :name, :age

  def greet
    "Hello, I'm #{name}"
  end
end

person = Person.new
person.name = "Bob"
puts person.greet  # => "Hello, I'm Bob"
```

## 📝 Const Missing - Dynamic Constants

```ruby
module DynamicConstants
  def self.const_missing(name)
    const_set(name, "Dynamic constant: #{name}")
  end
end

puts DynamicConstants::UNDEFINED  # => "Dynamic constant: UNDEFINED"
puts DynamicConstants::ANYTHING   # => "Dynamic constant: ANYTHING"
```

## 📝 Creating a DSL

DSLs (Domain Specific Languages) use metaprogramming for clean syntax:

```ruby
class RouteMapper
  def initialize
    @routes = []
  end

  def get(path, to:)
    @routes << { method: :get, path: path, controller: to }
  end

  def post(path, to:)
    @routes << { method: :post, path: path, controller: to }
  end

  def routes
    @routes
  end

  def self.draw(&block)
    mapper = new
    mapper.instance_eval(&block)
    mapper.routes
  end
end

# DSL usage (looks like Rails routes!)
routes = RouteMapper.draw do
  get "/users", to: "users#index"
  get "/users/:id", to: "users#show"
  post "/users", to: "users#create"
end

puts "Defined routes:"
routes.each do |route|
  puts "  #{route[:method].upcase} #{route[:path]} => #{route[:controller]}"
end
```

## 📝 Building ActiveRecord-style Class Methods

```ruby
class Model
  def self.attribute(name, type: :string)
    # Create instance variable
    define_method(name) do
      instance_variable_get("@#{name}")
    end

    # Create setter with type conversion
    define_method("#{name}=") do |value|
      converted_value = case type
      when :string
        value.to_s
      when :integer
        value.to_i
      when :boolean
        !!value
      else
        value
      end
      instance_variable_set("@#{name}", converted_value)
    end
  end

  def self.validates(attribute, presence: false, length: nil)
    @validations ||= []
    @validations << { attribute: attribute, presence: presence, length: length }
  end

  def self.validations
    @validations || []
  end

  def valid?
    self.class.validations.all? do |validation|
      value = send(validation[:attribute])

      if validation[:presence]
        return false if value.nil? || value.to_s.empty?
      end

      if validation[:length]
        return false if value.to_s.length < validation[:length][:minimum]
      end

      true
    end
  end
end

class User < Model
  attribute :name, type: :string
  attribute :age, type: :integer
  attribute :active, type: :boolean

  validates :name, presence: true, length: { minimum: 3 }
  validates :age, presence: true
end

user = User.new
user.name = "Al"
user.age = 30

puts "Valid? #{user.valid?}"  # => false (name too short)

user.name = "Alice"
puts "Valid? #{user.valid?}"  # => true
```

## 📝 Practical Patterns

### 1. Memoization with define_method

```ruby
module Memoizable
  def memoize(method_name)
    original_method = instance_method(method_name)
    define_method(method_name) do |*args|
      @memoized ||= {}
      cache_key = [method_name, args]
      @memoized[cache_key] ||= original_method.bind(self).call(*args)
    end
  end
end

class Expensive
  extend Memoizable

  def calculate(n)
    puts "Computing for #{n}..."
    sleep(0.5)
    n ** 2
  end

  memoize :calculate
end

exp = Expensive.new
puts exp.calculate(5)  # Computes
puts exp.calculate(5)  # Cached!
puts exp.calculate(10) # Computes
```

### 2. Method Delegation

```ruby
module Delegator
  def delegate(*methods, to:)
    methods.each do |method_name|
      define_method(method_name) do |*args, &block|
        target = instance_variable_get("@#{to}")
        target.send(method_name, *args, &block)
      end
    end
  end
end

class User
  extend Delegator

  def initialize(name, email)
    @name = name
    @profile = Profile.new(email)
  end

  delegate :email, :email=, :bio, :bio=, to: :profile

  attr_reader :name, :profile
end

class Profile
  attr_accessor :email, :bio

  def initialize(email)
    @email = email
  end
end

user = User.new("Alice", "alice@example.com")
puts user.email  # Delegates to @profile.email
user.bio = "Ruby developer"
puts user.bio    # Delegates to @profile.bio
```

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/14-Metaprogramming/exercises/metaprogramming_practice.rb
```

## 📚 What You Learned

✅ Using `send` for dynamic method calls
✅ Creating methods with `define_method`
✅ Implementing `method_missing` for dynamic behavior
✅ Using `class_eval` and `instance_eval`
✅ Building DSLs with metaprogramming
✅ Understanding how `attr_accessor` works
✅ Creating ActiveRecord-style class methods
✅ When to use (and avoid) metaprogramming

## 🔜 Next Steps

**Next tutorial: 15-Advanced-Error-Handling** - Learn about structured exception handling, custom exceptions, and error recovery patterns.

## 💡 Key Takeaways for Python Developers

1. **send**: Like `getattr` but more powerful and commonly used
2. **define_method**: Dynamic method creation (like `setattr` with functions)
3. **method_missing**: Ruby's `__getattr__` - but central to the language
4. **Metaprogramming is idiomatic**: Rails and other frameworks rely on it
5. **DSLs are common**: Ruby's syntax makes DSLs natural and readable

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting respond_to_missing?
```ruby
class Bad
  def method_missing(method_name, *args)
    "handled"
  end
  # Missing respond_to_missing?
end

obj = Bad.new
obj.anything  # Works
obj.respond_to?(:anything)  # false - WRONG!

# Always implement both:
def respond_to_missing?(method_name, include_private = false)
  true || super
end
```

### Pitfall 2: Overusing metaprogramming
```ruby
# Bad - too clever
class Bad
  def method_missing(name, *args)
    @data ||= {}
    @data[name] = args.first
  end
end

# Good - explicit and clear
class Good
  attr_accessor :name, :email, :age
end
```

### Pitfall 3: send vs public_send
```ruby
# send can call private methods - dangerous!
obj.send(:private_method)  # Works

# Use public_send for safety
obj.public_send(:private_method)  # NoMethodError
```

## 📖 Additional Resources

- [Metaprogramming Ruby](https://pragprog.com/titles/ppmetr2/metaprogramming-ruby-2/)
- [Ruby Metaprogramming](https://www.rubyguides.com/2016/04/metaprogramming-in-the-wild/)
- [Method Missing Deep Dive](https://www.honeybadger.io/blog/ruby-method-missing/)

---

Ready to write code that writes code? Run the exercises and master metaprogramming!
