#!/usr/bin/env ruby
# Idiomatic Ruby Patterns Practice Script

puts "=== Idiomatic Ruby Patterns Practice ==="
puts

# Section 1: Map - Transform Collections
puts "1. Map - Transform Collections"
puts "-" * 40

numbers = [1, 2, 3, 4, 5]
doubled = numbers.map { |n| n * 2 }
puts "Doubled: #{doubled.inspect}"

names = ["alice", "bob", "charlie"]
capitalized = names.map(&:capitalize)
puts "Capitalized: #{capitalized.inspect}"

uppercased = names.map(&:upcase)
puts "Uppercased: #{uppercased.inspect}"
puts

# Section 2: Select and Reject
puts "2. Select and Reject"
puts "-" * 40

numbers = (1..10).to_a
evens = numbers.select(&:even?)
puts "Evens: #{evens.inspect}"

odds = numbers.reject(&:even?)
puts "Odds: #{odds.inspect}"

words = ["apple", "banana", "", "cherry", ""]
non_empty = words.reject(&:empty?)
puts "Non-empty words: #{non_empty.inspect}"
puts

# Section 3: Reduce/Inject
puts "3. Reduce/Inject - Aggregate Values"
puts "-" * 40

numbers = [1, 2, 3, 4, 5]

sum = numbers.reduce(0) { |acc, n| acc + n }
puts "Sum (verbose): #{sum}"

sum = numbers.reduce(:+)
puts "Sum (shorthand): #{sum}"

product = numbers.reduce(:*)
puts "Product: #{product}"

# Build a hash
words = ["apple", "banana", "cherry"]
length_map = words.reduce({}) do |hash, word|
  hash[word] = word.length
  hash
end
puts "Length map: #{length_map.inspect}"
puts

# Section 4: each_with_object
puts "4. each_with_object"
puts "-" * 40

words = ["apple", "banana", "cherry"]
length_map = words.each_with_object({}) do |word, hash|
  hash[word] = word.length
end
puts "Length map: #{length_map.inspect}"

numbers = [1, 2, 3, 4, 5, 6]
grouped = numbers.each_with_object({ even: [], odd: [] }) do |n, groups|
  groups[n.even? ? :even : :odd] << n
end
puts "Grouped: #{grouped.inspect}"
puts

# Section 5: Chaining Enumerable Methods
puts "5. Chaining Enumerable Methods"
puts "-" * 40

users = [
  { name: "Alice", age: 30, active: true },
  { name: "Bob", age: 25, active: false },
  { name: "Charlie", age: 35, active: true },
  { name: "Diana", age: 28, active: true }
]

active_names = users
  .select { |u| u[:active] }
  .map { |u| u[:name] }
  .sort

puts "Active users (sorted): #{active_names.inspect}"

# Complex chain
adult_names = users
  .select { |u| u[:age] >= 30 }
  .select { |u| u[:active] }
  .map { |u| u[:name].upcase }

puts "Active adults (uppercase): #{adult_names.inspect}"
puts

# Section 6: Duck Typing
puts "6. Duck Typing"
puts "-" * 40

class MyCollection
  def each
    yield 1
    yield 2
    yield 3
  end

  def map(&block)
    results = []
    each { |item| results << block.call(item) }
    results
  end
end

def process(collection)
  if collection.respond_to?(:each)
    puts "  Processing collection:"
    collection.each { |item| puts "    - #{item}" }
  else
    puts "  Not a collection"
  end
end

process([1, 2, 3])
process(1..3)
process(MyCollection.new)
puts

# Section 7: Memoization
puts "7. Memoization"
puts "-" * 40

class Report
  def expensive_calculation
    @expensive_calculation ||= begin
      puts "  Computing expensive calculation..."
      sleep(0.3)
      42
    end
  end

  def another_expensive(n)
    @cache ||= {}
    @cache[n] ||= begin
      puts "  Computing for #{n}..."
      sleep(0.2)
      n * n
    end
  end
end

report = Report.new
puts "First call: #{report.expensive_calculation}"
puts "Second call: #{report.expensive_calculation}"
puts "Third call: #{report.expensive_calculation}"

puts "\nWith parameters:"
puts report.another_expensive(5)
puts report.another_expensive(5)  # Cached
puts report.another_expensive(10)
puts

# Section 8: Safe Navigation Operator
puts "8. Safe Navigation Operator (&.)"
puts "-" * 40

user1 = { name: "Alice", profile: { email: "alice@example.com" } }
user2 = nil

