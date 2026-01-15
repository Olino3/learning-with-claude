#!/usr/bin/env ruby
# Step 5: Ractor Worker Pool (Ruby 3.0+)

puts "=" * 60
puts "Step 5: Ractor Worker Pool"
puts "=" * 60
puts

if RUBY_VERSION < "3.0.0"
  puts "This step requires Ruby 3.0 or later."
  puts "Your Ruby version: #{RUBY_VERSION}"
  exit
end

class RactorWorkerPool
  def initialize(worker_count: 4)
    @worker_count = worker_count
  end

  def process(items, &block)
    # Create one Ractor per item for simplicity
    ractors = items.each_with_index.map do |item, index|
      Ractor.new(item, index, block) do |data, id, worker|
        result = worker.call(data)
        { id: id, result: result }
      end
    end

    # Collect all results
    results = ractors.map(&:take)
    
    # Sort by original index and extract results
    results.sort_by { |r| r[:id] }.map { |r| r[:result] }
  end
end

# Test it
pool = RactorWorkerPool.new(worker_count: 4)

puts "Processing data in parallel with Ractor pool..."
puts

# CPU-intensive work: computing squares
data = (1..10).to_a
start_time = Time.now

results = pool.process(data) do |n|
  # Simulate CPU work
  sum = 0
  10_000.times { sum += n }
  n * n
end

elapsed = Time.now - start_time

puts "Input:  #{data.inspect}"
puts "Output: #{results.inspect}"
puts "Time:   #{(elapsed * 1000).round}ms"
puts
puts "✓ Step 5 complete!"
