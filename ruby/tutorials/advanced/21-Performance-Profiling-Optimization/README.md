# Tutorial 21: Performance Profiling and Optimization

Master benchmarking, profiling, and optimization techniques to make your Ruby code faster and more efficient.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Benchmark code with Benchmark and benchmark-ips
- Profile memory usage with memory_profiler
- Profile CPU usage with stackprof
- Understand YARV bytecode and AST
- Apply optimization strategies
- Identify and fix performance bottlenecks

## 🐍➡️🔴 Coming from Python

Both languages have similar profiling tools:

| Concept | Python | Ruby |
|---------|--------|------|
| Time profiling | `cProfile`, `timeit` | `Benchmark`, `benchmark-ips` |
| Memory profiling | `memory_profiler`, `tracemalloc` | `memory_profiler` gem |
| CPU profiling | `cProfile`, `line_profiler` | `stackprof`, `ruby-prof` |
| Bytecode | `dis` module | `RubyVM::InstructionSequence` |
| AST | `ast` module | `RubyVM::AbstractSyntaxTree` |

> **📘 Python Note:** Ruby's `benchmark-ips` (iterations per second) is more intuitive than timeit for comparing approaches. Memory profiling works similarly to Python's tools.

## 📝 Benchmarking with Benchmark Module

```ruby
require 'benchmark'

# Basic timing
time = Benchmark.realtime do
  1_000_000.times { "string interpolation #{1 + 1}" }
end
puts "Time: #{time.round(3)}s"

# Compare multiple approaches
n = 1_000_000
Benchmark.bm(20) do |x|
  x.report("String concatenation:") { n.times { "Hello " + "World" } }
  x.report("String interpolation:") { n.times { "Hello #{'World'}" } }
  x.report("String join:") { n.times { ["Hello", "World"].join(" ") } }
end

# Detailed comparison with labels
Benchmark.bmbm(15) do |x|
  x.report("Array#each:") { (1..10_000).each { |i| i * 2 } }
  x.report("Array#map:") { (1..10_000).map { |i| i * 2 } }
  x.report("for loop:") { for i in 1..10_000 do i * 2 end }
end
```

## 📝 Benchmark IPS - Iterations Per Second

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)
  
  x.report("Hash#[]") do
    hash = { a: 1, b: 2 }
    hash[:a]
  end
  
  x.report("Hash#fetch") do
    hash = { a: 1, b: 2 }
    hash.fetch(:a)
  end
  
  x.report("Hash#dig") do
    hash = { a: 1, b: 2 }
    hash.dig(:a)
  end
  
  x.compare!
end
```

Output shows iterations/second and comparison:
```
Hash#[]:      10.5M (± 2%) i/s - 52.4M in 5.0s
Hash#fetch:   9.8M (± 3%) i/s - 49.1M in 5.0s
Hash#dig:     8.2M (± 2%) i/s - 41.2M in 5.0s

Comparison:
  Hash#[]:     10.5M i/s
  Hash#fetch:  9.8M i/s - 1.07x slower
  Hash#dig:    8.2M i/s - 1.28x slower
```

## 📝 Memory Profiling

```ruby
require 'memory_profiler'

report = MemoryProfiler.report do
  # Code to profile
  arrays = []
  1000.times do
    arrays << Array.new(100) { |i| "item #{i}" }
  end
  
  # Transform data
  arrays.flatten.map(&:upcase)
end

# Print detailed report
report.pretty_print

# Key metrics
puts "\nSummary:"
puts "Total allocated: #{report.total_allocated_memsize} bytes"
puts "Total retained: #{report.total_retained_memsize} bytes"
puts "Allocated objects: #{report.total_allocated}"
puts "Retained objects: #{report.total_retained}"

# Top allocations
puts "\nTop 5 allocations by location:"
report.allocated_memory_by_location.first(5).each do |location, size|
  puts "  #{location}: #{size} bytes"
end
```

## 📝 CPU Profiling with StackProf

```ruby
require 'stackprof'

# Profile CPU usage
StackProf.run(mode: :cpu, out: 'stackprof-cpu.dump') do
  def fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end
  
  fibonacci(30)
end

# Analyze results (run from command line)
# stackprof stackprof-cpu.dump --text
```

## 📝 AST and Bytecode Analysis

```ruby
# Abstract Syntax Tree
code = "def add(a, b); a + b; end"
ast = RubyVM::AbstractSyntaxTree.parse(code)
puts "AST:"
puts ast.inspect

# Bytecode analysis
def sample_method(x)
  y = x * 2
  z = y + 10
  z
end

iseq = RubyVM::InstructionSequence.of(method(:sample_method))
puts "\nBytecode:"
puts iseq.disasm

# Compare approaches
code1 = "[1, 2, 3, 4, 5].sum"
code2 = "1 + 2 + 3 + 4 + 5"

puts "\nArray#sum bytecode:"
puts RubyVM::InstructionSequence.compile(code1).disasm

