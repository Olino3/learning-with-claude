#!/usr/bin/env ruby
# Control Flow Challenges

puts "=== Control Flow Challenges ==="
puts

# Challenge 1: FizzBuzz
puts "Challenge 1: FizzBuzz (1-30)"
puts "-" * 40

# TODO: Implement FizzBuzz for 1-30
1.upto(30) do |i|
  # Your code here
end

puts

# Challenge 2: Prime Number Checker
puts "Challenge 2: Prime Numbers 1-50"
puts "-" * 40

def prime?(n)
  # TODO: Return true if n is prime
  # Your code here
end

# TODO: Print all primes from 1 to 50

puts

# Challenge 3: Simple Gradebook
puts "Challenge 3: Student Gradebook"
puts "-" * 40

students = [
  { name: "Alice", scores: [85, 92, 78, 95] },
  { name: "Bob", scores: [92, 88, 95, 91] },
  { name: "Carol", scores: [78, 81, 85, 80] }
]

# TODO: For each student:
# - Calculate average
# - Assign letter grade
# - Print formatted output

puts

puts "=== Challenges Complete! ==="
