# Step 3: Create Models

**Estimated Time:** 20 minutes

[← Previous Step](../2/README.md) | [Next Step →](../4/README.md)

---

## 🎯 Goal

Define Task and Category models with Sequel.

## 📝 Tasks

### 1. Create lib directory

```bash
mkdir -p lib
```

### 2. Create models file (`lib/models.rb`)

```ruby
require 'sequel'

class Category < Sequel::Model
  one_to_many :tasks

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
  end
end

class Task < Sequel::Model
  many_to_one :category

  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.empty?
    errors.add(:title, 'must be between 2 and 100 characters') if title && (title.length < 2 || title.length > 100)
  end

  def toggle_completion!
    self.completed = !self.completed
    self.save
  end
end
```

### 3. Update app.rb to use models

```ruby
require 'sinatra'
require 'sequel'

# Database connection
DB = Sequel.connect('sqlite://todos.db')

# Create tables
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

# Load models
require_relative 'lib/models'

# Seed some default categories
if Category.count == 0
  Category.create(name: 'Work', color: 'blue')
  Category.create(name: 'Personal', color: 'green')
  Category.create(name: 'Shopping', color: 'orange')
end

get '/' do
  redirect '/tasks'
end

get '/tasks' do
  tasks = Task.all
  categories = Category.all
  "Found #{tasks.count} tasks and #{categories.count} categories"
end
```

### 4. Test models

```bash
ruby app.rb
# Should see "Found 0 tasks and 3 categories"
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Models are loaded without errors
- [ ] Categories are seeded (3 categories created)
- [ ] Task count displays correctly (0 tasks, 3 categories)
- [ ] No validation errors when app starts

## 🎓 What You Learned

- Defining Sequel models with `Sequel::Model`
- Setting up one-to-many relationships
- Adding custom validations to models
- Seeding initial data
- Creating custom model methods (`toggle_completion!`)

## 🔍 Model Relationships

```
Category (1) ──has_many──> (N) Tasks
Task (N) ──belongs_to──> (1) Category
```

---

[← Previous: Add Database](../2/README.md) | [Next: List Tasks with Templates →](../4/README.md)
