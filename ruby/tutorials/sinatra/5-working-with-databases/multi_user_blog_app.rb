require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require 'bcrypt'

# Database setup
DB = Sequel.connect('sqlite://multi_user_blog.db')

# Create tables
DB.create_table? :users do
  primary_key :id
  String :username, null: false, unique: true
  String :email, null: false, unique: true
  String :password_hash, null: false
  String :bio, text: true
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table? :posts do
  primary_key :id
  foreign_key :user_id, :users, null: false
  String :title, null: false
  String :body, text: true
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table? :comments do
  primary_key :id
  foreign_key :post_id, :posts, null: false
  foreign_key :user_id, :users, null: false
  String :body, text: true
  DateTime :created_at
end

# Models
class User < Sequel::Model
  one_to_many :posts
  one_to_many :comments

  def validate
    super
    errors.add(:username, 'cannot be empty') if !username || username.strip.empty?
    errors.add(:username, 'must be at least 3 characters') if username && username.length < 3
    errors.add(:email, 'cannot be empty') if !email || email.strip.empty?
    errors.add(:email, 'is invalid') if email && !email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end

  def before_create
    super
    self.created_at = Time.now
    self.updated_at = Time.now
  end

  def before_update
    super
    self.updated_at = Time.now
  end

  def password=(new_password)
    self.password_hash = BCrypt::Password.create(new_password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_hash) == password
  end
end

class Post < Sequel::Model
  many_to_one :user
  one_to_many :comments

  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.strip.empty?
    errors.add(:title, 'must be at least 5 characters') if title && title.length < 5
    errors.add(:body, 'cannot be empty') if !body || body.strip.empty?
    errors.add(:body, 'must be at least 20 characters') if body && body.length < 20
  end

  def before_create
    super
    self.created_at = Time.now
    self.updated_at = Time.now
  end

  def before_update
    super
    self.updated_at = Time.now
  end

  def excerpt(length = 200)
    body.length > length ? "#{body[0...length]}..." : body
  end

  def formatted_date
    created_at.strftime('%B %d, %Y')
  end
end

class Comment < Sequel::Model
  many_to_one :post
  many_to_one :user

  def validate
    super
    errors.add(:body, 'cannot be empty') if !body || body.strip.empty?
    errors.add(:body, 'must be at least 5 characters') if body && body.length < 5
  end

  def before_create
    super
    self.created_at = Time.now
  end

  def formatted_date
    created_at.strftime('%b %d at %I:%M %p')
  end
end

# Session and helpers
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'dev_secret_change_in_production'

helpers do
  def current_user
    @current_user ||= User[session[:user_id]] if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash(:error, 'You must be logged in to do that')
      redirect '/login'
    end
  end

  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end

  def format_text(text)
    text.to_s.gsub("\n", "<br>")
  end
end

# Home page
get '/' do
  @posts = Post.order(Sequel.desc(:created_at)).all
  @success = get_flash(:success)
  erb :index
end

# Register form
get '/register' do
  redirect '/' if logged_in?
  @user = User.new
  erb :register
end

# Register user
post '/register' do
  @user = User.new(
    username: params[:username],
    email: params[:email],
    bio: params[:bio]
  )
  @user.password = params[:password]

  if params[:password] != params[:password_confirmation]
    @errors = ['Passwords do not match']
    return erb :register
  end

  if @user.valid?
    @user.save
    session[:user_id] = @user.id
    flash(:success, "Welcome, #{@user.username}!")
    redirect '/'
  else
    @errors = @user.errors.full_messages
    erb :register
  end
end

# Login form
get '/login' do
  redirect '/' if logged_in?
  erb :login
end

# Login
post '/login' do
  user = User.find(username: params[:username])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    flash(:success, "Welcome back, #{user.username}!")
    redirect '/'
  else
    @error = 'Invalid username or password'
    erb :login
  end
end

# Logout
post '/logout' do
  session.clear
  flash(:success, 'You have been logged out')
  redirect '/'
end

# User profile
get '/users/:id' do
  @user = User[params[:id]]
  halt 404, erb(:not_found) unless @user
  @posts = @user.posts_dataset.order(Sequel.desc(:created_at)).all
  erb :user_profile
end

# New post form
get '/posts/new' do
  require_login
  @post = Post.new
  erb :new_post
