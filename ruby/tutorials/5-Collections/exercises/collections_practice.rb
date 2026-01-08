#!/usr/bin/env ruby
# Collections Practice

puts "=== Arrays and Hashes ==="
puts

# Arrays
numbers = [1, 2, 3, 4, 5]
puts "Numbers: #{numbers}"
puts "Doubled: #{numbers.map { |n| n * 2 }}"
puts "Evens: #{numbers.select { |n| n.even? }}"
puts "Sum: #{numbers.reduce(:+)}"

# Hashes
user = { name: "Alice", age: 30, city: "Seattle" }
puts "\nUser: #{user}"
puts "Name: #{user[:name]}"
puts "Keys: #{user.keys}"
puts "Values: #{user.values}"

# Nested collections
users = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 },
  { name: "Carol", age: 35 }
]

names = users.map { |u| u[:name] }
puts "\nAll names: #{names.join(', ')}"

adults = users.select { |u| u[:age] >= 30 }
puts "Adults: #{adults.map { |u| u[:name] }.join(', ')}"

puts "\n=== Practice Complete ==="
