# Intermediate Ruby Lab: Blog Management System

Welcome to the comprehensive intermediate Ruby lab! This project integrates all intermediate concepts you've learned into a realistic blog management system.

## 🎯 Learning Objectives

This lab demonstrates:
- **Closures**: Using lambdas for validation rules and filters
- **Object Model**: Understanding self, inheritance, and singleton methods
- **Mixins**: Sharing behavior across classes with modules
- **Metaprogramming**: Dynamic method creation and method_missing
- **Error Handling**: Custom exceptions and retry logic
- **Idiomatic Ruby**: Enumerable, duck typing, and Ruby patterns

## 📋 Project Structure

```
intermediate-lab/
├── README.md (this file)
├── blog_system.rb (main application)
├── lib/
│   ├── models/
│   │   ├── post.rb
│   │   ├── comment.rb
│   │   └── user.rb
│   ├── concerns/
│   │   ├── timestampable.rb
│   │   ├── validatable.rb
│   │   └── sluggable.rb
│   ├── database/
│   │   └── query_builder.rb
│   └── errors/
│       └── custom_errors.rb
└── spec/ (tests - optional)
```

## 🚀 Running the Lab

```bash
cd ruby/labs/intermediate-lab
ruby blog_system.rb
```

## 🎓 Concepts Demonstrated

### 1. Blocks, Procs, and Lambdas (Tutorial 11)
- Validation rules using lambdas
- Filter and search operations with procs
- Iterator methods with blocks
- Callback system using closures

### 2. Ruby Object Model (Tutorial 12)
- Class hierarchy and inheritance
- Singleton methods for class-level operations
- Understanding self in different contexts
- Method lookup chain

### 3. Mixins and Modules (Tutorial 13)
- Timestampable concern (include)
- Validatable concern (include + extend)
- Sluggable concern (prepend for method override)
- Module composition patterns

### 4. Metaprogramming (Tutorial 14)
- Dynamic finder methods (find_by_*)
- Attribute system with define_method
- method_missing for query builder
- DSL for validation rules

### 5. Error Handling (Tutorial 15)
- Custom exception hierarchy
- Retry logic with exponential backoff
- Error context and logging
- Graceful error recovery

### 6. Idiomatic Ruby (Tutorial 16)
- Enumerable methods everywhere
- Method chaining for queries
- Duck typing for flexibility
- Memoization for performance
- Safe navigation operators

## 📝 Features Implemented

1. **User Management**
   - Create and manage users
   - Validation with custom rules
   - Memoized queries

2. **Post Management**
   - Create, update, and delete posts
   - Automatic slug generation
   - Timestamps and metadata
   - Full-text search

3. **Comment System**
   - Nested comments
   - Comment threading
   - Moderation capabilities

4. **Query Builder**
   - Chainable query interface
   - Dynamic finder methods
   - Sorting and filtering

5. **Validation Framework**
   - Custom validation rules
   - Composable validators
   - Error messages

## 🔍 Key Code Examples

### Dynamic Finders (Metaprogramming)
```ruby
Post.find_by_title("Hello World")
Post.find_all_by_author("Alice")
User.find_by_email("alice@example.com")
```

### Chainable Queries (Idiomatic Ruby)
```ruby
Post.where(published: true)
    .where { |p| p.view_count > 100 }
    .order_by(:created_at)
    .limit(10)
```

### Validation DSL (Metaprogramming + Closures)
```ruby
class Post
  validates :title, presence: true, length: { min: 5 }
  validates :content, presence: true
  validates :author, ->(value) { User.exists?(value) }
end
```

### Mixins for Shared Behavior
```ruby
class Post
  include Timestampable  # Adds created_at, updated_at
  include Validatable    # Adds validation framework
  include Sluggable      # Adds slug generation
end
```

## 🐍 For Python Developers

This lab demonstrates patterns you might implement with:
- **SQLAlchemy**: Our query builder and ORM-like interface
- **Django Models**: Validation and concern patterns
- **Decorators**: Ruby mixins and metaprogramming
- **List Comprehensions**: Ruby's enumerable methods

## 🎯 Challenges

Try extending the system with:
1. Add a tagging system for posts
2. Implement full-text search using closures
3. Add a caching layer with memoization
4. Create a plugin system with metaprogramming
5. Build a permission system with modules

## 📚 What You'll Learn

After completing this lab, you'll understand:
- How to structure a Ruby application
- When to use each intermediate concept
- How Rails and other frameworks work internally
- Production-ready Ruby patterns
- The Ruby philosophy: elegant, expressive code

---

Ready to dive in? Open `blog_system.rb` and start exploring!
