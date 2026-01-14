# Concurrent Processor Lab - Solution

## Overview

This solution demonstrates three different concurrency models in Ruby:

1. **Thread Pool** - Classic multi-threading with worker queues
2. **Ractor Processor** - True parallelism (Ruby 3.0+)
3. **Fiber Scheduler** - Cooperative multitasking

## Files

```
solution/
├── RUN.md                    # This file
├── concurrent_demo.rb        # Main demo script
└── lib/
    ├── worker_pool.rb        # Thread-based worker pool
    ├── ractor_processor.rb   # Ractor-based parallel processor
    └── fiber_scheduler.rb    # Fiber-based cooperative scheduler
```

## Prerequisites

- Ruby 3.0+ (required for Ractor support)
- No external gems required

## Running the Solution

```bash
cd ruby/labs/advanced/concurrent-processor-lab/solution
ruby concurrent_demo.rb
```

## Expected Output

The demo will show:

1. **Thread Pool**: Multiple threads processing jobs from a queue
2. **Ractor Processor**: Parallel computation across CPU cores
3. **Fiber Scheduler**: Cooperative task switching

## Key Concepts Demonstrated

- `Thread.new` for multi-threading
- `Queue` for thread-safe job distribution
- `Mutex` for protecting shared state
- `Ractor` for true parallelism (no GVL)
- `Fiber` for cooperative concurrency
- `Fiber.yield` for task switching

## Notes on Concurrency Models

| Model | Use Case | GVL Limited? |
|-------|----------|--------------|
| Threads | I/O-bound tasks | Yes |
| Ractors | CPU-bound parallel work | No |
| Fibers | Async I/O, coroutines | N/A |
