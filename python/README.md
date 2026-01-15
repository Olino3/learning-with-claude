# Python Learning Path

Welcome to the Python learning repository! This section contains progressive tutorials, labs, and reading materials to help you learn Python application development.

## 📚 Structure

This repository is organized into three main sections:

### `/tutorials`
Step-by-step tutorials that guide you through Python concepts and programming techniques. Each tutorial builds upon previous knowledge, creating a progressive learning experience.

### `/labs`
Hands-on projects and practical exercises where you can apply what you've learned. These labs provide real-world scenarios to practice Python development.

### `/reading`
Reference materials, documentation, and in-depth information about Python concepts, best practices, and advanced topics.

## 🎯 Learning Approach

This repository uses Git commits to track your learning progress. Each commit represents a step in your learning journey, allowing you to:
- See how applications are built incrementally
- Understand the evolution of code
- Review previous concepts easily
- Track your progress over time

## 🚀 Getting Started

### Setting Up Your Environment

This repository includes a containerized Python development environment—no local Python installation required!

**Quick Start:**
```bash
# From the repository root
tilt up
# Or: make up
```

The environment provides:
- **python-env** container: For running Python scripts, Python REPL, and applications
- Python 3.12 with common packages pre-installed
- Virtual environment for isolated dependency management
- Live code reloading via Tilt

**Common Commands:**
```bash
make python-shell                              # Open bash shell
make python-repl                               # Start Python REPL
make run-python SCRIPT=scripts/hello.py        # Run a script
make python-install                            # Install dependencies from requirements.txt
```

## 📖 Tutorial Path

Start with the basics and progress through increasingly advanced topics:

1. **Getting Started** - Python basics, syntax, and data types
2. **Control Flow** - Conditionals, loops, and flow control
3. **Functions** - Defining and using functions
4. **Data Structures** - Lists, tuples, dictionaries, and sets
5. **Object-Oriented Programming** - Classes, objects, and inheritance
6. **Modules and Packages** - Code organization and imports
7. **File I/O** - Reading and writing files
8. **Error Handling** - Exceptions and error management
9. **Advanced Topics** - Decorators, generators, context managers

## 🧪 Labs

Hands-on projects to practice your skills:

### Beginner Labs
- **Lab 1: Basics** - Fundamentals and simple programs
- **Lab 2: Collections** - Working with data structures
- **Lab 3: Functions** - Building reusable code

### Intermediate Labs
- Build practical applications combining multiple concepts

### Advanced Labs
- Complex projects using advanced Python features

## 🌐 Web Development

Python web development tutorials and labs using popular frameworks:
- Flask (lightweight web framework)
- FastAPI (modern async web framework)
- Django (full-featured web framework)

## 📚 Reading Materials

In-depth documentation on:
- Python best practices (PEP 8, PEP 20)
- Design patterns
- Performance optimization
- Testing strategies
- Package management with pip and virtualenv

## 💡 Tips for Success

1. **Practice regularly** - Code every day, even if just for 30 minutes
2. **Read the error messages** - Python's error messages are helpful
3. **Use the REPL** - Experiment interactively with `make python-repl`
4. **Read others' code** - Learn from the solutions in labs
5. **Write tests** - Practice test-driven development
6. **Ask questions** - Use the reading materials and online resources

## 🔗 Additional Resources

- [Official Python Documentation](https://docs.python.org/3/)
- [Python Package Index (PyPI)](https://pypi.org/)
- [PEP 8 - Style Guide](https://pep8.org/)
- [Real Python Tutorials](https://realpython.com/)

## 🐍 Python Philosophy

Remember the Zen of Python (`import this`):
- Beautiful is better than ugly
- Explicit is better than implicit
- Simple is better than complex
- Readability counts

Happy coding! 🚀
