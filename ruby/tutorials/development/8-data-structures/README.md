# Tutorial 8: Data Structures & Algorithms in Ruby

Master Ruby's powerful data structures and learn to implement efficient algorithms. This tutorial covers Enumerable methods, Hash and Array internals, custom data structures, algorithm implementation, and memoization patterns.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master Enumerable methods for data manipulation
- Understand Hash and Array internals
- Implement custom data structures in Ruby
- Write common algorithms in Ruby style
- Use memoization for performance
- Choose appropriate data structures
- Compare Ruby approaches to Python
- Optimize algorithmic complexity

## 🐍➡️🔴 Coming from Python

If you're familiar with Python data structures, here's how Ruby compares:

| Structure | Python | Ruby | Key Difference |
|-----------|--------|------|----------------|
| List | `list` | `Array` | Similar, Ruby more methods |
| Dictionary | `dict` | `Hash` | Symbol keys common in Ruby |
| Set | `set` | `Set` | Ruby requires `require 'set'` |
| Tuple | `tuple` | Frozen Array | No native tuple |
| Comprehensions | `[x for x in list]` | `array.map { |x| x }` | Different syntax |
| Iterator methods | `map`, `filter` | `map`, `select` | Ruby has many more |
| Slicing | `list[1:5]` | `array[1..4]` or `array[1, 4]` | Range vs length |
| Named tuple | `namedtuple` | `Struct` | Similar concept |

> **📘 Python Note:** Ruby's Enumerable module provides 50+ methods for data manipulation, similar to Python's itertools but built-in.

## 📝 Part 1: Enumerable Methods Deep Dive

Ruby's Enumerable module provides powerful functional programming tools.

### Basic Iteration

```ruby
# each - Basic iteration
[1, 2, 3].each { |n| puts n }

# each_with_index - With index
%w[a b c].each_with_index do |letter, index|
  puts "#{index}: #{letter}"
end

# each_with_object - Build a result
[1, 2, 3].each_with_object({}) do |num, hash|
  hash[num] = num**2
end
# => {1=>1, 2=>4, 3=>9}
```

> **📘 Python Note:** Similar to Python's enumerate:
> ```python
> for index, letter in enumerate(['a', 'b', 'c']):
>     print(f"{index}: {letter}")
> ```

### Transformation Methods

```ruby
# map / collect - Transform each element
[1, 2, 3].map { |n| n**2 }
# => [1, 4, 9]

# flat_map - Map and flatten
[[1, 2], [3, 4]].flat_map { |arr| arr.map { |n| n * 2 } }
# => [2, 4, 6, 8]

# map with index
['a', 'b', 'c'].map.with_index { |letter, i| "#{i}:#{letter}" }
# => ["0:a", "1:b", "2:c"]

# Compact - Remove nils
[1, nil, 3, nil, 5].compact
# => [1, 3, 5]

# Flatten - Flatten nested arrays
[[1, 2], [3, [4, 5]]].flatten
# => [1, 2, 3, 4, 5]
```

### Filtering Methods

```ruby
# select / filter - Keep matching elements
[1, 2, 3, 4, 5].select { |n| n.even? }
# => [2, 4]

# reject - Remove matching elements
[1, 2, 3, 4, 5].reject { |n| n.even? }
# => [1, 3, 5]

# grep - Filter with pattern
%w[apple banana cherry].grep(/^b/)
# => ["banana"]

# partition - Split into two arrays
[1, 2, 3, 4, 5].partition { |n| n.even? }
# => [[2, 4], [1, 3, 5]]

# take_while - Take until condition fails
[1, 2, 3, 4, 1].take_while { |n| n < 4 }
# => [1, 2, 3]

# drop_while - Drop until condition fails
[1, 2, 3, 4, 5].drop_while { |n| n < 4 }
# => [4, 5]
```

### Reduction Methods

