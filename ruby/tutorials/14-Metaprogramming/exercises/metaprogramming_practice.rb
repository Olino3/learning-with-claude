#!/usr/bin/env ruby
# Metaprogramming Fundamentals Practice Script

puts "=== Metaprogramming Fundamentals Practice ==="
puts

# Section 1: send - Dynamic Method Calls
puts "1. send - Dynamic Method Calls"
puts "-" * 40

class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  private

  def secret_formula
    42
  end
end

calc = Calculator.new

# Normal method call
puts "calc.add(5, 3) = #{calc.add(5, 3)}"

# Dynamic method call
operation = :subtract
puts "calc.send(:#{operation}, 10, 4) = #{calc.send(operation, 10, 4)}"

# send can call private methods!
puts "calc.send(:secret_formula) = #{calc.send(:secret_formula)}"

# public_send only calls public methods
puts "calc.public_send(:add, 2, 2) = #{calc.public_send(:add, 2, 2)}"
puts

# Section 2: Dynamic Dispatch Pattern
puts "2. Dynamic Dispatch Pattern"
puts "-" * 40

class API
  def get_users
    "Fetching users from API..."
  end

  def get_posts
    "Fetching posts from API..."
  end

  def get_comments
    "Fetching comments from API..."
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
puts api.fetch("users")
puts api.fetch("posts")
puts api.fetch("unknown")
puts

# Section 3: define_method - Creating Methods Dynamically
puts "3. define_method - Creating Methods Dynamically"
puts "-" * 40

class DynamicMath
  [:add, :subtract, :multiply, :divide].each do |operation|
    define_method(operation) do |a, b|
      case operation
      when :add
        a + b
      when :subtract
        a - b
      when :multiply
        a * b
      when :divide
        b.zero? ? "Cannot divide by zero" : a / b
      end
    end
  end
end

math = DynamicMath.new
puts "math.add(10, 5) = #{math.add(10, 5)}"
puts "math.subtract(10, 5) = #{math.subtract(10, 5)}"
puts "math.multiply(10, 5) = #{math.multiply(10, 5)}"
puts "math.divide(10, 5) = #{math.divide(10, 5)}"
puts

# Section 4: Building attr_accessor from Scratch
puts "4. Building Custom attr_accessor"
puts "-" * 40

class MyClass
  def self.my_attr_accessor(*attributes)
    attributes.each do |attribute|
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

  my_attr_accessor :name, :age, :email
end

obj = MyClass.new
obj.name = "Alice"
obj.age = 30
obj.email = "alice@example.com"

puts "Name: #{obj.name}"
puts "Age: #{obj.age}"
puts "Email: #{obj.email}"
puts

# Section 5: method_missing - The Magic Method
puts "5. method_missing - The Magic Method"
puts "-" * 40

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
    true
  end

  def to_h
    @data
  end
end

smart = SmartHash.new
smart.name = "Bob"
smart.age = 25
smart.city = "New York"

puts "smart.name = #{smart.name}"
puts "smart.age = #{smart.age}"
puts "smart.city = #{smart.city}"
puts "All data: #{smart.to_h.inspect}"
puts

# Section 6: ActiveRecord-style Dynamic Finders
puts "6. Dynamic Finders (ActiveRecord-style)"
puts "-" * 40

class SimpleDatabase
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
    elsif method_str.start_with?("count_by_")
      attribute = method_str.sub("count_by_", "").to_sym
      @data.count { |record| record[attribute] == args.first }
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_str = method_name.to_s
    method_str.start_with?("find_by_", "find_all_by_", "count_by_") || super
  end
end

users = [
  { id: 1, name: "Alice", role: "admin", age: 30 },
  { id: 2, name: "Bob", role: "user", age: 25 },
  { id: 3, name: "Charlie", role: "user", age: 35 },
  { id: 4, name: "Diana", role: "admin", age: 28 }
]

db = SimpleDatabase.new(users)

puts "find_by_name('Alice'):"
puts "  #{db.find_by_name("Alice").inspect}"

puts "\nfind_all_by_role('user'):"
db.find_all_by_role("user").each do |user|
  puts "  - #{user[:name]} (#{user[:age]})"
