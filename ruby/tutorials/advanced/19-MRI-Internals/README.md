# Tutorial 19: C Ruby (MRI) Internals

Welcome to Ruby's internals! This tutorial explores how MRI (Matz's Ruby Interpreter) works under the hood - object representation, garbage collection, and performance tuning.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand how Ruby stores objects in memory
- Master garbage collection tuning and profiling
- Use ObjectSpace to inspect and debug memory
- Understand YARV (Yet Another Ruby VM) bytecode
- Know how to identify and fix memory leaks
- Learn the basics of writing C extensions

## 🐍➡️🔴 Coming from Python

Both Ruby (MRI) and Python (CPython) are implemented in C:

| Concept | Python (CPython) | Ruby (MRI) |
|---------|------------------|------------|
| Object structure | `PyObject` | `RBasic`, `RVALUE` |
| Garbage collection | Reference counting + cycle detector | Mark and Sweep (generational) |
| Memory profiler | `memory_profiler`, `tracemalloc` | `memory_profiler`, `ObjectSpace` |
| Bytecode | Python bytecode (.pyc) | YARV instructions |
| C extensions | `ctypes`, `cffi`, C API | C Extension API |
| VM | Stack-based | Stack-based (YARV) |
| Inspect internals | `sys`, `gc` module | `ObjectSpace`, `GC` module |

> **📘 Python Note:** Ruby's GC is mark-and-sweep (like old Python), not reference counting. This means circular references aren't a problem, but GC pauses can be more noticeable.

## 📝 Object Representation in Memory

Every Ruby object is stored as an `RVALUE` structure in C:

```ruby
# Inspect object internals
class Person
  attr_accessor :name, :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
end

person = Person.new("Alice", 30)

# Object ID is the memory address (shifted)
puts "Object ID: #{person.object_id}"
puts "Object class: #{person.class}"
puts "Object size: #{ObjectSpace.memsize_of(person)} bytes"

# Instance variables storage
puts "Instance variables: #{person.instance_variables}"
puts "Instance variable count: #{person.instance_variables.size}"
```

### Object Allocation and Memory

```ruby
require 'objspace'

# Create objects and measure memory
objects = []
initial_memory = ObjectSpace.memsize_of_all

1000.times do |i|
  objects << { id: i, data: "x" * 100 }
end

final_memory = ObjectSpace.memsize_of_all
memory_used = final_memory - initial_memory

puts "Memory used: #{memory_used} bytes"
puts "Average per object: #{memory_used / 1000} bytes"

# Detailed object info
obj = { name: "Alice", age: 30 }
puts "\nObject details:"
puts "Size: #{ObjectSpace.memsize_of(obj)} bytes"
puts "Generation: #{ObjectSpace.allocation_generation(obj)}"
puts "Source file: #{ObjectSpace.allocation_sourcefile(obj)}"
puts "Source line: #{ObjectSpace.allocation_sourceline(obj)}"
```

> **📘 Python Note:** Like `sys.getsizeof()` in Python, but Ruby provides more detailed allocation tracking through ObjectSpace.

## 📝 Garbage Collection (GC)

Ruby uses a generational mark-and-sweep garbage collector:

```ruby
# GC Statistics
puts "GC Stats:"
GC.stat.each do |key, value|
  puts "  #{key}: #{value}"
end

puts "\nGC Count: #{GC.count}"
puts "GC Time: #{GC.stat(:time)} ms"

# Manual GC control
GC.disable  # Disable automatic GC
1000.times { String.new("temporary") }
puts "GC still disabled, objects not collected"

GC.enable   # Re-enable GC
GC.start    # Force GC
puts "GC ran, memory freed"

# Measure GC impact
require 'benchmark'

time_with_gc = Benchmark.realtime do
  GC.enable
  1_000_000.times { String.new("test") }
end

time_without_gc = Benchmark.realtime do
  GC.disable
  1_000_000.times { String.new("test") }
  GC.enable
end

puts "Time with GC: #{time_with_gc.round(3)}s"
puts "Time without GC: #{time_without_gc.round(3)}s"
```

### GC Tuning

```ruby
# Tune GC parameters for better performance
GC::Profiler.enable

# Configure GC
ENV['RUBY_GC_HEAP_INIT_SLOTS'] = '100000'
ENV['RUBY_GC_HEAP_GROWTH_FACTOR'] = '1.1'
ENV['RUBY_GC_HEAP_GROWTH_MAX_SLOTS'] = '100000'

# Perform work
100_000.times { Array.new(10) { rand } }

# View GC profile
puts GC::Profiler.result

GC::Profiler.disable
```

