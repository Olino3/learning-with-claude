# Step 4: JWT Authentication

**Estimated Time:** 35 minutes

[← Previous Step](../3/README.md) | [Next Step →](../5/README.md)

---

## 🎯 Goal

Implement JWT token-based authentication for stateless API auth.

## 📝 Tasks

### 1. Install JWT gem

```bash
gem install jwt
```

### 2. Create auth helpers (`lib/auth.rb`)

```ruby
require 'jwt'

module Auth
  SECRET_KEY = ENV['JWT_SECRET'] || 'change_this_secret_key_in_production'

  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
  rescue JWT::DecodeError => e
    nil
  end
end

module Sinatra
  module AuthHelper
    def authenticate!
      token = extract_token
      halt 401, { error: 'Unauthorized' }.to_json unless token

      payload = Auth.decode(token)
      halt 401, { error: 'Invalid or expired token' }.to_json unless payload

      @current_user = User.find_by(id: payload['user_id'])
      halt 401, { error: 'User not found' }.to_json unless @current_user
    end

    def current_user
      @current_user
    end

    private

    def extract_token
      auth_header = request.env['HTTP_AUTHORIZATION']
      return nil unless auth_header

      auth_header.split(' ').last
    end
  end

  helpers AuthHelper
end
```

### 3. Add authentication routes to app.rb

```ruby
require 'sinatra'
require 'json'
require_relative 'config/database'
require_relative 'lib/models/user'
require_relative 'lib/auth'

before do
  content_type :json
end

# Register new user
post '/api/v1/auth/register' do
  data = JSON.parse(request.body.read)

  user = User.new(
    email: data['email'],
    name: data['name'],
    password: data['password']
  )

  if user.save
    token = Auth.encode(user_id: user.id)
    status 201
    { token: token, user: user }.to_json
  else
    status 422
    { errors: user.errors.full_messages }.to_json
  end
end

# Login
post '/api/v1/auth/login' do
  data = JSON.parse(request.body.read)

  user = User.find_by(email: data['email'])

  if user && user.authenticate(data['password'])
    token = Auth.encode(user_id: user.id)
    { token: token, user: user }.to_json
  else
    status 401
    { error: 'Invalid email or password' }.to_json
  end
end

# Get current user (protected route)
get '/api/v1/auth/me' do
  authenticate!
  current_user.to_json
end

# ... keep existing routes
```

### 4. Test authentication

```bash
# Register
curl -X POST http://localhost:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User","password":"password123"}'

# Login
curl -X POST http://localhost:4567/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get current user (use token from login)
curl http://localhost:4567/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] User registration works and returns JWT token
- [ ] Login returns JWT token
- [ ] Protected routes require authentication
- [ ] Token validation works correctly
- [ ] Invalid tokens return 401 Unauthorized
- [ ] Token expires after 24 hours

## 🎓 What You Learned

- JWT (JSON Web Tokens) for stateless authentication
- Encoding and decoding JWTs
- Token expiration for security
- Authorization header format (`Bearer <token>`)
- Creating helper methods for authentication
- HTTP status codes (201, 401, 422)

## 🔍 JWT Structure

```
Header.Payload.Signature
eyJhbGc...  (encoded)

Decoded:
{
  "user_id": 1,
  "exp": 1234567890
}
```

## 💡 Tips

- Always use HTTPS in production for token security
- Set short expiration times (24 hours recommended)
- Store secret key in environment variables
- Include user ID in token payload
- Never store sensitive data in JWT (it's not encrypted!)

---

[← Previous: User Model](../3/README.md) | [Next: Post Model and CRUD →](../5/README.md)
