#!/usr/bin/env ruby
# Step 8: Algorithmic Optimization

require 'benchmark'

puts "=" * 60
puts "Step 8: Algorithmic Optimization"
puts "=" * 60
puts

class AlgorithmOptimizer
  # O(n²) - Naive approach: nested loops
  def self.find_duplicates_naive(array)
    duplicates = []
    array.each_with_index do |item, i|
      array.each_with_index do |other, j|
        if i != j && item == other && !duplicates.include?(item)
          duplicates << item
        end
      end
    end
    duplicates
  end

  # O(n) - Optimized: hash-based lookup
  def self.find_duplicates_optimized(array)
    seen = {}
    duplicates = []
    
    array.each do |item|
      if seen[item]
        duplicates << item unless duplicates.include?(item)
      else
        seen[item] = true
      end
    end
    
    duplicates
  end

  # O(n²) - Naive array search
  def self.find_common_naive(arr1, arr2)
    arr1.select { |item| arr2.include?(item) }
  end

  # O(n) - Hash-based search
  def self.find_common_optimized(arr1, arr2)
    set = arr2.each_with_object({}) { |item, h| h[item] = true }
    arr1.select { |item| set[item] }
  end
end

# Test with different sizes
puts "Finding duplicates in arrays:"
puts "-" * 50
puts

[100, 500, 1000].each do |size|
  array = Array.new(size) { rand(1..(size/2)) }
  
  puts "Array size: #{size}"
  Benchmark.bm(25) do |x|
    x.report("  O(n²) naive:") { AlgorithmOptimizer.find_duplicates_naive(array) }
    x.report("  O(n) optimized:") { AlgorithmOptimizer.find_duplicates_optimized(array) }
  end
  puts
end

puts "Finding common elements:"
puts "-" * 50
puts

arr1 = (1..1000).to_a.shuffle
arr2 = (500..1500).to_a.shuffle

Benchmark.bm(25) do |x|
  x.report("O(n²) with include?:") { AlgorithmOptimizer.find_common_naive(arr1, arr2) }
  x.report("O(n) with hash:") { AlgorithmOptimizer.find_common_optimized(arr1, arr2) }
end
puts

puts "Key takeaway: Algorithm choice has MUCH bigger impact than micro-optimizations!"
puts
puts "✓ Step 8 complete!"
