#!/usr/bin/env ruby
# MRI Internals Practice

require 'objspace'

puts "=" * 70
puts "MRI INTERNALS PRACTICE"
puts "Ruby Version: #{RUBY_VERSION}"
puts "=" * 70
puts

# Example 1: Object Memory Representation
puts "1. Object Memory Representation"
puts "-" * 70

class Person
  attr_accessor :name, :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
end

person = Person.new("Alice", 30)

puts "Object ID: #{person.object_id}"
puts "Object class: #{person.class}"
puts "Memory size: #{ObjectSpace.memsize_of(person)} bytes"
puts "Instance variables: #{person.instance_variables}"

# Compare sizes
string = "Hello, World!"
array = [1, 2, 3, 4, 5]
hash = { a: 1, b: 2, c: 3 }

puts "\nObject sizes:"
puts "String: #{ObjectSpace.memsize_of(string)} bytes"
puts "Array: #{ObjectSpace.memsize_of(array)} bytes"
puts "Hash: #{ObjectSpace.memsize_of(hash)} bytes"

puts

# Example 2: Garbage Collection Stats
puts "2. Garbage Collection Statistics"
puts "-" * 70

puts "GC Count: #{GC.count}"
puts "GC Time: #{GC.stat(:time)} ms"

# Key GC statistics
puts "\nImportant GC Stats:"
puts "Heap live slots: #{GC.stat(:heap_live_slots)}"
puts "Heap free slots: #{GC.stat(:heap_free_slots)}"
puts "Total allocated objects: #{GC.stat(:total_allocated_objects)}"
puts "Total freed objects: #{GC.stat(:total_freed_objects)}"
puts "Major GC count: #{GC.stat(:major_gc_count)}"
puts "Minor GC count: #{GC.stat(:minor_gc_count)}"

puts

# Example 3: Manual GC Control
puts "3. Manual GC Control"
puts "-" * 70

# Create many temporary objects
GC.disable
puts "GC disabled"
puts "Creating 10,000 temporary objects..."

before_count = GC.stat(:heap_live_slots)
10_000.times { String.new("temporary") }
after_count = GC.stat(:heap_live_slots)

puts "Live slots before: #{before_count}"
puts "Live slots after: #{after_count}"
puts "Difference: #{after_count - before_count}"

GC.enable
puts "\nGC re-enabled"
GC.start
puts "GC executed"

final_count = GC.stat(:heap_live_slots)
puts "Live slots after GC: #{final_count}"
puts "Objects collected: #{after_count - final_count}"

puts

# Example 4: ObjectSpace - Count Objects by Class
puts "4. ObjectSpace - Count Objects by Class"
puts "-" * 70

def count_objects_by_class(top_n = 10)
  counts = Hash.new(0)
  ObjectSpace.each_object do |obj|
    counts[obj.class] += 1
  end
  counts.sort_by { |_, count| -count }.first(top_n)
end

puts "Top 10 object classes in memory:"
count_objects_by_class.each_with_index do |(klass, count), i|
  puts "#{i + 1}. #{klass}: #{count}"
end

puts

# Example 5: ObjectSpace - Find Specific Objects
puts "5. ObjectSpace - Find Specific Objects"
puts "-" * 70

class MyData
  attr_accessor :id, :value
  
  def initialize(id, value)
    @id = id
    @value = value
  end
end

# Create some instances
data_objects = [
  MyData.new(1, "first"),
  MyData.new(2, "second"),
  MyData.new(3, "third")
]

puts "MyData instances in memory:"
ObjectSpace.each_object(MyData) do |obj|
  puts "  ID: #{obj.id}, Value: #{obj.value}"
end

puts

# Example 6: Memory Allocation Tracking
puts "6. Memory Allocation Tracking"
puts "-" * 70

# Enable allocation tracking
ObjectSpace.trace_object_allocations_start

# Create objects
tracked_string = String.new("tracked")
tracked_array = Array.new(5) { |i| i }
tracked_hash = { key: "value" }

# Get allocation info
puts "String allocation:"
puts "  File: #{ObjectSpace.allocation_sourcefile(tracked_string)}"
puts "  Line: #{ObjectSpace.allocation_sourceline(tracked_string)}"
puts "  Class: #{ObjectSpace.allocation_class_path(tracked_string)}"

puts "\nArray allocation:"
puts "  File: #{ObjectSpace.allocation_sourcefile(tracked_array)}"
puts "  Line: #{ObjectSpace.allocation_sourceline(tracked_array)}"

ObjectSpace.trace_object_allocations_stop

