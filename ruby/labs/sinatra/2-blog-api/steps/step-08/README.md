# Step 8: Pagination

This step adds pagination to list endpoints.

## What's Included
- Pagination helper method
- Page and per_page parameters
- Pagination metadata in responses
- Applied to posts and tag-posts endpoints

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
# Get first page of posts (default: 10 per page)
curl http://localhost:4567/api/v1/posts

# Get specific page
curl "http://localhost:4567/api/v1/posts?page=2"

# Customize per_page (max 100)
curl "http://localhost:4567/api/v1/posts?page=1&per_page=5"

# Paginated tag posts
curl "http://localhost:4567/api/v1/tags/1/posts?page=1&per_page=3"
```

## Response Format
```json
{
  "posts": [...],
  "meta": {
    "page": 1,
    "per_page": 10,
    "total": 25,
    "total_pages": 3
  }
}
```
