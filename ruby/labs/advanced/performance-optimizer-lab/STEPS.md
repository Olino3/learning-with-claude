# Progressive Learning Guide: Performance Optimizer

Learn to measure, profile, and optimize Ruby code step by step.

## 🎯 Overview

Master performance optimization through:
1. **Benchmarking** - Measure code performance
2. **Memory Profiling** - Identify memory issues
3. **Optimization Techniques** - Apply performance improvements

---

## Part 1: Benchmarking

### Step 1: Basic Benchmark Comparison

**Goal**: Compare performance of different approaches.

```ruby
require 'benchmark'

def benchmark_comparison
  n = 100_000

  Benchmark.bm(20) do |x|
    x.report("Array#each:") do
      result = []
      (1..n).each { |i| result << i * 2 }
    end

    x.report("Array#map:") do
      (1..n).map { |i| i * 2 }
    end

    x.report("Array#collect:") do
      (1..n).collect { |i| i * 2 }
    end
  end
end

benchmark_comparison
```

---

### Step 2: Iterations Per Second with benchmark-ips

**Goal**: Measure how many iterations can run per second.

```ruby
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("string concat") do
    str = ""
    100.times { str += "x" }
  end

  x.report("string interpolation") do
    str = ""
    100.times { str = "#{str}x" }
  end

  x.report("array join") do
    arr = []
    100.times { arr << "x" }
    arr.join
  end

  x.compare!
end
```

---

### Step 3: Create Custom Benchmark Suite

**Goal**: Build a reusable benchmarking framework.

```ruby
class BenchmarkSuite
  def initialize(name)
    @name = name
    @benchmarks = {}
  end

  def add(label, &block)
    @benchmarks[label] = block
  end

  def run(iterations: 10_000)
    puts "=" * 60
    puts "Benchmark Suite: #{@name}"
    puts "=" * 60

    results = {}

    @benchmarks.each do |label, block|
      time = Benchmark.measure do
        iterations.times { block.call }
      end

      results[label] = {
        real: time.real,
        user: time.user,
        system: time.system,
        total: time.total
      }

      puts "\n#{label}:"
      puts "  Real time: #{(time.real * 1000).round(2)}ms"
      puts "  User CPU: #{(time.user * 1000).round(2)}ms"
      puts "  System CPU: #{(time.system * 1000).round(2)}ms"
    end

    fastest = results.min_by { |_, v| v[:real] }
    puts "\n" + "=" * 60
    puts "Fastest: #{fastest[0]} (#{(fastest[1][:real] * 1000).round(2)}ms)"
    puts "=" * 60

    results
  end
end
```

**Test it**:
```ruby
suite = BenchmarkSuite.new("String Operations")

suite.add("Concatenation") { "hello" + " " + "world" }
suite.add("Interpolation") { "hello #{' '} world" }
suite.add("Format") { "%s %s" % ["hello", "world"] }

suite.run(iterations: 100_000)
```

---

## Part 2: Memory Profiling

### Step 4: Basic Memory Usage

**Goal**: Measure memory allocation.

```ruby
require 'objspace'

def measure_memory
  before = ObjectSpace.memsize_of_all
  yield
  after = ObjectSpace.memsize_of_all

  allocated = after - before
  puts "Memory allocated: #{allocated / 1024.0}KB"
end

measure_memory do
  array = Array.new(10_000) { |i| "string_#{i}" }
end
```

---

### Step 5: Object Allocation Tracking

**Goal**: Track object creation.

```ruby
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
```

**Test it**:
```ruby
profile = MemoryProfiler.profile do
  1000.times.map { |i| "string_#{i}" }
end

puts "Total objects allocated: #{profile[:total_allocated]}"
profile[:allocations].each do |type, count|
  puts "  #{type}: #{count}"
end
```

---

### Step 6: Memory-Efficient Alternatives

**Goal**: Identify and fix memory issues.

```ruby
class MemoryOptimizer
  def self.compare(name, &blocks)
    puts "\n" + "=" * 60
    puts "Memory Comparison: #{name}"
    puts "=" * 60

    blocks.call.each do |label, block|
      profile = MemoryProfiler.profile(&block)

      puts "\n#{label}:"
      puts "  Total allocations: #{profile[:total_allocated]}"
      puts "  Strings: #{profile[:allocations][:T_STRING] || 0}"
      puts "  Arrays: #{profile[:allocations][:T_ARRAY] || 0}"
      puts "  Hashes: #{profile[:allocations][:T_HASH] || 0}"
    end
  end
end
```

