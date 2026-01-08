#!/usr/bin/env ruby
# Strings and Symbols Practice Script

puts "=== Strings and Symbols Practice ==="
puts

# Section 1: String Interpolation
puts "1. String Interpolation"
puts "-" * 40

name = "Alice"
age = 30

# Basic interpolation
puts "Name: #{name}"
puts "Age: #{age}"

# Expression evaluation
puts "Next year: #{age + 1} years old"

# Method calls
puts "UPPERCASE: #{name.upcase}"
puts "lowercase: #{name.downcase}"

# Complex expressions
items = ["apple", "banana", "orange"]
puts "#{name} has #{items.length} items: #{items.join(', ')}"

# Vs concatenation (works but not idiomatic)
message = "Hello, " + name + "!"
puts message
puts

# Section 2: Common String Methods
puts "2. Common String Methods"
puts "-" * 40

text = "  Hello, Ruby World!  "
puts "Original: '#{text}'"
puts "Length: #{text.length}"
puts "Upcase: #{text.upcase}"
puts "Downcase: #{text.downcase}"
puts "Capitalize: #{text.capitalize}"
puts "Strip: '#{text.strip}'"
puts "Reverse: #{text.reverse}"

# Checking contents
puts "Include 'Ruby'?: #{text.include?('Ruby')}"
puts "Start with '  Hello'?: #{text.start_with?('  Hello')}"
puts "End with 'World!  '?: #{text.end_with?('World!  ')}"
puts

# Section 3: String Manipulation
puts "3. String Manipulation"
puts "-" * 40

sentence = "The quick brown fox"
puts "Original: #{sentence}"
puts "Replace 'brown' with 'red': #{sentence.gsub('brown', 'red')}"
puts "Split into words: #{sentence.split(' ').inspect}"
puts "First 9 characters: #{sentence[0..8]}"
puts "Last word: #{sentence.split(' ').last}"

# Character access
puts "First character: #{sentence[0]}"
puts "Last character: #{sentence[-1]}"
puts "Characters 4-8: #{sentence[4..8]}"
puts

# Section 4: Multi-line Strings
puts "4. Multi-line Strings"
puts "-" * 40

# Heredoc
basic_heredoc = <<TEXT
This is a basic heredoc.
It preserves line breaks.
Useful for long text.
TEXT

puts "Basic heredoc:"
puts basic_heredoc

# Squiggly heredoc (removes leading indentation)
def formatted_message
  <<~MSG
    This is indented in the code,
    but the leading spaces are removed.
    Very useful for clean code!
  MSG
end

puts "Squiggly heredoc:"
puts formatted_message
puts

# Section 5: Symbols vs Strings
puts "5. Symbols vs Strings"
puts "-" * 40

# Creating symbols
status = :active
role = :admin

puts "Symbol status: #{status} (#{status.class})"
puts "Symbol role: #{role} (#{role.class})"

# Converting
puts ":hello to string: #{:hello.to_s}"
puts "'hello' to symbol: #{'hello'.to_sym.inspect}"
puts

# Section 6: Symbol Memory Efficiency
puts "6. Symbol Memory Efficiency"
puts "-" * 40

# Same symbol = same object ID
puts "Symbol comparison:"
puts "  :hello.object_id: #{:hello.object_id}"
puts "  :hello.object_id: #{:hello.object_id}"
puts "  Same? #{:hello.object_id == :hello.object_id}"

puts
puts "String comparison:"
puts "  'hello'.object_id: #{'hello'.object_id}"
puts "  'hello'.object_id: #{'hello'.object_id}"
puts "  Same? #{'hello'.object_id == 'hello'.object_id}"

puts
puts "⚠️  Every string literal creates a new object!"
puts "✓  Every symbol is the same object instance!"
puts

# Section 7: Symbols in Hashes (most common use)
puts "7. Symbols in Hashes"
puts "-" * 40

# Modern hash syntax (symbol keys)
user = {
  name: "Alice",
  age: 30,
  role: :admin,
  active: true
}

puts "User hash with symbol keys:"
puts user.inspect
puts "Access with symbol: user[:name] = #{user[:name]}"
puts "Access role: user[:role] = #{user[:role]}"

# Old syntax (still valid)
old_style = { :name => "Bob", :age => 25 }
puts "Old style: #{old_style.inspect}"
puts

# Section 8: When to Use Symbols vs Strings
puts "8. When to Use Symbols vs Strings"
puts "-" * 40

# ✅ Symbols for: identifiers, hash keys, constants
statuses = [:active, :inactive, :pending]
puts "Status enum: #{statuses.inspect}"

config = {
  environment: :production,
  debug: false,
  log_level: :info
}
puts "Config: #{config.inspect}"

# ✅ Strings for: user data, output, manipulation
greeting = "Hello"
puts greeting.upcase!  # Mutate in place
puts "Greeting (mutated): #{greeting}"

user_input = "Alice"
puts "Welcome, #{user_input}!"
puts

# Section 9: String Mutability
puts "9. String Mutability (vs Python)"
puts "-" * 40

# Mutating methods (with !)
text1 = "hello"
puts "Before: #{text1}"
text1.upcase!
puts "After upcase!: #{text1}"

# Non-mutating (without !)
text2 = "world"
result = text2.upcase
puts "text2.upcase (no !): result = #{result}, original = #{text2}"

# This is different from Python where strings are always immutable!
puts
puts "⚠️  In Python, strings are immutable"
puts "✓  In Ruby, strings are mutable (! methods modify in place)"
puts

# Section 10: Useful String Methods
puts "10. More Useful String Methods"
puts "-" * 40

# Repetition
puts "'Ruby' * 3: #{'Ruby' * 3}"

# Checking emptiness
empty = ""
full = "content"
puts "empty.empty?: #{empty.empty?}"
puts "full.empty?: #{full.empty?}"

# Character codes
puts "'A'.ord: #{'A'.ord}"  # ASCII code
puts "65.chr: #{65.chr}"    # Character from code

# Padding
puts "'5'.rjust(3, '0'): #{'5'.rjust(3, '0')}"
puts "'5'.ljust(3, '0'): #{'5'.ljust(3, '0')}"
puts "'hello'.center(11, '-'): #{'hello'.center(11, '-')}"
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. Use \#{} for string interpolation (cleaner than f-strings)"
puts "2. Symbols are immutable, memory-efficient identifiers"
puts "3. Use symbols for hash keys, not strings"
puts "4. Strings are mutable in Ruby (unlike Python 3)"
puts "5. Methods ending in ? return booleans (empty?, include?)"
puts "6. Methods ending in ! mutate in place (upcase!, strip!)"
