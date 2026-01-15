# Performance Optimizer Lab - Solution

## Overview

This solution demonstrates performance optimization techniques in Ruby:

1. **Benchmarking** - Measuring code performance
2. **Memory Profiling** - Identifying memory issues
3. **Optimization Techniques** - Applying improvements

## Files

```
solution/
├── RUN.md                    # This file
├── performance_demo.rb       # Main demo script
└── lib/
    ├── benchmark_suite.rb    # Custom benchmarking framework
    ├── memory_profiler.rb    # Memory profiling utilities
    └── optimizer.rb          # Optimization examples
```

## Prerequisites

- Ruby 3.0+ (recommended)
- Optional: `benchmark-ips` gem for iterations-per-second benchmarks

## Running the Solution

```bash
cd ruby/labs/advanced/performance-optimizer-lab/solution
ruby performance_demo.rb
```

## Expected Output

The demo will show:

1. **Benchmark comparisons**: String, array, and hash operations
2. **Memory profiling**: Object allocation tracking
3. **Optimization examples**: Before/after performance gains

## Key Concepts Demonstrated

- `Benchmark.bm` for timing comparisons
- `ObjectSpace` for memory inspection
- Memoization patterns
- String optimization (frozen strings, `<<` vs `+=`)
- Symbol vs String keys
- Algorithm complexity improvements

## Tips for Real-World Optimization

1. **Measure first** - Don't optimize blindly
2. **Profile memory** - Check for leaks and excessive allocation
3. **Optimize hot paths** - Focus on frequently executed code
4. **Consider algorithms** - O(n) beats O(n²) more than micro-optimizations
