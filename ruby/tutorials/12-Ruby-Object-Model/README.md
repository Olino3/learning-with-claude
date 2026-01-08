# Tutorial 12: Ruby Object Model Deep Dive

Welcome to one of the most important intermediate Ruby topics! Understanding Ruby's object model is key to mastering the language. This tutorial explores how Ruby looks up methods, what `self` refers to, and where "class methods" actually live.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand that everything in Ruby is an object
- Master the concept of `self` in different contexts
- Navigate the inheritance hierarchy and method lookup path
- Understand singleton classes (eigenclasses/metaclasses)
- Know where class methods actually live
- Use `ancestors` to trace inheritance
- Understand the difference between class-level and instance-level code

## 🐍➡️🔴 Coming from Python

Python has classes and objects, but Ruby's object model is more uniform and powerful:

| Concept | Python | Ruby |
|---------|--------|------|
| Everything is object? | Mostly (classes are objects) | Truly everything |
| Class methods | `@classmethod` decorator | Methods on singleton class |
| Instance methods | `def method(self)` | `def method` (self is implicit) |
| `self` equivalent | `self` (explicit first param) | `self` (implicit) |
| Method resolution | MRO (C3 linearization) | Simple ancestor chain |
| Metaclass | `type` and `__metaclass__` | Singleton class |
| Multiple inheritance | Yes (with MRO) | No (use modules/mixins) |

> **📘 Python Note:** Ruby's object model is simpler and more consistent than Python's. Understanding `self` and singleton classes unlocks advanced Ruby patterns.

## 📝 Everything is an Object

In Ruby, EVERYTHING is an object - even classes, methods, and primitives:

```ruby
# Numbers are objects
5.class                    # => Integer
5.methods.count            # => 160+ methods!
5.times { |i| puts i }     # Numbers have methods

# Strings are objects
"hello".class              # => String
"hello".upcase             # Method call on object

# Classes are objects!
String.class               # => Class
Class.class                # => Class
Class.superclass           # => Module

# Even true/false/nil are objects
true.class                 # => TrueClass
false.class                # => FalseClass
nil.class                  # => NilClass
```

> **📘 Python Note:** Python has objects too, but Ruby takes it further. In Python, `5.times()` doesn't exist - integers don't have an iteration method.

## 📝 Understanding Self

`self` refers to the current object context. It changes based on where you are in the code:

### Self in Different Contexts

```ruby
# At top level, self is 'main'
puts self              # => main
puts self.class        # => Object

# In a class definition, self is the class
class Dog
  puts "In class definition: #{self}"  # => Dog

  # Instance methods - self is the instance
  def bark
    puts "Self in instance method: #{self.inspect}"
    puts "Self's class: #{self.class}"
  end

  # Class methods - self is the class
  def self.info
    puts "Self in class method: #{self}"
  end
end

dog = Dog.new
dog.bark        # self is the Dog instance
Dog.info        # self is the Dog class
```

### Self in Method Calls

```ruby
class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name  # Can use @name
    self.age = age  # Must use self. when calling setter
  end

  def greet
    # These are equivalent:
    puts "Hi, I'm #{name}"        # Implicit self
    puts "Hi, I'm #{self.name}"   # Explicit self
  end

  def birthday
    self.age += 1  # Must use self. for setters
    # age += 1  # This would create a local variable!
  end
end
```

> **📘 Python Note:** In Python, `self` is always explicit as the first parameter: `def method(self):`. In Ruby, it's implicit but can be used explicitly for clarity or when calling setters.

## 📝 Inheritance and Method Lookup

Ruby looks for methods in a specific order: the object's class, then included modules, then superclasses.

### The Lookup Chain

```ruby
class Animal
  def move
    "walking"
  end
end

module Swimmable
  def move
    "swimming"
  end
end

class Dog < Animal
  include Swimmable

  def bark
    "woof"
  end
end

dog = Dog.new
puts dog.bark  # Found in Dog
puts dog.move  # Found in Swimmable (before Animal!)

# View the lookup chain
puts Dog.ancestors
# => [Dog, Swimmable, Animal, Object, Kernel, BasicObject]
```

