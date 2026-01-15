# Step 9: Error Handling

**Estimated Time:** 15 minutes

[← Previous Step](../8/README.md)

---

## 🎯 Goal

Add centralized error handling and standardized error responses.

## 📝 Tasks

### 1. Create error handler module (`lib/error_handler.rb`)

```ruby
module Sinatra
  module ErrorHandler
    def self.registered(app)
      # 404 Not Found
      app.not_found do
        content_type :json
        status 404
        { error: 'Not found', message: 'The requested resource was not found' }.to_json
      end

      # 500 Internal Server Error
      app.error do
        content_type :json
        status 500
        { error: 'Internal server error', message: env['sinatra.error'].message }.to_json
      end

      # 422 Unprocessable Entity
      app.error 422 do
        content_type :json
        { error: 'Validation failed' }.to_json
      end

      # 401 Unauthorized
      app.error 401 do
        content_type :json
        { error: 'Unauthorized' }.to_json
      end

      # 403 Forbidden
      app.error 403 do
        content_type :json
        { error: 'Forbidden' }.to_json
      end
    end
  end

  register ErrorHandler
end
```

### 2. Add JSON parsing error handling

Add this to `app.rb` after the `before` block:

```ruby
# Handle JSON parsing errors
before do
  if request.post? || request.put?
    begin
      request.body.rewind
      @request_payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 400, { error: 'Invalid JSON' }.to_json
    end
  end
end

# Helper to get parsed JSON
helpers do
  def request_payload
    @request_payload || {}
  end
end
```

### 3. Update routes to use request_payload

Update your POST and PUT routes to use the helper:

```ruby
# Example: Update register route
post '/api/v1/auth/register' do
  user = User.new(
    email: request_payload['email'],
    name: request_payload['name'],
    password: request_payload['password']
  )

  # ... rest of code
end
```

### 4. Add logging (optional but recommended)

Add to `app.rb`:

```ruby
configure :development do
  set :logging, Logger::DEBUG
end

configure :production do
  set :logging, Logger::INFO
end
```

### 5. Test error handling

```bash
# Test 404
curl http://localhost:4567/api/v1/nonexistent

# Test invalid JSON
curl -X POST http://localhost:4567/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d 'invalid json'

# Test validation error
curl -X POST http://localhost:4567/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"invalid","name":"A","password":"123"}'

# Test unauthorized
curl http://localhost:4567/api/v1/auth/me
```

## ✅ Checkpoint

Before completing this lab, verify:

- [ ] 404 errors return proper JSON response
- [ ] Invalid JSON returns 400 Bad Request
- [ ] Validation errors return 422 with error details
- [ ] Unauthorized requests return 401
- [ ] Forbidden requests return 403
- [ ] Internal errors return 500
- [ ] All errors are in consistent JSON format

## 🎓 What You Learned

- Centralized error handling in Sinatra
- HTTP status codes and their meanings
- JSON parsing error handling
- Structured error responses
- Logging for debugging and monitoring
- Defensive programming practices

## 🔍 HTTP Status Codes

```
200 OK              - Success
201 Created         - Resource created
204 No Content      - Success (no body)
400 Bad Request     - Invalid request
401 Unauthorized    - Not authenticated
403 Forbidden       - Not authorized
404 Not Found       - Resource doesn't exist
422 Unprocessable   - Validation failed
500 Server Error    - Internal error
```

## 💡 Tips

- Always return JSON errors, not HTML
- Include helpful error messages for developers
- Log errors for debugging
- Don't expose sensitive information in errors
- Use appropriate status codes

---

## 🎉 Congratulations!

You've completed the Blog API lab! You've built a production-ready RESTful API with:

✅ JWT authentication
✅ CRUD operations for posts
✅ Nested comments system
✅ Many-to-many tagging
✅ Pagination
✅ Comprehensive error handling
✅ User authorization
✅ JSON responses
✅ Database relationships

### 🎯 Next Steps

**Try these enhancements:**
1. Add likes/favorites for posts
2. Implement user followers
3. Add full-text search
4. Cache popular posts with Redis
5. Add file uploads for images
6. Implement rate limiting
7. Add API versioning
8. Generate API documentation

**Continue your learning:**

Ready for user authentication in web apps? Continue to **[Lab 3: Authentication App →](../../3-auth-app/README.md)**

### 📚 What You've Mastered

- RESTful API design
- JWT token authentication
- ActiveRecord associations
- Authorization patterns
- JSON serialization
- Error handling
- Pagination
- Many-to-many relationships
- Database migrations
- API best practices

---

[← Previous: Pagination](../8/README.md)