```ruby
# reduce / inject - Accumulate value
[1, 2, 3, 4].reduce(0) { |sum, n| sum + n }
# => 10

# With symbol
[1, 2, 3, 4].reduce(:+)
# => 10

# sum (built-in)
[1, 2, 3, 4].sum
# => 10

# Product
[1, 2, 3, 4].reduce(1, :*)
# => 24

# Build hash
%w[a b c].each_with_index.reduce({}) do |hash, (letter, i)|
  hash[letter] = i
  hash
end
# => {"a"=>0, "b"=>1, "c"=>2}

# Or use each_with_object (cleaner)
%w[a b c].each_with_index.each_with_object({}) do |(letter, i), hash|
  hash[letter] = i
end
```

### Searching Methods

```ruby
# find / detect - First matching element
[1, 2, 3, 4].find { |n| n.even? }
# => 2

# find_all - All matching elements (alias for select)
[1, 2, 3, 4].find_all { |n| n.even? }
# => [2, 4]

# any? - At least one matches
[1, 2, 3].any? { |n| n.even? }
# => true

# all? - All match
[2, 4, 6].all? { |n| n.even? }
# => true

# none? - None match
[1, 3, 5].none? { |n| n.even? }
# => true

# one? - Exactly one matches
[1, 2, 3].one? { |n| n.even? }
# => true

# include? - Contains value
[1, 2, 3].include?(2)
# => true
```

### Grouping and Sorting

```ruby
# group_by - Group into hash
%w[apple apricot banana berry cherry].group_by { |word| word[0] }
# => {"a"=>["apple", "apricot"], "b"=>["banana", "berry"], "c"=>["cherry"]}

# tally - Count occurrences
%w[a b a c b a].tally
# => {"a"=>3, "b"=>2, "c"=>1}

# sort - Natural sort
[3, 1, 4, 1, 5].sort
# => [1, 1, 3, 4, 5]

# sort_by - Sort by attribute
users.sort_by { |user| user.age }

# Sort descending
[3, 1, 4].sort.reverse
# or
[3, 1, 4].sort { |a, b| b <=> a }

# min / max
[3, 1, 4, 1, 5].min  # => 1
[3, 1, 4, 1, 5].max  # => 5

# min_by / max_by
users.min_by { |user| user.age }
users.max_by { |user| user.age }

# minmax
[3, 1, 4, 1, 5].minmax
# => [1, 5]
```

### Chaining Methods

```ruby
# Complex data transformation
users
  .select { |u| u.active? }
  .map { |u| u.orders }
  .flatten
  .select { |o| o.total > 100 }
  .group_by { |o| o.status }
  .transform_values { |orders| orders.sum(&:total) }

# Or with then (Ruby 2.6+)
data
  .then { |d| d.select(&:active?) }
  .then { |d| d.map(&:value) }
  .then { |d| d.sum }
```

## 📝 Part 2: Hash Internals and Performance

### Hash Basics

```ruby
# Creation
hash = { name: 'Alice', age: 30 }
hash = Hash.new  # Empty hash
hash = Hash.new(0)  # Default value

# Symbol vs string keys
symbol_hash = { name: 'Alice' }  # Symbol key (preferred)
string_hash = { 'name' => 'Alice' }  # String key

# Access
hash[:name]
hash.fetch(:name)  # Raises if missing
hash.fetch(:email, 'default@example.com')  # With default

# Modification
hash[:name] = 'Bob'
hash.delete(:age)
hash.merge(city: 'NYC')  # Returns new hash
hash.merge!(city: 'NYC')  # Modifies in place
```

### Advanced Hash Operations

```ruby
# transform_keys / transform_values
hash = { a: 1, b: 2, c: 3 }
hash.transform_keys(&:to_s)  # => {"a"=>1, "b"=>2, "c"=>3}
hash.transform_values { |v| v * 2 }  # => {a: 2, b: 4, c: 6}

# slice - Extract keys
hash = { a: 1, b: 2, c: 3, d: 4 }
hash.slice(:a, :c)  # => {a: 1, c: 3}

# except - Omit keys
hash.except(:b, :d)  # => {a: 1, c: 3}

# dig - Deep access
data = { user: { address: { city: 'NYC' } } }
data.dig(:user, :address, :city)  # => "NYC"
data.dig(:user, :phone, :number)  # => nil (no error)

# Default values
hash = Hash.new { |h, k| h[k] = [] }
hash[:items] << 1  # Automatically creates array
hash[:items] << 2
hash  # => {items: [1, 2]}
```

### Hash Performance

