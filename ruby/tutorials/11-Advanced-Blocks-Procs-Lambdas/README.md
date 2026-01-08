# Tutorial 11: Advanced Blocks, Procs, and Lambdas (Closures)

Welcome to your first intermediate Ruby tutorial! This guide dives deep into one of Ruby's most powerful features: closures. Understanding blocks, procs, and lambdas is essential for writing idiomatic Ruby and understanding how Rails and other frameworks work.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master the differences between blocks, procs, and lambdas
- Understand closure behavior and variable capture
- Use yield effectively with block_given?
- Convert between blocks, procs, and lambdas
- Understand arity checking and return behavior differences
- Write methods that accept blocks as parameters
- Apply closures to real-world problems

## 🐍➡️🔴 Coming from Python

Python developers have some exposure to closures through decorators and nested functions, but Ruby takes this concept much further:

| Concept | Python | Ruby |
|---------|--------|------|
| Anonymous function | `lambda x: x * 2` | `lambda { |x| x * 2 }` or `->(x) { x * 2 }` |
| Passing functions | Pass function reference | Blocks are built into method calls |
| Decorators | `@decorator` | Uses blocks and `define_method` |
| Closure creation | Nested `def` or `lambda` | Blocks, Procs, and Lambdas |
| Generator pattern | `yield` keyword | `Enumerator` with blocks |
| Iterator protocol | `__iter__` and `__next__` | Blocks with `.each` |

> **📘 Python Note:** In Python, you might use `functools.partial` or `lambda` for similar patterns. Ruby's blocks are more fundamental to the language - almost every iteration uses them!

## 📝 Understanding Closures

### What is a Closure?

A closure is a function that "closes over" variables from its surrounding scope:

```ruby
def make_counter
  count = 0
  # This lambda closes over 'count'
  lambda { count += 1 }
end

counter = make_counter
puts counter.call  # => 1
puts counter.call  # => 2
puts counter.call  # => 3
```

> **📘 Python Note:** This is similar to Python's nested functions. The key difference is Ruby makes this pattern much more common and idiomatic.

## 📝 Blocks: The Foundation

Blocks are chunks of code enclosed in `{}` or `do...end`. They're passed to methods but are not objects themselves (until converted to Procs).

### Block Syntax

```ruby
# Single-line block (use {} for one-liners)
[1, 2, 3].each { |n| puts n * 2 }

# Multi-line block (use do...end for multi-line)
[1, 2, 3].each do |n|
  squared = n ** 2
  puts "#{n} squared is #{squared}"
end
```

> **📘 Python Note:** This replaces Python's explicit for loops. `[1, 2, 3].each { |n| puts n }` is like `for n in [1, 2, 3]: print(n)` but more functional.

### Writing Methods That Accept Blocks

```ruby
def repeat(n)
  n.times do |i|
    yield i if block_given?
  end
end

repeat(3) { |i| puts "Count: #{i}" }
# Output:
# Count: 0
# Count: 1
# Count: 2
```

> **📘 Python Note:** In Python, you'd pass a callback function explicitly: `repeat(3, lambda i: print(f"Count: {i}"))`. Ruby's implicit block passing is cleaner.

### Block Parameters

```ruby
# Capturing the block as a Proc
def execute(&block)
  puts "Before block"
  block.call("Hello") if block
  puts "After block"
end

execute { |msg| puts msg }
# Output:
# Before block
# Hello
# After block
```

## 📝 Procs: Blocks as Objects

Procs are objects that wrap blocks, allowing them to be stored, passed around, and called later.

```ruby
# Creating a Proc
doubler = Proc.new { |x| x * 2 }
puts doubler.call(5)  # => 10

# Proc from a block
def make_proc(&block)
  block  # The &block converts it to a Proc
end

my_proc = make_proc { |x| x + 1 }
puts my_proc.call(5)  # => 6

# Storing Procs in data structures
operations = {
  double: Proc.new { |x| x * 2 },
  triple: Proc.new { |x| x * 3 },
  square: Proc.new { |x| x ** 2 }
}

puts operations[:double].call(5)  # => 10
puts operations[:square].call(5)  # => 25
```

> **📘 Python Note:** This is like storing lambda functions in dictionaries: `operations = {'double': lambda x: x * 2}`. Ruby's syntax is more verbose but more consistent with the language.

