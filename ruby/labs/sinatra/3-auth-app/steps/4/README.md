# Step 4: Registration with BCrypt

[← Previous Step](../3/README.md) | [Next Step →](../5/README.md)

**Estimated Time**: 30 minutes

## 🎯 Goal
Add user registration with secure password hashing.

## 📝 Tasks

### 1. Install BCrypt

```bash
gem install bcrypt
```

### 2. Update User model (lib/models/user.rb)

```ruby
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :password

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  before_save :downcase_email
  before_save :hash_password, if: :password_present?

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  private

  def downcase_email
    self.email = email.downcase if email
  end

  def password_required?
    password_digest.blank?
  end

  def password_present?
    password.present?
  end

  def hash_password
    self.password_digest = BCrypt::Password.create(password)
  end
end
```

### 3. Create registration view (views/register.erb)

```erb
<div class="form-container">
  <h2>Register</h2>

  <% if @error %>
    <div class="alert alert-error"><%= @error %></div>
  <% end %>

  <form method="post" action="/register">
    <div class="form-group">
      <label for="name">Name</label>
      <input type="text" id="name" name="name" required
             value="<%= params[:name] %>">
    </div>

    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required
             value="<%= params[:email] %>">
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required
             minlength="6">
    </div>

    <div class="form-group">
      <label for="password_confirmation">Confirm Password</label>
      <input type="password" id="password_confirmation"
             name="password_confirmation" required minlength="6">
    </div>

    <button type="submit" class="btn btn-primary">Register</button>
    <p class="form-footer">
      Already have an account? <a href="/login">Login</a>
    </p>
  </form>
</div>
```

### 4. Add registration routes to app.rb

```ruby
# Show registration form
get '/register' do
  erb :register
end

# Handle registration
post '/register' do
  if params[:password] != params[:password_confirmation]
    @error = "Passwords don't match"
    return erb :register
  end

  user = User.new(
    name: params[:name],
    email: params[:email],
    password: params[:password]
  )

  if user.save
    session[:user_id] = user.id
    redirect '/dashboard'
  else
    @error = user.errors.full_messages.join(', ')
    erb :register
  end
end
```

### 5. Add form CSS to public/css/style.css

```css
.form-container {
  max-width: 400px;
  margin: 2rem auto;
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.form-group input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.btn {
  width: 100%;
  padding: 0.75rem;
  background: #2c3e50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn:hover {
  background: #34495e;
}

.form-footer {
  text-align: center;
  margin-top: 1rem;
}

.alert {
  padding: 1rem;
  margin-bottom: 1rem;
  border-radius: 4px;
}

.alert-error {
  background: #f8d7da;
  color: #721c24;
}
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=3
```

Test registration at http://localhost:4567/register:
- [ ] Registration form displays correctly
- [ ] Password confirmation works
- [ ] Passwords under 6 characters are rejected
- [ ] Duplicate emails are rejected
- [ ] Invalid email formats are rejected
- [ ] Passwords are hashed with BCrypt (not stored in plain text)
- [ ] User is automatically logged in after registration

## 💡 What You Learned

- Implementing secure password hashing with BCrypt
- Using `attr_accessor` for virtual password attribute
- Password confirmation validation
- Form error handling and display
- Automatic login after registration
- CSS styling for forms and alerts

## 🎯 Tips

- Never store passwords in plain text
- BCrypt automatically includes a salt for each password
- The `authenticate` method compares hashed passwords securely
- Use `password_required?` to only validate password on creation
- Show validation errors to help users fix form issues

---

[← Previous Step](../3/README.md) | [Next Step →](../5/README.md)
