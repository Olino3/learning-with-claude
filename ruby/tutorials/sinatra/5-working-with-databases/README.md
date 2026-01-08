# Tutorial 5: Working with Databases - Data Persistence with ORMs

Learn how to work with databases in Sinatra using Sequel and ActiveRecord ORMs, handle migrations, and perform CRUD operations.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Set up database connections (SQLite, PostgreSQL)
- Use Sequel ORM for database operations
- Use ActiveRecord ORM with Sinatra
- Create and run migrations
- Perform CRUD operations
- Work with model associations
- Validate data at the database level
- Handle transactions

## 🐍➡️🔴 Coming from Python ORMs

Ruby has two popular ORMs similar to Python's database tools:

| Feature | SQLAlchemy (Python) | Sequel (Ruby) | Django ORM | ActiveRecord (Ruby) |
|---------|---------------------|---------------|------------|---------------------|
| Philosophy | Explicit, flexible | Simple, Ruby-ish | Convention | Convention |
| Models | Class-based | Dataset/Model | Class-based | Class-based |
| Queries | `session.query()` | `DB[:table]` | `Model.objects` | `Model.where()` |
| Migrations | Alembic | Sequel migrations | Built-in | ActiveRecord migrations |
| Associations | `relationship()` | `one_to_many` | `ForeignKey` | `has_many` |

## 🗄️ Database Setup

### SQLite (Development)

```ruby
require 'sinatra'
require 'sequel'

# Connect to SQLite database
DB = Sequel.connect('sqlite://development.db')

# Or in-memory for testing
# DB = Sequel.connect('sqlite::memory:')
```

### PostgreSQL (Production)

```ruby
# Using DATABASE_URL environment variable
DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/myapp')

# Or explicit connection
DB = Sequel.connect(
  adapter: 'postgres',
  host: 'localhost',
  database: 'myapp',
  user: 'username',
  password: 'password'
)
```

## 📦 Sequel ORM

Sequel is a lightweight, flexible ORM similar to SQLAlchemy Core.

### Installation

```bash
gem install sequel
gem install sqlite3  # or pg for PostgreSQL
```

### Basic Usage

```ruby
require 'sinatra'
require 'sequel'

DB = Sequel.connect('sqlite://blog.db')

# Create table
DB.create_table? :posts do
  primary_key :id
  String :title, null: false
  String :body, text: true
  DateTime :created_at
end

# Insert data
posts = DB[:posts]
posts.insert(
  title: 'First Post',
  body: 'Hello World!',
  created_at: Time.now
)

# Query data
get '/posts' do
  @posts = posts.all
  erb :posts
end

# Find by ID
get '/posts/:id' do
  @post = posts.where(id: params[:id]).first
  erb :post
end

# Update
post '/posts/:id/update' do
  posts.where(id: params[:id]).update(
    title: params[:title],
    body: params[:body]
  )
  redirect '/posts'
end

# Delete
post '/posts/:id/delete' do
  posts.where(id: params[:id]).delete
  redirect '/posts'
end
```

### 🐍 SQLAlchemy Comparison

**SQLAlchemy Core:**
```python
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData

engine = create_engine('sqlite:///blog.db')
metadata = MetaData()

posts = Table('posts', metadata,
    Column('id', Integer, primary_key=True),
    Column('title', String, nullable=False),
    Column('body', String)
)

metadata.create_all(engine)

# Insert
conn.execute(posts.insert().values(title='First Post', body='Hello'))

# Query
result = conn.execute(posts.select())
```

**Sequel:**
```ruby
DB = Sequel.connect('sqlite://blog.db')

DB.create_table? :posts do
  primary_key :id
  String :title, null: false
  String :body
end

posts = DB[:posts]
posts.insert(title: 'First Post', body: 'Hello')
result = posts.all
```

## 🏗️ Sequel Models

Models provide a more object-oriented interface:

```ruby
require 'sequel'

DB = Sequel.connect('sqlite://blog.db')

DB.create_table? :posts do
  primary_key :id
  String :title, null: false
  String :body, text: true
  String :author
  DateTime :created_at
  DateTime :updated_at
end

class Post < Sequel::Model
  # Validations
  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.empty?
    errors.add(:title, 'is too short') if title && title.length < 5
    errors.add(:body, 'cannot be empty') if !body || body.empty?
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
  def excerpt(length = 100)
    body.length > length ? "#{body[0...length]}..." : body
  end
end

# Usage in routes
get '/posts' do
  @posts = Post.order(Sequel.desc(:created_at)).all
  erb :posts
end

get '/posts/:id' do
  @post = Post[params[:id]]
  halt 404, "Post not found" unless @post
  erb :post
end

post '/posts' do
  post = Post.new(
    title: params[:title],
    body: params[:body],
    author: params[:author]
  )

  if post.valid?
    post.save
    redirect "/posts/#{post.id}"
  else
    @errors = post.errors
    @post = post
    erb :new_post
  end
end

put '/posts/:id' do
  post = Post[params[:id]]
  halt 404 unless post

  post.update(
    title: params[:title],
    body: params[:body]
  )

  redirect "/posts/#{post.id}"
end

delete '/posts/:id' do
  post = Post[params[:id]]
  halt 404 unless post

  post.destroy
  redirect '/posts'
end
```

## 🔗 Model Associations (Sequel)

```ruby
DB.create_table? :users do
  primary_key :id
  String :name
  String :email
end

DB.create_table? :posts do
  primary_key :id
  foreign_key :user_id, :users
  String :title
  String :body
end

DB.create_table? :comments do
  primary_key :id
  foreign_key :post_id, :posts
  String :author
  String :body
end

class User < Sequel::Model
  one_to_many :posts
end

class Post < Sequel::Model
  many_to_one :user
  one_to_many :comments

  def validate
    super
    errors.add(:user_id, 'must be set') unless user_id
  end
end

class Comment < Sequel::Model
  many_to_one :post
end

# Usage
user = User.create(name: 'Alice', email: 'alice@example.com')

post = Post.create(
  user_id: user.id,
  title: 'My First Post',
  body: 'Content here'
)

comment = Comment.create(
  post_id: post.id,
  author: 'Bob',
  body: 'Great post!'
)

# Accessing associations
get '/users/:id' do
  @user = User[params[:id]]
  @posts = @user.posts  # Get all posts by user
  erb :user
end

get '/posts/:id' do
  @post = Post[params[:id]]
  @author = @post.user  # Get post author
  @comments = @post.comments  # Get all comments
  erb :post
end
```

## 🗃️ ActiveRecord ORM

ActiveRecord is Rails' ORM - more convention-driven, similar to Django ORM.

### Installation

```bash
gem install activerecord
gem install sinatra-activerecord
```

### Setup

```ruby
require 'sinatra'
require 'sinatra/activerecord'

# Database configuration
set :database, {
  adapter: 'sqlite3',
  database: 'blog.db'
}

# Or using database.yml
# set :database_file, 'config/database.yml'
```

### Creating Models

```ruby
class Post < ActiveRecord::Base
  # Validations
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true

  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Scopes
  scope :recent, -> { order(created_at: :desc).limit(10) }
  scope :by_author, ->(author) { where(author: author) }

  # Custom methods
  def excerpt(length = 100)
    body.truncate(length)
  end
end

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :posts
end

class Comment < ActiveRecord::Base
  validates :body, presence: true

  belongs_to :post
end
```

### Migrations (ActiveRecord)

Create a Rakefile:

```ruby
# Rakefile
require './app'
require 'sinatra/activerecord/rake'
```

Generate migration:

```bash
rake db:create_migration NAME=create_posts
```

Edit the migration:

```ruby
# db/migrate/20260108000001_create_posts.rb
class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body
      t.string :author
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :posts, :title
  end
end
```

Run migration:

```bash
rake db:migrate
```

### CRUD with ActiveRecord

