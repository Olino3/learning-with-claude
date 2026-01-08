require 'sinatra'
require 'sinatra/reloader' if development?
require 'bcrypt'
require 'securerandom'

enable :sessions

configure do
  set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)
  set :session_timeout, 1800  # 30 minutes
end

# Simulated user database (use real database in production)
USERS = {}
REMEMBER_TOKENS = {}

helpers do
  # Session management
  def current_user
    @current_user ||= USERS[session[:user_id]] if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      session[:return_to] = request.path
      flash(:error, 'You must be logged in to access this page')
      redirect '/login'
    end
  end

  # Session timeout
  def check_session_timeout
    return unless logged_in?

    if session[:last_activity]
      elapsed = Time.now - session[:last_activity]
      if elapsed > settings.session_timeout
        session.clear
        flash(:warning, 'Your session has expired. Please login again.')
        redirect '/login'
      end
    end

    session[:last_activity] = Time.now
  end

  # Session regeneration (prevent session fixation)
  def regenerate_session
    old_session = session.dup
    session.clear
    old_session.each { |key, value| session[key] = value unless key == :last_activity }
  end

  # Flash messages
  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end

  # Authentication
  def authenticate(username, password)
    user = USERS.values.find { |u| u[:username] == username }
    return false unless user

    BCrypt::Password.new(user[:password_hash]) == password
  end

  def create_user(username, email, password)
    user_id = SecureRandom.uuid
    USERS[user_id] = {
      id: user_id,
      username: username,
      email: email,
      password_hash: BCrypt::Password.create(password),
      created_at: Time.now,
      last_login: nil
    }
    user_id
  end

  # Remember me functionality
  def generate_remember_token(user_id)
    token = SecureRandom.hex(32)
    REMEMBER_TOKENS[token] = {
      user_id: user_id,
      created_at: Time.now
    }
    token
  end

  def find_user_by_token(token)
    return nil unless REMEMBER_TOKENS[token]

    data = REMEMBER_TOKENS[token]

    # Token expires after 30 days
    if Time.now - data[:created_at] > 30 * 24 * 60 * 60
      REMEMBER_TOKENS.delete(token)
      return nil
    end

    data[:user_id]
  end

  def auto_login_from_cookie
    return if logged_in?

    token = request.cookies['remember_token']
    return unless token

    user_id = find_user_by_token(token)
    if user_id && USERS[user_id]
      session[:user_id] = user_id
      @current_user = USERS[user_id]
    else
      response.delete_cookie('remember_token')
    end
  end

  def clear_remember_token(token)
    REMEMBER_TOKENS.delete(token) if token
  end
end

# Check session timeout and auto-login before each request
before do
  auto_login_from_cookie
  check_session_timeout if logged_in?
end

# Public routes

get '/' do
  erb :home
end

get '/register' do
  redirect '/dashboard' if logged_in?
  erb :register
end

post '/register' do
  username = params[:username]
  email = params[:email]
  password = params[:password]
  password_confirm = params[:password_confirmation]

  # Validation
  errors = []
  errors << 'Username is required' if username.to_s.empty?
  errors << 'Username must be at least 3 characters' if username.to_s.length < 3
  errors << 'Email is required' if email.to_s.empty?
  errors << 'Password must be at least 8 characters' if password.to_s.length < 8
  errors << 'Passwords do not match' if password != password_confirm

  # Check if username already exists
  if USERS.values.any? { |u| u[:username] == username }
    errors << 'Username already taken'
  end

  if errors.any?
    @errors = errors
    @username = username
    @email = email
    return erb :register
  end

  # Create user
  user_id = create_user(username, email, password)
  session[:user_id] = user_id
  session[:last_activity] = Time.now

  flash(:success, "Welcome, #{username}! Your account has been created.")
  redirect '/dashboard'
end

get '/login' do
  redirect '/dashboard' if logged_in?
  erb :login
end

