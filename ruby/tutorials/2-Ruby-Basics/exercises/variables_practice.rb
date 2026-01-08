#!/usr/bin/env ruby
# Variables and Types Practice Script
# This script demonstrates Ruby's variable types and type system

puts "=== Ruby Variables and Types Practice ==="
puts

# Section 1: Basic Variables
puts "1. Basic Variables"
puts "-" * 40

name = "Alice"
age = 30
height = 5.6
is_active = true
account_balance = nil

puts "Name: #{name} (#{name.class})"
puts "Age: #{age} (#{age.class})"
puts "Height: #{height} (#{height.class})"
puts "Active: #{is_active} (#{is_active.class})"
puts "Balance: #{account_balance.inspect} (#{account_balance.class})"
puts

# Section 2: Type Conversions
puts "2. Type Conversions"
puts "-" * 40

# String to number
num_string = "42"
converted_int = num_string.to_i
converted_float = num_string.to_f

puts "String '#{num_string}' to integer: #{converted_int} (#{converted_int.class})"
puts "String '#{num_string}' to float: #{converted_float} (#{converted_float.class})"

# Invalid conversions (Python would raise exception)
invalid = "hello"
invalid_int = invalid.to_i  # Returns 0 in Ruby!

puts "String '#{invalid}' to integer: #{invalid_int} ⚠️  (No error, returns 0)"

# Partial conversions
partial = "123abc"
partial_int = partial.to_i

puts "String '#{partial}' to integer: #{partial_int} (stops at non-digit)"
puts

# Section 3: Truthiness - THE BIG DIFFERENCE
puts "3. Truthiness (Different from Python!)"
puts "-" * 40

# Testing various values
test_values = [0, "", [], {}, nil, false, true, "hello"]

test_values.each do |value|
  result = if value
    "truthy ✓"
  else
    "falsy ✗"
  end
  puts "#{value.inspect.ljust(15)} is #{result}"
end

puts
puts "⚠️  In Python: 0, '', [], {} are falsy"
puts "✓  In Ruby: Only false and nil are falsy!"
puts

# Section 4: Checking for Empty/Nil
puts "4. The Ruby Way: empty? and nil?"
puts "-" * 40

items = []
text = ""
value = nil
number = 0

puts "Empty array check:"
puts "  items.empty? => #{items.empty?}"
puts "  items (in if) => #{items ? 'truthy' : 'falsy'}"

puts "Empty string check:"
puts "  text.empty? => #{text.empty?}"
puts "  text (in if) => #{text ? 'truthy' : 'falsy'}"

puts "Nil check:"
puts "  value.nil? => #{value.nil?}"
puts "  value (in if) => #{value ? 'truthy' : 'falsy'}"

puts "Zero check:"
puts "  number.zero? => #{number.zero?}"
puts "  number (in if) => #{number ? 'truthy' : 'falsy'}"
puts

# Section 5: Constants
puts "5. Constants and Freezing"
puts "-" * 40

MAX_USERS = 100
puts "Constant MAX_USERS: #{MAX_USERS}"

# Uncomment to see warning (still works though!)
# MAX_USERS = 200

# Freezing for immutability
COLORS = ["red", "green", "blue"].freeze
puts "Frozen array COLORS: #{COLORS.inspect}"

# Uncomment to see error
# COLORS << "yellow"  # RuntimeError!
puts

# Section 6: Nil Coalescing and Safe Navigation
puts "6. Nil Handling Patterns"
puts "-" * 40

user_name = nil
display_name = user_name || "Guest"
puts "user_name is nil, display_name: #{display_name}"

# Safe navigation
user = nil
user_email = user&.email  # Doesn't crash!
puts "user&.email with nil user: #{user_email.inspect}"

# Comparison with regular access
# Uncomment to see error:
# user.email  # NoMethodError!
puts

# Section 7: Everything is an Object
puts "7. Everything is an Object (Even nil!)"
puts "-" * 40

puts "nil has methods:"
puts "  nil.class => #{nil.class}"
puts "  nil.to_s => '#{nil.to_s}' (empty string)"
puts "  nil.to_i => #{nil.to_i}"
puts "  nil.to_a => #{nil.to_a.inspect}"

puts
puts "Numbers have methods:"
puts "  42.class => #{42.class}"
puts "  42.even? => #{42.even?}"
puts "  42.odd? => #{42.odd?}"
puts "  42.next => #{42.next}"
puts

# Section 8: Type Comparison
puts "8. Type Checking and Comparison"
puts "-" * 40

value = 42

puts "value = #{value}"
puts "value.class => #{value.class}"
puts "value.is_a?(Integer) => #{value.is_a?(Integer)}"
puts "value.is_a?(Numeric) => #{value.is_a?(Numeric)}"
puts "value.is_a?(String) => #{value.is_a?(String)}"
puts "value.kind_of?(Integer) => #{value.kind_of?(Integer)}"  # Same as is_a?
puts "value.instance_of?(Integer) => #{value.instance_of?(Integer)}"  # Exact class only
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. Only false and nil are falsy (not 0, '', [], {})"
puts "2. Use .empty? to check for empty collections/strings"
puts "3. Use .nil? to check for nil"
puts "4. .to_i returns 0 for invalid strings (no exception)"
puts "5. Everything is an object with methods"
puts "6. Use &. for safe navigation (like Python's optional chaining)"