```ruby
require 'sinatra'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'blog.db' }

# List all
get '/posts' do
  @posts = Post.order(created_at: :desc).all
  erb :posts
end

# Show one
get '/posts/:id' do
  @post = Post.find_by(id: params[:id])
  halt 404, "Post not found" unless @post
  erb :post
end

# New form
get '/posts/new' do
  @post = Post.new
  erb :new_post
end

# Create
post '/posts' do
  @post = Post.new(
    title: params[:title],
    body: params[:body],
    author: params[:author]
  )

  if @post.save
    redirect "/posts/#{@post.id}"
  else
    @errors = @post.errors.full_messages
    erb :new_post
  end
end

# Edit form
get '/posts/:id/edit' do
  @post = Post.find(params[:id])
  erb :edit_post
end

# Update
put '/posts/:id' do
  @post = Post.find(params[:id])

  if @post.update(
    title: params[:title],
    body: params[:body]
  )
    redirect "/posts/#{@post.id}"
  else
    @errors = @post.errors.full_messages
    erb :edit_post
  end
end

# Delete
delete '/posts/:id' do
  post = Post.find(params[:id])
  post.destroy
  redirect '/posts'
end
```

## 🐍 Django ORM Comparison

**Django:**
```python
from django.db import models

class Post(models.Model):
    title = models.CharField(max_length=200)
    body = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

# Query
posts = Post.objects.all()
post = Post.objects.get(id=1)
post = Post.objects.create(title='New', body='Content')
```

**ActiveRecord:**
```ruby
class Post < ActiveRecord::Base
  validates :title, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end

# Query
posts = Post.all
post = Post.find(1)
post = Post.create(title: 'New', body: 'Content')
```

## 🔍 Query Examples

### Sequel

```ruby
# Find all
posts = Post.all

# Find by ID
post = Post[1]

# Where clause
posts = Post.where(author: 'Alice')

# Multiple conditions
posts = Post.where(author: 'Alice', published: true)

# OR conditions
posts = Post.where(Sequel.|({ author: 'Alice' }, { author: 'Bob' }))

# LIKE
posts = Post.where(Sequel.like(:title, '%ruby%'))

# Order
posts = Post.order(:created_at)
posts = Post.order(Sequel.desc(:created_at))

# Limit
posts = Post.limit(10)

# Chaining
posts = Post.where(published: true)
           .order(Sequel.desc(:created_at))
           .limit(10)

# Count
count = Post.where(author: 'Alice').count

# Aggregate
DB[:posts].select{ avg(rating) }.first

# Join
posts = Post.join(:users, id: :user_id)
           .where(users__name: 'Alice')
```

### ActiveRecord

```ruby
# Find all
posts = Post.all

# Find by ID
post = Post.find(1)

# Find by attribute
post = Post.find_by(title: 'Hello')

# Where clause
posts = Post.where(author: 'Alice')

# Multiple conditions
posts = Post.where(author: 'Alice', published: true)

# OR conditions
posts = Post.where(author: 'Alice').or(Post.where(author: 'Bob'))

# LIKE
posts = Post.where('title LIKE ?', '%ruby%')

# Order
posts = Post.order(:created_at)
posts = Post.order(created_at: :desc)

# Limit
posts = Post.limit(10)

# Chaining
posts = Post.where(published: true)
           .order(created_at: :desc)
           .limit(10)

# Count
count = Post.where(author: 'Alice').count

# Aggregate
average = Post.average(:rating)

# Join
posts = Post.joins(:user).where(users: { name: 'Alice' })

# Includes (eager loading)
posts = Post.includes(:comments).all
```

## 💾 Transactions

### Sequel

```ruby
DB.transaction do
  user = User.create(name: 'Alice', email: 'alice@example.com')
  post = Post.create(user_id: user.id, title: 'First Post', body: 'Content')

  raise Sequel::Rollback if some_condition  # Rollback
end
```

### ActiveRecord

```ruby
ActiveRecord::Base.transaction do
  user = User.create!(name: 'Alice', email: 'alice@example.com')
  post = Post.create!(user_id: user.id, title: 'First Post', body: 'Content')

  raise ActiveRecord::Rollback if some_condition
end
```

## 🔐 Validations

### Sequel

```ruby
class Post < Sequel::Model
  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.empty?
    errors.add(:title, 'must be at least 5 characters') if title && title.length < 5
    errors.add(:email, 'is not valid') if email && !email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end
end

post = Post.new(title: 'Hi')
post.valid?  # => false
post.errors  # => { title: ['must be at least 5 characters'] }
```

