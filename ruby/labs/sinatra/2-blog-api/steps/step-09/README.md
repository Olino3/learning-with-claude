# Step 9: Error Handling & Polish

This is the complete Blog API with standardized error responses and CORS support.

## What's Included
- CORS headers for cross-origin requests
- Standardized error responses
- 404 and 500 error handlers
- User profile endpoints
- Search functionality
- Post owner can delete comments on their posts
- Access control for unpublished posts

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
# API root - shows all endpoints
curl http://localhost:4567/

# Search posts
curl "http://localhost:4567/api/v1/posts?search=sinatra"

# Get user profile with stats
curl http://localhost:4567/api/v1/users/1

# Get user's posts
curl http://localhost:4567/api/v1/users/1/posts

# Test 404 error
curl http://localhost:4567/api/v1/posts/999

# Test invalid endpoint
curl http://localhost:4567/api/v1/invalid
```

## Features
- JWT authentication
- CRUD operations for posts
- Nested comments
- Many-to-many tagging
- Pagination
- Search functionality
- User profiles
- CORS support
- Standardized error responses
