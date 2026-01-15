# Thread-Based Worker Pool with Result Collection

require 'thread'

class WorkerPool
  def initialize(size: 4)
    @size = size
    @jobs = Queue.new
    @results = Queue.new
    @threads = []
  end

  def start
    @threads = @size.times.map do |worker_id|
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
    self
  end

  def schedule(id, &block)
    start if @threads.empty?
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
    self
  end
end

# Thread-safe counter
class ThreadSafeCounter
  def initialize
    @count = 0
    @mutex = Mutex.new
  end

  def increment
    @mutex.synchronize { @count += 1 }
  end

  def decrement
    @mutex.synchronize { @count -= 1 }
  end

  def value
    @mutex.synchronize { @count }
  end
end

# Task processor with error tracking
class TaskProcessor
  def initialize(thread_count: 4)
    @pool = WorkerPool.new(size: thread_count)
    @completed = ThreadSafeCounter.new
    @failed = ThreadSafeCounter.new
  end

  def process(tasks)
    @pool.start

    tasks.each_with_index do |task, index|
      @pool.schedule(index) do
        begin
          result = task.call
          @completed.increment
          result
        rescue => e
          @failed.increment
          raise
        end
      end
    end

    @pool.shutdown

    {
      completed: @completed.value,
      failed: @failed.value,
      results: @pool.results
    }
  end
end
