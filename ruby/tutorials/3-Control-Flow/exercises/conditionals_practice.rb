#!/usr/bin/env ruby
# Conditionals Practice Script

puts "=== Ruby Conditionals Practice ==="
puts

# Section 1: Basic If/Elsif/Else
puts "1. If/Elsif/Else Statements"
puts "-" * 40

age = 25

if age < 13
  category = "Child"
elsif age < 18
  category = "Teenager"
elsif age < 65
  category = "Adult"
else
  category = "Senior"
end

puts "Age #{age} is in category: #{category}"

# If returns a value
status = if age >= 18
  "Can vote"
else
  "Cannot vote yet"
end

puts "Voting status: #{status}"
puts

# Section 2: Unless (Inverse If)
puts "2. Unless - The Inverse If"
puts "-" * 40

password = "secret123"
username = ""

# Unless for simple negations
unless password.empty?
  puts "✓ Password is set"
end

unless username.empty?
  puts "✓ Username is set"
else
  puts "✗ Username is not set"
end

# Comparison: unless vs if not
authenticated = false

puts "Using unless:"
unless authenticated
  puts "  Please log in"
end

puts "Using if not:"
if !authenticated
  puts "  Please log in"
end

puts
puts "💡 Use 'unless' for simple negative checks"
puts "⚠️  Avoid 'unless/else' - it's confusing!"
puts

# Section 3: Statement Modifiers
puts "3. Statement Modifiers (Suffix Conditionals)"
puts "-" * 40

logged_in = true
admin = false
debug_mode = false

# If modifier
puts "Welcome back!" if logged_in
puts "Admin panel available" if admin

# Unless modifier
puts "Debug info shown" unless debug_mode

# Common use: guard clauses
def process_data(data)
  return "Error: No data" if data.nil?
  return "Error: Empty data" if data.empty?
  "Processing: #{data}"
end

puts process_data(nil)
puts process_data("")
puts process_data("valid data")
puts

# Section 4: Case/When Statements
puts "4. Case/When - Multi-way Branching"
puts "-" * 40

# Basic case/when
day = "Friday"

message = case day
when "Monday"
  "Start of the work week"
when "Wednesday"
  "Hump day!"
when "Friday"
  "TGIF!"
when "Saturday", "Sunday"  # Multiple values
  "Weekend!"
else
  "Regular day"
end

puts "#{day}: #{message}"

# Case with ranges
score = 87

grade = case score
when 90..100
  "A - Excellent!"
when 80..89
  "B - Good job!"
when 70..79
  "C - Satisfactory"
when 60..69
  "D - Needs improvement"
else
  "F - Failed"
end

puts "Score #{score} = Grade: #{grade}"

# Case without a value (like if/elsif)
temperature = 75

weather = case
when temperature > 90
  "Hot"
when temperature > 70
  "Warm"
when temperature > 50
  "Cool"
when temperature > 32
  "Cold"
else
  "Freezing"
end

puts "Temperature #{temperature}°F is: #{weather}"
puts

# Section 5: Case with Types and Patterns
puts "5. Advanced Case/When Matching"
puts "-" * 40

# Matching types
value = "hello"

type_result = case value
when String
  "It's a string: #{value}"
when Integer
  "It's a number: #{value}"
when Array
  "It's an array with #{value.length} items"
else
  "Unknown type"
end

puts type_result

# Matching with regex
input = "user@example.com"

format = case input
when /^\d+$/
  "Numeric ID"
when /@/
  "Email address"
when /^https?:\/\//
  "URL"
else
  "Plain text"
end

puts "Input '#{input}' detected as: #{format}"
puts

# Section 6: Ternary Operator
puts "6. Ternary Operator"
puts "-" * 40

age = 25
can_vote = age >= 18 ? "Yes" : "No"
puts "Age #{age}, can vote? #{can_vote}"

# Nested ternary (use sparingly!)
role = "member"
access_level = role == "admin" ? "full" : role == "member" ? "limited" : "none"
puts "Role '#{role}' has access level: #{access_level}"

# Often better as case for readability
access_level = case role
when "admin"
  "full"
when "member"
  "limited"
else
  "none"
end

puts "Using case: #{access_level}"
puts

# Section 7: Combining Conditions
puts "7. Logical Operators in Conditionals"
puts "-" * 40

age = 25
has_license = true

# AND conditions
if age >= 16 && has_license
  puts "✓ Can drive legally"
end

# OR conditions
if admin || logged_in
  puts "✓ Access granted"
end

# Combining operators
if (age >= 18 && has_license) || admin
  puts "✓ Can rent a car"
end

# Ruby word operators (lower precedence)
proceed = true and false  # Variable gets true, then 'and false' is evaluated
proceed = true && false   # Variable gets false

puts "Proceed (and): #{proceed}"
puts

# Section 8: Truthy/Falsy Reminder
puts "8. Truthy and Falsy Values"
puts "-" * 40

values = [true, false, nil, 0, "", [], {}, "hello"]

values.each do |val|
  result = if val
    "truthy ✓"
  else
    "falsy ✗"
  end
  puts "#{val.inspect.ljust(15)} is #{result}"
end

puts
puts "⚠️  Remember: Only false and nil are falsy in Ruby!"
puts "✓  Everything else (including 0, '', []) is truthy!"
puts

# Section 9: Safe Navigation and Nil Checks
puts "9. Nil-safe Conditionals"
puts "-" * 40

user = nil

# Traditional nil check
if user != nil
  puts "User name: #{user.name}"
else
  puts "No user"
end

# Better: checking truthiness
if user
  puts "User name: #{user.name}"
else
  puts "No user"
end

# Best: safe navigation operator
name = user&.name || "Guest"
puts "Display name: #{name}"

# With conditionals
puts "Admin access" if user&.admin?
puts

# Section 10: Real-world Example
puts "10. Real-world: User Authentication Flow"
puts "-" * 40

def check_access(username, password, role)
  # Guard clauses
  return "Error: Username required" if username.nil? || username.empty?
  return "Error: Password required" if password.nil? || password.empty?

  # Simulate authentication
  authenticated = username == "admin" && password == "secret"
  return "Error: Invalid credentials" unless authenticated

  # Check role-based access
  access = case role
  when "admin"
    "Full access granted"
  when "moderator"
    "Limited access granted"
  when "user"
    "Basic access granted"
  else
    "Unknown role: #{role}"
  end

  access
end

puts check_access(nil, "pass", "admin")
puts check_access("admin", nil, "admin")
puts check_access("wrong", "wrong", "admin")
puts check_access("admin", "secret", "admin")
puts check_access("admin", "secret", "moderator")
puts check_access("admin", "secret", "user")
puts check_access("admin", "secret", "guest")
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. Use 'elsif' not 'elif'!"
puts "2. Conditionals return values - use it!"
puts "3. Use 'unless' for simple negative conditions"
puts "4. Statement modifiers for concise code: 'return if error'"
puts "5. Case/when is powerful: ranges, regex, types"
puts "6. Only false and nil are falsy"
