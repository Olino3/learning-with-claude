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
├── README.md (this file)
├── STEPS.md                   # Step-by-step build guide
├── solution/                  # Complete working solution
│   ├── RUN.md                 # How to run the solution
│   ├── concurrent_demo.rb     # Main demo application
│   └── lib/
│       ├── worker_pool.rb     # Thread-based worker pool
│       ├── ractor_processor.rb  # Ractor-based parallel processor
│       └── fiber_scheduler.rb # Fiber-based task scheduler
└── steps/                     # Step-by-step implementation
    ├── step-01/               # Basic Thread Pool
    ├── step-02/               # Thread Safety with Mutex
    ├── step-03/               # Result Collection
    ├── step-04/               # Ractor Basics
    ├── step-05/               # Ractor Message Passing
    ├── step-06/               # Fiber Basics
    └── step-07/               # Fiber Scheduler
```

## 🚀 Running the Lab

### Quick Start

Run the complete concurrent processor demo:

```bash
make advanced-lab NUM=2
```

### Learning Approaches

**Option 1: Study Complete System** (Quick Overview)
- Run the complete system with `make advanced-lab NUM=2`
- Review the code in `solution/concurrent_demo.rb` and `solution/lib/` directory
- See threads, ractors, and fibers working together

**Option 2: Progressive Building** (Recommended for Learning)
- Follow the step-by-step guide in the `steps/` directory
- Each step introduces new concurrency concepts
- Run each step's demo: `ruby steps/step-01/step_demo.rb`
- Steps: Thread Pool → Mutexes → Ractors → Fibers

**Option 3: Read Solution Guide**
- Check [solution/README.md](solution/README.md) for detailed implementation notes
- Review concurrency patterns and thread safety approaches

### Manual Execution

If you prefer to run manually:

```bash
docker compose exec ruby-env ruby ruby/labs/advanced/concurrent-processor-lab/solution/concurrent_demo.rb
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