# Safe navigation
email1 = user1&.[](:profile)&.[](:email)
puts "User1 email: #{email1}"

email2 = user2&.[](:profile)&.[](:email)
puts "User2 email: #{email2.inspect}"

# With method calls
class Person
  attr_accessor :name, :address

  def initialize(name)
    @name = name
  end
end

class Address
  attr_accessor :city

  def initialize(city)
    @city = city
  end
end

person1 = Person.new("Alice")
person1.address = Address.new("New York")

person2 = Person.new("Bob")

puts "\nPerson1 city: #{person1&.address&.city}"
puts "Person2 city: #{person2&.address&.city.inspect}"
puts

# Section 9: Tap - Side Effects in Chains
puts "9. Tap - Side Effects in Chains"
puts "-" * 40

class User
  attr_accessor :name, :age, :email

  def initialize(name)
    @name = name
  end
end

user = User.new("Alice").tap do |u|
  u.age = 30
  u.email = "alice@example.com"
end

puts "User: #{user.name}, #{user.age}, #{user.email}"

# Debugging chains
result = [1, 2, 3, 4, 5, 6]
  .tap { |a| puts "  Original: #{a.inspect}" }
  .select(&:even?)
  .tap { |a| puts "  After select: #{a.inspect}" }
  .map { |n| n * 2 }
  .tap { |a| puts "  After map: #{a.inspect}" }
puts

# Section 10: Then (yield_self)
puts "10. Then - Transform in Chains"
puts "-" * 40

result = "  hello world  "
  .then { |s| s.strip }
  .then { |s| s.upcase }
  .then { |s| s.split }
  .then { |arr| arr.join("-") }

puts "Result: #{result}"

# Useful for complex transformations
price = 100
final_price = price
  .then { |p| p * 0.9 }  # 10% discount
  .then { |p| p * 1.2 }  # 20% tax
  .then { |p| p.round(2) }

puts "Final price: $#{final_price}"
puts

# Section 11: Single Splat (*)
puts "11. Single Splat (*) - Arrays"
puts "-" * 40

def greet(greeting, *names)
  names.each { |name| puts "  #{greeting}, #{name}!" }
end

greet("Hello", "Alice", "Bob", "Charlie")

# Destructuring
first, *middle, last = [1, 2, 3, 4, 5]
puts "\nFirst: #{first}"
puts "Middle: #{middle.inspect}"
puts "Last: #{last}"

# Spreading
arr1 = [1, 2, 3]
arr2 = [4, 5, 6]
combined = [0, *arr1, *arr2, 7]
puts "Combined: #{combined.inspect}"
puts

# Section 12: Double Splat (**) - Hashes
puts "12. Double Splat (**) - Hashes"
puts "-" * 40

def create_user(name:, email:, **options)
  puts "  Name: #{name}"
  puts "  Email: #{email}"
  puts "  Options: #{options.inspect}"
end

create_user(
  name: "Alice",
  email: "alice@example.com",
  age: 30,
  role: :admin,
  active: true
)

# Merging hashes
defaults = { color: "blue", size: "medium", weight: "light" }
custom = { color: "red", weight: "heavy" }
merged = { **defaults, **custom }
puts "\nMerged config: #{merged.inspect}"
puts

# Section 13: PORO Pattern
puts "13. PORO - Plain Old Ruby Objects"
puts "-" * 40

class Item
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end

class Invoice
  attr_reader :items, :customer

  def initialize(customer)
    @customer = customer
    @items = []
  end

  def add_item(item)
    @items << item
    self  # Return self for chaining
  end

  def total
    items.map(&:price).sum
  end

  def summary
    "Invoice for #{customer}: #{items.size} items, Total: $#{total}"
  end
end

invoice = Invoice.new("Alice")
  .add_item(Item.new("Book", 15))
  .add_item(Item.new("Pen", 2))
  .add_item(Item.new("Notebook", 8))

puts invoice.summary
puts

# Section 14: Declarative vs Imperative
puts "14. Declarative vs Imperative"
puts "-" * 40

users = [
  { name: "Alice", age: 30, active: true },
  { name: "Bob", age: 17, active: false },
  { name: "Charlie", age: 35, active: true },
  { name: "Diana", age: 16, active: true }
]

# Imperative (how)
puts "Imperative approach:"
valid_users_imperative = []
users.each do |user|
  if user[:age] >= 18 && user[:active]
    valid_users_imperative << user[:name].upcase
  end
end
puts "  #{valid_users_imperative.inspect}"

