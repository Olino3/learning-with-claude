#!/usr/bin/env ruby
# Step 1: Basic Benchmark Comparison

require 'benchmark'

puts "=" * 60
puts "Step 1: Basic Benchmarking"
puts "=" * 60
puts

n = 100_000

puts "Comparing array iteration methods (#{n} items):"
puts

Benchmark.bm(20) do |x|
  x.report("Array#each:") do
    result = []
    (1..n).each { |i| result << i * 2 }
  end

  x.report("Array#map:") do
    (1..n).map { |i| i * 2 }
  end

  x.report("Array#collect:") do
    (1..n).collect { |i| i * 2 }
  end
end

puts
puts "Column explanation:"
puts "  user   - CPU time spent in user mode"
puts "  system - CPU time spent in kernel mode"
puts "  total  - user + system"
puts "  real   - actual elapsed time (wall clock)"
puts
puts "✓ Step 1 complete!"
