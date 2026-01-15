# Step 7: Remember Me Feature

[← Previous Step](../6/README.md) | [Next Step →](../8/README.md)

**Estimated Time**: 30 minutes

## 🎯 Goal
Add persistent "Remember Me" functionality using secure tokens.

## 📝 Tasks

### 1. Add remember_token to users table

Create `db/add_remember_token.rb`:
```ruby
require_relative '../config/database'

ActiveRecord::Base.connection.add_column :users, :remember_token, :string
ActiveRecord::Base.connection.add_index :users, :remember_token

puts "✓ Added remember_token column"
```

Run it:
```bash
ruby db/add_remember_token.rb
```

### 2. Update User model (lib/models/user.rb)

Add these methods to the User class:

```ruby
def create_remember_token
  self.remember_token = SecureRandom.urlsafe_base64
  save(validate: false)
end

def clear_remember_token
  self.remember_token = nil
  save(validate: false)
end

def self.find_by_remember_token(token)
  find_by(remember_token: token) if token.present?
end
```

### 3. Update login route to support "Remember Me"

Modify the POST /login route in app.rb:

```ruby
post '/login' do
  user = User.find_by(email: params[:email].downcase)

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    
    # Handle "Remember Me"
    if params[:remember_me]
      user.create_remember_token
      response.set_cookie('remember_token', {
        value: user.remember_token,
        expires: Time.now + (30 * 24 * 60 * 60), # 30 days
        httponly: true,
        secure: production?,
        same_site: :lax
      })
    end
    
    redirect '/dashboard'
  else
    @error = 'Invalid email or password'
    erb :login
  end
end
```

### 4. Update login form (views/login.erb)

Add checkbox after password field:

```erb
<div class="form-group">
  <label for="password">Password</label>
  <input type="password" id="password" name="password" required>
</div>

<div class="form-group checkbox">
  <label>
    <input type="checkbox" name="remember_me" value="1">
    Remember me for 30 days
  </label>
</div>

<button type="submit" class="btn btn-primary">Login</button>
```

Add CSS for checkbox:
```css
.form-group.checkbox label {
  display: flex;
  align-items: center;
  font-weight: normal;
}

.form-group.checkbox input[type="checkbox"] {
  width: auto;
  margin-right: 0.5rem;
}
```

### 5. Update auth helpers (lib/auth_helpers.rb)

Modify the `current_user` method to check for remember token:

```ruby
def current_user
  if @current_user
    @current_user
  elsif session[:user_id]
    @current_user = User.find_by(id: session[:user_id])
  elsif request.cookies['remember_token']
    user = User.find_by_remember_token(request.cookies['remember_token'])
    if user
      session[:user_id] = user.id
      @current_user = user
    end
  end
end
```

### 6. Update logout to clear remember token

Modify the GET /logout route:

```ruby
get '/logout' do
  if logged_in?
    current_user.clear_remember_token
  end
  
  response.delete_cookie('remember_token')
  session.clear
  redirect '/'
end
```

### 7. Add production? helper

Add this helper to app.rb or lib/auth_helpers.rb:

```ruby
def production?
  ENV['RACK_ENV'] == 'production'
end
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=3
```

Test "Remember Me":
- [ ] "Remember me" checkbox appears on login form
- [ ] Logging in with checkbox creates remember_token cookie
- [ ] Closing and reopening browser maintains login
- [ ] Cookie expires after 30 days (check expiration date)
- [ ] Logout clears the remember token
- [ ] Token is secure (httponly, secure in production)

## 💡 What You Learned

- Implementing persistent sessions with secure tokens
- Using SecureRandom for cryptographically secure tokens
- Setting secure cookie attributes (httponly, secure, same_site)
- Auto-login from cookies
- Token lifecycle management (create, validate, clear)
- Security best practices for "Remember Me" features

## 🎯 Tips

- Always use `SecureRandom.urlsafe_base64` for tokens, not regular random
- Set `httponly: true` to prevent JavaScript access
- Use `secure: true` in production for HTTPS-only cookies
- `same_site: :lax` prevents CSRF attacks
- Clear tokens on logout for security
- Store tokens hashed in production for extra security

---

[← Previous Step](../6/README.md) | [Next Step →](../8/README.md)
