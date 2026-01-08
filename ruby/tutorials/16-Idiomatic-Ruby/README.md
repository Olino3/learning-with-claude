# Tutorial 16: Idiomatic Ruby Patterns

Welcome to the final intermediate tutorial! This guide covers "The Ruby Way" - idiomatic patterns that make your code elegant, expressive, and distinctly Ruby. Master these patterns to write code that looks like it was written by a Ruby expert.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master Enumerable methods (map, reduce, select, etc.)
- Understand and apply duck typing
- Implement memoization patterns
- Use safe navigation operators
- Apply the PORO (Plain Old Ruby Object) pattern
- Use tap and then for method chaining
- Understand splat operators and keyword arguments
- Write declarative code instead of imperative
- Apply the Ruby principle: optimize for readability

## 🐍➡️🔴 Coming from Python

Ruby emphasizes elegance and expressiveness more than Python:

| Concept | Python | Ruby |
|---------|--------|------|
| List comprehension | `[x*2 for x in list]` | `list.map { |x| x * 2 }` |
| Filter | `[x for x in list if x > 0]` | `list.select { |x| x > 0 }` |
| Reduce | `reduce(lambda x,y: x+y, list)` | `list.reduce(:+)` |
| Duck typing | Common | More emphasized |
| Memoization | `@lru_cache` | `||=` operator |
| Method chaining | Limited | Core idiom |
| Blocks everywhere | Less common | Fundamental |

> **📘 Python Note:** Ruby takes functional programming further than Python. Blocks and chaining are everywhere.

## 📝 Enumerable Mastery

Ruby's Enumerable module is the heart of idiomatic iteration:

### Map - Transform Collections

```ruby
# Instead of:
results = []
[1, 2, 3, 4].each { |n| results << n * 2 }

# Use map:
results = [1, 2, 3, 4].map { |n| n * 2 }
# => [2, 4, 6, 8]

# Even better with symbol to proc:
names = ["alice", "bob", "charlie"]
names.map(&:capitalize)  # => ["Alice", "Bob", "Charlie"]
names.map(&:upcase)      # => ["ALICE", "BOB", "CHARLIE"]
```

### Select/Reject - Filter Collections

```ruby
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Select (keep truthy)
evens = numbers.select { |n| n.even? }
# => [2, 4, 6, 8, 10]

# Reject (remove truthy)
odds = numbers.reject { |n| n.even? }
# => [1, 3, 5, 7, 9]

# With symbol to proc
words = ["apple", "banana", ""]
words.select(&:empty?)   # => [""]
words.reject(&:empty?)   # => ["apple", "banana"]
```

### Reduce/Inject - Aggregate Values

```ruby
numbers = [1, 2, 3, 4, 5]

# Sum
numbers.reduce(0) { |sum, n| sum + n }  # => 15
numbers.reduce(:+)                       # => 15 (shorthand)
numbers.sum                              # => 15 (even better!)

# Product
numbers.reduce(1) { |product, n| product * n }  # => 120
numbers.reduce(:*)                               # => 120

# Build hash
words = ["apple", "banana", "cherry"]
words.reduce({}) { |hash, word|
  hash[word] = word.length
  hash
}
# => {"apple"=>5, "banana"=>6, "cherry"=>6}
```

### Each_with_object - Build Collections

```ruby
# Better than reduce for building objects
words = ["apple", "banana", "cherry"]

length_map = words.each_with_object({}) do |word, hash|
  hash[word] = word.length
end
# => {"apple"=>5, "banana"=>6, "cherry"=>6}

# With arrays
numbers = [1, 2, 3, 4, 5]
grouped = numbers.each_with_object({ even: [], odd: [] }) do |n, hash|
  hash[n.even? ? :even : :odd] << n
end
# => {:even=>[2, 4], :odd=>[1, 3, 5]}
```

### Chaining Enumerable Methods

```ruby
# The Ruby way: chain multiple operations
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

puts active_names.inspect
# => ["Alice", "Charlie", "Diana"]
```

> **📘 Python Note:** Like chaining `filter()` and `map()`, but more readable. Ruby encourages this style.

## 📝 Duck Typing

"If it walks like a duck and quacks like a duck, it's a duck."

