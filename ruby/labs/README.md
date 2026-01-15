# Ruby Labs - Progressive Learning Path

Welcome to the Ruby Labs! This comprehensive collection of hands-on labs will take you from Ruby beginner to advanced practitioner through practical, project-based learning.

## 🎯 Learning Philosophy

These labs follow a **progressive learning approach**:

- **Build, Don't Just Read**: Type the code yourself, experiment, and modify
- **Step-by-Step**: Each lab is broken into small, manageable steps
- **Practical Projects**: Learn by building real applications
- **Immediate Feedback**: Run and test your code frequently
- **Python Comparisons**: Every lab includes comparisons for Python developers

## 📚 Complete Learning Path

### Level 1: Beginner Labs (Foundation)

**Prerequisites**: Basic programming knowledge
**Duration**: ~3-4 hours total

Build a solid foundation in Ruby fundamentals:

| Lab | Focus | What You'll Build | Time |
|-----|-------|-------------------|------|
| **[Lab 1: Basics & OOP](beginner/lab1-basics/README.md)** | Classes, Objects, Methods | Book Library System | 45min |
| **[Lab 2: Collections](beginner/lab2-collections/README.md)** | Arrays, Hashes, Iteration | Contact Manager | 60min |
| **[Lab 3: Methods & Modules](beginner/lab3-methods-modules/README.md)** | Parameters, Modules, Reusability | Scientific Calculator | 60min |

**🎓 What You'll Learn**:

- Ruby syntax and fundamentals
- Object-oriented programming
- Collections and enumerable methods
- Module composition patterns

👉 **Start Here**: [Beginner Labs Overview](beginner/README.md)

---

### Level 2: Intermediate Lab (Real-World Application)

**Prerequisites**: Completed beginner labs
**Duration**: ~2-3 hours

Build a complete blog management system that integrates all intermediate concepts:

**[Blog Management System](intermediate-lab/README.md)** - A comprehensive application demonstrating:

- **Mixins**: Shared behavior with modules (Timestampable, Validatable, Sluggable)
- **Closures**: Validation rules with lambdas and procs
- **Metaprogramming**: Dynamic finder methods and DSL creation
- **Query Builder**: Chainable query interface
- **Error Handling**: Custom exceptions and retry logic

**🔍 Progressive Steps**: Follow the [Step-by-Step Guide](intermediate-lab/STEPS.md) to build the system incrementally:

1. Basic Models (User, Post, Comment)
2. Add Timestamps with Modules
3. Add Validation with Lambdas
4. Add Slugs with Prepend
5. Add Metaprogramming (Dynamic Finders)
6. Add Query Builder (Method Chaining)

**🎓 What You'll Learn**:

- How Rails and similar frameworks work internally
- Production-ready Ruby patterns
- Advanced object-oriented design
- Metaprogramming techniques

👉 **Start Here**: [Intermediate Lab](intermediate-lab/README.md)

---

### Level 3: Advanced Labs (Master Level)

**Prerequisites**: Completed intermediate lab
**Duration**: ~6-8 hours total

Build production-quality mini applications demonstrating advanced patterns:

| Lab | Focus | What You'll Build | Difficulty |
|-----|-------|-------------------|------------|
| **[Lab 1: DSL Builder](advanced/dsl-builder-lab/README.md)** | Metaprogramming | Config DSL, Route Mapper, Query Builder | ⭐⭐⭐⭐ |
| **[Lab 2: Concurrent Processor](advanced/concurrent-processor-lab/README.md)** | Concurrency | Thread Pool, Ractor System, Fiber Scheduler | ⭐⭐⭐⭐⭐ |
| **[Lab 3: Performance Optimizer](advanced/performance-optimizer-lab/README.md)** | Optimization | Benchmark Suite, Memory Profiler | ⭐⭐⭐ |
| **[Lab 4: Mini Framework](advanced/mini-framework-lab/README.md)** | Design Patterns | Web Framework with MVC, Services, Plugins | ⭐⭐⭐⭐ |

Each lab includes a **[STEPS.md]** guide for progressive building!

**🎓 What You'll Learn**:

- Building production-quality Ruby applications
- Advanced metaprogramming and DSLs
- Concurrent and parallel processing
- Performance profiling and optimization
- Design patterns and architectural patterns

👉 **Start Here**: [Advanced Labs Overview](advanced/README.md)

---

## 🚀 Quick Start

### 1. Choose Your Starting Point

**New to Ruby?**
→ Start with [Beginner Lab 1](beginner/lab1-basics/README.md)

**Know Ruby basics?**
→ Start with [Intermediate Lab](intermediate-lab/README.md)

**Intermediate Ruby developer?**
→ Start with [Advanced Labs](advanced/README.md)

### 2. Run a Lab

```bash
# Navigate to a lab directory
cd ruby/labs/beginner/lab1-basics

# Read the README for instructions
cat README.md

# Run the solution to see expected output
ruby solution.rb

# Start with the starter code
# Follow the step-by-step instructions in README.md
```

### 3. Follow the Steps

Each lab provides:

