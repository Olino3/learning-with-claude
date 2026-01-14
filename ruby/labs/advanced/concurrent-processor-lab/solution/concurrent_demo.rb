#!/usr/bin/env ruby
# Concurrent Processor Lab - Complete Solution Demo

require_relative 'lib/worker_pool'
require_relative 'lib/ractor_processor'
require_relative 'lib/fiber_scheduler'

puts "=" * 70
puts "CONCURRENT PROCESSOR LAB - COMPLETE SOLUTION"
puts "=" * 70
puts

# ============================================================
# Part 1: Thread-Based Worker Pool
# ============================================================
puts "Part 1: Thread-Based Worker Pool"
puts "-" * 70

pool = WorkerPool.new(size: 4)
results = []
mutex = Mutex.new

puts "Processing 10 jobs with 4 worker threads..."
start_time = Time.now

10.times do |i|
  pool.schedule(i) do
    sleep(0.1)  # Simulate I/O work
    i * 2
  end
end

pool.shutdown
collected_results = pool.results

puts "Results: #{collected_results.sort_by { |r| r[:id] }.map { |r| "Job #{r[:id]}=#{r[:result]}" }.join(', ')}"
puts "Time: #{((Time.now - start_time) * 1000).round}ms (parallel, not 1000ms sequential)"
puts

# ============================================================
# Part 2: Ractor-Based Parallel Processor (Ruby 3.0+)
# ============================================================
if RUBY_VERSION >= "3.0.0"
  puts "Part 2: Ractor-Based Parallel Processor"
  puts "-" * 70

  def fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end

  puts "Computing Fibonacci numbers in parallel with Ractors..."
  start_time = Time.now

  results = RactorProcessor.process([30, 31, 32, 33, 34]) do |n|
    # Each Ractor computes independently
    fib = proc { |x| x <= 1 ? x : fib.call(x-1) + fib.call(x-2) }
    [n, fib.call(n)]
  end

  results.each { |n, fib| puts "  fib(#{n}) = #{fib}" }
  puts "Time: #{((Time.now - start_time) * 1000).round}ms"
  puts
else
  puts "Part 2: Ractor-Based Processor (skipped - requires Ruby 3.0+)"
  puts "-" * 70
  puts "Your Ruby version: #{RUBY_VERSION}"
  puts
end

# ============================================================
# Part 3: Fiber-Based Cooperative Scheduler
# ============================================================
puts "Part 3: Fiber-Based Cooperative Scheduler"
puts "-" * 70

scheduler = FiberScheduler.new

puts "Running cooperative tasks with Fibers..."

scheduler.schedule("Task A") do
  3.times do |i|
    puts "  Task A - iteration #{i}"
    FiberScheduler.yield_control
  end
  "Task A complete"
end

scheduler.schedule("Task B") do
  3.times do |i|
    puts "  Task B - iteration #{i}"
    FiberScheduler.yield_control
  end
  "Task B complete"
end

scheduler.schedule("Task C") do
  2.times do |i|
    puts "  Task C - iteration #{i}"
    FiberScheduler.yield_control
  end
  "Task C complete"
end

results = scheduler.run
puts
puts "Results: #{results.inspect}"
puts

puts "=" * 70
puts "All concurrency patterns demonstrated!"
puts "=" * 70
