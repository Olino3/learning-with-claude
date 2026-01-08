# Tutorial 5: Collections - Arrays and Hashes

Master Ruby's powerful collection types with methods Python developers will love!

## 📋 Learning Objectives

- Work with Arrays (Ruby's lists)
- Master Hashes (Ruby's dictionaries)
- Use collection methods (.map, .select, .reduce, etc.)
- Understand symbols as hash keys
- Iterate over collections efficiently

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| List | `[1, 2, 3]` | `[1, 2, 3]` |
| Dictionary | `{'key': 'value'}` | `{ key: 'value' }` |
| List comprehension | `[x*2 for x in list]` | `list.map { \|x\| x*2 }` |
| Filter | `[x for x in list if x>2]` | `list.select { \|x\| x>2 }` |
| Get with default | `dict.get('key', default)` | `hash.fetch(:key, default)` |
| Keys | `dict.keys()` | `hash.keys` |
| Values | `dict.values()` | `hash.values` |

## 📝 Arrays

```ruby
# Creating arrays
numbers = [1, 2, 3, 4, 5]
mixed = [1, "two", :three, [4, 5]]
empty = []

# Accessing elements
numbers[0]      # => 1
numbers[-1]     # => 5
numbers[1..3]   # => [2, 3, 4]
numbers[1...3]  # => [2, 3]

# Adding elements
numbers << 6           # => [1, 2, 3, 4, 5, 6]
numbers.push(7)        # => [1, 2, 3, 4, 5, 6, 7]
numbers.unshift(0)     # => [0, 1, 2, 3, 4, 5, 6, 7]

# Removing elements
numbers.pop            # => 7 (removes and returns last)
numbers.shift          # => 0 (removes and returns first)
numbers.delete(3)      # => 3 (removes value 3)

# Useful methods
numbers.length         # => 6
numbers.empty?         # => false
numbers.include?(3)    # => true
numbers.first          # => 1
numbers.last           # => 6
numbers.reverse        # => [6, 5, 4, 3, 2, 1]
numbers.sort           # => [1, 2, 3, 4, 5, 6]
numbers.uniq           # => removes duplicates
numbers.compact        # => removes nil values

# Transformation methods
[1, 2, 3].map { |n| n * 2 }           # => [2, 4, 6]
[1, 2, 3, 4].select { |n| n.even? }   # => [2, 4]
[1, 2, 3, 4].reject { |n| n.even? }   # => [1, 3]
[1, 2, 3].reduce(0) { |sum, n| sum + n }  # => 6

# Iteration
[1, 2, 3].each { |n| puts n }
[1, 2, 3].each_with_index { |n, i| puts "#{i}: #{n}" }
```

> **📘 Python Note:** Arrays are like Python lists but with more built-in methods. Methods like `.map`, `.select` are more common than list comprehensions in Ruby.

## 📝 Hashes

```ruby
# Creating hashes (symbol keys recommended)
user = { name: "Alice", age: 30, email: "alice@example.com" }

# Old syntax (still valid)
user = { :name => "Alice", :age => 30 }

# String keys (less common)
config = { "host" => "localhost", "port" => 3000 }

# Accessing values
user[:name]              # => "Alice"
user[:age]               # => 30
user[:missing]           # => nil
user.fetch(:missing, 0)  # => 0 (with default)

# Adding/updating
user[:city] = "Seattle"
user[:age] = 31

# Removing
user.delete(:email)

# Useful methods
user.keys                # => [:name, :age, :city]
user.values              # => ["Alice", 31, "Seattle"]
user.length              # => 3
user.empty?              # => false
user.key?(:name)         # => true
user.value?("Alice")     # => true
user.merge({ role: :admin })  # => new hash with merged values

# Iteration
user.each { |key, value| puts "#{key}: #{value}" }
user.each_key { |key| puts key }
user.each_value { |value| puts value }

# Transformation
user.map { |k, v| "#{k}: #{v}" }          # => array of strings
user.select { |k, v| v.is_a?(String) }    # => hash with string values
user.transform_values { |v| v.to_s }      # => all values to strings
```

> **📘 Python Note:** Hashes are like Python dicts. Use symbols (`:key`) for hash keys - they're more efficient than strings. The `{ key: value }` syntax is shorthand for `{ :key => value }`.

## 🔄 Common Patterns

```ruby
# Array to Hash
keys = [:name, :age]
values = ["Alice", 30]
hash = keys.zip(values).to_h  # => {name: "Alice", age: 30}

# Hash to Array
user.to_a  # => [[:name, "Alice"], [:age, 30]]

# Nested structures
users = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 },
  { name: "Carol", age: 35 }
]

users.map { |u| u[:name] }                    # => ["Alice", "Bob", "Carol"]
users.select { |u| u[:age] > 26 }             # => [{name: "Alice"...}, {name: "Carol"...}]
users.reduce(0) { |sum, u| sum + u[:age] }    # => 90

# Group by
users.group_by { |u| u[:age] > 30 }
# => {false=>[{name: "Alice"...}, {name: "Bob"...}], true=>[{name: "Carol"...}]}
```

## ✍️ Exercises

### Exercise: Collections Mastery

👉 **[Start Exercise: Collections](exercises/collections.md)**

Practice arrays, hashes, and transformation methods.

## 📚 What You Learned

✅ Array methods and manipulation
✅ Hash creation and access
✅ Symbols as hash keys
✅ Collection iteration and transformation
✅ Method chaining for data processing

## 🔜 Next Steps

**Next tutorial: 6-Object-Oriented-Programming**

## 💡 Key Takeaways

1. **Use symbols for hash keys**: `{ name: "Alice" }` not `{ "name" => "Alice" }`
2. **Prefer iterators**: `.map`, `.select` instead of loops
3. **Method chaining**: Combine operations for readable pipelines
4. **Negative indices**: `array[-1]` gets last element
5. **Safe access**: Use `.fetch` for hashes with defaults

---

**[Start Exercise](exercises/collections.md)**!
