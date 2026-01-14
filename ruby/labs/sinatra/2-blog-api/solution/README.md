# Solution: Blog API

This directory contains the complete, working solution for the Blog API lab.

## Running the Solution

```bash
make sinatra-lab NUM=2
```

The complete API will start at http://localhost:4567

## What's Included

The solution includes all features from the 9-step tutorial:

✅ RESTful JSON API design  
✅ PostgreSQL database with ActiveRecord  
✅ User authentication with JWT  
✅ Post CRUD operations  
✅ Nested comments system  
✅ Tag associations (many-to-many)  
✅ Pagination for large datasets  
✅ Centralized error handling  
✅ Password hashing with BCrypt  

## Key Files

- `app.rb` - Main Sinatra API application
- `config/database.rb` - Database configuration
- `lib/models/` - ActiveRecord models (User, Post, Comment, Tag)
- `lib/auth.rb` - JWT authentication helpers
- `lib/serializers.rb` - JSON serialization

## API Endpoints

### Authentication
- `POST /api/v1/register` - Create new user account
- `POST /api/v1/login` - Login and get JWT token

### Posts
- `GET /api/v1/posts` - List all posts (with pagination)
- `POST /api/v1/posts` - Create new post (auth required)
- `GET /api/v1/posts/:id` - Get single post
- `PUT /api/v1/posts/:id` - Update post (author only)
- `DELETE /api/v1/posts/:id` - Delete post (author only)

### Comments
- `GET /api/v1/posts/:id/comments` - List post comments
- `POST /api/v1/posts/:id/comments` - Create comment (auth required)
- `PUT /api/v1/comments/:id` - Update comment (author only)
- `DELETE /api/v1/comments/:id` - Delete comment (author only)

### Tags
- `GET /api/v1/tags` - List all tags
- `GET /api/v1/tags/:name/posts` - Get posts by tag

## Testing the API

### Register a User
```bash
curl -X POST http://localhost:4567/api/v1/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"secret123","name":"Test User"}'
```

### Login
```bash
curl -X POST http://localhost:4567/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"secret123"}'
```

### Create a Post (with JWT token)
```bash
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"title":"My First Post","content":"Hello World!","tags":["ruby","sinatra"]}'
```

### Get All Posts
```bash
curl http://localhost:4567/api/v1/posts?page=1&per_page=10
```

## Database Schema

### users
- Email, password_digest, name
- Has many posts and comments

### posts
- Title, content, author (user_id)
- Belongs to user
- Has many comments and tags

### comments
- Content, author (user_id), post_id
- Belongs to user and post

### tags
- Name
- Has many posts through post_tags

## Authentication Flow

1. User registers with email/password
2. Password is hashed with BCrypt
3. User logs in with credentials
4. Server generates JWT token
5. Client includes token in Authorization header
6. Server verifies token on protected routes

## Learning Outcomes

By studying this solution, you'll understand:

1. **API Design**
   - RESTful endpoint structure
   - JSON request/response format
   - API versioning (v1)

2. **Authentication**
   - JWT token generation and verification
   - BCrypt password hashing
   - Authorization middleware

3. **Database Relations**
   - One-to-many (users → posts)
   - Many-to-many (posts ↔ tags)
   - Nested resources (posts → comments)

4. **Best Practices**
   - Error handling and status codes
   - Input validation
   - Pagination for performance
   - Custom serialization

## Next Steps

Once you've reviewed the solution:

1. Try extending it:
   - Add post categories
   - Implement post likes/reactions
   - Add comment replies (threading)
   - Full-text search

2. Test with tools:
   - Use Postman or Insomnia
   - Write automated tests
   - Try different API clients

3. Move to the next lab:
   - [Lab 3: Authentication Web App](../../3-auth-app/steps/1/README.md)
