# Progressive Building Guide: Blog API

Build a production-ready RESTful Blog API step by step with authentication, relationships, and JSON responses.

## 🎯 Overview

This guide breaks down the blog API into 9 progressive steps:
1. **Basic API Setup** - Create JSON API structure
2. **Add Database** - PostgreSQL with ActiveRecord
3. **User Model** - User authentication with BCrypt
4. **JWT Authentication** - Token-based auth
5. **Post Model** - Blog posts with CRUD
6. **Comments System** - Nested comments on posts
7. **Tagging System** - Many-to-many relationships
8. **Pagination** - Efficient data loading
9. **Error Handling** - Standardized error responses

**Estimated Time**: 3-4 hours

---

## Step 1: Basic API Setup (20 min)

### 🎯 Goal
Create a Sinatra API that returns JSON responses.

### 📝 Tasks

1. **Create app.rb**:
   ```ruby
   require 'sinatra'
   require 'json'

   # Set content type to JSON for all responses
   before do
     content_type :json
   end

   # API root
   get '/api/v1' do
     { message: 'Blog API v1', status: 'running' }.to_json
   end

   # Health check
   get '/api/v1/health' do
     { status: 'ok', timestamp: Time.now }.to_json
   end
   ```

2. **Test the API**:
   ```bash
   ruby app.rb
   # Visit http://localhost:4567/api/v1
   # Or use curl:
   curl http://localhost:4567/api/v1
   ```

### ✅ Checkpoint
- [ ] API returns JSON
- [ ] Health endpoint works
- [ ] Content-Type is application/json

---

## Step 2: Add Database with ActiveRecord (25 min)

### 🎯 Goal
Set up PostgreSQL with ActiveRecord ORM.

### 📝 Tasks

1. **Install gems**:
   ```bash
   gem install sinatra activerecord pg
   ```

2. **Create database configuration** (`config/database.rb`):
   ```ruby
   require 'active_record'

   # Database connection
   db_config = {
     adapter: 'postgresql',
     host: ENV['DB_HOST'] || 'localhost',
     database: ENV['DB_NAME'] || 'blog_api_dev',
     username: ENV['DB_USER'] || 'postgres',
     password: ENV['DB_PASSWORD'] || '',
     pool: 5,
     timeout: 5000
   }

   # For development, you can use SQLite instead:
   # db_config = {
   #   adapter: 'sqlite3',
   #   database: 'blog_api.db'
   # }

   ActiveRecord::Base.establish_connection(db_config)

   # Enable logging in development
   ActiveRecord::Base.logger = Logger.new(STDOUT) if development?
   ```

3. **Update app.rb**:
   ```ruby
   require 'sinatra'
   require 'json'
   require_relative 'config/database'

   before do
     content_type :json
   end

   get '/api/v1' do
     {
       message: 'Blog API v1',
       status: 'running',
       database: 'connected'
     }.to_json
   end

   get '/api/v1/health' do
     {
       status: 'ok',
       timestamp: Time.now,
       database: ActiveRecord::Base.connected? ? 'connected' : 'disconnected'
     }.to_json
   end
   ```

4. **Create the database**:
   ```bash
   # PostgreSQL
   createdb blog_api_dev

   # Or if using Docker
   docker-compose exec postgres createdb -U postgres blog_api_dev
   ```

### ✅ Checkpoint
- [ ] Database connection works
- [ ] Health endpoint shows database status
- [ ] No connection errors

---

## Step 3: User Model with Authentication (30 min)

### 🎯 Goal
Create User model with password hashing.

### 📝 Tasks

1. **Install BCrypt**:
   ```bash
   gem install bcrypt
   ```

