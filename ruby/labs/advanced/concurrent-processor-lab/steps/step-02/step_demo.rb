#!/usr/bin/env ruby
# Step 2: Thread Safety with Mutex

require 'thread'

class ThreadSafeCounter
  def initialize
    @count = 0
    @mutex = Mutex.new
  end

  def increment
    @mutex.synchronize do
      @count += 1
    end
  end

  def value
    @mutex.synchronize { @count }
  end
end

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

class TaskProcessor
  def initialize(thread_count: 4)
    @pool = ThreadPool.new(size: thread_count)
    @completed = ThreadSafeCounter.new
    @failed = ThreadSafeCounter.new
  end

  def process(tasks)
    @pool.start

    tasks.each do |task|
      @pool.schedule do
        begin
          task.call
          @completed.increment
        rescue => e
          @failed.increment
          puts "Error: #{e.message}"
        end
      end
    end

    @pool.shutdown

    { completed: @completed.value, failed: @failed.value }
  end
end

# Test it
puts "=" * 60
puts "Step 2: Thread Safety with Mutex"
puts "=" * 60
puts

# First, demonstrate the UNSAFE way
puts "Without Mutex (race condition):"
unsafe_count = 0
threads = 100.times.map do
  Thread.new do
    100.times { unsafe_count += 1 }
  end
end
threads.each(&:join)
puts "  Expected: 10000, Got: #{unsafe_count}"
puts

# Now the SAFE way
puts "With Mutex (thread-safe):"
safe_counter = ThreadSafeCounter.new
threads = 100.times.map do
  Thread.new do
    100.times { safe_counter.increment }
  end
end
threads.each(&:join)
puts "  Expected: 10000, Got: #{safe_counter.value}"
puts

# Process tasks with error handling
puts "Task Processor demo:"
processor = TaskProcessor.new(thread_count: 4)

tasks = 10.times.map do |i|
  -> {
    sleep(0.05)
    raise "Simulated error" if i == 5
    puts "  Task #{i} completed"
  }
end

result = processor.process(tasks)
puts
puts "Results: #{result}"
puts
puts "✓ Step 2 complete!"