```ruby
# Don't check the class
def process(items)
  # Bad
  if items.is_a?(Array)
    items.each { |item| puts item }
  end

  # Good - duck typing
  items.each { |item| puts item }
end

# Works with Array
process([1, 2, 3])

# Works with Range
process(1..3)

# Works with custom class
class MyCollection
  def each
    yield 1
    yield 2
    yield 3
  end
end
process(MyCollection.new)
```

### Respond_to? - Check Capabilities

```ruby
def display(object)
  if object.respond_to?(:each)
    object.each { |item| puts item }
  elsif object.respond_to?(:to_s)
    puts object.to_s
  end
end

display([1, 2, 3])
display("Hello")
display(42)
```

> **📘 Python Note:** Like Python's "duck typing", but Ruby takes it further. Check methods, not types.

## 📝 Memoization

Cache expensive computations:

```ruby
class Report
  def expensive_calculation
    @expensive_calculation ||= begin
      puts "Computing..."
      sleep(1)
      42
    end
  end
end

report = Report.new
report.expensive_calculation  # Computes
report.expensive_calculation  # Cached!
report.expensive_calculation  # Cached!
```

### Memoization with Parameters

```ruby
class Calculator
  def initialize
    @cache = {}
  end

  def fibonacci(n)
    @cache[n] ||= begin
      return n if n <= 1
      fibonacci(n - 1) + fibonacci(n - 2)
    end
  end
end

calc = Calculator.new
puts calc.fibonacci(10)  # Computes
puts calc.fibonacci(10)  # Cached
```

> **📘 Python Note:** Similar to `@lru_cache`, but `||=` is simpler for basic cases.

## 📝 Safe Navigation Operator

Ruby 2.3+ has the safe navigation operator `&.`:

```ruby
user = { name: "Alice", profile: { email: "alice@example.com" } }

# Without safe navigation
email = user && user[:profile] && user[:profile][:email]

# With safe navigation
email = user&.[](:profile)&.[](:email)

# With method calls
name = user&.fetch(:name)&.upcase

# Returns nil if any step is nil
result = nil&.some_method&.another_method  # => nil
```

> **📘 Python Note:** Like optional chaining in other languages. Python uses `getattr(obj, 'attr', None)`.

## 📝 Tap and Then - Method Chaining

### Tap - Side Effects in Chains

```ruby
# Without tap
user = User.new("Alice")
user.age = 30
user.email = "alice@example.com"
puts user

# With tap
User.new("Alice").tap do |u|
  u.age = 30
  u.email = "alice@example.com"
  puts u
end

# Debugging chains
result = [1, 2, 3, 4, 5]
  .tap { |a| puts "Original: #{a.inspect}" }
  .select(&:even?)
  .tap { |a| puts "After select: #{a.inspect}" }
  .map { |n| n * 2 }
  .tap { |a| puts "After map: #{a.inspect}" }
```

### Then (Yield_self) - Transform in Chains

```ruby
# Ruby 2.5+
"  hello  "
  .then { |s| s.strip }
  .then { |s| s.upcase }
  .then { |s| "** #{s} **" }
# => "** HELLO **"

# Useful for transformations
result = fetch_data
  .then { |data| parse_json(data) }
  .then { |json| transform(json) }
  .then { |obj| save_to_db(obj) }
```

## 📝 Splat Operators

### Single Splat (*) - Arrays

```ruby
def greet(greeting, *names)
  names.each { |name| puts "#{greeting}, #{name}!" }
end

greet("Hello", "Alice", "Bob", "Charlie")

# Collecting arguments
first, *rest, last = [1, 2, 3, 4, 5]
puts "first: #{first}"  # => 1
puts "rest: #{rest}"    # => [2, 3, 4]
puts "last: #{last}"    # => 5

# Spreading arrays
arr1 = [1, 2, 3]
arr2 = [4, 5, 6]
combined = [*arr1, *arr2]  # => [1, 2, 3, 4, 5, 6]
```

### Double Splat (**) - Hashes

```ruby
def create_user(name:, email:, **options)
  puts "Name: #{name}"
  puts "Email: #{email}"
  puts "Options: #{options.inspect}"
end

create_user(
  name: "Alice",
  email: "alice@example.com",
  age: 30,
  role: :admin
)

# Merging hashes
defaults = { color: "blue", size: "medium" }
custom = { color: "red", weight: "heavy" }
merged = { **defaults, **custom }
# => {:color=>"red", :size=>"medium", :weight=>"heavy"}
```

