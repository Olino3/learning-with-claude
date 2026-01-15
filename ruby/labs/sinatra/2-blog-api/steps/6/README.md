# Step 6: Comments System

**Estimated Time:** 25 minutes

[← Previous Step](../5/README.md) | [Next Step →](../7/README.md)

---

## 🎯 Goal

Add nested comments on posts with full CRUD operations.

## 📝 Tasks

### 1. Create Comment model (`lib/models/comment.rb`)

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

### 2. Create comments table (add to `db/migrate.rb`)

```ruby
ActiveRecord::Base.connection.create_table :comments, force: true do |t|
  t.text :content, null: false
  t.references :user, foreign_key: true
  t.references :post, foreign_key: true
  t.timestamps
end

puts "✓ Comments table created"
```

Run the migration:
```bash
ruby db/migrate.rb
```

### 3. Update Post and User models

**In `lib/models/post.rb`:**
```ruby
class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  # ... rest of code
end
```

**In `lib/models/user.rb`:**
```ruby
class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  # ... rest of code
end
```

### 4. Load Comment model in app.rb

```ruby
require_relative 'lib/models/comment'
```

### 5. Add comment routes

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

### 6. Test the endpoints

```bash
# Get post comments
curl http://localhost:4567/api/v1/posts/1/comments

# Create comment
curl -X POST http://localhost:4567/api/v1/posts/1/comments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"content":"Great post!"}'

# Update comment
curl -X PUT http://localhost:4567/api/v1/comments/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"content":"Updated comment"}'

# Delete comment
curl -X DELETE http://localhost:4567/api/v1/comments/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Can list post comments
- [ ] Can create comments on posts
- [ ] Can update own comments
- [ ] Can delete own comments
- [ ] Comments include user information
- [ ] Authorization works (can't edit others' comments)

## 🎓 What You Learned

- Creating nested resources (comments belong to posts)
- Multiple `belongs_to` associations
- Nested routes (`/posts/:id/comments`)
- Cascading deletes with `dependent: :destroy`
- Complex authorization (comments on posts)

## 🔍 Comment Routes

```ruby
GET    /api/v1/posts/:id/comments  # List post comments
POST   /api/v1/posts/:id/comments  # Create comment
PUT    /api/v1/comments/:id        # Update comment
DELETE /api/v1/comments/:id        # Delete comment
```

## 💡 Tips

- Nest resources that belong to a parent (comments to posts)
- Use `dependent: :destroy` to clean up associated records
- Always validate nested resources exist
- Consider adding moderation features for production

---

[← Previous: Post Model and CRUD](../5/README.md) | [Next: Tagging System →](../7/README.md)
