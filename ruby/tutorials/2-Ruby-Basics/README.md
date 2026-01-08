# Tutorial 2: Ruby Basics - Syntax, Variables, and Data Types

Welcome to your second Ruby tutorial! This guide introduces Ruby's fundamental syntax and data types, with special attention to how they differ from Python.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Ruby's naming conventions and style
- Work with Ruby's basic data types
- Master variable declaration and scope
- Understand symbols (Ruby's unique feature)
- Use string interpolation effectively
- Recognize key syntax differences from Python

## 🐍➡️🔴 Coming from Python

If you're a Python developer, you'll notice several differences:

| Concept | Python | Ruby |
|---------|--------|------|
| Variable naming | `snake_case` | `snake_case` (same!) |
| Constants | `UPPER_CASE` (convention) | `UPPER_CASE` (enforced) |
| String interpolation | `f"{var}"` or `"{}".format()` | `"#{var}"` |
| Null value | `None` | `nil` |
| Boolean | `True`/`False` | `true`/`false` |
| Comments | `# comment` | `# comment` (same!) |
| Multi-line comments | `"""..."""` (docstring) | `=begin...=end` (rarely used) |
| Type checking | `type()` | `.class` |
| Truthiness | `0`, `[]`, `""` are falsy (most other values are truthy) | Only `false` and `nil` are falsy |

## 📝 Ruby Syntax Essentials

### Variables

Ruby uses different naming conventions for different types of variables:

```ruby
# Local variables - snake_case
user_name = "Alice"
total_count = 42

# Constants - UPPER_CASE (Ruby warns if you change them)
MAX_SIZE = 100
API_KEY = "abc123"

# Instance variables - @prefix
@user_email = "alice@example.com"

# Class variables - @@prefix
@@total_users = 0
```

> **📘 Python Note:** Unlike Python, Ruby enforces constant naming. Trying to reassign a constant will generate a warning (but still works, unlike truly immutable languages).

### Data Types

#### Numbers

```ruby
# Integers - no size limit!
small = 42
big = 123_456_789_012_345  # underscores for readability

# Floats
pi = 3.14159
scientific = 1.5e10

# Type conversion
"42".to_i        # => 42
"3.14".to_f      # => 3.14
42.to_s          # => "42"
3.14.to_s        # => "3.14"
```

> **📘 Python Note:** Ruby uses `.to_i`, `.to_f`, `.to_s` for conversion instead of Python's `int()`, `float()`, `str()`. The "to_" prefix makes it read more naturally: "convert to integer".

#### Strings

```ruby
# Single vs double quotes
single = 'Hello'          # No interpolation
double = "Hello, #{name}" # Interpolation works

# Multi-line strings
heredoc = <<~TEXT
  This is a multi-line string.
  It preserves formatting.
  The ~TEXT squiggly heredoc removes leading indentation.
TEXT

# Common string methods
"hello".upcase          # => "HELLO"
"WORLD".downcase        # => "world"
"ruby".capitalize       # => "Ruby"
"hello".length          # => 5
"hello".reverse         # => "olleh"
"  trim  ".strip        # => "trim"
```

> **📘 Python Note:** Ruby's string interpolation `#{}` is more concise than Python's f-strings `f"{var}"`. Also, Ruby strings are mutable (unlike Python 3), though this rarely matters in practice.

#### Symbols

Symbols are a unique Ruby feature - they're immutable, reusable identifiers:

```ruby
# Symbols start with a colon
status = :active
direction = :north

# They're memory-efficient - same symbol = same object ID
:hello.object_id == :hello.object_id  # => true
"hello".object_id == "hello".object_id  # => false

# Common use cases
user = { name: "Alice", role: :admin }  # Hash keys
```

> **📘 Python Note:** Python doesn't have symbols. Think of them as lightweight, immutable strings optimized for use as identifiers. They're commonly used for hash keys, method names, and status values. Ruby developers use symbols where Python developers might use string constants or enums.

#### Booleans and Nil

```ruby
# Boolean values (lowercase!)
is_active = true
is_deleted = false

# Nil (like Python's None)
nothing = nil

# Checking for nil
value = nil
value.nil?      # => true
value == nil    # => true

# Truthiness - KEY DIFFERENCE FROM PYTHON!
# Only false and nil are falsy
# Everything else is truthy (including 0, "", [])

if 0
  puts "This runs! 0 is truthy in Ruby"
end

if []
  puts "This runs! Empty array is truthy in Ruby"
end

if ""
  puts "This runs! Empty string is truthy in Ruby"
end
```

> **📘 Python Note:** This is a MAJOR difference! In Python, `0`, `""`, `[]`, and `{}` are falsy. In Ruby, ONLY `false` and `nil` are falsy. This can catch Python developers off guard!

### Operators

```ruby
# Arithmetic (same as Python)
10 + 5    # => 15
10 - 5    # => 5
10 * 5    # => 50
10 / 5    # => 2
10 % 3    # => 1
10 ** 2   # => 100 (exponentiation)

# String concatenation
"Hello" + " " + "World"   # => "Hello World"
"Ruby" * 3                # => "RubyRubyRuby"

# Comparison (same as Python)
5 == 5    # => true
5 != 3    # => true
5 > 3     # => true
5 <= 5    # => true

# Logical operators
true && false   # => false (and)
true || false   # => true (or)
!true          # => false (not)

# Ruby also supports word operators (more readable)
true and false  # => false
true or false   # => true
not true        # => false
```

> **📘 Python Note:** Ruby has both symbolic (`&&`, `||`, `!`) and word operators (`and`, `or`, `not`). The symbolic versions have higher precedence and are more commonly used. Python only has word operators.

## ✍️ Exercises

Ready to practice? Let's solidify your understanding with hands-on exercises!

### Exercise 1: Variables and Data Types

Learn Ruby's variable conventions and type system.

👉 **[Start Exercise 1: Variables and Types](exercises/1-variables-and-types.md)**

In this exercise, you'll:
- Declare and use different types of variables
- Practice type conversions
- Explore Ruby's truthiness rules
- Compare with Python's behavior

### Exercise 2: Strings and Symbols

Master Ruby's string manipulation and symbols.

👉 **[Start Exercise 2: Strings and Symbols](exercises/2-strings-and-symbols.md)**

In this exercise, you'll:
- Practice string interpolation
- Use common string methods
- Understand when to use symbols vs strings
- Create reusable string templates

### Exercise 3: Basic Calculator

Build a simple calculator to practice operators and type conversion.

👉 **[Start Exercise 3: Basic Calculator](exercises/3-basic-calculator.md)**

In this exercise, you'll:
- Combine multiple concepts
- Get user input and convert types
- Perform calculations
- Format output nicely

## 📚 What You Learned

After completing the exercises, you will know:

✅ Ruby's variable naming conventions and types
✅ How to work with numbers, strings, and symbols
✅ Ruby's truthiness rules (only `false` and `nil` are falsy)
✅ String interpolation with `#{}`
✅ Type conversion methods (`.to_i`, `.to_f`, `.to_s`)
✅ Key differences between Ruby and Python syntax

## 🔜 Next Steps

Congratulations on completing the Ruby Basics tutorial! You now understand:
- Ruby's fundamental syntax and style
- Variable types and naming conventions
- Basic data types and their methods
- Critical differences from Python

You're ready to learn about control flow!

**Next tutorial: 3-Control-Flow** (coming soon)

## 💡 Key Takeaways for Python Developers

1. **Truthiness**: Remember, only `false` and `nil` are falsy in Ruby!
2. **Symbols**: Use symbols for identifiers and hash keys - they're memory-efficient
3. **String Interpolation**: `#{}` is your friend - cleaner than f-strings
4. **Everything is an object**: Even numbers have methods: `5.times { puts "Hi" }`
5. **Convention over configuration**: Ruby has strong style conventions - follow them!

## 🆘 Common Pitfalls

### Pitfall 1: Truthiness
```ruby
# Python developer might expect this to be false
items = []
if items
  puts "This WILL run! Empty array is truthy in Ruby!"
end

# Instead, check explicitly
if items.empty?
  puts "This is the Ruby way"
end
```

### Pitfall 2: Constants are mutable
```ruby
MAX_SIZE = 100
MAX_SIZE = 200  # Warning, but still works!

# Use frozen arrays/hashes for true immutability
COLORS = ["red", "green", "blue"].freeze
```

### Pitfall 3: String concatenation vs interpolation
```ruby
# Works, but not idiomatic
message = "Hello, " + name + "!"

# Better - more readable
message = "Hello, #{name}!"
```

## 📖 Additional Resources

- [Ruby Data Types Documentation](https://ruby-doc.org/core-3.4.0/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [Ruby vs Python: A Comparison](https://www.ruby-lang.org/en/)

---

Ready to get started? Begin with **[Exercise 1: Variables and Types](exercises/1-variables-and-types.md)**!
