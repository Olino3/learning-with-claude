#!/usr/bin/env ruby
# Step 3: Custom Benchmark Suite

require 'benchmark'

puts "=" * 60
puts "Step 3: Custom Benchmark Suite"
puts "=" * 60
puts

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
    puts "Iterations: #{iterations}"
    puts "=" * 60

    results = {}

    @benchmarks.each do |label, block|
      time = Benchmark.measure do
        iterations.times { block.call }
      end

      results[label] = {
        real: time.real,
        user: time.user,
        total: time.total
      }

      puts "\n#{label}:"
      puts "  Real time: #{(time.real * 1000).round(2)}ms"
      puts "  User CPU: #{(time.user * 1000).round(2)}ms"
    end

    fastest = results.min_by { |_, v| v[:real] }
    slowest = results.max_by { |_, v| v[:real] }
    
    puts "\n" + "-" * 60
    puts "Fastest: #{fastest[0]} (#{(fastest[1][:real] * 1000).round(2)}ms)"
    puts "Slowest: #{slowest[0]} (#{(slowest[1][:real] * 1000).round(2)}ms)"
    
    if fastest[1][:real] > 0
      puts "Speedup: #{(slowest[1][:real] / fastest[1][:real]).round(2)}x"
    end

    results
  end
end

# Test the suite
suite = BenchmarkSuite.new("String Operations")

suite.add("Concatenation (+)") { "hello" + " " + "world" }
suite.add("Interpolation") { "hello #{' '} world" }
suite.add("Format (%)") { "%s %s" % ["hello", "world"] }
suite.add("Shovel (<<)") { "hello" << " " << "world" }

suite.run(iterations: 100_000)

puts
puts "✓ Step 3 complete!"
