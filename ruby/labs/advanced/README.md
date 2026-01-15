# Advanced Ruby Labs

Hands-on projects demonstrating advanced Ruby concepts through real-world mini applications.

## 🎯 Overview

These labs are designed for intermediate to advanced Ruby developers (especially those with Python experience) who want to master Ruby's advanced features through practical, project-based learning.

## 📚 Available Labs

### Lab 1: DSL Builder
**Focus**: Advanced Metaprogramming & DSLs

Build powerful Domain Specific Languages:
- Configuration DSL (like Rails config)
- Route Mapper DSL (Rails-style routing)
- Query Builder DSL (ActiveRecord-style)

**Concepts**: `instance_eval`, `method_missing`, `define_method`, method chaining

👉 **[Start Lab 1](dsl-builder-lab/README.md)** | Run with: `make advanced-lab NUM=1`

---

### Lab 2: Concurrent Task Processor
**Focus**: Concurrency and Parallelism

Build high-performance concurrent processors:
- Thread-based worker pool
- Ractor-based parallel processor
- Fiber-based task scheduler

**Concepts**: Threads, Mutexes, Ractors, Fibers, thread safety

👉 **[Start Lab 2](concurrent-processor-lab/README.md)** | Run with: `make advanced-lab NUM=2`

---

### Lab 3: Performance Optimizer
**Focus**: Profiling and Optimization

Master performance analysis and optimization:
- Benchmarking suite
- Memory profiling
- Optimization techniques

**Concepts**: Benchmark, memory profiling, optimization patterns

👉 **[Start Lab 3](performance-optimizer-lab/README.md)** | Run with: `make advanced-lab NUM=3`

---

### Lab 4: Mini Framework
**Focus**: Design Patterns

Build a minimal web framework:
- Routing system
- MVC pattern
- Service layer architecture
- Plugin system

**Concepts**: Singleton, Factory, Service Objects, Decorator, Builder

👉 **[Start Lab 4](mini-framework-lab/README.md)** | Run with: `make advanced-lab NUM=4`

---

## 🚀 Getting Started

### Prerequisites

- Completed intermediate Ruby tutorials
- Ruby 3.0+ (for Ractor support)
- Docker (for isolated environment)

### Running Labs

#### Quick Start with Make Commands

Run any lab with a simple make command:

```bash
# Lab 1: DSL Builder
make advanced-lab NUM=1

# Lab 2: Concurrent Task Processor
make advanced-lab NUM=2

# Lab 3: Performance Optimizer
make advanced-lab NUM=3

# Lab 4: Mini Framework
make advanced-lab NUM=4
```

#### Alternative: Manual Execution

If you prefer to run manually:

```bash
# Start the containers
docker compose up -d ruby-env

# Run a specific lab
docker compose exec ruby-env ruby ruby/labs/advanced/dsl-builder-lab/solution/dsl_demo.rb
```

## 📖 Lab Structure

Each lab follows a consistent structure:

```
lab-name/
├── README.md          # Lab objectives and instructions
├── solution/          # Complete working implementation
│   ├── README.md      # Solution guide and implementation notes
│   ├── *_demo.rb      # Main demonstration file
│   └── lib/           # Implementation modules
├── steps/             # Progressive step-by-step implementations
│   ├── step-01/       # Each step with its own demo
│   ├── step-02/
│   └── ...
└── *_demo.rb          # Entry point (some labs)
```

## 🎓 Learning Path

Recommended order:

1. **DSL Builder** → Understand metaprogramming patterns
2. **Concurrent Processor** → Master concurrency models
3. **Performance Optimizer** → Learn optimization techniques
4. **Mini Framework** → Apply design patterns

## 🐍 For Python Developers

Each lab includes comparisons to Python equivalents:

| Lab | Python Equivalent |
|-----|-------------------|
| DSL Builder | Django settings, Flask routing, SQLAlchemy |
| Concurrent Processor | ThreadPoolExecutor, ProcessPoolExecutor, asyncio |
| Performance Optimizer | cProfile, memory_profiler, timeit |
| Mini Framework | Flask, FastAPI, Django patterns |

## 💡 Key Differences from Intermediate Labs

**Intermediate Labs**:
- Focus on core Ruby features
- Single-file applications
- Basic patterns

**Advanced Labs**:
- Multi-file project structure
- Real-world architectures
- Advanced metaprogramming
- Performance-critical code
- Design pattern implementations

## 🎯 Challenges

Each lab includes extension challenges:

- Add new features
- Improve performance
- Implement additional patterns
- Create tests
- Build documentation

## 📊 Lab Comparison

| Lab | Difficulty | Topics | Files | Lines |
|-----|-----------|--------|-------|-------|
| DSL Builder | ⭐⭐⭐⭐ | Metaprogramming | 7 | ~500 |
| Concurrent Processor | ⭐⭐⭐⭐⭐ | Concurrency | 4 | ~300 |
| Performance Optimizer | ⭐⭐⭐ | Optimization | 3 | ~200 |
| Mini Framework | ⭐⭐⭐⭐ | Design Patterns | 5 | ~400 |

## 🔧 Development Environment

The advanced labs use the ruby-env container with enhanced capabilities:

**Features**:
- Increased resources (4 CPU, 2GB RAM)
- YJIT enabled for performance
- GC tuning for profiling
- Profiling tools pre-installed
- Full Ruby development environment

**Tools Available**:
- `memory_profiler` - Memory usage analysis
- `benchmark-ips` - Iterations per second benchmarking
- `stackprof` - CPU profiling
- `rubocop` - Code quality checking

## 📚 Additional Resources

- [Ruby Metaprogramming](https://pragprog.com/titles/ppmetr2/metaprogramming-ruby-2/)
- [Working with Ruby Threads](https://www.jstorimer.com/products/working-with-ruby-threads)
- [Ruby Performance Optimization](https://pragprog.com/titles/adrpo/ruby-performance-optimization/)
- [Design Patterns in Ruby](https://refactoring.guru/design-patterns/ruby)

## 🤝 Contributing

These labs are part of the learning repository. Feel free to:
- Extend labs with new features
- Add more examples
- Improve documentation
- Share your solutions

## 📝 Notes

- Labs use progressive commits to show development progression
- Each lab builds on tutorial concepts
- Code is production-style but simplified for learning
- Python comparisons throughout

---

**Ready to dive into advanced Ruby?** Choose a lab and start building!
