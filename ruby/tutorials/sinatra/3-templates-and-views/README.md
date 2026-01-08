# Tutorial 3: Templates and Views - Rendering Dynamic HTML

Learn how to use ERB templates to render dynamic HTML, work with layouts, and organize your views in Sinatra.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use ERB templates to generate HTML
- Pass data from routes to views
- Create layouts for consistent page structure
- Work with partials for reusable components
- Serve static files (CSS, JavaScript, images)
- Use template helpers for cleaner views

## 🐍➡️🔴 Coming from Flask/Jinja2

ERB is to Ruby what Jinja2 is to Python. The concepts are similar but the syntax differs:

| Feature | Flask/Jinja2 | Sinatra/ERB |
|---------|-------------|-------------|
| Render template | `render_template('page.html')` | `erb :page` |
| Variable output | `{{ name }}` | `<%= name %>` |
| Code execution | `{% if user %}` | `<% if @user %>` |
| Loop | `{% for item in items %}` | `<% @items.each do |item| %>` |
| Pass variables | `name=value` | `@name = value` (instance vars) |
| Layout | `{% extends 'base.html' %}` | `layout :layout_name` |
| Partial | `{% include 'partial.html' %}` | `erb :partial, layout: false` |

## 📝 ERB Basics

ERB (Embedded Ruby) lets you embed Ruby code in HTML templates.

### ERB Tags

```erb
<!-- Output (with HTML escaping) -->
<%= @name %>

<!-- Output (without HTML escaping - DANGEROUS!) -->
<%== @html_content %>

<!-- Execute Ruby code (no output) -->
<% if @user %>
  <p>Hello, <%= @user[:name] %>!</p>
<% end %>

<!-- Comments (not sent to client) -->
<%# This is an ERB comment %>
```

### Basic Example

**app.rb:**
```ruby
require 'sinatra'

get '/' do
  @title = 'Welcome'
  @message = 'Hello from Sinatra!'
  erb :index
end
```

**views/index.erb:**
```erb
<!DOCTYPE html>
<html>
<head>
  <title><%= @title %></title>
</head>
<body>
  <h1><%= @message %></h1>
  <p>The time is <%= Time.now %></p>
</body>
</html>
```

### 🐍 Flask/Jinja2 Comparison

**Flask:**
```python
from flask import render_template

@app.route('/')
def index():
    return render_template('index.html',
                         title='Welcome',
                         message='Hello from Flask!')
```

**Sinatra:**
```ruby
get '/' do
  @title = 'Welcome'
  @message = 'Hello from Sinatra!'
  erb :index
end
```

Key difference: Sinatra uses **instance variables** (`@var`) that are automatically available in templates.

## 🎨 Using Layouts

Layouts provide a consistent structure across pages:

**views/layout.erb:**
```erb
<!DOCTYPE html>
<html>
<head>
  <title><%= @title || 'My App' %></title>
  <link rel="stylesheet" href="/css/style.css">
</head>
<body>
  <header>
    <h1>My Sinatra App</h1>
    <nav>
      <a href="/">Home</a>
      <a href="/about">About</a>
    </nav>
  </header>

  <main>
    <%= yield %>  <%# Page content goes here %>
  </main>

  <footer>
    <p>&copy; 2024 My App</p>
  </footer>
</body>
</html>
```

**views/index.erb:**
```erb
<h2>Welcome!</h2>
<p>This content appears inside the layout.</p>
```

**app.rb:**
```ruby
get '/' do
  @title = 'Home'
  erb :index  # Automatically wrapped in layout.erb
end

get '/about' do
  @title = 'About'
  erb :about  # Also uses layout.erb
end
```

### Custom Layouts

```ruby
# Use different layout
get '/admin' do
  erb :admin_dashboard, layout: :admin_layout
end

# No layout
get '/api/data' do
  erb :data, layout: false
end
```

### 🐍 Flask Comparison

**Flask (Jinja2):**
```jinja2
{%extends "layout.html" %}

{% block content %}
  <h2>Welcome!</h2>
{% endblock %}
```

**Sinatra (ERB):**
```erb
<!-- layout.erb contains <%= yield %> -->
<!-- This file's content replaces yield -->
<h2>Welcome!</h2>
```

## 🔄 Control Flow in ERB

### Conditionals

```erb
<% if @user %>
  <p>Welcome back, <%= @user[:name] %>!</p>
<% else %>
  <p>Please log in</p>
<% end %>

<!-- Inline modifier -->
<p class="<%= 'admin' if @user[:admin] %>">
  <%= @user[:name] %>
</p>
```

### Loops

```erb
<ul>
  <% @users.each do |user| %>
    <li><%= user[:name] %> (<%= user[:email] %>)</li>
  <% end %>
</ul>

<!-- With index -->
<ol>
  <% @items.each_with_index do |item, index| %>
    <li>Item #<%= index + 1 %>: <%= item %></li>
  <% end %>
</ol>
```

### Case Statements

```erb
<% case @status %>
<% when 'active' %>
  <span class="badge green">Active</span>
<% when 'pending' %>
  <span class="badge yellow">Pending</span>
<% else %>
  <span class="badge red">Inactive</span>
<% end %>
```