puts

# Example 7: YARV Bytecode Inspection
puts "7. YARV Bytecode Inspection"
puts "-" * 70

# Simple method
def add(a, b)
  a + b
end

# Get bytecode
iseq = RubyVM::InstructionSequence.of(method(:add))
puts "Bytecode for add method:"
puts iseq.disasm

puts

# Example 8: Comparing Bytecode for Different Approaches
puts "8. Comparing Bytecode for Different Approaches"
puts "-" * 70

# Approach 1
code1 = "1 + 2 + 3"
iseq1 = RubyVM::InstructionSequence.compile(code1)

# Approach 2
code2 = "[1, 2, 3].sum"
iseq2 = RubyVM::InstructionSequence.compile(code2)

puts "Bytecode for: 1 + 2 + 3"
puts iseq1.disasm
puts "\nBytecode for: [1, 2, 3].sum"
puts iseq2.disasm

puts

# Example 9: Memory Usage Measurement
puts "9. Memory Usage Measurement"
puts "-" * 70

# Measure memory before
before_memory = ObjectSpace.memsize_of_all

# Create objects
big_array = Array.new(10_000) { |i| { id: i, data: "x" * 50 } }

# Measure memory after
after_memory = ObjectSpace.memsize_of_all
memory_used = after_memory - before_memory

puts "Memory before: #{before_memory} bytes"
puts "Memory after: #{after_memory} bytes"
puts "Memory used: #{memory_used} bytes"
puts "Average per object: #{memory_used / 10_000} bytes"

puts

# Example 10: GC Profiler
puts "10. GC Profiler"
puts "-" * 70

GC::Profiler.enable

# Do some work that triggers GC
3.times do
  100_000.times { String.new("test" * 10) }
end

puts "GC Profile Report:"
puts GC::Profiler.result

total_time = GC::Profiler.total_time
puts "\nTotal GC time: #{total_time.round(4)} seconds"

GC::Profiler.clear
GC::Profiler.disable

puts

# Example 11: Finding Memory Leaks
puts "11. Detecting Memory Leaks"
puts "-" * 70

class PotentialLeak
  @@cache = []  # Class variable - potential leak!
  
  def initialize(data)
    @data = data
    @@cache << self  # Stores reference, preventing GC
  end
  
  def self.cache_size
    @@cache.size
  end
end

before = ObjectSpace.each_object(PotentialLeak).count

1000.times { |i| PotentialLeak.new("data-#{i}") }

after = ObjectSpace.each_object(PotentialLeak).count
GC.start  # Force GC

after_gc = ObjectSpace.each_object(PotentialLeak).count

puts "Objects before: #{before}"
puts "Objects after creation: #{after}"
puts "Objects after GC: #{after_gc}"
puts "Leaked objects (not collected): #{after_gc}"
puts "Cache size: #{PotentialLeak.cache_size}"

puts

# Example 12: Object Generation Tracking
puts "12. Object Generation Tracking"
puts "-" * 70

ObjectSpace.trace_object_allocations_start

# Create objects in different "generations"
old_obj = String.new("old")
GC.start  # This might promote old_obj to an older generation

new_obj = String.new("new")

puts "Old object generation: #{ObjectSpace.allocation_generation(old_obj)}"
puts "New object generation: #{ObjectSpace.allocation_generation(new_obj)}"

ObjectSpace.trace_object_allocations_stop

puts

# Example 13: Weak References (avoiding leaks)
puts "13. Weak References (Memory Leak Prevention)"
puts "-" * 70

begin
  require 'weakref'
  
  class SafeCache
    def initialize
      @cache = []
    end
    
    def add(obj)
      @cache << WeakRef.new(obj)
    end
    
    def alive_count
      @cache.count { |ref| ref.weakref_alive? }
    end
  end
  
  cache = SafeCache.new
  
  # Add objects
  10.times { cache.add(String.new("cached")) }
  puts "Objects in cache: #{cache.alive_count}"
  
  # Force GC - weak references won't prevent collection
  GC.start
  puts "After GC: #{cache.alive_count}"
  
rescue LoadError
  puts "WeakRef not available in this Ruby version"
end

puts

puts "=" * 70
puts "Practice complete! You've explored Ruby's internals!"
puts "=" * 70
puts
puts "Key Insights:"
puts "- Ruby uses mark-and-sweep GC (generational)"
puts "- ObjectSpace provides powerful introspection"
puts "- YARV bytecode is stack-based like Python"
puts "- Memory leaks often come from class variables"
puts "- GC can be tuned for performance"
