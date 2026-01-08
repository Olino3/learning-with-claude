# Tutorial 18: Concurrency and Parallelism

Welcome to Ruby's concurrency model! This tutorial covers threads, the Global VM Lock (GVL), Ractors for true parallelism, and Fibers for cooperative concurrency.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand the Global VM Lock (GVL) and its implications
- Use Threads effectively for concurrent I/O
- Master Ractors (Ruby 3.0+) for true parallel execution
- Implement Fibers for lightweight cooperative concurrency
- Handle thread safety with Mutexes and thread-local variables
- Avoid deadlocks and race conditions
- Choose the right concurrency model for your use case

## 🐍➡️🔴 Coming from Python

Python and Ruby have similar concurrency challenges due to global locks:

| Concept | Python | Ruby |
|---------|--------|------|
| Global lock | GIL (Global Interpreter Lock) | GVL (Global VM Lock) |
| Threads | `threading.Thread` | `Thread.new` |
| True parallelism | `multiprocessing.Process` | `Ractor` (Ruby 3.0+) |
| Async/await | `asyncio`, `async`/`await` | Fibers + libraries like `async` |
| Thread safety | `threading.Lock` | `Mutex` |
| Thread-local storage | `threading.local()` | `Thread.current[:key]` |
| Concurrent futures | `concurrent.futures` | `Concurrent::Promise` (gem) |

> **📘 Python Note:** The GVL in Ruby is like Python's GIL - only one thread executes Ruby code at a time. However, I/O operations release the lock, making threads useful for I/O-bound tasks. For CPU-bound parallelism, use Ractors (like Python's multiprocessing).

## 📝 Understanding the Global VM Lock (GVL)

The GVL prevents multiple threads from executing Ruby code simultaneously:

```ruby
require 'benchmark'

def cpu_intensive_work(n)
  sum = 0
  n.times { sum += 1 }
  sum
end

# Single-threaded
puts "Single-threaded execution:"
time_single = Benchmark.realtime do
  2.times { cpu_intensive_work(100_000_000) }
end
puts "Time: #{time_single.round(2)}s"

# Multi-threaded (won't be faster due to GVL!)
puts "\nMulti-threaded execution:"
time_multi = Benchmark.realtime do
  threads = 2.times.map do
    Thread.new { cpu_intensive_work(100_000_000) }
  end
  threads.each(&:join)
end
puts "Time: #{time_multi.round(2)}s"
puts "Speedup: #{(time_single / time_multi).round(2)}x"
```

> **📘 Python Note:** This is exactly like Python's GIL. Multi-threading doesn't speed up CPU-bound work because only one thread runs at a time.

### When Threads ARE Useful (I/O-bound)

Threads release the GVL during I/O operations:

```ruby
require 'net/http'
require 'benchmark'

urls = [
  'https://www.ruby-lang.org',
  'https://rubygems.org',
  'https://guides.rubyonrails.org',
  'https://www.github.com'
]

def fetch_url(url)
  uri = URI(url)
  Net::HTTP.get_response(uri)
rescue => e
  puts "Error fetching #{url}: #{e.message}"
end

# Sequential
time_seq = Benchmark.realtime do
  urls.each { |url| fetch_url(url) }
end
puts "Sequential: #{time_seq.round(2)}s"

# Concurrent (much faster!)
time_concurrent = Benchmark.realtime do
  threads = urls.map do |url|
    Thread.new { fetch_url(url) }
  end
  threads.each(&:join)
end
puts "Concurrent: #{time_concurrent.round(2)}s"
puts "Speedup: #{(time_seq / time_concurrent).round(2)}x"
```

## 📝 Thread Basics

### Creating and Managing Threads

```ruby
# Create a thread
thread = Thread.new do
  puts "Thread started!"
  sleep(1)
  puts "Thread finished!"
  "result value"
end

puts "Main thread continues..."

# Wait for thread to complete
result = thread.join
puts "Thread returned: #{result.value}"

# Check thread status
thread2 = Thread.new { sleep(5) }
puts "Thread alive? #{thread2.alive?}"
puts "Thread status: #{thread2.status}"  # "run" or "sleep"
thread2.kill  # Force stop
```

### Thread-local Variables

```ruby
Thread.current[:user_id] = 42
Thread.current[:name] = "Alice"

puts "Main thread user_id: #{Thread.current[:user_id]}"

thread = Thread.new do
  Thread.current[:user_id] = 100
  Thread.current[:name] = "Bob"
  puts "Worker thread user_id: #{Thread.current[:user_id]}"
end

thread.join

puts "Main thread user_id (unchanged): #{Thread.current[:user_id]}"
```

> **📘 Python Note:** Like `threading.local()` in Python, but simpler syntax using hash-like access.

## 📝 Thread Safety and Mutexes

### Race Condition Example

```ruby
# UNSAFE: Race condition!
counter = 0
threads = 10.times.map do
  Thread.new do
    1000.times { counter += 1 }  # Not atomic!
  end
end
threads.each(&:join)

puts "Expected: 10000, Got: #{counter}"  # Probably wrong!
```