```ruby
# Hash lookup is O(1) average case
require 'benchmark'

array = (1..100_000).to_a
hash = array.each_with_object({}) { |n, h| h[n] = true }

Benchmark.bm do |x|
  x.report('Array#include?') { array.include?(99_999) }
  x.report('Hash#key?') { hash.key?(99_999) }
end

# Result:
#                    user     system      total        real
# Array#include?  0.002134   0.000000   0.002134 (  0.002138)
# Hash#key?       0.000001   0.000000   0.000001 (  0.000001)

# Hash is ~2000x faster for lookups!
```

## 📝 Part 3: Array Performance

### Array Operations

```ruby
# Efficient appending
array = []
array << 1  # O(1) amortized
array.push(2)  # O(1) amortized

# Inefficient prepending
array.unshift(0)  # O(n) - shifts all elements

# Use deque pattern if prepending often
require 'algorithms'
deque = Containers::Deque.new
deque.push_front(1)  # O(1)

# Slicing
array = [1, 2, 3, 4, 5]
array[1..3]  # => [2, 3, 4]
array[1, 3]  # Start at 1, take 3  => [2, 3, 4]
array[1..-1]  # From 1 to end  => [2, 3, 4, 5]

# first, last
array.first  # => 1
array.first(3)  # => [1, 2, 3]
array.last  # => 5
array.last(2)  # => [4, 5]

# Concatenation
[1, 2] + [3, 4]  # => [1, 2, 3, 4]
[1, 2].concat([3, 4])  # Modifies in place
```

### Array vs Set Performance

```ruby
require 'set'
require 'benchmark'

array = (1..10_000).to_a
set = Set.new(array)

Benchmark.bm do |x|
  x.report('Array') { 100.times { array.include?(9_999) } }
  x.report('Set') { 100.times { set.include?(9_999) } }
end

# Use Set for membership testing, Array for ordered data
```

## 📝 Part 4: Custom Data Structures

### Stack

```ruby
class Stack
  def initialize
    @items = []
  end

  def push(item)
    @items.push(item)
  end

  def pop
    @items.pop
  end

  def peek
    @items.last
  end

  def empty?
    @items.empty?
  end

  def size
    @items.size
  end
end

# Usage
stack = Stack.new
stack.push(1)
stack.push(2)
stack.pop  # => 2
```

### Queue

```ruby
class Queue
  def initialize
    @items = []
  end

  def enqueue(item)
    @items.push(item)
  end

  def dequeue
    @items.shift
  end

  def peek
    @items.first
  end

  def empty?
    @items.empty?
  end
end
```

### Linked List

```ruby
class Node
  attr_accessor :value, :next_node

  def initialize(value)
    @value = value
    @next_node = nil
  end
end

class LinkedList
  attr_reader :head

  def initialize
    @head = nil
  end

  def append(value)
    new_node = Node.new(value)

    if @head.nil?
      @head = new_node
    else
      current = @head
      current = current.next_node while current.next_node
      current.next_node = new_node
    end
  end

  def find(value)
    current = @head
    while current
      return current if current.value == value
      current = current.next_node
    end
    nil
  end

  def to_a
    result = []
    current = @head
    while current
      result << current.value
      current = current.next_node
    end
    result
  end
end
```

## 📝 Part 5: Algorithm Implementation

### Binary Search

```ruby
def binary_search(array, target)
  left = 0
  right = array.length - 1

  while left <= right
    mid = (left + right) / 2

    case array[mid] <=> target
    when 0 then return mid
    when -1 then left = mid + 1
    when 1 then right = mid - 1
    end
  end

  nil
end

# Ruby way with bsearch
[1, 2, 3, 4, 5].bsearch { |x| x >= 3 }  # => 3
```

### Quick Sort

```ruby
def quicksort(array)
  return array if array.length <= 1

  pivot = array[array.length / 2]
  left = array.select { |x| x < pivot }
  middle = array.select { |x| x == pivot }
  right = array.select { |x| x > pivot }

  quicksort(left) + middle + quicksort(right)
end
```

### Merge Sort

