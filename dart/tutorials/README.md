# Dart Tutorials

Progressive tutorials for learning Dart development, designed for engineers with Python experience.

## 🎯 Learning Path

These tutorials build upon each other progressively. Follow them in order for the best learning experience.

### Tutorial 1: Getting Started
**Status:** ✅ Complete

Get your Dart development environment up and running with Docker and Tilt.

👉 **[Start Tutorial 1: Getting Started](1-Getting-Started/README.md)**

**You'll learn:**
- How to use the Dart development environment
- Running Dart scripts
- Using the interactive Dart REPL
- The difference between REPLs and scripts

---

### Tutorial 2: Dart Basics - Variables, Types, and Operators
**Status:** ✅ Complete

Master Dart's fundamental syntax with special attention to differences from Python.

👉 **[Start Tutorial 2: Dart Basics](2-Dart-Basics/README.md)**

**You'll learn:**
- Variables and type annotations
- Basic data types (int, double, String, bool, dynamic)
- **Key difference:** Static typing with type inference
- String interpolation with `${}`
- Type conversion and casting
- Dart's `var`, `final`, and `const` keywords

**Key for Python developers:**
- Dart is statically typed (but has type inference)
- `final` and `const` for immutability
- String interpolation uses `${}` syntax
- No implicit type coercion

---

### Tutorial 3: Control Flow - Conditionals and Loops
**Status:** ✅ Complete

Learn Dart's control structures and how they compare to Python.

👉 **[Start Tutorial 3: Control Flow](3-Control-Flow/README.md)**

**You'll learn:**
- If/else if/else statements
- Switch/case with pattern matching (Dart 3.0+)
- For loops, for-in loops, while, and do-while
- Loop control: break and continue
- **Dart's collection control flow:** if and for in collections
- **Dart's spread operator:** `...` for expanding collections

**Key for Python developers:**
- Switch/case is powerful with pattern matching
- Collection if/for allows inline filtering
- Must use braces `{}` for blocks (no indentation-based blocks)
- Spread operator `...` is like Python's `*`

---

### Tutorial 4: Functions - Dart's Flexible Approach
**Status:** ✅ Complete

Master Dart's powerful function features.

👉 **[Start Tutorial 4: Functions](4-Functions/README.md)**

**You'll learn:**
- Function declarations and types
- Positional and named parameters
- Optional parameters with defaults
- **Arrow functions:** `=>` for single expressions
- **First-class functions:** Functions as values
- Anonymous functions and closures
- Higher-order functions

**Key for Python developers:**
- Named parameters use curly braces `{}`
- Required named parameters with `required` keyword
- Arrow functions `=>` for concise syntax
- Type annotations on parameters and return types
- Closures work similarly to Python

---

### Tutorial 5: Collections - Lists, Sets, and Maps
**Status:** ✅ Complete

Master Dart's collection types and their powerful methods.

👉 **[Start Tutorial 5: Collections](5-Collections/README.md)**