# Declarative (what)
puts "\nDeclarative approach:"
valid_users_declarative = users
  .select { |u| u[:age] >= 18 && u[:active] }
  .map { |u| u[:name].upcase }
puts "  #{valid_users_declarative.inspect}"
puts

# Section 15: Common Idioms - Default Values
puts "15. Common Idioms - Default Values"
puts "-" * 40

# ||= for defaults
config = {}
config[:timeout] ||= 30
config[:retries] ||= 3
config[:timeout] ||= 60  # Won't override
puts "Config: #{config.inspect}"

# Hash default
options = { name: "Alice" }
timeout = options[:timeout] || 30
retries = options[:retries] || 3
puts "Timeout: #{timeout}, Retries: #{retries}"
puts

# Section 16: Guard Clauses
puts "16. Guard Clauses"
puts "-" * 40

class UserProcessor
  def process(user)
    return "User is nil" unless user
    return "User is inactive" unless user[:active]
    return "User is banned" if user[:banned]

    "Processing #{user[:name]}"
  end
end

processor = UserProcessor.new
puts processor.process(nil)
puts processor.process({ name: "Alice", active: false })
puts processor.process({ name: "Bob", active: true, banned: true })
puts processor.process({ name: "Charlie", active: true })
puts

# Section 17: Symbol to Proc Magic
puts "17. Symbol to Proc Magic (&:method)"
puts "-" * 40

numbers = [1, 2, 3, 4, 5]
puts "Even numbers: #{numbers.select(&:even?).inspect}"
puts "Odd numbers: #{numbers.select(&:odd?).inspect}"

words = ["hello", "world", "ruby"]
puts "Uppercased: #{words.map(&:upcase).inspect}"
puts "Lengths: #{words.map(&:length).inspect}"
puts "Capitalized: #{words.map(&:capitalize).inspect}"

# Multiple applications
users = [
  { name: "alice" },
  { name: "bob" },
  { name: "charlie" }
]
names = users.map { |u| u[:name] }.map(&:capitalize)
puts "User names: #{names.inspect}"
puts

# Section 18: Complex Chaining Example
puts "18. Complex Chaining Example"
puts "-" * 40

orders = [
  { id: 1, items: [{ price: 10 }, { price: 20 }], customer: "Alice" },
  { id: 2, items: [{ price: 5 }], customer: "Bob" },
  { id: 3, items: [{ price: 30 }, { price: 15 }, { price: 25 }], customer: "Alice" }
]

# Calculate total for each customer
customer_totals = orders
  .group_by { |order| order[:customer] }
  .transform_values { |customer_orders|
    customer_orders
      .flat_map { |order| order[:items] }
      .map { |item| item[:price] }
      .sum
  }

puts "Customer totals:"
customer_totals.each do |customer, total|
  puts "  #{customer}: $#{total}"
end
puts

# Section 19: Conditional Assignment
puts "19. Conditional Assignment"
puts "-" * 40

user = { name: "Alice", verified: true }

# Assign only if condition is true
status = :active if user[:verified]
puts "Status: #{status}"

# Short circuit
result = user && user[:name]
puts "Result: #{result}"

# Multiple conditions
expensive_result = user[:verified] && user[:name] && "PROCESSED: #{user[:name]}"
puts "Expensive result: #{expensive_result}"
puts

# Section 20: Practical Example - Data Pipeline
puts "20. Practical Data Pipeline Example"
puts "-" * 40

raw_data = [
  "  Alice,30,alice@example.com  ",
  "Bob,25,bob@example.com",
  "  Charlie,35,charlie@example.com  ",
  "",
  "Diana,28,diana@example.com"
]

processed = raw_data
  .reject(&:empty?)
  .map(&:strip)
  .map { |line| line.split(",") }
  .map { |parts| { name: parts[0], age: parts[1].to_i, email: parts[2] } }
  .select { |user| user[:age] >= 26 }
  .sort_by { |user| user[:age] }

puts "Processed users (age >= 26, sorted by age):"
processed.each do |user|
  puts "  #{user[:name]}: #{user[:age]} years, #{user[:email]}"
end
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. Use map/select/reduce instead of loops"
puts "2. Chain methods for readable data transformations"
puts "3. Symbol to proc (&:method) is powerful and concise"
puts "4. ||= for memoization and default values"
puts "5. Duck typing: check methods with respond_to?, not types"
puts "6. Safe navigation (&.) prevents nil errors"
puts "7. tap for side effects, then for transformations"
puts "8. Guard clauses improve readability"
puts "9. Declarative style: express what, not how"
puts "10. Splat operators for flexible method signatures"
puts
