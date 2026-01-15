# Step 5: Create Tasks

**Estimated Time:** 25 minutes

[← Previous Step](../4/README.md) | [Next Step →](../6/README.md)

---

## 🎯 Goal

Add a form to create new tasks with validation.

## 📝 Tasks

### 1. Create new task view (`views/new.erb`)

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

### 2. Add CSS for forms (add to `public/css/style.css`)

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

### 3. Add routes to app.rb

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

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] New task form displays
- [ ] Can create tasks successfully
- [ ] Validation works (try submitting with empty title)
- [ ] Redirects to task list after creation
- [ ] Can select a category from dropdown
- [ ] Created tasks appear in the task list

## 🎓 What You Learned

- Creating HTML forms in ERB
- Handling POST requests in Sinatra
- Form validation with Sequel models
- Accessing form parameters with `params`
- Redirecting after form submission
- Displaying error messages to users

## 🔍 Understanding Form Handling

```ruby
# Form submission flow:
1. User fills form → 2. POST /tasks → 3. Validate → 4. Save or show errors
```

## 💡 Tips

- Always validate user input on the server side
- Use `valid?` to check model validity before saving
- Empty strings from forms should be converted to `nil` for optional fields
- The `redirect` helper prevents form resubmission on refresh

---

[← Previous: List Tasks with Templates](../4/README.md) | [Next: Update & Delete Tasks →](../6/README.md)
