# Step 8: Add Filtering

**Estimated Time:** 20 minutes

[← Previous Step](../7/README.md)

---

## 🎯 Goal

Filter tasks by category and completion status.

## 📝 Tasks

### 1. Add filter links to index (`views/index.erb`)

Add this at the top of the file, before the `header-actions` div:

```erb
<div class="filters">
  <a href="/tasks" class="filter-link <%= 'active' unless params[:filter] || params[:category] %>">All</a>
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

<div class="header-actions">
  <!-- existing content -->
</div>
```

### 2. Add filter CSS (add to `public/css/style.css`)

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

### 3. Update index route with filtering (in `app.rb`)

Replace the existing `get '/tasks'` route:

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

## ✅ Checkpoint

Before completing this lab, verify:

- [ ] Can filter by status (All/Active/Completed)
- [ ] Can filter by category (Work/Personal/Shopping)
- [ ] Active filter is highlighted
- [ ] Filters work correctly (show appropriate tasks)
- [ ] Can clear filters by clicking "All"

## 🎓 What You Learned

- Using query parameters for filtering
- Building dynamic database queries with Sequel
- Chaining query methods (where, order)
- Conditional CSS classes in ERB
- Creating a user-friendly filter interface

## 🔍 Query Building Pattern

```ruby
# Start with base query
@tasks = Task.order(...)

# Add conditions dynamically
@tasks = @tasks.where(completed: false) if condition

# Execute query
@tasks = @tasks.all
```

---

## 🎉 Congratulations!

You've completed the Todo App lab! You've built a full-featured application with:

✅ Database integration with SQLite and Sequel
✅ CRUD operations (Create, Read, Update, Delete)
✅ Form handling and validation
✅ Flash messages for user feedback
✅ Filtering and sorting
✅ Beautiful UI with CSS
✅ RESTful route design

### 🎯 Next Steps

**Try these enhancements:**
1. Add due dates and overdue indicators
2. Implement task priority levels
3. Add search functionality
4. Export tasks to JSON or CSV
5. Add user authentication

**Continue your learning:**

Ready for more advanced topics? Continue to **[Lab 2: Blog API →](../../2-blog-api/README.md)**

### 📚 What You've Mastered

- Sinatra routing and request handling
- Sequel ORM for database operations
- ERB templates and layouts
- Form handling and validation
- Session management
- RESTful route design
- CSS styling and responsive design

---

[← Previous: Add Flash Messages](../7/README.md)