## 📦 Partials

Partials are reusable template fragments:

**views/_user_card.erb:**
```erb
<div class="user-card">
  <h3><%= user[:name] %></h3>
  <p><%= user[:email] %></p>
  <p>Role: <%= user[:role] %></p>
</div>
```

**views/users.erb:**
```erb
<h1>All Users</h1>

<div class="user-grid">
  <% @users.each do |user| %>
    <%= erb :_user_card, layout: false, locals: { user: user } %>
  <% end %>
</div>
```

**app.rb:**
```ruby
get '/users' do
  @users = [
    { name: 'Alice', email: 'alice@example.com', role: 'Admin' },
    { name: 'Bob', email: 'bob@example.com', role: 'User' }
  ]
  erb :users
end
```

## 🎭 Template Helpers

Create helper methods for cleaner templates:

```ruby
helpers do
  def format_date(date)
    date.strftime('%B %d, %Y')
  end

  def current_user
    @current_user ||= { name: 'Guest', role: 'visitor' }
  end

  def admin?
    current_user[:role] == 'admin'
  end

  def link_to(text, url, options = {})
    css_class = options[:class] || ''
    "<a href='#{url}' class='#{css_class}'>#{text}</a>"
  end
end
```

**Use in templates:**
```erb
<p>Today is <%= format_date(Time.now) %></p>

<% if admin? %>
  <a href="/admin">Admin Panel</a>
<% end %>

<%= link_to('Home', '/', class: 'btn') %>
```

## 📁 Static Files

Sinatra serves files from the `public/` directory automatically:

```
your-app/
├── app.rb
├── views/
│   └── index.erb
└── public/
    ├── css/
    │   └── style.css
    ├── js/
    │   └── app.js
    └── images/
        └── logo.png
```

**In templates:**
```erb
<link rel="stylesheet" href="/css/style.css">
<script src="/js/app.js"></script>
<img src="/images/logo.png" alt="Logo">
```

**Configure public folder:**
```ruby
set :public_folder, 'public'  # Default
# or
set :public_folder, File.join(File.dirname(__FILE__), 'static')
```

## 🌐 Complete App Example

**app.rb:**
```ruby
require 'sinatra'

configure do
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :public_folder, File.join(File.dirname(__FILE__), 'public')
end

helpers do
  def page_title(title = nil)
    @title = title if title
    @title || 'My Sinatra App'
  end

  def active_link(path)
    request.path == path ? 'active' : ''
  end
end

get '/' do
  @title = 'Home'
  @posts = [
    { id: 1, title: 'First Post', excerpt: 'Welcome!' },
    { id: 2, title: 'Second Post', excerpt: 'More content' }
  ]
  erb :home
end

get '/posts/:id' do
  @post = {
    id: params[:id],
    title: 'Sample Post',
    content: 'This is the full post content.',
    author: 'Alice',
    date: Time.now
  }
  erb :post
end
```

## 📝 Forms in ERB

```erb
<form action="/users" method="post">
  <div>
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required>
  </div>

  <div>
    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>
  </div>

  <button type="submit">Create User</button>
</form>
```

**Handle the form:**
```ruby
post '/users' do
  @name = params[:name]
  @email = params[:email]

  # Save to database (next tutorial)

  erb :user_created
end
```

## ✍️ Exercises

### Exercise 1: Blog with Layout

Create a blog with:
- Layout with header, nav, footer
- Home page listing posts
- Individual post pages
- About page

**Solution:** [blog_app.rb](blog_app.rb)

### Exercise 2: User Dashboard

Build a user dashboard with:
- Partials for user cards
- Helper methods for formatting
- Conditional rendering based on user role

**Solution:** [dashboard_app.rb](dashboard_app.rb)

### Exercise 3: Product Catalog

Create a product catalog with:
- Grid layout of products
- Product detail pages
- Search functionality with results page

**Solution:** [catalog_app.rb](catalog_app.rb)

## 🎓 Key Concepts

1. **Instance Variables**: Use `@var` in routes, available in views
2. **ERB Tags**: `<%= %>` for output, `<% %>` for code
3. **Layouts**: Use `<%= yield %>` to insert page content
4. **Partials**: Reusable template components with `locals:`
5. **Helpers**: Methods available in all templates

## 🐞 Common Issues

### Issue 1: Variable Not Showing

**Problem:** `<%= @name %>` is blank

**Solution:** Set it as instance variable in route
```ruby
get '/' do
  @name = 'Alice'  # Must be @name, not just name
  erb :index
end
```

### Issue 2: Layout Not Applied

**Problem:** Page renders without layout

**Solution:** Ensure layout.erb exists in views/ and contains `<%= yield %>`

### Issue 3: Partial Not Found

**Problem:** `erb :_partial` fails

**Solution:** Partials need layout: false
```ruby
erb :_partial, layout: false, locals: { user: @user }
```

## 🔜 What's Next?

You now know:
- ✅ How to use ERB templates
- ✅ How to create layouts and partials
- ✅ How to pass data to views
- ✅ How to serve static files
- ✅ How to use template helpers

Next: Forms, user input, and data validation!

**Next:** [Tutorial 4: Forms and User Input](../4-forms-and-input/README.md)
