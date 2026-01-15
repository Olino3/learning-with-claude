# Step 6: Comments System

This step adds nested comments on posts.

## What's Included
- Comment model with validations
- List comments on a post
- Create comments (authenticated)
- Update own comments
- Delete own comments

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
# Get post comments
curl http://localhost:4567/api/v1/posts/1/comments

# Create comment
curl -X POST http://localhost:4567/api/v1/posts/1/comments \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content":"This is my comment"}'
```