### ActiveRecord

```ruby
class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :author, presence: true, uniqueness: true

  validate :custom_validation

  private

  def custom_validation
    errors.add(:body, 'cannot contain profanity') if body&.match?(/badword/)
  end
end

post = Post.new(title: 'Hi')
post.valid?  # => false
post.errors.full_messages  # => ["Title is too short (minimum is 5 characters)"]
```

## ✍️ Exercises

### Exercise 1: Blog with Sequel

Create a blog application with:
- Posts CRUD (Create, Read, Update, Delete)
- Basic validations
- List and detail views
- Author field

**Solution:** [blog_sequel_app.rb](blog_sequel_app.rb)

### Exercise 2: Task Manager with ActiveRecord

Build a task manager with:
- Tasks with title, description, status
- Categories with associations
- Migrations
- Mark complete functionality

**Solution:** [task_manager_app.rb](task_manager_app.rb)

### Exercise 3: Multi-User Blog

Create a blog with users and posts:
- User authentication (basic)
- Posts belong to users
- Comments on posts
- User profile pages

**Solution:** [multi_user_blog_app.rb](multi_user_blog_app.rb)

## 🎓 Key Concepts

1. **ORM**: Maps database tables to Ruby objects
2. **Migrations**: Version control for database schema
3. **Models**: Ruby classes representing database tables
4. **Associations**: Relationships between models (has_many, belongs_to)
5. **Validations**: Ensure data integrity
6. **Queries**: Chainable methods to fetch data
7. **Transactions**: Atomic database operations

## 🐞 Common Issues

### Issue 1: Connection Not Established

**Problem:** Database connection fails

**Solution:** Check connection string and ensure database exists

```ruby
# Create database first
DB = Sequel.connect('sqlite://blog.db')

# Or for PostgreSQL
# createdb myapp
DB = Sequel.connect('postgres://localhost/myapp')
```

### Issue 2: Table Doesn't Exist

**Problem:** `Sequel::DatabaseError: no such table`

**Solution:** Create table or run migrations

```ruby
DB.create_table? :posts do
  primary_key :id
  String :title
end
```

### Issue 3: Validation Failing Silently

**Problem:** Record not saving but no error shown

**Solution:** Check validations and use save with exception

```ruby
# Sequel
post.save(raise_on_failure: true)

# ActiveRecord
post.save!  # Raises exception on failure
```

## 📊 ORM Quick Reference

| Task | SQLAlchemy | Sequel | ActiveRecord |
|------|------------|--------|--------------|
| Connect | `create_engine()` | `Sequel.connect()` | `set :database` |
| Create table | `metadata.create_all()` | `DB.create_table` | Migration |
| Insert | `session.add(obj)` | `Model.create()` | `Model.create()` |
| Query all | `session.query()` | `Model.all` | `Model.all` |
| Find by ID | `session.get()` | `Model[id]` | `Model.find(id)` |
| Where | `.filter()` | `.where()` | `.where()` |
| Order | `.order_by()` | `.order()` | `.order()` |
| Update | `obj.attr = val` | `obj.update()` | `obj.update()` |
| Delete | `session.delete()` | `obj.destroy` | `obj.destroy` |

## 🔜 What's Next?

You now know:
- ✅ How to connect to databases
- ✅ How to use Sequel and ActiveRecord ORMs
- ✅ How to create models and migrations
- ✅ How to perform CRUD operations
- ✅ How to work with associations
- ✅ How to validate data

Next: Sessions, cookies, and user authentication!

**Next:** [Tutorial 6: Sessions and Cookies](../6-sessions-and-cookies/README.md)

## 📖 Additional Resources

- [Sequel Documentation](https://sequel.jeremyevans.net/)
- [ActiveRecord Guide](https://guides.rubyonrails.org/active_record_basics.html)
- [Sinatra ActiveRecord](https://github.com/sinatra/sinatra-activerecord)
- [Database Design Best Practices](https://www.postgresql.org/docs/current/tutorial.html)

---

Ready to practice? Start with **Exercise 1: Blog with Sequel**!
