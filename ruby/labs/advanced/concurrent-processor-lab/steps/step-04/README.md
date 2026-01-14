# Step 4: Basic Ractor Processing

This step introduces Ractors for true parallel processing (Ruby 3.0+).

## Run this step

```bash
ruby step_demo.rb
```

## Concepts

- `Ractor.new` for creating isolated execution units
- Ractors bypass the GVL (Global VM Lock)
- True parallelism for CPU-bound work
