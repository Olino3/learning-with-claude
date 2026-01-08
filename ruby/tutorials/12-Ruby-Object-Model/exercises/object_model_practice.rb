#!/usr/bin/env ruby
# Ruby Object Model Deep Dive Practice Script

puts "=== Ruby Object Model Deep Dive ==="
puts

# Section 1: Everything is an Object
puts "1. Everything is an Object"
puts "-" * 40

puts "5.class = #{5.class}"
puts "5.is_a?(Object) = #{5.is_a?(Object)}"
puts "'hello'.class = #{'hello'.class}"
puts "true.class = #{true.class}"
puts "false.class = #{false.class}"
puts "nil.class = #{nil.class}"

puts "\nEven classes are objects:"
puts "String.class = #{String.class}"
puts "Class.class = #{Class.class}"
puts "Class.superclass = #{Class.superclass}"
puts

# Section 2: Understanding Self
puts "2. Understanding Self"
puts "-" * 40

puts "At top level, self = #{self}"
puts "self.class = #{self.class}"

class Dog
  puts "\n  In class definition, self = #{self}"

  def instance_method
    puts "  In instance method, self = #{self.inspect}"
    puts "  self.class = #{self.class}"
  end

  def self.class_method
    puts "  In class method, self = #{self}"
  end
end

puts "\nCalling instance method:"
dog = Dog.new
dog.instance_method

puts "\nCalling class method:"
Dog.class_method
puts

# Section 3: Self in Method Calls
puts "3. Self in Method Calls"
puts "-" * 40

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    self.age = age  # Must use self for setter
  end

  def greet
    # These are equivalent:
    puts "  Hi, I'm #{name}"           # Implicit self
    puts "  Hi, I'm #{self.name}"      # Explicit self
  end

  def birthday
    self.age += 1
    puts "  #{name} is now #{age} years old"
  end
end

alice = Person.new("Alice", 30)
alice.greet
alice.birthday
puts

# Section 4: Inheritance and Method Lookup
puts "4. Inheritance and Method Lookup"
puts "-" * 40

class Animal
  def move
    "walking"
  end

  def speak
    "making sounds"
  end
end

class Dog < Animal
  def speak
    "barking"
  end

  def fetch
    "fetching ball"
  end
end

dog = Dog.new
puts "dog.move = #{dog.move}"     # From Animal
puts "dog.speak = #{dog.speak}"   # Overridden in Dog
puts "dog.fetch = #{dog.fetch}"   # Defined in Dog
puts

# Section 5: Ancestors - The Lookup Chain
puts "5. Ancestors - The Lookup Chain"
puts "-" * 40

puts "Dog.ancestors:"
Dog.ancestors.each { |ancestor| puts "  - #{ancestor}" }

puts "\nString.ancestors:"
String.ancestors.each { |ancestor| puts "  - #{ancestor}" }

puts "\nInteger.ancestors:"
Integer.ancestors.each { |ancestor| puts "  - #{ancestor}" }
puts

# Section 6: Modules in the Lookup Chain
puts "6. Modules in the Lookup Chain"
puts "-" * 40

module Swimmable
  def move
    "swimming"
  end
end

module Flyable
  def move
    "flying"
  end
end

class Bird < Animal
  include Swimmable  # Earlier include
  include Flyable     # Later include (higher priority)

  def chirp
    "chirping"
  end
end

bird = Bird.new
puts "bird.move = #{bird.move}"  # From Flyable (last included)

puts "\nBird.ancestors:"
Bird.ancestors.each { |ancestor| puts "  - #{ancestor}" }
puts

# Section 7: Super - Calling Parent Methods
puts "7. Super - Calling Parent Methods"
puts "-" * 40

class Vehicle
  def start(key)
    "Turning key: #{key}"
  end
end

class Car < Vehicle
  def start(key)
    parent_result = super  # Passes all arguments automatically
    "#{parent_result} -> Engine starting"
  end
end

class ElectricCar < Car
  def start(key)
    parent_result = super
    "#{parent_result} -> Electric motor engaged"
  end
end

car = ElectricCar.new
puts car.start("master-key")
puts

# Section 8: Singleton Classes (Eigenclasses)
puts "8. Singleton Classes"
puts "-" * 40

fido = "Fido"
rex = "Rex"

# Add method to just one instance
def fido.speak
  "#{self} says woof!"
end

puts "fido.speak = #{fido.speak}"
puts "rex responds to speak? #{rex.respond_to?(:speak)}"

puts "\nfido's singleton class: #{fido.singleton_class}"
puts "Methods in fido's singleton: #{fido.singleton_class.instance_methods(false).inspect}"
puts

# Section 9: Class Methods Are Singleton Methods
puts "9. Class Methods Are Singleton Methods"
puts "-" * 40

class Cat
  # Method 1: def self.method_name
  def self.all_breeds
    ["Persian", "Siamese", "Maine Coon"]
  end

  # Method 2: class << self
  class << self
    def species
      "Felis catus"
    end

    def create(name)
      "Created cat: #{name}"
    end
  end
end

puts "Cat.all_breeds = #{Cat.all_breeds.inspect}"
puts "Cat.species = #{Cat.species}"
puts "Cat.create('Whiskers') = #{Cat.create('Whiskers')}"

puts "\nCat's singleton methods:"
Cat.singleton_class.instance_methods(false).each do |method|
  puts "  - #{method}"
end
puts

# Section 10: Singleton Class Per Instance
puts "10. Singleton Class Per Instance"
puts "-" * 40

class Robot
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def greet
    "Hello, I'm #{name}"
  end
end

r2d2 = Robot.new("R2-D2")
c3po = Robot.new("C-3PO")

# Add special method to just r2d2
class << r2d2
  def beep
    "Beep boop! - #{name}"
  end
