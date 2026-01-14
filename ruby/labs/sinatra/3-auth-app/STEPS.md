# Progressive Building Guide: Authentication Web App

Build a secure web application with user authentication, sessions, and protected routes.

## 🎯 Overview

This guide breaks down the authentication app into 8 progressive steps:
1. **Basic Web App Setup** - Sinatra with views
2. **Add Database** - SQLite with ActiveRecord
3. **User Model** - User registration basics
4. **Password Security** - BCrypt hashing
5. **Login System** - Session-based authentication
6. **Protected Routes** - Authorization helpers
7. **Remember Me** - Persistent sessions
8. **User Profiles** - User dashboard and settings

**Estimated Time**: 3-4 hours

---

## Step 1: Basic Web App Setup (20 min)

### 🎯 Goal
Create a Sinatra web application with views and layout.

### 📝 Tasks

1. **Create app.rb**:
   ```ruby
   require 'sinatra'

   enable :sessions
   set :session_secret, ENV.fetch('SESSION_SECRET', 'change_this_in_production')

   get '/' do
     erb :home
   end
   ```

2. **Create layout** (`views/layout.erb`):
   ```erb
   <!DOCTYPE html>
   <html>
   <head>
     <title>Auth App</title>
     <meta charset="utf-8">
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <link rel="stylesheet" href="/css/style.css">
   </head>
   <body>
     <header>
       <div class="container">
         <h1>🔐 Auth App</h1>
         <nav>
           <a href="/">Home</a>
         </nav>
       </div>
     </header>

     <main class="container">
       <%= yield %>
     </main>
   </body>
   </html>
   ```

3. **Create home view** (`views/home.erb`):
   ```erb
   <div class="hero">
     <h2>Welcome to Auth App</h2>
     <p>A demonstration of secure authentication with Sinatra</p>
   </div>
   ```

4. **Add basic CSS** (`public/css/style.css`):
   ```css
   * {
     margin: 0;
     padding: 0;
     box-sizing: border-box;
   }

   body {
     font-family: -apple-system, sans-serif;
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
     background: #2c3e50;
     color: white;
     padding: 1rem 0;
   }

   header nav {
     margin-top: 1rem;
   }

   header nav a {
     color: white;
     margin-right: 1rem;
     text-decoration: none;
   }

   main {
     padding: 2rem 0;
   }

   .hero {
     background: white;
     padding: 3rem;
     border-radius: 8px;
     text-align: center;
     box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   }
   ```

### ✅ Checkpoint
- [ ] App runs and displays home page
- [ ] Layout and styling work
- [ ] Sessions are enabled

---

## Step 2: Add Database (20 min)

### 🎯 Goal
Set up SQLite database with ActiveRecord.

### 📝 Tasks

1. **Install gems**:
   ```bash
   gem install activerecord sqlite3
   ```

2. **Create database config** (`config/database.rb`):
   ```ruby
   require 'active_record'

   ActiveRecord::Base.establish_connection(
     adapter: 'sqlite3',
     database: 'auth_app.db'
   )
   ```

3. **Update app.rb**:
   ```ruby
   require 'sinatra'
   require_relative 'config/database'

   enable :sessions
   set :session_secret, ENV.fetch('SESSION_SECRET', 'change_this_in_production')

   # ... rest of code
   ```

### ✅ Checkpoint
- [ ] Database connection works
- [ ] auth_app.db file is created

---

## Step 3: User Model with Validations (25 min)

### 🎯 Goal
Create User model with email and name validation.

### 📝 Tasks

1. **Create User model** (`lib/models/user.rb`):
   ```ruby
   class User < ActiveRecord::Base
     validates :email, presence: true, uniqueness: true,
               format: { with: URI::MailTo::EMAIL_REGEXP }
     validates :name, presence: true, length: { minimum: 2, maximum: 50 }

     before_save :downcase_email

     private

     def downcase_email
       self.email = email.downcase if email
     end
   end
   ```

2. **Create users table**:
   ```ruby
   # Create db/migrate.rb
   require_relative '../config/database'

   ActiveRecord::Base.connection.create_table :users, force: true do |t|
     t.string :email, null: false
     t.string :password_digest, null: false
     t.string :name, null: false
     t.timestamps
   end

   ActiveRecord::Base.connection.add_index :users, :email, unique: true

   puts "✓ Users table created"
   ```

3. **Run migration**:
   ```bash
   ruby db/migrate.rb
   ```

4. **Load model in app.rb**:
   ```ruby
   require 'sinatra'
   require_relative 'config/database'
   require_relative 'lib/models/user'

   # ... rest of code
   ```

### ✅ Checkpoint
- [ ] Users table exists
- [ ] User model validates correctly

---

## Step 4: Registration with BCrypt (30 min)

### 🎯 Goal
Add user registration with secure password hashing.

### 📝 Tasks

1. **Install BCrypt**:
   ```bash
   gem install bcrypt
   ```

2. **Update User model** to include BCrypt:
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

3. **Create registration view** (`views/register.erb`):
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

4. **Add registration routes**:
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

5. **Add form CSS**:
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

### ✅ Checkpoint
- [ ] Registration form displays
- [ ] Password validation works
- [ ] Passwords are hashed with BCrypt
- [ ] User is logged in after registration

---

## Step 5: Login System (25 min)

### 🎯 Goal
Implement login/logout with sessions.

### 📝 Tasks

1. **Create login view** (`views/login.erb`):
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

2. **Add login/logout routes**:
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

### ✅ Checkpoint
- [ ] Login form works
- [ ] Authentication works correctly
- [ ] Logout clears session
- [ ] Redirects work properly

---

## Step 6: Protected Routes and Helpers (20 min)

### 🎯 Goal
Add authentication helpers and protect routes.

### 📝 Tasks

1. **Create auth helpers** (`lib/auth_helpers.rb`):
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

2. **Load helpers in app.rb**:
   ```ruby
   require 'sinatra'
   require_relative 'config/database'
   require_relative 'lib/models/user'
   require_relative 'lib/auth_helpers'

   # ... rest of code
   ```

3. **Update navigation in layout.erb**:
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

4. **Create dashboard** (`views/dashboard.erb`):
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

5. **Add dashboard route**:
   ```ruby
   get '/dashboard' do
     require_login
     erb :dashboard
   end
   ```

### ✅ Checkpoint
- [ ] Auth helpers work correctly
- [ ] Dashboard requires authentication
- [ ] Navigation changes based on auth state
- [ ] Redirect after login works

---

## Steps 7-8: Quick Summary

### Step 7: Remember Me
- Add remember_token to users table
- Create persistent cookie
- Auto-login from cookie

### Step 8: User Profiles
- Profile edit form
- Password change functionality
- Account deletion

See the complete application for full implementation!

---

## 🎉 Completion!

You've built a secure authentication system with:

✅ User registration
✅ BCrypt password hashing
✅ Session-based authentication
✅ Protected routes
✅ Login/logout functionality
✅ User dashboard

### 📚 What You Learned

- Secure authentication patterns
- BCrypt password hashing
- Session management
- Authorization helpers
- Form handling and validation
- CSRF protection basics

**Next:** [Lab 4: Real-Time Chat](../4-realtime-chat/README.md)
