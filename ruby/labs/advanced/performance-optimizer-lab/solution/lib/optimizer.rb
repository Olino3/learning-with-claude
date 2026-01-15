# Optimization Examples

class Optimizer
  # O(n²) - Naive approach
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

  # O(n) - Hash-based approach
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

  # Even better: O(n) with Set
  def self.find_duplicates_with_set(array)
    require 'set'
    seen = Set.new
    duplicates = Set.new
    
    array.each do |item|
      if seen.include?(item)
        duplicates << item
      else
        seen << item
      end
    end
    
    duplicates.to_a
  end
end

# Memoization helper
module Memoizable
  def memoize(method_name)
    original = instance_method(method_name)
    cache_var = "@_memoize_#{method_name}"
    
    define_method(method_name) do |*args|
      cache = instance_variable_get(cache_var) || {}
      
      unless cache.key?(args)
        cache[args] = original.bind(self).call(*args)
        instance_variable_set(cache_var, cache)
      end
      
      cache[args]
    end
  end
end

# Frozen string optimization
class FrozenStrings
  GREETING = "Hello".freeze
  
  def self.efficient
    GREETING
  end
  
  def self.inefficient
    "Hello"  # Creates new string each time
  end
end
