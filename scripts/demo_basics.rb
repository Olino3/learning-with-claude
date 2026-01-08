#!/usr/bin/env ruby
# Demonstrates basic Ruby features

puts "=" * 50
puts "Ruby Basics Demo"
puts "=" * 50
puts ""

# Variables and strings
name = "Ruby Learner"
puts "1. Variables and Strings:"
puts "   Hello, #{name}!"
puts ""

# Arrays
puts "2. Arrays:"
fruits = ["apple", "banana", "orange"]
puts "   Fruits: #{fruits.join(", ")}"
puts "   First fruit: #{fruits.first}"
puts ""

# Hashes
puts "3. Hashes:"
person = { name: "Alice", age: 30, language: "Ruby" }
puts "   Person: #{person}"
puts "   Name: #{person[:name]}"
puts ""

# Loops
puts "4. Iteration:"
puts "   Counting 1 to 5:"
(1..5).each do |num|
  puts "   - #{num}"
end
puts ""

# Methods
def greet(name)
  "Welcome to Ruby, #{name}!"
end

puts "5. Methods:"
puts "   #{greet("Developer")}"
puts ""

puts "=" * 50
puts "Demo complete! ✅"
puts "=" * 50
