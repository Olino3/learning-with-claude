#!/usr/bin/env ruby
# Strings and Symbols Challenge

puts "=== Strings and Symbols Challenge ==="
puts

# Challenge 1: String Interpolation
puts "Challenge 1: Build a Formatted Message"
puts "-" * 40

# TODO: Create variables and build a message using interpolation
# Create: first_name, last_name, age, city
# Build a message: "John Doe is 25 years old and lives in Seattle."

# Your code here:

# puts "Message: #{message}"
puts

# Challenge 2: String Manipulation
puts "Challenge 2: Text Processing"
puts "-" * 40

def process_text(text)
  # TODO: Process the text by:
  # 1. Remove leading/trailing whitespace
  # 2. Capitalize first letter of each word
  # 3. Remove any double spaces
  # 4. Return the processed text

  # Hint: Use .strip, .split, .map, .capitalize, .join
  # Your code here:

end

# Test cases (uncomment when ready):
# puts process_text("  hello   world  ")  # => "Hello World"
# puts process_text(" ruby programming ")  # => "Ruby Programming"
puts

# Challenge 3: Symbol vs String
puts "Challenge 3: Choose Symbol or String"
puts "-" * 40

# TODO: Fix this code by using symbols where appropriate
# and strings where appropriate

def create_user_profile(name, email, role)
  # ❌ Currently using strings for everything
  # user = {
  #   "name" => name,
  #   "email" => email,
  #   "role" => role,
  #   "status" => "active"
  # }

  # TODO: Rewrite using symbols for keys and role/status
  # Your code here:

end

# Test (uncomment when ready):
# user = create_user_profile("Alice", "alice@example.com", "admin")
# p user
puts

# Challenge 4: Multi-line String Formatting
puts "Challenge 4: Email Template"
puts "-" * 40

def generate_email(name, product, price, quantity)
  # TODO: Create an email template using squiggly heredoc
  # Include:
  # - Greeting with name
  # - Order details (product, quantity, price each)
  # - Total calculation
  # - Thank you message

  # Use <<~EMAIL heredoc format
  # Your code here:

end

# Test (uncomment when ready):
# puts generate_email("Alice", "Ruby Book", 29.99, 2)
puts

# Challenge 5: String Method Chaining
puts "Challenge 5: Text Analysis"
puts "-" * 40

def analyze_text(text)
  # TODO: Return a hash with:
  # - :word_count
  # - :char_count (excluding spaces)
  # - :longest_word
  # - :shortest_word
  # - :average_word_length (as float)

  # Your code here:

end

# Test (uncomment when ready):
# result = analyze_text("The quick brown fox jumps over the lazy dog")
# p result
# Expected: {
#   word_count: 9,
#   char_count: 35,
#   longest_word: "quick" (or "brown", "jumps"),
#   shortest_word: "The" (or "fox", "the", "dog"),
#   average_word_length: 3.89
# }
puts

# Challenge 6: String to Symbol Conversion
puts "Challenge 6: Dynamic Hash Keys"
puts "-" * 40

def create_hash_from_arrays(keys, values)
  # TODO: Create a hash where:
  # - keys are converted to symbols
  # - values remain as is
  # - Handle the case where arrays are different lengths

  # Example:
  # keys = ["name", "age", "city"]
  # values = ["Alice", 25, "Seattle"]
  # Result: { name: "Alice", age: 25, city: "Seattle" }

  # Hint: Use .zip and .to_h
  # Your code here:

end

# Test (uncomment when ready):
# keys = ["name", "age", "city"]
# values = ["Alice", 25, "Seattle"]
# result = create_hash_from_arrays(keys, values)
# p result
puts

# Challenge 7: Advanced String Manipulation
puts "Challenge 7: URL Slug Generator"
puts "-" * 40

def generate_slug(title)
  # TODO: Convert a title to a URL-friendly slug
  # Rules:
  # - Convert to lowercase
  # - Replace spaces with hyphens
  # - Remove special characters (keep only a-z, 0-9, hyphens)
  # - Remove leading/trailing hyphens
  # - Collapse multiple hyphens into one

  # Example: "Hello, World! 123" => "hello-world-123"

  # Your code here:

end

# Test (uncomment when ready):
# puts generate_slug("Hello, World! 123")           # => "hello-world-123"
# puts generate_slug("  Ruby Programming  ")        # => "ruby-programming"
# puts generate_slug("One---Two---Three")           # => "one-two-three"
# puts generate_slug("Special!@#$%Characters")      # => "special-characters"
puts

# Challenge 8: Symbol Memory Test
puts "Challenge 8: Demonstrate Symbol Efficiency"
puts "-" * 40

def symbol_efficiency_demo
  # TODO: Demonstrate that symbols are more memory efficient
  # Create 1000 copies of:
  # - A string "status"
  # - A symbol :status
  # Show that symbols have the same object_id, strings don't

  # Your code here:

end

# Uncomment when ready:
# symbol_efficiency_demo
puts

# Bonus Challenge: String Builder
puts "Bonus Challenge: Template Engine"
puts "-" * 40

def render_template(template, variables)
  # TODO: Create a simple template engine
  # Replace {{variable}} with values from variables hash
  # Example:
  #   template = "Hello {{name}}, you are {{age}} years old!"
  #   variables = { name: "Alice", age: 25 }
  #   Result: "Hello Alice, you are 25 years old!"

  # Hint: Use .gsub with a block
  # Your code here:

end

# Test (uncomment when ready):
# template = "Hello {{name}}, you are {{age}} years old!"
# variables = { name: "Alice", age: 25 }
# puts render_template(template, variables)
puts

puts "=== Challenge Complete! ==="
puts "Uncomment the test cases as you complete each challenge."
puts
puts "Solutions can be found in:"
puts "  ruby/tutorials/2-Ruby-Basics/exercises/strings_solution.rb"