```ruby
def merge_sort(array)
  return array if array.length <= 1

  mid = array.length / 2
  left = merge_sort(array[0...mid])
  right = merge_sort(array[mid..-1])

  merge(left, right)
end

def merge(left, right)
  result = []

  until left.empty? || right.empty?
    result << (left.first <= right.first ? left.shift : right.shift)
  end

  result + left + right
end
```

## 📝 Part 6: Memoization Patterns

### Basic Memoization

```ruby
class Fibonacci
  def initialize
    @cache = {}
  end

  def calculate(n)
    return n if n <= 1
    @cache[n] ||= calculate(n - 1) + calculate(n - 2)
  end
end

# Or with class-level memoization
class Calculator
  @cache = {}

  def self.expensive_operation(n)
    @cache[n] ||= begin
      # Expensive calculation
      sleep 1
      n ** 2
    end
  end
end
```

### Instance Variable Memoization

```ruby
class User < ApplicationRecord
  def full_name
    @full_name ||= "#{first_name} #{last_name}"
  end

  # Careful with falsey values!
  def admin?
    return @admin if defined?(@admin)
    @admin = role == 'admin'
  end
end
```

### Using Memery Gem

```ruby
# Gemfile
gem 'memery'

class ReportGenerator
  include Memery

  memoize def generate_report
    # Expensive operation
  end
end
```

## ✍️ Exercises

### Exercise 1: Enumerable Mastery
👉 **[Enumerable Methods](exercises/1-enumerable-mastery.md)**

Practice:
- Data transformations
- Complex filtering
- Grouping and aggregation
- Method chaining

### Exercise 2: Custom Data Structures
👉 **[Build Data Structures](exercises/2-custom-structures.md)**

Implement:
- Binary Search Tree
- Priority Queue
- LRU Cache
- Trie (Prefix Tree)

### Exercise 3: Algorithm Implementation
👉 **[Algorithms in Ruby](exercises/3-algorithms.md)**

Code:
- Sorting algorithms
- Graph algorithms
- Dynamic programming
- String algorithms

## 📚 What You Learned

✅ Enumerable methods for data manipulation
✅ Hash and Array performance characteristics
✅ Custom data structure implementation
✅ Algorithm implementation in Ruby
✅ Memoization patterns
✅ Performance optimization
✅ Ruby vs Python approaches

## 🔜 Next Steps

**Next: [Tutorial 9: Security & Environment Management](../9-security-environment/README.md)**

Learn to:
- Manage environment variables
- Handle secrets securely
- Prevent common vulnerabilities
- Implement secure authentication

## 💡 Key Takeaways for Python Developers

1. **Enumerable ≈ itertools**: More methods built-in
2. **Hash ≈ dict**: Symbol keys common in Ruby
3. **Array ≈ list**: Similar performance characteristics
4. **Blocks**: Ruby's killer feature for iteration
5. **Memoization**: Similar patterns, different syntax
6. **Performance**: Similar optimization strategies
7. **Functional style**: Ruby embraces it more

## 🆘 Common Pitfalls

### Pitfall 1: Modifying While Iterating

```ruby
# Bad
array = [1, 2, 3, 4, 5]
array.each { |n| array.delete(n) if n.even? }  # Unpredictable!

# Good
array = [1, 2, 3, 4, 5]
array.reject! { |n| n.even? }
```

### Pitfall 2: Inefficient Chaining

```ruby
# Bad: Multiple passes
array.select { |x| x > 0 }.map { |x| x * 2 }.sum

# Good: Single pass
array.reduce(0) { |sum, x| x > 0 ? sum + (x * 2) : sum }
```

### Pitfall 3: Memoization with Falsey Values

```ruby
# Bad
def admin?
  @admin ||= check_admin_status  # Fails if false!
end

# Good
def admin?
  return @admin if defined?(@admin)
  @admin = check_admin_status
end
```

## 📖 Additional Resources

- [Ruby Enumerable Documentation](https://ruby-doc.org/core/Enumerable.html)
- [Algorithms in Ruby](https://github.com/kanwei/algorithms)
- [Data Structures in Ruby](https://www.rubyguides.com/ruby-tutorial/ruby-data-structures/)

---

Ready to master data structures? Start with **[Exercise 1: Enumerable Mastery](exercises/1-enumerable-mastery.md)**! 📊
