require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'rake'

# Database configuration
set :database, {
  adapter: 'sqlite3',
  database: 'tasks.db'
}

# Models
class Category < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

class Task < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true, length: { minimum: 3 }
  validates :category, presence: true

  scope :pending, -> { where(completed: false).order(created_at: :desc) }
  scope :completed, -> { where(completed: true).order(updated_at: :desc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }

  def toggle_complete!
    update(completed: !completed)
  end
end

# Create tables if they don't exist
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists? :categories
    create_table :categories do |t|
      t.string :name, null: false
      t.string :color, default: '#667eea'
      t.timestamps
    end
    add_index :categories, :name, unique: true
  end

  unless ActiveRecord::Base.connection.table_exists? :tasks
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.references :category, foreign_key: true
      t.boolean :completed, default: false
      t.date :due_date
      t.timestamps
    end
    add_index :tasks, :category_id
    add_index :tasks, :completed
  end
end

# Seed default categories if empty
if Category.count == 0
  Category.create([
    { name: 'Work', color: '#667eea' },
    { name: 'Personal', color: '#f093fb' },
    { name: 'Shopping', color: '#4facfe' },
    { name: 'Health', color: '#43e97b' }
  ])
end

enable :sessions

helpers do
  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end

  def format_date(date)
    return 'No due date' unless date
    date.strftime('%b %d, %Y')
  end

  def overdue?(task)
    task.due_date && task.due_date < Date.today && !task.completed
  end
end

# Home - show all tasks
get '/' do
  filter = params[:filter] || 'all'
  category_id = params[:category]

  @tasks = case filter
           when 'pending' then Task.pending
           when 'completed' then Task.completed
           else Task.order(created_at: :desc)
           end

  @tasks = @tasks.by_category(category_id) if category_id.present?

  @categories = Category.order(:name).all
  @selected_category = category_id
  @current_filter = filter
  @success = get_flash(:success)

  erb :index
end

# New task form
get '/tasks/new' do
  @task = Task.new
  @categories = Category.order(:name).all
  erb :new_task
end

# Create task
post '/tasks' do
  @task = Task.new(
    title: params[:title],
    description: params[:description],
    category_id: params[:category_id],
    due_date: params[:due_date].empty? ? nil : params[:due_date]
  )

  if @task.save
    flash(:success, 'Task created successfully!')
    redirect '/'
  else
    @categories = Category.order(:name).all
    @errors = @task.errors.full_messages
    erb :new_task
  end
end

# Edit task
get '/tasks/:id/edit' do
  @task = Task.find_by(id: params[:id])
  halt 404, erb(:not_found) unless @task

  @categories = Category.order(:name).all
  erb :edit_task
end

# Update task
post '/tasks/:id' do
  @task = Task.find_by(id: params[:id])
  halt 404, erb(:not_found) unless @task

  if @task.update(
    title: params[:title],
    description: params[:description],
    category_id: params[:category_id],
    due_date: params[:due_date].empty? ? nil : params[:due_date]
  )
    flash(:success, 'Task updated successfully!')
    redirect '/'
  else
    @categories = Category.order(:name).all
    @errors = @task.errors.full_messages
    erb :edit_task
  end
end

# Toggle task completion
post '/tasks/:id/toggle' do
  task = Task.find_by(id: params[:id])
  halt 404 unless task

  task.toggle_complete!
  redirect back
end

# Delete task
post '/tasks/:id/delete' do
  task = Task.find_by(id: params[:id])
  halt 404 unless task

  task.destroy
  flash(:success, 'Task deleted successfully!')
  redirect '/'
end

# Categories page
get '/categories' do
  @categories = Category.order(:name).all
  @success = get_flash(:success)
  erb :categories
end

# New category form
get '/categories/new' do
  @category = Category.new
  erb :new_category
end

# Create category
post '/categories' do
  @category = Category.new(
    name: params[:name],
    color: params[:color]
  )

  if @category.save
    flash(:success, 'Category created successfully!')
    redirect '/categories'
  else
    @errors = @category.errors.full_messages
    erb :new_category
  end
end

# Delete category
post '/categories/:id/delete' do
  category = Category.find_by(id: params[:id])
  halt 404 unless category

  category.destroy
  flash(:success, 'Category deleted successfully!')
  redirect '/categories'
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Task Manager</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }

    .container {
      max-width: 1000px;
      margin: 0 auto;
      background: white;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      overflow: hidden;
    }

    header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 2rem;
      text-align: center;
    }

    header h1 {
      font-size: 2rem;
      margin-bottom: 0.5rem;
    }

    nav {
      display: flex;
      gap: 1rem;
      justify-content: center;
      margin-top: 1rem;
    }

    nav a {
      color: white;
      text-decoration: none;
      padding: 0.5rem 1rem;
      background: rgba(255,255,255,0.2);
      border-radius: 5px;
      transition: background 0.2s;
    }

    nav a:hover {
      background: rgba(255,255,255,0.3);
    }

    .content {
      padding: 2rem;
    }

    .btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: transform 0.2s;
    }

    .btn:hover {
      transform: translateY(-2px);
    }

    .btn-small {
      padding: 0.5rem 1rem;
      font-size: 0.875rem;
    }

    .btn-danger {
      background: #dc3545;
    }

    .btn-success {
      background: #28a745;
    }

    .success {
      background: #d4edda;
      border: 1px solid #c3e6cb;
      color: #155724;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .filters {
      display: flex;
      gap: 1rem;
      margin-bottom: 1.5rem;
      flex-wrap: wrap;
      align-items: center;
    }

    .filters select {
      padding: 0.5rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
    }

    .task-list {
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }

    .task-card {
      border: 2px solid #e0e0e0;
      border-radius: 8px;
      padding: 1.5rem;
      transition: all 0.2s;
    }

    .task-card:hover {
      border-color: #667eea;
    }

    .task-card.completed {
      opacity: 0.6;
    }

    .task-card.overdue {
      border-color: #dc3545;
      background: #fff5f5;
    }

    .task-header {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 0.5rem;
    }

    .task-checkbox {
      width: 24px;
      height: 24px;
      cursor: pointer;
    }

    .task-title {
      flex: 1;
      font-size: 1.25rem;
      font-weight: 600;
    }

    .task-title.completed {
      text-decoration: line-through;
      color: #999;
    }

    .task-category {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      border-radius: 15px;
      font-size: 0.875rem;
      color: white;
    }

    .task-meta {
      color: #666;
      font-size: 0.875rem;
      margin-bottom: 0.5rem;
    }

    .task-description {
      color: #555;
      margin: 0.5rem 0 1rem 2.5rem;
    }

    .task-actions {
      display: flex;
      gap: 0.5rem;
      margin-left: 2.5rem;
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 600;
      color: #555;
    }

    input[type="text"],
    input[type="date"],
    input[type="color"],
    textarea,
    select {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
      font-family: inherit;
    }

    textarea {
      resize: vertical;
      min-height: 100px;
    }

    .errors {
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      color: #721c24;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .errors ul {
      margin-left: 1.5rem;
    }

    .empty-state {
      text-align: center;
      padding: 3rem;
      color: #999;
    }

    .stats {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
      margin-bottom: 2rem;
    }

    .stat-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 1.5rem;
      border-radius: 8px;
      text-align: center;
    }

    .stat-number {
      font-size: 2rem;
      font-weight: bold;
    }

    .category-list {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 1rem;
    }

    .category-card {
      border: 2px solid #e0e0e0;
      border-radius: 8px;
      padding: 1.5rem;
    }

    .category-color {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>✅ Task Manager</h1>
      <p>Built with ActiveRecord and Sinatra</p>
      <nav>
        <a href="/">Tasks</a>
        <a href="/categories">Categories</a>
      </nav>
    </header>

    <div class="content">
      <%= yield %>
    </div>
  </div>
</body>
</html>

@@index
<% if @success %>
  <div class="success"><%= @success %></div>
<% end %>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
  <h2>My Tasks</h2>
  <a href="/tasks/new" class="btn">+ New Task</a>
</div>

<div class="stats">
  <div class="stat-card">
    <div class="stat-number"><%= Task.count %></div>
    <div>Total Tasks</div>
  </div>
  <div class="stat-card">
    <div class="stat-number"><%= Task.pending.count %></div>
    <div>Pending</div>
  </div>
  <div class="stat-card">
    <div class="stat-number"><%= Task.completed.count %></div>
    <div>Completed</div>
  </div>
</div>

<form action="/" method="get" class="filters">
  <select name="filter" onchange="this.form.submit()">
    <option value="all" <%= 'selected' if @current_filter == 'all' %>>All Tasks</option>
    <option value="pending" <%= 'selected' if @current_filter == 'pending' %>>Pending</option>
    <option value="completed" <%= 'selected' if @current_filter == 'completed' %>>Completed</option>
  </select>

  <select name="category" onchange="this.form.submit()">
    <option value="">All Categories</option>
    <% @categories.each do |cat| %>
      <option value="<%= cat.id %>" <%= 'selected' if @selected_category == cat.id.to_s %>>
        <%= cat.name %>
      </option>
    <% end %>
  </select>
</form>

<% if @tasks.empty? %>
  <div class="empty-state">
    <h3>No tasks found</h3>
    <p>Create your first task to get started!</p>
  </div>
<% else %>
  <div class="task-list">
    <% @tasks.each do |task| %>
      <div class="task-card <%= 'completed' if task.completed %> <%= 'overdue' if overdue?(task) %>">
        <div class="task-header">
          <form action="/tasks/<%= task.id %>/toggle" method="post" style="display: inline;">
            <input type="checkbox" class="task-checkbox" <%= 'checked' if task.completed %>
                   onchange="this.form.submit()">
          </form>
          <div class="task-title <%= 'completed' if task.completed %>">
            <%= task.title %>
          </div>
          <span class="task-category" style="background: <%= task.category.color %>;">
            <%= task.category.name %>
          </span>
        </div>

        <div class="task-meta">
          Due: <%= format_date(task.due_date) %>
          <% if overdue?(task) %>
            <strong style="color: #dc3545;">OVERDUE</strong>
          <% end %>
        </div>

        <% if task.description && !task.description.empty? %>
          <div class="task-description">
            <%= task.description %>
          </div>
        <% end %>

        <div class="task-actions">
          <a href="/tasks/<%= task.id %>/edit" class="btn btn-small">Edit</a>
          <form action="/tasks/<%= task.id %>/delete" method="post" style="display: inline;"
                onsubmit="return confirm('Delete this task?')">
            <button type="submit" class="btn btn-small btn-danger">Delete</button>
          </form>
        </div>
      </div>
    <% end %>
  </div>
<% end %>

@@new_task
<h2>Create New Task</h2>

<% if @errors %>
  <div class="errors">
    <strong>Errors:</strong>
    <ul>
      <% @errors.each do |error| %>
        <li><%= error %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<form action="/tasks" method="post">
  <div class="form-group">
    <label for="title">Title *</label>
    <input type="text" id="title" name="title" value="<%= @task.title %>" required>
  </div>

  <div class="form-group">
    <label for="category_id">Category *</label>
    <select id="category_id" name="category_id" required>
      <option value="">Select a category</option>
      <% @categories.each do |cat| %>
        <option value="<%= cat.id %>" <%= 'selected' if @task.category_id == cat.id %>>
          <%= cat.name %>
        </option>
      <% end %>
    </select>
  </div>

  <div class="form-group">
    <label for="due_date">Due Date</label>
    <input type="date" id="due_date" name="due_date" value="<%= @task.due_date %>">
  </div>

  <div class="form-group">
    <label for="description">Description</label>
    <textarea id="description" name="description"><%= @task.description %></textarea>
  </div>

  <button type="submit" class="btn">Create Task</button>
  <a href="/" class="btn btn-danger">Cancel</a>
</form>

@@edit_task
<h2>Edit Task</h2>

<% if @errors %>
  <div class="errors">
    <strong>Errors:</strong>
    <ul>
      <% @errors.each do |error| %>
        <li><%= error %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<form action="/tasks/<%= @task.id %>" method="post">
  <div class="form-group">
    <label for="title">Title *</label>
    <input type="text" id="title" name="title" value="<%= @task.title %>" required>
  </div>

  <div class="form-group">
    <label for="category_id">Category *</label>
    <select id="category_id" name="category_id" required>
      <% @categories.each do |cat| %>
        <option value="<%= cat.id %>" <%= 'selected' if @task.category_id == cat.id %>>
          <%= cat.name %>
        </option>
      <% end %>
    </select>
  </div>

  <div class="form-group">
    <label for="due_date">Due Date</label>
    <input type="date" id="due_date" name="due_date" value="<%= @task.due_date %>">
  </div>

  <div class="form-group">
    <label for="description">Description</label>
    <textarea id="description" name="description"><%= @task.description %></textarea>
  </div>

  <button type="submit" class="btn">Update Task</button>
  <a href="/" class="btn btn-danger">Cancel</a>
</form>

@@categories
<% if @success %>
  <div class="success"><%= @success %></div>
<% end %>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
  <h2>Categories</h2>
  <a href="/categories/new" class="btn">+ New Category</a>
</div>

<div class="category-list">
  <% @categories.each do |category| %>
    <div class="category-card">
      <div class="category-color" style="background: <%= category.color %>;"></div>
      <h3><%= category.name %></h3>
      <p><%= category.tasks.count %> tasks</p>
      <div style="margin-top: 1rem;">
        <form action="/categories/<%= category.id %>/delete" method="post"
              onsubmit="return confirm('Delete category and all its tasks?')">
          <button type="submit" class="btn btn-small btn-danger">Delete</button>
        </form>
      </div>
    </div>
  <% end %>
</div>

@@new_category
<h2>Create New Category</h2>

<% if @errors %>
  <div class="errors">
    <strong>Errors:</strong>
    <ul>
      <% @errors.each do |error| %>
        <li><%= error %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<form action="/categories" method="post">
  <div class="form-group">
    <label for="name">Name *</label>
    <input type="text" id="name" name="name" value="<%= @category.name %>" required>
  </div>

  <div class="form-group">
    <label for="color">Color</label>
    <input type="color" id="color" name="color" value="<%= @category.color || '#667eea' %>">
  </div>

  <button type="submit" class="btn">Create Category</button>
  <a href="/categories" class="btn btn-danger">Cancel</a>
</form>

@@not_found
<div class="empty-state">
  <h2>404 - Not Found</h2>
  <a href="/" class="btn">Go Home</a>
</div>
