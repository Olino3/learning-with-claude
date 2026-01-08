# Exercise 2: Loops and Iterators

In this exercise, you'll master Ruby's idiomatic iteration using iterators instead of traditional loops.

## 🎯 Objective

Learn Ruby's iteration patterns and when to use each construct.

## 📋 What You'll Learn

- While and until loops
- Ruby iterators (.each, .times, .map, .select)
- Loop control (break, next, redo)
- Range iteration
- Method chaining

## 🚀 Steps

### Step 1: While and Until

```bash
make repl
```

```ruby
# While loop
count = 0
while count < 5
  puts count
  count += 1
end

# Until loop (inverse while)
count = 0
until count >= 5
  puts count
  count += 1
end

# Infinite loop with break
loop do
  puts "Running..."
  break if rand(10) > 8
end
```

> **📘 Python Note:** Python doesn't have `until`. It's `while not condition`. Ruby also has a dedicated `loop` method for infinite loops.

### Step 2: Ruby Iterators (The Idiomatic Way)

```ruby
# Times - cleaner than while
5.times do |i|
  puts "Count: #{i}"
end

# Each - most common iterator
["apple", "banana", "orange"].each do |fruit|
  puts fruit
end

# Each with index
["apple", "banana"].each_with_index do |fruit, i|
  puts "#{i}: #{fruit}"
end

# Map - transform elements
numbers = [1, 2, 3, 4, 5]
doubled = numbers.map { |n| n * 2 }  # => [2, 4, 6, 8, 10]

# Select - filter elements
evens = numbers.select { |n| n.even? }  # => [2, 4]

# Reject - inverse filter
odds = numbers.reject { |n| n.even? }  # => [1, 3, 5]
```

> **📘 Python Note:**
> - Ruby's `.times` = Python's `for i in range(5):`
> - Ruby's `.each` = Python's `for item in list:`
> - Ruby's `.map` = Python's `[x*2 for x in numbers]`
> - Ruby's `.select` = Python's `[x for x in numbers if condition]`

### Step 3: Loop Control

```ruby
# Break - exit loop
5.times do |i|
  break if i == 3
  puts i
end  # Prints: 0, 1, 2

# Next - skip to next iteration (like Python's continue)
5.times do |i|
  next if i == 2
  puts i
end  # Prints: 0, 1, 3, 4

# Redo - restart current iteration (rare)
i = 0
5.times do
  puts i
  i += 1
  redo if i == 2 && !@done  # Be careful!
end
```

### Step 4: Range Iteration

```ruby
# Ranges with each
(1..5).each { |i| puts i }     # 1, 2, 3, 4, 5
(1...5).each { |i| puts i }    # 1, 2, 3, 4

# Upto and downto
1.upto(5) { |i| puts i }       # 1, 2, 3, 4, 5
5.downto(1) { |i| puts i }     # 5, 4, 3, 2, 1

# Step
0.step(10, 2) { |i| puts i }   # 0, 2, 4, 6, 8, 10
```

### Step 5: Method Chaining

```ruby
# Chain multiple operations
result = [1, 2, 3, 4, 5, 6]
  .select { |n| n.even? }      # => [2, 4, 6]
  .map { |n| n * 2 }           # => [4, 8, 12]
  .reduce(:+)                  # => 24

# More readable with newlines
numbers = [1, 2, 3, 4, 5]
result = numbers
  .select { |n| n > 2 }
  .map { |n| n ** 2 }
  .reduce(0) { |sum, n| sum + n }
```

Run the practice script:

```bash
make run-script SCRIPT=ruby/tutorials/3-Control-Flow/exercises/loops_practice.rb
```

Complete the challenge:

```bash
ruby/tutorials/3-Control-Flow/exercises/loops_challenge.rb
```

## ✅ Success Criteria

- [ ] You can use .times, .each, .each_with_index
- [ ] You can use .map, .select, .reject
- [ ] You understand break and next
- [ ] You can chain iterator methods
- [ ] You prefer iterators over while loops

## 🎓 Key Takeaways

**Use Iterators, Not Loops:**
```ruby
# ❌ Python/C style (works but not idiomatic)
i = 0
while i < 5
  puts i
  i += 1
end

# ✅ Ruby style
5.times { |i| puts i }

# ❌ Not idiomatic
for i in 0..4
  puts i
end

# ✅ Ruby style
(0..4).each { |i| puts i }
```

**Map, Select, Reject:**
```ruby
numbers = [1, 2, 3, 4, 5]

# Transform
doubled = numbers.map { |n| n * 2 }

# Filter
evens = numbers.select { |n| n.even? }
odds = numbers.reject { |n| n.even? }

# Chain them
result = numbers
  .select { |n| n > 2 }
  .map { |n| n * 2 }
```

## 🎉 Congratulations!

You now know Ruby's idiomatic iteration patterns!

## 🔜 Next Steps

Move on to **Exercise 3: Control Flow Challenges** to practice combining concepts!
