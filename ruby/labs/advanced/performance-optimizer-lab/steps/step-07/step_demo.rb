#!/usr/bin/env ruby
# Step 7: Common Ruby Optimizations

require 'benchmark'

puts "=" * 60
puts "Step 7: Common Ruby Optimizations"
puts "=" * 60
puts

n = 100_000

# Optimization 1: Symbol vs String keys
puts "1. Symbol vs String Keys"
puts "-" * 50
Benchmark.bm(25) do |x|
  x.report("String keys:") do
    n.times do
      hash = { "name" => "Alice", "age" => 30 }
      hash["name"]
    end
  end
  
  x.report("Symbol keys (faster):") do
    n.times do
      hash = { name: "Alice", age: 30 }
      hash[:name]
    end
  end
end
puts

# Optimization 2: Frozen strings
puts "2. Frozen Strings"
puts "-" * 50

FROZEN_GREETING = "Hello, World!".freeze

Benchmark.bm(25) do |x|
  x.report("New string each time:") do
    n.times { "Hello, World!" }
  end
  
  x.report("Frozen constant (faster):") do
    n.times { FROZEN_GREETING }
  end
end
puts

# Optimization 3: Efficient iteration
puts "3. Efficient Iteration"
puts "-" * 50
arr = (1..1000).to_a

Benchmark.bm(25) do |x|
  x.report("each + push:") do
    1000.times do
      result = []
      arr.each { |x| result.push(x * 2) }
    end
  end
  
  x.report("map (faster):") do
    1000.times do
      arr.map { |x| x * 2 }
    end
  end
end
puts

# Optimization 4: Avoiding method calls in loops
puts "4. Method Call Optimization"
puts "-" * 50
Benchmark.bm(25) do |x|
  x.report("Method in condition:") do
    arr = (1..10_000).to_a
    100.times do
      arr.select { |x| x > arr.size / 2 }
    end
  end
  
  x.report("Cache method result:") do
    arr = (1..10_000).to_a
    100.times do
      mid = arr.size / 2
      arr.select { |x| x > mid }
    end
  end
end
puts

puts "✓ Step 7 complete!"
