# Progressive Building Guide: Todo Application

Build a complete todo application step by step, learning Sinatra fundamentals along the way.

## 🎯 Overview

This guide breaks down the todo application into 8 progressive steps:
1. **Basic Sinatra Setup** - Create your first Sinatra route
2. **Add Database** - Set up SQLite with Sequel ORM
3. **Create Models** - Define Task and Category models
4. **List Tasks** - Display all tasks with ERB templates
5. **Create Tasks** - Add form to create new tasks
6. **Update & Delete** - Edit and remove tasks
7. **Add Sessions** - Flash messages for user feedback
8. **Add Filtering** - Filter by category and status

**Estimated Time**: 2-3 hours

---

## Step 1: Basic Sinatra Setup (15 min)

### 🎯 Goal
Create a basic Sinatra application with a home route.

### 📝 Tasks

1. **Create the main application file** (`app.rb`):
   ```ruby
   require 'sinatra'

   get '/' do
     "Hello, Todo App!"
   end
   ```

2. **Run the application**:
   ```bash
   ruby app.rb
   ```

3. **Visit** `http://localhost:4567` in your browser

4. **Enhance the home route**:
   ```ruby
   require 'sinatra'

   get '/' do
     redirect '/tasks'
   end

   get '/tasks' do
     "Your tasks will appear here"
   end
   ```

### ✅ Checkpoint
- [ ] Sinatra app runs without errors
- [ ] You can access localhost:4567
- [ ] Routes redirect properly

---

## Step 2: Add Database (20 min)

### 🎯 Goal
Set up SQLite database with Sequel ORM.

### 📝 Tasks

1. **Install required gems**:
   ```bash
   gem install sequel sqlite3
   ```

2. **Update app.rb to include database**:
   ```ruby
   require 'sinatra'
   require 'sequel'

   # Connect to database (creates file if doesn't exist)
   DB = Sequel.connect('sqlite://todos.db')

   # Create tables if they don't exist
   DB.create_table? :categories do
     primary_key :id
     String :name, null: false
     String :color, default: 'blue'
   end

   DB.create_table? :tasks do
     primary_key :id
     String :title, null: false
     String :description, text: true
     Boolean :completed, default: false
     foreign_key :category_id, :categories
     DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
     DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
   end

   get '/' do
     redirect '/tasks'
   end

   get '/tasks' do
     "Database connected! Tables created."
   end
   ```

3. **Test the database connection**:
   ```bash
   ruby app.rb
   # Visit http://localhost:4567/tasks
   # Check that todos.db file was created
   ```

### ✅ Checkpoint
- [ ] Database file `todos.db` is created
- [ ] No database errors when running app
- [ ] Tables are created successfully

---

## Step 3: Create Models (20 min)

### 🎯 Goal
Define Task and Category models with Sequel.

### 📝 Tasks

1. **Create lib directory**:
   ```bash
   mkdir -p lib
   ```

2. **Create models file** (`lib/models.rb`):
   ```ruby
   require 'sequel'

   class Category < Sequel::Model
     one_to_many :tasks

     def validate
       super
       errors.add(:name, 'cannot be empty') if !name || name.empty?
     end
   end

   class Task < Sequel::Model
     many_to_one :category

     def validate
       super
       errors.add(:title, 'cannot be empty') if !title || title.empty?
       errors.add(:title, 'must be between 2 and 100 characters') if title && (title.length < 2 || title.length > 100)
     end

     def toggle_completion!
       self.completed = !self.completed
       self.save
     end
   end
   ```

3. **Update app.rb to use models**:
   ```ruby
   require 'sinatra'
   require 'sequel'

   # Database connection
   DB = Sequel.connect('sqlite://todos.db')

   # Create tables
   DB.create_table? :categories do
     primary_key :id
     String :name, null: false
     String :color, default: 'blue'
   end

   DB.create_table? :tasks do
     primary_key :id
     String :title, null: false
     String :description, text: true
     Boolean :completed, default: false
     foreign_key :category_id, :categories
     DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
     DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
   end

   # Load models
   require_relative 'lib/models'

   # Seed some default categories
   if Category.count == 0
     Category.create(name: 'Work', color: 'blue')
     Category.create(name: 'Personal', color: 'green')
     Category.create(name: 'Shopping', color: 'orange')
   end

   get '/' do
     redirect '/tasks'
   end

   get '/tasks' do
     tasks = Task.all
     categories = Category.all
     "Found #{tasks.count} tasks and #{categories.count} categories"
   end
   ```

