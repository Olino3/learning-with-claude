# Ruby Tutorials

Progressive tutorials for learning Ruby development, designed for engineers with Python experience.

## 🎯 Learning Path

These tutorials build upon each other progressively. Follow them in order for the best learning experience.

### Tutorial 1: Getting Started
**Status:** ✅ Complete

Get your Ruby development environment up and running with Docker and Tilt.

👉 **[Start Tutorial 1: Getting Started](1-Getting-Started/README.md)**

**You'll learn:**
- How to use the Ruby development environment
- Running Ruby scripts
- Using the interactive Ruby interpreter (IRB)
- The difference between REPLs and scripts

---

### Tutorial 2: Ruby Basics - Syntax, Variables, and Data Types
**Status:** ✅ Complete

Master Ruby's fundamental syntax with special attention to differences from Python.

👉 **[Start Tutorial 2: Ruby Basics](2-Ruby-Basics/README.md)**

**You'll learn:**
- Variables and naming conventions
- Basic data types (Numbers, Strings, Symbols, Booleans, nil)
- **Critical difference:** Only `false` and `nil` are falsy (not 0, "", [])
- Symbols - Ruby's unique identifier type
- String interpolation with `#{}`
- Type conversion methods

**Key for Python developers:**
- Truthiness rules are very different!
- Symbols are like immutable, memory-efficient strings
- String interpolation is cleaner than f-strings

---

### Tutorial 3: Control Flow - Conditionals and Loops
**Status:** ✅ Complete

Learn Ruby's control structures including unique features like `unless` and statement modifiers.

👉 **[Start Tutorial 3: Control Flow](3-Control-Flow/README.md)**

**You'll learn:**
- If/elsif/else (note: `elsif` not `elif`!)
- Unless - Ruby's inverse if
- Case/when for multi-way branching
- Statement modifiers for concise code
- While, until, and loop constructs
- **Ruby iterators:** .each, .times, .map, .select (the idiomatic way)
- Loop control: break and next

**Key for Python developers:**
- Use `elsif` not `elif`
- Embrace iterators over for loops
- Statement modifiers: `do_something if condition`
- `unless` reads naturally for negations

---

### Tutorial 4: Methods and Blocks - Ruby's Unique Approach
**Status:** ✅ Complete

Master Ruby's methods and blocks - featuring blocks, which Python doesn't have!

👉 **[Start Tutorial 4: Methods and Blocks](4-Methods-and-Blocks/README.md)**

**You'll learn:**
- Method definitions and parameters
- Optional, keyword, and splat parameters
- **Blocks** - Ruby's unique feature (do...end and {...})
- yield to call blocks
- Procs and Lambdas
- Closures and scope
- The & operator for block conversion

**Key for Python developers:**
- Implicit return (last expression is returned)
- Blocks are everywhere in Ruby
- Lambdas are like Python lambdas but more powerful
- yield calls the block passed to a method

---

### Tutorial 5: Collections - Arrays and Hashes
**Status:** ✅ Complete

Master Ruby's powerful collection types and their methods.

👉 **[Start Tutorial 5: Collections](5-Collections/README.md)**

