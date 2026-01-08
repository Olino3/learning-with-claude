# Exercise 3: Basic Calculator

In this exercise, you'll build a simple calculator that combines variables, type conversion, string interpolation, and user input.

## 🎯 Objective

Create a functional calculator script that demonstrates Ruby basics in action.

## 📋 What You'll Learn

- How to get user input in Ruby
- Type conversion in practice
- String interpolation for output formatting
- Combining multiple Ruby concepts
- Error handling basics

## 🚀 Steps

### Step 1: Understanding User Input

Ruby uses `gets` to get input from the user:

```ruby
# Start IRB
make repl

# Try getting input
puts "What's your name?"
name = gets

# Notice it includes the newline!
# Use chomp to remove it
puts "What's your name?"
name = gets.chomp

puts "Hello, #{name}!"
```

> **📘 Python Note:** Ruby's `gets` is like Python's `input()`, but it includes the trailing newline character. Always use `.chomp` to remove it (like `.rstrip('\n')` in Python).

### Step 2: Getting Numeric Input

```ruby
# String to number conversion
puts "Enter a number:"
num_string = gets.chomp
num = num_string.to_i

puts "You entered: #{num} (#{num.class})"

# Or chain it
puts "Enter another number:"
num2 = gets.chomp.to_i

# Perform calculation
result = num + num2
puts "#{num} + #{num2} = #{result}"
```

### Step 3: Build a Simple Calculator

Create a file `ruby/tutorials/2-Ruby-Basics/exercises/calculator.rb` with this starter code:

```ruby
#!/usr/bin/env ruby
# Simple Calculator

puts "=== Simple Calculator ==="
puts

# Get first number
puts "Enter first number:"
num1 = gets.chomp.to_f

# Get second number
puts "Enter second number:"
num2 = gets.chomp.to_f

# Perform calculations
sum = num1 + num2
difference = num1 - num2
product = num1 * num2
quotient = num1 / num2

# Display results
puts
puts "Results:"
puts "#{num1} + #{num2} = #{sum}"
puts "#{num1} - #{num2} = #{difference}"
puts "#{num1} × #{num2} = #{product}"
puts "#{num1} ÷ #{num2} = #{quotient}"
```

Try running it:
```bash
make run-script SCRIPT=ruby/tutorials/2-Ruby-Basics/exercises/calculator.rb
```

### Step 4: Add Operation Selection

Enhance your calculator to let users choose the operation:

```ruby
#!/usr/bin/env ruby
# Calculator with Operation Selection

puts "=== Calculator ==="
puts

# Get numbers
puts "Enter first number:"
num1 = gets.chomp.to_f

puts "Enter second number:"
num2 = gets.chomp.to_f

# Get operation
puts
puts "Select operation:"
puts "1. Addition (+)"
puts "2. Subtraction (-)"
puts "3. Multiplication (×)"
puts "4. Division (÷)"
puts "Enter choice (1-4):"
choice = gets.chomp.to_i

# Calculate based on choice
result = case choice
when 1
  num1 + num2
when 2
  num1 - num2
when 3
  num1 * num2
when 4
  num1 / num2
else
  puts "Invalid choice!"
  exit
end

# Display result
operation = ['+', '-', '×', '÷'][choice - 1]
puts
puts "Result: #{num1} #{operation} #{num2} = #{result}"
```

> **📘 Python Note:** Ruby's `case/when` is like Python's `switch/case` (Python 3.10+) or `if/elif/else` chains. Each `when` returns a value, making it easy to assign results.

### Step 5: Add Input Validation

Make it more robust:

```ruby
#!/usr/bin/env ruby
# Calculator with Validation

def get_number(prompt)
  puts prompt
  input = gets.chomp

  # Validate it's a number
  if input.match?(/^-?\d+\.?\d*$/)
    input.to_f
  else
    puts "Error: '#{input}' is not a valid number"
    nil
  end
end

puts "=== Validated Calculator ==="
puts

# Get numbers with validation
num1 = get_number("Enter first number:")
exit unless num1

num2 = get_number("Enter second number:")
exit unless num2

# Rest of your calculator code...
```

