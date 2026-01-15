#!/usr/bin/env ruby
# Step 4: Basic Memory Usage

require 'objspace'

puts "=" * 60
puts "Step 4: Basic Memory Usage"
puts "=" * 60
puts

def measure_memory
  GC.start
  before = ObjectSpace.memsize_of_all
  
  result = yield
  
  after = ObjectSpace.memsize_of_all
  allocated = after - before

  {
    result: result,
    before_kb: before / 1024.0,
    after_kb: after / 1024.0,
    allocated_kb: allocated / 1024.0
  }
end

puts "Measuring memory allocation..."
puts

# Test 1: Array of integers
stats = measure_memory do
  Array.new(10_000) { |i| i }
end
puts "Array of 10,000 integers:"
puts "  Memory allocated: #{stats[:allocated_kb].round(2)} KB"
puts

# Test 2: Array of strings
stats = measure_memory do
  Array.new(10_000) { |i| "string_#{i}" }
end
puts "Array of 10,000 strings:"
puts "  Memory allocated: #{stats[:allocated_kb].round(2)} KB"
puts

# Test 3: Array of hashes
stats = measure_memory do
  Array.new(10_000) { |i| { id: i, name: "item_#{i}" } }
end
puts "Array of 10,000 hashes:"
puts "  Memory allocated: #{stats[:allocated_kb].round(2)} KB"
puts

# Individual object sizes
puts "Individual object sizes:"
puts "  Integer (1): #{ObjectSpace.memsize_of(1)} bytes"
puts "  String 'hello': #{ObjectSpace.memsize_of('hello')} bytes"
puts "  Array [1,2,3]: #{ObjectSpace.memsize_of([1,2,3])} bytes"
puts "  Hash {a: 1}: #{ObjectSpace.memsize_of({a: 1})} bytes"
puts

puts "✓ Step 4 complete!"
