#!/usr/bin/env ruby
# My First Ruby Script

# Print a greeting
puts "Hello! This is my first Ruby script."

# Variables
my_name = "Ruby Learner"
favorite_color = "blue"

puts "My name is #{my_name}"
puts "My favorite color is #{favorite_color}"

# A simple calculation
age = 25
puts "In 5 years, I will be #{age + 5} years old"

# Working with arrays
hobbies = ["reading", "coding", "gaming"]
puts "\nMy hobbies:"
hobbies.each do |hobby|
  puts "  - #{hobby}"
end

# A simple method
def favorite_quote
  "The only way to do great work is to love what you do."
end

puts "\nFavorite quote: #{favorite_quote}"
