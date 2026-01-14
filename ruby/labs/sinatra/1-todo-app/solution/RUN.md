# Running the Todo App Solution

## Prerequisites

Make sure you have Ruby and Bundler installed:

```bash
ruby -v    # Should show Ruby 3.x
bundle -v  # Should show Bundler 2.x
```

## Installation

1. Navigate to the solution folder:
   ```bash
   cd ruby/labs/sinatra/1-todo-app/solution
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

## Running the Application

Start the server:

```bash
ruby app.rb
```

Or using rackup:

```bash
rackup -p 4567
```

## Accessing the App

Open your browser and visit: **http://localhost:4567**

## Features

- ✅ Create, read, update, delete tasks
- ✅ Categorize tasks (Work, Personal, Shopping, Health, Learning)
- ✅ Mark tasks as complete/incomplete
- ✅ Filter by status (All/Active/Completed)
- ✅ Filter by category
- ✅ Search tasks by title
- ✅ Flash messages for feedback
- ✅ Progress tracking with statistics

## Database

The app uses SQLite. The database file `todos.db` will be created automatically on first run. Default categories are seeded automatically.

## Stopping the Server

Press `Ctrl+C` in the terminal.
