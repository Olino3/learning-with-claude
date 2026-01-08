#!/usr/bin/env ruby
# Methods and Blocks Challenge

puts "=== Methods Challenge ==="
puts

# TODO: Create a calculator method that accepts operation as a symbol
def calculate(a, b, operation: :add)
  # Support :add, :subtract, :multiply, :divide
  # Your code here:
end

# Test (uncomment):
# puts calculate(10, 5, operation: :add)
# puts calculate(10, 5, operation: :multiply)

# TODO: Create a method that yields multiple times
def countdown(from, to = 0)
  # Yield each number from 'from' down to 'to'
  # Your code here:
end

# Test (uncomment):
# countdown(5) { |n| puts n }

# TODO: Create a filter method using a block
def filter(array, &block)
  # Return elements where block returns true
  # Your code here:
end

# Test (uncomment):
# result = filter([1, 2, 3, 4, 5]) { |n| n.even? }
# p result  # => [2, 4]

puts "\n=== Challenge Complete ==="
