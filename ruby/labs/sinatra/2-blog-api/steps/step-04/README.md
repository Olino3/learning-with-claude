# Step 4: JWT Authentication

This step adds JWT token-based authentication.

## What's Included
- User registration endpoint
- User login endpoint
- JWT token generation
- Protected routes with authentication

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
# Register
curl -X POST http://localhost:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"new@example.com","password":"password123","name":"New User"}'

# Login
curl -X POST http://localhost:4567/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get current user (use token from login)
curl http://localhost:4567/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```
