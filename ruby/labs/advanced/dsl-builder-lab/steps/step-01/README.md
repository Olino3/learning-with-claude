# Step 1: Basic Configuration with instance_eval

This step introduces the fundamental DSL pattern using `instance_eval`.

## Run this step

```bash
ruby step_demo.rb
```

## Concepts

- `instance_eval(&block)` evaluates a block in the context of an object
- `method_missing` handles undefined methods dynamically
- Getters and setters via variable arguments