> **📘 Python Note:** Python uses reference counting, so objects are freed immediately when references drop to zero. Ruby's mark-and-sweep runs periodically, which can cause GC pauses.

## 📝 ObjectSpace - Memory Inspector

ObjectSpace lets you iterate over all live objects:

```ruby
require 'objspace'

# Count objects by class
def object_count_by_class
  counts = Hash.new(0)
  ObjectSpace.each_object do |obj|
    counts[obj.class] += 1
  end
  counts.sort_by { |_, count| -count }.first(10)
end

puts "Top 10 object classes:"
object_count_by_class.each do |klass, count|
  puts "  #{klass}: #{count}"
end

# Find all instances of a class
class MyClass
  attr_accessor :data
end

objects = 5.times.map { MyClass.new }
objects.first.data = "first"
objects.last.data = "last"

puts "\nMyClass instances:"
ObjectSpace.each_object(MyClass) do |obj|
  puts "  Object: #{obj.object_id}, Data: #{obj.data}"
end

# Memory dump for analysis
ObjectSpace.dump_all(output: File.open('heap_dump.json', 'w'))
puts "\nHeap dump written to heap_dump.json"
```

### Finding Memory Leaks

```ruby
require 'objspace'

class LeakyClass
  @@all = []  # Class variable holds references!
  
  def initialize(data)
    @data = data
    @@all << self  # Memory leak!
  end
end

# Track object creation
ObjectSpace.trace_object_allocations_start

before = ObjectSpace.each_object(LeakyClass).count

1000.times do |i|
  LeakyClass.new("data-#{i}")
end

after = ObjectSpace.each_object(LeakyClass).count

ObjectSpace.trace_object_allocations_stop

puts "Objects before: #{before}"
puts "Objects after: #{after}"
puts "Leaked objects: #{after - before}"
puts "These objects won't be garbage collected!"
```

> **📘 Python Note:** Like Python's `tracemalloc` module for tracking memory allocations and finding leaks.

## 📝 YARV Bytecode

Ruby compiles code to YARV (Yet Another Ruby VM) instructions:

```ruby
code = <<-RUBY
  def add(a, b)
    a + b
  end
  
  result = add(2, 3)
RUBY

# Compile and inspect bytecode
instructions = RubyVM::InstructionSequence.compile(code)
puts "Bytecode:"
puts instructions.disasm

# Disassemble a method
def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

iseq = RubyVM::InstructionSequence.of(method(:fibonacci))
puts "\nFibonacci bytecode:"
puts iseq.disasm
```

### Bytecode Optimization

```ruby
# Compare bytecode for different approaches

# Approach 1: Direct addition
code1 = "1 + 2 + 3 + 4 + 5"
iseq1 = RubyVM::InstructionSequence.compile(code1)

# Approach 2: Array sum
code2 = "[1, 2, 3, 4, 5].sum"
iseq2 = RubyVM::InstructionSequence.compile(code2)

puts "Direct addition instructions:"
puts iseq1.disasm

puts "\nArray sum instructions:"
puts iseq2.disasm

# Count instructions
count1 = iseq1.disasm.lines.count
count2 = iseq2.disasm.lines.count

puts "\nDirect: #{count1} instructions"
puts "Array: #{count2} instructions"
```

> **📘 Python Note:** Like Python's `dis` module for disassembling bytecode. Both are stack-based VMs.

## 📝 Memory Profiling

Using the `memory_profiler` gem:

```ruby
require 'memory_profiler'

report = MemoryProfiler.report do
  # Code to profile
  strings = []
  10_000.times do |i|
    strings << "string-#{i}"
  end
  
  # Process strings
  strings.map(&:upcase)
end

# Show results
report.pretty_print

# Detailed metrics
puts "\nTotal allocated: #{report.total_allocated_memsize} bytes"
puts "Total retained: #{report.total_retained_memsize} bytes"
puts "Allocated objects: #{report.total_allocated}"
puts "Retained objects: #{report.total_retained}"
```

### Identifying Memory Hotspots

