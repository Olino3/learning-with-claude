# Blog API - Complete Solution

A RESTful JSON API built with Sinatra and ActiveRecord, featuring JWT authentication, blog posts, comments, and tags.

## Features

- JWT authentication (register, login, protected routes)
- CRUD operations for posts
- Comment system
- Tagging with many-to-many relationships
- Pagination
- Search and filtering

## Run the App

### Prerequisites

```bash
# Navigate to solution folder and install dependencies
cd solution
bundle install
```

### Start the Server

```bash
ruby app.rb
```

The API will be available at `http://localhost:4567`

## API Endpoints

### Authentication

```bash
# Register new user
curl -X POST http://localhost:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123", "name": "Test User"}'

# Login
curl -X POST http://localhost:4567/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "alice@example.com", "password": "password123"}'

# Get current user (requires auth)
curl http://localhost:4567/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Posts

```bash
# List all posts
curl http://localhost:4567/api/v1/posts

# Get single post
curl http://localhost:4567/api/v1/posts/1

# Create post (requires auth)
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title": "My Post", "content": "Post content here", "published": true, "tags": ["ruby", "sinatra"]}'

# Update post (requires auth)
curl -X PUT http://localhost:4567/api/v1/posts/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title": "Updated Title"}'

# Delete post (requires auth)
curl -X DELETE http://localhost:4567/api/v1/posts/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Comments

```bash
# Get comments for a post
curl http://localhost:4567/api/v1/posts/1/comments

# Add comment (requires auth)
curl -X POST http://localhost:4567/api/v1/posts/1/comments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"content": "Great post!"}'
```

### Tags

```bash
# List all tags
curl http://localhost:4567/api/v1/tags

# Get posts by tag
curl http://localhost:4567/api/v1/tags/1/posts
```

### Filtering & Pagination

```bash
# Filter by tag
curl "http://localhost:4567/api/v1/posts?tag=ruby"

# Filter by user
curl "http://localhost:4567/api/v1/posts?user_id=1"

# Search posts
curl "http://localhost:4567/api/v1/posts?search=sinatra"

# Paginate
curl "http://localhost:4567/api/v1/posts?page=2&per_page=5"
```

## Sample Data

The app seeds itself with:
- 2 users (alice@example.com, bob@example.com - password: password123)
- 2 sample posts with tags
- 1 sample comment

## Project Structure

```
solution/
├── app.rb              # Main application
├── Gemfile             # Dependencies
├── config.ru           # Rack config
└── lib/
    ├── auth.rb         # JWT authentication helpers
    ├── serializers.rb  # JSON serialization
    └── models/
        ├── user.rb     # User model
        ├── post.rb     # Post model
        ├── comment.rb  # Comment model
        └── tag.rb      # Tag model
```
