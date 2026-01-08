# Exercise 3: Control Flow Challenges

Apply your knowledge of conditionals and loops to solve classic programming challenges!

## 🎯 Challenges

### Challenge 1: FizzBuzz

The classic programming challenge - implement it the Ruby way!

```ruby
# Print numbers 1-100, but:
# - "Fizz" if divisible by 3
# - "Buzz" if divisible by 5
# - "FizzBuzz" if divisible by both
# - The number otherwise

1.upto(100) do |i|
  # Your solution here
end
```

### Challenge 2: Number Guessing Game

```ruby
# User guesses a random number
# Provide "higher" or "lower" hints
# Count number of guesses

secret = rand(1..100)
attempts = 0

# Your game loop here
```

### Challenge 3: Gradebook

```ruby
students = [
  { name: "Alice", scores: [85, 92, 78] },
  { name: "Bob", scores: [92, 88, 95] },
  { name: "Carol", scores: [78, 81, 85] }
]

# Calculate average grade for each student
# Assign letter grades
# Find top student
```

Run and complete:

```bash
make run-script SCRIPT=ruby/tutorials/3-Control-Flow/exercises/challenges.rb
```

## 🎉 Complete Tutorial 3!

Congratulations! You've mastered Ruby's control flow!

**Next: Tutorial 4 - Methods and Blocks**
