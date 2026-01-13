# Tutorial 1: Getting Started with Dart

Welcome to your first Dart tutorial! This guide will help you set up your development environment and get comfortable running Dart code.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand how to use the Dart development environment
- Know how to run Dart scripts
- Be comfortable using the interactive Dart REPL
- Have successfully run your first Dart programs

## 🚀 Setting Up Your Development Environment

This repository uses Docker and Tilt to provide a consistent Dart development environment. You don't need to install Dart on your local machine—everything runs in containers!

### Prerequisites

Before you begin, make sure you have:
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- [Tilt](https://docs.tilt.dev/install.html) installed (optional but recommended)

### Starting the Environment

You have two options for starting the development environment:

#### Option 1: Using Tilt (Recommended)

Tilt provides a nice UI and better development experience:

```bash
# From the repository root
tilt up
```

Or use the Makefile shortcut:

```bash
make up
```

Tilt will:
- Build the Docker containers
- Start the services
- Provide a web UI at http://localhost:10350
- Auto-reload when you change files

Press `space` to open the Tilt UI in your browser, or `ctrl+c` to stop.

#### Option 2: Using Docker Compose Directly

If you prefer not to use Tilt:

```bash
# Start in detached mode
docker-compose up -d

# Or use the Makefile
make up-docker
```

### Understanding the Containers

The development environment includes two Dart containers:

1. **dart-scripts**: For running Dart scripts and applications
2. **dart-repl**: For interactive Dart experimentation with the Dart REPL

Both containers have:
- Latest stable Dart SDK installed
- Access to all your code via volume mounts
- Shared pub cache for efficient package management

## ✍️ Exercises

Now that you understand the environment setup, it's time to get hands-on!

We've created two beginner-friendly exercises to help you get started:

### Exercise 1: Run My First Script

Learn how to run Dart scripts using the development environment.

👉 **[Start Exercise 1: Run My First Script](exercises/1-run-my-first-script.md)**

In this exercise, you'll:
- Start the development environment
- Run the provided `hello.dart` script
- Learn three different methods for running scripts
- Verify your environment is working correctly

### Exercise 2: Run My First REPL

Discover the power of interactive Dart programming.

👉 **[Start Exercise 2: Run My First REPL](exercises/2-run-my-first-repl.md)**

In this exercise, you'll:
- Learn what a REPL is and why it's useful
- Start and use the Dart REPL
- Try basic Dart commands interactively
- Understand when to use REPL vs writing scripts

## 📚 What You Learned

After completing the exercises, you will know:

✅ How to start and stop the development environment
✅ How to run Dart scripts using the containers
✅ How to use the Dart REPL for interactive experimentation
✅ The difference between running scripts and using a REPL

## 🔜 Next Steps

Congratulations on completing the Getting Started tutorial! You now have:
- A working Dart development environment
- Experience running Dart scripts
- Familiarity with the interactive Dart REPL

You're ready to start learning Dart programming!

Check out the next tutorial: **2-Dart-Basics** (coming soon)

## 💡 Tips for Learning

- **Experiment**: Don't be afraid to try things in the REPL
- **Make mistakes**: Errors are learning opportunities
- **Practice regularly**: Even 15 minutes a day builds skills
- **Ask questions**: Use comments in your code to document your thinking
- **Have fun**: Enjoy the learning process!

## 🆘 Troubleshooting

### Containers won't start
```bash
# Check if containers are running
docker-compose ps

# View logs
make logs

# Rebuild containers
make build
```

### Script not found
Make sure you're running commands from the repository root directory.

### Permission errors
The containers run as root by default, so file permissions should not be an issue.

## 📖 Additional Resources

- [Official Dart Documentation](https://dart.dev/guides)
- [Dart Language Tour](https://dart.dev/language)
- [Dart API Reference](https://api.dart.dev/)
- [DartPad (Try Dart in Browser)](https://dartpad.dev/)
- [Effective Dart](https://dart.dev/effective-dart)

---

Happy coding! 🎉 Start with **[Exercise 1: Run My First Script](exercises/1-run-my-first-script.md)** when you're ready!