2. **Create User model** (`lib/models/user.rb`):
   ```ruby
   require 'active_record'
   require 'bcrypt'

   class User < ActiveRecord::Base
     # Virtual attribute for password
     attr_accessor :password

     # Validations
     validates :email, presence: true, uniqueness: true,
               format: { with: URI::MailTo::EMAIL_REGEXP }
     validates :name, presence: true, length: { minimum: 2, maximum: 100 }
     validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

     # Hash password before saving
     before_save :hash_password, if: :password_present?

     # Authenticate user
     def authenticate(password)
       BCrypt::Password.new(password_digest) == password
     end

     # JSON representation (hide password_digest)
     def as_json(options = {})
       super(options.merge(except: [:password_digest]))
     end

     private

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

3. **Create migration** (`db/migrate/001_create_users.rb`):
   ```ruby
   class CreateUsers < ActiveRecord::Migration[7.0]
     def change
       create_table :users do |t|
         t.string :email, null: false
         t.string :password_digest, null: false
         t.string :name, null: false
         t.timestamps
       end

       add_index :users, :email, unique: true
     end
   end
   ```

4. **Run migration helper** (`db/migrate.rb`):
   ```ruby
   require_relative '../config/database'

   # Load all models
   Dir['./lib/models/*.rb'].each { |file| require file }

   # Run migrations
   ActiveRecord::Base.connection.create_table :users, force: true do |t|
     t.string :email, null: false
     t.string :password_digest, null: false
     t.string :name, null: false
     t.timestamps
   end

   ActiveRecord::Base.connection.add_index :users, :email, unique: true

   puts "✓ Users table created"
   ```

5. **Run the migration**:
   ```bash
   ruby db/migrate.rb
   ```

6. **Load models in app.rb**:
   ```ruby
   require 'sinatra'
   require 'json'
   require_relative 'config/database'
   require_relative 'lib/models/user'

   # ... rest of code
   ```

### ✅ Checkpoint
- [ ] Users table exists
- [ ] User model validates correctly
- [ ] Password hashing works

---

## Step 4: JWT Authentication (35 min)

### 🎯 Goal
Implement JWT token-based authentication.

### 📝 Tasks

1. **Install JWT gem**:
   ```bash
   gem install jwt
   ```

2. **Create auth helpers** (`lib/auth.rb`):
   ```ruby
   require 'jwt'

   module Auth
     SECRET_KEY = ENV['JWT_SECRET'] || 'change_this_secret_key_in_production'

     def self.encode(payload)
       payload[:exp] = 24.hours.from_now.to_i
       JWT.encode(payload, SECRET_KEY, 'HS256')
     end

     def self.decode(token)
       JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
     rescue JWT::DecodeError => e
       nil
     end
   end

   module Sinatra
     module AuthHelper
       def authenticate!
         token = extract_token
         halt 401, { error: 'Unauthorized' }.to_json unless token

         payload = Auth.decode(token)
         halt 401, { error: 'Invalid or expired token' }.to_json unless payload

         @current_user = User.find_by(id: payload['user_id'])
         halt 401, { error: 'User not found' }.to_json unless @current_user
       end

       def current_user
         @current_user
       end

       private

       def extract_token
         auth_header = request.env['HTTP_AUTHORIZATION']
         return nil unless auth_header

         auth_header.split(' ').last
       end
     end

     helpers AuthHelper
   end
   ```

3. **Add authentication routes** to app.rb:
   ```ruby
   require 'sinatra'
   require 'json'
   require_relative 'config/database'
   require_relative 'lib/models/user'
   require_relative 'lib/auth'

   before do
     content_type :json
   end

   # Register new user
   post '/api/v1/auth/register' do
     data = JSON.parse(request.body.read)

     user = User.new(
       email: data['email'],
       name: data['name'],
       password: data['password']
     )

     if user.save
       token = Auth.encode(user_id: user.id)
       status 201
       { token: token, user: user }.to_json
     else
       status 422
       { errors: user.errors.full_messages }.to_json
     end
   end

   # Login
   post '/api/v1/auth/login' do
     data = JSON.parse(request.body.read)

     user = User.find_by(email: data['email'])

     if user && user.authenticate(data['password'])
       token = Auth.encode(user_id: user.id)
       { token: token, user: user }.to_json
     else
       status 401
       { error: 'Invalid email or password' }.to_json
     end
   end

   # Get current user (protected route)
   get '/api/v1/auth/me' do
     authenticate!
     current_user.to_json
   end
   ```

4. **Test authentication**:
   ```bash
   # Register
   curl -X POST http://localhost:4567/api/v1/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","name":"Test User","password":"password123"}'

   # Login
   curl -X POST http://localhost:4567/api/v1/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"password123"}'

   # Get current user (use token from login)
   curl http://localhost:4567/api/v1/auth/me \
     -H "Authorization: Bearer YOUR_TOKEN_HERE"
   ```

### ✅ Checkpoint
- [ ] User registration works
- [ ] Login returns JWT token
- [ ] Protected routes require authentication
- [ ] Token validation works

---

## Step 5: Post Model and CRUD (35 min)

### 🎯 Goal
Create blog posts with full CRUD operations.

### 📝 Tasks

1. **Create Post model** (`lib/models/post.rb`):
   ```ruby
   class Post < ActiveRecord::Base
     belongs_to :user

     validates :title, presence: true, length: { minimum: 5, maximum: 200 }
     validates :content, presence: true, length: { minimum: 10 }
     validates :user, presence: true

     scope :published, -> { where(published: true) }
     scope :recent, -> { order(created_at: :desc) }

     def as_json(options = {})
       super(options.merge(
         include: { user: { only: [:id, :name, :email] } }
       ))
     end
   end
   ```

2. **Create posts table**:
   ```ruby
   # Add to db/migrate.rb or run directly
   ActiveRecord::Base.connection.create_table :posts, force: true do |t|
     t.string :title, null: false
     t.text :content, null: false
     t.boolean :published, default: false
     t.references :user, foreign_key: true
     t.timestamps
   end

   puts "✓ Posts table created"
   ```

3. **Add Post routes** to app.rb:
   ```ruby
   # List all posts
   get '/api/v1/posts' do
     posts = Post.includes(:user).recent.all
     posts.to_json
   end

   # Get single post
   get '/api/v1/posts/:id' do
     post = Post.includes(:user).find_by(id: params[:id])
     halt 404, { error: 'Post not found' }.to_json unless post
     post.to_json
   end

   # Create post (auth required)
   post '/api/v1/posts' do
     authenticate!

     data = JSON.parse(request.body.read)
     post = current_user.posts.new(
       title: data['title'],
       content: data['content'],
       published: data['published'] || false
     )

     if post.save
       status 201
       post.to_json
     else
       status 422
       { errors: post.errors.full_messages }.to_json
     end
   end

   # Update post (auth required)
   put '/api/v1/posts/:id' do
     authenticate!

     post = Post.find_by(id: params[:id])
     halt 404, { error: 'Post not found' }.to_json unless post
     halt 403, { error: 'Not authorized' }.to_json unless post.user_id == current_user.id

     data = JSON.parse(request.body.read)
     if post.update(data.slice('title', 'content', 'published'))
       post.to_json
     else
       status 422
       { errors: post.errors.full_messages }.to_json
     end
   end

   # Delete post (auth required)
   delete '/api/v1/posts/:id' do
     authenticate!

     post = Post.find_by(id: params[:id])
     halt 404, { error: 'Post not found' }.to_json unless post
     halt 403, { error: 'Not authorized' }.to_json unless post.user_id == current_user.id

     post.destroy
     status 204
   end
   ```

4. **Update User model**:
   ```ruby
   class User < ActiveRecord::Base
     has_many :posts, dependent: :destroy

     # ... rest of code
   end
   ```

### ✅ Checkpoint
- [ ] Can list all posts
- [ ] Can get single post with user info
- [ ] Can create posts (authenticated)
- [ ] Can update own posts
- [ ] Can delete own posts
- [ ] Authorization works correctly

---

## Step 6: Comments System (25 min)

### 🎯 Goal
Add nested comments on posts.

### 📝 Tasks

1. **Create Comment model** (`lib/models/comment.rb`):
   ```ruby
   class Comment < ActiveRecord::Base
     belongs_to :user
     belongs_to :post

     validates :content, presence: true, length: { minimum: 1, maximum: 500 }
     validates :user, presence: true
     validates :post, presence: true

     def as_json(options = {})
       super(options.merge(
         include: { user: { only: [:id, :name] } }
       ))
     end
   end
   ```

2. **Create comments table**:
   ```ruby
   ActiveRecord::Base.connection.create_table :comments, force: true do |t|
     t.text :content, null: false
     t.references :user, foreign_key: true
     t.references :post, foreign_key: true
     t.timestamps
   end
   ```

3. **Update Post and User models**:
   ```ruby
   class Post < ActiveRecord::Base
     has_many :comments, dependent: :destroy
     # ... rest of code
   end

   class User < ActiveRecord::Base
     has_many :comments, dependent: :destroy
     # ... rest of code
   end
   ```

4. **Add comment routes**:
   ```ruby
   # Get post comments
   get '/api/v1/posts/:id/comments' do
     post = Post.find_by(id: params[:id])
     halt 404, { error: 'Post not found' }.to_json unless post

     comments = post.comments.includes(:user).order(created_at: :desc)
     comments.to_json
   end

   # Create comment (auth required)
   post '/api/v1/posts/:id/comments' do
     authenticate!

     post = Post.find_by(id: params[:id])
     halt 404, { error: 'Post not found' }.to_json unless post

     data = JSON.parse(request.body.read)
     comment = post.comments.new(
       content: data['content'],
       user: current_user
     )

     if comment.save
       status 201
       comment.to_json
     else
       status 422
       { errors: comment.errors.full_messages }.to_json
     end
   end

   # Update comment (auth required)
   put '/api/v1/comments/:id' do
     authenticate!

     comment = Comment.find_by(id: params[:id])
     halt 404, { error: 'Comment not found' }.to_json unless comment
     halt 403, { error: 'Not authorized' }.to_json unless comment.user_id == current_user.id

     data = JSON.parse(request.body.read)
     if comment.update(content: data['content'])
       comment.to_json
     else
       status 422
       { errors: comment.errors.full_messages }.to_json
     end
   end

   # Delete comment (auth required)
   delete '/api/v1/comments/:id' do
     authenticate!

     comment = Comment.find_by(id: params[:id])
     halt 404, { error: 'Comment not found' }.to_json unless comment
     halt 403, { error: 'Not authorized' }.to_json unless comment.user_id == current_user.id

     comment.destroy
     status 204
   end
   ```

### ✅ Checkpoint
- [ ] Can list post comments
- [ ] Can create comments
- [ ] Can update own comments
- [ ] Can delete own comments

---

## Steps 7-9: Quick Summary

### Step 7: Tagging System
- Create Tag model
- Many-to-many relationship with posts
- Tag endpoints

### Step 8: Pagination
- Add will_paginate or kaminari gem
- Paginate posts list
- Return pagination metadata

### Step 9: Error Handling
- Centralized error handler
- Standardized error responses
- Logging

See the complete application in `app.rb` for full implementation!

---

## 🎉 Completion!

You've built a production-ready Blog API with:

✅ JWT authentication
✅ CRUD operations for posts
✅ Nested comments
✅ User authorization
✅ JSON responses
✅ Database relationships

### 📚 What You Learned

- RESTful API design
- JWT token authentication
- ActiveRecord associations
- Authorization patterns
- JSON serialization
- Error handling

**Next:** [Lab 3: Authentication Web App](../3-auth-app/README.md)
