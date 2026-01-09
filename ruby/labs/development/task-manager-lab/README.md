# Lab 1: TDD Task Manager

A complete CLI task manager application built with Test-Driven Development (TDD) principles, demonstrating professional Ruby project structure and design patterns.

## Learning Objectives

After completing this lab, you will understand:

- **Test-Driven Development (TDD)**: Write tests first, then implement features
- **Repository Pattern**: Separate data persistence from business logic
- **Service Objects**: Encapsulate business logic in dedicated classes
- **CLI Design**: Build user-friendly command-line interfaces
- **Project Structure**: Organize code following Ruby conventions
- **SOLID Principles**: Single Responsibility, Dependency Injection

## Project Structure

```
task-manager-lab/
├── bin/
│   └── task_manager          # Executable CLI entry point
├── lib/
│   ├── task_manager.rb       # Main application orchestrator
│   ├── task.rb               # Task model (entity)
│   ├── task_repository.rb    # Data persistence layer
│   └── cli.rb                # Command-line interface
├── spec/
│   ├── spec_helper.rb        # RSpec configuration
│   ├── task_spec.rb          # Task model tests
│   ├── task_repository_spec.rb
│   ├── task_manager_spec.rb
│   └── cli_spec.rb
├── .rspec                    # RSpec settings
├── .rubocop.yml              # Rubocop configuration
├── Gemfile                   # Dependencies
├── Rakefile                  # Task automation
└── README.md                 # This file
```

## Design Patterns Demonstrated

### 1. Repository Pattern
Separates data access logic from business logic. The `TaskRepository` handles all file I/O operations, making it easy to swap storage mechanisms (file → database) without changing business logic.

### 2. Single Responsibility Principle
Each class has one clear responsibility:
- `Task`: Represents a task entity
- `TaskRepository`: Manages task persistence
- `TaskManager`: Orchestrates business operations
- `CLI`: Handles user interaction

### 3. Dependency Injection
Classes receive their dependencies through constructors, making them testable and flexible.

## Setup Instructions

### Prerequisites
- Ruby 3.0 or higher
- Bundler gem installed

### Installation

1. **Navigate to the lab directory**:
   ```bash
   cd ruby/labs/development/task-manager-lab
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Run tests to verify setup**:
   ```bash
   bundle exec rspec
   ```

   You should see all tests passing with 100% coverage.

4. **Make the CLI executable** (optional):
   ```bash
   chmod +x bin/task_manager
   ```

## Usage Examples

### Run the Interactive CLI

```bash
# Using Ruby
ruby bin/task_manager

# Or if executable
./bin/task_manager
```

### CLI Commands

Once in the interactive shell:

```
Task Manager - Available Commands:
  add <title> <description>  - Add a new task
  list [status]             - List tasks (all/pending/completed)
  complete <id>             - Mark task as completed
  delete <id>               - Delete a task
  show <id>                 - Show task details
  search <keyword>          - Search tasks by keyword
  help                      - Show this help
  exit                      - Exit application

Examples:
  add "Buy groceries" "Milk, eggs, bread"
  list pending
  complete 1
  search milk
```

### Programmatic Usage

You can also use the library in your own Ruby code:

```ruby
require_relative 'lib/task_manager'

# Create a task manager
manager = TaskManager.new

# Add tasks
task_id = manager.add_task('Learn Ruby', 'Complete TDD tutorial')

# List tasks
pending_tasks = manager.list_tasks(status: :pending)

# Complete a task
manager.complete_task(task_id)

# Search tasks
results = manager.search_tasks('Ruby')
```

## Testing Instructions

### Run All Tests

```bash
bundle exec rspec
```

### Run Specific Test File

```bash
bundle exec rspec spec/task_spec.rb
```

### Run with Coverage Report

```bash
bundle exec rspec
# Open coverage/index.html to see detailed coverage report
```

### Run with Documentation Format

```bash
bundle exec rspec --format documentation
```

### Watch Mode (run tests on file changes)

```bash
bundle exec guard
# Requires: gem install guard guard-rspec
```

## TDD Workflow Demonstrated

This lab follows strict TDD principles:

### Red-Green-Refactor Cycle

1. **Red**: Write a failing test
   ```ruby
   # spec/task_spec.rb
   it 'creates a task with title and description' do
     task = Task.new(title: 'Test', description: 'Test desc')
     expect(task.title).to eq('Test')
   end
   ```

2. **Green**: Write minimal code to make it pass
   ```ruby
   # lib/task.rb
   class Task
     attr_reader :title
     def initialize(title:, description:)
       @title = title
     end
   end
   ```

3. **Refactor**: Improve code while keeping tests green
   ```ruby
   # Add validation, extract methods, etc.
   ```

### Test Structure

Each test file follows the pattern:
- **Arrange**: Set up test data
- **Act**: Execute the code being tested
- **Assert**: Verify the results

## Code Quality

### Run Rubocop (Linter)

```bash
bundle exec rubocop
```

### Auto-fix Rubocop Violations

```bash
bundle exec rubocop -A
```

### Run All Quality Checks

```bash
bundle exec rake
```

## Key Concepts Explained

### 1. Task Model (Entity)
A simple Ruby class representing a task with attributes and behavior. Demonstrates:
- Value objects
- Immutability patterns
- Data validation

### 2. Task Repository
Implements the Repository pattern for data persistence:
- Abstract storage layer
- File-based persistence (easily swappable)
- Transaction-like operations (atomic writes)

### 3. Task Manager (Service)
Business logic orchestrator:
- Coordinates between repository and models
- Implements use cases
- Maintains business rules

### 4. CLI (Interface)
User interface layer:
- Command parsing
- Input validation
- Output formatting
- Error handling

## Extending the Lab

Try these exercises to deepen your understanding:

### Beginner
1. Add a `priority` field to tasks (low/medium/high)
2. Implement task filtering by priority
3. Add a `due_date` field with validation

### Intermediate
4. Implement task categories/tags
5. Add sorting options (by date, priority, title)
6. Create a `update_task` command

### Advanced
7. Replace file storage with SQLite database
8. Add user authentication (multiple users)
9. Implement recurring tasks
10. Add task dependencies (task X must be done before task Y)

## Common Issues & Solutions

### Issue: "cannot load such file"
**Solution**: Make sure you're running commands from the lab directory:
```bash
cd ruby/labs/development/task-manager-lab
```

### Issue: Tests fail on first run
**Solution**: Delete the `tasks.json` file if it exists:
```bash
rm tasks.json
```

### Issue: Permission denied on bin/task_manager
**Solution**: Make the file executable:
```bash
chmod +x bin/task_manager
```

## Additional Resources

- [RSpec Documentation](https://rspec.info/)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Ruby Style Guide](https://rubystyle.guide/)

## License

This lab is part of the Learning with Claude Ruby curriculum and is provided for educational purposes.
