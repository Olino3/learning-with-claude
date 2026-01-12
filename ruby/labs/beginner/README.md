# Beginner Ruby Labs

Welcome to the beginner Ruby labs! These hands-on exercises will help you build a solid foundation in Ruby programming.

## 🎯 Overview

These labs are designed for developers new to Ruby (especially those with Python or other programming experience) who want to learn Ruby fundamentals through practical exercises.

## 📚 Progressive Learning Path

Complete these labs in order - each builds on concepts from the previous one:

### Lab 1: Ruby Basics & Object-Oriented Programming
**Focus**: Classes, Instances, and Methods

Build a simple book library system to learn:
- Creating classes and objects
- Instance variables and methods
- Class variables and class methods
- Inheritance basics
- String interpolation and basic I/O

**Estimated Time**: 30-45 minutes

👉 **[Start Lab 1](lab1-basics/README.md)**

---

### Lab 2: Collections & Iteration
**Focus**: Arrays, Hashes, and Enumerable

Build a contact management system to learn:
- Working with arrays and hashes
- Iterating with `each`, `map`, `select`, `reject`
- Understanding blocks and yield
- Symbols vs strings
- Hash manipulation

**Estimated Time**: 45-60 minutes

👉 **[Start Lab 2](lab2-collections/README.md)**

---

### Lab 3: Methods & Modules
**Focus**: Method Design and Code Reusability

Build a calculator with utilities to learn:
- Method parameters and return values
- Keyword arguments and default values
- Variable-length argument lists (*args)
- Creating and including modules
- Method visibility (public, private, protected)

**Estimated Time**: 45-60 minutes

👉 **[Start Lab 3](lab3-methods-modules/README.md)**

---

## 🚀 Getting Started

### Prerequisites

- Ruby 3.0+ installed
- Basic programming knowledge
- Text editor or IDE

### Running Labs

```bash
# Navigate to a specific lab
cd ruby/labs/beginner/lab1-basics

# Follow the step-by-step instructions in that lab's README
# Run your solution
ruby solution.rb
```

## 📖 Lab Structure

Each lab follows a consistent format:

```
labN-name/
├── README.md          # Instructions with progressive steps
├── starter.rb         # Starting code template
├── solution.rb        # Complete solution (don't peek!)
└── tests.rb           # Optional tests to verify your work
```

## 🎓 Learning Approach

**Step-by-Step Progression**: Each lab is broken into small, manageable steps. Complete each step before moving to the next.

**Build, Don't Just Read**: Type the code yourself rather than copying. This builds muscle memory.

**Experiment**: After completing each step, try modifying the code to see what happens.

**Check Your Work**: Run the code frequently to verify it works.

## 🐍 For Python Developers

Each lab includes comparisons to Python equivalents:

| Ruby Concept | Python Equivalent |
|--------------|-------------------|
| Classes | Classes (similar) |
| `attr_accessor` | `@property` decorator |
| Blocks | Lambda functions / list comprehensions |
| Modules | Mixins / multiple inheritance |
| Symbols | Interned strings / enums |
| `each` | `for` loop |
| `map` | list comprehension / `map()` |

## 💡 Key Differences from Python

- **Everything is an object**: Even numbers and `nil`
- **Methods don't need parentheses**: `puts "Hello"` vs `print("Hello")`
- **Blocks are everywhere**: Ruby's way of passing code
- **Symbols**: Immutable, reusable identifiers (`:name`)
- **Implicit returns**: Last expression is returned automatically
- **End keyword**: Use `end` instead of indentation

## 🎯 What's Next?

After completing these beginner labs:

1. **Intermediate Labs** → Complex object-oriented patterns
2. **Advanced Labs** → Metaprogramming and frameworks

## 📚 Additional Resources

- [Ruby Documentation](https://ruby-doc.org/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [Try Ruby](https://try.ruby-lang.org/) - Interactive tutorial
- [Ruby Koans](http://rubykoans.com/) - Learn by testing

## 🤝 Tips for Success

1. **Don't rush**: Understanding is more important than speed
2. **Read error messages**: Ruby's errors are helpful
3. **Use IRB**: Test small snippets interactively (`irb` command)
4. **Ask questions**: Look up anything you don't understand
5. **Have fun**: Ruby is designed to be enjoyable!

---

**Ready to start?** Head to [Lab 1](lab1-basics/README.md) and begin your Ruby journey!
