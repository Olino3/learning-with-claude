#!/usr/bin/env ruby
# File I/O Practice

puts "=== File I/O ==="
puts

# Write file
File.write("/tmp/test.txt", "Hello, Ruby!\nWelcome to File I/O")

# Read file
content = File.read("/tmp/test.txt")
puts "File content:"
puts content

# Read lines
puts "\nLines:"
File.foreach("/tmp/test.txt") do |line|
  puts "  > #{line}"
end

puts "\n=== Practice Complete ==="
