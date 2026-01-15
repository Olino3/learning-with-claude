#!/usr/bin/env ruby
# Step 3: Result Collection

require 'thread'

class ThreadPool
  def initialize(size: 4)
    @size = size
    @jobs = Queue.new
    @results = Queue.new
    @threads = []
  end

  def start
    @threads = @size.times.map do
      Thread.new do
        loop do
          job = @jobs.pop
          break if job == :shutdown

          begin
            result = job[:task].call
            @results.push({ id: job[:id], result: result, error: nil })
          rescue => e
            @results.push({ id: job[:id], result: nil, error: e.message })
          end
        end
      end
    end
  end

  def schedule(id, &block)
    @jobs.push({ id: id, task: block })
  end

  def results
    output = []
    until @results.empty?
      output << @results.pop
    end
    output
  end

  def shutdown
    @size.times { @jobs.push(:shutdown) }
    @threads.each(&:join)
  end
end

# Test it
puts "=" * 60
puts "Step 3: Result Collection"
puts "=" * 60
puts

pool = ThreadPool.new(size: 4)
pool.start

puts "Processing 10 calculations in parallel..."
puts

10.times do |i|
  pool.schedule(i) do
    sleep(rand * 0.2)  # Random delay
    i * i  # Return square
  end
end

pool.shutdown

results = pool.results.sort_by { |r| r[:id] }
puts "Results:"
results.each do |r|
  status = r[:error] ? "ERROR: #{r[:error]}" : "#{r[:id]}² = #{r[:result]}"
  puts "  Job #{r[:id]}: #{status}"
end

puts
puts "✓ Step 3 complete!"
