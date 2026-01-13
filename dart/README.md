# Dart Learning Path

Welcome to the Dart learning repository! This section contains progressive tutorials, labs, and reading materials to help you learn Dart application development.

## 📚 Structure

This repository is organized into three main sections:

### `/tutorials`
Step-by-step tutorials that guide you through Dart concepts and programming techniques. Each tutorial builds upon previous knowledge, creating a progressive learning experience designed for Python developers.

### `/labs`
Hands-on projects and practical exercises where you can apply what you've learned. These labs provide real-world scenarios to practice Dart development.

### `/reading`
Reference materials, documentation, and in-depth information about Dart concepts, best practices, and advanced topics.

## 🎯 Learning Approach

This repository uses Git commits to track your learning progress. Each commit represents a step in your learning journey, allowing you to:
- See how applications are built incrementally
- Understand the evolution of code
- Review previous concepts easily
- Track your progress over time

## 🚀 Getting Started

### Setting Up Your Environment

This repository includes a containerized Dart development environment—no local Dart installation required!

**Quick Start:**
```bash
# From the repository root
tilt up
# Or: make up
```

The environment provides:
- **dart-scripts** container: For running Dart scripts and applications
- **dart-repl** container: Interactive Dart interpreter
- Dart SDK with common packages pre-installed
- Live code reloading via Tilt

**Common Commands:**
```bash
make shell                                    # Open bash shell
make repl                                     # Start Dart REPL
make run-script SCRIPT=scripts/hello.dart     # Run a script
```

For detailed instructions, see [Tutorial 1: Getting Started](/dart/tutorials/1-Getting-Started/README.md)

### Learning Path

1. **Start with Tutorial 1**: `/tutorials/1-Getting-Started` - Learn to use the environment
2. **Progress through tutorials**: Work through tutorials 2-10 in order
3. **Practice concepts**: Work through labs in the `/labs` directory
4. **Deepen understanding**: Explore materials in the `/reading` directory

## 📝 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Tilt](https://docs.tilt.dev/install.html) (optional but recommended)
- A text editor or IDE
- Basic understanding of programming concepts (Python experience is helpful)

No Dart installation needed—everything runs in containers! ✨

## 🎓 For Python Developers

These tutorials are specifically designed for engineers with Python experience. Each tutorial includes:
- **Python comparison tables** showing equivalent concepts
- **Python notes** highlighting key differences
- **Mental models** to bridge Python and Dart
- **Common pitfalls** for Python developers

### Critical Differences to Remember

1. **Static Typing:** Dart is statically typed (with inference) vs Python's dynamic typing
2. **Null Safety:** Compile-time null safety - no more `NoneType` runtime errors!
3. **Syntax:** Braces `{}` and semicolons `;`
4. **Collections:** Strongly typed collections with generics
5. **Final vs Const:** Two levels of immutability

### Major Advantages Dart Has Over Python

1. **Null Safety:** Catch null reference errors at compile time
2. **Performance:** AOT compilation for better runtime performance
3. **Type Safety:** Catch type errors before runtime
4. **Better IDE Support:** Strong typing enables excellent autocomplete and refactoring
5. **Modern Async:** First-class async/await and Stream support
6. **Flutter:** Can build native mobile, web, and desktop apps

## 📖 Tutorial Path

Start your Dart learning journey with the comprehensive tutorial series:

👉 **[Dart Tutorials](/dart/tutorials/README.md)**

The tutorials cover:
1. Getting Started - Environment setup
2. Dart Basics - Variables, types, operators
3. Control Flow - Conditionals, loops, switch
4. Functions - Parameters, closures, arrow functions
5. Collections - Lists, sets, maps, generics
6. Object-Oriented Programming - Classes, inheritance, mixins
7. Null Safety - Dart's killer feature
8. Error Handling - Exceptions, try/catch
9. Async Programming - Future, Stream, async/await
10. File I/O - Reading/writing files

## 🎯 After Completing This Path

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

## 📚 Additional Resources

- [Official Dart Documentation](https://dart.dev/guides)
- [Dart Language Tour](https://dart.dev/language)
- [Effective Dart](https://dart.dev/effective-dart)
- [Dart API Reference](https://api.dart.dev/)
- [DartPad](https://dartpad.dev/) - Try Dart in your browser
- [Flutter](https://flutter.dev/) - Build beautiful apps

Happy learning! 🎉
