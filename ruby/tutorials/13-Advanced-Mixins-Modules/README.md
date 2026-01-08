# Tutorial 13: Advanced Mixins and Modules

Welcome to advanced module patterns! Ruby uses modules instead of multiple inheritance to share behavior across classes. This tutorial explores the powerful patterns you can create with `include`, `extend`, and `prepend`.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master include, extend, and prepend
- Understand when to use each module composition method
- Use module callbacks (included, extended, prepended)
- Create concern-style modules (like Rails)
- Understand module method lookup order
- Build mixins that add both instance and class methods
- Use modules for namespacing and organization

## 🐍➡️🔴 Coming from Python

Python uses multiple inheritance, while Ruby uses modules for composition:

| Concept | Python | Ruby |
|---------|--------|------|
| Multiple inheritance | `class C(A, B)` | Use modules with `include` |
| Mixins | Multiple inheritance | Modules with `include` |
| Adding class methods | Metaclass or decorator | `extend` module |
| Method override | Override in child class | `prepend` module |
| Namespace | Packages/modules | Modules with `::` |
| Abstract methods | `abc.abstractmethod` | Raise NotImplementedError |

> **📘 Python Note:** Ruby's module system is cleaner than multiple inheritance. No diamond problem, no complex MRO - just a simple ancestor chain.

## 📝 Include: Adding Instance Methods

`include` adds a module's methods as instance methods to a class:

```ruby
module Swimmable
  def swim
    "#{name} is swimming"
  end
end

class Duck
  include Swimmable

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

duck = Duck.new("Donald")
puts duck.swim  # => "Donald is swimming"

# Module is in the ancestors chain
puts Duck.ancestors
# => [Duck, Swimmable, Object, Kernel, BasicObject]
```

### Multiple Includes

```ruby
module Walkable
  def walk
    "#{name} is walking"
  end
end

module Talkable
  def talk
    "#{name} is talking"
  end
end

class Person
  include Walkable
  include Talkable

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

person = Person.new("Alice")
puts person.walk  # => "Alice is walking"
puts person.talk  # => "Alice is talking"

# Later includes have higher priority
puts Person.ancestors
# => [Person, Talkable, Walkable, Object, Kernel, BasicObject]
```

> **📘 Python Note:** Like Python's multiple inheritance `class Person(Walkable, Talkable)`, but the lookup is simpler - just follow the ancestors chain.

## 📝 Extend: Adding Class Methods

`extend` adds a module's methods as class methods (singleton methods):

```ruby
module Findable
  def find_by_name(name)
    "Finding #{name}..."
  end

  def all
    "Getting all records..."
  end
end

class User
  extend Findable
end

# Methods are available on the class
puts User.find_by_name("Alice")  # => "Finding Alice..."
puts User.all                     # => "Getting all records..."

# Not available on instances
user = User.new
# user.find_by_name("Bob")  # NoMethodError!
```

### Extend on Instances

You can also extend individual instances:

```ruby
module Special
  def special_ability
    "I'm special!"
  end
end

object1 = "Regular string"
object2 = "Special string"

object2.extend(Special)

puts object2.special_ability  # => "I'm special!"
# puts object1.special_ability  # NoMethodError!
```

## 📝 Prepend: Method Override

`prepend` inserts the module BEFORE the class in the lookup chain:

```ruby
module Logging
  def save
    puts "Logging: About to save"
    result = super  # Calls the original method
    puts "Logging: Save completed"
    result
  end
end

class Document
  prepend Logging

  def save
    puts "Saving document..."
    true
  end
end

doc = Document.new
doc.save

# Output:
# Logging: About to save
# Saving document...
# Logging: Save completed

# Logging comes BEFORE Document in ancestors
puts Document.ancestors
# => [Logging, Document, Object, Kernel, BasicObject]
```

> **📘 Python Note:** This is like using decorators or `super()` in Python, but built into the language. Perfect for aspect-oriented programming.

## 📝 Include vs Extend vs Prepend

