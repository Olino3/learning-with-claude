# Beginner Dart Labs

Progressive hands-on labs to learn Dart fundamentals through building real projects.

## 📚 Lab Overview

| Lab | Topic | Project | Time | Difficulty |
|-----|-------|---------|------|------------|
| **Lab 1** | [Dart Basics & OOP](lab1-basics/README.md) | Book Library System | 1-2h | ⭐ Beginner |
| **Lab 2** | [Collections & Iteration](lab2-collections/README.md) | Contact Manager | 1.5-2.5h | ⭐⭐ Beginner+ |
| **Lab 3** | [Functions & Mixins](lab3-functions-mixins/README.md) | Calculator with Mixins | 2-3h | ⭐⭐ Intermediate |

## 🚀 Quick Start

### Run a Lab

```bash
# Lab 1: Dart Basics
make dart-beginner-lab NUM=1

# Lab 2: Collections & Iteration
make dart-beginner-lab NUM=2

# Lab 3: Functions & Mixins
make dart-beginner-lab NUM=3
```

### Alternative: Run Manually

```bash
# Run any Dart file
make run-dart SCRIPT=dart/labs/beginner/lab1-basics/solution.dart
```

## 📖 Recommended Learning Path

1. **Start with Lab 1** if you're new to Dart or coming from Python/Ruby
2. **Progress to Lab 2** to master Dart's powerful collection methods
3. **Complete Lab 3** to learn functional programming and code reusability with mixins

Each lab includes:
- ✅ Clear learning objectives
- ✅ Step-by-step instructions
- ✅ Python/Ruby comparisons (for developers coming from these languages)
- ✅ Complete working solutions
- ✅ Practice exercises

## 💡 Learning Tips

- **Code along** with each step—don't just read!
- **Experiment** with the examples in DartPad: https://dartpad.dev
- **Compare** your code with the solutions
- **Take breaks** between labs to let concepts sink in

## 🎯 After Completing These Labs

Move on to more advanced topics:
- **Flutter Labs**: Build web and mobile applications
- **Intermediate Labs**: Async programming and advanced patterns
- **Advanced Labs**: Design patterns and architecture

---

## 🎯 Overview

These labs are designed for developers new to Dart (especially those with Python, Ruby, or other programming experience) who want to learn Dart fundamentals through practical exercises.

## 📚 Progressive Learning Path

Complete these labs in order - each builds on concepts from the previous one:

### Lab 1: Dart Basics & Object-Oriented Programming

**Focus**: Classes, Objects, and Methods

Build a simple book library system to learn:

- Creating classes and objects
- Instance variables and methods
- Constructors with named parameters
- Getters and computed properties
- String interpolation and basic I/O
- Null safety fundamentals
- Typed collections (List<T>)

**Estimated Time**: 1-2 hours

👉 **[Start Lab 1](lab1-basics/README.md)**

---

### Lab 2: Collections & Iteration

**Focus**: Lists, Maps, and Iteration

Build a contact management system to learn:

- Working with Lists and Maps
- Iterating with `forEach`, `map`, `where`, `reduce`
- Understanding higher-order functions
- Sets and unique collections
- Collection manipulation
- Cascade notation

**Estimated Time**: 1.5-2.5 hours

👉 **[Start Lab 2](lab2-collections/README.md)**

---

### Lab 3: Functions & Mixins

**Focus**: Function Design and Code Reusability

Build a calculator with utilities to learn:

- Function parameters and return types
- Named and optional parameters
- Arrow functions and closures
- Creating and using mixins
- Extension methods
- Function composition

**Estimated Time**: 2-3 hours

👉 **[Start Lab 3](lab3-functions-mixins/README.md)**

---

## 🚀 Getting Started

### Prerequisites

- Dart SDK 3.0+ installed (included in the Docker environment)
- Basic programming knowledge
- Text editor or IDE

### Running Labs

```bash
# Navigate to a specific lab
cd dart/labs/beginner/lab1-basics

# Follow the step-by-step instructions in that lab's README
# Run your solution
dart run solution.dart
```

## 📖 Lab Structure

Each lab follows a consistent format:

```
labN-name/
├── README.md          # Instructions with progressive steps
├── starter.dart       # Starting code template
└── solution.dart      # Complete solution (don't peek!)
```

## 🎓 Learning Approach

**Step-by-Step Progression**: Each lab is broken into small, manageable steps. Complete each step before moving to the next.

**Build, Don't Just Read**: Type the code yourself rather than copying. This builds muscle memory.

**Experiment**: After completing each step, try modifying the code to see what happens.

**Check Your Work**: Run the code frequently to verify it works.

## 🐍 For Python Developers

Each lab includes comparisons to Python equivalents:

| Dart Concept | Python Equivalent |
|--------------|-------------------|
| Classes | Classes (similar) |
| `get`/`set` | `@property` decorator |
| Named parameters | Keyword arguments |
| Mixins | Multiple inheritance |
| `final` | Constants / immutable variables |
| `forEach` | `for` loop |
| `map` | list comprehension / `map()` |
| Null safety (`?`) | Optional type hints |

## 💎 For Ruby Developers

| Dart Concept | Ruby Equivalent |
|--------------|------------------|
| Classes | Classes (similar) |
| `get`/`set` | `attr_accessor` |
| Named parameters | Keyword arguments |
| Mixins | Modules with `include` |
| `final`/`const` | Constants |
| `forEach` | `each` |
| `map` | `map` |
| Null safety | N/A (Ruby is dynamically typed) |

## 💡 Key Differences from Python/Ruby

**From Python:**
- **Statically typed**: Types are checked at compile time
- **Null safety**: Must explicitly handle null values with `?` and `!`
- **Semicolons required**: End statements with `;`
- **Named parameters**: Use `required` or provide defaults
- **No multiple inheritance**: Use mixins instead

**From Ruby:**
- **Statically typed**: Types must be declared or inferred
- **Null safety**: Compiler enforces null handling
- **Explicit returns**: Must use `return` or make it the last expression
- **Braces required**: Use `{}` not `end`
- **Mixins are different**: Use `with` keyword and can't have constructors

## 🎯 What's Next?

After completing these beginner labs:

1. **Flutter Labs** → Build web and mobile applications
2. **Intermediate Labs** → Async/await and advanced patterns
3. **Advanced Labs** → Design patterns and architecture

## 📚 Additional Resources

- [Dart Documentation](https://dart.dev/guides)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [DartPad](https://dartpad.dev/) - Interactive Dart playground
- [Effective Dart](https://dart.dev/guides/language/effective-dart) - Style guide

## 🤝 Tips for Success

1. **Don't rush**: Understanding is more important than speed
2. **Read error messages**: Dart's errors are very helpful
3. **Use DartPad**: Test small snippets interactively
4. **Ask questions**: Look up anything you don't understand
5. **Embrace null safety**: It prevents bugs before they happen!

---

**Ready to start?** Head to [Lab 1](lab1-basics/README.md) and begin your Dart journey!