end

puts r2d2.beep
puts "c3po responds to beep? #{c3po.respond_to?(:beep)}"
puts

# Section 11: Method Visibility
puts "11. Method Visibility"
puts "-" * 40

class BankAccount
  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    if valid_amount?(amount)
      @balance += amount
      "Deposited $#{amount}. Balance: $#{balance}"
    else
      "Invalid amount"
    end
  end

  def show_balance
    "Balance: $#{balance}"
  end

  protected

  def balance
    @balance
  end

  def compare_balance(other)
    if @balance > other.balance
      "This account has more money"
    else
      "Other account has more money"
    end
  end

  private

  def valid_amount?(amount)
    amount > 0
  end
end

account1 = BankAccount.new(1000)
account2 = BankAccount.new(500)

puts account1.deposit(100)
puts account1.show_balance
# puts account1.balance  # Error - protected
# puts account1.valid_amount?(50)  # Error - private
puts

# Section 12: Class Variables vs Instance Variables
puts "12. Class Variables vs Instance Variables"
puts "-" * 40

class Counter
  @@total_count = 0

  def initialize(name)
    @name = name
    @instance_count = 0
    @@total_count += 1
  end

  def increment
    @instance_count += 1
    @@total_count += 1
  end

  def stats
    "#{@name}: instance=#{@instance_count}, total=#{@@total_count}"
  end

  def self.total
    @@total_count
  end
end

c1 = Counter.new("Counter1")
c2 = Counter.new("Counter2")

c1.increment
c1.increment
c2.increment

puts c1.stats
puts c2.stats
puts "Total across all instances: #{Counter.total}"
puts

# Section 13: Class Instance Variables
puts "13. Class Instance Variables"
puts "-" * 40

class Product
  @all_products = []

  class << self
    attr_accessor :all_products

    def add(product)
      @all_products << product
    end

    def count
      @all_products.length
    end
  end

  attr_reader :name

  def initialize(name)
    @name = name
    self.class.add(self)
  end
end

Product.new("Laptop")
Product.new("Phone")
Product.new("Tablet")

puts "Total products: #{Product.count}"
puts "Products: #{Product.all_products.map(&:name).inspect}"
puts

# Section 14: Method Missing
puts "14. Method Missing"
puts "-" * 40

class DynamicGreeter
  def initialize(name)
    @name = name
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?("greet_in_")
      language = method_name.to_s.sub("greet_in_", "")
      greetings = {
        "english" => "Hello",
        "spanish" => "Hola",
        "french" => "Bonjour",
        "japanese" => "Konnichiwa"
      }
      greeting = greetings[language] || "Hello"
      "#{greeting}, #{@name}!"
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("greet_in_") || super
  end
end

greeter = DynamicGreeter.new("Alice")
puts greeter.greet_in_english
puts greeter.greet_in_spanish
puts greeter.greet_in_french
puts greeter.greet_in_japanese
puts "Responds to greet_in_german? #{greeter.respond_to?(:greet_in_german)}"
puts

# Section 15: Dynamic Finder Pattern
puts "15. Dynamic Finder Pattern (like ActiveRecord)"
puts "-" * 40

class SimpleORM
  def initialize(data)
    @data = data
  end

  def method_missing(method_name, *args, &block)
    method_str = method_name.to_s

    if method_str.start_with?("find_by_")
      attribute = method_str.sub("find_by_", "").to_sym
      value = args.first
      @data.find { |item| item[attribute] == value }
    elsif method_str.start_with?("find_all_by_")
      attribute = method_str.sub("find_all_by_", "").to_sym
      value = args.first
      @data.select { |item| item[attribute] == value }
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
  { id: 1, name: "Alice", age: 30, role: "admin" },
  { id: 2, name: "Bob", age: 25, role: "user" },
  { id: 3, name: "Charlie", age: 35, role: "user" }
]

orm = SimpleORM.new(users)

puts "Find by name:"
puts orm.find_by_name("Bob").inspect

puts "\nFind by age:"
puts orm.find_by_age(30).inspect

puts "\nFind all by role:"
puts orm.find_all_by_role("user").inspect
puts

# Section 16: Defining Methods Dynamically
puts "16. Defining Methods Dynamically"
puts "-" * 40

class DynamicClass
  [:add, :subtract, :multiply].each do |operation|
    define_method("#{operation}_numbers") do |a, b|
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
puts "10 + 5 = #{calc.add_numbers(10, 5)}"
puts "10 - 5 = #{calc.subtract_numbers(10, 5)}"
puts "10 * 5 = #{calc.multiply_numbers(10, 5)}"
puts

# Section 17: Inspecting Object Methods
puts "17. Inspecting Object Methods"
puts "-" * 40

class MyClass
  def public_method
    "public"
  end

  protected

  def protected_method
    "protected"
  end

  private

  def private_method
    "private"
  end
end

obj = MyClass.new

puts "Public methods (custom only):"
puts "  #{(obj.public_methods(false)).inspect}"

puts "\nProtected methods:"
puts "  #{(obj.protected_methods(false)).inspect}"

puts "\nPrivate methods:"
puts "  #{(obj.private_methods(false)).inspect}"

puts "\nAll methods (including inherited): #{obj.methods.count} methods"
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. Everything is an object - even classes and primitives"
puts "2. self is implicit but can be used explicitly"
puts "3. Method lookup: instance -> modules -> superclass -> Object -> BasicObject"
puts "4. Class methods live in the singleton class"
puts "5. Use .ancestors to see the full lookup chain"
puts "6. Private methods can't be called with explicit receiver"
puts "7. Class variables (@@) are shared in inheritance - be careful!"
puts "8. method_missing enables powerful metaprogramming (like ActiveRecord)"
puts
