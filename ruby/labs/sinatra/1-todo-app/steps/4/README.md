# Step 4: List Tasks with Templates

**Estimated Time:** 30 minutes

[← Previous Step](../3/README.md) | [Next Step →](../5/README.md)

---

## 🎯 Goal

Display tasks in a nice HTML template using ERB.

## 📝 Tasks

### 1. Create views directory

```bash
mkdir -p views
```

### 2. Create layout template (`views/layout.erb`)

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

### 3. Create index view (`views/index.erb`)

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

### 4. Update app.rb to render template

Update the `/tasks` route:

```ruby
get '/tasks' do
  @tasks = Task.order(Sequel.desc(:created_at)).all
  erb :index
end
```

### 5. Create basic CSS (`public/css/style.css`)

First, create the directory:

```bash
mkdir -p public/css
```

Then create the CSS file:

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

.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}

.btn-danger {
  background: #f44336;
}

.btn-danger:hover {
  background: #da190b;
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

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Tasks display in a list
- [ ] Page is styled nicely with CSS
- [ ] Layout template works (header and footer appear)
- [ ] Empty state shows when no tasks exist
- [ ] Category badges display with correct colors

## 🎓 What You Learned

- Creating ERB templates in Sinatra
- Using layout files with `yield`
- Passing instance variables to views
- Conditional rendering in ERB
- Serving static CSS files
- Creating responsive layouts

## 💡 Tips

- The `public/` directory is automatically served by Sinatra
- ERB tags: `<%= %>` for output, `<% %>` for logic
- Layout files wrap all views with `yield`

---

[← Previous: Create Models](../3/README.md) | [Next: Create Tasks →](../5/README.md)