end

puts "\ncount_by_role('admin'): #{db.count_by_role('admin')}"
puts

# Section 7: instance_eval - Changing self
puts "7. instance_eval - Changing self"
puts "-" * 40

class Person
  def initialize(name, secret)
    @name = name
    @secret = secret
  end
end

person = Person.new("Alice", "loves chocolate")

puts "Accessing private data with instance_eval:"
person.instance_eval do
  puts "  Name: #{@name}"
  puts "  Secret: #{@secret}"
end

puts "\nAdding method to specific instance:"
person.instance_eval do
  def greet
    "Hi, I'm #{@name}!"
  end
end

puts person.greet

person2 = Person.new("Bob", "secret")
puts "person2 responds to greet? #{person2.respond_to?(:greet)}"
puts

# Section 8: class_eval - Adding Methods to Classes
puts "8. class_eval - Adding Methods to Classes"
puts "-" * 40

class Product
end

# Add methods dynamically
Product.class_eval do
  attr_accessor :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def display
    "#{name}: $#{price}"
  end
end

product = Product.new("Laptop", 999)
puts product.display
puts

# Section 9: Building a Simple DSL
puts "9. Building a Simple DSL"
puts "-" * 40

class RouteMapper
  def initialize
    @routes = []
  end

  def get(path, to:)
    @routes << { method: :get, path: path, handler: to }
  end

  def post(path, to:)
    @routes << { method: :post, path: path, handler: to }
  end

  def delete(path, to:)
    @routes << { method: :delete, path: path, handler: to }
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

routes = RouteMapper.draw do
  get "/", to: "home#index"
  get "/users", to: "users#index"
  get "/users/:id", to: "users#show"
  post "/users", to: "users#create"
  delete "/users/:id", to: "users#destroy"
end

puts "Defined routes:"
routes.each do |route|
  puts "  #{route[:method].to_s.upcase.ljust(6)} #{route[:path].ljust(20)} => #{route[:handler]}"
end
puts

# Section 10: Building ActiveRecord-style Attributes
puts "10. ActiveRecord-style Attribute System"
puts "-" * 40

class Model
  def self.attribute(name, type: :string, default: nil)
    # Getter
    define_method(name) do
      instance_variable_get("@#{name}") || default
    end

    # Setter with type conversion
    define_method("#{name}=") do |value|
      converted_value = case type
      when :string
        value.to_s
      when :integer
        value.to_i
      when :float
        value.to_f
      when :boolean
        !!value
      else
        value
      end
      instance_variable_set("@#{name}", converted_value)
    end
  end
end

class User < Model
  attribute :name, type: :string
  attribute :age, type: :integer
  attribute :score, type: :float
  attribute :active, type: :boolean, default: true
end

user = User.new
user.name = "Alice"
user.age = "30"  # Will be converted to integer
user.score = "95.5"  # Will be converted to float

puts "Name: #{user.name} (#{user.name.class})"
puts "Age: #{user.age} (#{user.age.class})"
puts "Score: #{user.score} (#{user.score.class})"
puts "Active: #{user.active} (#{user.active.class})"
puts

# Section 11: Validation DSL
puts "11. Building a Validation DSL"
puts "-" * 40

class ValidatedModel
  def self.validates(attribute, rules = {})
    @validations ||= []
    @validations << { attribute: attribute, rules: rules }
  end

  def self.validations
    @validations || []
  end

  def valid?
    errors.empty?
  end

  def errors
    @errors ||= []
    @errors.clear

    self.class.validations.each do |validation|
      attr = validation[:attribute]
      value = send(attr)
      rules = validation[:rules]

      if rules[:presence] && (value.nil? || value.to_s.strip.empty?)
        @errors << "#{attr} can't be blank"
      end

      if rules[:length] && rules[:length][:minimum]
        min = rules[:length][:minimum]
        if value.to_s.length < min
          @errors << "#{attr} must be at least #{min} characters"
        end
      end

      if rules[:numericality] && !value.is_a?(Numeric)
        @errors << "#{attr} must be a number"
      end
    end

    @errors
  end
end

class ValidatedUser < ValidatedModel
  attr_accessor :name, :email, :age

  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true
  validates :age, numericality: true