puts "\nDirect addition bytecode:"
puts RubyVM::InstructionSequence.compile(code2).disasm
```

## 📝 Common Optimizations

### 1. String Concatenation

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("String +=") do
    str = ""
    100.times { str += "x" }
  end
  
  x.report("String <<") do
    str = ""
    100.times { str << "x" }
  end
  
  x.report("Array join") do
    arr = []
    100.times { arr << "x" }
    arr.join
  end
  
  x.compare!
end
```

Result: `<<` is fastest (mutates in place), then Array join, `+=` is slowest (creates new strings).

### 2. Symbol vs String Keys

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("String keys") do
    hash = { "name" => "Alice", "age" => 30 }
    hash["name"]
  end
  
  x.report("Symbol keys") do
    hash = { name: "Alice", age: 30 }
    hash[:name]
  end
  
  x.compare!
end
```

Result: Symbol keys are faster (symbols are immutable and reused).

### 3. Block vs Symbol to_proc

```ruby
require 'benchmark/ips'

numbers = (1..1000).to_a

Benchmark.ips do |x|
  x.report("Block") do
    numbers.map { |n| n.to_s }
  end
  
  x.report("Symbol to_proc") do
    numbers.map(&:to_s)
  end
  
  x.compare!
end
```

### 4. Memoization

```ruby
class SlowCalculator
  def expensive_operation(n)
    sleep(0.001)  # Simulate expensive work
    n ** 2
  end
end

class FastCalculator
  def expensive_operation(n)
    @cache ||= {}
    @cache[n] ||= begin
      sleep(0.001)
      n ** 2
    end
  end
end

require 'benchmark'

slow = SlowCalculator.new
fast = FastCalculator.new

Benchmark.bm(15) do |x|
  x.report("Without cache:") { 100.times { slow.expensive_operation(5) } }
  x.report("With cache:") { 100.times { fast.expensive_operation(5) } }
end
```

### 5. Early Returns

```ruby
require 'benchmark/ips'

def slow_search(array, target)
  result = nil
  array.each do |item|
    result = item if item == target
  end
  result
end

def fast_search(array, target)
  array.each do |item|
    return item if item == target
  end
  nil
end

array = (1..10_000).to_a

Benchmark.ips do |x|
  x.report("Without early return") { slow_search(array, 10) }
  x.report("With early return") { fast_search(array, 10) }
  x.compare!
end
```

## 📝 Optimization Strategies

### 1. Use Built-in Methods

```ruby
# Slow
sum = 0
array.each { |n| sum += n }

# Fast
sum = array.sum
```

### 2. Avoid Creating Unnecessary Objects

```ruby
# Slow - creates many intermediate arrays
result = array.map { |n| n * 2 }.select { |n| n > 10 }.map { |n| n.to_s }

# Fast - single pass
result = array.filter_map { |n| (n * 2).to_s if n * 2 > 10 }
```

### 3. Use Lazy Evaluation for Large Datasets

```ruby
# Slow - processes all
result = huge_array.map { |n| expensive(n) }.first(10)

# Fast - only processes 10
result = huge_array.lazy.map { |n| expensive(n) }.first(10)
```

### 4. Freeze Strings

```ruby
# Slow - creates new string each time
def slow
  "constant string"
end

# Fast - reuses frozen string
def fast
  "constant string".freeze
end

# Even better with frozen string literal comment
# frozen_string_literal: true
```

## ✍️ Practice Exercise

```bash
ruby ruby/tutorials/advanced/21-Performance-Profiling-Optimization/exercises/performance_practice.rb
```

## 📚 What You Learned

✅ Benchmarking code with Benchmark and benchmark-ips
✅ Memory profiling with memory_profiler
✅ CPU profiling with stackprof
✅ Understanding bytecode and AST
✅ Common optimization strategies
✅ Identifying performance bottlenecks

## 🔜 Next Steps

**Next tutorial: 22-Design-Patterns** - Master Ruby-specific design pattern implementations.

## 💡 Key Takeaways for Python Developers

1. **benchmark-ips**: More intuitive than timeit
2. **Memory profiling**: Similar to Python's tools
3. **Symbol keys**: Faster than string keys (unlike Python)
4. **Memoization**: Same pattern as Python's `@lru_cache`
5. **Lazy**: Like generators for performance
6. **Frozen strings**: Like Python's string interning

## 🆘 Common Pitfalls

### Pitfall 1: Premature Optimization

```ruby
# Don't optimize before profiling!
# First: Make it work
# Second: Make it right
# Third: Make it fast (if needed)
```

### Pitfall 2: Micro-optimizations

```ruby
# This matters:
1_000_000.times { slow_operation }

# This doesn't:
10.times { slightly_slower_operation }
```

### Pitfall 3: Not using built-ins

```ruby
# Slow
sum = 0
array.each { |n| sum += n }

# Fast
sum = array.sum
```

## 📖 Additional Resources

- [Benchmark IPS Guide](https://github.com/evanphx/benchmark-ips)
- [Ruby Performance Optimization](https://pragprog.com/titles/adrpo/ruby-performance-optimization/)
- [StackProf Guide](https://github.com/tmm1/stackprof)

---

Ready to optimize your code? Run the exercises and profile your Ruby!
