#!/usr/bin/env ruby
# Step 1: Basic Thread Pool

require 'thread'

class ThreadPool
  def initialize(size: 4)
    @size = size
    @jobs = Queue.new
    @threads = []
  end

  def start
    @threads = @size.times.map do
      Thread.new do
        loop do
          job = @jobs.pop
          break if job == :shutdown
          job.call
        end
      end
    end
  end

  def schedule(&block)
    @jobs.push(block)
  end

  def shutdown
    @size.times { @jobs.push(:shutdown) }
    @threads.each(&:join)
  end
end

# Test it
puts "=" * 60
puts "Step 1: Basic Thread Pool"
puts "=" * 60
puts

pool = ThreadPool.new(size: 4)
pool.start

puts "Scheduling 10 jobs across 4 threads..."
puts

10.times do |i|
  pool.schedule do
    sleep(0.1)  # Simulate some work
    puts "  Job #{i} completed by thread #{Thread.current.object_id}"
  end
end

pool.shutdown
puts
puts "All jobs completed!"
puts
puts "✓ Step 1 complete!"