end

user1 = ValidatedUser.new
user1.name = "Al"
user1.email = ""
user1.age = "not a number"

puts "User1 valid? #{user1.valid?}"
puts "Errors:"
user1.errors.each { |error| puts "  - #{error}" }

user2 = ValidatedUser.new
user2.name = "Alice"
user2.email = "alice@example.com"
user2.age = 30

puts "\nUser2 valid? #{user2.valid?}"
puts

# Section 12: Method Delegation
puts "12. Method Delegation Pattern"
puts "-" * 40

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

class Profile
  attr_accessor :email, :bio, :website

  def initialize(email)
    @email = email
  end
end

class DelegatingUser
  extend Delegator

  attr_reader :name

  def initialize(name, email)
    @name = name
    @profile = Profile.new(email)
  end

  delegate :email, :email=, :bio, :bio=, :website, :website=, to: :profile

  attr_reader :profile
end

user = DelegatingUser.new("Alice", "alice@example.com")
user.bio = "Ruby developer"
user.website = "https://alice.dev"

puts "User: #{user.name}"
puts "Email: #{user.email}"
puts "Bio: #{user.bio}"
puts "Website: #{user.website}"
puts

# Section 13: const_missing
puts "13. const_missing - Dynamic Constants"
puts "-" * 40

module DynamicConfig
  def self.const_missing(name)
    const_set(name, "Config value for #{name}")
  end
end

puts "DynamicConfig::DATABASE_URL = #{DynamicConfig::DATABASE_URL}"
puts "DynamicConfig::API_KEY = #{DynamicConfig::API_KEY}"
puts "DynamicConfig::SECRET_TOKEN = #{DynamicConfig::SECRET_TOKEN}"
puts

# Section 14: Memoization with Metaprogramming
puts "14. Memoization with define_method"
puts "-" * 40

module Memoizable
  def memoize(method_name)
    original_method = instance_method(method_name)

    define_method(method_name) do |*args|
      @memoized ||= {}
      cache_key = [method_name, args]

      if @memoized.key?(cache_key)
        puts "  [CACHE HIT] #{method_name}(#{args.join(', ')})"
        @memoized[cache_key]
      else
        puts "  [COMPUTING] #{method_name}(#{args.join(', ')})"
        @memoized[cache_key] = original_method.bind(self).call(*args)
      end
    end
  end
end

class Fibonacci
  extend Memoizable

  def calculate(n)
    return n if n <= 1
    calculate(n - 1) + calculate(n - 2)
  end

  memoize :calculate
end

fib = Fibonacci.new
puts "fib.calculate(10) = #{fib.calculate(10)}"
puts "\nCalling again (should be cached):"
puts "fib.calculate(10) = #{fib.calculate(10)}"
puts

# Section 15: Class Macro Pattern
puts "15. Class Macro Pattern"
puts "-" * 40

module Timestamps
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def timestamps
      define_method(:created_at) do
        @created_at
      end

      define_method(:updated_at) do
        @updated_at
      end

      define_method(:touch) do
        @updated_at = Time.now
      end

      # Add callback to initialize
      original_initialize = instance_method(:initialize)
      define_method(:initialize) do |*args, &block|
        @created_at = Time.now
        @updated_at = Time.now
        original_initialize.bind(self).call(*args, &block) if original_initialize
      end
    end
  end
end

class Post
  include Timestamps
  timestamps

  attr_accessor :title

  def initialize(title)
    @title = title
  end
end

post = Post.new("My First Post")
puts "Post created at: #{post.created_at}"
sleep(0.1)
post.touch
puts "Post updated at: #{post.updated_at}"
puts "Created == Updated? #{post.created_at == post.updated_at}"
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. send: Dynamic method calls (like getattr)"
puts "2. define_method: Create methods at runtime"
puts "3. method_missing: Handle undefined methods (like __getattr__)"
puts "4. instance_eval/class_eval: Execute code in different contexts"
puts "5. DSLs: Ruby's syntax makes DSLs natural"
puts "6. Metaprogramming is idiomatic: Rails heavily uses it"
puts "7. Always implement respond_to_missing? with method_missing"
puts
