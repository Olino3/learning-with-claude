#!/usr/bin/env ruby
# Step 5: Object Allocation Tracking

require 'objspace'

puts "=" * 60
puts "Step 5: Object Allocation Tracking"
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

    {
      result: result,
      allocations: allocations,
      total_allocated: allocations.values.sum
    }
  end
end

puts "Profiling different operations..."
puts

# Profile 1: Creating strings
profile = MemoryProfiler.profile do
  1000.times.map { |i| "string_#{i}" }
end
puts "Creating 1000 strings:"
puts "  Total objects: #{profile[:total_allocated]}"
profile[:allocations].each do |type, count|
  puts "    #{type}: #{count}" if count > 0
end
puts

# Profile 2: Creating arrays
profile = MemoryProfiler.profile do
  100.times.map { |i| [i, i*2, i*3] }
end
puts "Creating 100 arrays of 3 elements:"
puts "  Total objects: #{profile[:total_allocated]}"
profile[:allocations].each do |type, count|
  puts "    #{type}: #{count}" if count > 0
end
puts

# Profile 3: String concatenation comparison
puts "String building comparison:"
puts

profile1 = MemoryProfiler.profile do
  str = ""
  100.times { |i| str += i.to_s }
end
puts "  Using += (creates new string each time):"
puts "    String objects: #{profile1[:allocations][:T_STRING] || 0}"

profile2 = MemoryProfiler.profile do
  str = ""
  100.times { |i| str << i.to_s }
end
puts "  Using << (mutates in place):"
puts "    String objects: #{profile2[:allocations][:T_STRING] || 0}"
puts

puts "✓ Step 5 complete!"
