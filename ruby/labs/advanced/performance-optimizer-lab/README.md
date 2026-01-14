# Advanced Lab 3: Performance Optimizer

Profile, benchmark, and optimize Ruby code for maximum performance.

## 🎯 Learning Objectives

- Benchmark code with Benchmark and benchmark-ips
- Profile memory usage
- Profile CPU usage
- Identify and fix bottlenecks
- Apply optimization techniques

## 📋 Project Structure

```
performance-optimizer-lab/
├── README.md (this file)
├── STEPS.md                   # Step-by-step build guide
├── solution/                  # Complete working solution
│   ├── RUN.md                 # How to run the solution
│   ├── performance_demo.rb    # Main demo application
│   └── lib/
│       ├── benchmark_suite.rb # Benchmarking utilities
│       ├── memory_profiler.rb # Memory profiling tools
│       └── optimizer.rb       # Optimization patterns
└── steps/                     # Step-by-step implementation
    ├── step-01/               # Benchmark Basics
    ├── step-02/               # Comparison Benchmarks
    ├── step-03/               # IPS Benchmarking
    ├── step-04/               # Memory Measurement
    ├── step-05/               # Object Allocation Tracking
    ├── step-06/               # String Optimization
    ├── step-07/               # Collection Optimization
    ├── step-08/               # Caching Strategies
    └── step-09/               # Comprehensive Profiling
```

## 🚀 Running the Lab

### Quick Start

Run the complete performance optimization demo:

```bash
make advanced-lab NUM=3
```

### Learning Approaches

**Option 1: Study Complete System** (Quick Overview)
- Run the complete system with `make advanced-lab NUM=3`
- Review the code in `solution/performance_demo.rb` and `solution/lib/` directory
- See benchmarking and profiling in action

**Option 2: Progressive Building** (Recommended for Learning)
- Follow the step-by-step guide in the `steps/` directory
- Each step introduces new profiling/optimization techniques
- Run each step's demo: `ruby steps/step-01/step_demo.rb`
- Steps: Benchmarking → Memory Profiling → Optimization Patterns

**Option 3: Read Solution Guide**
- Check [solution/README.md](solution/README.md) for detailed implementation notes
- Review optimization strategies and performance patterns

### Manual Execution

If you prefer to run manually:

```bash
docker compose exec ruby-env ruby ruby/labs/advanced/performance-optimizer-lab/solution/performance_demo.rb
```

## 🐍 For Python Developers

Similar to:
- **timeit**: Our Benchmark module
- **cProfile**: CPU profiling
- **memory_profiler**: Memory profiling
- **line_profiler**: Line-by-line profiling

## 🎓 Features

1. **Benchmarking Suite**: Compare implementations
2. **Memory Profiling**: Track allocations
3. **Optimization Examples**: Before/after comparisons
4. **Best Practices**: Common optimizations

## 🎯 Challenges

- Add automated optimization suggestions
- Create performance regression tests
- Build optimization report generator
- Implement A/B testing for code paths

---

Ready to optimize? Run the benchmarks!