| Method | Effect | Use Case | Position in Ancestors |
|--------|--------|----------|----------------------|
| `include` | Adds instance methods | Share behavior across classes | After class |
| `extend` | Adds class methods | Add class-level functionality | Singleton class |
| `prepend` | Overrides methods | Wrap/decorate methods | Before class |

```ruby
module Example
  def greet
    "Hello from module"
  end
end

class WithInclude
  include Example
end

class WithPrepend
  prepend Example

  def greet
    "Hello from class"
  end
end

puts WithInclude.new.greet  # => "Hello from module"
puts WithPrepend.new.greet  # => "Hello from module" (prepend wins!)
```

## 📝 Module Hooks

Modules can hook into the inclusion process:

```ruby
module Trackable
  def self.included(base)
    puts "#{self} included in #{base}"
    base.extend(ClassMethods)
  end

  def self.extended(base)
    puts "#{self} extended #{base}"
  end

  def self.prepended(base)
    puts "#{self} prepended to #{base}"
  end

  # Instance methods
  def track
    "Tracking instance"
  end

  # Class methods to add
  module ClassMethods
    def track_all
      "Tracking all instances"
    end
  end
end

class Model
  include Trackable
end
# Output: "Trackable included in Model"

model = Model.new
puts model.track         # => "Tracking instance"
puts Model.track_all     # => "Tracking all instances"
```

> **📘 Python Note:** Similar to Python's `__init_subclass__`, but more flexible. This pattern is used extensively in Rails.

## 📝 The Concern Pattern (Rails-style)

Creating modules that add both instance and class methods:

```ruby
module Commentable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      attr_accessor :comments
    end
  end

  # Instance methods
  def add_comment(comment)
    @comments ||= []
    @comments << comment
  end

  def comment_count
    @comments&.length || 0
  end

  # Class methods
  module ClassMethods
    def total_comments
      "Counting all comments..."
    end

    def most_commented
      "Finding most commented..."
    end
  end
end

class BlogPost
  include Commentable
end

class Video
  include Commentable
end

# Instance methods
post = BlogPost.new
post.add_comment("Great post!")
post.add_comment("Thanks!")
puts "Comments: #{post.comment_count}"

# Class methods
puts BlogPost.total_comments
puts Video.most_commented
```

## 📝 Module Composition Patterns

### 1. Chainable Modules

```ruby
module Validatable
  def valid?
    @errors.nil? || @errors.empty?
  end

  def errors
    @errors ||= []
  end
end

module Persistable
  def save
    return false unless valid?
    puts "Saving #{self.class}..."
    true
  end
end

class Record
  include Validatable
  include Persistable

  def validate
    errors << "Invalid" unless name
    self
  end

  attr_accessor :name
end

record = Record.new
record.name = "Test"
record.validate.save
```

### 2. Dependency Injection via Modules

```ruby
module DatabaseConnection
  def connection
    @connection ||= "Connected to database"
  end
end

module Queryable
  def self.included(base)
    base.include(DatabaseConnection)
  end

  def query(sql)
    "#{connection}: Executing '#{sql}'"
  end
end

class User
  include Queryable
end

user = User.new
puts user.query("SELECT * FROM users")
```

### 3. Namespacing

```ruby
module API
  module V1
    class User
      def self.endpoint
        "/api/v1/users"
      end
    end
  end

  module V2
    class User
      def self.endpoint
        "/api/v2/users"
      end
    end
  end
end

puts API::V1::User.endpoint  # => "/api/v1/users"
puts API::V2::User.endpoint  # => "/api/v2/users"
```

> **📘 Python Note:** Like Python's package structure, but using modules. `::` is like Python's `.` for accessing nested items.

## 📝 Advanced Patterns

### Abstract Methods in Modules

```ruby
module Searchable
  def search(query)
    raise NotImplementedError, "#{self.class} must implement #search"
  end

  def search_all
    search("*")  # Calls the abstract method
  end
end

class Database
  include Searchable

  def search(query)
    "Searching database for: #{query}"
  end
end

class FileSystem
  include Searchable
  # Doesn't implement search - will raise error when called
end

db = Database.new
puts db.search_all  # Works

fs = FileSystem.new
# fs.search_all  # Raises NotImplementedError!
```