### Ancestors Method

```ruby
class A; end
class B < A; end
class C < B; end

puts C.ancestors.inspect
# => [C, B, A, Object, Kernel, BasicObject]

# Even basic classes have ancestors
puts String.ancestors.inspect
# => [String, Comparable, Object, Kernel, BasicObject]

puts Integer.ancestors.inspect
# => [Integer, Numeric, Comparable, Object, Kernel, BasicObject]
```

> **📘 Python Note:** Similar to Python's MRO (Method Resolution Order), but simpler. Use `Class.ancestors` instead of `Class.__mro__`.

### Super - Calling Parent Methods

```ruby
class Vehicle
  def start
    "Engine starting..."
  end
end

class Car < Vehicle
  def start
    message = super  # Calls parent's start method
    "#{message} Car is ready!"
  end
end

class ElectricCar < Car
  def start
    message = super  # Calls Car's start (which calls Vehicle's)
    "#{message} (Electric mode)"
  end
end

car = ElectricCar.new
puts car.start
# => "Engine starting... Car is ready! (Electric mode)"
```

## 📝 Singleton Classes (Eigenclasses)

Every object in Ruby has a hidden singleton class where its unique methods live. This is where "class methods" actually exist!

### What is a Singleton Class?

```ruby
# Regular instance
dog = "Fido"

# Add a method to just this one instance
def dog.speak
  "#{self} says woof!"
end

puts dog.speak  # => "Fido says woof!"

# Other strings don't have this method
other = "Rex"
# other.speak  # NoMethodError!

# The method lives in dog's singleton class
puts dog.singleton_class  # => #<Class:#<String:0x...>>
```

### Class Methods are Singleton Methods

```ruby
class Dog
  # These are equivalent ways to define class methods:

  # Method 1: def self.method_name
  def self.all_breeds
    ["Labrador", "Poodle", "Beagle"]
  end

  # Method 2: Open the singleton class
  class << self
    def species
      "Canis familiaris"
    end

    def create(name)
      new(name)  # Can call private methods here
    end
  end
end

# Class methods are actually instance methods on the class's singleton class!
puts Dog.singleton_class.instance_methods(false)
# => [:all_breeds, :species, :create]
```

### Opening the Singleton Class

```ruby
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

# Add methods to a specific instance
alice = Person.new("Alice")

class << alice
  def special_greeting
    "I'm special #{name}!"
  end
end

puts alice.special_greeting  # Works!

bob = Person.new("Bob")
# bob.special_greeting  # NoMethodError!
```

### Singleton Class Inheritance

```ruby
class A
  def self.class_method
    "A's class method"
  end
end

class B < A
end

# B inherits A's class methods
puts B.class_method  # => "A's class method"

# This works because B's singleton class inherits from A's singleton class
puts B.singleton_class.superclass  # => #<Class:A>
puts A.singleton_class.superclass  # => #<Class:Object>
```

## 📝 Method Visibility

Ruby has three visibility levels: public, private, and protected.

```ruby
class BankAccount
  def initialize(balance)
    @balance = balance
  end

  # Public method (default)
  def deposit(amount)
    @balance += amount
  end

  # Protected - can be called by instances of the same class
  protected

  def balance
    @balance
  end

  # Private - can only be called without explicit receiver
  private

  def validate_amount(amount)
    amount > 0
  end

  # Private methods can't be called with explicit receiver
  def transfer_to(other_account, amount)
    if validate_amount(amount)  # OK - no receiver
      @balance -= amount
      other_account.receive(amount)  # OK - protected
    end
  end

  protected

  def receive(amount)
    @balance += amount
  end
end

account1 = BankAccount.new(1000)
account2 = BankAccount.new(500)

account1.deposit(100)  # OK - public
# account1.balance  # Error - protected
# account1.validate_amount(50)  # Error - private
```

