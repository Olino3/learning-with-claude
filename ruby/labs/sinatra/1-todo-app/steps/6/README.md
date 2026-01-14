# Step 6: Update & Delete Tasks

**Estimated Time:** 25 minutes

[← Previous Step](../5/README.md) | [Next Step →](../7/README.md)

---

## 🎯 Goal

Add edit and delete functionality for tasks.

## 📝 Tasks

### 1. Enable method override in app.rb

Add this near the top of your `app.rb` file:

```ruby
require 'sinatra'
require 'sequel'

# Enable PUT and DELETE methods
use Rack::MethodOverride

# ... rest of code
```

### 2. Create edit view (`views/edit.erb`)

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

### 3. Add edit, update, and delete routes

Add these routes to your `app.rb`:

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

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Can edit tasks (click Edit button)
- [ ] Can delete tasks (click Delete button with confirmation)
- [ ] Can toggle completion status (click Complete/Undo button)
- [ ] All redirects work properly
- [ ] 404 error is shown for non-existent tasks

## 🎓 What You Learned

- Using `Rack::MethodOverride` for PUT and DELETE requests in HTML forms
- Implementing RESTful routes (GET, POST, PUT, DELETE)
- Finding records by ID with `Task[id]`
- Using `halt` to stop execution and return error codes
- Updating and deleting records with Sequel
- Pre-populating form fields with existing data

## 🔍 RESTful Routes Summary

```ruby
GET    /tasks/:id/edit    # Show edit form
PUT    /tasks/:id         # Update task
DELETE /tasks/:id         # Delete task
POST   /tasks/:id/toggle  # Custom action
```

## 💡 Tips

- `Rack::MethodOverride` allows HTML forms to use PUT/DELETE methods
- Always check if a record exists before operating on it
- Use `halt` to return HTTP status codes (404, 403, etc.)
- JavaScript `confirm()` prevents accidental deletions

---

[← Previous: Create Tasks](../5/README.md) | [Next: Add Flash Messages →](../7/README.md)
