# Exercise 2: Strings and Symbols

In this exercise, you'll master Ruby's powerful string features and learn about symbols - a unique Ruby data type that Python doesn't have.

## 🎯 Objective

Learn Ruby's string manipulation capabilities and understand when to use symbols vs strings.

## 📋 What You'll Learn

- String interpolation with `#{}`
- Common string methods and operations
- What symbols are and why they're useful
- When to use symbols instead of strings
- Memory efficiency of symbols

## 🚀 Steps

### Step 1: Start Your REPL

```bash
make repl
```

### Step 2: String Interpolation

Ruby's interpolation is cleaner and more powerful than Python's f-strings:

```ruby
# Basic interpolation
name = "Alice"
age = 30

# Simple interpolation
puts "Hello, #{name}!"
puts "You are #{age} years old"

# Expression interpolation
puts "Next year you'll be #{age + 1}"

# Method calls in interpolation
puts "Your name uppercased: #{name.upcase}"

# Multiple variables
city = "Seattle"
puts "#{name} lives in #{city}"

# Complex expressions
items = [1, 2, 3]
puts "You have #{items.length} items: #{items.join(', ')}"
```

> **📘 Python Note:** Ruby's `#{}` can evaluate any expression, not just variables. It's like Python's f-strings but without the `f` prefix. Single quotes don't support interpolation (like Python's raw strings).

### Step 3: String Methods

Explore Ruby's rich string API:

```ruby
text = "hello world"

# Case conversion
text.upcase         # => "HELLO WORLD"
text.downcase       # => "hello world"
text.capitalize     # => "Hello world"
text.swapcase       # => "HELLO WORLD"

# Inspection
text.length         # => 11
text.size           # => 11 (alias for length)
text.empty?         # => false
text.include?("world")  # => true
text.start_with?("hello")  # => true
text.end_with?("world")    # => true

# Modification
text.reverse        # => "dlrow olleh"
text.strip          # Removes leading/trailing whitespace
text.chomp          # Removes trailing newline
text.gsub("world", "Ruby")  # => "hello Ruby"

# Splitting and joining
words = text.split(" ")  # => ["hello", "world"]
words.join("-")          # => "hello-world"

# Accessing characters
text[0]            # => "h"
text[-1]           # => "d"
text[0..4]         # => "hello"
text[6..-1]        # => "world"
```

> **📘 Python Note:** Ruby uses `?` suffix for predicate methods (methods that return true/false). Also, strings are indexed similarly to Python, including negative indices and ranges.

### Step 4: Multi-line Strings

Ruby has several ways to handle multi-line strings:

```ruby
# Using quotes (preserves newlines and indentation)
text1 = "Line 1
Line 2
Line 3"

# Heredoc (traditional)
text2 = <<TEXT
This is a multi-line string.
It preserves formatting.
TEXT

# Squiggly heredoc (removes leading indentation)
text3 = <<~TEXT
  This is indented in the code
  but the leading spaces are removed
  in the actual string!
TEXT

# Try them!
puts text1
puts "-" * 20
puts text2
puts "-" * 20
puts text3
```

> **📘 Python Note:** Python uses triple quotes `"""` for multi-line strings. Ruby's `<<~TEXT` heredoc is particularly useful as it removes leading indentation (similar to Python's `textwrap.dedent`).

### Step 5: Understanding Symbols

Symbols are immutable, reusable identifiers - a unique Ruby feature:

```ruby
# Creating symbols
status = :active
direction = :north
role = :admin

# Check the type
status.class  # => Symbol

# Symbols are immutable
status.to_s    # => "active" (convert to string)

# Converting between strings and symbols
:hello.to_s    # => "hello"
"hello".to_sym # => :hello
"hello".intern # => :hello (older alias)

# Memory efficiency - same symbol = same object
:hello.object_id == :hello.object_id   # => true
"hello".object_id == "hello".object_id # => false (different objects!)

# Check object IDs
puts "Symbol :hello object_id: #{:hello.object_id}"  # Same!
puts "String 'hello' object_id: #{'hello'.object_id}"
puts "String 'hello' object_id: #{'hello'.object_id}"  # Different!
```

> **📘 Python Note:** Python doesn't have symbols. Think of them as lightweight, immutable strings that are guaranteed to be the same object instance every time. They're commonly used for:
> - Hash keys (like dictionary keys in Python)
> - Method names
> - Constants/enumerations
> - Status values

