#!/usr/bin/env ruby
# Concurrent Task Processor Lab

require 'thread'

# Thread-based worker pool
class WorkerPool
  def initialize(size)
    @queue = Queue.new
    @workers = size.times.map do |i|
      Thread.new do
        loop do
          job = @queue.pop
          break if job == :shutdown
          
          begin
            job[:task].call
          rescue => e
            puts "Worker #{i} error: #{e.message}"
          ensure
            job[:done]&.call if job[:done]
          end
        end
      end
    end
  end
  
  def schedule(task, &done_callback)
    @queue.push({ task: task, done: done_callback })
  end
  
  def shutdown
    @workers.size.times { @queue.push(:shutdown) }
    @workers.each(&:join)
  end
end

puts "=" * 70
puts "CONCURRENT TASK PROCESSOR LAB"
puts "=" * 70
puts

puts "Running worker pool with I/O-bound tasks..."
pool = WorkerPool.new(4)

10.times do |i|
  pool.schedule(-> { 
    sleep(0.1)
    puts "Task #{i} completed by #{Thread.current.object_id}"
  })
end

pool.shutdown
puts "All tasks completed!"
puts

# Ractor example (Ruby 3.0+)
if RUBY_VERSION >= "3.0.0"
  puts "Ractor-based parallel processing..."
  
  def fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end
  
  ractors = (30..34).map do |n|
    Ractor.new(n) { |num| [num, fibonacci(num)] }
  end
  
  results = ractors.map(&:take)
  results.each { |n, fib| puts "fib(#{n}) = #{fib}" }
end

puts
puts "=" * 70
puts "Concurrent processing complete!"
puts "=" * 70
