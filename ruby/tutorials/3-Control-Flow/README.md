# Tutorial 3: Control Flow - Conditionals and Loops

Welcome to Tutorial 3! This guide covers Ruby's control flow structures, with special attention to Ruby-specific features that Python doesn't have.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master Ruby's conditional statements (if/elsif/else, unless, case/when)
- Understand Ruby's unique loop constructs (while, until, loop)
- Use Ruby's powerful iterators (.each, .times, .map, etc.)
- Learn statement modifiers for concise code
- Recognize key differences from Python's control flow

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| If/else | `if:` `elif:` `else:` | `if` `elsif` `else` `end` |
| Switch | `match/case` (3.10+) | `case/when/else/end` |
| Inverse if | N/A | `unless/else/end` |
| Ternary | `x if condition else y` | `condition ? x : y` |
| For loop | `for x in list:` | `array.each do \|x\|` |
| While | `while:` | `while/end` |
| Inverse while | N/A | `until/end` |
| Break/Continue | `break`/`continue` | `break`/`next` |
| Statement modifier | N/A | `do_something if condition` |

## 📝 Conditional Statements

### If/Elsif/Else

```ruby
# Basic if
age = 25

if age >= 18
  puts "Adult"
end

# If/else
if age >= 18
  puts "Adult"
else
  puts "Minor"
end

# If/elsif/else (note: elsif, not elif!)
if age < 13
  puts "Child"
elsif age < 18
  puts "Teenager"
else
  puts "Adult"
end

# If returns a value!
status = if age >= 18
  "adult"
else
  "minor"
end
```

> **📘 Python Note:**
> - Ruby uses `elsif`, not `elif`
> - Ruby uses `end` instead of indentation to close blocks
> - Ruby's `if` returns a value (last expression evaluated), allowing assignment

### Unless (Ruby's Inverse If)

```ruby
# Unless is "if not"
password = "secret"

unless password.empty?
  puts "Password is set"
end

# Equivalent to:
if !password.empty?
  puts "Password is set"
end

# Unless/else (confusing - avoid!)
unless age < 18
  puts "Adult"
else
  puts "Minor"  # This is confusing!
end
```

> **📘 Python Note:** Python doesn't have `unless`. It's syntactic sugar for `if not`. Use it for simple negations, but avoid `unless/else` as it's confusing (use regular `if` instead).

### Statement Modifiers (Suffix Conditionals)

```ruby
# Put the condition at the end for simple statements
puts "Welcome!" if logged_in
save_data unless dry_run

# This is idiomatic Ruby for one-line conditionals
# Equivalent to:
if logged_in
  puts "Welcome!"
end

unless dry_run
  save_data
end
```

> **📘 Python Note:** Python doesn't have statement modifiers. This is a popular Ruby idiom that makes code read more naturally: "Do this if that" vs "if that, do this".

### Case/When

```ruby
# Case/when (like Python's match/case or if/elif chains)
grade = 'B'

case grade
when 'A'
  puts "Excellent!"
when 'B'
  puts "Good job!"
when 'C'
  puts "Acceptable"
when 'D'
  puts "Needs improvement"
else
  puts "Failed"
end

# Case returns a value
result = case grade
when 'A'
  "Excellent"
when 'B', 'C'  # Multiple values
  "Passing"
else
  "Failing"
end

# Case with ranges
score = 85

message = case score
when 90..100
  "A"
when 80..89
  "B"
when 70..79
  "C"
when 60..69
  "D"
else
  "F"
end

# Case without a value (like if/elsif)
age = 25

case
when age < 13
  "Child"
when age < 18
  "Teen"
when age < 65
  "Adult"
else
  "Senior"
end
```

> **📘 Python Note:** Ruby's `case/when` is more powerful than Python's `match/case`:
> - Works in older Ruby versions (Python needs 3.10+)
> - Supports ranges natively
> - Returns values naturally
> - Can be used without a value (like if/elsif)

### Ternary Operator

```ruby
# condition ? true_value : false_value
status = age >= 18 ? "adult" : "minor"

# Can be nested (but keep it simple!)
access = admin? ? "full" : member? ? "limited" : "none"

# Often better as regular if for clarity
access = if admin?
  "full"
elsif member?
  "limited"
else
  "none"
end
```

