# Step 7: Tagging System

**Estimated Time:** 20 minutes

[← Previous Step](../6/README.md) | [Next Step →](../8/README.md)

---

## 🎯 Goal

Implement a many-to-many tagging system for posts.

## 📝 Tasks

### 1. Create Tag model (`lib/models/tag.rb`)

```ruby
class Tag < ActiveRecord::Base
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true
end
```

### 2. Create PostTag join model (`lib/models/post_tag.rb`)

```ruby
class PostTag < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag
end
```

### 3. Update Post model

Add to `lib/models/post.rb`:

```ruby
class Post < ActiveRecord::Base
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # ... rest of code

  def as_json(options = {})
    super(options.merge(
      include: {
        user: { only: [:id, :name, :email] },
        tags: { only: [:id, :name] }
      }
    ))
  end
end
```

### 4. Create tables (add to `db/migrate.rb`)

```ruby
# Tags table
ActiveRecord::Base.connection.create_table :tags, force: true do |t|
  t.string :name, null: false
  t.timestamps
end
ActiveRecord::Base.connection.add_index :tags, :name, unique: true

# Join table
ActiveRecord::Base.connection.create_table :post_tags, force: true do |t|
  t.references :post, foreign_key: true
  t.references :tag, foreign_key: true
  t.timestamps
end
ActiveRecord::Base.connection.add_index :post_tags, [:post_id, :tag_id], unique: true

puts "✓ Tags and post_tags tables created"
```

Run the migration:
```bash
ruby db/migrate.rb
```

### 5. Load models in app.rb

```ruby
require_relative 'lib/models/tag'
require_relative 'lib/models/post_tag'
```

### 6. Add tag routes

```ruby
# List all tags
get '/api/v1/tags' do
  tags = Tag.all
  tags.to_json
end

# Get posts for a tag
get '/api/v1/tags/:id/posts' do
  tag = Tag.find_by(id: params[:id])
  halt 404, { error: 'Tag not found' }.to_json unless tag

  posts = tag.posts.includes(:user).recent
  posts.to_json
end

# Update post creation to handle tags
# Modify existing POST /api/v1/posts route:
post '/api/v1/posts' do
  authenticate!

  data = JSON.parse(request.body.read)
  post = current_user.posts.new(
    title: data['title'],
    content: data['content'],
    published: data['published'] || false
  )

  if post.save
    # Handle tags
    if data['tags'].is_a?(Array)
      data['tags'].each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name.strip.downcase)
        post.tags << tag unless post.tags.include?(tag)
      end
    end

    status 201
    post.to_json
  else
    status 422
    { errors: post.errors.full_messages }.to_json
  end
end
```

### 7. Test the endpoints

```bash
# Create post with tags
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title":"Tagged Post","content":"Content here","tags":["ruby","sinatra","api"]}'

# List all tags
curl http://localhost:4567/api/v1/tags

# Get posts for a tag
curl http://localhost:4567/api/v1/tags/1/posts
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Can create posts with tags
- [ ] Tags are created automatically if they don't exist
- [ ] Can list all tags
- [ ] Can get all posts for a specific tag
- [ ] Posts include tags in JSON response
- [ ] Tags are case-insensitive and trimmed

## 🎓 What You Learned

- Many-to-many relationships with `has_many :through`
- Join tables (post_tags)
- Using `find_or_create_by` for tag management
- Complex JSON serialization with multiple associations
- Preventing duplicate associations

## 🔍 Many-to-Many Relationship

```
Post (N) ←→ post_tags (join table) ←→ (N) Tag

Post has_many tags through post_tags
Tag has_many posts through post_tags
```

## 💡 Tips

- Normalize tag names (lowercase, trim whitespace)
- Use `find_or_create_by` to avoid duplicates
- Join tables enable many-to-many relationships
- Add unique index on join table to prevent duplicates

---

[← Previous: Comments System](../6/README.md) | [Next: Pagination →](../8/README.md)