### Proc Characteristics

```ruby
# Procs are lenient with arguments
lenient = Proc.new { |a, b, c| puts "a=#{a}, b=#{b}, c=#{c}" }
lenient.call(1)        # a=1, b=, c= (no error!)
lenient.call(1, 2)     # a=1, b=2, c=
lenient.call(1, 2, 3)  # a=1, b=2, c=3

# Procs return from the method they were defined in
def test_proc_return
  my_proc = Proc.new { return "from proc" }
  my_proc.call
  "after proc"  # This never executes!
end

puts test_proc_return  # => "from proc"
```

## 📝 Lambdas: Stricter Procs

Lambdas are like Procs but with stricter behavior around arguments and returns.

```ruby
# Creating lambdas (two syntaxes)
multiply = lambda { |x, y| x * y }
add = ->(x, y) { x + y }  # Stabby lambda (preferred)

puts multiply.call(3, 4)  # => 12
puts add.call(5, 2)       # => 7

# Lambdas check argument count strictly
strict = lambda { |a, b| puts "a=#{a}, b=#{b}" }
# strict.call(1)  # ArgumentError!
strict.call(1, 2)  # Works

# Lambdas return to the lambda itself
def test_lambda_return
  my_lambda = lambda { return "from lambda" }
  result = my_lambda.call
  "after lambda: #{result}"
end

puts test_lambda_return  # => "after lambda: from lambda"
```

> **📘 Python Note:** Ruby lambdas are most similar to Python's `lambda` or `def` functions. The key difference is Ruby lambdas can be multi-line and more powerful.

## 📝 Blocks vs Procs vs Lambdas Comparison

| Feature | Block | Proc | Lambda |
|---------|-------|------|--------|
| Object? | No (syntax) | Yes | Yes (special Proc) |
| Stored in variable? | No | Yes | Yes |
| Argument strictness | N/A | Lenient | Strict |
| Return behavior | Returns from method | Returns from method | Returns from lambda |
| Syntax | `{ }` or `do...end` | `Proc.new { }` | `lambda { }` or `->() { }` |

```ruby
# Demonstrating the differences
def demo_differences
  # Block - can't store directly
  [1, 2, 3].each { |n| puts n }

  # Proc - lenient arguments, returns from method
  my_proc = Proc.new { |a, b| puts "Proc: #{a}, #{b}" }
  my_proc.call(1)  # Works! b is nil

  # Lambda - strict arguments, returns to caller
  my_lambda = ->(a, b) { puts "Lambda: #{a}, #{b}" }
  # my_lambda.call(1)  # Error! Must provide both arguments
  my_lambda.call(1, 2)  # Works
end
```

## 📝 Practical Applications

### 1. Custom Iterators

```ruby
class CustomCollection
  def initialize(*items)
    @items = items
  end

  def each(&block)
    @items.each { |item| block.call(item) }
  end

  def map(&block)
    results = []
    each { |item| results << block.call(item) }
    results
  end
end

collection = CustomCollection.new(1, 2, 3, 4)
collection.each { |n| puts n * 2 }
doubled = collection.map { |n| n * 2 }
puts doubled.inspect  # => [2, 4, 6, 8]
```

### 2. Callbacks and Event Handlers

```ruby
class EventEmitter
  def initialize
    @listeners = {}
  end

  def on(event, &handler)
    @listeners[event] ||= []
    @listeners[event] << handler
  end

  def emit(event, *args)
    return unless @listeners[event]
    @listeners[event].each { |handler| handler.call(*args) }
  end
end

emitter = EventEmitter.new
emitter.on(:user_login) { |user| puts "#{user} logged in!" }
emitter.on(:user_login) { |user| puts "Welcome, #{user}!" }
emitter.emit(:user_login, "Alice")
```

### 3. Lazy Evaluation

```ruby
# Creating a lazy evaluator
def lazy_compute(&computation)
  # Returns a lambda that will compute when called
  lambda { computation.call }
end

expensive_calc = lazy_compute do
  puts "Computing..."
  sleep(1)
  42 * 42
end

puts "Created lazy computation"
puts "Result: #{expensive_calc.call}"  # Computes here
puts "Result again: #{expensive_calc.call}"  # Computes again
```

### 4. Method Factories