4. **Test models**:
   ```bash
   ruby app.rb
   # Should see "Found 0 tasks and 3 categories"
   ```

### ✅ Checkpoint
- [ ] Models are loaded without errors
- [ ] Categories are seeded
- [ ] Task count displays correctly

---

## Step 4: List Tasks with Templates (30 min)

### 🎯 Goal
Display tasks in a nice HTML template.

### 📝 Tasks

1. **Create views directory**:
   ```bash
   mkdir -p views
   ```

2. **Create layout template** (`views/layout.erb`):
   ```erb
   <!DOCTYPE html>
   <html>
   <head>
     <title>Todo App</title>
     <meta charset="utf-8">
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <link rel="stylesheet" href="/css/style.css">
   </head>
   <body>
     <header>
       <div class="container">
         <h1>📝 Todo App</h1>
       </div>
     </header>

     <main class="container">
       <%= yield %>
     </main>

     <footer>
       <div class="container">
         <p>Built with Sinatra</p>
       </div>
     </footer>
   </body>
   </html>
   ```

3. **Create index view** (`views/index.erb`):
   ```erb
   <div class="header-actions">
     <h2>My Tasks</h2>
     <a href="/tasks/new" class="btn btn-primary">+ New Task</a>
   </div>

   <% if @tasks.empty? %>
     <div class="empty-state">
       <p>No tasks yet! Create your first task to get started.</p>
       <a href="/tasks/new" class="btn btn-primary">Create Task</a>
     </div>
   <% else %>
     <div class="task-list">
       <% @tasks.each do |task| %>
         <div class="task-item <%= 'completed' if task.completed %>">
           <div class="task-content">
             <h3><%= task.title %></h3>
             <% if task.description && !task.description.empty? %>
               <p><%= task.description %></p>
             <% end %>
             <% if task.category %>
               <span class="badge badge-<%= task.category.color %>">
                 <%= task.category.name %>
               </span>
             <% end %>
           </div>
           <div class="task-actions">
             <form method="post" action="/tasks/<%= task.id %>/toggle" style="display:inline">
               <button type="submit" class="btn btn-sm">
                 <%= task.completed ? '↺ Undo' : '✓ Complete' %>
               </button>
             </form>
             <a href="/tasks/<%= task.id %>/edit" class="btn btn-sm">Edit</a>
             <form method="post" action="/tasks/<%= task.id %>" style="display:inline">
               <input type="hidden" name="_method" value="DELETE">
               <button type="submit" class="btn btn-sm btn-danger"
                       onclick="return confirm('Are you sure?')">Delete</button>
             </form>
           </div>
         </div>
       <% end %>
     </div>
   <% end %>
   ```

4. **Update app.rb to render template**:
   ```ruby
   # ... (previous code)

   get '/tasks' do
     @tasks = Task.order(Sequel.desc(:created_at)).all
     erb :index
   end
   ```

