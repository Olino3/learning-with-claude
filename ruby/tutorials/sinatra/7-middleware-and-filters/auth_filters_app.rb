require 'sinatra'
require 'sinatra/reloader' if development?
require 'bcrypt'
require 'securerandom'
require 'logger'

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)
set :session_timeout, 1800  # 30 minutes

# Audit logger
configure do
  set :audit_logger, Logger.new(File.join(Dir.pwd, 'audit.log'))
end

# Simulated database
USERS = {
  'admin' => {
    username: 'admin',
    password_hash: BCrypt::Password.create('admin123'),
    role: 'admin',
    email: 'admin@example.com'
  },
  'moderator' => {
    username: 'moderator',
    password_hash: BCrypt::Password.create('mod123'),
    role: 'moderator',
    email: 'mod@example.com'
  },
  'user' => {
    username: 'user',
    password_hash: BCrypt::Password.create('user123'),
    role: 'user',
    email: 'user@example.com'
  }
}

helpers do
  def current_user
    @current_user ||= USERS[session[:username]] if session[:username]
  end

  def authenticated?
    !!current_user
  end

  def has_role?(*roles)
    authenticated? && roles.include?(current_user[:role])
  end

  def audit_log(action, details = {})
    info = {
      timestamp: Time.now,
      user: current_user ? current_user[:username] : 'anonymous',
      ip: request.ip,
      action: action
    }.merge(details)

    settings.audit_logger.info(info.inspect)
  end

  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end
end

# === FILTERS ===

# Log all requests
before do
  puts "[#{Time.now}] #{request.request_method} #{request.path} from #{request.ip}"
end

# Set start time for performance monitoring
before do
  @request_start_time = Time.now
end

# Check session timeout for authenticated users
before do
  next unless authenticated?

  if session[:last_activity]
    elapsed = Time.now - session[:last_activity]
    if elapsed > settings.session_timeout
      session.clear
      flash(:warning, 'Session expired. Please login again.')
      redirect '/login'
    end
  end

  session[:last_activity] = Time.now
end

# Require authentication for protected routes
before '/dashboard', '/profile', '/admin/*', '/moderator/*' do
  unless authenticated?
    session[:return_to] = request.path
    flash(:error, 'Please login to continue')
    redirect '/login'
  end
end

# Require admin role
before '/admin/*' do
  unless has_role?('admin')
    audit_log('unauthorized_access_attempt', path: request.path)
    halt 403, erb(:forbidden)
  end
end

# Require admin or moderator role
before '/moderator/*' do
  unless has_role?('admin', 'moderator')
    audit_log('unauthorized_access_attempt', path: request.path)
    halt 403, erb(:forbidden)
  end
end

# Log response time
after do
  elapsed = Time.now - @request_start_time
  puts "[#{Time.now}] Completed in #{(elapsed * 1000).round(2)}ms"

  # Add performance header
  response.headers['X-Response-Time'] = "#{(elapsed * 1000).round(2)}ms"
end

# Add security headers
after do
  response.headers['X-Frame-Options'] = 'DENY'
  response.headers['X-Content-Type-Options'] = 'nosniff'
  response.headers['X-XSS-Protection'] = '1; mode=block'
end

# === ROUTES ===

get '/' do
  erb :home
end

get '/login' do
  redirect '/dashboard' if authenticated?
  erb :login
end

post '/login' do
  username = params[:username]
  password = params[:password]

  user = USERS[username]

  if user && BCrypt::Password.new(user[:password_hash]) == password
    session[:username] = username
    session[:last_activity] = Time.now
    session[:login_time] = Time.now

    audit_log('login_success', username: username)

    flash(:success, "Welcome back, #{username}!")
    return_to = session.delete(:return_to) || '/dashboard'
    redirect return_to
  else
    audit_log('login_failure', username: username)
    @error = 'Invalid credentials'
    erb :login
  end
end

post '/logout' do
  audit_log('logout', username: current_user[:username]) if authenticated?
  session.clear
  flash(:success, 'Logged out successfully')
  redirect '/'