```ruby
def make_multiplier(factor)
  lambda { |x| x * factor }
end

double = make_multiplier(2)
triple = make_multiplier(3)

puts double.call(5)  # => 10
puts triple.call(5)  # => 15
```

> **📘 Python Note:** This is exactly like Python's closure pattern:
> ```python
> def make_multiplier(factor):
>     return lambda x: x * factor
> ```

## 📝 Advanced Patterns

### Converting Between Types

```ruby
# Block to Proc (with &)
def takes_proc(proc)
  proc.call(5)
end

takes_proc(lambda { |x| x * 2 })  # => 10

# Using & to convert symbol to proc
numbers = [1, 2, 3, 4, 5]
puts numbers.map(&:to_s).inspect  # => ["1", "2", "3", "4", "5"]

# This is shorthand for:
# numbers.map { |n| n.to_s }
```

> **📘 Python Note:** The `&:to_s` pattern has no direct Python equivalent. It's Ruby magic that converts `:to_s` to `{ |obj| obj.to_s }`.

### Block + Arguments

```ruby
def with_timing(*args, &block)
  start = Time.now
  result = block.call(*args)
  elapsed = Time.now - start
  puts "Took #{elapsed} seconds"
  result
end

result = with_timing(10, 20) { |a, b| a + b }
puts "Result: #{result}"
```

### Closure Gotchas

```ruby
# Variable capture
def create_lambdas
  lambdas = []

  # Be careful with loop variables!
  for i in 1..3
    lambdas << lambda { puts i }
  end

  lambdas
end

lambdas = create_lambdas
lambdas.each { |l| l.call }  # All print 4! (loop variable issue)

# Solution: use .each or pass as parameter
def create_lambdas_correctly
  (1..3).map { |i| lambda { puts i } }
end

lambdas = create_lambdas_correctly
lambdas.each { |l| l.call }  # Prints 1, 2, 3 correctly
```

> **📘 Python Note:** This is similar to the classic Python closure gotcha with list comprehensions. Ruby's `.each` handles it better than `for`.

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/11-Advanced-Blocks-Procs-Lambdas/exercises/closures_practice.rb
```

## 📚 What You Learned

✅ Difference between blocks, procs, and lambdas
✅ How closures capture variables
✅ When to use `yield` vs `block.call`
✅ Argument handling differences (lenient vs strict)
✅ Return behavior differences
✅ Converting between block types
✅ Practical patterns: callbacks, iterators, lazy evaluation

## 🔜 Next Steps

**Next tutorial: 12-Ruby-Object-Model** - Dive deep into Ruby's object model, understanding `self`, inheritance hierarchy, and singleton classes.

## 💡 Key Takeaways for Python Developers

1. **Blocks are everywhere**: Ruby uses blocks for iteration instead of explicit for loops
2. **Three types**: Blocks (syntax), Procs (lenient), Lambdas (strict)
3. **Symbol to Proc**: `&:method_name` is powerful Ruby magic
4. **Closures**: Both languages support closures, but Ruby makes them more central
5. **Return behavior**: Procs return from the enclosing method, lambdas return to caller

## 🆘 Common Pitfalls

### Pitfall 1: For loops capture variables wrong
```ruby
# Wrong
lambdas = []
for i in 1..3
  lambdas << lambda { i }  # All reference same i!
end

# Right
lambdas = (1..3).map { |i| lambda { i } }
```

### Pitfall 2: Proc vs Lambda return
```ruby
def test
  Proc.new { return "early" }.call
  "never reached"
end
# Returns "early" - Proc returns from method!

def test2
  lambda { return "from lambda" }.call
  "reached"
end
# Returns "reached" - lambda returns to caller
```

### Pitfall 3: Block vs Proc argument passing
```ruby
# Wrong - can't pass block and proc separately
# some_method { |x| ... } (proc)

# Right - use & to convert
some_method(&proc)
```

## 📖 Additional Resources

- [Ruby Closures Explained](https://www.rubyguides.com/2016/02/ruby-procs-and-lambdas/)
- [Understanding Blocks, Procs and Lambdas](https://www.honeybadger.io/blog/ruby-blocks-procs-lambdas/)
- [Ruby Documentation: Proc](https://ruby-doc.org/core-3.4.0/Proc.html)

---

Ready to practice? Run the exercises and experiment with closures!
