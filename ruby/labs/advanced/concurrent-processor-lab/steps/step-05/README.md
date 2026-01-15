# Step 5: Ractor Worker Pool

This step creates a pool of Ractor workers for controlled parallelism.

## Run this step

```bash
ruby step_demo.rb
```

## Concepts

- `Ractor.receive` for receiving messages
- `Ractor.yield` for sending results
- `Ractor.select` for collecting from multiple Ractors
