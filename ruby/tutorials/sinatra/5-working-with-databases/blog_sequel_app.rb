require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'

# Database connection
DB = Sequel.connect('sqlite://blog.db')

# Create posts table
DB.create_table? :posts do
  primary_key :id
  String :title, null: false
  String :body, text: true
  String :author
  DateTime :created_at
  DateTime :updated_at
end

# Post model
class Post < Sequel::Model
  # Validations
  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.strip.empty?
    errors.add(:title, 'must be at least 5 characters') if title && title.length < 5
    errors.add(:body, 'cannot be empty') if !body || body.strip.empty?
    errors.add(:body, 'must be at least 20 characters') if body && body.length < 20
    errors.add(:author, 'cannot be empty') if !author || author.strip.empty?
  end

  # Hooks
  def before_create
    super
    self.created_at = Time.now
    self.updated_at = Time.now
  end

  def before_update
    super
    self.updated_at = Time.now
  end

  # Custom methods
  def excerpt(length = 150)
    body.length > length ? "#{body[0...length]}..." : body
  end

  def formatted_date
    created_at.strftime('%B %d, %Y at %I:%M %p')
  end
end

enable :sessions

helpers do
  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end

  def format_text(text)
    # Simple formatting: convert newlines to <br>
    text.to_s.gsub("\n", "<br>")
  end
end

# List all posts
get '/' do
  @posts = Post.order(Sequel.desc(:created_at)).all
  @success = get_flash(:success)
  erb :index
end

# New post form
get '/posts/new' do
  @post = Post.new
  erb :new_post
end

# Create post
post '/posts' do
  @post = Post.new(
    title: params[:title],
    body: params[:body],
    author: params[:author]
  )

  if @post.valid?
    @post.save
    flash(:success, 'Post created successfully!')
    redirect '/'
  else
    @errors = @post.errors
    erb :new_post
  end
end

# Show post
get '/posts/:id' do
  @post = Post[params[:id]]
  halt 404, erb(:not_found) unless @post
  erb :show_post
end

# Edit post form
get '/posts/:id/edit' do
  @post = Post[params[:id]]
  halt 404, erb(:not_found) unless @post
  erb :edit_post
end