5. **Create basic CSS** (`public/css/style.css`):
   ```bash
   mkdir -p public/css
   ```

   ```css
   /* public/css/style.css */
   * {
     margin: 0;
     padding: 0;
     box-sizing: border-box;
   }

   body {
     font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
     line-height: 1.6;
     color: #333;
     background: #f5f5f5;
   }

   .container {
     max-width: 800px;
     margin: 0 auto;
     padding: 0 20px;
   }

   header {
     background: #4CAF50;
     color: white;
     padding: 1rem 0;
     box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   }

   header h1 {
     margin: 0;
     font-size: 1.8rem;
   }

   main {
     padding: 2rem 0;
   }

   .header-actions {
     display: flex;
     justify-content: space-between;
     align-items: center;
     margin-bottom: 2rem;
   }

   .btn {
     padding: 0.5rem 1rem;
     background: #4CAF50;
     color: white;
     text-decoration: none;
     border-radius: 4px;
     border: none;
     cursor: pointer;
     font-size: 1rem;
   }

   .btn:hover {
     background: #45a049;
   }

   .btn-primary {
     background: #2196F3;
   }

   .btn-primary:hover {
     background: #0b7dda;
   }

   .task-item {
     background: white;
     padding: 1rem;
     margin-bottom: 1rem;
     border-radius: 8px;
     box-shadow: 0 2px 4px rgba(0,0,0,0.1);
     display: flex;
     justify-content: space-between;
     align-items: flex-start;
   }

   .task-item.completed {
     opacity: 0.6;
   }

   .task-item.completed h3 {
     text-decoration: line-through;
   }

   .task-content {
     flex: 1;
   }

   .task-content h3 {
     margin-bottom: 0.5rem;
   }

   .task-actions {
     display: flex;
     gap: 0.5rem;
   }

   .badge {
     display: inline-block;
     padding: 0.25rem 0.75rem;
     border-radius: 12px;
     font-size: 0.875rem;
     margin-top: 0.5rem;
   }

   .badge-blue { background: #E3F2FD; color: #1976D2; }
   .badge-green { background: #E8F5E9; color: #388E3C; }
   .badge-orange { background: #FFF3E0; color: #F57C00; }

   .empty-state {
     text-align: center;
     padding: 3rem;
     background: white;
     border-radius: 8px;
   }

   footer {
     text-align: center;
     padding: 2rem 0;
     color: #666;
   }
   ```

### ✅ Checkpoint
- [ ] Tasks display in a list
- [ ] Page is styled nicely
- [ ] Layout template works
- [ ] Empty state shows when no tasks

---

## Step 5: Create Tasks (25 min)

### 🎯 Goal
Add a form to create new tasks.

### 📝 Tasks

1. **Create new task view** (`views/new.erb`):
   ```erb
   <h2>New Task</h2>

   <form method="post" action="/tasks" class="form">
     <div class="form-group">
       <label for="title">Title *</label>
       <input type="text" id="title" name="title" required
              minlength="2" maxlength="100">
     </div>

     <div class="form-group">
       <label for="description">Description</label>
       <textarea id="description" name="description" rows="4"
                 maxlength="500"></textarea>
     </div>

     <div class="form-group">
       <label for="category_id">Category</label>
       <select id="category_id" name="category_id">
         <option value="">None</option>
         <% @categories.each do |category| %>
           <option value="<%= category.id %>"><%= category.name %></option>
         <% end %>
       </select>
     </div>

     <div class="form-actions">
       <button type="submit" class="btn btn-primary">Create Task</button>
       <a href="/tasks" class="btn">Cancel</a>
     </div>
   </form>
   ```

2. **Add CSS for forms** (add to `public/css/style.css`):
   ```css
   .form {
     background: white;
     padding: 2rem;
     border-radius: 8px;
     box-shadow: 0 2px 4px rgba(0,0,0,0.1);
     max-width: 600px;
   }

   .form-group {
     margin-bottom: 1.5rem;
   }

   .form-group label {
     display: block;
     margin-bottom: 0.5rem;
     font-weight: 500;
   }

   .form-group input,
   .form-group textarea,
   .form-group select {
     width: 100%;
     padding: 0.75rem;
     border: 1px solid #ddd;
     border-radius: 4px;
     font-size: 1rem;
   }

   .form-group textarea {
     resize: vertical;
   }

   .form-actions {
     display: flex;
     gap: 1rem;
   }
   ```

3. **Add routes to app.rb**:
   ```ruby
   # Show form for new task
   get '/tasks/new' do
     @categories = Category.all
     erb :new
   end

   # Create new task
   post '/tasks' do
     task = Task.new(
       title: params[:title],
       description: params[:description],
       category_id: params[:category_id].empty? ? nil : params[:category_id]
     )

     if task.valid?
       task.save
       redirect '/tasks'
     else
       @error = task.errors.full_messages.join(', ')
       @categories = Category.all
       erb :new
     end
   end
   ```

### ✅ Checkpoint
- [ ] New task form displays
- [ ] Can create tasks successfully
- [ ] Validation works
- [ ] Redirects after creation

---

## Step 6: Update & Delete Tasks (25 min)

