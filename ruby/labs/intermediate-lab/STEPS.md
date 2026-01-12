# Progressive Learning Guide: Blog Management System

This guide breaks down the blog management system into progressive steps. Build the system incrementally, learning new concepts at each step.

## 🎯 Overview

You'll build a complete blog management system by following these 6 progressive steps:

1. **Step 1**: Basic Models - Create User, Post, Comment classes
2. **Step 2**: Add Timestamps - Include module for created_at/updated_at
3. **Step 3**: Add Validation - Use lambdas and closures for validation rules
4. **Step 4**: Add Slugs - Use prepend for automatic slug generation
5. **Step 5**: Add Metaprogramming - Dynamic finder methods
6. **Step 6**: Add Query Builder - Chainable query interface

## ⏱️ Estimated Time

- Each step: 20-30 minutes
- Total: 2-3 hours

---

## Step 1: Basic Models (Concepts: Classes, Inheritance)

### 🎯 Learning Focus
- Define basic classes with attributes
- Implement simple instance methods
- Use arrays for relationships

### 📝 Tasks

1. **Create the User class** (`lib/models/user.rb`):
   ```ruby
   class User
     attr_accessor :id, :name, :email

     def initialize(name:, email:)
       @id = generate_id
       @name = name
       @email = email
     end

     def to_s
       "User(#{@id}): #{@name} <#{@email}>"
     end

     private

     def generate_id
       "user_#{Time.now.to_i}_#{rand(1000)}"
     end
   end
   ```

2. **Create the Post class** (`lib/models/post.rb`):
   ```ruby
   class Post
     attr_accessor :id, :title, :content, :author, :published

     def initialize(title:, content:, author:)
       @id = generate_id
       @title = title
       @content = content
       @author = author  # User object
       @published = false
     end

     def publish
       @published = true
     end

     def unpublish
       @published = false
     end

     def to_s
       status = @published ? "Published" : "Draft"
       "Post(#{@id}): #{@title} by #{@author.name} [#{status}]"
     end

     private

     def generate_id
       "post_#{Time.now.to_i}_#{rand(1000)}"
     end
   end
   ```

3. **Create the Comment class** (`lib/models/comment.rb`):
   ```ruby
   class Comment
     attr_accessor :id, :content, :author, :post

     def initialize(content:, author:, post:)
       @id = generate_id
       @content = content
       @author = author  # User object
       @post = post      # Post object
     end

     def to_s
       "Comment(#{@id}) by #{@author.name}: #{@content[0...30]}..."
     end

     private

     def generate_id
       "comment_#{Time.now.to_i}_#{rand(1000)}"
     end
   end
   ```

4. **Test your models**:
   ```ruby
   # Test in IRB or create test_step1.rb
   require_relative 'lib/models/user'
   require_relative 'lib/models/post'
   require_relative 'lib/models/comment'

   # Create users
   alice = User.new(name: "Alice", email: "alice@example.com")
   bob = User.new(name: "Bob", email: "bob@example.com")

   # Create posts
   post1 = Post.new(title: "Hello Ruby", content: "My first post", author: alice)
   post1.publish

   # Create comments
   comment1 = Comment.new(content: "Great post!", author: bob, post: post1)

   puts alice
   puts post1
   puts comment1
   ```

### ✅ Checkpoint
- [ ] All three model classes work independently
- [ ] IDs are generated automatically
- [ ] `to_s` methods display useful information
- [ ] Objects can reference each other (author, post)

---

## Step 2: Add Timestamps (Concepts: Mixins, Modules)

### 🎯 Learning Focus
- Create reusable modules
- Use `include` to add module methods
- Understand module composition

### 📝 Tasks

1. **Create Timestampable module** (`lib/concerns/timestampable.rb`):
   ```ruby
   module Timestampable
     def self.included(base)
       base.class_eval do
         attr_reader :created_at, :updated_at
       end
     end

     def initialize(*args, **kwargs)
       super(*args, **kwargs) if defined?(super)
       @created_at = Time.now
       @updated_at = Time.now
     end

     def touch
       @updated_at = Time.now
     end

     def age_in_seconds
       Time.now - @created_at
     end

     def recently_updated?(seconds = 60)
       Time.now - @updated_at < seconds
     end
   end
   ```

2. **Include Timestampable in your models**:
   ```ruby
   # In each model file, add:
   require_relative '../concerns/timestampable'

   class User
     include Timestampable
     # ... rest of the class
   end
   ```

3. **Update to_s methods** to show timestamps:
   ```ruby
   def to_s
     "Post(#{@id}): #{@title} by #{@author.name} [Created: #{@created_at.strftime('%Y-%m-%d')}]"
   end
   ```

4. **Test timestamps**:
   ```ruby
   user = User.new(name: "Alice", email: "alice@example.com")
   puts "Created at: #{user.created_at}"

   sleep(2)
   user.touch
   puts "Updated at: #{user.updated_at}"
   puts "Recently updated? #{user.recently_updated?}"
   ```

