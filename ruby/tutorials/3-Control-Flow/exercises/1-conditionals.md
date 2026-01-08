# Exercise 1: Conditionals

In this exercise, you'll master Ruby's conditional statements including unique features like `unless` and statement modifiers.

## 🎯 Objective

Learn all of Ruby's conditional constructs and when to use each one.

## 📋 What You'll Learn

- If/elsif/else statements
- Unless for negative conditions
- Case/when for multi-way branching
- Statement modifiers for concise code
- Ternary operator
- How conditionals return values

## 🚀 Steps

### Step 1: Basic If/Elsif/Else

Start your REPL and experiment:

```bash
make repl
```

```ruby
# Simple if
age = 25

if age >= 18
  puts "You can vote"
end

# If/else
if age >= 21
  puts "You can drink (in US)"
else
  puts "Not yet"
end

# If/elsif/else
if age < 13
  puts "Child"
elsif age < 18
  puts "Teenager"
elsif age < 65
  puts "Adult"
else
  puts "Senior"
end
```

> **📘 Python Note:** Remember, it's `elsif` not `elif`! This is the #1 mistake Python developers make in Ruby.

### Step 2: Conditionals Return Values

```ruby
# If can assign a value
status = if age >= 18
  "adult"
else
  "minor"
end

puts status  # => "adult"

# Case also returns values
grade = 'B'
message = case grade
when 'A'
  "Excellent"
when 'B'
  "Good"
when 'C'
  "Fair"
else
  "Needs improvement"
end

puts message  # => "Good"
```

> **📘 Python Note:** In Python, you'd use a ternary or assign inside each branch. Ruby's if/case naturally return the last evaluated expression.

### Step 3: Unless (Inverse If)

```ruby
# Unless is "if not"
password = "secret123"

unless password.empty?
  puts "Password is set"
end

# Equivalent to:
if !password.empty?
  puts "Password is set"
end

# OR:
if password.empty? == false
  puts "Password is set"
end

# When to use unless:
# ✅ Good - simple negative check
proceed = true
puts "Stopping" unless proceed

# ❌ Bad - unless with else is confusing
unless age < 18
  puts "Adult"
else
  puts "Minor"  # Confusing!
end

# ✅ Better - use regular if
if age >= 18
  puts "Adult"
else
  puts "Minor"
end
```

> **📘 Python Note:** Python doesn't have `unless`. Use it in Ruby for simple negations where it reads more naturally. Think: "Do this unless that" vs "If not that, do this".

### Step 4: Statement Modifiers (Suffix Conditionals)

```ruby
# Put condition at the end for one-liners
logged_in = true
puts "Welcome back!" if logged_in

# With unless
dry_run = false
puts "Saving data..." unless dry_run

# Can be used with any statement
count = 5
count += 1 if count < 10
count -= 1 unless count <= 0

# Great for guard clauses
def process(data)
  return nil if data.nil?
  return [] if data.empty?
  # ... actual processing
end
```

> **📘 Python Note:** This is pure Ruby idiom. Python doesn't have statement modifiers. They make code read more naturally: "Save data unless dry run" vs "If not dry run, save data".

### Step 5: Case/When

```ruby
# Basic case/when
day = "Monday"

case day
when "Monday"
  puts "Start of week"
when "Friday"
  puts "TGIF!"
when "Saturday", "Sunday"  # Multiple values
  puts "Weekend!"
else
  puts "Midweek"
end

# With ranges
score = 85

letter_grade = case score
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

puts "Grade: #{letter_grade}"  # => "Grade: B"

# Case without a value (like if/elsif)
case
when score >= 90
  "A"
when score >= 80
  "B"
when score >= 70
  "C"
when score >= 60
  "D"
else
  "F"
end

# Case with regex
input = "hello@example.com"

case input
when /^\d+$/
  "Number"
when /@/
  "Email"
when /^https?:\/\//
  "URL"
else
  "Unknown"
end
```

> **📘 Python Note:** Ruby's case/when is more flexible than Python's match/case:
> - Works in all Ruby versions (Python needs 3.10+)
> - Supports ranges naturally
> - Can match with regex
> - Can be used without a comparison value

### Step 6: Ternary Operator

```ruby
# condition ? true_value : false_value
age = 25
status = age >= 18 ? "adult" : "minor"

# Good for simple cases
max = a > b ? a : b

# Can chain (but keep it readable!)
role = admin? ? "admin" : member? ? "member" : "guest"

# Often better as case for clarity
role = case
when admin?
  "admin"
when member?
  "member"
else
  "guest"
end
```

