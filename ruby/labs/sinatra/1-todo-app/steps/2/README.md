# Step 2: Add Database

**Estimated Time:** 20 minutes

[← Previous Step](../1/README.md) | [Next Step →](../3/README.md)

---

## 🎯 Goal

Set up SQLite database with Sequel ORM.

## 📝 Tasks

### 1. Install required gems

```bash
gem install sequel sqlite3
```

### 2. Update app.rb to include database

```ruby
require 'sinatra'
require 'sequel'

# Connect to database (creates file if doesn't exist)
DB = Sequel.connect('sqlite://todos.db')

# Create tables if they don't exist
DB.create_table? :categories do
  primary_key :id
  String :name, null: false
  String :color, default: 'blue'
end

DB.create_table? :tasks do
  primary_key :id
  String :title, null: false
  String :description, text: true
  Boolean :completed, default: false
  foreign_key :category_id, :categories
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
end

get '/' do
  redirect '/tasks'
end

get '/tasks' do
  "Database connected! Tables created."
end
```

### 3. Test the database connection

```bash
ruby app.rb
# Visit http://localhost:4567/tasks
# Check that todos.db file was created in your directory
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Database file `todos.db` is created
- [ ] No database errors when running app
- [ ] Tables are created successfully
- [ ] Browser shows "Database connected! Tables created."

## 🎓 What You Learned

- How to use Sequel ORM to connect to SQLite
- Creating database tables programmatically
- Using `create_table?` for idempotent table creation
- Defining primary keys, foreign keys, and column constraints

## 🔍 Database Schema

```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  color TEXT DEFAULT 'blue'
);

CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  completed BOOLEAN DEFAULT FALSE,
  category_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

---

[← Previous: Basic Sinatra Setup](../1/README.md) | [Next: Create Models →](../3/README.md)
