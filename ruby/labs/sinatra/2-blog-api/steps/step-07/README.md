# Step 7: Tagging System

This step adds many-to-many relationships with tags.

## What's Included
- Tag model with validations
- Post-Tag many-to-many relationship (post_tags join table)
- List all tags
- Filter posts by tag
- Add/update tags when creating/updating posts

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
# List all tags
curl http://localhost:4567/api/v1/tags

# Get posts by tag
curl http://localhost:4567/api/v1/tags/1/posts

# Filter posts by tag name
curl http://localhost:4567/api/v1/posts?tag=ruby

# Create post with tags
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Tagged Post","content":"Content here","tags":["ruby","sinatra"]}'
```
