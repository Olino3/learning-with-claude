#!/usr/bin/env ruby
# Step 6: Basic Fiber Scheduler

puts "=" * 60
puts "Step 6: Basic Fiber Scheduler"
puts "=" * 60
puts

class FiberScheduler
  def initialize
    @tasks = []
  end

  def schedule(&block)
    fiber = Fiber.new(&block)
    @tasks << fiber
  end

  def run
    until @tasks.empty?
      fiber = @tasks.shift
      fiber.resume

      # If fiber is not finished, reschedule it
      @tasks << fiber if fiber.alive?
    end
  end
end

# Test it
puts "Cooperative multitasking with Fibers..."
puts "Tasks will interleave by yielding control voluntarily."
puts

scheduler = FiberScheduler.new

scheduler.schedule do
  3.times do |i|
    puts "  Task 1 - iteration #{i}"
    Fiber.yield
  end
end

scheduler.schedule do
  3.times do |i|
    puts "  Task 2 - iteration #{i}"
    Fiber.yield
  end
end

scheduler.schedule do
  2.times do |i|
    puts "  Task 3 - iteration #{i}"
    Fiber.yield
  end
end

puts "Starting scheduler..."
puts
scheduler.run

puts
puts "All tasks completed!"
puts
puts "Key insight: Fibers are cooperative (not preemptive)."
puts "Each task explicitly yields control with Fiber.yield"
puts
puts "✓ Step 6 complete!"