> **📘 Python Note:** Python's ternary is `true_value if condition else false_value`. Ruby uses the traditional C-style `? :` syntax.

## 🔄 Loops and Iteration

### While Loop

```ruby
# While loop
count = 0
while count < 5
  puts count
  count += 1
end

# While as modifier
count += 1 while count < 10

# While can return a value
result = while count < 5
  count += 1
end  # Returns nil
```

### Until Loop (Inverse While)

```ruby
# Until is "while not"
count = 0
until count >= 5
  puts count
  count += 1
end

# Equivalent to:
while count < 5
  puts count
  count += 1
end

# Until as modifier
count += 1 until count >= 10
```

> **📘 Python Note:** Python doesn't have `until`. It's `while not condition`. Use `until` when the negation reads more naturally.

### Infinite Loops

```ruby
# Loop method (infinite loop)
loop do
  puts "This runs forever"
  break if some_condition
end

# While true (also works)
while true
  puts "This runs forever"
  break if some_condition
end
```

### Loop Control

```ruby
# break - exit the loop
5.times do |i|
  break if i == 3
  puts i
end  # Prints 0, 1, 2

# next - skip to next iteration (like Python's continue)
5.times do |i|
  next if i == 2
  puts i
end  # Prints 0, 1, 3, 4

# redo - restart current iteration (rare)
5.times do |i|
  puts i
  redo if i == 2 && !@done  # Be careful - infinite loop risk!
end
```

> **📘 Python Note:** Ruby's `next` is Python's `continue`. Ruby also has `redo` which Python lacks - it restarts the current iteration (use carefully!).

## 🎯 Ruby Iterators (The Idiomatic Way)

Ruby developers rarely use `while` or `for` loops. Instead, use iterators:

### Times

```ruby
# Print "Hello" 5 times
5.times do
  puts "Hello"
end

# With index
5.times do |i|
  puts "Count: #{i}"  # 0, 1, 2, 3, 4
end

# One-liner with braces
5.times { |i| puts i }
```

> **📘 Python Note:** Python would use `for i in range(5):`. Ruby's `.times` is more readable and intention-revealing.

### Each (Most Common Iterator)

```ruby
# Iterate over array
fruits = ["apple", "banana", "orange"]

fruits.each do |fruit|
  puts fruit
end

# With index
fruits.each_with_index do |fruit, index|
  puts "#{index}: #{fruit}"
end

# One-liner
fruits.each { |fruit| puts fruit }
```

> **📘 Python Note:** Similar to Python's `for fruit in fruits:`, but `.each` is a method call, not a language keyword. Ruby also has `.each_with_index` built-in (vs Python's `enumerate()`).

### Map/Select/Reject

```ruby
numbers = [1, 2, 3, 4, 5]

# Map - transform each element (like Python's map or list comprehension)
doubled = numbers.map { |n| n * 2 }
# => [2, 4, 6, 8, 10]

# Select - filter elements (like Python's filter or list comprehension with if)
evens = numbers.select { |n| n.even? }
# => [2, 4]

# Reject - opposite of select
odds = numbers.reject { |n| n.even? }
# => [1, 3, 5]

# Chaining
result = numbers
  .select { |n| n > 2 }
  .map { |n| n * 2 }
# => [6, 8, 10]
```

> **📘 Python Note:**
> - Ruby's `.map` = Python's `[x*2 for x in numbers]`
> - Ruby's `.select` = Python's `[x for x in numbers if condition]`
> - Ruby's `.reject` = Python's `[x for x in numbers if not condition]`
> - Method chaining is more common in Ruby than nested comprehensions

### Range Iteration

```ruby
# Upto
1.upto(5) { |i| puts i }      # 1, 2, 3, 4, 5

# Downto
5.downto(1) { |i| puts i }    # 5, 4, 3, 2, 1

# Step
0.step(10, 2) { |i| puts i }  # 0, 2, 4, 6, 8, 10

# Range with each
(1..5).each { |i| puts i }    # 1, 2, 3, 4, 5
(1...5).each { |i| puts i }   # 1, 2, 3, 4 (exclusive)
```

