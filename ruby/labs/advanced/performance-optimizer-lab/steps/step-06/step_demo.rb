#!/usr/bin/env ruby
# Step 6: Memory-Efficient Alternatives

require 'objspace'

puts "=" * 60
puts "Step 6: Memory-Efficient Alternatives"
puts "=" * 60
puts

class MemoryProfiler
  def self.profile(&block)
    before_counts = ObjectSpace.count_objects
    GC.start
    GC.disable
    result = block.call
    GC.enable
    after_counts = ObjectSpace.count_objects

    allocations = {}
    after_counts.each do |type, count|
      diff = count - (before_counts[type] || 0)
      allocations[type] = diff if diff > 0
    end

    { allocations: allocations, total: allocations.values.sum }
  end
end

class MemoryOptimizer
  def self.compare(name, alternatives)
    puts "#{name}:"
    puts "-" * 50
    
    results = []
    alternatives.each do |label, block|
      profile = MemoryProfiler.profile(&block)
      results << { label: label, total: profile[:total], allocations: profile[:allocations] }
    end
    
    results.sort_by { |r| r[:total] }.each do |r|
      puts "  #{r[:label]}:"
      puts "    Total allocations: #{r[:total]}"
      puts "    Strings: #{r[:allocations][:T_STRING] || 0}, Arrays: #{r[:allocations][:T_ARRAY] || 0}"
    end
    puts
  end
end

# Comparison 1: Array building
MemoryOptimizer.compare("Array Building (1000 items)", {
  "Using << operator" => -> {
    arr = []
    1000.times { |i| arr << i }
    arr
  },
  "Using Array.new with block" => -> {
    Array.new(1000) { |i| i }
  },
  "Using Range#to_a" => -> {
    (0...1000).to_a
  }
})

# Comparison 2: Hash creation
MemoryOptimizer.compare("Hash Keys (1000 entries)", {
  "String keys" => -> {
    hash = {}
    1000.times { |i| hash["key_#{i}"] = i }
    hash
  },
  "Symbol keys" => -> {
    hash = {}
    1000.times { |i| hash[:"key_#{i}"] = i }
    hash
  }
})

# Comparison 3: String building
MemoryOptimizer.compare("String Building (100 parts)", {
  "Concatenation (+=)" => -> {
    str = ""
    100.times { |i| str += "part#{i}" }
    str
  },
  "Shovel (<<)" => -> {
    str = ""
    100.times { |i| str << "part#{i}" }
    str
  },
  "Array#join" => -> {
    parts = []
    100.times { |i| parts << "part#{i}" }
    parts.join
  }
})

puts "✓ Step 6 complete!"
