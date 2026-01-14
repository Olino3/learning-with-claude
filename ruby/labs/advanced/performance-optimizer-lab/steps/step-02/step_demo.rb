#!/usr/bin/env ruby
# Step 2: Iterations Per Second

require 'benchmark'

puts "=" * 60
puts "Step 2: Iterations Per Second"
puts "=" * 60
puts

def measure_ips(label, duration: 2, &block)
  iterations = 0
  start_time = Time.now
  
  while (Time.now - start_time) < duration
    block.call
    iterations += 1
  end
  
  elapsed = Time.now - start_time
  ips = iterations / elapsed
  
  { label: label, iterations: iterations, elapsed: elapsed, ips: ips }
end

puts "Measuring iterations per second (2 second runs)..."
puts

results = []

results << measure_ips("String +=") do
  str = ""
  100.times { str += "x" }
end

results << measure_ips("String <<") do
  str = ""
  100.times { str << "x" }
end

results << measure_ips("Array.join") do
  arr = []
  100.times { arr << "x" }
  arr.join
end

puts "Results:"
puts "-" * 50
printf "%-20s %15s %10s\n", "Method", "Iterations/sec", "Relative"
puts "-" * 50

fastest = results.max_by { |r| r[:ips] }
results.sort_by { |r| -r[:ips] }.each do |r|
  relative = r[:ips] / fastest[:ips]
  printf "%-20s %15.0f %9.2fx\n", r[:label], r[:ips], relative
end

puts
puts "Note: 'benchmark-ips' gem provides more sophisticated IPS measurements"
puts
puts "✓ Step 2 complete!"