> **📘 Python Note:**
> - `1.upto(5)` is like Python's `range(1, 6)`
> - `1..5` is inclusive (like `range(1, 6)`)
> - `1...5` is exclusive (like `range(1, 5)`)

## ✍️ Exercises

Master control flow with hands-on practice!

### Exercise 1: Conditionals and Branching

Learn Ruby's conditional statements and unique features.

👉 **[Start Exercise 1: Conditionals](exercises/1-conditionals.md)**

In this exercise, you'll:
- Practice if/elsif/else statements
- Use unless for negative conditions
- Master case/when for multi-way branching
- Use statement modifiers for clean code

### Exercise 2: Loops and Iteration

Explore Ruby's looping constructs and iterators.

👉 **[Start Exercise 2: Loops and Iterators](exercises/2-loops-and-iterators.md)**

In this exercise, you'll:
- Use while and until loops
- Master Ruby iterators (.each, .times, .map)
- Practice loop control (break, next)
- Learn when to use each construct

### Exercise 3: FizzBuzz and Beyond

Apply control flow to classic programming challenges.

👉 **[Start Exercise 3: Control Flow Challenges](exercises/3-control-flow-challenges.md)**

In this exercise, you'll:
- Implement FizzBuzz the Ruby way
- Build a number guessing game
- Create a grade calculator
- Practice combining conditionals and loops

## 📚 What You Learned

After completing the exercises, you will know:

✅ Ruby's conditional statements (if/elsif/else, unless, case/when)
✅ Statement modifiers for concise code
✅ Looping with while, until, and loop
✅ Ruby iterators (.each, .times, .map, .select)
✅ Loop control with break and next
✅ When to use each control flow construct

## 🔜 Next Steps

Congratulations on completing the Control Flow tutorial! You now understand:
- All of Ruby's conditional statements
- Ruby-specific features like unless and statement modifiers
- The idiomatic way to iterate in Ruby
- How control flow differs from Python

You're ready to learn about methods and blocks!

**Next tutorial: 4-Methods-and-Blocks** (coming soon)

## 💡 Key Takeaways for Python Developers

1. **Use `elsif`, not `elif`**: Common typo for Python developers!
2. **Embrace iterators**: `.each`, `.times`, `.map` instead of `for` loops
3. **Statement modifiers**: `do_something if condition` is idiomatic
4. **Unless for negatives**: `unless error` reads better than `if !error`
5. **Everything returns a value**: `if`, `case`, etc. can be assigned
6. **Ranges are powerful**: `(1..10).each`, `when 90..100`

## 🆘 Common Pitfalls

### Pitfall 1: Using elif instead of elsif
```ruby
# ❌ Wrong - Python syntax
if x < 0
  "negative"
elif x == 0  # SyntaxError!
  "zero"
end

# ✅ Correct - Ruby syntax
if x < 0
  "negative"
elsif x == 0
  "zero"
end
```

### Pitfall 2: Using for loops instead of iterators
```ruby
# ❌ Works but not idiomatic
for i in 0..4
  puts i
end

# ✅ Ruby way
5.times { |i| puts i }

# or
(0..4).each { |i| puts i }
```

### Pitfall 3: Confusing unless/else
```ruby
# ❌ Confusing - avoid unless/else
unless condition
  do_something
else
  do_other_thing  # Hard to reason about
end

# ✅ Use regular if
if condition
  do_other_thing
else
  do_something
end
```

### Pitfall 4: Forgetting end keyword
```ruby
# ❌ Missing end
if condition
  do_something
# SyntaxError!

# ✅ Always close with end
if condition
  do_something
end
```

## 📖 Additional Resources

- [Ruby Control Expressions](https://ruby-doc.org/core-3.4.0/doc/syntax/control_expressions_rdoc.html)
- [Ruby Iterators Guide](https://www.rubyguides.com/ruby-tutorial/loops/)
- [Ruby Style Guide - Conditionals](https://rubystyle.guide/#no-nested-conditionals)

---

Ready to master control flow? Begin with **[Exercise 1: Conditionals](exercises/1-conditionals.md)**!
