#!/usr/bin/env ruby
# Advanced Calculator Challenge
# Build a full-featured calculator with validation and multiple operations

puts "=== Advanced Calculator Challenge ==="
puts

# TODO: Implement these functions

def get_number(prompt)
  # TODO: Get a number from user with validation
  # - Display the prompt
  # - Get input and chomp
  # - Validate it's a valid number (integer or float)
  # - Return the number as a float, or nil if invalid
  # Hint: Use regex /^-?\d+\.?\d*$/ to validate

  # Your code here:

end

def get_operation
  # TODO: Display menu and get operation choice
  # Operations:
  # 1. Addition (+)
  # 2. Subtraction (-)
  # 3. Multiplication (×)
  # 4. Division (÷)
  # 5. Power (^)
  # 6. Modulo (%)
  # 7. Square Root (√)
  # 8. Quit
  # Return the choice as an integer

  # Your code here:

end

def calculate(num1, num2, operation)
  # TODO: Perform the calculation based on operation
  # Handle special cases:
  # - Division by zero
  # - Square root of negative (for num1)
  # - Invalid operation
  # Return result or error message

  # Use case/when statement
  # Your code here:

end

def format_result(num1, num2, operation, result)
  # TODO: Format and return the result as a nice string
  # Examples:
  # "5.0 + 3.0 = 8.0"
  # "10.0 ÷ 2.0 = 5.0"
  # "√16.0 = 4.0"
  # "Error: Division by zero"

  # Your code here:

end

# Main calculator loop
# TODO: Implement the main loop
# 1. Get first number
# 2. Get operation (check if quit)
# 3. Get second number (if needed - not for square root)
# 4. Calculate result
# 5. Display formatted result
# 6. Ask if user wants to continue
# 7. Repeat or exit

# Uncomment and complete:
# loop do
#   # Your main calculator logic here
#
#   puts "\nContinue? (y/n)"
#   break unless gets.chomp.downcase == 'y'
# end

puts
puts "=== Challenge Instructions ==="
puts
puts "Your task:"
puts "1. Implement get_number with validation"
puts "2. Implement get_operation with menu"
puts "3. Implement calculate with all operations"
puts "4. Implement format_result for nice output"
puts "5. Create the main loop that ties it all together"
puts
puts "Bonus features:"
puts "- Store calculation history"
puts "- Allow using previous result as input"
puts "- Add more operations (sin, cos, log, etc.)"
puts "- Create a memory function (store/recall)"
puts
puts "Test your calculator thoroughly!"
puts "Handle edge cases:"
puts "- Division by zero"
puts "- Invalid input"
puts "- Square root of negative numbers"
puts "- Very large numbers"
