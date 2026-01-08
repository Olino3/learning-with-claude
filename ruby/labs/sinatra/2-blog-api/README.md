# Sinatra Lab 2: Blog API with Database

A RESTful blog API demonstrating advanced Sinatra concepts with PostgreSQL, JWT authentication, and API design best practices.

## 🎯 Learning Objectives

This lab demonstrates:
- **RESTful API Design**: Building a JSON API following REST principles
- **Database Integration**: PostgreSQL with ActiveRecord ORM
- **Authentication**: JWT (JSON Web Tokens) for stateless auth
- **API Versioning**: Proper API versioning strategy (v1)
- **Error Handling**: Standardized error responses
- **Validation**: Model validations and error messages
- **Associations**: Complex model relationships (users, posts, comments, tags)
- **Pagination**: Efficient data pagination for large datasets
- **JSON Serialization**: Custom JSON responses

## 📋 Project Structure

```
2-blog-api/
├── README.md (this file)
├── app.rb (main Sinatra API application)
├── config/
│   └── database.rb (database configuration)
├── lib/
│   ├── models/
│   │   ├── user.rb (user model with authentication)
│   │   ├── post.rb (blog post model)
│   │   ├── comment.rb (comment model)
│   │   └── tag.rb (tag model)
│   ├── auth.rb (JWT authentication helpers)
│   └── serializers.rb (JSON serialization)
└── db/
    └── seeds.rb (sample data for testing)
```

## 🚀 Running the Lab

```bash
# Install dependencies
gem install sinatra activerecord pg jwt bcrypt

# Set up PostgreSQL database
createdb blog_api_dev

# Run migrations (will be created automatically on first run)
# Or use the provided setup script

# Run the application
cd ruby/labs/sinatra/2-blog-api
ruby app.rb

# API will be available at http://localhost:4567
```

## 🎓 Features Implemented

### 1. User Authentication (JWT)
- User registration with email validation
- Login with password verification (BCrypt)
- JWT token generation and verification
- Protected routes requiring authentication

### 2. Blog Posts (CRUD)
- Create posts (authenticated users only)
- Read posts (public access)
- Update posts (author only)
- Delete posts (author only)
- Search and filter posts
- Pagination support

### 3. Comments System
- Add comments to posts
- Nested comment structure
- Edit/delete own comments
- Moderation capabilities

### 4. Tagging System
- Add tags to posts
- Query posts by tag
- Popular tags endpoint
- Tag statistics

### 5. API Features
- JSON responses with proper HTTP status codes
- Error handling with detailed messages
- Request validation
- Rate limiting (concept)
- API versioning (/api/v1)

## 🔍 API Endpoints

### Authentication
```
POST   /api/v1/auth/register    # Register new user
POST   /api/v1/auth/login       # Login and get JWT token
GET    /api/v1/auth/me          # Get current user info
```

### Posts
```
GET    /api/v1/posts            # List all posts (paginated)
GET    /api/v1/posts/:id        # Get single post
POST   /api/v1/posts            # Create post (auth required)
PUT    /api/v1/posts/:id        # Update post (auth required)
DELETE /api/v1/posts/:id        # Delete post (auth required)
GET    /api/v1/posts/:id/comments  # Get post comments
```

### Comments
```
POST   /api/v1/posts/:id/comments    # Add comment (auth required)
PUT    /api/v1/comments/:id          # Update comment (auth required)
DELETE /api/v1/comments/:id          # Delete comment (auth required)
```

### Tags
```
GET    /api/v1/tags             # List all tags
GET    /api/v1/tags/:id/posts   # Get posts with tag
```

### Users
```
GET    /api/v1/users/:id        # Get user profile
GET    /api/v1/users/:id/posts  # Get user's posts
```

## 📝 Example Usage

### Register a User
```bash
curl -X POST http://localhost:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepass",
    "name": "John Doe"
  }'
```

### Login
```bash
curl -X POST http://localhost:4567/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepass"
  }'

# Response includes JWT token:
# {"token": "eyJhbGc...", "user": {...}}
```

### Create a Post (with JWT)
```bash
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "title": "My First Post",
    "content": "This is the content...",
    "tags": ["ruby", "sinatra"]
  }'
```