end

# Create post
post '/posts' do
  require_login

  @post = Post.new(
    user_id: current_user.id,
    title: params[:title],
    body: params[:body]
  )

  if @post.valid?
    @post.save
    flash(:success, 'Post created successfully!')
    redirect "/posts/#{@post.id}"
  else
    @errors = @post.errors
    erb :new_post
  end
end

# Show post
get '/posts/:id' do
  @post = Post[params[:id]]
  halt 404, erb(:not_found) unless @post
  @comments = @post.comments_dataset.order(:created_at).all
  erb :show_post
end

# Edit post form
get '/posts/:id/edit' do
  require_login
  @post = Post[params[:id]]
  halt 404, erb(:not_found) unless @post
  halt 403, 'Not authorized' unless @post.user_id == current_user.id

  erb :edit_post
end

# Update post
post '/posts/:id' do
  require_login
  @post = Post[params[:id]]
  halt 404, erb(:not_found) unless @post
  halt 403, 'Not authorized' unless @post.user_id == current_user.id

  @post.set(
    title: params[:title],
    body: params[:body]
  )

  if @post.valid?
    @post.save
    flash(:success, 'Post updated successfully!')
    redirect "/posts/#{@post.id}"
  else
    @errors = @post.errors
    erb :edit_post
  end
end

# Delete post
post '/posts/:id/delete' do
  require_login
  post = Post[params[:id]]
  halt 404 unless post
  halt 403, 'Not authorized' unless post.user_id == current_user.id

  post.destroy
  flash(:success, 'Post deleted successfully!')
  redirect '/'
end

# Add comment
post '/posts/:id/comments' do
  require_login

  comment = Comment.new(
    post_id: params[:id],
    user_id: current_user.id,
    body: params[:body]
  )

  if comment.valid?
    comment.save
    flash(:success, 'Comment added!')
  else
    flash(:error, 'Comment must be at least 5 characters')
  end

  redirect "/posts/#{params[:id]}"
end

