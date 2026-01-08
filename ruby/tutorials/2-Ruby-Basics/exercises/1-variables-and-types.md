# Exercise 1: Variables and Types

In this exercise, you'll explore Ruby's variable types and type system, with special attention to differences from Python.

## 🎯 Objective

Understand Ruby's variable conventions, data types, and truthiness rules.

## 📋 What You'll Learn

- How to declare and use variables in Ruby
- Ruby's type conversion methods
- The crucial difference in truthiness between Ruby and Python
- How to check types and values

## 🚀 Steps

### Step 1: Start Your REPL

Make sure your environment is running and start IRB:

```bash
make repl
```

### Step 2: Experiment with Variables

Try these commands in IRB to see how Ruby handles variables:

**Basic Variables:**

```ruby
# Declare variables (no special keyword needed, unlike Python's potential type hints)
name = "Alice"
age = 30
height = 5.6
is_active = true

# Check the values
name
age
height
is_active
```

**Type Checking:**

```ruby
# Check types using .class (like Python's type())
name.class      # => String
age.class       # => Integer
height.class    # => Float
is_active.class # => TrueClass

# Ruby's class hierarchy
42.class.superclass           # => Integer
42.class.superclass.superclass # => Numeric
```

> **📘 Python Note:** In Python you'd use `type(name)`. In Ruby, every object has a `.class` method. Also, `True` and `False` are instances of `bool` in Python, but in Ruby they have their own classes: `TrueClass` and `FalseClass`.

### Step 3: Type Conversion Practice

Ruby's conversion methods are more explicit than Python's:

```ruby
# String to number
"42".to_i        # => 42
"3.14".to_f      # => 3.14
"hello".to_i     # => 0 (invalid strings become 0, not error!)

# Number to string
42.to_s          # => "42"
3.14.to_s        # => "3.14"

# Try invalid conversions
"abc123".to_i    # => 0 (stops at first non-digit)
"123abc".to_i    # => 123 (converts until it hits non-digit)
"  42  ".to_i    # => 42 (strips whitespace)
```

> **📘 Python Note:** Unlike Python's `int("hello")` which raises a `ValueError`, Ruby's `.to_i` returns `0` for invalid strings. This is more forgiving but can hide bugs - be careful!

### Step 4: The Truthiness Test (Critical!)

This is where Ruby differs significantly from Python:

```ruby
# In Python, these are ALL falsy: 0, "", [], {}, None, False
# In Ruby, ONLY false and nil are falsy!

# Test numeric zero
if 0
  puts "Zero is truthy in Ruby!"
end

# Test empty string
if ""
  puts "Empty string is truthy in Ruby!"
end

# Test empty array
if []
  puts "Empty array is truthy in Ruby!"
end

# Only false and nil are falsy
if false
  puts "This won't run"
end

if nil
  puts "This won't run either"
end

# Checking for empty collections the Ruby way
items = []
if items.empty?
  puts "This is how you check for empty in Ruby"
end

text = ""
if text.empty?
  puts "Same for strings"
end
```

### Step 5: Working with Nil

```ruby
# Nil is Ruby's null value (like Python's None)
value = nil

# Check for nil
value.nil?       # => true
value == nil     # => true

# Nil has methods (everything is an object!)
nil.class        # => NilClass
nil.to_s         # => ""
nil.to_i         # => 0
nil.to_a         # => []

# Safe navigation operator (new in Ruby 2.3)
user = nil
user&.name       # => nil (doesn't crash!)
# vs
# user.name      # => NoMethodError

# Nil coalescing
name = nil
display_name = name || "Guest"  # => "Guest"
```

> **📘 Python Note:** Ruby's `&.` is like Python's walrus operator or optional chaining. The `||` operator is commonly used for default values, similar to `or` in Python but more idiomatic in Ruby.

### Step 6: Constants

```ruby
# Constants start with uppercase (UPPER_CASE by convention)
MAX_USERS = 100
PI = 3.14159

# Ruby warns if you reassign (but allows it)
MAX_USERS = 200  # => warning: already initialized constant MAX_USERS

# Freeze for true immutability
COLORS = ["red", "green", "blue"].freeze
COLORS << "yellow"  # => RuntimeError: can't modify frozen Array
```

### Step 7: Run the Practice Script

Exit IRB (`exit` or Ctrl+D) and run the practice script:

```bash
make run-script SCRIPT=ruby/tutorials/2-Ruby-Basics/exercises/variables_practice.rb
```

This script demonstrates all the concepts you learned interactively.

### Step 8: Complete the Challenge

Open the challenge script and complete the TODOs:

```bash
# Edit the file
ruby/tutorials/2-Ruby-Basics/exercises/variables_challenge.rb

# Run it to test
make run-script SCRIPT=ruby/tutorials/2-Ruby-Basics/exercises/variables_challenge.rb
```

**Challenge tasks:**
1. Create variables of each type (String, Integer, Float, Boolean, Nil)
2. Implement a type conversion function
3. Create a truthiness checker that behaves like Ruby
4. Fix common Python-to-Ruby conversion bugs

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can declare variables of different types
- [ ] You understand `.to_i`, `.to_f`, `.to_s` conversions
- [ ] You know that only `false` and `nil` are falsy in Ruby
- [ ] You can check for nil using `.nil?`
- [ ] You can use `.empty?` to check for empty collections
- [ ] You've completed the challenge script successfully

## 🎓 Key Takeaways

**Critical Differences from Python:**

1. **Truthiness**: Only `false` and `nil` are falsy - this is the #1 gotcha!
2. **Type conversion**: `.to_i` returns 0 for invalid strings (doesn't raise exception)
3. **Constants**: Warning only, not enforced (use `.freeze` for immutability)
4. **Everything is an object**: Even `nil` has methods!

**Ruby Idioms:**

```ruby
# ❌ Python style (works but not idiomatic)
if items.length == 0:
    print("Empty")

# ✅ Ruby style (idiomatic)
if items.empty?
  puts "Empty"
end

# ❌ Not needed in Ruby
if value != nil

# ✅ Ruby way
if value
  # value is neither false nor nil
end

# Or explicitly
if value.nil?
  # value is nil
end
```

## 🐛 Common Mistakes

**Mistake 1: Assuming Python's truthiness**
```ruby
# ❌ Wrong assumption from Python
items = []
if not items:  # This won't work - items is truthy!
  puts "Empty"

# ✅ Correct
if items.empty?
  puts "Empty"
end
```

**Mistake 2: Expecting exceptions on invalid conversions**
```ruby
# ❌ Assuming Python behavior
age = "abc".to_i  # Returns 0, doesn't raise exception!

# ✅ Validate input
age = "abc"
if age.to_i.to_s == age  # Round-trip check
  puts "Valid number"
else
  puts "Invalid number"
end

# Or use Integer() for strict conversion
begin
  age = Integer("abc")  # Raises ArgumentError
rescue ArgumentError
  puts "Invalid number"
end
```

## 🎉 Congratulations!

You now understand Ruby's type system and the critical truthiness difference from Python! This knowledge will prevent many bugs as you continue learning.

## 🔜 Next Steps

Move on to **Exercise 2: Strings and Symbols** to learn about Ruby's powerful string features and unique symbol type!

## 💡 Pro Tips

- Use `.inspect` or `.p` to debug values: `p value` shows type info
- Use `.methods` to discover what you can do: `"hello".methods`
- IRB is your friend - experiment freely!
- When in doubt about truthiness, remember: **only false and nil are falsy**
