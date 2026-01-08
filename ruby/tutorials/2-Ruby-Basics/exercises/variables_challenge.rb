#!/usr/bin/env ruby
# Variables and Types Challenge
# Complete the TODOs to practice Ruby variables and types

puts "=== Variables and Types Challenge ==="
puts

# Challenge 1: Create variables of each type
puts "Challenge 1: Variable Declaration"
puts "-" * 40

# TODO: Create a string variable called 'language' with value "Ruby"
# language =

# TODO: Create an integer variable called 'version' with value 3
# version =

# TODO: Create a float variable called 'rating' with value 4.8
# rating =

# TODO: Create a boolean variable called 'is_fun' with value true
# is_fun =

# TODO: Create a nil variable called 'unknown'
# unknown =

# Uncomment these when you're done:
# puts "Language: #{language} (#{language.class})"
# puts "Version: #{version} (#{version.class})"
# puts "Rating: #{rating} (#{rating.class})"
# puts "Is fun: #{is_fun} (#{is_fun.class})"
# puts "Unknown: #{unknown.inspect} (#{unknown.class})"
puts

# Challenge 2: Type Conversion Function
puts "Challenge 2: Type Conversion"
puts "-" * 40

def safe_to_integer(value)
  # TODO: Convert value to integer
  # If conversion results in 0, check if original was actually "0"
  # Return nil if conversion is invalid, otherwise return the integer

  # Hint: Compare value.to_i.to_s == value.strip to validate
  # Your code here:

end

# Test cases (uncomment when ready):
# puts "safe_to_integer('42') => #{safe_to_integer('42').inspect}"      # Should be 42
# puts "safe_to_integer('hello') => #{safe_to_integer('hello').inspect}"  # Should be nil
# puts "safe_to_integer('0') => #{safe_to_integer('0').inspect}"        # Should be 0
# puts "safe_to_integer('  123  ') => #{safe_to_integer('  123  ').inspect}"  # Should be 123
puts

# Challenge 3: Truthiness Checker
puts "Challenge 3: Ruby Truthiness"
puts "-" * 40

def is_truthy?(value)
  # TODO: Return true if value is truthy in Ruby, false if falsy
  # Remember: Only false and nil are falsy in Ruby!

  # Your code here:

end

# Test cases (uncomment when ready):
# test_values = [0, "", [], {}, nil, false, true, "hello"]
# test_values.each do |val|
#   result = is_truthy?(val) ? "truthy" : "falsy"
#   puts "#{val.inspect.ljust(15)} is #{result}"
# end
puts

# Challenge 4: Empty Checker
puts "Challenge 4: Checking for Empty (The Ruby Way)"
puts "-" * 40

def describe_value(value)
  # TODO: Return a description of the value:
  # - "nil" if value is nil
  # - "empty" if value responds to .empty? and is empty
  # - "zero" if value is 0
  # - "value" otherwise (or the actual value as a string)

  # Hint: Use .nil?, .respond_to?(:empty?), .empty?, .zero?
  # Your code here:

end

# Test cases (uncomment when ready):
# puts "describe_value(nil) => #{describe_value(nil)}"
# puts "describe_value('') => #{describe_value('')}"
# puts "describe_value([]) => #{describe_value([])}"
# puts "describe_value(0) => #{describe_value(0)}"
# puts "describe_value('hello') => #{describe_value('hello')}"
# puts "describe_value([1,2,3]) => #{describe_value([1,2,3])}"
puts

# Challenge 5: Nil Coalescing
puts "Challenge 5: Nil Coalescing and Defaults"
puts "-" * 40

def greet(name = nil, title = nil)
  # TODO: Create a greeting using name and title
  # - Use "Guest" if name is nil
  # - Use "friend" if title is nil
  # - Return "Hello, [title] [name]!"

  # Hint: Use || for default values
  # Your code here:

end

# Test cases (uncomment when ready):
# puts greet("Alice", "Dr.")      # => "Hello, Dr. Alice!"
# puts greet("Bob", nil)          # => "Hello, friend Bob!"
# puts greet(nil, "Ms.")          # => "Hello, Ms. Guest!"
# puts greet(nil, nil)            # => "Hello, friend Guest!"
puts

# Challenge 6: Fix the Python Code
puts "Challenge 6: Fix Python-to-Ruby Conversion"
puts "-" * 40

# This is Python-style code converted naively to Ruby
# Fix it to be idiomatic Ruby!

def check_items_python_style(items)
  # ❌ Python style
  # if not items:  # This doesn't work in Ruby!
  #   return "No items"
  # elif items.length == 0:  # Redundant in Python, wrong in Ruby
  #   return "Empty"
  # else:
  #   return "Has items"

  # TODO: Rewrite this the Ruby way
  # Hint: Use .empty? and Ruby if/elsif/else syntax
  # Your code here:

end

# Test cases (uncomment when ready):
# puts check_items_python_style([])           # => "Empty"
# puts check_items_python_style([1, 2, 3])    # => "Has items"
puts

# Bonus Challenge: Type Validator
puts "Bonus Challenge: Type Validator"
puts "-" * 40

def validate_user_input(name, age, email)
  # TODO: Validate that:
  # - name is a non-empty string
  # - age is a positive integer
  # - email is a non-empty string containing "@"
  # Return array of error messages, or empty array if all valid

  # Your code here:
  errors = []

  # Add your validation logic

  errors
end

# Test cases (uncomment when ready):
# puts "Valid input:"
# p validate_user_input("Alice", 25, "alice@example.com")  # => []
#
# puts "Invalid input:"
# p validate_user_input("", -5, "invalid")  # => ["Name cannot be empty", "Age must be positive", "Email must contain @"]

puts
puts "=== Challenge Complete! ==="
puts "Check your solutions by uncommenting the test cases."
puts
puts "Solutions can be verified by running:"
puts "  ruby ruby/tutorials/2-Ruby-Basics/exercises/variables_solution.rb"