# Delete comment
post '/comments/:id/delete' do
  require_login
  comment = Comment[params[:id]]
  halt 404 unless comment
  halt 403, 'Not authorized' unless comment.user_id == current_user.id

  post_id = comment.post_id
  comment.destroy
  flash(:success, 'Comment deleted')
  redirect "/posts/#{post_id}"
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Multi-User Blog</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: #f8f9fa;
      line-height: 1.6;
      color: #333;
    }

    header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 1.5rem 0;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .header-content {
      max-width: 1000px;
      margin: 0 auto;
      padding: 0 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    header h1 {
      font-size: 1.75rem;
    }

    header a {
      color: white;
      text-decoration: none;
    }

    nav {
      display: flex;
      gap: 1.5rem;
      align-items: center;
    }

    .container {
      max-width: 1000px;
      margin: 2rem auto;
      padding: 0 2rem;
    }

    .btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: transform 0.2s;
    }

    .btn:hover {
      transform: translateY(-2px);
    }

    .btn-small {
      padding: 0.5rem 1rem;
      font-size: 0.875rem;
    }

    .btn-danger {
      background: #dc3545;
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

    .post-card {
      background: white;
      padding: 2rem;
      margin-bottom: 1.5rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .post-card h2 {
      color: #667eea;
      margin-bottom: 0.5rem;
    }

    .post-card h2 a {
      color: #667eea;
      text-decoration: none;
    }

    .post-meta {
      color: #666;
      font-size: 0.875rem;
      margin-bottom: 1rem;
    }

    .post-meta a {
      color: #667eea;
      text-decoration: none;
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
    input[type="password"],
    textarea {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
      font-family: inherit;
    }

    textarea {
      resize: vertical;
      min-height: 150px;
    }

    .errors {
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      color: #721c24;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .comment-section {
      margin-top: 2rem;
      padding-top: 2rem;
      border-top: 2px solid #e0e0e0;
    }

    .comment {
      background: #f8f9fa;
      padding: 1rem;
      margin-bottom: 1rem;
      border-radius: 5px;
    }

    .comment-meta {
      font-size: 0.875rem;
      color: #666;
      margin-bottom: 0.5rem;
    }

    .comment-meta a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
    }

    .user-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 2rem;
      border-radius: 10px;
      margin-bottom: 2rem;
    }

    .user-stats {
      display: flex;
      gap: 2rem;
      margin-top: 1rem;
    }
  </style>
</head>
<body>
  <header>
    <div class="header-content">
      <h1><a href="/">📝 Multi-User Blog</a></h1>
      <nav>
        <% if logged_in? %>
          <a href="/posts/new">Write Post</a>
          <a href="/users/<%= current_user.id %>">Profile</a>
          <form action="/logout" method="post" style="display: inline;">
            <button type="submit" class="btn btn-small">Logout</button>
          </form>
        <% else %>
          <a href="/register" class="btn btn-small">Register</a>
          <a href="/login" class="btn btn-small">Login</a>
        <% end %>
      </nav>
    </div>
  </header>

  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@index
<% if @success %>
  <div class="message success"><%= @success %></div>
<% end %>

<% if @posts.empty? %>
  <div class="post-card">
    <h2>No posts yet</h2>
    <p>Be the first to write a post!</p>
    <% if logged_in? %>
      <a href="/posts/new" class="btn" style="margin-top: 1rem;">Write First Post</a>
    <% end %>
  </div>
<% else %>
  <% @posts.each do |post| %>
    <div class="post-card">
      <h2><a href="/posts/<%= post.id %>"><%= post.title %></a></h2>
      <div class="post-meta">
        By <a href="/users/<%= post.user.id %>"><%= post.user.username %></a>
        on <%= post.formatted_date %> • <%= post.comments.count %> comments
      </div>
      <p><%= post.excerpt %></p>
      <a href="/posts/<%= post.id %>" class="btn btn-small">Read More</a>
    </div>
  <% end %>
<% end %>

@@register
<div class="post-card">
  <h2>Create Account</h2>

  <% if @errors %>
    <div class="errors">
      <strong>Errors:</strong>
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
      <input type="text" id="username" name="username" value="<%= @user.username %>" required>
    </div>

    <div class="form-group">
      <label for="email">Email *</label>
      <input type="email" id="email" name="email" value="<%= @user.email %>" required>
    </div>

    <div class="form-group">
      <label for="password">Password *</label>
      <input type="password" id="password" name="password" required>
    </div>

    <div class="form-group">
      <label for="password_confirmation">Confirm Password *</label>
      <input type="password" id="password_confirmation" name="password_confirmation" required>
    </div>

    <div class="form-group">
      <label for="bio">Bio (optional)</label>
      <textarea id="bio" name="bio"><%= @user.bio %></textarea>
    </div>

    <button type="submit" class="btn">Create Account</button>
    <p style="margin-top: 1rem;">
      Already have an account? <a href="/login">Login here</a>
    </p>
  </form>
</div>

@@login
<div class="post-card">
  <h2>Login</h2>

  <% if @error %>
    <div class="message error"><%= @error %></div>
  <% end %>

  <form action="/login" method="post">
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" required>
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>
    </div>

    <button type="submit" class="btn">Login</button>
    <p style="margin-top: 1rem;">
      Don't have an account? <a href="/register">Register here</a>
    </p>
  </form>
</div>

@@user_profile
<div class="user-header">
  <h1><%= @user.username %></h1>
  <% if @user.bio && !@user.bio.empty? %>
    <p><%= @user.bio %></p>
  <% end %>
  <div class="user-stats">
    <div><strong><%= @user.posts.count %></strong> posts</div>
    <div><strong><%= @user.comments.count %></strong> comments</div>
    <div>Joined <%= @user.created_at.strftime('%B %Y') %></div>
  </div>
</div>

<h2>Posts by <%= @user.username %></h2>

<% if @posts.empty? %>
  <div class="post-card">
    <p>No posts yet.</p>
  </div>
<% else %>
  <% @posts.each do |post| %>
    <div class="post-card">
      <h3><a href="/posts/<%= post.id %>"><%= post.title %></a></h3>
      <div class="post-meta">
        <%= post.formatted_date %> • <%= post.comments.count %> comments
      </div>
      <p><%= post.excerpt(150) %></p>
    </div>
  <% end %>
<% end %>

@@new_post
<div class="post-card">
  <h2>Write New Post</h2>

  <% if @errors %>
    <div class="errors">
      <strong>Errors:</strong>
      <ul>
        <% @errors.each do |field, messages| %>
          <% messages.each do |msg| %>
            <li><%= field.to_s.capitalize %>: <%= msg %></li>
          <% end %>
        <% end %>
      </ul>
    </div>
  <% end %>

  <form action="/posts" method="post">
    <div class="form-group">
      <label for="title">Title *</label>
      <input type="text" id="title" name="title" value="<%= @post.title %>" required>
    </div>

    <div class="form-group">
      <label for="body">Content *</label>
      <textarea id="body" name="body" required><%= @post.body %></textarea>
    </div>

    <button type="submit" class="btn">Publish Post</button>
    <a href="/" class="btn btn-danger">Cancel</a>
  </form>
</div>

@@edit_post
<div class="post-card">
  <h2>Edit Post</h2>

  <% if @errors %>
    <div class="errors">
      <strong>Errors:</strong>
      <ul>
        <% @errors.each do |field, messages| %>
          <% messages.each do |msg| %>
            <li><%= field.to_s.capitalize %>: <%= msg %></li>
          <% end %>
        <% end %>
      </ul>
    </div>
  <% end %>

  <form action="/posts/<%= @post.id %>" method="post">
    <div class="form-group">
      <label for="title">Title *</label>
      <input type="text" id="title" name="title" value="<%= @post.title %>" required>
    </div>

    <div class="form-group">
      <label for="body">Content *</label>
      <textarea id="body" name="body" required><%= @post.body %></textarea>
    </div>

    <button type="submit" class="btn">Update Post</button>
    <a href="/posts/<%= @post.id %>" class="btn btn-danger">Cancel</a>
  </form>
</div>

@@show_post
<% if success = get_flash(:success) %>
  <div class="message success"><%= success %></div>
<% end %>

<% if error = get_flash(:error) %>
  <div class="message error"><%= error %></div>
<% end %>

<div class="post-card">
  <h1><%= @post.title %></h1>
  <div class="post-meta">
    By <a href="/users/<%= @post.user.id %>"><%= @post.user.username %></a>
    on <%= @post.formatted_date %>
    <% if logged_in? && @post.user_id == current_user.id %>
      • <a href="/posts/<%= @post.id %>/edit">Edit</a>
    <% end %>
  </div>

  <div style="margin: 2rem 0; line-height: 1.8;">
    <%= format_text(@post.body) %>
  </div>

  <% if logged_in? && @post.user_id == current_user.id %>
    <form action="/posts/<%= @post.id %>/delete" method="post" style="display: inline;"
          onsubmit="return confirm('Delete this post?')">
      <button type="submit" class="btn btn-danger btn-small">Delete Post</button>
    </form>
  <% end %>

  <div class="comment-section">
    <h3><%= @comments.count %> Comments</h3>

    <% if logged_in? %>
      <form action="/posts/<%= @post.id %>/comments" method="post" style="margin: 1.5rem 0;">
        <div class="form-group">
          <textarea name="body" placeholder="Add a comment..." rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-small">Post Comment</button>
      </form>
    <% else %>
      <p style="margin: 1rem 0; color: #666;">
        <a href="/login">Login</a> to post comments
      </p>
    <% end %>

    <% @comments.each do |comment| %>
      <div class="comment">
        <div class="comment-meta">
          <a href="/users/<%= comment.user.id %>"><%= comment.user.username %></a>
          • <%= comment.formatted_date %>
          <% if logged_in? && comment.user_id == current_user.id %>
            <form action="/comments/<%= comment.id %>/delete" method="post" style="display: inline; float: right;"
                  onsubmit="return confirm('Delete comment?')">
              <button type="submit" class="btn-danger" style="padding: 0.25rem 0.5rem; font-size: 0.75rem; border: none; border-radius: 3px; cursor: pointer;">Delete</button>
            </form>
          <% end %>
        </div>
        <div><%= format_text(comment.body) %></div>
      </div>
    <% end %>
  </div>
</div>

<a href="/" class="btn btn-small">← Back to All Posts</a>

@@not_found
<div class="post-card">
  <h2>404 - Not Found</h2>
  <p>The page you're looking for doesn't exist.</p>
  <a href="/" class="btn">Go Home</a>
</div>