### ✅ Checkpoint
- [ ] All models have created_at and updated_at
- [ ] Timestamps are set automatically on creation
- [ ] `touch` method updates the updated_at timestamp
- [ ] Helper methods like `age_in_seconds` work

---

## Step 3: Add Validation (Concepts: Lambdas, Closures, Metaprogramming Basics)

### 🎯 Learning Focus
- Create validation framework with lambdas
- Use `class_eval` to add validation DSL
- Understand closures and procs

### 📝 Tasks

1. **Create Validatable module** (`lib/concerns/validatable.rb`):
   ```ruby
   module Validatable
     def self.included(base)
       base.extend(ClassMethods)
       base.class_eval do
         attr_reader :errors
       end
     end

     module ClassMethods
       def validations
         @validations ||= []
       end

       def validates(attribute, rules)
         validations << { attribute: attribute, rules: rules }
       end
     end

     def initialize(*args, **kwargs)
       super(*args, **kwargs) if defined?(super)
       @errors = {}
     end

     def valid?
       @errors = {}
       self.class.validations.each do |validation|
         attribute = validation[:attribute]
         rules = validation[:rules]
         value = send(attribute)

         validate_presence(attribute, value, rules[:presence]) if rules[:presence]
         validate_length(attribute, value, rules[:length]) if rules[:length]
         validate_format(attribute, value, rules[:format]) if rules[:format]
         validate_custom(attribute, value, rules[:custom]) if rules[:custom]
       end
       @errors.empty?
     end

     def valid!
       raise ValidationError, error_messages.join(", ") unless valid?
     end

     def error_messages
       @errors.map { |attr, msgs| "#{attr}: #{msgs.join(', ')}" }
     end

     private

     def add_error(attribute, message)
       @errors[attribute] ||= []
       @errors[attribute] << message
     end

     def validate_presence(attribute, value, required)
       add_error(attribute, "can't be blank") if required && (value.nil? || value.to_s.strip.empty?)
     end

     def validate_length(attribute, value, rules)
       return if value.nil?
       if rules[:min] && value.to_s.length < rules[:min]
         add_error(attribute, "must be at least #{rules[:min]} characters")
       end
       if rules[:max] && value.to_s.length > rules[:max]
         add_error(attribute, "must be at most #{rules[:max]} characters")
       end
     end

     def validate_format(attribute, value, regex)
       return if value.nil?
       add_error(attribute, "is invalid") unless value.to_s.match?(regex)
     end

     def validate_custom(attribute, value, lambda_proc)
       result = lambda_proc.call(value)
       add_error(attribute, "is invalid") unless result
     end
   end
   ```

2. **Create custom error class** (`lib/errors/custom_errors.rb`):
   ```ruby
   class ValidationError < StandardError; end
   class NotFoundError < StandardError; end
   class UnauthorizedError < StandardError; end
   ```

3. **Add validations to models**:
   ```ruby
   class User
     include Timestampable
     include Validatable

     validates :name, presence: true, length: { min: 2, max: 50 }
     validates :email, presence: true, format: /@/

     # ... rest of class
   end

   class Post
     include Timestampable
     include Validatable

     validates :title, presence: true, length: { min: 5, max: 200 }
     validates :content, presence: true, length: { min: 10 }
     validates :author, presence: true

     # ... rest of class
   end
   ```

4. **Test validation**:
   ```ruby
   user = User.new(name: "A", email: "invalid")
   puts user.valid?  # => false
   puts user.error_messages

   valid_user = User.new(name: "Alice", email: "alice@example.com")
   puts valid_user.valid?  # => true
   ```

### ✅ Checkpoint
- [ ] Validation framework works
- [ ] Can define validation rules on models
- [ ] `valid?` checks all validations
- [ ] Error messages are collected properly

---

## Step 4: Add Slugs (Concepts: Prepend, Method Override)

### 🎯 Learning Focus
- Use `prepend` to override methods
- Understand method lookup chain
- Automatic attribute generation

### 📝 Tasks

1. **Create Sluggable module** (`lib/concerns/sluggable.rb`):
   ```ruby
   module Sluggable
     def self.included(base)
       base.class_eval do
         attr_reader :slug
       end
     end

     def title=(new_title)
       super(new_title) if defined?(super)
       @slug = generate_slug(new_title)
     end

     def initialize(*args, **kwargs)
       super(*args, **kwargs) if defined?(super)
       @slug = generate_slug(@title) if @title
     end

     private

     def generate_slug(text)
       return "" if text.nil?
       text.downcase
           .strip
           .gsub(/[^\w\s-]/, '')   # Remove special characters
           .gsub(/\s+/, '-')        # Replace spaces with hyphens
           .gsub(/-+/, '-')         # Remove duplicate hyphens
     end
   end
   ```

2. **Add Sluggable to Post**:
   ```ruby
   class Post
     include Timestampable
     include Validatable
     include Sluggable

     # ... rest of class
   end
   ```