### Get All Posts
```bash
curl http://localhost:4567/api/v1/posts?page=1&per_page=10
```

## 🐍 For Python Developers

This Sinatra API compares to these Python frameworks:

### Flask-RESTful Equivalent
```python
from flask import Flask, jsonify, request
from flask_restful import Resource, Api
from flask_jwt_extended import JWTManager, create_access_token, jwt_required

app = Flask(__name__)
api = Api(app)
jwt = JWTManager(app)

class PostList(Resource):
    def get(self):
        posts = Post.query.all()
        return jsonify([post.serialize() for post in posts])

    @jwt_required()
    def post(self):
        data = request.get_json()
        post = Post(title=data['title'], content=data['content'])
        db.session.add(post)
        db.session.commit()
        return post.serialize(), 201

api.add_resource(PostList, '/api/v1/posts')
```

### FastAPI Equivalent
```python
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import HTTPBearer
from pydantic import BaseModel
from typing import List

app = FastAPI()
security = HTTPBearer()

class PostCreate(BaseModel):
    title: str
    content: str
    tags: List[str] = []

@app.post("/api/v1/posts", response_model=Post)
async def create_post(
    post: PostCreate,
    token: str = Depends(security)
):
    user = verify_token(token)
    return Post.create(**post.dict(), user_id=user.id)

@app.get("/api/v1/posts", response_model=List[Post])
async def list_posts(page: int = 1, per_page: int = 10):
    return Post.query.paginate(page, per_page)
```

### Django REST Framework Equivalent
```python
from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=True, methods=['get'])
    def comments(self, request, pk=None):
        post = self.get_object()
        comments = post.comments.all()
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)
```

### Key Differences
- **Sinatra**: Minimalist, explicit routing, manual serialization
- **Flask-RESTful**: Similar simplicity with RESTful conventions
- **FastAPI**: Modern, async, automatic validation with Pydantic
- **Django REST Framework**: Full-featured, includes serializers, viewsets

## 📊 Database Schema

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  published BOOLEAN DEFAULT false,
  user_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  post_id INTEGER REFERENCES posts(id),
  user_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE post_tags (
  post_id INTEGER REFERENCES posts(id),
  tag_id INTEGER REFERENCES tags(id),
  PRIMARY KEY (post_id, tag_id)
);
```

## 🎯 Challenges

Try extending the API with:

1. **Likes System**: Add likes/favorites for posts and comments
2. **Follow System**: Users can follow other users
3. **Media Upload**: Support for image uploads with posts
4. **Full-Text Search**: Implement search with PostgreSQL full-text search
5. **Caching**: Add Redis caching for popular posts
6. **WebSockets**: Real-time notifications for comments
7. **Rate Limiting**: Implement proper rate limiting
8. **API Documentation**: Auto-generate OpenAPI/Swagger docs
9. **Soft Deletes**: Implement soft delete for posts/comments
10. **Activity Feed**: User activity stream

## 📚 Concepts Covered

After completing this lab, you'll understand:

- **RESTful API Design**: Following REST principles and conventions
- **JWT Authentication**: Stateless authentication with tokens
- **ActiveRecord ORM**: Complex associations and queries
- **JSON APIs**: Serialization and standardized responses
- **Error Handling**: Proper HTTP status codes and error messages
- **Database Migrations**: Schema management
- **Security**: Password hashing, token validation
- **Pagination**: Efficient data loading for large datasets
- **API Versioning**: Managing API changes over time

## 🔧 Technical Details

### Dependencies
- **sinatra**: Web framework (~> 3.0)
- **activerecord**: ORM for database access (~> 7.0)
- **pg**: PostgreSQL driver (~> 1.5)
- **jwt**: JSON Web Token implementation (~> 2.7)
- **bcrypt**: Password hashing (~> 3.1)

### Database
- PostgreSQL for production-ready features
- Can use SQLite for development if needed

### Security
- BCrypt password hashing
- JWT with expiration
- Authorization checks on routes
- SQL injection protection via ORM

---

Ready to build a blog API? Run `ruby app.rb` and start making API calls!
