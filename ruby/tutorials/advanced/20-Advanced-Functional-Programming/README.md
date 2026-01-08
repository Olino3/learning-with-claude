# Tutorial 20: Advanced Functional Programming

Master Ruby's functional programming capabilities - currying, method objects, lazy evaluation, and functional composition patterns.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use currying and partial application
- Work with method objects as first-class citizens
- Master lazy evaluation with Enumerable#lazy
- Implement functional composition patterns
- Build immutable data structures
- Apply functional programming paradigms in Ruby

## 🐍➡️🔴 Coming from Python

Python has functools, Ruby has similar functional features:

| Concept | Python | Ruby |
|---------|--------|------|
| Currying | `functools.partial` | `Proc#curry` |
| Method as object | `obj.method` (bound method) | `method(:name)` |
| Lazy evaluation | Generators (`yield`) | `Enumerable#lazy` |
| Function composition | `compose(*funcs)` | `.>>` and `.<<` (Ruby 2.6+) |
| Map/filter/reduce | List comprehensions | `.map`, `.select`, `.reduce` |
| Immutability | Named tuples, frozen dataclasses | `.freeze`, immutable gems |

> **📘 Python Note:** Ruby's functional features are more integrated. `lazy` is built-in, currying is a method call, and method objects are first-class.

## 📝 Currying and Partial Application

Currying transforms a multi-argument function into a chain of single-argument functions:

```ruby
# Basic currying
add = ->(a, b, c) { a + b + c }
curried_add = add.curry

# Can call with all args at once
puts curried_add.call(1, 2, 3)  # => 6

# Or partial application
add_one = curried_add.call(1)
add_one_and_two = add_one.call(2)
puts add_one_and_two.call(3)    # => 6

# Practical example: URL builder
build_url = ->(protocol, domain, path) { "#{protocol}://#{domain}#{path}" }
curried_url = build_url.curry

# Create specialized builders
https_builder = curried_url.call("https")
github_https = https_builder.call("github.com")

puts github_https.call("/ruby/ruby")  # => https://github.com/ruby/ruby
puts github_https.call("/Olino3/learning-with-claude")
```

### Currying Methods

```ruby
def greet(greeting, title, name)
  "#{greeting}, #{title} #{name}!"
end

# Convert method to proc and curry
curried_greet = method(:greet).to_proc.curry

# Partial application
hello_greet = curried_greet.call("Hello")
hello_mr = hello_greet.call("Mr.")

puts hello_mr.call("Smith")   # => "Hello, Mr. Smith!"
puts hello_mr.call("Jones")   # => "Hello, Mr. Jones!"

# Different greeting
goodbye_greet = curried_greet.call("Goodbye")
goodbye_ms = goodbye_greet.call("Ms.")
puts goodbye_ms.call("Alice")  # => "Goodbye, Ms. Alice!"
```

> **📘 Python Note:** Like `functools.partial(func, arg1, arg2)`, but more flexible. Ruby's curry allows partial application at any stage.

## 📝 Method Objects as First-Class Citizens

Methods can be detached and passed around:

```ruby
class Calculator
  def add(a, b)
    a + b
  end
  
  def multiply(a, b)
    a * b
  end
  
  def apply_operation(operation, a, b)
    operation.call(a, b)
  end
end

calc = Calculator.new

# Get method objects
add_method = calc.method(:add)
multiply_method = calc.method(:multiply)

# Pass methods as arguments
puts calc.apply_operation(add_method, 5, 3)       # => 8
puts calc.apply_operation(multiply_method, 5, 3)  # => 15

# Store in data structures
operations = {
  add: calc.method(:add),
  multiply: calc.method(:multiply)
}

puts operations[:add].call(10, 5)       # => 15
puts operations[:multiply].call(10, 5)  # => 50
```

### Method Composition

```ruby
# Define transformations
double = ->(x) { x * 2 }
increment = ->(x) { x + 1 }
square = ->(x) { x ** 2 }

# Manual composition
result = square.call(increment.call(double.call(3)))
puts result  # => 49 (3 * 2 = 6, 6 + 1 = 7, 7^2 = 49)

# Composition helper
def compose(*fns)
  ->(x) { fns.reverse.reduce(x) { |acc, fn| fn.call(acc) } }
end

pipeline = compose(square, increment, double)
puts pipeline.call(3)  # => 49

# Or using >> and << (Ruby 2.6+)
if RUBY_VERSION >= "2.6.0"
  pipeline2 = double >> increment >> square
  puts pipeline2.call(3)  # => 49
end
```

> **📘 Python Note:** Similar to `from functools import reduce; compose = lambda *fns: lambda x: reduce(lambda acc, f: f(acc), fns, x)`.

## 📝 Lazy Evaluation with Enumerable#lazy

Lazy evaluation defers computation until needed:

```ruby
# Without lazy - processes entire collection
numbers = (1..1_000_000)
result = numbers.map { |n| n * 2 }
                .select { |n| n % 3 == 0 }
                .first(5)
puts result.inspect  # Processed 1 million numbers!

# With lazy - only processes what's needed
lazy_result = numbers.lazy
                     .map { |n| n * 2 }
                     .select { |n| n % 3 == 0 }
                     .first(5)
puts lazy_result  # Only processed until we got 5 results!
```

### Infinite Sequences

