#!/usr/bin/env ruby
# Exercise 2: Simple Calculator
# Create a calculator that performs basic operations on two numbers

# TODO: Define two numbers
num1 = 10
num2 = 5

# TODO: Calculate and print the sum
puts "Sum: #{num1} + #{num2} = #{num1 + num2}"

# TODO: Calculate and print the difference
puts "Difference: #{num1} - #{num2} = #{num1 - num2}"

# TODO: Calculate and print the product
puts "Product: #{num1} × #{num2} = #{num1 * num2}"

# TODO: Calculate and print the quotient
puts "Quotient: #{num1} ÷ #{num2} = #{num1 / num2}"

# BONUS: Use methods for each operation
def add(a, b)
  a + b
end

def subtract(a, b)
  a - b
end

def multiply(a, b)
  a * b
end

def divide(a, b)
  a / b
end

puts "\n--- Using Methods ---"
puts "Sum: #{add(num1, num2)}"
puts "Difference: #{subtract(num1, num2)}"
puts "Product: #{multiply(num1, num2)}"
puts "Quotient: #{divide(num1, num2)}"
