# learning-with-claude

Learning things using Claude

## 🚀 Quick Start

This repository includes a containerized development environment using Docker and Tilt. You don't need to install any programming languages locally—everything runs in containers!

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Tilt](https://docs.tilt.dev/install.html) (optional but recommended)

### Starting the Environment

```bash
# Using Tilt (recommended)
tilt up

# Or using Docker Compose directly
docker-compose up -d

# Or using the Makefile
make up
```

### Quick Commands

```bash
make help          # View all available commands
make shell         # Open a shell in the development container
make repl          # Start an interactive Ruby interpreter
make run-script    # Run a Ruby script
make down          # Stop the environment
```

## 📚 What's Inside

This repository contains learning materials for various programming topics, organized by language:

- **`/ruby`** - Ruby programming tutorials, labs, and reading materials

Each section includes:
- Progressive tutorials
- Hands-on labs
- Reference materials
- Example code

## 🎯 Getting Started

1. Start the development environment: `tilt up` or `make up`
2. Navigate to the language you want to learn (e.g., `/ruby`)
3. Follow the tutorials in order, starting with "Getting Started"
4. Practice with the provided labs and exercises
5. Use the reading materials for deeper understanding

## 🏗️ Development Environment

The development environment is built with:
- **Docker**: Containerized runtime environments
- **Docker Compose**: Multi-container orchestration
- **Tilt**: Development workflow automation with live reload

Benefits:
- ✅ No local installation required
- ✅ Consistent environment for all learners
- ✅ Easy to get started
- ✅ Extensible for different languages and frameworks

## 📖 Learning Approach

This repository uses Git commits to track learning progress. Each commit represents a step in the learning journey, allowing you to:
- See how code evolves incrementally
- Understand the development process
- Review previous concepts easily
- Track progress over time

Happy learning! 🎉
