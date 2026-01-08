#!/usr/bin/env ruby
# Simple Calculator Example

puts "=== Simple Calculator ==="
puts

# Get first number
puts "Enter first number:"
num1 = gets.chomp.to_f

# Get second number
puts "Enter second number:"
num2 = gets.chomp.to_f

# Perform calculations
sum = num1 + num2
difference = num1 - num2
product = num1 * num2

# Handle division by zero
if num2.zero?
  quotient = "undefined (division by zero)"
else
  quotient = num1 / num2
end

# Display results
puts
puts "Results:"
puts "#{num1} + #{num2} = #{sum}"
puts "#{num1} - #{num2} = #{difference}"
puts "#{num1} × #{num2} = #{product}"
puts "#{num1} ÷ #{num2} = #{quotient}"
puts

puts "Calculator complete!"
