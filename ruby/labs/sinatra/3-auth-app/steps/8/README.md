# Step 8: User Profiles

[← Previous Step](../7/README.md)

**Estimated Time**: 35 minutes

## 🎯 Goal
Add profile editing, password changes, and account deletion.

## 📝 Tasks

### 1. Create profile edit view (views/profile_edit.erb)

```erb
<div class="form-container">
  <h2>Edit Profile</h2>

  <% if @success %>
    <div class="alert alert-success"><%= @success %></div>
  <% elsif @error %>
    <div class="alert alert-error"><%= @error %></div>
  <% end %>

  <form method="post" action="/profile/edit">
    <div class="form-group">
      <label for="name">Name</label>
      <input type="text" id="name" name="name" required
             value="<%= current_user.name %>">
    </div>

    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required
             value="<%= current_user.email %>">
    </div>

    <button type="submit" class="btn btn-primary">Update Profile</button>
  </form>

  <hr style="margin: 2rem 0;">

  <h3>Change Password</h3>
  <form method="post" action="/profile/password">
    <div class="form-group">
      <label for="current_password">Current Password</label>
      <input type="password" id="current_password" 
             name="current_password" required>
    </div>

    <div class="form-group">
      <label for="new_password">New Password</label>
      <input type="password" id="new_password" 
             name="new_password" required minlength="6">
    </div>

    <div class="form-group">
      <label for="password_confirmation">Confirm New Password</label>
      <input type="password" id="password_confirmation"
             name="password_confirmation" required minlength="6">
    </div>

    <button type="submit" class="btn btn-primary">Change Password</button>
  </form>

  <hr style="margin: 2rem 0;">

  <h3>Danger Zone</h3>
  <p>Deleting your account is permanent and cannot be undone.</p>
  <form method="post" action="/profile/delete" 
        onsubmit="return confirm('Are you sure? This cannot be undone!');">
    <button type="submit" class="btn btn-danger">Delete Account</button>
  </form>
</div>
```

Add CSS for success alerts and danger button:
```css
.alert-success {
  background: #d4edda;
  color: #155724;
}

.btn-danger {
  background: #dc3545;
}

.btn-danger:hover {
  background: #c82333;
}
```

### 2. Add profile routes to app.rb

```ruby
# Show profile edit form
get '/profile/edit' do
  require_login
  erb :profile_edit
end

# Update profile
post '/profile/edit' do
  require_login
  
  current_user.name = params[:name]
  current_user.email = params[:email]
  
  if current_user.save
    @success = 'Profile updated successfully!'
  else
    @error = current_user.errors.full_messages.join(', ')
  end
  
  erb :profile_edit
end

# Change password
post '/profile/password' do
  require_login
  
  unless current_user.authenticate(params[:current_password])
    @error = 'Current password is incorrect'
    return erb :profile_edit
  end
  
  if params[:new_password] != params[:password_confirmation]
    @error = "New passwords don't match"
    return erb :profile_edit
  end
  
  current_user.password = params[:new_password]
  if current_user.save
    @success = 'Password changed successfully!'
  else
    @error = current_user.errors.full_messages.join(', ')
  end
  
  erb :profile_edit
end

# Delete account
post '/profile/delete' do
  require_login
  
  current_user.destroy
  session.clear
  response.delete_cookie('remember_token')
  
  redirect '/'
end
```

### 3. Update dashboard view (views/dashboard.erb)

Update the edit profile link to work properly:

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

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=3
```

Test profile management:
- [ ] Can edit profile name and email
- [ ] Email validation prevents invalid formats
- [ ] Duplicate emails are rejected
- [ ] Current password required to change password
- [ ] New password must be at least 6 characters
- [ ] Password confirmation works correctly
- [ ] Account deletion works and clears session
- [ ] Success and error messages display properly

## 💡 What You Learned

- Building profile management interfaces
- Secure password change flows
- Account deletion with confirmation
- Form validation and user feedback
- Multiple forms on one page
- Protecting sensitive operations with current password
- Using JavaScript confirm for destructive actions

## 🎯 Tips

- Always require current password before changing to new password
- Use JavaScript confirm() for irreversible actions
- Clear all sessions and cookies when deleting account
- Provide clear success/error feedback for user actions
- Separate forms for different operations improve clarity
- Consider soft deletes instead of hard deletes in production

---

## 🎉 Completion!

You've built a complete authentication system with:

✅ User registration with BCrypt hashing  
✅ Session-based login/logout  
✅ Protected routes and authorization  
✅ "Remember Me" persistent sessions  
✅ Profile management  
✅ Password changes  
✅ Account deletion  

### 📚 What You Learned

- Complete authentication flow from registration to logout
- Secure password handling with BCrypt
- Session management and persistent cookies
- Authorization patterns and helpers
- Profile CRUD operations
- Security best practices for web applications

### 🚀 Next Steps

Continue building your Sinatra skills with real-time features:

**[Lab 4: Real-Time Chat →](../../4-realtime-chat/steps/1/README.md)**

Build a WebSocket-powered chat application with rooms and user presence!

---

[← Previous Step](../7/README.md)