### Template Method Pattern

```ruby
module Workflow
  def execute
    before_execute
    perform
    after_execute
  end

  def before_execute
    puts "Starting workflow..."
  end

  def perform
    raise NotImplementedError, "Subclass must implement #perform"
  end

  def after_execute
    puts "Workflow complete!"
  end
end

class EmailWorkflow
  include Workflow

  def perform
    puts "Sending email..."
  end
end

class ReportWorkflow
  include Workflow

  def perform
    puts "Generating report..."
  end

  def after_execute
    super
    puts "Report saved to disk"
  end
end

EmailWorkflow.new.execute
puts
ReportWorkflow.new.execute
```

### Module with State

```ruby
module Configurable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def config
      @config ||= {}
    end

    def configure
      yield config
    end
  end

  def config
    self.class.config
  end
end

class Application
  include Configurable
end

Application.configure do |config|
  config[:name] = "MyApp"
  config[:version] = "1.0"
  config[:debug] = true
end

app = Application.new
puts app.config[:name]     # => "MyApp"
puts app.config[:version]  # => "1.0"
```

## 📝 Method Lookup with Multiple Modules

```ruby
module A
  def greet
    "A"
  end
end

module B
  def greet
    "B"
  end
end

module C
  def greet
    "C"
  end
end

class Demo
  prepend A    # Highest priority
  include B    # Medium priority
  include C    # Lowest priority (but before class)

  def greet
    "Demo"
  end
end

puts Demo.new.greet  # => "A" (prepend wins)

puts Demo.ancestors
# => [A, Demo, C, B, Object, Kernel, BasicObject]
# Note: Last include (C) comes before earlier include (B)
```

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/13-Advanced-Mixins-Modules/exercises/mixins_practice.rb
```

## 📚 What You Learned

✅ Difference between include, extend, and prepend
✅ Module hooks (included, extended, prepended)
✅ Creating modules that add both instance and class methods
✅ Concern pattern (Rails-style)
✅ Method lookup order with modules
✅ Namespacing with modules
✅ Template method pattern
✅ Abstract methods in Ruby

## 🔜 Next Steps

**Next tutorial: 14-Metaprogramming-Fundamentals** - Learn about `send`, `define_method`, `method_missing`, and other metaprogramming techniques.

## 💡 Key Takeaways for Python Developers

1. **Modules > Multiple inheritance**: Cleaner than Python's MRO
2. **include**: Like multiple inheritance for instance methods
3. **extend**: Adds class methods (like metaclass programming)
4. **prepend**: Like decorators but built into the language
5. **Hooks**: `included`, `extended`, `prepended` for metaprogramming
6. **Concerns**: Pattern for mixing instance + class methods

## 🆘 Common Pitfalls

### Pitfall 1: Include order matters
```ruby
# Later includes have higher priority!
class Demo
  include A  # Lower priority
  include B  # Higher priority
end
# B's methods override A's methods
```

### Pitfall 2: Prepend overrides class methods
```ruby
module Logger
  def save
    puts "Logging"
    super  # Must call super to get class method!
  end
end

class Model
  prepend Logger
  def save
    puts "Saving"
  end
end
# Without super, the class's save would never run!
```

### Pitfall 3: Module state is shared
```ruby
module Counter
  @count = 0  # This belongs to the module, not the class!

  def self.increment
    @count += 1
  end
end
# Use class_eval or included hook to set class-specific state
```

## 📖 Additional Resources

- [Ruby Modules: Include vs Prepend vs Extend](https://www.geeksforgeeks.org/ruby-modules-mixins/)
- [Rails Concerns Explained](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
- [Ruby Module Documentation](https://ruby-doc.org/core-3.4.0/Module.html)

---

Ready to practice? Run the exercises and master Ruby's module system!
