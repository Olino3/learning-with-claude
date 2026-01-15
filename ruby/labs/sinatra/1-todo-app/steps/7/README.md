# Step 7: Add Flash Messages

**Estimated Time:** 20 minutes

[← Previous Step](../6/README.md) | [Next Step →](../8/README.md)

---

## 🎯 Goal

Show success/error messages to users after actions.

## 📝 Tasks

### 1. Enable sessions in app.rb

Add this near the top of your `app.rb` file:

```ruby
require 'sinatra'
require 'sequel'

# Enable sessions for flash messages
enable :sessions
set :session_secret, ENV.fetch('SESSION_SECRET', 'super_secret_key_change_in_production')

use Rack::MethodOverride

# ... rest of code
```

### 2. Create helper methods (`lib/helpers.rb`)

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

### 3. Load helpers in app.rb

Add this after loading models:

```ruby
# ... after DB setup
require_relative 'lib/models'
require_relative 'lib/helpers'
```

### 4. Add flash display to layout (`views/layout.erb`)

Update the `<main>` section:

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

### 5. Add flash CSS (add to `public/css/style.css`)

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

### 6. Update routes to use flash

Update your POST, PUT, and DELETE routes:

```ruby
# Create task
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

# Update task
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

# Delete task
delete '/tasks/:id' do
  task = Task[params[:id]]
  halt 404, "Task not found" unless task

  task.destroy
  set_flash(:success, 'Task deleted successfully!')
  redirect '/tasks'
end

# Toggle completion
post '/tasks/:id/toggle' do
  task = Task[params[:id]]
  halt 404, "Task not found" unless task

  task.toggle_completion!
  set_flash(:success, "Task marked as #{task.completed ? 'completed' : 'active'}!")
  redirect '/tasks'
end
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Flash messages display after creating a task
- [ ] Success messages show in green
- [ ] Error messages show in red
- [ ] Messages disappear after page refresh
- [ ] Flash works for create, update, delete, and toggle actions

## 🎓 What You Learned

- Using sessions in Sinatra for storing temporary data
- Creating helper modules and mixing them into Sinatra
- Implementing the flash pattern for user feedback
- Storing and retrieving data across requests
- Auto-deleting flash messages after display

## 🔍 How Flash Messages Work

```ruby
# Flow:
1. Action performed → 2. Set flash in session → 3. Redirect → 
4. Display flash → 5. Delete from session
```

## 💡 Tips

- Flash messages are stored in the session and deleted after being read
- Always use flash with redirects, not with direct rendering
- The `session.delete(:flash)` ensures messages only show once
- Set different session secrets for development and production

---

[← Previous: Update & Delete Tasks](../6/README.md) | [Next: Add Filtering →](../8/README.md)
