#!/usr/bin/env ruby
# Methods Practice

puts "=== Ruby Methods Practice ==="
puts

# Basic methods
def greet(name)
  "Hello, #{name}!"
end

puts greet("Alice")

# Optional parameters
def greet_with_title(name, title = "Friend")
  "Hello, #{title} #{name}!"
end

puts greet_with_title("Bob")
puts greet_with_title("Carol", "Dr.")

# Keyword arguments
def create_user(name:, email:, age: 18, active: true)
  {
    name: name,
    email: email,
    age: age,
    active: active
  }
end

user = create_user(name: "Alice", email: "alice@example.com")
puts "User: #{user}"

# Splat operator
def sum(*numbers)
  numbers.reduce(0, :+)
end

puts "Sum: #{sum(1, 2, 3, 4, 5)}"

# Implicit return
def max(a, b)
  a > b ? a : b  # Implicit return
end

puts "Max(5, 3): #{max(5, 3)}"

puts "\n=== Practice Complete ==="
