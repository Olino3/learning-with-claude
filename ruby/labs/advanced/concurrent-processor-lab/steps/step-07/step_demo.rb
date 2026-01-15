#!/usr/bin/env ruby
# Step 7: Async Tasks with Fibers

puts "=" * 60
puts "Step 7: Async Tasks with Fibers"
puts "=" * 60
puts

class AsyncTask
  attr_reader :name, :result

  def initialize(name, &block)
    @name = name
    @fiber = Fiber.new(&block)
    @completed = false
    @result = nil
  end

  def resume
    return @result if @completed

    result = @fiber.resume
    
    unless @fiber.alive?
      @completed = true
      @result = result
    end

    result
  end

  def completed?
    @completed
  end

  def alive?
    !@completed && @fiber.alive?
  end
end

class FiberScheduler
  def initialize
    @tasks = []
  end

  def schedule(name, &block)
    task = AsyncTask.new(name, &block)
    @tasks << task
    task
  end

  def run
    until @tasks.all?(&:completed?)
      @tasks.each do |task|
        task.resume if task.alive?
      end
    end

    @tasks.map { |t| { name: t.name, result: t.result } }
  end

  def self.yield_control
    Fiber.yield
  end
end

# Test it
puts "Running async tasks with result collection..."
puts

scheduler = FiberScheduler.new

scheduler.schedule("Counter A") do
  sum = 0
  5.times do |i|
    sum += i
    puts "  Counter A: sum = #{sum}"
    FiberScheduler.yield_control
  end
  sum  # Return final value
end

scheduler.schedule("Counter B") do
  product = 1
  4.times do |i|
    product *= (i + 1)
    puts "  Counter B: product = #{product}"
    FiberScheduler.yield_control
  end
  product  # Return final value
end

scheduler.schedule("Quick task") do
  puts "  Quick task: computing..."
  FiberScheduler.yield_control
  puts "  Quick task: done!"
  42  # Return value
end

puts "Starting scheduler..."
puts
results = scheduler.run

puts
puts "Task results:"
results.each do |r|
  puts "  #{r[:name]} => #{r[:result]}"
end

puts
puts "=" * 60
puts "✓ Step 7 complete! Concurrent Processor Lab finished!"
puts "=" * 60
