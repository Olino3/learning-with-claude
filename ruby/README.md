# Ruby Learning Path

Welcome to the Ruby learning repository! This section contains progressive tutorials, labs, and reading materials to help you learn Ruby application development.

## 📚 Structure

This repository is organized into three main sections:

### `/tutorials`
Step-by-step tutorials that guide you through Ruby concepts and programming techniques. Each tutorial builds upon previous knowledge, creating a progressive learning experience.

### `/labs`
Hands-on projects and practical exercises where you can apply what you've learned. These labs provide real-world scenarios to practice Ruby development.

### `/reading`
Reference materials, documentation, and in-depth information about Ruby concepts, best practices, and advanced topics.

## 🎯 Learning Approach

This repository uses Git commits to track your learning progress. Each commit represents a step in your learning journey, allowing you to:
- See how applications are built incrementally
- Understand the evolution of code
- Review previous concepts easily
- Track your progress over time

## 🚀 Getting Started

### Setting Up Your Environment

This repository includes a containerized Ruby development environment—no local Ruby installation required!

**Quick Start:**
```bash
# From the repository root
tilt up
# Or: make up
```

The environment provides:
- **ruby-scripts** container: For running Ruby scripts and applications
- **ruby-repl** container: Interactive Ruby interpreter (IRB)
- Ruby 3.3 with common gems pre-installed
- Live code reloading via Tilt

**Common Commands:**
```bash
make shell                                    # Open bash shell
make repl                                     # Start IRB
make run-script SCRIPT=scripts/hello.rb       # Run a script
```

For detailed instructions, see [Tutorial 1: Getting Started](/ruby/tutorials/1-Getting-Started/README.md)

### Learning Path

1. **Start with Tutorial 1**: `/tutorials/1-Getting-Started` - Learn to use the environment
2. **Practice concepts**: Work through labs in the `/labs` directory
3. **Deepen understanding**: Explore materials in the `/reading` directory

## 📝 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Tilt](https://docs.tilt.dev/install.html) (optional but recommended)
- A text editor or IDE
- Basic understanding of programming concepts (helpful but not required)

No Ruby installation needed—everything runs in containers! ✨

Happy learning! 🎉