# Update post
post '/posts/:id' do
  @post = Post[params[:id]]
  halt 404, erb(:not_found) unless @post

  @post.set(
    title: params[:title],
    body: params[:body],
    author: params[:author]
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
  post = Post[params[:id]]
  halt 404 unless post

  post.destroy
  flash(:success, 'Post deleted successfully!')
  redirect '/'
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Sequel Blog</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: #f5f7fa;
      color: #333;
      line-height: 1.6;
    }

    .container {
      max-width: 900px;
      margin: 0 auto;
      padding: 2rem;
    }

    header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 2rem;
      text-align: center;
      margin-bottom: 2rem;
      border-radius: 10px;
    }

    header h1 {
      font-size: 2.5rem;
      margin-bottom: 0.5rem;
    }

    header p {
      opacity: 0.9;
    }

    .btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      font-weight: 600;
      transition: transform 0.2s;
      border: none;
      cursor: pointer;
      font-size: 1rem;
    }

    .btn:hover {
      transform: translateY(-2px);
    }

    .btn-danger {
      background: #dc3545;
    }

    .btn-secondary {
      background: #6c757d;
    }

    .success {
      background: #d4edda;
      border: 1px solid #c3e6cb;
      color: #155724;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .post-card {
      background: white;
      padding: 2rem;
      margin-bottom: 1.5rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      transition: transform 0.2s;
    }

    .post-card:hover {
      transform: translateY(-2px);
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

    .post-excerpt {
      color: #555;
      margin-bottom: 1rem;
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
      min-height: 200px;
    }

    input:focus,
    textarea:focus {
      outline: none;
      border-color: #667eea;
    }

    .errors {
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      color: #721c24;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .errors ul {
      margin-left: 1.5rem;
    }

    .actions {
      display: flex;
      gap: 1rem;
      margin-top: 1.5rem;
    }

    .empty-state {
      text-align: center;
      padding: 4rem 2rem;
      background: white;
      border-radius: 10px;
    }

    .empty-state h2 {
      color: #999;
      margin-bottom: 1rem;
    }

    .post-detail {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .post-detail h1 {
      color: #667eea;
      margin-bottom: 1rem;
    }

    .post-body {
      line-height: 1.8;
      color: #444;
      margin: 2rem 0;
    }

    .required {
      color: #dc3545;
    }
  </style>
</head>
<body>
  <%= yield %>
</body>
</html>

@@index
<div class="container">
  <header>
    <h1>📝 Sequel Blog</h1>
    <p>A simple blog built with Sinatra and Sequel ORM</p>
  </header>

  <% if @success %>
    <div class="success">
      <%= @success %>
    </div>
  <% end %>

  <div style="margin-bottom: 2rem;">
    <a href="/posts/new" class="btn">✍️ Write New Post</a>
  </div>

  <% if @posts.empty? %>
    <div class="empty-state">
      <h2>No posts yet</h2>
      <p>Be the first to write something!</p>
      <a href="/posts/new" class="btn" style="margin-top: 1rem;">Create First Post</a>
    </div>
  <% else %>
    <% @posts.each do |post| %>
      <div class="post-card">
        <h2><a href="/posts/<%= post.id %>"><%= post.title %></a></h2>
        <div class="post-meta">
          By <strong><%= post.author %></strong> on <%= post.formatted_date %>
        </div>
        <div class="post-excerpt">
          <%= post.excerpt %>
        </div>
        <div class="actions">
          <a href="/posts/<%= post.id %>" class="btn">Read More</a>
          <a href="/posts/<%= post.id %>/edit" class="btn btn-secondary">Edit</a>
        </div>
      </div>
    <% end %>
  <% end %>
</div>

@@new_post
<div class="container">
  <header>
    <h1>✍️ Write New Post</h1>
  </header>

  <div style="background: white; padding: 2rem; border-radius: 10px;">
    <% if @errors && @errors.any? %>
      <div class="errors">
        <strong>Please fix these errors:</strong>
        <ul>
          <% @errors.each do |field, messages| %>
            <% messages.each do |message| %>
              <li><%= field.to_s.capitalize %>: <%= message %></li>
            <% end %>
          <% end %>
        </ul>
      </div>
    <% end %>

    <form action="/posts" method="post">
      <div class="form-group">
        <label for="title">Title <span class="required">*</span></label>
        <input type="text" id="title" name="title" value="<%= @post.title %>" required>
      </div>

      <div class="form-group">
        <label for="author">Author <span class="required">*</span></label>
        <input type="text" id="author" name="author" value="<%= @post.author %>" required>
      </div>

      <div class="form-group">
        <label for="body">Content <span class="required">*</span></label>
        <textarea id="body" name="body" required><%= @post.body %></textarea>
      </div>

      <div class="actions">
        <button type="submit" class="btn">Publish Post</button>
        <a href="/" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

@@edit_post
<div class="container">
  <header>
    <h1>✏️ Edit Post</h1>
  </header>

  <div style="background: white; padding: 2rem; border-radius: 10px;">
    <% if @errors && @errors.any? %>
      <div class="errors">
        <strong>Please fix these errors:</strong>
        <ul>
          <% @errors.each do |field, messages| %>
            <% messages.each do |message| %>
              <li><%= field.to_s.capitalize %>: <%= message %></li>
            <% end %>
          <% end %>
        </ul>
      </div>
    <% end %>

    <form action="/posts/<%= @post.id %>" method="post">
      <div class="form-group">
        <label for="title">Title <span class="required">*</span></label>
        <input type="text" id="title" name="title" value="<%= @post.title %>" required>
      </div>

      <div class="form-group">
        <label for="author">Author <span class="required">*</span></label>
        <input type="text" id="author" name="author" value="<%= @post.author %>" required>
      </div>

      <div class="form-group">
        <label for="body">Content <span class="required">*</span></label>
        <textarea id="body" name="body" required><%= @post.body %></textarea>
      </div>

      <div class="actions">
        <button type="submit" class="btn">Update Post</button>
        <a href="/posts/<%= @post.id %>" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

@@show_post
<div class="container">
  <div class="post-detail">
    <h1><%= @post.title %></h1>
    <div class="post-meta">
      By <strong><%= @post.author %></strong> on <%= @post.formatted_date %>
    </div>
    <div class="post-body">
      <%= format_text(@post.body) %>
    </div>
    <div class="actions">
      <a href="/" class="btn btn-secondary">← Back to Posts</a>
      <a href="/posts/<%= @post.id %>/edit" class="btn">Edit Post</a>
      <form action="/posts/<%= @post.id %>/delete" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this post?')">
        <button type="submit" class="btn btn-danger">Delete Post</button>
      </form>
    </div>
  </div>
</div>

@@not_found
<div class="container">
  <div class="empty-state">
    <h1>404</h1>
    <h2>Post not found</h2>
    <a href="/" class="btn" style="margin-top: 1rem;">Go Home</a>
  </div>
</div>