- **📖 README.md**: Overview, learning objectives, and step-by-step instructions
- **📝 STEPS.md**: Progressive building guide (intermediate & advanced labs)
- **🎯 starter.rb**: Template to start coding (beginner labs)
- **✅ solution.rb**: Complete working solution (for reference)

---

## 📊 Learning Path Overview

```
┌─────────────────────────────────────────────────────────────┐
│  BEGINNER (3-4 hours)                                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                    │
│  │ Lab 1   │→ │ Lab 2   │→ │ Lab 3   │                    │
│  │ OOP     │  │ Collections│ │ Modules │                    │
│  └─────────┘  └─────────┘  └─────────┘                    │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  INTERMEDIATE (2-3 hours)                                   │
│  ┌──────────────────────────────────────────────┐          │
│  │ Blog Management System (6 progressive steps) │          │
│  │ • Models → Mixins → Validation →             │          │
│  │   Slugs → Metaprogramming → Query Builder   │          │
│  └──────────────────────────────────────────────┘          │
└──────────────────────────┬──────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  ADVANCED (6-8 hours)                                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      │
│  │ DSL     │  │Concurrent│  │Performance│ │Framework│      │
│  │ Builder │  │Processor │  │Optimizer │  │Builder  │      │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘      │
└─────────────────────────────────────────────────────────────┘
```

---

## 🐍 For Python Developers

Every lab includes Python comparisons! Here's what you'll discover:

| Ruby Concept | Python Equivalent | Lab |
|--------------|-------------------|-----|
| `attr_accessor` | `@property` | Beginner Lab 1 |
| Blocks `{ }` | Lambda/list comprehensions | Beginner Lab 2 |
| Modules/Mixins | Multiple inheritance | Beginner Lab 3 |
| `instance_eval` | No direct equivalent | Advanced Lab 1 |
| Threads/Ractors | `threading`/`multiprocessing` | Advanced Lab 2 |
| Metaprogramming | Limited (decorators, metaclasses) | Intermediate Lab |

---

## 💡 Lab Features

### Progressive Steps

Every lab is broken down into manageable steps with:

- ✅ Clear objectives for each step
- 💡 Ruby-specific tips and tricks
- 🐍 Python comparisons
- ✅ Checkpoint lists

### Hands-On Learning

- **Build incrementally**: Add features step by step
- **Test frequently**: Run code after each step
- **Experiment**: Modify code to see what happens
- **Solutions provided**: Reference when stuck

### Real-World Focus

- **Production patterns**: Learn industry best practices
- **Complete applications**: Build working systems
- **Practical skills**: Applicable to real projects
- **Framework internals**: Understand how Rails works

---

## 🎓 Learning Tips

1. **Type the code yourself** - Don't copy-paste! Muscle memory matters.

2. **Run code frequently** - Test after adding each piece of functionality.

3. **Read error messages** - Ruby's errors are helpful and informative.

4. **Experiment** - Modify the code, break things, fix them.

5. **Use IRB** - Test small snippets interactively:

   ```bash
   irb
   > "hello".upcase
   => "HELLO"
   ```

6. **Follow the progression** - Don't skip ahead, each lab builds on previous concepts.

7. **Check solutions when stuck** - But try yourself first!

---

## 🛠️ Technical Requirements

### Required

- Ruby 3.0+ (check: `ruby --version`)
- Text editor or IDE

### Recommended

- Ruby 3.1+ for best experience
- Docker (for advanced labs with special dependencies)

### Installation

```bash
# macOS (using Homebrew)
brew install ruby

# Linux (Ubuntu/Debian)
sudo apt-get install ruby-full

# Check installation
ruby --version
```

---

## 📚 Additional Resources

### Documentation

- [Official Ruby Docs](https://ruby-doc.org/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [Ruby Weekly Newsletter](https://rubyweekly.com/)

### Books

- "Eloquent Ruby" by Russ Olsen
- "The Well-Grounded Rubyist" by David A. Black
- "Metaprogramming Ruby" by Paolo Perrotta

### Online

- [Try Ruby](https://try.ruby-lang.org/) - Interactive tutorial
- [Ruby Koans](http://rubykoans.com/) - Learn by testing
- [Exercism Ruby Track](https://exercism.org/tracks/ruby)

---

## 🎯 What's Next After Labs?

After completing these labs, you'll be ready for:

- **Ruby on Rails**: Build full web applications
- **Ruby gems**: Create and publish your own gems
- **Open source**: Contribute to Ruby projects
- **Advanced topics**: Fiber, Ractor, YJIT optimization
- **Real projects**: Apply skills to production systems

---

## 🤝 Contributing

Found an issue or have a suggestion?

- Open an issue on GitHub
- Submit a pull request
- Share your solutions

---

## 📝 License

These labs are part of the learning-with-claude repository and are freely available for educational purposes.

---

**Ready to begin your Ruby journey?**

👉 **Start with**: [Beginner Lab 1: Ruby Basics & OOP](beginner/lab1-basics/README.md)

Or jump to your level:

- [Beginner Labs](beginner/README.md)
- [Intermediate Lab](intermediate-lab/README.md)
- [Advanced Labs](advanced/README.md)

**Happy coding!** 🚀
