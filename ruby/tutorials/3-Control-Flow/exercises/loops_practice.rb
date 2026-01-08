#!/usr/bin/env ruby
# Loops and Iterators Practice

puts "=== Ruby Loops and Iterators ==="
puts

# Section 1: Traditional Loops (Less Common in Ruby)
puts "1. While and Until Loops"
puts "-" * 40

count = 0
puts "While loop:"
while count < 3
  puts "  Count: #{count}"
  count += 1
end

count = 0
puts "Until loop:"
until count >= 3
  puts "  Count: #{count}"
  count += 1
end
puts

# Section 2: Times Iterator (Idiomatic)
puts "2. Times Iterator"
puts "-" * 40

puts "Basic times:"
3.times do
  puts "  Hello!"
end

puts "With index:"
5.times do |i|
  puts "  Index: #{i}"
end
puts

# Section 3: Each Iterator
puts "3. Each Iterator"
puts "-" * 40

fruits = ["apple", "banana", "orange"]
puts "Iterate over array:"
fruits.each do |fruit|
  puts "  - #{fruit}"
end

puts "With index:"
fruits.each_with_index do |fruit, index|
  puts "  #{index + 1}. #{fruit}"
end
puts

# Section 4: Map (Transform)
puts "4. Map - Transform Elements"
puts "-" * 40

numbers = [1, 2, 3, 4, 5]
puts "Original: #{numbers.inspect}"

doubled = numbers.map { |n| n * 2 }
puts "Doubled: #{doubled.inspect}"

squared = numbers.map { |n| n ** 2 }
puts "Squared: #{squared.inspect}"

words = ["hello", "world"]
uppercased = words.map { |w| w.upcase }
puts "Uppercased: #{uppercased.inspect}"
puts

# Section 5: Select and Reject (Filter)
puts "5. Select and Reject - Filter Elements"
puts "-" * 40

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
puts "Original: #{numbers.inspect}"

evens = numbers.select { |n| n.even? }
puts "Even numbers: #{evens.inspect}"

odds = numbers.reject { |n| n.even? }
puts "Odd numbers: #{odds.inspect}"

greater_than_5 = numbers.select { |n| n > 5 }
puts "Greater than 5: #{greater_than_5.inspect}"
puts

# Section 6: Loop Control
puts "6. Loop Control (break, next)"
puts "-" * 40

puts "Using break:"
10.times do |i|
  break if i == 5
  puts "  #{i}"
end

puts "Using next:"
10.times do |i|
  next if i % 2 == 0  # Skip even numbers
  puts "  #{i}"
end
puts

# Section 7: Range Iteration
puts "7. Range Iteration"
puts "-" * 40

puts "Range 1..5 (inclusive):"
(1..5).each { |i| print "#{i} " }
puts

puts "Range 1...5 (exclusive):"
(1...5).each { |i| print "#{i} " }
puts "\n"

puts "Upto:"
1.upto(5) { |i| print "#{i} " }
puts

puts "Downto:"
5.downto(1) { |i| print "#{i} " }
puts

puts "Step:"
0.step(10, 2) { |i| print "#{i} " }
puts "\n"

# Section 8: Method Chaining
puts "8. Method Chaining"
puts "-" * 40

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
puts "Original: #{numbers.inspect}"

result = numbers
  .select { |n| n.even? }
  .map { |n| n * 2 }
puts "Select evens, then double: #{result.inspect}"

sum = numbers
  .select { |n| n > 5 }
  .map { |n| n ** 2 }
  .reduce(0) { |sum, n| sum + n }
puts "Sum of squares > 5: #{sum}"
puts

# Section 9: Real-world Example
puts "9. Real-world Example: Data Processing"
puts "-" * 40

users = [
  { name: "Alice", age: 30, active: true },
  { name: "Bob", age: 25, active: false },
  { name: "Carol", age: 35, active: true },
  { name: "Dave", age: 28, active: true }
]

active_user_names = users
  .select { |user| user[:active] }
  .map { |user| user[:name] }

puts "Active users: #{active_user_names.join(', ')}"

average_age = users
  .map { |user| user[:age] }
  .reduce(:+) / users.length.to_f

puts "Average age: #{average_age.round(1)}"
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways:"
puts "1. Use .times instead of while loops for counting"
puts "2. Use .each for iteration (not for loops)"
puts "3. Use .map to transform, .select/.reject to filter"
puts "4. Chain methods for readable data pipelines"
puts "5. break = exit, next = continue (Python)"
