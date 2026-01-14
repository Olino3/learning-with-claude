# Fiber-Based Cooperative Scheduler

class FiberScheduler
  def initialize
    @tasks = []
  end

  def schedule(name = nil, &block)
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

class AsyncTask
  attr_reader :name, :result

  def initialize(name = nil, &block)
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

# Advanced Fiber scheduler with priorities
class PriorityFiberScheduler
  def initialize
    @tasks = { high: [], normal: [], low: [] }
  end

  def schedule(priority: :normal, &block)
    task = AsyncTask.new(&block)
    @tasks[priority] << task
    task
  end

  def run
    loop do
      # Process high priority first
      task = @tasks[:high].find(&:alive?) ||
             @tasks[:normal].find(&:alive?) ||
             @tasks[:low].find(&:alive?)

      break unless task
      task.resume
    end

    all_tasks.map(&:result)
  end

  private

  def all_tasks
    @tasks.values.flatten
  end
end
