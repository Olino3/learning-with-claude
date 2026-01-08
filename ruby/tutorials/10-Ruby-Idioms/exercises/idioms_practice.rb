#!/usr/bin/env ruby
# Ruby Idioms Practice

puts "=== Ruby Idioms ==="
puts

# Idiomatic Ruby patterns
numbers = [1, 2, 3, 4, 5]

# Use symbols for hash keys
user = { name: "Alice", age: 30, active: true }
puts "User: #{user}"

# Prefer iterators
puts "\nNumbers doubled:"
numbers.each { |n| puts "  #{n * 2}" }

# Method chaining
result = numbers
  .select { |n| n > 2 }
  .map { |n| n ** 2 }
  .reduce(:+)

puts "\nChained result: #{result}"

# Statement modifiers
puts "Active user!" if user[:active]

# Safe navigation
puts "\nSafe navigation:"
puts user&.fetch(:email, "no email")

puts "\n=== All Tutorials Complete! ==="
puts "You've mastered Ruby basics!"
