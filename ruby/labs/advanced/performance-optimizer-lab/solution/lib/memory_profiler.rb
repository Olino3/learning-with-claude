# Simple Memory Profiler

require 'objspace'

class SimpleMemoryProfiler
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

  def self.measure_memory
    before = ObjectSpace.memsize_of_all
    yield
    after = ObjectSpace.memsize_of_all
    
    {
      before_kb: before / 1024.0,
      after_kb: after / 1024.0,
      allocated_kb: (after - before) / 1024.0
    }
  end
end

class MemoryOptimizer
  def self.compare(name, &blocks)
    puts "\n" + "=" * 60
    puts "Memory Comparison: #{name}"
    puts "=" * 60

    blocks.call.each do |label, block|
      profile = SimpleMemoryProfiler.profile(&block)

      puts "\n#{label}:"
      puts "  Total allocations: #{profile[:total_allocated]}"
      puts "  Strings: #{profile[:allocations][:T_STRING] || 0}"
      puts "  Arrays: #{profile[:allocations][:T_ARRAY] || 0}"
      puts "  Hashes: #{profile[:allocations][:T_HASH] || 0}"
    end
  end
end
