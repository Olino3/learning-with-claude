#!/usr/bin/env ruby
# Step 9: Caching and Memoization

require 'benchmark'

puts "=" * 60
puts "Step 9: Caching and Memoization"
puts "=" * 60
puts

# Example 1: Fibonacci without memoization
class SlowFibonacci
  def calc(n)
    return n if n <= 1
    calc(n - 1) + calc(n - 2)
  end
end

# Example 2: Fibonacci with memoization
class FastFibonacci
  def initialize
    @cache = {}
  end

  def calc(n)
    @cache[n] ||= begin
      return n if n <= 1
      calc(n - 1) + calc(n - 2)
    end
  end
end

# Example 3: Class-level memoization
class Fibonacci
  @cache = { 0 => 0, 1 => 1 }
  
  def self.calc(n)
    @cache[n] ||= calc(n - 1) + calc(n - 2)
  end
end

puts "Fibonacci Comparison:"
puts "-" * 50

Benchmark.bm(30) do |x|
  x.report("Without memoization (n=30):") { SlowFibonacci.new.calc(30) }
  x.report("With memoization (n=30):") { FastFibonacci.new.calc(30) }
  x.report("Class-level cache (n=30):") { Fibonacci.calc(30) }
end
puts

# Practical example: expensive computation
puts "Practical Memoization Example:"
puts "-" * 50

class DataProcessor
  def initialize
    @computed_results = {}
  end

  # Without memoization
  def process_slow(id)
    # Simulate expensive computation
    sleep(0.01)
    id * 2
  end

  # With memoization
  def process_fast(id)
    @computed_results[id] ||= begin
      sleep(0.01)
      id * 2
    end
  end
end

processor = DataProcessor.new
ids = [1, 2, 3, 1, 2, 3, 1, 2, 3]  # Repeated IDs

puts "Processing #{ids.length} items (with repeated IDs)..."

Benchmark.bm(30) do |x|
  x.report("Without memoization:") do
    ids.each { |id| processor.process_slow(id) }
  end
  
  x.report("With memoization:") do
    ids.each { |id| processor.process_fast(id) }
  end
end
puts

# Simple memoization pattern
puts "Simple Memoization Pattern:"
puts "-" * 50
puts <<~CODE
  def expensive_method
    @cached_result ||= begin
      # expensive computation here
    end
  end
CODE
puts

puts "=" * 60
puts "✓ Step 9 complete! Performance Optimizer Lab finished!"
puts "=" * 60
