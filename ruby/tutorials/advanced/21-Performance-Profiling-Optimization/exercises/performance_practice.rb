#!/usr/bin/env ruby
# Performance Profiling and Optimization Practice

require 'benchmark'

puts "=" * 70
puts "PERFORMANCE PROFILING AND OPTIMIZATION PRACTICE"
puts "=" * 70
puts

# Example 1: Basic Benchmarking
puts "1. Basic Benchmarking"
puts "-" * 70

time = Benchmark.realtime do
  1_000_000.times { "string" + " concatenation" }
end
puts "Time for 1M string concatenations: #{time.round(3)}s"

puts

# Example 2: Comparing Multiple Approaches
puts "2. Comparing Multiple Approaches"
puts "-" * 70

n = 100_000
Benchmark.bm(20) do |x|
  x.report("String +:") { n.times { "Hello " + "World" } }
  x.report("String <<:") { n.times { str = "Hello "; str << "World" } }
  x.report("String interpolation:") { n.times { "Hello #{'World'}" } }
  x.report("String join:") { n.times { ["Hello", "World"].join(" ") } }
end

puts

# Example 3: Symbol vs String Keys
puts "3. Symbol vs String Keys Performance"
puts "-" * 70

Benchmark.bm(15) do |x|
  x.report("String keys:") do
    100_000.times do
      h = { "name" => "Alice", "age" => 30 }
      h["name"]
    end
  end
  
  x.report("Symbol keys:") do
    100_000.times do
      h = { name: "Alice", age: 30 }
      h[:name]
    end
  end
end

puts

# Example 4: Early Returns
puts "4. Early Returns Optimization"
puts "-" * 70

def search_without_return(array, target)
  result = nil
  array.each { |item| result = item if item == target }
  result
end

def search_with_return(array, target)
  array.each { |item| return item if item == target }
  nil
end

array = (1..10_000).to_a

Benchmark.bm(25) do |x|
  x.report("Without early return:") { 1000.times { search_without_return(array, 10) } }
  x.report("With early return:") { 1000.times { search_with_return(array, 10) } }
end

puts

# Example 5: Memoization
puts "5. Memoization Performance"
puts "-" * 70

class WithoutMemoization
  def expensive_calc(n)
    sleep(0.001)
    n ** 2
  end
end

class WithMemoization
  def expensive_calc(n)
    @cache ||= {}
    @cache[n] ||= begin
      sleep(0.001)
      n ** 2
    end
  end
end

without = WithoutMemoization.new
with = WithMemoization.new

Benchmark.bm(25) do |x|
  x.report("Without memoization:") { 50.times { without.expensive_calc(5) } }
  x.report("With memoization:") { 50.times { with.expensive_calc(5) } }
end

puts

# Example 6: Array Operations
puts "6. Array Operations Comparison"
puts "-" * 70

numbers = (1..1000).to_a

Benchmark.bm(20) do |x|
  x.report("each with sum:") do
    sum = 0
    numbers.each { |n| sum += n }
  end
  
  x.report("inject:") { numbers.inject(0, :+) }
  x.report("reduce:") { numbers.reduce(0, :+) }
  x.report("sum:") { numbers.sum }
end

puts

# Example 7: String Building
puts "7. String Building Strategies"
puts "-" * 70

Benchmark.bm(20) do |x|
  x.report("String +=:") do
    str = ""
    100.times { str += "x" }
  end
  
  x.report("String <<:") do
    str = ""
    100.times { str << "x" }
  end
  
  x.report("Array join:") do
    arr = []
    100.times { arr << "x" }
    arr.join
  end
end

puts

# Example 8: Block vs Symbol to_proc
puts "8. Block vs Symbol to_proc"
puts "-" * 70

numbers = (1..1000).to_a

Benchmark.bm(20) do |x|
  x.report("Block:") { 100.times { numbers.map { |n| n.to_s } } }
  x.report("Symbol to_proc:") { 100.times { numbers.map(&:to_s) } }
end

puts

# Example 9: Lazy Evaluation
puts "9. Lazy Evaluation Benefits"
puts "-" * 70

large_range = (1..1_000_000)

eager_time = Benchmark.realtime do
  large_range.map { |n| n * 2 }.select { |n| n % 3 == 0 }.first(10)
end

lazy_time = Benchmark.realtime do
  large_range.lazy.map { |n| n * 2 }.select { |n| n % 3 == 0 }.first(10)
end

puts "Eager evaluation: #{eager_time.round(4)}s"
puts "Lazy evaluation: #{lazy_time.round(4)}s"
puts "Speedup: #{(eager_time / lazy_time).round(2)}x"

puts

# Example 10: Method Call Overhead
puts "10. Method Call Overhead"
puts "-" * 70

def simple_method(x)
  x * 2
end

Benchmark.bm(20) do |x|
  x.report("Inline:") { 100_000.times { |i| i * 2 } }
  x.report("Method call:") { 100_000.times { |i| simple_method(i) } }
end

puts

# Example 11: Hash Access Patterns
puts "11. Hash Access Patterns"
puts "-" * 70

hash = (1..1000).map { |i| [i, i * 2] }.to_h

Benchmark.bm(20) do |x|
  x.report("Hash#[]:") { 10_000.times { hash[500] } }
  x.report("Hash#fetch:") { 10_000.times { hash.fetch(500) } }
  x.report("Hash#dig:") { 10_000.times { hash.dig(500) } }
end

puts

# Example 12: Avoid Creating Unnecessary Objects
puts "12. Avoid Creating Unnecessary Objects"
puts "-" * 70

array = (1..1000).to_a

Benchmark.bm(25) do |x|
  x.report("Multiple intermediate arrays:") do
    array.map { |n| n * 2 }.select { |n| n > 100 }.map { |n| n.to_s }
  end
  
  x.report("Single pass with select_map:") do
    array.filter_map { |n| (n * 2).to_s if n * 2 > 100 }
  end
end

puts

puts "=" * 70
puts "Performance practice complete!"
puts "=" * 70
puts
puts "Key Insights:"
puts "- Symbol keys are faster than string keys"
puts "- Early returns improve performance"
puts "- Memoization drastically speeds up repeated calculations"
puts "- Lazy evaluation helps with large datasets"
puts "- Built-in methods (like .sum) are optimized"
puts "- String << is faster than String +"
puts "- Avoid creating unnecessary intermediate objects"
