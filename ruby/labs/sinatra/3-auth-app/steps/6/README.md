# Step 6: Protected Routes and Helpers

[← Previous Step](../5/README.md) | [Next Step →](../7/README.md)

**Estimated Time**: 20 minutes

## 🎯 Goal
Add authentication helpers and protect routes.

## 📝 Tasks

### 1. Create auth helpers (lib/auth_helpers.rb)

```ruby
module Sinatra
  module AuthHelpers
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end

    def require_login
      unless logged_in?
        session[:return_to] = request.path_info
        redirect '/login'
      end
    end
  end

  helpers AuthHelpers
end
```

### 2. Load helpers in app.rb

```ruby
require 'sinatra'
require_relative 'config/database'
require_relative 'lib/models/user'
require_relative 'lib/auth_helpers'

# ... rest of code
```

### 3. Update navigation in views/layout.erb

Replace the navigation section:

```erb
<nav>
  <a href="/">Home</a>
  <% if logged_in? %>
    <a href="/dashboard">Dashboard</a>
    <a href="/logout">Logout</a>
    <span class="user-info">👤 <%= current_user.name %></span>
  <% else %>
    <a href="/login">Login</a>
    <a href="/register">Register</a>
  <% end %>
</nav>
```

Add CSS for user-info:
```css
.user-info {
  margin-left: auto;
  font-weight: 500;
}
```

### 4. Create dashboard (views/dashboard.erb)

```erb
<div class="dashboard">
  <h2>Welcome, <%= current_user.name %>!</h2>

  <div class="user-card">
    <h3>Your Profile</h3>
    <p><strong>Name:</strong> <%= current_user.name %></p>
    <p><strong>Email:</strong> <%= current_user.email %></p>
    <p><strong>Member since:</strong> <%= current_user.created_at.strftime('%B %d, %Y') %></p>

    <a href="/profile/edit" class="btn">Edit Profile</a>
  </div>
</div>
```

Add dashboard CSS to public/css/style.css:
```css
.dashboard {
  max-width: 600px;
  margin: 2rem auto;
}

.user-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-top: 1.5rem;
}

.user-card p {
  margin: 0.75rem 0;
}

.user-card .btn {
  margin-top: 1.5rem;
  width: auto;
  display: inline-block;
  padding: 0.5rem 1.5rem;
}
```

### 5. Add dashboard route to app.rb

```ruby
get '/dashboard' do
  require_login
  erb :dashboard
end
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=3
```

Test authentication:
- [ ] Dashboard requires login (try accessing while logged out)
- [ ] After login, redirected to dashboard
- [ ] Navigation shows correct links based on auth state
- [ ] User name appears in navigation when logged in
- [ ] Dashboard displays user information correctly
- [ ] Logout returns to home page

## 💡 What You Learned

- Creating reusable authentication helpers
- Implementing authorization with `require_login`
- Using helper methods in views (`current_user`, `logged_in?`)
- Conditional navigation based on authentication state
- Protecting routes from unauthorized access
- Storing return URLs for post-login redirects

## 🎯 Tips

- `!!` converts truthy/falsy to true/false boolean
- Memoization (`||=`) prevents repeated database queries
- `require_login` is a before filter alternative
- Store `return_to` for better UX after login
- Use helpers to keep views clean and DRY

---

[← Previous Step](../5/README.md) | [Next Step →](../7/README.md)