### Safe with Mutex

```ruby
require 'thread'

counter = 0
mutex = Mutex.new

threads = 10.times.map do
  Thread.new do
    1000.times do
      mutex.synchronize { counter += 1 }
    end
  end
end
threads.each(&:join)

puts "Expected: 10000, Got: #{counter}"  # Correct!
```

> **📘 Python Note:** Like `threading.Lock()` in Python. Use `synchronize` to ensure only one thread executes critical sections.

### Thread-safe Queue

```ruby
require 'thread'

queue = Queue.new  # Thread-safe queue

# Producer threads
producers = 3.times.map do |i|
  Thread.new do
    5.times do |j|
      item = "Item-#{i}-#{j}"
      queue.push(item)
      puts "Produced: #{item}"
      sleep(rand * 0.1)
    end
  end
end

# Consumer threads
consumers = 2.times.map do
  Thread.new do
    loop do
      item = queue.pop
      break if item == :done
      puts "  Consumed: #{item}"
      sleep(rand * 0.1)
    end
  end
end

# Wait for producers
producers.each(&:join)

# Signal consumers to stop
consumers.size.times { queue.push(:done) }
consumers.each(&:join)
```

## 📝 Ractors - True Parallelism (Ruby 3.0+)

Ractors provide true parallel execution without shared memory:

```ruby
# Check Ruby version
if RUBY_VERSION >= "3.0.0"
  # Simple Ractor example
  ractor = Ractor.new do
    puts "Ractor executing on different core!"
    42
  end
  
  result = ractor.take  # Wait for result
  puts "Ractor returned: #{result}"
  
  # Parallel computation with Ractors
  def fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end
  
  # Create Ractors for parallel work
  ractors = (35..39).map do |n|
    Ractor.new(n) do |num|
      [num, fibonacci(num)]
    end
  end
  
  # Collect results
  results = ractors.map(&:take)
  results.each do |n, fib|
    puts "fib(#{n}) = #{fib}"
  end
else
  puts "Ractors require Ruby 3.0+. Current version: #{RUBY_VERSION}"
end
```

### Ractor Communication

```ruby
if RUBY_VERSION >= "3.0.0"
  # Ractors communicate via message passing
  ractor = Ractor.new do
    loop do
      message = Ractor.receive
      break if message == :stop
      
      puts "Ractor received: #{message}"
      Ractor.yield "Processed: #{message}"
    end
  end
  
  # Send messages
  ractor.send("Hello")
  ractor.send("World")
  ractor.send(:stop)
  
  # Receive responses
  puts ractor.take
  puts ractor.take
end
```

### Ractor Restrictions

```ruby
if RUBY_VERSION >= "3.0.0"
  # Ractors can only share immutable objects
  
  # OK: Immutable values
  Ractor.new(42) { |n| n * 2 }
  Ractor.new("hello".freeze) { |s| s.upcase }
  
  # NOT OK: Mutable objects
  # arr = [1, 2, 3]
  # Ractor.new(arr) { |a| a.sum }  # Error!
  
  # Solution: Make shareable
  arr = [1, 2, 3].freeze
  Ractor.make_shareable(arr)
  result = Ractor.new(arr) { |a| a.sum }.take
  puts "Sum: #{result}"
end
```

> **📘 Python Note:** Ractors are like Python's `multiprocessing.Process` - separate interpreters with no shared memory. Communication is via message passing (like queues in multiprocessing).

## 📝 Fibers - Lightweight Cooperative Concurrency

Fibers are like lightweight threads with manual scheduling:

```ruby
fiber = Fiber.new do
  puts "Fiber started"
  Fiber.yield "First yield"
  puts "Fiber resumed"
  Fiber.yield "Second yield"
  puts "Fiber finishing"
  "Final value"
end

puts "Main: Starting fiber"
result1 = fiber.resume
puts "Main: Got #{result1}"

puts "Main: Resuming fiber"
result2 = fiber.resume
puts "Main: Got #{result2}"

puts "Main: Final resume"
result3 = fiber.resume
puts "Main: Got #{result3}"
```

### Fibers for Generators

```ruby
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
10.times do
  puts fib.resume
end
```

> **📘 Python Note:** Fibers are similar to Python generators with `yield`, but more general-purpose. They can be resumed from anywhere, not just in iteration.

### Fiber-based Pipeline

```ruby
# Producer fiber
producer = Fiber.new do
  10.times do |i|
    puts "Producing: #{i}"
    Fiber.yield i
  end
  nil
end

# Transformer fiber
transformer = Fiber.new do
  loop do
    value = producer.resume
    break unless value
    puts "Transforming: #{value}"
    Fiber.yield value * 2
  end
end

# Consumer (main)
loop do
  value = transformer.resume
  break unless value
  puts "Consuming: #{value}"
end
```

## 📝 Practical Patterns

