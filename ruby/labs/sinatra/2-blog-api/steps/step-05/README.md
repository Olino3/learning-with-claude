# Step 5: Post Model and CRUD

This step adds Post model with full CRUD operations.

## What's Included
- Post model with validations
- List all posts
- Get single post
- Create post (authenticated)
- Update own posts
- Delete own posts

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
# List posts
curl http://localhost:4567/api/v1/posts

# Get single post
curl http://localhost:4567/api/v1/posts/1

# Create post (authenticated)
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"New Post Title","content":"This is the post content.","published":true}'
```