**Test it**:
```ruby
MemoryOptimizer.compare("Array Building") do
  {
    "Using << operator" => -> {
      arr = []
      1000.times { |i| arr << i }
    },

    "Using Array.new" => -> {
      Array.new(1000) { |i| i }
    }
  }
end
```

---

## Part 3: Optimization Techniques

### Step 7: Common Optimizations

**Goal**: Apply Ruby-specific optimizations.

```ruby
class Optimizer
  # 1. Use symbols instead of strings for keys
  def optimize_hash_keys
    suite = BenchmarkSuite.new("Hash Keys")

    suite.add("String keys") do
      hash = {}
      100.times { |i| hash["key_#{i}"] = i }
    end

    suite.add("Symbol keys") do
      hash = {}
      100.times { |i| hash[:"key_#{i}"] = i }
    end

    suite.run
  end

  # 2. Use blocks efficiently
  def optimize_blocks
    suite = BenchmarkSuite.new("Block Usage")
    arr = (1..1000).to_a

    suite.add("Block with each") do
      result = []
      arr.each { |x| result << x * 2 }
    end

    suite.add("Direct map") do
      arr.map { |x| x * 2 }
    end

    suite.add("Symbol to_proc") do
      arr.map(&:to_s)
    end

    suite.run
  end

  # 3. Avoid unnecessary allocations
  def optimize_allocations
    suite = BenchmarkSuite.new("Object Allocation")

    suite.add("New string each time") do
      100.times { str = "hello" }
    end

    suite.add("Frozen string") do
      frozen = "hello".freeze
      100.times { str = frozen }
    end

    suite.run
  end
end
```

---

### Step 8: Algorithmic Optimization

**Goal**: Improve algorithm efficiency.

```ruby
class AlgorithmOptimizer
  # Example: Finding duplicates

  def find_duplicates_naive(array)
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

  def find_duplicates_optimized(array)
    seen = {}
    array.each_with_object([]) do |item, duplicates|
      if seen[item]
        duplicates << item unless duplicates.include?(item)
      else
        seen[item] = true
      end
    end
  end

  def benchmark_algorithms
    array = Array.new(1000) { rand(1..500) }

    Benchmark.bm(20) do |x|
      x.report("Naive O(n²):") { find_duplicates_naive(array) }
      x.report("Optimized O(n):") { find_duplicates_optimized(array) }
    end
  end
end
```

---

### Step 9: Caching and Memoization

**Goal**: Cache expensive computations.

```ruby
class Fibonacci
  # Without memoization
  def self.calc_slow(n)
    return n if n <= 1
    calc_slow(n - 1) + calc_slow(n - 2)
  end

  # With memoization
  def self.calc_fast(n, cache = {})
    return n if n <= 1
    cache[n] ||= calc_fast(n - 1, cache) + calc_fast(n - 2, cache)
  end

  # Using instance variable for automatic memoization
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
```

**Test it**:
```ruby
Benchmark.bm(20) do |x|
  x.report("Without cache:") { Fibonacci.calc_slow(25) }
  x.report("With cache:") { Fibonacci.calc_fast(25) }
  x.report("Instance cache:") do
    fib = Fibonacci.new
    fib.calc(25)
  end
end
```

---

## 🎯 Final Challenge

1. Profile the intermediate lab blog system
2. Identify performance bottlenecks
3. Apply optimizations
4. Measure improvements

Create a report with:
- Before/after benchmarks
- Memory usage comparison
- Specific optimizations applied

---

## ✅ Completion Checklist

- [ ] Basic benchmarking with Benchmark
- [ ] Iterations per second measurement
- [ ] Custom benchmark suite
- [ ] Memory profiling
- [ ] Object allocation tracking
- [ ] Common Ruby optimizations
- [ ] Algorithmic improvements
- [ ] Caching and memoization

---

**Fantastic!** You're now a performance expert! Next → [Mini Framework Lab](../mini-framework-lab/README.md)