post '/login' do
  username = params[:username]
  password = params[:password]

  if authenticate(username, password)
    user = USERS.values.find { |u| u[:username] == username }

    regenerate_session  # Prevent session fixation
    session[:user_id] = user[:id]
    session[:last_activity] = Time.now

    # Update last login
    user[:last_login] = Time.now

    # Remember me functionality
    if params[:remember_me]
      token = generate_remember_token(user[:id])
      response.set_cookie('remember_token',
        value: token,
        max_age: 30 * 24 * 60 * 60,  # 30 days
        httponly: true,
        secure: production?,
        same_site: :strict
      )
    end

    flash(:success, "Welcome back, #{user[:username]}!")
    return_to = session.delete(:return_to) || '/dashboard'
    redirect return_to
  else
    @error = 'Invalid username or password'
    @username = username
    erb :login
  end
end

post '/logout' do
  # Clear remember token
  token = request.cookies['remember_token']
  clear_remember_token(token) if token
  response.delete_cookie('remember_token')

  # Clear session
  session.clear

  flash(:success, 'You have been logged out successfully')
  redirect '/'
end

# Protected routes

get '/dashboard' do
  require_login
  erb :dashboard
end

get '/profile' do
  require_login
  erb :profile
end

get '/settings' do
  require_login
  erb :settings
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Authentication System Demo</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }

    .container {
      max-width: 500px;
      margin: 0 auto;
    }

    .card {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      margin-bottom: 1.5rem;
    }

    h1, h2 {
      color: #667eea;
      margin-bottom: 1rem;
    }

    .message {
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .success {
      background: #d4edda;
      border: 1px solid #c3e6cb;
      color: #155724;
    }

    .error {
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      color: #721c24;
    }

    .warning {
      background: #fff3cd;
      border: 1px solid #ffeaa7;
      color: #856404;
    }

    .errors {
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .errors ul {
      margin-left: 1.5rem;
      color: #721c24;
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 600;
      color: #555;
    }

    input[type="text"],
    input[type="email"],
    input[type="password"] {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
    }

    input:focus {
      outline: none;
      border-color: #667eea;
    }

    .checkbox-group {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .checkbox-group input {
      width: auto;
    }

    .btn {
      display: inline-block;
      width: 100%;
      padding: 1rem;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      text-align: center;
    }

    .btn:hover {
      transform: translateY(-2px);
    }

    .btn-danger {
      background: #dc3545;
    }

    .text-center {
      text-align: center;
    }

    .user-info {
      background: #f8f9fa;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1rem;
    }

    .user-info p {
      margin-bottom: 0.5rem;
      color: #555;
    }

    .nav-links {
      display: flex;
      gap: 1rem;
      margin-top: 1rem;
    }

    .nav-links a {
      flex: 1;
      padding: 0.75rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      text-align: center;
      border-radius: 5px;
      font-weight: 600;
    }

    .session-info {
      background: #e3f2fd;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1rem;
      font-size: 0.875rem;
      color: #1565c0;
    }
  </style>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@home
<div class="card">
  <h1 class="text-center">🔐 Authentication System</h1>
  <p class="text-center" style="color: #666; margin-bottom: 2rem;">
    Secure session-based authentication with Sinatra
  </p>

  <% if success = get_flash(:success) %>
    <div class="message success"><%= success %></div>
  <% end %>

  <% if logged_in? %>
    <div class="user-info">
      <p><strong>Logged in as:</strong> <%= current_user[:username] %></p>
      <p><strong>Email:</strong> <%= current_user[:email] %></p>
    </div>

    <div class="nav-links">
      <a href="/dashboard">Dashboard</a>
      <a href="/profile">Profile</a>
      <a href="/settings">Settings</a>
    </div>

    <form action="/logout" method="post" style="margin-top: 1rem;">
      <button type="submit" class="btn btn-danger">Logout</button>
    </form>
  <% else %>
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
      <a href="/login" class="btn">Login</a>
      <a href="/register" class="btn">Register</a>
    </div>
  <% end %>
</div>

@@register
<div class="card">
  <h2>Create Account</h2>

  <% if @errors %>
    <div class="errors">
      <strong>Please fix the following errors:</strong>
      <ul>
        <% @errors.each do |error| %>
          <li><%= error %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <form action="/register" method="post">
    <div class="form-group">
      <label for="username">Username *</label>
      <input type="text" id="username" name="username" value="<%= @username %>" required>
    </div>

    <div class="form-group">
      <label for="email">Email *</label>
      <input type="email" id="email" name="email" value="<%= @email %>" required>
    </div>

    <div class="form-group">
      <label for="password">Password *</label>
      <input type="password" id="password" name="password" required>
      <small style="color: #666;">At least 8 characters</small>
    </div>

    <div class="form-group">
      <label for="password_confirmation">Confirm Password *</label>
      <input type="password" id="password_confirmation" name="password_confirmation" required>
    </div>

    <button type="submit" class="btn">Create Account</button>

    <p class="text-center" style="margin-top: 1rem;">
      Already have an account? <a href="/login">Login here</a>
    </p>
  </form>
</div>

@@login
<div class="card">
  <h2>Login</h2>

  <% if @error %>
    <div class="message error"><%= @error %></div>
  <% end %>

  <% if warning = get_flash(:warning) %>
    <div class="message warning"><%= warning %></div>
  <% end %>

  <% if error = get_flash(:error) %>
    <div class="message error"><%= error %></div>
  <% end %>

  <form action="/login" method="post">
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" value="<%= @username %>" required autofocus>
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>
    </div>

    <div class="form-group">
      <div class="checkbox-group">
        <input type="checkbox" id="remember_me" name="remember_me">
        <label for="remember_me" style="margin-bottom: 0;">Remember me for 30 days</label>
      </div>
    </div>

    <button type="submit" class="btn">Login</button>

    <p class="text-center" style="margin-top: 1rem;">
      Don't have an account? <a href="/register">Register here</a>
    </p>
  </form>
</div>

@@dashboard
<div class="card">
  <h2>Dashboard</h2>

  <% if success = get_flash(:success) %>
    <div class="message success"><%= success %></div>
  <% end %>

  <div class="session-info">
    <strong>Session Information:</strong><br>
    Session ID: <%= session.id if session.respond_to?(:id) %><br>
    Last Activity: <%= Time.now - session[:last_activity] %> seconds ago<br>
    Session Timeout: <%= settings.session_timeout / 60 %> minutes
  </div>

  <div class="user-info">
    <p><strong>Username:</strong> <%= current_user[:username] %></p>
    <p><strong>Email:</strong> <%= current_user[:email] %></p>
    <p><strong>Account Created:</strong> <%= current_user[:created_at].strftime('%B %d, %Y') %></p>
    <% if current_user[:last_login] %>
      <p><strong>Last Login:</strong> <%= current_user[:last_login].strftime('%B %d, %Y at %I:%M %p') %></p>
    <% end %>
  </div>

  <div class="nav-links">
    <a href="/">Home</a>
    <a href="/profile">Profile</a>
    <a href="/settings">Settings</a>
  </div>

  <form action="/logout" method="post" style="margin-top: 1rem;">
    <button type="submit" class="btn btn-danger">Logout</button>
  </form>
</div>

@@profile
<div class="card">
  <h2>Profile</h2>

  <div class="user-info">
    <p><strong>Username:</strong> <%= current_user[:username] %></p>
    <p><strong>Email:</strong> <%= current_user[:email] %></p>
    <p><strong>Member Since:</strong> <%= current_user[:created_at].strftime('%B %d, %Y') %></p>
  </div>

  <p style="color: #666; margin-top: 1rem;">
    This is a protected page. Only authenticated users can see this.
  </p>

  <div class="nav-links">
    <a href="/dashboard">Dashboard</a>
    <a href="/settings">Settings</a>
  </div>
</div>

@@settings
<div class="card">
  <h2>Settings</h2>

  <h3 style="margin-bottom: 1rem; color: #333;">Security</h3>

  <div class="user-info">
    <p><strong>Session Timeout:</strong> <%= settings.session_timeout / 60 %> minutes</p>
    <p><strong>Remember Me:</strong> <%= request.cookies['remember_token'] ? 'Enabled' : 'Disabled' %></p>
  </div>

  <p style="color: #666; margin: 1rem 0;">
    Your session will automatically expire after <%= settings.session_timeout / 60 %> minutes of inactivity.
  </p>

  <div class="nav-links">
    <a href="/dashboard">Dashboard</a>
    <a href="/profile">Profile</a>
  </div>
</div>