### 🎯 Goal
Add edit and delete functionality.

### 📝 Tasks

1. **Enable method override** in app.rb:
   ```ruby
   require 'sinatra'
   require 'sequel'

   # Enable PUT and DELETE methods
   use Rack::MethodOverride

   # ... rest of code
   ```

2. **Create edit view** (`views/edit.erb`):
   ```erb
   <h2>Edit Task</h2>

   <form method="post" action="/tasks/<%= @task.id %>" class="form">
     <input type="hidden" name="_method" value="PUT">

     <div class="form-group">
       <label for="title">Title *</label>
       <input type="text" id="title" name="title" value="<%= @task.title %>"
              required minlength="2" maxlength="100">
     </div>

     <div class="form-group">
       <label for="description">Description</label>
       <textarea id="description" name="description" rows="4"
                 maxlength="500"><%= @task.description %></textarea>
     </div>

     <div class="form-group">
       <label for="category_id">Category</label>
       <select id="category_id" name="category_id">
         <option value="">None</option>
         <% @categories.each do |category| %>
           <option value="<%= category.id %>"
                   <%= 'selected' if @task.category_id == category.id %>>
             <%= category.name %>
           </option>
         <% end %>
       </select>
     </div>

     <div class="form-actions">
       <button type="submit" class="btn btn-primary">Update Task</button>
       <a href="/tasks" class="btn">Cancel</a>
     </div>
   </form>
   ```

3. **Add edit, update, and delete routes**:
   ```ruby
   # Show edit form
   get '/tasks/:id/edit' do
     @task = Task[params[:id]]
     halt 404, "Task not found" unless @task
     @categories = Category.all
     erb :edit
   end

   # Update task
   put '/tasks/:id' do
     task = Task[params[:id]]
     halt 404, "Task not found" unless task

     task.update(
       title: params[:title],
       description: params[:description],
       category_id: params[:category_id].empty? ? nil : params[:category_id]
     )

     redirect '/tasks'
   end

   # Delete task
   delete '/tasks/:id' do
     task = Task[params[:id]]
     halt 404, "Task not found" unless task

     task.destroy
     redirect '/tasks'
   end

   # Toggle task completion
   post '/tasks/:id/toggle' do
     task = Task[params[:id]]
     halt 404, "Task not found" unless task

     task.toggle_completion!
     redirect '/tasks'
   end
   ```

### ✅ Checkpoint
- [ ] Can edit tasks
- [ ] Can delete tasks
- [ ] Can toggle completion
- [ ] All redirects work

---

## Step 7: Add Flash Messages (20 min)

### 🎯 Goal
Show success/error messages to users.

### 📝 Tasks

1. **Enable sessions** in app.rb:
   ```ruby
   require 'sinatra'
   require 'sequel'

   # Enable sessions for flash messages
   enable :sessions
   set :session_secret, ENV.fetch('SESSION_SECRET', 'super_secret_key_change_in_production')

   use Rack::MethodOverride

   # ... rest of code
   ```

2. **Create helper methods** (`lib/helpers.rb`):
   ```ruby
   module Sinatra
     module FlashHelper
       def flash
         @flash ||= session.delete(:flash) || {}
       end

       def set_flash(type, message)
         session[:flash] = { type => message }
       end
     end

     helpers FlashHelper
   end
   ```

3. **Load helpers in app.rb**:
   ```ruby
   # ... after DB setup
   require_relative 'lib/models'
   require_relative 'lib/helpers'
   ```

4. **Add flash display to layout** (`views/layout.erb`):
   ```erb
   <main class="container">
     <% if flash[:success] %>
       <div class="alert alert-success"><%= flash[:success] %></div>
     <% end %>
     <% if flash[:error] %>
       <div class="alert alert-error"><%= flash[:error] %></div>
     <% end %>

     <%= yield %>
   </main>
   ```

5. **Add flash CSS**:
   ```css
   .alert {
     padding: 1rem;
     margin-bottom: 1rem;
     border-radius: 4px;
   }

   .alert-success {
     background: #d4edda;
     color: #155724;
     border: 1px solid #c3e6cb;
   }

   .alert-error {
     background: #f8d7da;
     color: #721c24;
     border: 1px solid #f5c6cb;
   }
   ```

