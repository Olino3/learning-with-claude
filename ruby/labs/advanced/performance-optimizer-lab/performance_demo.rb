#!/usr/bin/env ruby
# Performance Optimizer Lab

require 'benchmark'

puts "=" * 70
puts "PERFORMANCE OPTIMIZER LAB"
puts "=" * 70
puts

# Optimization 1: String concatenation
puts "1. String Concatenation Optimization"
puts "-" * 70

n = 100_000
Benchmark.bm(20) do |x|
  x.report("String += (slow):") { str = ""; n.times { str += "x" } }
  x.report("String << (fast):") { str = ""; n.times { str << "x" } }
  x.report("Array join (fast):") { arr = []; n.times { arr << "x" }; arr.join }
end

puts

# Optimization 2: Hash access
puts "2. Symbol vs String Keys"
puts "-" * 70

Benchmark.bm(20) do |x|
  x.report("String keys:") do
    100_000.times { h = { "name" => "Alice" }; h["name"] }
  end
  x.report("Symbol keys (fast):") do
    100_000.times { h = { name: "Alice" }; h[:name] }
  end
end

puts

# Optimization 3: Iteration
puts "3. Iteration Methods"
puts "-" * 70

arr = (1..10_000).to_a
Benchmark.bm(20) do |x|
  x.report("each with sum:") { sum = 0; arr.each { |n| sum += n } }
  x.report("inject:") { arr.inject(0, :+) }
  x.report("sum (fastest):") { arr.sum }
end

puts

# Optimization 4: Memoization
puts "4. Memoization Impact"
puts "-" * 70

class Slow
  def calc(n) = (sleep 0.001; n ** 2)
end

class Fast
  def calc(n)
    @cache ||= {}
    @cache[n] ||= (sleep 0.001; n ** 2)
  end
end

slow, fast = Slow.new, Fast.new
Benchmark.bm(25) do |x|
  x.report("Without memoization:") { 50.times { slow.calc(5) } }
  x.report("With memoization (fast):") { 50.times { fast.calc(5) } }
end

puts

puts "=" * 70
puts "Optimization complete! Always profile before optimizing."
puts "=" * 70
