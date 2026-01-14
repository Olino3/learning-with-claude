# Step 5: Post Model and CRUD

**Estimated Time:** 35 minutes

[← Previous Step](../4/README.md) | [Next Step →](../6/README.md)

---

## 🎯 Goal

Create blog posts with full CRUD operations and user associations.

## 📝 Tasks

### 1. Create Post model (`lib/models/post.rb`)

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

### 2. Create posts table (add to `db/migrate.rb`)

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

Run the migration:
```bash
ruby db/migrate.rb
```

### 3. Update User model

Add the association to `lib/models/user.rb`:

```ruby
class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  
  # ... rest of code
end
```

### 4. Load Post model in app.rb

```ruby
require_relative 'lib/models/user'
require_relative 'lib/models/post'
```

### 5. Add Post routes to app.rb

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

### 6. Test the endpoints

```bash
# Create post (requires auth token)
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title":"My First Post","content":"This is the content of my first post.","published":true}'

# List all posts
curl http://localhost:4567/api/v1/posts

# Get single post
curl http://localhost:4567/api/v1/posts/1

# Update post
curl -X PUT http://localhost:4567/api/v1/posts/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title":"Updated Title"}'

# Delete post
curl -X DELETE http://localhost:4567/api/v1/posts/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Can list all posts with user information
- [ ] Can get single post with user info
- [ ] Can create posts (authenticated users only)
- [ ] Can update own posts
- [ ] Can delete own posts
- [ ] Authorization works (can't edit others' posts)
- [ ] Validation prevents invalid posts

## 🎓 What You Learned

- Creating model associations (`belongs_to`, `has_many`)
- Using scopes for common queries
- Eager loading with `includes()` to prevent N+1 queries
- Authorization (users can only edit their own posts)
- RESTful API endpoints (GET, POST, PUT, DELETE)
- HTTP status codes (200, 201, 204, 403, 404, 422)
- JSON serialization with associations

## 🔍 RESTful Routes

```ruby
GET    /api/v1/posts        # List all
GET    /api/v1/posts/:id    # Get one
POST   /api/v1/posts        # Create (auth)
PUT    /api/v1/posts/:id    # Update (auth)
DELETE /api/v1/posts/:id    # Delete (auth)
```

## 💡 Tips

- Use `includes()` to avoid N+1 query problems
- Always check authorization (not just authentication)
- Return 204 No Content for successful DELETE
- Use scopes for readable, reusable queries

---

[← Previous: JWT Authentication](../4/README.md) | [Next: Comments System →](../6/README.md)
