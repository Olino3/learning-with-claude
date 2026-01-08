#!/usr/bin/env ruby
# Conditionals Challenge

puts "=== Conditionals Challenge ==="
puts

# Challenge 1: Grade Calculator
puts "Challenge 1: Grade Calculator with Case/When"
puts "-" * 40

def calculate_grade(score)
  # TODO: Return letter grade based on score
  # 90-100: A
  # 80-89: B
  # 70-79: C
  # 60-69: D
  # Below 60: F
  # Invalid (< 0 or > 100): "Invalid score"

  # Use case/when with ranges
  # Your code here:

end

# Test cases (uncomment when ready):
# puts "Score 95: #{calculate_grade(95)}"   # => "A"
# puts "Score 87: #{calculate_grade(87)}"   # => "B"
# puts "Score 73: #{calculate_grade(73)}"   # => "C"
# puts "Score 65: #{calculate_grade(65)}"   # => "D"
# puts "Score 45: #{calculate_grade(45)}"   # => "F"
# puts "Score 105: #{calculate_grade(105)}" # => "Invalid score"
puts

# Challenge 2: Unless vs If
puts "Challenge 2: Rewrite Using Unless"
puts "-" * 40

# TODO: Rewrite this using unless instead of if not
# def process_payment(amount, balance)
#   if !(amount > 0)
#     return "Invalid amount"
#   end
#
#   if !(balance >= amount)
#     return "Insufficient funds"
#   end
#
#   "Payment of $#{amount} processed"
# end

# Your improved version:
def process_payment(amount, balance)
  # Your code here using unless:

end

# Test cases (uncomment when ready):
# puts process_payment(-10, 100)   # => "Invalid amount"
# puts process_payment(50, 25)     # => "Insufficient funds"
# puts process_payment(30, 100)    # => "Payment of $30 processed"
puts

# Challenge 3: Statement Modifiers
puts "Challenge 3: Convert to Statement Modifiers"
puts "-" * 40

# TODO: Rewrite these using statement modifiers for cleaner code
def validate_user(name, age, email)
  errors = []

  # if name.nil? || name.empty?
  #   errors << "Name is required"
  # end
  #
  # if age.nil? || age < 0
  #   errors << "Valid age is required"
  # end
  #
  # if email.nil? || !email.include?("@")
  #   errors << "Valid email is required"
  # end

  # Your improved version with statement modifiers:
  # Your code here:

  errors.empty? ? "Valid" : errors.join(", ")
end

# Test cases (uncomment when ready):
# puts validate_user("Alice", 25, "alice@example.com")  # => "Valid"
# puts validate_user(nil, 25, "alice@example.com")     # => "Name is required"
# puts validate_user("Bob", -5, "bob@example.com")     # => "Valid age is required"
# puts validate_user("Carol", 30, "invalid")           # => "Valid email is required"
puts

# Challenge 4: Multi-way Branching
puts "Challenge 4: Traffic Light System"
puts "-" * 40

def traffic_action(light, pedestrian_waiting)
  # TODO: Determine action based on light color and pedestrian
  # Green light: "Go" (or "Slow down" if pedestrian waiting)
  # Yellow light: "Prepare to stop"
  # Red light: "Stop"
  # Invalid: "Invalid light color"

  # Use case/when and handle pedestrian_waiting with if/unless
  # Your code here:

end

# Test cases (uncomment when ready):
# puts traffic_action("green", false)   # => "Go"
# puts traffic_action("green", true)    # => "Slow down"
# puts traffic_action("yellow", false)  # => "Prepare to stop"
# puts traffic_action("red", false)     # => "Stop"
# puts traffic_action("blue", false)    # => "Invalid light color"
puts

# Challenge 5: Age Category with Ternary
puts "Challenge 5: Nested Ternary (Then Improve It)"
puts "-" * 40

def age_category_ternary(age)
  # TODO: Write using nested ternary operator
  # 0-12: "child"
  # 13-19: "teenager"
  # 20-64: "adult"
  # 65+: "senior"

  # Your ternary version:

end

def age_category_better(age)
  # TODO: Rewrite using case/when for better readability
  # Same categories as above

  # Your case/when version:

end

# Test both versions (uncomment when ready):
# puts "Ternary version:"
# puts "Age 10: #{age_category_ternary(10)}"
# puts "Age 16: #{age_category_ternary(16)}"
# puts "Age 30: #{age_category_ternary(30)}"
# puts "Age 70: #{age_category_ternary(70)}"
#
# puts "\nCase/when version:"
# puts "Age 10: #{age_category_better(10)}"
# puts "Age 16: #{age_category_better(16)}"
# puts "Age 30: #{age_category_better(30)}"
# puts "Age 70: #{age_category_better(70)}"
puts

# Challenge 6: Complex Conditionals
puts "Challenge 6: Access Control System"
puts "-" * 40

def check_access(user_role, time_of_day, day_of_week, has_badge)
  # TODO: Implement complex access control
  # Rules:
  # - Admins: always have access
  # - Managers: access during business hours (9-17) on weekdays
  # - Employees: access during business hours on weekdays, AND must have badge
  # - Guests: no access
  # - Return detailed message

  # Use combination of case/when and if/elsif
  # Your code here:

end

# Test cases (uncomment when ready):
# puts check_access("admin", 22, "Saturday", false)      # Admin always has access
# puts check_access("manager", 10, "Monday", true)       # Manager during business hours
# puts check_access("manager", 10, "Sunday", true)       # Manager on weekend
# puts check_access("employee", 10, "Monday", true)      # Employee with badge
# puts check_access("employee", 10, "Monday", false)     # Employee without badge
# puts check_access("guest", 10, "Monday", true)         # Guest
puts

# Challenge 7: Input Validation with Pattern Matching
puts "Challenge 7: Input Type Validator"
puts "-" * 40

def validate_input(input)
  # TODO: Validate input type and format
  # Use case/when with regex patterns
  # Return: { type: "...", valid: true/false, message: "..." }
  #
  # Patterns:
  # - Email: contains @ and .
  # - Phone: 10 digits (with optional dashes/spaces)
  # - ZIP: 5 digits or 5+4 format
  # - URL: starts with http:// or https://
  # - Number: only digits
  # - Other: anything else

  # Your code here:

end

# Test cases (uncomment when ready):
# p validate_input("user@example.com")
# p validate_input("555-123-4567")
# p validate_input("12345")
# p validate_input("https://example.com")
# p validate_input("42")
# p validate_input("random text")
puts

# Bonus Challenge: FizzBuzz Conditions
puts "Bonus Challenge: FizzBuzz with Style"
puts "-" * 40

def fizzbuzz_number(n)
  # TODO: Implement FizzBuzz for a single number
  # - Divisible by 3 and 5: "FizzBuzz"
  # - Divisible by 3: "Fizz"
  # - Divisible by 5: "Buzz"
  # - Otherwise: the number itself
  #
  # Try multiple approaches:
  # 1. Using if/elsif
  # 2. Using case/when
  # 3. Using ternary (if you dare!)
  # 4. Your own creative approach

  # Your code here:

end

# Test (uncomment when ready):
# (1..20).each do |i|
#   puts "#{i}: #{fizzbuzz_number(i)}"
# end
puts

puts "=== Challenge Complete! ==="
puts
puts "Remember:"
puts "1. Use elsif (not elif!)"
puts "2. Conditionals return values"
puts "3. unless is great for simple negations"
puts "4. Statement modifiers for concise code"
puts "5. case/when is powerful and readable"
puts
puts "Solutions can be found in:"
puts "  ruby/tutorials/3-Control-Flow/exercises/conditionals_solution.rb"