> **📘 Python Note:** Python uses `true_value if condition else false_value`. Ruby uses the traditional C-style `? :` syntax.

### Step 7: Comparison Operators in Conditionals

```ruby
# Standard comparisons
x = 10

if x > 5
  puts "Greater than 5"
end

if x >= 10
  puts "10 or more"
end

if x == 10
  puts "Exactly 10"
end

if x != 10
  puts "Not 10"
end

# Spaceship operator (returns -1, 0, or 1)
1 <=> 2   # => -1 (less than)
2 <=> 2   # => 0 (equal)
3 <=> 2   # => 1 (greater than)

# Pattern matching (Ruby 2.7+)
case [1, 2, 3]
in [1, 2, 3]
  puts "Exact match"
in [1, *, 3]
  puts "Starts with 1, ends with 3"
end
```

### Step 8: Run the Practice Script

Exit IRB and run the practice script:

```bash
make run-script SCRIPT=ruby/tutorials/3-Control-Flow/exercises/conditionals_practice.rb
```

### Step 9: Complete the Challenge

Edit and complete the challenge:

```bash
# Edit the file
ruby/tutorials/3-Control-Flow/exercises/conditionals_challenge.rb

# Run it
make run-script SCRIPT=ruby/tutorials/3-Control-Flow/exercises/conditionals_challenge.rb
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can write if/elsif/else statements
- [ ] You remember to use `elsif` (not `elif`!)
- [ ] You understand when to use `unless`
- [ ] You can use statement modifiers for concise code
- [ ] You can use case/when for multi-way branching
- [ ] You know conditionals return values
- [ ] You've completed the challenge script

## 🎓 Key Takeaways

**If/Elsif/Else:**
```ruby
# ✅ Ruby style
if condition1
  action1
elsif condition2
  action2
else
  action3
end

# ✅ Can assign
result = if condition
  "yes"
else
  "no"
end
```

**Unless:**
```ruby
# ✅ Good - simple negation
proceed unless error

# ✅ Good - guard clause
return if data.nil?

# ❌ Avoid - confusing with else
unless condition
  something
else
  something_else  # Hard to reason about
end
```

**Case/When:**
```ruby
# ✅ Multiple values
case day
when "Sat", "Sun"
  "Weekend"
end

# ✅ Ranges
case age
when 0..12
  "Child"
when 13..17
  "Teen"
end

# ✅ No value (like if/elsif)
case
when x > 10
  "Big"
when x > 5
  "Medium"
else
  "Small"
end
```

**Statement Modifiers:**
```ruby
# ✅ Idiomatic Ruby
puts "Hello" if logged_in
save_data unless dry_run
return nil if data.empty?

# Same as:
if logged_in
  puts "Hello"
end
```

## 🐛 Common Mistakes

**Mistake 1: Using elif**
```ruby
# ❌ Python syntax
if x < 0
  "negative"
elif x == 0  # SyntaxError!
  "zero"
end

# ✅ Correct
if x < 0
  "negative"
elsif x == 0  # Note: elsif
  "zero"
end
```

**Mistake 2: Unless with else**
```ruby
# ❌ Confusing
unless paid?
  puts "Please pay"
else
  puts "Thank you"  # Hard to parse mentally
end

# ✅ Use if instead
if paid?
  puts "Thank you"
else
  puts "Please pay"
end
```

**Mistake 3: Forgetting end**
```ruby
# ❌ Missing end
if condition
  do_something
# SyntaxError!

# ✅ Always use end
if condition
  do_something
end
```

## 🎉 Congratulations!

You now understand Ruby's conditional statements! You know:
- How to use if/elsif/else (with elsif not elif!)
- When to use unless vs if not
- How to write concise code with statement modifiers
- How to use case/when for multi-way branching

## 🔜 Next Steps

Move on to **Exercise 2: Loops and Iterators** to learn Ruby's iteration constructs!

## 💡 Pro Tips

- Use statement modifiers for guard clauses and simple conditions
- Prefer `unless` for simple negative conditions: `return unless valid?`
- Use case/when for 3+ branches instead of long if/elsif chains
- Remember conditionals return values - use it!
- Avoid `unless` with `else` - it's confusing
- Use `.nil?`, `.empty?`, `.zero?` etc. instead of comparing to nil/0/[]
