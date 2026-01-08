# Sinatra Lab 1: Todo Application

A full-featured todo application demonstrating core Sinatra concepts with database integration, CRUD operations, and session management.

## 🎯 Learning Objectives

This lab demonstrates:
- **Sinatra Basics**: Routing, request handling, and response rendering
- **Database Integration**: SQLite with Sequel ORM
- **CRUD Operations**: Create, Read, Update, Delete for tasks
- **Sessions**: Flash messages for user feedback
- **Form Handling**: Validation and error handling
- **RESTful Design**: Following REST conventions
- **View Rendering**: ERB templates with layouts
- **Static Assets**: CSS styling

## 📋 Project Structure

```
1-todo-app/
├── README.md (this file)
├── app.rb (main Sinatra application)
├── lib/
│   ├── models.rb (database models: Task, Category)
│   └── helpers.rb (view helper methods)
├── views/
│   ├── layout.erb (main layout template)
│   ├── index.erb (task list view)
│   ├── edit.erb (edit task form)
│   └── new.erb (new task form)
└── public/
    └── css/
        └── style.css (application styles)
```

## 🚀 Running the Lab

```bash
# Install dependencies
gem install sinatra sequel sqlite3

# Run the application
cd ruby/labs/sinatra/1-todo-app
ruby app.rb

# Visit http://localhost:4567
```

## 🎓 Features Implemented

### 1. Task Management (CRUD)
- **Create**: Add new tasks with title, description, and category
- **Read**: View all tasks, filter by category or status
- **Update**: Edit task details, mark as complete/incomplete
- **Delete**: Remove tasks from the system

### 2. Categories
- Organize tasks into categories (Work, Personal, Shopping, etc.)
- Filter tasks by category
- Color-coded category badges

### 3. Task Filtering
- View all tasks
- Filter by completed status
- Filter by category
- Search by title

### 4. Session Management
- Flash messages for success/error feedback
- Persistent notifications across redirects
- User-friendly error messages

### 5. Validation
- Title is required (2-100 characters)
- Description is optional but limited to 500 characters
- Category must exist
- Custom validation messages

## 🔍 Key Code Examples

### RESTful Routes
```ruby
# Index - List all tasks
GET /tasks

# New - Show form for new task
GET /tasks/new

# Create - Create a new task
POST /tasks

# Edit - Show form to edit task
GET /tasks/:id/edit

# Update - Update a task
PUT /tasks/:id

# Delete - Delete a task
DELETE /tasks/:id

# Toggle - Toggle task completion
POST /tasks/:id/toggle
```

### Sequel ORM Usage
```ruby
# Find all incomplete tasks in a category
Task.where(completed: false, category_id: 1).all

# Create a task with validation
task = Task.new(title: "Buy groceries", category: work_category)
task.save

# Update a task
task.update(completed: true)
```

### Flash Messages
```ruby
# Success message
session[:flash] = { success: "Task created successfully!" }

# Error message
session[:flash] = { error: "Title is required" }
```

### View Helpers
```ruby
# Format date nicely
<%= format_date(task.created_at) %>

# Category badge with color
<%= category_badge(task.category) %>

# Status indicator
<%= task_status(task) %>
```

## 🐍 For Python Developers

This Sinatra app compares to these Python frameworks:

### Flask Equivalent
```python
# Flask would use similar patterns
from flask import Flask, render_template, request, redirect, flash
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)

@app.route('/tasks')
def index():
    tasks = Task.query.all()
    return render_template('index.html', tasks=tasks)

@app.route('/tasks', methods=['POST'])
def create():
    task = Task(title=request.form['title'])
    db.session.add(task)
    db.session.commit()
    flash('Task created!')
    return redirect('/tasks')
```

### Django Equivalent
```python
# Django views.py
from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Task

def task_list(request):
    tasks = Task.objects.all()
    return render(request, 'tasks/index.html', {'tasks': tasks})

def task_create(request):
    if request.method == 'POST':
        task = Task.objects.create(
            title=request.POST['title'],
            description=request.POST.get('description', '')
        )
        messages.success(request, 'Task created!')
        return redirect('task_list')
    return render(request, 'tasks/new.html')
```

### Key Differences
- **Sinatra**: Minimalist, explicit routing, no built-in ORM
- **Flask**: Similar minimalism, but with Flask-SQLAlchemy integration
- **Django**: Full-featured, includes ORM, admin, forms, etc.

## 📊 Database Schema

```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  color TEXT NOT NULL
);

CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  completed BOOLEAN DEFAULT FALSE,
  category_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

## 🎯 Challenges

Try extending the application with:

1. **Due Dates**: Add due date field and overdue indicators
2. **Priority Levels**: High, Medium, Low priority with visual indicators
3. **Sub-tasks**: Support for task hierarchies
4. **Tags**: Multiple tags per task for flexible organization
5. **Search**: Full-text search across title and description
6. **Statistics**: Dashboard showing completion rates and trends
7. **Export**: Export tasks to JSON or CSV
8. **Dark Mode**: Toggle between light and dark themes
9. **API Endpoints**: JSON API for mobile app integration
10. **User Authentication**: Multi-user support with login

## 📚 Concepts Covered

After completing this lab, you'll understand:

- **Sinatra Application Structure**: How to organize a real Sinatra app
- **ORM Integration**: Using Sequel for database operations
- **RESTful Design**: Following REST conventions in routing
- **Form Handling**: Processing and validating form submissions
- **Session Management**: Using sessions for flash messages
- **View Rendering**: ERB templates with layouts and partials
- **Asset Management**: Serving static files (CSS, JS, images)
- **Error Handling**: Graceful error handling and user feedback

## 🔧 Technical Details

### Dependencies
- **sinatra**: Web framework (~> 3.0)
- **sequel**: ORM for database access (~> 5.0)
- **sqlite3**: Database driver (~> 1.6)

### Database
- SQLite for simplicity (single file: `todos.db`)
- Can easily switch to PostgreSQL or MySQL

### Styling
- Clean, responsive CSS
- Mobile-friendly design
- Color-coded categories
- Status indicators

---

Ready to build a todo app? Run `ruby app.rb` and start managing tasks!
