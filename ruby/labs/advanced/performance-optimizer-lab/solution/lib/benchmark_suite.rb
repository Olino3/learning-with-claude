# Custom Benchmark Suite

require 'benchmark'

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
    slowest = results.max_by { |_, v| v[:real] }
    
    puts "\n" + "=" * 60
    puts "Fastest: #{fastest[0]} (#{(fastest[1][:real] * 1000).round(2)}ms)"
    puts "Slowest: #{slowest[0]} (#{(slowest[1][:real] * 1000).round(2)}ms)"
    puts "Speedup: #{(slowest[1][:real] / fastest[1][:real]).round(2)}x"
    puts "=" * 60

    results
  end
end

# Comparison helper
class BenchmarkCompare
  def self.run(name, iterations: 10_000, &block)
    suite = BenchmarkSuite.new(name)
    block.call(suite)
    suite.run(iterations: iterations)
  end
end
