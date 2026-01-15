# Step 5: Object Allocation Tracking

This step tracks what types of objects are being created.

## Run this step

```bash
ruby step_demo.rb
```

## Concepts

- `ObjectSpace.count_objects` for tracking allocations by type
- Disabling GC during profiling
- Identifying allocation patterns