```ruby
# Infinite sequence of Fibonacci numbers
fibonacci = Enumerator.new do |yielder|
  a, b = 0, 1
  loop do
    yielder << a
    a, b = b, a + b
  end
end

# Take first 10 without computing all
puts fibonacci.lazy.first(10).inspect

# Filter even Fibonacci numbers
even_fibs = fibonacci.lazy.select(&:even?).first(10)
puts even_fibs

# Infinite range with transformations
infinite_squares = (1..Float::INFINITY).lazy.map { |n| n ** 2 }
puts infinite_squares.first(5)  # [1, 4, 9, 16, 25]
```

### Lazy File Processing

```ruby
# Process huge log file lazily
def process_log_file(filename)
  File.foreach(filename).lazy
    .map(&:strip)
    .reject { |line| line.empty? || line.start_with?('#') }
    .map { |line| parse_log_entry(line) }
    .select { |entry| entry[:level] == 'ERROR' }
    .first(10)  # Only read until we get 10 errors
end

def parse_log_entry(line)
  # Simplified parser
  parts = line.split(' ', 3)
  { timestamp: parts[0], level: parts[1], message: parts[2] }
end
```

> **📘 Python Note:** Like Python generators and itertools. `lazy` chains operations without creating intermediate arrays.

## 📝 Immutable Data Structures

Functional programming emphasizes immutability:

```ruby
# Make objects immutable
person = { name: "Alice", age: 30 }.freeze

# Can't modify
# person[:age] = 31  # FrozenError!

# Create new objects instead
updated_person = person.merge(age: 31)
puts person[:age]          # => 30 (original unchanged)
puts updated_person[:age]  # => 31 (new object)

# Deeply frozen structures
def deep_freeze(obj)
  case obj
  when Hash
    obj.each { |k, v| deep_freeze(v) }
    obj.freeze
  when Array
    obj.each { |v| deep_freeze(v) }
    obj.freeze
  else
    obj.freeze if obj.respond_to?(:freeze)
  end
  obj
end

data = { users: [{ name: "Alice" }, { name: "Bob" }] }
frozen_data = deep_freeze(data)

# frozen_data[:users] << { name: "Charlie" }  # Error!
# frozen_data[:users][0][:name] = "Alicia"    # Error!
```

### Immutable Value Objects

```ruby
class Point
  attr_reader :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
    freeze  # Make immutable
  end
  
  def move(dx, dy)
    # Return new instance instead of modifying
    Point.new(@x + dx, @y + dy)
  end
  
  def to_s
    "(#{@x}, #{@y})"
  end
end

p1 = Point.new(0, 0)
p2 = p1.move(5, 3)
p3 = p2.move(-2, 1)

puts p1  # => (0, 0)
puts p2  # => (5, 3)
puts p3  # => (3, 4)
```

## 📝 Functional Patterns

### 1. Map-Filter-Reduce Pipeline

```ruby
# Calculate sum of squares of even numbers
numbers = (1..100)

result = numbers
  .select(&:even?)           # filter
  .map { |n| n ** 2 }        # map
  .reduce(0, :+)             # reduce

puts result

# With lazy for large datasets
lazy_result = (1..Float::INFINITY)
  .lazy
  .select(&:even?)
  .map { |n| n ** 2 }
  .first(10)
  .reduce(0, :+)

puts lazy_result
```

### 2. Function Memoization

```ruby
def memoize(fn)
  cache = {}
  ->(arg) do
    cache[arg] ||= fn.call(arg)
  end
end

# Slow fibonacci
fib = ->(n) do
  return n if n <= 1
  fib.call(n - 1) + fib.call(n - 2)
end

# Fast memoized fibonacci
memoized_fib = memoize(fib)

require 'benchmark'
puts Benchmark.measure { fib.call(35) }
puts Benchmark.measure { memoized_fib.call(35) }
```

### 3. Transducers Pattern

```ruby
# Composable transformation pipeline
def transducer(*transformations)
  ->(collection) do
    transformations.reduce(collection.lazy) do |coll, transform|
      transform.call(coll)
    end
  end
end

# Define transformations
map_double = ->(coll) { coll.map { |x| x * 2 } }
filter_even = ->(coll) { coll.select(&:even?) }
take_five = ->(coll) { coll.first(5) }

# Compose pipeline
pipeline = transducer(map_double, filter_even, take_five)

result = pipeline.call(1..100)
puts result.inspect
```

## ✍️ Practice Exercise

```bash
ruby ruby/tutorials/advanced/20-Advanced-Functional-Programming/exercises/functional_practice.rb
```

## 📚 What You Learned

✅ Currying and partial application
✅ Method objects as first-class values
✅ Lazy evaluation for efficient processing
✅ Functional composition patterns
✅ Immutable data structures
✅ Practical functional programming in Ruby

## 🔜 Next Steps

**Next tutorial: 21-Performance-Profiling-Optimization** - Master benchmarking, profiling, and optimization.

## 💡 Key Takeaways for Python Developers

1. **Currying**: Built-in, more flexible than `functools.partial`
2. **Lazy**: Like generators but for any enumerable
3. **Method objects**: First-class, like bound methods
4. **Composition**: Natural with `>>` and `<<` operators
5. **Immutability**: `.freeze` for immutable objects
6. **Functional style**: Idiomatic in Ruby, like Python

## 📖 Additional Resources

- [Functional Programming in Ruby](https://www.rubyguides.com/2018/01/ruby-functional-programming/)
- [Lazy Enumerator Guide](https://blog.appsignal.com/2018/05/29/ruby-magic-enumerable-and-enumerator.html)
- [Immutability in Ruby](https://www.honeybadger.io/blog/ruby-frozen-objects/)

---

Ready to embrace functional programming? Run the exercises!