**You'll learn:**
- Lists (Dart's arrays) and operations
- Sets for unique values
- Maps (Dart's dictionaries) with strong typing
- Collection methods: .map(), .where(), .reduce()
- **Collection literals:** [], {}, {}
- **Spread operators and collection if/for**
- Working with generic types

**Key for Python developers:**
- Lists are typed: `List<int>` instead of `list`
- Sets use `{}` but different from Maps
- Maps need type annotations: `Map<String, int>`
- Method chaining is common
- Collection if/for for inline transformations

---

### Tutorial 6: Object-Oriented Programming
**Status:** ✅ Complete

Learn Dart's elegant object-oriented features.

👉 **[Start Tutorial 6: OOP](6-Object-Oriented-Programming/README.md)**

**You'll learn:**
- Classes and objects
- Constructors (default, named, factory)
- Properties and methods
- Getters and setters
- Inheritance with `extends`
- Abstract classes and interfaces
- Mixins with `with`
- **Dart's unique features:** Named constructors, factory constructors

**Key for Python developers:**
- Constructors are special methods (no `__init__`)
- Named constructors for multiple initialization patterns
- No `self` - just use property names directly
- Mixins are more powerful than multiple inheritance
- `@override` annotation for clarity

---

### Tutorial 7: Null Safety - Dart's Superpower
**Status:** ✅ Complete

Master Dart's sound null safety system - a major advantage over Python.

👉 **[Start Tutorial 7: Null Safety](7-Null-Safety/README.md)**

**You'll learn:**
- **Nullable vs non-nullable types:** `String` vs `String?`
- **Null-aware operators:** `??`, `??=`, `?.`, `!`
- **Late variables:** `late` keyword
- The `required` keyword for named parameters
- Null assertion operator `!` (use carefully!)
- Flow analysis and type promotion

**Key for Python developers:**
- Null safety is compile-time enforced (unlike Python's Optional)
- `Type?` means nullable, `Type` means non-nullable
- No more `NullPointerException` runtime errors
- `?.` for safe navigation (like Python's optional chaining)
- This is a MAJOR difference and advantage over Python

---

### Tutorial 8: Error Handling and Exceptions
**Status:** ✅ Complete

Master Dart's exception handling system.

👉 **[Start Tutorial 8: Error Handling](8-Error-Handling/README.md)**

**You'll learn:**
- try/catch/finally blocks
- on keyword for catching specific exceptions
- Throwing exceptions
- Custom exception classes
- Stack traces
- **rethrow** keyword
- When to use exceptions vs return values

**Key for Python developers:**
- `try/catch/finally` (catch not except)
- `on ExceptionType` before catch
- `rethrow` to propagate exceptions
- Similar philosophy to Python
- Exceptions should be exceptional

---

### Tutorial 9: Asynchronous Programming
**Status:** ✅ Complete

Learn Dart's powerful async model - essential for modern apps.

👉 **[Start Tutorial 9: Async Programming](9-Async-Programming/README.md)**

**You'll learn:**
- **Future:** Dart's promise/async result
- **async/await syntax**
- **Stream:** Dart's async sequences
- Error handling in async code
- **await for** loops
- **async* generators**
- Concurrent execution with Future.wait()

**Key for Python developers:**
- Similar to Python's asyncio but more integrated
- `Future` is like Python's `Future` or `Task`
- `Stream` is like Python's async generators
- `async/await` works similarly
- Better tooling and language integration than Python

---

### Tutorial 10: File I/O and String Processing
**Status:** ✅ Complete

Learn file operations and text processing in Dart.

👉 **[Start Tutorial 10: File-IO](10-File-IO/README.md)**

**You'll learn:**
- Reading and writing files
- Async file operations
- Line-by-line processing
- File existence and metadata
- Working with paths
- Text parsing and formatting
- **dart:io** library

**Key for Python developers:**
- Similar to Python's file operations
- Async by default for better performance
- Path operations similar to `pathlib`
- Strong typing for file operations

---

### Tutorial 11: Advanced Generics and Type System
**Status:** ✅ Complete

Master Dart's powerful type system and advanced generics features.

👉 **[Start Tutorial 11: Advanced Generics](11-Advanced-Generics-Type-System/README.md)**

**You'll learn:**
- Generic classes with type parameters and constraints
- Type bounds with `extends`
- Covariance and contravariance
- Runtime type checking and casting
- Generic type inference
- Type-safe APIs and patterns

**Key for Python developers:**
- Dart's generics are enforced at compile time (unlike Python's optional hints)
- Type bounds are more powerful than Python's TypeVar bounds
- Runtime type information is preserved
- Type safety prevents entire classes of bugs

---

### Tutorial 12: Mixins and Extension Methods
**Status:** ✅ Complete

Learn Dart's powerful composition features for code reuse.

👉 **[Start Tutorial 12: Mixins & Extensions](12-Mixins-Extension-Methods/README.md)**

**You'll learn:**
- Creating and using mixins with `with`
- Mixin constraints using `on`
- Extension methods to add functionality
- Generic extensions
- Mixin ordering and conflict resolution
- Practical patterns with mixins

**Key for Python developers:**
- Cleaner than Python's multiple inheritance (no MRO complexity)
- Extension methods are safer than monkey patching
- Mixins enable true composition over inheritance
- More predictable than Python's method resolution order

---

### Tutorial 13: Advanced Async Patterns
**Status:** ✅ Complete

Master advanced asynchronous programming patterns in Dart.

👉 **[Start Tutorial 13: Advanced Async](13-Advanced-Async-Patterns/README.md)**

**You'll learn:**
- StreamController for custom streams
- Stream transformations and operators
- Async generators with `async*` and `yield`
- Completer for manual Future control
- Isolates for true parallel processing
- Broadcast vs single-subscription streams
- Combining multiple streams

**Key for Python developers:**
- More integrated than Python's asyncio
- Isolates provide true parallelism (no GIL!)
- Streams are more powerful than async generators
- Better tooling and language integration

---

### Tutorial 14: Reflection and Metadata
**Status:** ✅ Complete

Understand annotations, reflection, and code generation in Dart.

👉 **[Start Tutorial 14: Reflection](14-Reflection-Metadata/README.md)**

**You'll learn:**
- Built-in and custom annotations
- dart:mirrors for reflection (with caveats)
- Runtime type information
- Reflectable package
- Code generation with build_runner
- When to use reflection vs code generation

**Key for Python developers:**
- Code generation preferred over runtime reflection
- Annotations more limited than Python decorators
- Performance and tree-shaking considerations
- Modern approach favors compile-time generation

---

### Tutorial 15: Advanced Error Handling and Debugging
**Status:** ✅ Complete

Master sophisticated error handling patterns and debugging techniques.

👉 **[Start Tutorial 15: Error Handling](15-Advanced-Error-Handling/README.md)**

**You'll learn:**
- Custom exception hierarchies
- Result/Either types for functional error handling
- Stack trace manipulation
- Zone-based error boundaries
- Debugging techniques and tools
- Retry patterns with exponential backoff
- Circuit breaker pattern
- Error logging and reporting

**Key for Python developers:**
- Similar exception model but more structured
- Zones provide error boundaries (like Python's context managers)
- Result types are functional alternative to exceptions
- Better stack trace utilities than Python

---

### Tutorial 16: Idiomatic Dart Patterns and Best Practices
**Status:** ✅ Complete

Write production-ready, idiomatic Dart code following best practices.

👉 **[Start Tutorial 16: Idiomatic Dart](16-Idiomatic-Dart-Patterns/README.md)**

**You'll learn:**
- Factory patterns and named constructors
- Builder pattern with fluent APIs
- Cascade notation advanced usage
- Functional programming patterns
- Immutability with final, const, copyWith
- Null safety best practices
- Collection patterns and operators
- Pattern matching with switch expressions (Dart 3.0+)
- Effective Dart style guide
- Common anti-patterns to avoid

**Key for Python developers:**
- Different idioms than Python - embrace Dart's way
- Named constructors are more powerful than @classmethod
- Immutability patterns prevent bugs
- Pattern matching more powerful than Python's match
- Strong conventions lead to readable code

---

## 📊 Tutorial Overview

### Core Tutorials (1-10)

| # | Tutorial | Topics | Difficulty |
|---|----------|--------|------------|
| 1 | Getting Started | Environment setup, scripts, REPL | ⭐ Beginner |
| 2 | Dart Basics | Syntax, variables, types, operators | ⭐ Beginner |
| 3 | Control Flow | Conditionals, loops, switch | ⭐⭐ Beginner |
| 4 | Functions | Parameters, arrow functions, closures | ⭐⭐ Intermediate |
| 5 | Collections | Lists, sets, maps, generics | ⭐⭐ Intermediate |
| 6 | OOP | Classes, inheritance, mixins | ⭐⭐ Intermediate |
| 7 | Null Safety | Nullable types, null-aware operators | ⭐⭐⭐ Intermediate |
| 8 | Error Handling | Exceptions, try/catch | ⭐⭐ Intermediate |
| 9 | Async Programming | Future, async/await, Stream | ⭐⭐⭐ Intermediate |
| 10 | File I/O | Files, paths, text processing | ⭐⭐ Intermediate |

### Intermediate Tutorials (11-16)

| # | Tutorial | Topics | Difficulty |
|---|----------|--------|------------|
| 11 | Advanced Generics & Type System | Generic constraints, variance, type casting | ⭐⭐⭐ Intermediate |
| 12 | Mixins & Extension Methods | Mixin composition, extension methods | ⭐⭐⭐ Intermediate |
| 13 | Advanced Async Patterns | StreamController, Isolates, async generators | ⭐⭐⭐⭐ Advanced |
| 14 | Reflection & Metadata | Annotations, code generation, dart:mirrors | ⭐⭐⭐ Intermediate |
| 15 | Advanced Error Handling | Custom exceptions, Result types, Zones | ⭐⭐⭐ Intermediate |
| 16 | Idiomatic Dart Patterns | Best practices, design patterns, style guide | ⭐⭐⭐ Intermediate |

---

## 🎓 For Python Developers

Each tutorial includes special **Python Notes** highlighting:
- Key differences between Python and Dart
- Common pitfalls for Python developers
- Idiomatic translations of Python patterns to Dart
- Mental models to bridge the two languages

### Critical Differences to Remember

1. **Static Typing:** Dart is statically typed (with inference) vs Python's dynamic typing
2. **Null Safety:** Compile-time null safety - no more `NoneType` runtime errors!
3. **Syntax:** Braces `{}` and semicolons `;` (though semicolons are often optional)
4. **Collections:** Strongly typed collections with generics
5. **Async/Await:** More deeply integrated into the language
6. **Final vs Const:** Two levels of immutability
7. **Everything is an object:** Like Python, but with static types

### Major Advantages Dart Has Over Python

1. **Null Safety:** Catch null reference errors at compile time
2. **Performance:** AOT compilation for better runtime performance
3. **Type Safety:** Catch type errors before runtime
4. **Better IDE Support:** Strong typing enables excellent autocomplete and refactoring
5. **Modern Async:** First-class async/await and Stream support
6. **Flutter:** Can build native mobile, web, and desktop apps

## 🚀 Getting Started

1. **Start with Tutorial 1** to set up your environment
2. **Follow tutorials in order** - they build progressively
3. **Do all exercises** - hands-on practice is essential
4. **Use the REPL** - experiment freely
5. **Compare with Python** - leverage your existing knowledge

## 💡 Learning Tips

- **Experiment in the REPL:** Try everything interactively first
- **Read the Python notes:** They'll help you map concepts
- **Complete the challenges:** They confirm your understanding
- **Write code daily:** Even 15 minutes builds muscle memory
- **Embrace static typing:** It's your friend, not your enemy
- **Use the type system:** Let Dart help you catch bugs early
- **Think "Flutter-ready":** Many Dart patterns prepare you for Flutter

## 📚 Structure

Each tutorial includes:
- **README:** Concepts and comparisons with Python
- **Exercises:** Progressive hands-on practice with REPL and scripts
- **Practice scripts:** Run and experiment
- **Challenge scripts:** Test your understanding
- **Python notes:** Throughout every tutorial

## 🎯 After Completing These Tutorials

You'll be able to:
- ✅ Write idiomatic Dart code
- ✅ Understand Dart's type system and null safety
- ✅ Leverage Dart's modern features
- ✅ Build Dart applications confidently
- ✅ Be ready to learn Flutter
- ✅ Appreciate static typing's benefits

### Next Steps

- **Build projects:** Apply what you've learned
- **Learn Flutter:** Build mobile, web, and desktop apps
- **Explore packages:** Discover pub.dev ecosystem
- **Join the community:** Dart/Flutter Discord, Reddit
- **Practice on Exercism:** Dart track exercises
- **Read Dart code:** Study popular packages

## 📖 Additional Resources

- [Official Dart Documentation](https://dart.dev/guides)
- [Dart Language Tour](https://dart.dev/language)
- [Effective Dart](https://dart.dev/effective-dart)
- [Dart API Reference](https://api.dart.dev/)
- [DartPad](https://dartpad.dev/) - Try Dart in your browser
- [Flutter](https://flutter.dev/) - Build beautiful apps

## 🤝 Contributing

Found an issue or have a suggestion? These tutorials are designed to help Python developers learn Dart effectively. Feedback is always welcome!

---

**Ready to start?** Begin with **[Tutorial 1: Getting Started](1-Getting-Started/README.md)**!

Happy learning! 🎯✨