3. **Test slug generation**:
   ```ruby
   post = Post.new(title: "Hello Ruby World!", content: "Content", author: alice)
   puts post.slug  # => "hello-ruby-world"

   post.title = "New Title Here"
   puts post.slug  # => "new-title-here"
   ```

### ✅ Checkpoint
- [ ] Slugs are generated automatically from titles
- [ ] Slugs update when title changes
- [ ] Slug format is URL-friendly (lowercase, hyphens)

---

## Step 5: Add Metaprogramming (Concepts: method_missing, define_method)

### 🎯 Learning Focus
- Dynamic method generation
- `method_missing` for flexible APIs
- Class-level methods

### 📝 Tasks

1. **Add dynamic finders to models**:
   ```ruby
   # Add this to each model class
   class << self
     def all
       @all ||= []
     end

     def create(**attributes)
       instance = new(**attributes)
       all << instance if instance.valid?
       instance
     end

     def find_by(attribute, value)
       all.find { |instance| instance.send(attribute) == value }
     end

     def method_missing(method_name, *args)
       if method_name.to_s.start_with?('find_by_')
         attribute = method_name.to_s.sub('find_by_', '')
         find_by(attribute.to_sym, args.first)
       elsif method_name.to_s.start_with?('find_all_by_')
         attribute = method_name.to_s.sub('find_all_by_', '')
         all.select { |instance| instance.send(attribute) == args.first }
       else
         super
       end
     end

     def respond_to_missing?(method_name, include_private = false)
       method_name.to_s.start_with?('find_by_', 'find_all_by_') || super
     end
   end
   ```

2. **Test dynamic finders**:
   ```ruby
   alice = User.create(name: "Alice", email: "alice@example.com")
   bob = User.create(name: "Bob", email: "bob@example.com")

   # Dynamic finders
   user = User.find_by_email("alice@example.com")
   posts = Post.find_all_by_author(alice)

   puts "Found: #{user}"
   ```

### ✅ Checkpoint
- [ ] `find_by_*` methods work dynamically
- [ ] `find_all_by_*` methods work dynamically
- [ ] `.create` method adds to collection
- [ ] `.all` returns all instances

---

## Step 6: Add Query Builder (Concepts: Method Chaining, Lazy Evaluation)

### 🎯 Learning Focus
- Chainable query interface
- Lazy evaluation patterns
- Builder pattern

### 📝 Tasks

1. **Create QueryBuilder** (`lib/database/query_builder.rb`):
   ```ruby
   class QueryBuilder
     def initialize(collection)
       @collection = collection
       @conditions = []
       @order_attr = nil
       @order_dir = :asc
       @limit_count = nil
     end

     def where(conditions = nil, &block)
       if block_given?
         @conditions << block
       elsif conditions.is_a?(Hash)
         @conditions << ->(item) {
           conditions.all? { |attr, value| item.send(attr) == value }
         }
       end
       self
     end

     def order_by(attribute, direction = :asc)
       @order_attr = attribute
       @order_dir = direction
       self
     end

     def limit(count)
       @limit_count = count
       self
     end

     def execute
       result = @collection

       # Apply conditions
       @conditions.each do |condition|
         result = result.select(&condition)
       end

       # Apply ordering
       if @order_attr
         result = result.sort_by { |item| item.send(@order_attr) }
         result = result.reverse if @order_dir == :desc
       end

       # Apply limit
       result = result.first(@limit_count) if @limit_count

       result
     end

     def first
       execute.first
     end

     def all
       execute
     end

     def count
       execute.length
     end
   end
   ```

2. **Add query methods to models**:
   ```ruby
   class << self
     def where(conditions = nil, &block)
       QueryBuilder.new(all).where(conditions, &block)
     end

     def order_by(attribute, direction = :asc)
       QueryBuilder.new(all).order_by(attribute, direction)
     end
   end
   ```

3. **Test query builder**:
   ```ruby
   # Chainable queries
   published_posts = Post.where(published: true)
                         .order_by(:created_at, :desc)
                         .limit(5)
                         .all

   recent_posts = Post.where { |p| p.age_in_seconds < 3600 }
                      .order_by(:created_at, :desc)
                      .all
   ```

### ✅ Checkpoint
- [ ] Can chain `where`, `order_by`, `limit`
- [ ] `where` accepts hash or block
- [ ] Queries are lazy (execute only when needed)
- [ ] `first`, `all`, `count` trigger execution

---

## 🎉 Completion

### Final Integration

Run the complete system (`blog_system.rb`):

```bash
ruby blog_system.rb
```

### What You've Learned

- ✅ Building classes with proper structure
- ✅ Using mixins for shared behavior
- ✅ Creating validation frameworks with lambdas
- ✅ Automatic attribute generation
- ✅ Dynamic method generation
- ✅ Query builder with method chaining
- ✅ How Rails and similar frameworks work internally

### Next Steps

Ready for advanced Ruby? → [Advanced Labs](../advanced/README.md)