## 📝 PORO - Plain Old Ruby Objects

Keep objects simple and focused:

```ruby
# Good PORO
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
    items.sum(&:price)
  end

  def paid?
    @paid == true
  end

  def mark_paid
    @paid = true
  end
end

# Usage with chaining
invoice = Invoice.new("Alice")
  .add_item(Item.new("Book", 10))
  .add_item(Item.new("Pen", 2))

puts "Total: $#{invoice.total}"
```

## 📝 Declarative vs Imperative

Write what you want, not how to do it:

```ruby
# Imperative (how)
valid_users = []
users.each do |user|
  if user.age >= 18 && user.active?
    valid_users << user.name.upcase
  end
end

# Declarative (what)
valid_users = users
  .select { |u| u.age >= 18 && u.active? }
  .map { |u| u.name.upcase }
```

## 📝 Common Idioms

### 1. Truthiness Check

```ruby
# Instead of: if !x.nil? && !x.empty?
if x && !x.empty?
  # ...
end

# Or use presence
if x&.size&.positive?
  # ...
end
```

### 2. Default Values

```ruby
# Instead of: x = x ? x : default
x ||= default

# Hash default
config[:timeout] ||= 30

# Method default
def process(options = {})
  timeout = options[:timeout] || 30
  retry_count = options[:retries] || 3
end
```

### 3. Guard Clauses

```ruby
# Instead of nested ifs
def process(user)
  return unless user
  return unless user.active?
  return if user.banned?

  # Main logic here
end
```

### 4. Conditional Assignment

```ruby
# Assign only if condition is true
status = :active if user.verified?

# Short circuit
user && user.save

# Multiple conditions
result = condition1 && condition2 && expensive_operation
```

### 5. Symbol to Proc

```ruby
# Instead of:
users.map { |u| u.name }

# Use:
users.map(&:name)

# Works with any method:
numbers.select(&:even?)
strings.map(&:upcase)
objects.each(&:save)
```

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/16-Idiomatic-Ruby/exercises/idiomatic_practice.rb
```

## 📚 What You Learned

✅ Enumerable methods (map, select, reduce)
✅ Duck typing and respond_to?
✅ Memoization with ||=
✅ Safe navigation operator (&.)
✅ Tap and then for chaining
✅ Splat operators (* and **)
✅ PORO pattern
✅ Declarative over imperative style
✅ Common Ruby idioms

## 🔜 Next Steps

**Next: Comprehensive Lab** - Apply all intermediate concepts in a real-world project!

## 💡 Key Takeaways for Python Developers

1. **Enumerable everywhere**: map/select/reduce instead of loops
2. **Duck typing**: Check methods with respond_to?, not types
3. **Memoization**: ||= is simpler than decorators for basic cases
4. **Chaining**: Ruby encourages method chaining more than Python
5. **Blocks are fundamental**: Used for iteration, configuration, DSLs
6. **Symbol to proc**: &:method_name is Ruby magic
7. **Declarative style**: Focus on what, not how

## 🆘 Common Pitfalls

### Pitfall 1: Overusing map
```ruby
# Bad
users.map { |u| u.save }  # Returns array of results

# Good
users.each(&:save)  # Returns original array
```

### Pitfall 2: Memoization with false/nil
```ruby
# Bad
def exists?
  @exists ||= expensive_check  # Won't cache false!
end

# Good
def exists?
  return @exists if defined?(@exists)
  @exists = expensive_check
end
```

### Pitfall 3: Chaining too much
```ruby
# Bad - hard to debug
result = data.map(&:process).select(&:valid?).group_by(&:type).transform_values { |v| v.sum(&:total) }.sort_by { |k, v| -v }

# Good - readable
result = data
  .map(&:process)
  .select(&:valid?)
  .group_by(&:type)
  .transform_values { |v| v.sum(&:total) }
  .sort_by { |k, v| -v }
```

## 📖 Additional Resources

- [Ruby Style Guide](https://rubystyle.guide/)
- [Eloquent Ruby](https://www.amazon.com/Eloquent-Ruby-Addison-Wesley-Professional/dp/0321584104)
- [Ruby Enumerable Documentation](https://ruby-doc.org/core-3.4.0/Enumerable.html)

---

Congratulations! You've completed all intermediate Ruby tutorials. Ready for the comprehensive lab?