### Step 6: When to Use Symbols vs Strings

```ruby
# ✅ Use SYMBOLS for:

# Hash keys (most common use case)
user = { name: "Alice", role: :admin, status: :active }

# Method names and identifiers
object.send(:method_name)

# Constants and enumerations
STATUS_ACTIVE = :active
STATUS_INACTIVE = :inactive

# ✅ Use STRINGS for:

# User input/output
puts "Hello, #{name}!"

# Text that changes or is manipulated
message = "Hello"
message.upcase!

# Data from external sources
content = File.read("file.txt")

# Rule of thumb:
# - Strings: Data that changes or is displayed to users
# - Symbols: Fixed identifiers in your code
```

### Step 7: String Mutability

Unlike Python 3, Ruby strings are mutable:

```ruby
# Mutable strings
text = "hello"
text.upcase!   # ! means "modify in place"
text           # => "HELLO" (changed!)

# Non-mutating versions (return new string)
text2 = "world"
text2.upcase   # => "WORLD"
text2          # => "world" (unchanged)

# This matters for memory and performance
big_string = "x" * 1000
big_string.upcase!   # Modifies in place (faster)
big_string = big_string.upcase  # Creates new string (slower, more memory)
```

> **📘 Python Note:** In Python 3, strings are immutable - you always get a new string. Ruby lets you modify strings in place with `!` methods (called "bang methods"). Generally prefer non-mutating versions unless performance is critical.

### Step 8: Run the Practice Script

Exit IRB and run the practice script:

```bash
make run-script SCRIPT=ruby/tutorials/2-Ruby-Basics/exercises/strings_practice.rb
```

### Step 9: Complete the Challenge

Edit and complete the challenge:

```bash
# Edit the file
ruby/tutorials/2-Ruby-Basics/exercises/strings_challenge.rb

# Run it
make run-script SCRIPT=ruby/tutorials/2-Ruby-Basics/exercises/strings_challenge.rb
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can use string interpolation with `#{}`
- [ ] You know common string methods (upcase, downcase, strip, etc.)
- [ ] You understand what symbols are and how they differ from strings
- [ ] You know when to use symbols vs strings
- [ ] You understand symbol memory efficiency
- [ ] You've completed the challenge script

## 🎓 Key Takeaways

**String Interpolation:**
```ruby
# ✅ Ruby way
"Hello, #{name}!"

# ❌ Not idiomatic (but works)
"Hello, " + name + "!"
```

**Symbols vs Strings:**
```ruby
# ✅ Symbols for identifiers
user = { name: "Alice", role: :admin }

# ✅ Strings for data
puts "Welcome, #{user[:name]}!"

# ❌ Don't use strings for hash keys (works but wasteful)
user = { "name" => "Alice", "role" => "admin" }  # Creates new strings each time
```

**Predicate Methods:**
```ruby
# Ruby convention: methods ending in ? return boolean
"".empty?           # => true
"hello".include?("e")  # => true
"test".start_with?("t")  # => true
```

## 🐛 Common Mistakes

**Mistake 1: Using single quotes for interpolation**
```ruby
name = "Alice"
puts 'Hello, #{name}!'  # => "Hello, #{name}!" (no interpolation!)
puts "Hello, #{name}!"  # => "Hello, Alice!" (correct)
```

**Mistake 2: Using strings instead of symbols for hash keys**
```ruby
# ❌ Less efficient
user = { "name" => "Alice" }

# ✅ More efficient and idiomatic
user = { name: "Alice" }  # Shorthand for { :name => "Alice" }
```

**Mistake 3: Forgetting symbols are immutable**
```ruby
status = :active
status.upcase!  # NoMethodError! Symbols can't be modified

# ✅ Convert to string first if you need to manipulate
status.to_s.upcase  # => "ACTIVE"
```

## 🎉 Congratulations!

You now understand Ruby's powerful string features and the unique symbol type! You know:
- How to use string interpolation effectively
- When to use symbols vs strings
- How to manipulate strings with Ruby's rich API

## 🔜 Next Steps

Move on to **Exercise 3: Basic Calculator** to combine everything you've learned!

## 💡 Pro Tips

- Use double quotes by default (allows interpolation)
- Use symbols for hash keys: `{ name: "Alice" }` is cleaner than `{ "name" => "Alice" }`
- Explore string methods: `"hello".methods.sort` to see all available methods
- Use heredocs for multi-line strings in code
- Remember: symbols are for identifiers, strings are for data