6. **Update routes to use flash**:
   ```ruby
   post '/tasks' do
     task = Task.new(
       title: params[:title],
       description: params[:description],
       category_id: params[:category_id].empty? ? nil : params[:category_id]
     )

     if task.valid?
       task.save
       set_flash(:success, 'Task created successfully!')
       redirect '/tasks'
     else
       set_flash(:error, task.errors.full_messages.join(', '))
       @categories = Category.all
       erb :new
     end
   end

   put '/tasks/:id' do
     task = Task[params[:id]]
     halt 404, "Task not found" unless task

     task.update(
       title: params[:title],
       description: params[:description],
       category_id: params[:category_id].empty? ? nil : params[:category_id]
     )

     set_flash(:success, 'Task updated successfully!')
     redirect '/tasks'
   end

   delete '/tasks/:id' do
     task = Task[params[:id]]
     halt 404, "Task not found" unless task

     task.destroy
     set_flash(:success, 'Task deleted successfully!')
     redirect '/tasks'
   end
   ```

### ✅ Checkpoint
- [ ] Flash messages display
- [ ] Success messages show in green
- [ ] Error messages show in red
- [ ] Messages disappear after refresh

---

## Step 8: Add Filtering (20 min)

### 🎯 Goal
Filter tasks by category and completion status.

### 📝 Tasks

1. **Add filter links to index** (`views/index.erb`):
   ```erb
   <div class="filters">
     <a href="/tasks" class="filter-link <%= 'active' unless params[:filter] %>">All</a>
     <a href="/tasks?filter=active" class="filter-link <%= 'active' if params[:filter] == 'active' %>">Active</a>
     <a href="/tasks?filter=completed" class="filter-link <%= 'active' if params[:filter] == 'completed' %>">Completed</a>

     <span class="divider">|</span>

     <% @categories.each do |category| %>
       <a href="/tasks?category=<%= category.id %>"
          class="filter-link <%= 'active' if params[:category] == category.id.to_s %>">
         <%= category.name %>
       </a>
     <% end %>
   </div>

   <!-- rest of template -->
   ```

2. **Add filter CSS**:
   ```css
   .filters {
     background: white;
     padding: 1rem;
     border-radius: 8px;
     margin-bottom: 1rem;
     box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   }

   .filter-link {
     padding: 0.5rem 1rem;
     margin-right: 0.5rem;
     text-decoration: none;
     color: #333;
     border-radius: 4px;
     display: inline-block;
   }

   .filter-link:hover {
     background: #f5f5f5;
   }

   .filter-link.active {
     background: #4CAF50;
     color: white;
   }

   .divider {
     color: #ddd;
     margin: 0 0.5rem;
   }
   ```

3. **Update index route with filtering**:
   ```ruby
   get '/tasks' do
     @categories = Category.all
     @tasks = Task.order(Sequel.desc(:created_at))

     # Filter by completion status
     if params[:filter] == 'active'
       @tasks = @tasks.where(completed: false)
     elsif params[:filter] == 'completed'
       @tasks = @tasks.where(completed: true)
     end

     # Filter by category
     if params[:category]
       @tasks = @tasks.where(category_id: params[:category])
     end

     @tasks = @tasks.all
     erb :index
   end
   ```

### ✅ Checkpoint
- [ ] Can filter by status (all/active/completed)
- [ ] Can filter by category
- [ ] Active filter is highlighted
- [ ] Filters work correctly

---

## 🎉 Completion!

Congratulations! You've built a complete todo application with:

✅ Database integration
✅ CRUD operations
✅ Form handling and validation
✅ Flash messages
✅ Filtering and sorting
✅ Nice UI with CSS

### 🎯 Next Steps

Try these enhancements:
1. Add due dates and overdue indicators
2. Implement task priority levels
3. Add search functionality
4. Export tasks to JSON
5. Add user authentication

### 📚 What You Learned

- Sinatra routing and request handling
- Sequel ORM for database operations
- ERB templates and layouts
- Form handling and validation
- Session management
- RESTful route design
- CSS styling

**Ready for more?** Continue to [Lab 2: Blog API](../2-blog-api/README.md)!
