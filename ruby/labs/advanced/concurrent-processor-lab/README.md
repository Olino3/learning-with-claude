# Advanced Lab 2: Concurrent Task Processor

Build a high-performance concurrent task processing system using threads, Ractors, and Fibers.

## 🎯 Learning Objectives

- Implement thread-based worker pools
- Use Ractors for CPU-bound parallel processing (Ruby 3.0+)
- Apply Fibers for cooperative concurrency
- Ensure thread safety with Mutexes
- Handle concurrent I/O efficiently

## 📋 Project Structure

```
concurrent-processor-lab/
├── README.md
├── lib/
│   ├── worker_pool.rb     # Thread-based worker pool
│   ├── ractor_processor.rb  # Ractor-based parallel processor
│   └── fiber_scheduler.rb # Fiber-based task scheduler
└── concurrent_demo.rb     # Main demo
```

## 🚀 Running the Lab

```bash
cd ruby/labs/advanced/concurrent-processor-lab
ruby concurrent_demo.rb
```

## 🐍 For Python Developers

Compares to:
- **ThreadPoolExecutor**: Our worker pool
- **ProcessPoolExecutor**: Our Ractor processor
- **asyncio**: Our Fiber scheduler
- **queue.Queue**: Thread-safe queue usage

## 🎓 Features

1. **Worker Pool**: Thread pool for concurrent I/O
2. **Ractor Processor**: Parallel CPU processing
3. **Fiber Scheduler**: Cooperative task scheduling
4. **Thread Safety**: Proper synchronization
5. **Error Handling**: Graceful failure handling

## 🎯 Challenges

- Add priority queue for tasks
- Implement backpressure control
- Create task cancellation
- Add monitoring and metrics
- Build retry logic with exponential backoff

---

Ready to process tasks concurrently? Run the demo!
