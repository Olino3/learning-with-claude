# Step 2: Thread Safety with Mutex

This step adds thread safety using `Mutex` to protect shared state.

## Run this step

```bash
ruby step_demo.rb
```

## Concepts

- `Mutex.new` for creating locks
- `mutex.synchronize { }` for critical sections
- Thread-safe counters
