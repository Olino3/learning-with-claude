# learning-with-claude

Learning things using Claude

## 🚀 Quick Start

This repository includes a containerized development environment using Docker and Tilt. You don't need to install any programming languages locally—everything runs in containers!

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (required)
- [Docker Compose](https://docs.docker.com/compose/install/) (included with Docker Desktop)
- [Tilt](https://docs.tilt.dev/install.html) (optional, for enhanced development experience)

### Starting the Environment

```bash
# Option 1: Using Tilt (recommended - provides a nice web UI)
make up
# Then open http://localhost:10350 for the Tilt dashboard

# Option 2: Using Docker Compose directly
make up-docker

# Check the status of all containers
make status
```

### Stopping the Environment

```bash
make down          # Stop all containers
make clean         # Stop and remove all data (including databases)
```

## 📚 What's Inside

This repository contains learning materials for various programming topics:

- **`/ruby`** - Ruby programming tutorials, labs, and reading materials
  - **`/ruby/tutorials`** - Progressive learning tutorials
  - **`/ruby/labs`** - Hands-on practice projects
  - **`/ruby/reading`** - Reference materials

## 🎯 Learning Paths

### Path 1: Ruby Fundamentals

Start here if you're new to Ruby:

```bash
# 1. Start the environment
make up-docker

# 2. Open the Ruby shell
make shell

# 3. Start the Ruby REPL to experiment
make repl

# 4. Run your first script
make run-script SCRIPT=scripts/hello.rb
```

Follow the tutorials in order:
1. [Getting Started](ruby/tutorials/1-Getting-Started/README.md)
2. [Ruby Basics](ruby/tutorials/2-Ruby-Basics/README.md)
3. Continue through tutorials 3-16...

### Path 2: Sinatra Web Development

Start here if you want to build web applications with Ruby:

```bash
# 1. Start the environment
make up-docker

# 2. Run your first Sinatra tutorial
make sinatra-tutorial NUM=1

# 3. Open http://localhost:4567 in your browser
```

**Sinatra Tutorials (in order):**

| # | Topic | Command |
|---|-------|---------|
| 1 | Hello Sinatra | `make sinatra-tutorial NUM=1` |
| 2 | Routes & Parameters | `make sinatra-tutorial NUM=2` |
| 3 | Templates & Views | `make sinatra-tutorial NUM=3` |
| 4 | Forms & Input | `make sinatra-tutorial NUM=4` |
| 5 | Working with Databases | `make sinatra-tutorial NUM=5` |
| 6 | Sessions & Cookies | `make sinatra-tutorial NUM=6` |
| 7 | Middleware & Filters | `make sinatra-tutorial NUM=7` |
| 8 | RESTful APIs | `make sinatra-tutorial NUM=8` |

**Sinatra Labs (hands-on projects):**

| # | Project | Command |
|---|---------|---------|
| 1 | Todo App | `make sinatra-lab NUM=1` |
| 2 | Blog API | `make sinatra-lab NUM=2` |
| 3 | Authentication App | `make sinatra-lab NUM=3` |
| 4 | Real-time Chat | `make sinatra-lab NUM=4` |

## 🛠️ Available Commands

Run `make help` to see all available commands. Here are the most common ones:

### General Commands

```bash
make help              # Show all available commands
make up                # Start with Tilt
make up-docker         # Start with Docker Compose
make down              # Stop all containers
make status            # Show container status
make logs              # View all logs
```

### Ruby Commands

```bash
make shell             # Open a bash shell in Ruby container
make repl              # Start interactive Ruby REPL (IRB)
make run-script SCRIPT=path/to/file.rb   # Run a Ruby script
```

### Sinatra Commands

```bash
make sinatra-shell     # Open bash shell in Sinatra container
make sinatra-start APP=path/to/app.rb    # Start a Sinatra app
make sinatra-stop      # Stop running Sinatra apps
make sinatra-logs      # View Sinatra container logs
make sinatra-tutorial NUM=1   # Run tutorial by number (1-8)
make sinatra-lab NUM=1        # Run lab by number (1-4)
```

### Database Commands

```bash
make db-console        # Open PostgreSQL console
make redis-cli         # Open Redis CLI
```

## 🌐 Web Application Ports

When running Sinatra applications, these ports are available:

| Port | Description | URL |
|------|-------------|-----|
| 4567 | Sinatra default | http://localhost:4567 |
| 9292 | Rack applications | http://localhost:9292 |
| 3000 | Alternative port | http://localhost:3000 |
| 5432 | PostgreSQL | `localhost:5432` |
| 6379 | Redis | `localhost:6379` |

## 🏗️ Development Environment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Compose                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────┐  ┌─────────────────────┐  │
│  │       ruby-scripts          │  │     ruby-repl       │  │
│  │  (Scripts, Apps, Labs)      │  │       (IRB)         │  │
│  │  + Profiling & Performance  │  │                     │  │
│  └─────────────────────────────┘  └─────────────────────┘  │
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                    sinatra-web                           ││
│  │  Ports: 4567, 9292, 3000                                 ││
│  │  For: Sinatra tutorials, labs, web development          ││
│  └─────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │    postgres     │  │            redis                │  │
│  │   Port: 5432    │  │          Port: 6379             │  │
│  └─────────────────┘  └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Example Workflows

### Workflow 1: Learning Ruby Basics

```bash
# Start environment
make up-docker

# Experiment in the REPL
make repl
# >> puts "Hello, Ruby!"
# >> [1, 2, 3].map { |n| n * 2 }
# >> exit

# Run tutorial exercises
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/my_first_script.rb
```

### Workflow 2: Building a Sinatra Web App

```bash
# Start environment
make up-docker

# Start with the hello world tutorial
make sinatra-tutorial NUM=1
# Open http://localhost:4567 in your browser
# Press Ctrl+C to stop

# Progress to more advanced tutorials
make sinatra-tutorial NUM=2   # Routes
make sinatra-tutorial NUM=3   # Templates
# ...continue through the tutorials

# Try a hands-on lab
make sinatra-lab NUM=1   # Todo App
```

### Workflow 3: Developing Your Own Sinatra App

```bash
# Start environment
make up-docker

# Open a shell to work interactively
make sinatra-shell

# Inside the container, navigate and run your app
cd ruby/labs/sinatra/1-todo-app
ruby app.rb -o 0.0.0.0

# Or run a specific app from outside
make sinatra-start APP=ruby/labs/sinatra/1-todo-app/app.rb
```

## 📖 Learning Approach

This repository uses Git commits to track learning progress. Each commit represents a step in the learning journey, allowing you to:
- See how code evolves incrementally
- Understand the development process
- Review previous concepts easily
- Track progress over time

## 🤝 Tips for Success

1. **Follow tutorials in order** - They build on each other
2. **Type the code yourself** - Don't just copy/paste
3. **Experiment in the REPL** - Use `make repl` to try things out
4. **Read the README files** - Each tutorial/lab has detailed instructions
5. **Check STEPS.md** - Labs have step-by-step guides
6. **Use `make help`** - When in doubt, check available commands

Happy learning! 🎉
