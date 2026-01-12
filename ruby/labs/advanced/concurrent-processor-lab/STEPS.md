# Progressive Learning Guide: Concurrent Task Processor

Build three different concurrency models step by step.

## 🎯 Overview

Build three progressively advanced concurrent processors:
1. **Thread Pool** - Basic multi-threading with worker pool
2. **Ractor Processor** - Parallel processing with Ractors (Ruby 3+)
3. **Fiber Scheduler** - Cooperative multitasking with Fibers

---

## Part 1: Thread-Based Worker Pool

### Step 1: Basic Thread Pool

**Goal**: Create a pool of worker threads.

```ruby
class ThreadPool
  def initialize(size: 4)
    @size = size
    @jobs = Queue.new
    @threads = []
  end

  def start
    @size.times do
      @threads << Thread.new do
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
```

**Test it**:
```ruby
pool = ThreadPool.new(size: 4)
pool.start

10.times do |i|
  pool.schedule { puts "Job #{i} on thread #{Thread.current.object_id}" }
end

pool.shutdown
```

---

### Step 2: Add Thread Safety with Mutex

**Goal**: Protect shared state with mutexes.

```ruby
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
```

---

### Step 3: Add Result Collection

**Goal**: Collect results from threads safely.

```ruby
class ThreadPool
  def initialize(size: 4)
    @size = size
    @jobs = Queue.new
    @results = Queue.new
    @threads = []
  end

  def start
    @size.times do
      @threads << Thread.new do
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
```

---

## Part 2: Ractor-Based Parallel Processor

### Step 4: Basic Ractor Processing

**Goal**: Use Ractors for true parallelism (Ruby 3+).

```ruby
class RactorProcessor
  def self.process(items, &block)
    ractors = items.map do |item|
      Ractor.new(item, block) do |data, worker|
        worker.call(data)
      end
    end

    ractors.map(&:take)
  end
end
```

**Test it**:
```ruby
results = RactorProcessor.process([1, 2, 3, 4, 5]) do |n|
  n * n
end

puts results.inspect  # => [1, 4, 9, 16, 25]
```

---

### Step 5: Add Ractor Worker Pool

**Goal**: Create a pool of Ractor workers.

```ruby
class RactorWorkerPool
  def initialize(worker_count: 4)
    @workers = Array.new(worker_count) do
      Ractor.new do
        loop do
          task = Ractor.receive
          break if task == :shutdown

          result = task[:block].call(task[:data])
          Ractor.yield({ id: task[:id], result: result })
        end
      end
    end
  end

  def process(items, &block)
    items.each_with_index do |item, index|
      worker = @workers[index % @workers.size]
      worker.send({ id: index, data: item, block: block })
    end

    results = []
    items.size.times do
      _ractor, result = Ractor.select(*@workers)
      results << result
    end

    results.sort_by { |r| r[:id] }.map { |r| r[:result] }
  end

  def shutdown
    @workers.each { |w| w.send(:shutdown) }
  end
end
```

---

## Part 3: Fiber-Based Cooperative Scheduler

### Step 6: Basic Fiber Task Scheduler

**Goal**: Use Fibers for cooperative multitasking.

```ruby
class FiberScheduler
  def initialize
    @tasks = []
  end

  def schedule(&block)
    fiber = Fiber.new do
      block.call
    end
    @tasks << fiber
  end

  def run
    until @tasks.empty?
      fiber = @tasks.shift
      result = fiber.resume

      # If fiber is not finished, reschedule it
      @tasks << fiber if fiber.alive?
    end
  end
end
```

**Test it**:
```ruby
scheduler = FiberScheduler.new

scheduler.schedule do
  3.times do |i|
    puts "Task 1 - iteration #{i}"
    Fiber.yield
  end
end

scheduler.schedule do
  3.times do |i|
    puts "Task 2 - iteration #{i}"
    Fiber.yield
  end
end

scheduler.run
```

---

### Step 7: Add Async I/O with Fibers

**Goal**: Simulate async operations with Fibers.

```ruby
class AsyncTask
  def initialize(&block)
    @fiber = Fiber.new(&block)
    @completed = false
    @result = nil
  end

  def resume
    return @result if @completed

    result = @fiber.resume
    if @fiber.alive?
      result
    else
      @completed = true
      @result = result
    end
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

  def schedule(&block)
    @tasks << AsyncTask.new(&block)
  end

  def run
    until @tasks.all?(&:completed?)
      @tasks.each do |task|
        task.resume if task.alive?
      end
    end

    @tasks.map(&:resume)
  end
end
```

---

## 🎯 Final Challenge

1. Create a benchmark comparing all three approaches
2. Process a large dataset (e.g., 1000 items)
3. Measure execution time and memory usage
4. Compare Thread Pool vs Ractor vs Fiber performance

Run: `ruby concurrent_demo.rb`

---

## ✅ Completion Checklist

- [ ] Thread pool with Queue
- [ ] Thread-safe counters with Mutex
- [ ] Result collection from threads
- [ ] Basic Ractor processing
- [ ] Ractor worker pool
- [ ] Basic Fiber scheduler
- [ ] Async task management with Fibers
- [ ] Performance comparison

---

**Great work!** You've mastered Ruby concurrency! Next → [Performance Optimizer Lab](../performance-optimizer-lab/README.md)