end

get '/dashboard' do
  audit_log('view_dashboard')
  erb :dashboard
end

get '/profile' do
  audit_log('view_profile')
  erb :profile
end

get '/admin/dashboard' do
  audit_log('view_admin_dashboard')
  @users = USERS
  erb :admin_dashboard
end

get '/admin/audit' do
  audit_log('view_audit_log')
  log_file = File.join(Dir.pwd, 'audit.log')

  if File.exist?(log_file)
    @log_entries = File.readlines(log_file).last(50).reverse
  else
    @log_entries = []
  end

  erb :audit_log
end

get '/moderator/dashboard' do
  audit_log('view_moderator_dashboard')
  erb :moderator_dashboard
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Auth Filters Demo</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
    }
    .card {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      margin-bottom: 1.5rem;
    }
    h1, h2 { color: #667eea; margin-bottom: 1rem; }
    .message {
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }
    .success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
    .error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
    .warning { background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; }
    .form-group { margin-bottom: 1.5rem; }
    label { display: block; margin-bottom: 0.5rem; font-weight: 600; color: #555; }
    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
    }
    .btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      text-decoration: none;
      font-weight: 600;
    }
    .btn-danger { background: #dc3545; }
    .info-box {
      background: #f8f9fa;
      padding: 1rem;
      border-radius: 5px;
      margin: 1rem 0;
    }
    .role-badge {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      border-radius: 15px;
      font-size: 0.875rem;
      font-weight: 600;
    }
    .role-admin { background: #ff4757; color: white; }
    .role-moderator { background: #ffa502; color: white; }
    .role-user { background: #1e90ff; color: white; }
    nav {
      background: rgba(255,255,255,0.95);
      padding: 1rem;
      border-radius: 10px;
      margin-bottom: 1.5rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    nav a {
      color: #667eea;
      text-decoration: none;
      margin: 0 0.5rem;
      font-weight: 600;
    }
    .log-entry {
      background: #f8f9fa;
      padding: 0.5rem;
      margin-bottom: 0.5rem;
      border-radius: 3px;
      font-family: monospace;
      font-size: 0.875rem;
    }
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #e0e0e0; }
    th { background: #667eea; color: white; }
  </style>
</head>
<body>
  <div class="container">
    <% if authenticated? %>
      <nav>
        <div>
          <a href="/dashboard">Dashboard</a>
          <a href="/profile">Profile</a>
          <% if has_role?('admin') %>
            <a href="/admin/dashboard">Admin</a>
            <a href="/admin/audit">Audit Log</a>
          <% end %>
          <% if has_role?('admin', 'moderator') %>
            <a href="/moderator/dashboard">Moderator</a>
          <% end %>
        </div>
        <div>
          <span><%= current_user[:username] %> (<span class="role-badge role-<%= current_user[:role] %>"><%= current_user[:role] %></span>)</span>
          <form action="/logout" method="post" style="display: inline; margin-left: 1rem;">
            <button type="submit" class="btn btn-danger" style="padding: 0.5rem 1rem;">Logout</button>
          </form>
        </div>
      </nav>
    <% end %>
    <%= yield %>
  </div>
</body>
</html>

@@home
<div class="card">
  <h1>🔒 Auth Filters Demo</h1>
  <% if success = get_flash(:success) %>
    <div class="message success"><%= success %></div>
  <% end %>

  <% if authenticated? %>
    <p>Welcome, <strong><%= current_user[:username] %></strong>!</p>
    <p style="margin-top: 1rem;">
      <a href="/dashboard" class="btn">Go to Dashboard</a>
    </p>
  <% else %>
    <p style="margin-bottom: 1rem;">Demo authentication system with role-based filters.</p>
    <a href="/login" class="btn">Login</a>

    <div class="info-box" style="margin-top: 2rem;">
      <h3>Test Accounts:</h3>
      <p><strong>Admin:</strong> admin / admin123</p>
      <p><strong>Moderator:</strong> moderator / mod123</p>
      <p><strong>User:</strong> user / user123</p>
    </div>
  <% end %>
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
      <label>Username</label>
      <input type="text" name="username" required autofocus>
    </div>
    <div class="form-group">
      <label>Password</label>
      <input type="password" name="password" required>
    </div>
    <button type="submit" class="btn">Login</button>
  </form>

  <div class="info-box" style="margin-top: 2rem;">
    <h3>Test Accounts:</h3>
    <p><strong>Admin:</strong> admin / admin123</p>
    <p><strong>Moderator:</strong> moderator / mod123</p>
    <p><strong>User:</strong> user / user123</p>
  </div>
</div>

@@dashboard
<div class="card">
  <h2>Dashboard</h2>
  <% if success = get_flash(:success) %>
    <div class="message success"><%= success %></div>
  <% end %>

  <div class="info-box">
    <p><strong>Username:</strong> <%= current_user[:username] %></p>
    <p><strong>Role:</strong> <span class="role-badge role-<%= current_user[:role] %>"><%= current_user[:role] %></span></p>
    <p><strong>Email:</strong> <%= current_user[:email] %></p>
    <p><strong>Session timeout:</strong> <%= settings.session_timeout / 60 %> minutes</p>
    <p><strong>Last activity:</strong> <%= Time.now - session[:last_activity] %> seconds ago</p>
  </div>

  <h3>Access Levels:</h3>
  <ul style="margin-left: 2rem;">
    <li>✅ Dashboard (all users)</li>
    <li>✅ Profile (all users)</li>
    <li><%= has_role?('admin', 'moderator') ? '✅' : '❌' %> Moderator Panel</li>
    <li><%= has_role?('admin') ? '✅' : '❌' %> Admin Panel</li>
    <li><%= has_role?('admin') ? '✅' : '❌' %> Audit Log</li>
  </ul>
</div>

@@profile
<div class="card">
  <h2>Profile</h2>
  <div class="info-box">
    <p><strong>Username:</strong> <%= current_user[:username] %></p>
    <p><strong>Email:</strong> <%= current_user[:email] %></p>
    <p><strong>Role:</strong> <span class="role-badge role-<%= current_user[:role] %>"><%= current_user[:role] %></span></p>
  </div>
</div>

@@admin_dashboard
<div class="card">
  <h2>🔐 Admin Dashboard</h2>
  <p>Only admins can access this page.</p>

  <h3 style="margin-top: 2rem;">All Users:</h3>
  <table>
    <tr>
      <th>Username</th>
      <th>Email</th>
      <th>Role</th>
    </tr>
    <% @users.each do |username, user| %>
      <tr>
        <td><%= user[:username] %></td>
        <td><%= user[:email] %></td>
        <td><span class="role-badge role-<%= user[:role] %>"><%= user[:role] %></span></td>
      </tr>
    <% end %>
  </table>
</div>

@@audit_log
<div class="card">
  <h2>📋 Audit Log</h2>
  <p>Recent activity (last 50 entries):</p>

  <div style="margin-top: 1rem;">
    <% if @log_entries.empty? %>
      <p style="color: #666;">No log entries yet.</p>
    <% else %>
      <% @log_entries.each do |entry| %>
        <div class="log-entry"><%= entry %></div>
      <% end %>
    <% end %>
  </div>
</div>

@@moderator_dashboard
<div class="card">
  <h2>🛡️ Moderator Dashboard</h2>
  <p>Accessible by admins and moderators.</p>

  <div class="info-box" style="margin-top: 1rem;">
    <p>You have moderator permissions. You can access moderation tools and view user reports.</p>
  </div>
</div>

@@forbidden
<div class="card">
  <h2 style="color: #dc3545;">403 - Forbidden</h2>
  <p>You don't have permission to access this page.</p>
  <p style="margin-top: 1rem;">
    <a href="/dashboard" class="btn">Back to Dashboard</a>
  </p>
</div>