> **📘 Python Note:** Ruby's regex support is built-in with `match?` method. This is similar to Python's `re.match()` but more integrated into the language.

### Step 6: Complete the Challenge

Edit the challenge file and implement the advanced calculator:

```bash
# Edit the file
ruby/tutorials/2-Ruby-Basics/exercises/calculator_challenge.rb

# Run it
make run-script SCRIPT=ruby/tutorials/2-Ruby-Basics/exercises/calculator_challenge.rb
```

**Challenge requirements:**
1. Support basic operations (+, -, *, /)
2. Validate numeric input
3. Handle division by zero
4. Allow multiple calculations (loop until user quits)
5. Format output nicely
6. Add extra operations (power, modulo, square root)

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can get user input with `gets.chomp`
- [ ] You can convert strings to numbers with `.to_i` and `.to_f`
- [ ] You can use `case/when` for selection
- [ ] You've built a working calculator
- [ ] You've added input validation
- [ ] You've handled edge cases (division by zero)

## 🎓 Key Takeaways

**User Input:**
```ruby
# ✅ Always chomp to remove newline
name = gets.chomp

# ✅ Convert to appropriate type
age = gets.chomp.to_i
price = gets.chomp.to_f

# ❌ Forgetting chomp
name = gets  # Includes "\n"!
```

**Type Conversion:**
```ruby
# String to number
"42".to_i      # => 42
"3.14".to_f    # => 3.14

# Number to string
42.to_s        # => "42"

# Invalid conversions
"abc".to_i     # => 0 (no exception!)
"abc".to_f     # => 0.0
```

**Case/When:**
```ruby
# ✅ Ruby style
result = case choice
when 1
  "First"
when 2
  "Second"
else
  "Other"
end

# ✅ Can also use in statement form
case choice
when 1
  puts "First"
when 2
  puts "Second"
end
```

## 🐛 Common Mistakes

**Mistake 1: Forgetting to chomp**
```ruby
# ❌ Has newline
age = gets.to_i  # Input: "25\n"

# ✅ Correct
age = gets.chomp.to_i
```

**Mistake 2: Not handling invalid input**
```ruby
# ❌ Assumes valid input
num = gets.chomp.to_i  # "abc" becomes 0!

# ✅ Validate first
input = gets.chomp
if input.match?(/^\d+$/)
  num = input.to_i
else
  puts "Invalid input"
end
```

**Mistake 3: Division by zero**
```ruby
# ❌ Will crash
result = num1 / num2  # Error if num2 is 0

# ✅ Check first
if num2.zero?
  puts "Cannot divide by zero"
else
  result = num1 / num2
end
```

## 🎉 Congratulations!

You've built a working calculator using Ruby basics! You now know how to:
- Get and validate user input
- Convert between types
- Use case/when for control flow
- Handle errors gracefully
- Format output nicely

## 🔜 Next Steps

You've completed Tutorial 2: Ruby Basics! You now have a solid foundation in:
- Variables and data types
- Strings and symbols
- Type conversion
- User input and output

**Next tutorial: 3-Control-Flow** - Learn about conditionals, loops, and iteration in Ruby!

## 💡 Pro Tips

- Always validate user input in real programs
- Use `.to_f` for calculations to avoid integer division surprises
- The `case/when` statement returns the value of the matching branch
- Use regex for robust input validation
- Remember that `.to_i` and `.to_f` return 0 for invalid input
- Add helpful error messages for better user experience

## 🎯 Bonus Challenges

If you want more practice:

1. **Scientific Calculator**: Add sin, cos, tan, log functions
2. **History**: Store and display previous calculations
3. **Variables**: Let users store results in named variables
4. **Expression Parser**: Evaluate strings like "2 + 3 * 4"
5. **Unit Converter**: Convert between units (miles to km, etc.)
