#!/usr/bin/env ruby
# Concurrency and Parallelism Practice

require 'benchmark'
require 'thread'

puts "=" * 70
puts "CONCURRENCY AND PARALLELISM PRACTICE"
puts "Ruby Version: #{RUBY_VERSION}"
puts "=" * 70
puts

# Example 1: Thread Basics
puts "1. Thread Basics"
puts "-" * 70

def countdown(name, count)
  count.downto(1) do |i|
    puts "#{name}: #{i}"
    sleep(0.1)
  end
  "#{name} finished!"
end

thread1 = Thread.new { countdown("Thread-A", 5) }
thread2 = Thread.new { countdown("Thread-B", 5) }

puts "Main thread continues..."
result1 = thread1.value
result2 = thread2.value

puts result1
puts result2

puts

# Example 2: Thread-local Variables
puts "2. Thread-local Variables"
puts "-" * 70

Thread.current[:name] = "Main Thread"
Thread.current[:counter] = 0

puts "Main thread name: #{Thread.current[:name]}"

thread = Thread.new do
  Thread.current[:name] = "Worker Thread"
  Thread.current[:counter] = 100
  puts "Worker thread name: #{Thread.current[:name]}"
  puts "Worker thread counter: #{Thread.current[:counter]}"
end

thread.join

puts "Main thread name (unchanged): #{Thread.current[:name]}"
puts "Main thread counter: #{Thread.current[:counter]}"

puts

# Example 3: Race Condition Demonstration
puts "3. Race Condition Demonstration"
puts "-" * 70

# Unsafe counter
unsafe_counter = 0
threads = 10.times.map do
  Thread.new do
    1000.times { unsafe_counter += 1 }
  end
end
threads.each(&:join)

puts "Unsafe counter (expected 10000): #{unsafe_counter}"

# Safe counter with Mutex
safe_counter = 0
mutex = Mutex.new
threads = 10.times.map do
  Thread.new do
    1000.times do
      mutex.synchronize { safe_counter += 1 }
    end
  end
end
threads.each(&:join)

puts "Safe counter (expected 10000): #{safe_counter}"

puts

# Example 4: Thread-safe Queue
puts "4. Thread-safe Queue (Producer-Consumer)"
puts "-" * 70

queue = Queue.new

# Producer threads
producers = 3.times.map do |i|
  Thread.new do
    3.times do |j|
      item = "Item-#{i}-#{j}"
      queue.push(item)
      puts "Produced: #{item}"
      sleep(rand * 0.05)
    end
  end
end

# Consumer thread
consumer = Thread.new do
  9.times do
    item = queue.pop
    puts "  Consumed: #{item}"
    sleep(rand * 0.05)
  end
end

producers.each(&:join)
consumer.join

puts

# Example 5: Threads for I/O-bound Tasks
puts "5. Threads for I/O-bound Tasks"
puts "-" * 70

def simulate_io_operation(id)
  puts "Task #{id} starting..."
  sleep(0.2)  # Simulate I/O
  puts "Task #{id} completed!"
  "Result #{id}"
end

# Sequential
puts "Sequential execution:"
time_seq = Benchmark.realtime do
  5.times { |i| simulate_io_operation(i) }
end
puts "Time: #{time_seq.round(2)}s"

puts "\nConcurrent execution:"
time_concurrent = Benchmark.realtime do
  threads = 5.times.map { |i| Thread.new { simulate_io_operation(i) } }
  threads.each(&:join)
end
puts "Time: #{time_concurrent.round(2)}s"
puts "Speedup: #{(time_seq / time_concurrent).round(2)}x"

puts

# Example 6: Worker Pool Pattern
puts "6. Worker Pool Pattern"
puts "-" * 70

class WorkerPool
  def initialize(size)
    @queue = Queue.new
    @workers = size.times.map do |i|
      Thread.new do
        loop do
          job = @queue.pop
          break if job == :shutdown
          
          begin
            puts "Worker #{i} processing job"
            job.call
          rescue => e
            puts "Worker #{i} error: #{e.message}"
          end
        end
      end
    end
  end
  
  def schedule(&block)
    @queue.push(block)
  end
  
  def shutdown
    @workers.size.times { @queue.push(:shutdown) }
    @workers.each(&:join)
  end
end

pool = WorkerPool.new(3)

8.times do |i|
  pool.schedule do
    puts "  Job #{i} executing"
    sleep(0.05)
  end
end

pool.shutdown
puts "All jobs completed"

puts

# Example 7: Fibers for Cooperative Concurrency
puts "7. Fibers for Cooperative Concurrency"
puts "-" * 70

fiber = Fiber.new do
  puts "Fiber: Starting"
  Fiber.yield "First yield"
  puts "Fiber: Resumed after first yield"
  Fiber.yield "Second yield"
  puts "Fiber: Resumed after second yield"
  "Final result"