```ruby
require 'memory_profiler'

def memory_intensive_method
  # Create many objects
  (1..1000).map { |i| { id: i, data: "x" * 100 } }
end

def another_method
  # Create strings
  (1..1000).map { |i| "String #{i}" * 10 }
end

report = MemoryProfiler.report do
  memory_intensive_method
  another_method
end

puts "Memory allocated by location:"
report.allocated_memory_by_location.each do |location, size|
  puts "  #{location}: #{size} bytes"
end

puts "\nMemory allocated by gem:"
report.allocated_memory_by_gem.each do |gem, size|
  puts "  #{gem}: #{size} bytes"
end
```

> **📘 Python Note:** Similar to Python's `memory_profiler` package. Shows allocation hotspots and memory retention.

## 📝 Writing C Extensions (Basics)

Create a simple C extension:

```c
// simple_ext.c
#include "ruby.h"

VALUE method_hello(VALUE self) {
    return rb_str_new_cstr("Hello from C!");
}

VALUE method_add(VALUE self, VALUE a, VALUE b) {
    int x = NUM2INT(a);
    int y = NUM2INT(b);
    return INT2NUM(x + y);
}

void Init_simple_ext() {
    VALUE mSimple = rb_define_module("SimpleExt");
    rb_define_module_function(mSimple, "hello", method_hello, 0);
    rb_define_module_function(mSimple, "add", method_add, 2);
}
```

```ruby
# extconf.rb
require 'mkmf'
create_makefile('simple_ext')
```

Compile and use:
```bash
# ruby extconf.rb
# make
# ruby -r ./simple_ext -e "puts SimpleExt.hello"
# ruby -r ./simple_ext -e "puts SimpleExt.add(5, 3)"
```

> **📘 Python Note:** Like writing Python C extensions with the Python/C API. Ruby's API is similar - wrapping C functions for Ruby use.

## ✍️ Practice Exercise

Run the practice script:

```bash
ruby ruby/tutorials/advanced/19-MRI-Internals/exercises/internals_practice.rb
```

## 📚 What You Learned

✅ Understanding Ruby's object representation in memory
✅ Garbage collection internals and tuning
✅ Using ObjectSpace to inspect memory
✅ Reading YARV bytecode
✅ Memory profiling techniques
✅ Finding and fixing memory leaks
✅ Basics of C extensions

## 🔜 Next Steps

**Next tutorial: 20-Advanced-Functional-Programming** - Master currying, method objects, and lazy evaluation.

## 💡 Key Takeaways for Python Developers

1. **Mark-and-sweep GC**: Different from Python's reference counting
2. **ObjectSpace**: Like `gc` module but more powerful
3. **YARV bytecode**: Similar to Python bytecode (both stack-based)
4. **Memory profiling**: Similar tools, different internals
5. **C extensions**: Both languages have C APIs for extensions
6. **GC tuning**: Ruby needs more tuning than Python

## 🆘 Common Pitfalls

### Pitfall 1: Holding references prevents GC

```ruby
# BAD: Class variable prevents GC
class Bad
  @@cache = []
  def initialize
    @@cache << self  # Memory leak!
  end
end

# GOOD: Use WeakRef or clear cache
require 'weakref'
class Good
  @@cache = []
  def initialize
    @@cache << WeakRef.new(self)
  end
end
```

### Pitfall 2: Not enabling ObjectSpace tracking

```ruby
# Must enable before checking allocations
ObjectSpace.trace_object_allocations_start
obj = String.new("test")
puts ObjectSpace.allocation_sourcefile(obj)  # Works!

obj2 = String.new("test2")  # No tracking!
# puts ObjectSpace.allocation_sourcefile(obj2)  # Returns nil
```

### Pitfall 3: Large GC pauses

```ruby
# Prevent long GC pauses by tuning
GC.start(full_mark: false)  # Incremental GC
# or
ENV['RUBY_GC_HEAP_GROWTH_FACTOR'] = '1.05'  # Smaller growth
```

## 📖 Additional Resources

- [Ruby Under a Microscope](http://patshaughnessy.net/ruby-under-a-microscope)
- [ObjectSpace Documentation](https://ruby-doc.org/core/ObjectSpace.html)
- [GC Tuning Guide](https://www.speedshop.co/2017/03/09/a-guide-to-gc-stat.html)
- [Writing Ruby C Extensions](https://silverhammermba.github.io/emberb/)

---

Ready to explore Ruby's internals? Run the exercises and understand how Ruby works!
