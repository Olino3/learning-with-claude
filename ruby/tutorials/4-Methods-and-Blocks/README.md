# Tutorial 4: Methods and Blocks - Ruby's Unique Approach

Welcome to Tutorial 4! This guide covers Ruby's methods, blocks, procs, and lambdas - featuring blocks, which Python doesn't have!

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Define and call methods in Ruby
- Understand method parameters (required, optional, keyword, splat)
- Master blocks - Ruby's unique feature
- Work with Procs and Lambdas
- Use yield to call blocks
- Understand closures and scope

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| Define method | `def name(params):` | `def name(params)` `end` |
| Optional params | `def f(x=1):` | `def f(x=1)` |
| Keyword args | `def f(*, x):` | `def f(x:)` |
| Variable args | `*args` | `*args` |
| Keyword args | `**kwargs` | `**kwargs` |
| Return | `return x` | `return x` or implicit |
| Blocks | Lambda/closure | `do...end` or `{...}` |
| Anonymous func | `lambda x: x*2` | `->(x) { x*2 }` |

## 📝 Methods

### Basic Methods

```ruby
# Simple method
def greet
  puts "Hello!"
end

greet  # Call without parentheses

# With parameters
def greet(name)
  puts "Hello, #{name}!"
end

greet("Alice")
greet "Alice"  # Parentheses optional

# Return values (implicit last expression)
def add(a, b)
  a + b  # Implicit return
end

result = add(5, 3)  # => 8

# Explicit return
def subtract(a, b)
  return a - b
end
```

> **📘 Python Note:** Ruby methods implicitly return the last evaluated expression. `return` is optional (but useful for early returns).

### Method Parameters

```ruby
# Optional parameters (with defaults)
def greet(name = "Guest")
  "Hello, #{name}!"
end

greet           # => "Hello, Guest!"
greet("Alice")  # => "Hello, Alice!"

# Keyword arguments
def create_user(name:, email:, age: 18)
  { name: name, email: email, age: age }
end

create_user(name: "Alice", email: "alice@example.com")
create_user(name: "Bob", email: "bob@example.com", age: 25)

# Splat operator (*args)
def sum(*numbers)
  numbers.reduce(0, :+)
end

sum(1, 2, 3, 4, 5)  # => 15

# Double splat (**kwargs)
def user_info(**details)
  details
end

user_info(name: "Alice", age: 30, city: "Seattle")

# Mixing parameter types
def complex_method(required, optional = "default", *args, keyword:, **kwargs)
  # ...
end
```

> **📘 Python Note:** Similar to Python, but Ruby's keyword args use `:` syntax. The splat and double-splat work the same way.

## 🎯 Blocks - Ruby's Unique Feature

Blocks are chunks of code that can be passed to methods. This is Ruby's most distinctive feature!

### Block Basics

```ruby
# Block with do...end (multi-line)
[1, 2, 3].each do |num|
  puts num * 2
end

# Block with {...} (single-line)
[1, 2, 3].each { |num| puts num * 2 }

# Blocks are not objects (unlike everything else in Ruby!)
# They're part of method syntax
```

> **📘 Python Note:** Python doesn't have blocks. The closest equivalent is passing lambda functions, but Ruby blocks are more powerful and integrated into the language.

### Yield - Calling Blocks

```ruby
def my_method
  puts "Before yield"
  yield  # Call the block
  puts "After yield"
end

my_method { puts "In the block!" }

# With parameters
def repeat(n)
  n.times { |i| yield i }
end

repeat(3) { |i| puts "Count: #{i}" }

# Check if block given
def maybe_yield
  if block_given?
    yield
  else
    puts "No block provided"
  end
end

maybe_yield { puts "Block!" }  # => "Block!"
maybe_yield                    # => "No block provided"
```

### Block Parameters

```ruby
# Single parameter
[1, 2, 3].map { |n| n * 2 }

# Multiple parameters
{a: 1, b: 2}.each { |key, value| puts "#{key}: #{value}" }

# Block-local variables
[1, 2, 3].each do |n; temp|
  temp = n * 2  # temp is block-local
  puts temp
end
```

## 🔧 Procs and Lambdas

When you need to store blocks as objects, use Procs or Lambdas:

```ruby
# Proc - block as an object
my_proc = Proc.new { |x| x * 2 }
my_proc.call(5)  # => 10

# Lambda - stricter proc
my_lambda = ->(x) { x * 2 }
my_lambda.call(5)  # => 10

# Or
my_lambda = lambda { |x| x * 2 }

# Difference: argument checking
proc = Proc.new { |x, y| x + y }
proc.call(1)  # => NoMethodError (y is nil)

lam = ->(x, y) { x + y }
lam.call(1)   # => ArgumentError (wrong number of arguments)

# Difference: return behavior
def proc_return
  my_proc = Proc.new { return "from proc" }
  my_proc.call
  "from method"  # Never reached
end

def lambda_return
  my_lambda = -> { return "from lambda" }
  my_lambda.call
  "from method"  # This is returned
end
```

> **📘 Python Note:**
> - Lambdas are like Python's lambda but more powerful (multi-line, statements)
> - Procs are like Python functions/callables
> - Use lambdas when you want strict argument checking (like Python)
> - Use procs when you want flexible arguments

### Passing Blocks as Parameters

```ruby
# Explicit block parameter with &
def my_method(&block)
  block.call if block
end

my_method { puts "Hello!" }

# Converting between blocks and procs
def method_with_block(&block)
  block.call
end

my_proc = Proc.new { puts "I'm a proc!" }
method_with_block(&my_proc)  # & converts proc to block
```

## ✍️ Exercises

### Exercise 1: Methods Mastery

Learn all about Ruby methods and parameters.

👉 **[Start Exercise 1: Methods](exercises/1-methods.md)**

### Exercise 2: Blocks, Procs, and Lambdas

Master Ruby's unique block feature.

👉 **[Start Exercise 2: Blocks](exercises/2-blocks.md)**

## 📚 What You Learned

✅ How to define and call methods
✅ Method parameter types (required, optional, keyword, splat)
✅ Blocks - do...end vs {...}
✅ Using yield to call blocks
✅ Procs and Lambdas
✅ The & operator for block conversion

## 🔜 Next Steps

**Next tutorial: 5-Collections** - Arrays and Hashes

## 💡 Key Takeaways for Python Developers

1. **Implicit return**: Last expression is returned automatically
2. **Blocks are everywhere**: Most Ruby methods accept blocks
3. **do...end vs {...}**: Use do...end for multi-line, {...} for single-line
4. **Lambda vs Proc**: Lambda is stricter (like Python functions)
5. **yield**: Calls the block passed to a method
6. **Closures**: Blocks, procs, and lambdas can access outer variables

## 📖 Additional Resources

- [Ruby Blocks](https://www.rubyguides.com/2016/02/ruby-procs-and-lambdas/)
- [Methods in Ruby](https://ruby-doc.org/core-3.4.0/doc/syntax/methods_rdoc.html)

---

Ready to master methods and blocks? Begin with **[Exercise 1: Methods](exercises/1-methods.md)**!