### 1. Worker Pool Pattern

```ruby
class WorkerPool
  def initialize(size)
    @queue = Queue.new
    @workers = size.times.map do |i|
      Thread.new do
        loop do
          job = @queue.pop
          break if job == :shutdown
          
          begin
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

# Usage
pool = WorkerPool.new(4)

10.times do |i|
  pool.schedule do
    puts "Processing job #{i} in #{Thread.current.object_id}"
    sleep(0.1)
  end
end

pool.shutdown
```

### 2. Parallel Map

```ruby
def parallel_map(array, thread_count: 4, &block)
  chunk_size = (array.size / thread_count.to_f).ceil
  chunks = array.each_slice(chunk_size).to_a
  
  threads = chunks.map do |chunk|
    Thread.new { chunk.map(&block) }
  end
  
  threads.flat_map { |t| t.value }
end

# Usage
numbers = (1..100).to_a
results = parallel_map(numbers) { |n| n * n }
puts results.first(10)
```

### 3. Async Task Runner

```ruby
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

# Usage
task1 = AsyncTask.new { sleep(1); "Task 1 complete" }
task2 = AsyncTask.new { sleep(1); "Task 2 complete" }

puts "Tasks running..."
puts task1.result
puts task2.result
```

## 📝 Deadlock Prevention

```ruby
# DEADLOCK EXAMPLE (don't run this!)
# mutex1 = Mutex.new
# mutex2 = Mutex.new
# 
# t1 = Thread.new do
#   mutex1.synchronize do
#     sleep 0.1
#     mutex2.synchronize { puts "Thread 1" }
#   end
# end
# 
# t2 = Thread.new do
#   mutex2.synchronize do
#     sleep 0.1
#     mutex1.synchronize { puts "Thread 2" }
#   end
# end

# SOLUTION: Always acquire locks in same order
mutex1 = Mutex.new
mutex2 = Mutex.new

def safe_operation(mutex1, mutex2, name)
  # Always lock mutex1 before mutex2
  mutex1.synchronize do
    mutex2.synchronize do
      puts "#{name} acquired both locks"
    end
  end
end

t1 = Thread.new { safe_operation(mutex1, mutex2, "Thread 1") }
t2 = Thread.new { safe_operation(mutex1, mutex2, "Thread 2") }

t1.join
t2.join
```

## ✍️ Practice Exercise

Run the practice script to see concurrency in action:

```bash
ruby ruby/tutorials/advanced/18-Concurrency-and-Parallelism/exercises/concurrency_practice.rb
```

## 📚 What You Learned

✅ Understanding the GVL and its impact on threading
✅ Using threads for I/O-bound concurrency
✅ Ractors for CPU-bound parallelism (Ruby 3.0+)
✅ Fibers for cooperative concurrency
✅ Thread safety with Mutexes
✅ Avoiding deadlocks and race conditions
✅ Practical concurrency patterns

## 🔜 Next Steps

**Next tutorial: 19-MRI-Internals** - Explore Ruby's C implementation, garbage collection, and memory management.

## 💡 Key Takeaways for Python Developers

1. **GVL = GIL**: Same limitation - threads don't help CPU-bound tasks
2. **Threads for I/O**: Like Python, threads work great for I/O operations
3. **Ractors = multiprocessing**: True parallelism with separate interpreters
4. **Fibers ≈ generators**: Cooperative concurrency, more flexible than generators
5. **Queue is thread-safe**: Like Python's `queue.Queue`
6. **Mutex = Lock**: Same concept, different name

## 🆘 Common Pitfalls

### Pitfall 1: Expecting thread speedup for CPU work

```ruby
# Won't speed up due to GVL!
threads = 4.times.map { Thread.new { heavy_computation() } }
threads.each(&:join)

# Use Ractors instead (Ruby 3.0+)
ractors = 4.times.map { Ractor.new { heavy_computation() } }
results = ractors.map(&:take)
```

### Pitfall 2: Forgetting to synchronize

```ruby
# BAD: Race condition
@counter += 1

# GOOD: Thread-safe
@mutex.synchronize { @counter += 1 }
```

### Pitfall 3: Sharing mutable data with Ractors

```ruby
# BAD: Won't work
arr = [1, 2, 3]
Ractor.new(arr) { |a| a.sum }  # Error!

# GOOD: Make shareable
arr = [1, 2, 3].freeze
Ractor.make_shareable(arr)
Ractor.new(arr) { |a| a.sum }
```

## 📖 Additional Resources

- [Ruby Concurrency Guide](https://www.rubyguides.com/2015/07/ruby-threads/)
- [Ractors Documentation](https://docs.ruby-lang.org/en/master/Ractor.html)
- [Fibers Guide](https://ruby-doc.org/core/Fiber.html)
- [Working with Ruby Threads](https://www.jstorimer.com/products/working-with-ruby-threads)

---

Ready to master concurrent programming? Run the exercises and explore Ruby's concurrency models!
