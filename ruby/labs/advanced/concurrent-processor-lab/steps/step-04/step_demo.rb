#!/usr/bin/env ruby
# Step 4: Basic Ractor Processing (Ruby 3.0+)

puts "=" * 60
puts "Step 4: Basic Ractor Processing"
puts "=" * 60
puts

if RUBY_VERSION < "3.0.0"
  puts "This step requires Ruby 3.0 or later."
  puts "Your Ruby version: #{RUBY_VERSION}"
  puts
  puts "Ractors enable true parallelism by bypassing the GVL."
  puts "Please upgrade to Ruby 3.0+ to run this demo."
  exit
end

class RactorProcessor
  def self.process(items, &block)
    ractors = items.map do |item|
      Ractor.new(item, &block)
    end

    ractors.map(&:take)
  end
end

# Define fibonacci in a way Ractors can use
def ractor_fibonacci(n)
  return n if n <= 1
  ractor_fibonacci(n - 1) + ractor_fibonacci(n - 2)
end

puts "Computing Fibonacci numbers in parallel..."
puts "(Each Ractor runs independently, truly parallel!)"
puts

# Simple parallel processing
numbers = [25, 26, 27, 28, 29]
start_time = Time.now

ractors = numbers.map do |n|
  Ractor.new(n) do |num|
    # Each Ractor has its own copy of this computation
    fib = ->(x) { x <= 1 ? x : fib.call(x-1) + fib.call(x-2) }
    [num, fib.call(num)]
  end
end

results = ractors.map(&:take)
elapsed = Time.now - start_time

puts "Results:"
results.each do |n, fib|
  puts "  fib(#{n}) = #{fib}"
end
puts
puts "Time: #{(elapsed * 1000).round}ms (parallel execution)"
puts
puts "Note: With threads, these would run sequentially due to GVL."
puts "      Ractors enable true CPU parallelism!"
puts
puts "✓ Step 4 complete!"
