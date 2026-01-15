#!/usr/bin/env ruby
# Performance Optimizer Lab - Complete Solution Demo

require 'benchmark'
require_relative 'lib/benchmark_suite'
require_relative 'lib/memory_profiler'
require_relative 'lib/optimizer'

puts "=" * 70
puts "PERFORMANCE OPTIMIZER LAB - COMPLETE SOLUTION"
puts "=" * 70
puts

# ============================================================
# Part 1: Benchmarking
# ============================================================
puts "Part 1: Benchmarking"
puts "-" * 70

n = 100_000

puts "String concatenation comparison (#{n} iterations):"
Benchmark.bm(20) do |x|
  x.report("String += (slow):") { str = ""; n.times { str += "x" } }
  x.report("String << (fast):") { str = ""; n.times { str << "x" } }
  x.report("Array.join:") { arr = []; n.times { arr << "x" }; arr.join }
end
puts

puts "Hash key comparison (#{n} lookups):"
string_hash = { "name" => "value" }
symbol_hash = { name: "value" }

Benchmark.bm(20) do |x|
  x.report("String keys:") { n.times { string_hash["name"] } }
  x.report("Symbol keys:") { n.times { symbol_hash[:name] } }
end
puts

# ============================================================
# Part 2: Memory Profiling
# ============================================================
puts "Part 2: Memory Profiling"
puts "-" * 70

profile1 = SimpleMemoryProfiler.profile do
  Array.new(1000) { |i| "string_#{i}" }
end
puts "Array of 1000 strings:"
puts "  Total objects: #{profile1[:total_allocated]}"
profile1[:allocations].each { |type, count| puts "    #{type}: #{count}" if count > 0 }
puts

profile2 = SimpleMemoryProfiler.profile do
  1000.times.map { |i| { id: i, name: "item_#{i}" } }
end
puts "Array of 1000 hashes:"
puts "  Total objects: #{profile2[:total_allocated]}"
profile2[:allocations].each { |type, count| puts "    #{type}: #{count}" if count > 0 }
puts

# ============================================================
# Part 3: Optimization Techniques
# ============================================================
puts "Part 3: Optimization Techniques"
puts "-" * 70

puts "Memoization impact:"
class SlowFib
  def calc(n)
    return n if n <= 1
    calc(n - 1) + calc(n - 2)
  end
end

class FastFib
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

Benchmark.bm(25) do |x|
  x.report("Without memoization:") { SlowFib.new.calc(25) }
  x.report("With memoization:") { FastFib.new.calc(25) }
end
puts

puts "Algorithm complexity (finding duplicates):"
arr = Array.new(500) { rand(1..250) }

Benchmark.bm(25) do |x|
  x.report("O(n²) naive:") { Optimizer.find_duplicates_naive(arr) }
  x.report("O(n) with hash:") { Optimizer.find_duplicates_optimized(arr) }
end
puts

puts "=" * 70
puts "Performance optimization complete!"
puts "Remember: Always measure before optimizing!"
puts "=" * 70