end

puts "Main: Calling fiber.resume"
result1 = fiber.resume
puts "Main: Got '#{result1}'"

puts "Main: Calling fiber.resume again"
result2 = fiber.resume
puts "Main: Got '#{result2}'"

puts "Main: Final resume"
result3 = fiber.resume
puts "Main: Got '#{result3}'"

puts

# Example 8: Fiber-based Generator
puts "8. Fiber-based Generator (Fibonacci)"
puts "-" * 70

def fibonacci_generator
  Fiber.new do
    a, b = 0, 1
    loop do
      Fiber.yield a
      a, b = b, a + b
    end
  end
end

fib = fibonacci_generator
print "First 15 Fibonacci numbers: "
15.times do
  print "#{fib.resume} "
end
puts

puts

# Example 9: Ractors (Ruby 3.0+)
puts "9. Ractors for True Parallelism (Ruby 3.0+)"
puts "-" * 70

if RUBY_VERSION >= "3.0.0"
  def fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end
  
  puts "Creating Ractors for parallel computation..."
  
  ractors = (30..34).map do |n|
    Ractor.new(n) do |num|
      result = fibonacci(num)
      [num, result]
    end
  end
  
  results = ractors.map(&:take)
  results.each do |n, fib|
    puts "fib(#{n}) = #{fib}"
  end
  
  # Ractor message passing
  puts "\nRactor message passing:"
  ractor = Ractor.new do
    3.times do
      message = Ractor.receive
      puts "Ractor received: #{message}"
      Ractor.yield "Processed: #{message.upcase}"
    end
  end
  
  ["hello", "world", "ruby"].each do |msg|
    ractor.send(msg)
    response = ractor.take
    puts "Main received: #{response}"
  end
else
  puts "Ractors require Ruby 3.0+"
  puts "Current version: #{RUBY_VERSION}"
  puts "Install Ruby 3.0+ to use Ractors"
end

puts

# Example 10: Async Task Pattern
puts "10. Async Task Pattern"
puts "-" * 70

class AsyncTask
  def initialize(&block)
    @result = nil
    @error = nil
    @completed = false
    @mutex = Mutex.new
    
    @thread = Thread.new do
      begin
        @result = block.call
      rescue => e
        @error = e
      ensure
        @mutex.synchronize { @completed = true }
      end
    end
  end
  
  def completed?
    @mutex.synchronize { @completed }
  end
  
  def wait
    @thread.join
    raise @error if @error
    @result
  end
  
  def result
    wait
  end
end

task1 = AsyncTask.new do
  sleep(0.2)
  "Task 1 result"
end

task2 = AsyncTask.new do
  sleep(0.3)
  "Task 2 result"
end

task3 = AsyncTask.new do
  sleep(0.1)
  "Task 3 result"
end

puts "Tasks running asynchronously..."
puts "Task 1: #{task1.result}"
puts "Task 2: #{task2.result}"
puts "Task 3: #{task3.result}"

puts

# Example 11: Deadlock Prevention
puts "11. Deadlock Prevention"
puts "-" * 70

mutex1 = Mutex.new
mutex2 = Mutex.new

def safe_operation(mutex1, mutex2, name)
  # Always acquire locks in the same order
  mutex1.synchronize do
    sleep(0.01)  # Simulate some work
    mutex2.synchronize do
      puts "#{name} acquired both locks safely"
    end
  end
end

threads = [
  Thread.new { safe_operation(mutex1, mutex2, "Thread 1") },
  Thread.new { safe_operation(mutex1, mutex2, "Thread 2") },
  Thread.new { safe_operation(mutex1, mutex2, "Thread 3") }
]

threads.each(&:join)
puts "No deadlock occurred!"

puts

# Example 12: Parallel Map Implementation
puts "12. Parallel Map Implementation"
puts "-" * 70

def parallel_map(array, thread_count: 4, &block)
  chunk_size = (array.size / thread_count.to_f).ceil
  chunks = array.each_slice(chunk_size).to_a
  
  threads = chunks.map do |chunk|
    Thread.new { chunk.map(&block) }
  end
  
  threads.flat_map(&:value)
end

numbers = (1..20).to_a

puts "Squaring numbers with parallel map:"
results = parallel_map(numbers, thread_count: 4) { |n| n * n }
puts results.inspect

puts

puts "=" * 70
puts "Practice complete! You've mastered Ruby concurrency!"
puts "=" * 70
puts
puts "Key Takeaways:"
puts "- Threads are great for I/O-bound tasks"
puts "- Use Mutex for thread safety"
puts "- Ractors enable true parallelism (Ruby 3.0+)"
puts "- Fibers provide cooperative concurrency"
puts "- Always prevent deadlocks by locking in order"