**You'll learn:**
- Arrays (Ruby's lists) and operations
- Hashes (Ruby's dictionaries) with symbol keys
- Collection methods: .map, .select, .reject, .reduce
- Iteration patterns
- Method chaining for data processing
- Working with nested collections

**Key for Python developers:**
- Use symbols for hash keys: `{ name: "Alice" }`
- `.map` is like list comprehensions
- `.select`/`.reject` for filtering
- Method chaining is more common than nested comprehensions

---

### Tutorial 6: Object-Oriented Programming
**Status:** ✅ Complete

Learn Ruby's elegant object-oriented features.

👉 **[Start Tutorial 6: OOP](6-Object-Oriented-Programming/README.md)**

**You'll learn:**
- Classes and objects
- Instance variables (@var) and class variables (@@var)
- attr_accessor, attr_reader, attr_writer
- Inheritance with super
- Class methods and self
- Public, private, and protected methods

**Key for Python developers:**
- `initialize` is like `__init__`
- `@var` is like `self.var`
- `attr_accessor` creates getters/setters automatically
- Inheritance uses `<` not parentheses

---

### Tutorial 7: Modules and Mixins
**Status:** ✅ Complete

Understand Ruby's powerful composition model with modules.

👉 **[Start Tutorial 7: Modules and Mixins](7-Modules-and-Mixins/README.md)**

**You'll learn:**
- Creating and using modules
- Mixins with `include`
- Extending classes with `extend`
- Namespacing with `::`
- Module methods
- Ruby's answer to multiple inheritance

**Key for Python developers:**
- Modules are like Python's mix of modules and multiple inheritance
- `include` adds instance methods (like mixin)
- `extend` adds class methods
- More flexible than Python's inheritance model

---

### Tutorial 8: Error Handling and Exceptions
**Status:** ✅ Complete

Master Ruby's exception handling system.

👉 **[Start Tutorial 8: Error Handling](8-Error-Handling/README.md)**

**You'll learn:**
- begin/rescue/ensure/end blocks
- Catching and raising exceptions
- Custom exception classes
- retry for error recovery
- Ensure for cleanup code

**Key for Python developers:**
- `begin/rescue/ensure/end` is like `try/except/finally`
- `rescue => e` captures the exception
- `retry` re-executes begin block (Python doesn't have this)
- Inherit from StandardError for custom exceptions

---

### Tutorial 9: File I/O and String Processing
**Status:** ✅ Complete

Learn file operations and text processing in Ruby.

👉 **[Start Tutorial 9: File I/O](9-File-IO/README.md)**

**You'll learn:**
- Reading and writing files
- File.open with blocks (auto-closes)
- Line-by-line processing
- File existence and metadata
- Working with paths
- Text parsing and formatting

**Key for Python developers:**
- `File.open { |f| }` auto-closes (like Python's `with`)
- File methods are class methods: `File.read('file.txt')`
- Blocks make file handling cleaner

---

### Tutorial 10: Ruby Idioms and Best Practices
**Status:** ✅ Complete

Write idiomatic, clean Ruby code following community conventions.

👉 **[Start Tutorial 10: Ruby Idioms](10-Ruby-Idioms/README.md)**

**You'll learn:**
- Ruby coding conventions
- When to use symbols vs strings
- Idiomatic iteration patterns
- Statement modifiers for clarity
- Method chaining patterns
- Ruby style guide essentials
- Common patterns and anti-patterns

**Key for Python developers:**
- Embrace Ruby idioms (they're different from Python!)
- Use symbols for identifiers
- Prefer iterators over loops
- Statement modifiers for simple conditions
- Follow the community style guide

---

## 📊 Tutorial Overview

### Core Tutorials (1-10)

| # | Tutorial | Topics | Difficulty |
|---|----------|--------|------------|
| 1 | Getting Started | Environment setup, scripts, REPL | ⭐ Beginner |
| 2 | Ruby Basics | Syntax, variables, types, symbols | ⭐ Beginner |
| 3 | Control Flow | Conditionals, loops, iterators | ⭐⭐ Beginner |
| 4 | Methods & Blocks | Methods, blocks, procs, lambdas | ⭐⭐ Intermediate |
| 5 | Collections | Arrays, hashes, transformations | ⭐⭐ Intermediate |
| 6 | OOP | Classes, inheritance, modules | ⭐⭐ Intermediate |
| 7 | Modules & Mixins | Composition, namespacing | ⭐⭐⭐ Intermediate |
| 8 | Error Handling | Exceptions, rescue, retry | ⭐⭐ Intermediate |
| 9 | File I/O | Files, reading, writing | ⭐⭐ Intermediate |
| 10 | Ruby Idioms | Best practices, style | ⭐⭐⭐ Intermediate |

### Intermediate Tutorials (11-16)

| # | Tutorial | Topics | Difficulty |
|---|----------|--------|------------|
| 11 | Advanced Blocks & Closures | Procs, lambdas, closures | ⭐⭐⭐ Intermediate |
| 12 | Ruby Object Model | Inheritance, singleton, eigenclass | ⭐⭐⭐⭐ Intermediate |
| 13 | Advanced Mixins | Module composition, prepend | ⭐⭐⭐ Intermediate |
| 14 | Metaprogramming | method_missing, define_method | ⭐⭐⭐⭐ Intermediate |
| 15 | Advanced Error Handling | Custom exceptions, retry patterns | ⭐⭐⭐ Intermediate |
| 16 | Idiomatic Ruby | Enumerable, duck typing, patterns | ⭐⭐⭐ Intermediate |

### Advanced Tutorials (17-23)

| # | Tutorial | Topics | Difficulty |
|---|----------|--------|------------|
| 17 | Advanced Metaprogramming & DSLs | instance_eval, Binding, Refinements | ⭐⭐⭐⭐⭐ Advanced |
| 18 | Concurrency and Parallelism | Threads, Ractors, Fibers, GVL | ⭐⭐⭐⭐⭐ Advanced |
| 19 | MRI Internals | GC, ObjectSpace, YARV bytecode | ⭐⭐⭐⭐⭐ Advanced |
| 20 | Advanced Functional Programming | Currying, lazy evaluation, method objects | ⭐⭐⭐⭐ Advanced |
| 21 | Performance Profiling & Optimization | Benchmarking, profiling, optimization | ⭐⭐⭐⭐ Advanced |
| 22 | Design Patterns (Ruby Edition) | Decorator, Service Objects, Singleton | ⭐⭐⭐⭐ Advanced |
| 23 | WebSockets & Network Programming | TCP/UDP, async gem, WebSockets, Falcon | ⭐⭐⭐⭐⭐ Advanced |

---

## 🎓 Advanced Ruby Track

The advanced tutorials (17-23) dive deep into Ruby's most powerful features - the techniques used by framework authors and library developers. These are for developers ready to:

- Build frameworks and DSLs
- Optimize performance-critical code
- Understand Ruby's internals
- Write professional, production-ready Ruby
- Build real-time, high-performance network applications

### Tutorial 17: Advanced Metaprogramming & DSLs
**Status:** ✅ Complete

Master the metaprogramming techniques that power Rails, RSpec, and other Ruby frameworks.

👉 **[Start Tutorial 17](advanced/17-Advanced-Metaprogramming-DSLs/README.md)**

**You'll learn:**
- `instance_eval` and `class_eval` for context manipulation
- `Binding` to capture execution context
- `Refinements` for scoped monkey-patching
- Building production-ready DSLs

---

### Tutorial 18: Concurrency and Parallelism
**Status:** ✅ Complete

Understand Ruby's concurrency model, from threads to Ractors.

👉 **[Start Tutorial 18](advanced/18-Concurrency-and-Parallelism/README.md)**

**You'll learn:**
- The Global VM Lock (GVL) and its implications
- Threads for I/O-bound concurrency
- Ractors for CPU-bound parallelism (Ruby 3.0+)
- Fibers for cooperative concurrency
- Thread safety and avoiding deadlocks

---

### Tutorial 19: MRI Internals
**Status:** ✅ Complete

Explore how Ruby works under the hood.

👉 **[Start Tutorial 19](advanced/19-MRI-Internals/README.md)**

**You'll learn:**
- Object representation in memory
- Garbage collection tuning
- ObjectSpace for memory inspection
- YARV bytecode and AST
- Finding and fixing memory leaks

---

### Tutorial 20: Advanced Functional Programming
**Status:** ✅ Complete

Master Ruby's functional programming capabilities.

👉 **[Start Tutorial 20](advanced/20-Advanced-Functional-Programming/README.md)**

**You'll learn:**
- Currying and partial application
- Method objects as first-class citizens
- Lazy evaluation with `Enumerable#lazy`
- Functional composition patterns
- Immutable data structures

---

### Tutorial 21: Performance Profiling and Optimization
**Status:** ✅ Complete

Learn to make Ruby code fast.

👉 **[Start Tutorial 21](advanced/21-Performance-Profiling-Optimization/README.md)**

**You'll learn:**
- Benchmarking with `Benchmark` and `benchmark-ips`
- Memory profiling with `memory_profiler`
- CPU profiling with `stackprof`
- Understanding YARV bytecode for optimization
- Common optimization strategies

---

### Tutorial 22: Design Patterns (Ruby Edition)
**Status:** ✅ Complete

Apply design patterns the Ruby way.

👉 **[Start Tutorial 22](advanced/22-Design-Patterns/README.md)**

**You'll learn:**
- Proxy/Decorator with `SimpleDelegator`
- Service Objects and Interactors
- Singleton pattern
- Observer pattern with `Observable`
- Factory and Builder patterns

---

### Tutorial 23: WebSockets & Modern Async Network Programming
**Status:** ✅ Complete

Master modern async I/O and real-time communication with WebSockets.

👉 **[Start Tutorial 23](advanced/23-WebSockets-Network-Programming/README.md)**

**You'll learn:**
- TCP/UDP socket programming fundamentals
- Modern async I/O with the `async` gem (Fiber-based)
- WebSocket protocol internals (handshake, framing, masking)
- Building WebSocket servers with `async-websocket`
- Falcon server for high-performance async web apps
- Real-time patterns (pub/sub, broadcasting)
- Migrating from EventMachine to modern async

**Prerequisites:** Complete [Tutorial 18: Concurrency and Parallelism](advanced/18-Concurrency-and-Parallelism/README.md) first, especially the Fibers section.

**Related:** [Sinatra Lab 4: Realtime Chat](../labs/sinatra/4-realtime-chat/README.md) - Build a complete chat app (TODO: Update to async gem)

---

## 💎 Advanced Labs

After completing the advanced tutorials, apply your knowledge with hands-on labs:

- **[Lab 1: DSL Builder](../labs/advanced/dsl-builder-lab/)** - Build configuration, routing, and query DSLs
- **[Lab 2: Concurrent Processor](../labs/advanced/concurrent-processor-lab/)** - Worker pools, Ractors, Fibers
- **[Lab 3: Performance Optimizer](../labs/advanced/performance-optimizer-lab/)** - Benchmark and optimize
- **[Lab 4: Mini Framework](../labs/advanced/mini-framework-lab/)** - Build a web framework

---

## 🎓 For Python Developers

Each tutorial includes special **Python Notes** highlighting:
- Key differences between Python and Ruby
- Common pitfalls for Python developers
- Idiomatic translations of Python patterns to Ruby
- Mental models to bridge the two languages

### Critical Differences to Remember

1. **Truthiness:** Only `false` and `nil` are falsy (not 0, "", [])
2. **Syntax:** `elsif` not `elif`, `end` not indentation
3. **Blocks:** Ruby's unique feature - not in Python
4. **Symbols:** Immutable identifiers - use for hash keys
5. **Iterators:** Prefer `.each`, `.map` over `for` loops
6. **Implicit return:** Methods return last expression
7. **Everything is an object:** Even `nil` has methods!

## 🚀 Getting Started

1. **Start with Tutorial 1** to set up your environment
2. **Follow tutorials in order** - they build progressively
3. **Do all exercises** - hands-on practice is essential
4. **Use the REPL** - experiment freely in IRB
5. **Compare with Python** - leverage your existing knowledge

## 💡 Learning Tips

- **Experiment in IRB:** Try everything in the REPL first
- **Read the Python notes:** They'll help you map concepts
- **Complete the challenges:** They confirm your understanding
- **Write code daily:** Even 15 minutes builds muscle memory
- **Embrace Ruby idioms:** Don't write Python in Ruby syntax
- **Ask "the Ruby way":** There's usually an idiomatic approach

## 📚 Structure

Each tutorial includes:
- **README:** Concepts and comparisons with Python
- **Exercises:** Progressive hands-on practice
- **Practice scripts:** Run and experiment
- **Challenge scripts:** Test your understanding
- **Python notes:** Throughout every tutorial

## 🎯 After Completing These Tutorials

You'll be able to:
- ✅ Write idiomatic Ruby code
- ✅ Understand Ruby's unique features (blocks, symbols, etc.)
- ✅ Leverage Ruby's elegant syntax
- ✅ Build Ruby applications confidently
- ✅ Read and understand Ruby gems
- ✅ Contribute to Ruby open-source projects

### Next Steps

- **Build projects:** Apply what you've learned
- **Explore Ruby gems:** Discover the ecosystem
- **Learn a framework:** Rails, Sinatra, Hanami
- **Join the community:** RubyGems, Reddit, Discord
- **Practice on Exercism:** Ruby track exercises
- **Read Ruby code:** Study popular gems

## 📖 Additional Resources

- [Official Ruby Documentation](https://ruby-doc.org/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [RubyGems](https://rubygems.org/)
- [Exercism Ruby Track](https://exercism.org/tracks/ruby)
- [Ruby Weekly Newsletter](https://rubyweekly.com/)
- [The Ruby Toolbox](https://www.ruby-toolbox.com/)

## 🤝 Contributing

Found an issue or have a suggestion? These tutorials use Git commits to track progress. Each tutorial was added as a separate commit, allowing you to see the learning path evolve.

---

**Ready to start?** Begin with **[Tutorial 1: Getting Started](1-Getting-Started/README.md)**!

Happy learning! 💎✨
