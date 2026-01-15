# Step 5: Login System

[← Previous Step](../4/README.md) | [Next Step →](../6/README.md)

**Estimated Time**: 25 minutes

## 🎯 Goal
Implement login/logout with sessions.

## 📝 Tasks

### 1. Create login view (views/login.erb)

```erb
<div class="form-container">
  <h2>Login</h2>

  <% if @error %>
    <div class="alert alert-error"><%= @error %></div>
  <% end %>

  <form method="post" action="/login">
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required>
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>
    </div>

    <button type="submit" class="btn btn-primary">Login</button>
    <p class="form-footer">
      Don't have an account? <a href="/register">Register</a>
    </p>
  </form>
</div>
```

### 2. Add login/logout routes to app.rb

```ruby
# Show login form
get '/login' do
  redirect '/dashboard' if session[:user_id]
  erb :login
end

# Handle login
post '/login' do
  user = User.find_by(email: params[:email].downcase)

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/dashboard'
  else
    @error = 'Invalid email or password'
    erb :login
  end
end

# Logout
get '/logout' do
  session.clear
  redirect '/'
end
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=3
```

Test the login system:
- [ ] Login form displays at http://localhost:4567/login
- [ ] Can login with registered user credentials
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to /dashboard (will create next)
- [ ] Logout clears session and redirects to home
- [ ] Already logged-in users are redirected from login page

## 💡 What You Learned

- Session-based authentication in Sinatra
- Secure password comparison with BCrypt's authenticate method
- Preventing timing attacks with constant-time comparison
- Login/logout flow and redirects
- Session management and clearing
- User-friendly error messages without revealing account existence

## 🎯 Tips

- Always downcase email for case-insensitive login
- Use generic error messages ("Invalid email or password") to prevent account enumeration
- Clear the entire session on logout for security
- Redirect already-logged-in users to prevent confusion
- The `user.authenticate` method uses BCrypt's secure comparison

---

[← Previous Step](../4/README.md) | [Next Step →](../6/README.md)