> **📘 Python Note:** Python uses naming convention (`_private`, `__very_private`) while Ruby has true visibility modifiers.

## 📝 Class Variables vs Instance Variables

```ruby
class Counter
  # Class variable - shared across all instances
  @@total_count = 0

  # Class instance variable - belongs to the class object
  @class_count = 0

  def initialize
    @instance_count = 0  # Instance variable
    @@total_count += 1
  end

  def increment
    @instance_count += 1
    @@total_count += 1
  end

  def instance_count
    @instance_count
  end

  def self.total_count
    @@total_count
  end

  # Class instance variable accessor
  class << self
    attr_accessor :class_count
  end
end

c1 = Counter.new
c2 = Counter.new

c1.increment
c1.increment
c2.increment

puts "c1 count: #{c1.instance_count}"    # => 2
puts "c2 count: #{c2.instance_count}"    # => 1
puts "Total count: #{Counter.total_count}"  # => 5 (2 creates + 3 increments)
```

## 📝 Method Missing and Respond To

```ruby
class DynamicFinder
  def initialize(data)
    @data = data
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?("find_by_")
      attribute = method_name.to_s.sub("find_by_", "")
      @data.find { |item| item[attribute.to_sym] == args.first }
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("find_by_") || super
  end
end

users = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 },
  { name: "Charlie", age: 35 }
]

finder = DynamicFinder.new(users)
puts finder.find_by_name("Bob").inspect     # => {:name=>"Bob", :age=>25}
puts finder.find_by_age(35).inspect         # => {:name=>"Charlie", :age=>35}
puts finder.respond_to?(:find_by_email)     # => true
```

> **📘 Python Note:** Similar to Python's `__getattr__` and `__hasattr__`, but more commonly used in Ruby for DSLs.

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/12-Ruby-Object-Model/exercises/object_model_practice.rb
```

## 📚 What You Learned

✅ Everything in Ruby is an object (including classes)
✅ How `self` changes based on context
✅ Method lookup path and ancestors
✅ Singleton classes and where class methods live
✅ Using `super` to call parent methods
✅ Method visibility (public, protected, private)
✅ Difference between class and instance variables
✅ Method missing for dynamic behavior

## 🔜 Next Steps

**Next tutorial: 13-Advanced-Mixins-Modules** - Learn about include, extend, prepend, and advanced module patterns.

## 💡 Key Takeaways for Python Developers

1. **Everything is an object**: Even classes have methods and can be manipulated
2. **Self is implicit**: You don't need `self` as first parameter, but you can use it
3. **Singleton class**: Where "class methods" actually live (not on the class directly)
4. **Simple lookup**: Ruby's method lookup is simpler than Python's MRO
5. **Visibility**: Ruby has true private/protected, not just naming conventions

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting self in setters
```ruby
class Person
  attr_accessor :age

  def birthday
    age += 1  # Creates local variable!
  end

  def birthday_correct
    self.age += 1  # Calls setter
  end
end
```

### Pitfall 2: Class variables vs class instance variables
```ruby
class A
  @@class_var = "shared"
  @instance_var = "not shared"
end

class B < A
  @@class_var = "B's version"  # CHANGES A's @@class_var too!
end
# Class variables are shared in inheritance - usually use class instance variables
```

### Pitfall 3: Private methods and explicit self
```ruby
class Example
  private

  def helper
    "help"
  end

  def use_helper
    helper        # OK
    # self.helper # Error! Can't use explicit receiver
  end
end
```

## 📖 Additional Resources

- [Understanding Ruby's Object Model](https://www.honeybadger.io/blog/how-ruby-objects-work/)
- [Ruby Singleton Class](https://www.devalot.com/articles/2008/09/ruby-singleton)
- [Method Lookup in Ruby](https://www.rubyguides.com/2019/04/ruby-method-lookup/)

---

Ready to practice? Run the exercises and explore Ruby's object model!
