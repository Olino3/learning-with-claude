#!/usr/bin/env ruby
# Blocks, Procs, and Lambdas Practice

puts "=== Blocks Practice ==="
puts

# Blocks with each
puts "Each with block:"
[1, 2, 3].each { |n| puts "  #{n * 2}" }

# Method with yield
def repeat(n)
  n.times { |i| yield i if block_given? }
end

puts "\nRepeat with yield:"
repeat(3) { |i| puts "  Count: #{i}" }

# Procs
puts "\nProc example:"
doubler = Proc.new { |x| x * 2 }
puts "doubler.call(5) = #{doubler.call(5)}"

# Lambdas
puts "\nLambda example:"
tripler = ->(x) { x * 3 }
puts "tripler.call(5) = #{tripler.call(5)}"

# Block as parameter
def execute_block(&block)
  block.call("from method") if block
end

puts "\nBlock as parameter:"
execute_block { |msg| puts "  Received: #{msg}" }

puts "\n=== Practice Complete ==="
