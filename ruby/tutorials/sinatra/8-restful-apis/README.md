# Tutorial 8: RESTful APIs - Building Production-Ready APIs

Learn how to build RESTful APIs with Sinatra, including JSON handling, error responses, versioning, authentication, and documentation.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Build RESTful JSON APIs
- Handle errors gracefully
- Implement API versioning
- Add API authentication
- Configure CORS
- Document APIs
- Follow REST best practices

## 🐍➡️🔴 Coming from Flask/FastAPI

Building APIs in Sinatra is similar to Flask:

| Feature | Flask/FastAPI | Sinatra |
|---------|---------------|---------|
| JSON response | `jsonify()` / `return {}` | `.to_json` |
| Request JSON | `request.get_json()` | `JSON.parse(request.body.read)` |
| Status codes | `return data, 201` | `status 201; data.to_json` |
| Error handling | `@app.errorhandler(404)` | `error 404 do` |
| Route parameters | `@app.route('/users/<id>')` | `get '/users/:id' do` |
| Content type | Auto or `mimetype='application/json'` | `content_type :json` |

## 🚀 Basic REST API

### Simple JSON API

```ruby
require 'sinatra'
require 'json'

# Set JSON as default content type for all responses
before do
  content_type :json
end

# GET collection
get '/api/users' do
  users = [
    { id: 1, name: 'Alice', email: 'alice@example.com' },
    { id: 2, name: 'Bob', email: 'bob@example.com' }
  ]

  { users: users, count: users.length }.to_json
end

# GET single resource
get '/api/users/:id' do
  user = { id: params[:id].to_i, name: 'Alice', email: 'alice@example.com' }
  user.to_json
end

# POST create
post '/api/users' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  user = {
    id: rand(100..999),
    name: data['name'],
    email: data['email']
  }

  status 201
  user.to_json
end

# PUT update
put '/api/users/:id' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  user = {
    id: params[:id].to_i,
    name: data['name'],
    email: data['email']
  }

  user.to_json
end

# DELETE resource
delete '/api/users/:id' do
  status 204  # No content
end
```

### 🐍 Flask Comparison

**Flask:**
```python
from flask import Flask, jsonify, request

@app.route('/api/users', methods=['GET'])
def get_users():
    users = [{'id': 1, 'name': 'Alice'}]
    return jsonify(users=users)

@app.route('/api/users', methods=['POST'])
def create_user():
    data = request.get_json()
    return jsonify(data), 201
```

**Sinatra:**
```ruby
get '/api/users' do
  users = [{ id: 1, name: 'Alice' }]
  { users: users }.to_json
end

post '/api/users' do
  data = JSON.parse(request.body.read)
  status 201
  data.to_json
end
```

## 📝 Request Body Parsing

### JSON Helper

```ruby
helpers do
  def json_params
    request.body.rewind
    JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end
end

post '/api/users' do
  data = json_params

  # Access with symbols
  name = data[:name]
  email = data[:email]

  { id: 1, name: name, email: email }.to_json
end
```

## ❌ Error Handling

### Structured Error Responses

```ruby
# Error helpers
helpers do
  def error_response(status, message, details = {})
    halt status, {
      error: {
        status: status,
        message: message,
        details: details
      }
    }.to_json
  end

  def not_found(resource = 'Resource')
    error_response(404, "#{resource} not found")
  end

  def validation_error(errors)
    error_response(422, 'Validation failed', errors: errors)
  end
end

# 404 handler
not_found do
  { error: 'Endpoint not found', path: request.path }.to_json
end

# 500 handler
error do
  { error: 'Internal server error', message: env['sinatra.error'].message }.to_json
end

# Custom error handling
get '/api/users/:id' do
  user = User.find_by(id: params[:id])
  not_found('User') unless user

  user.to_json
end
```

## 🔢 API Versioning

### URL-Based Versioning

```ruby
# Version 1
namespace '/api/v1' do
  get '/users' do
    { version: 1, users: [] }.to_json
  end
end

# Version 2
namespace '/api/v2' do
  get '/users' do
    { version: 2, users: [], meta: { total: 0 } }.to_json
  end
end
```

### Header-Based Versioning

```ruby
before '/api/*' do
  @api_version = request.env['HTTP_API_VERSION'] || '1'

  unless ['1', '2'].include?(@api_version)
    halt 400, { error: 'Invalid API version' }.to_json
  end
end

get '/api/users' do
  case @api_version
  when '1'
    { users: get_users_v1 }.to_json
  when '2'
    { users: get_users_v2, meta: {} }.to_json
  end
end
```

## 🔐 API Authentication

### API Key Authentication

```ruby
configure do
  set :api_keys, ['secret-key-1', 'secret-key-2']
end

before '/api/*' do
  api_key = request.env['HTTP_X_API_KEY']

  unless settings.api_keys.include?(api_key)
    halt 401, { error: 'Invalid or missing API key' }.to_json
  end
end
```

### JWT Authentication

```ruby
require 'jwt'

helpers do
  def generate_token(user_id)
    payload = {
      user_id: user_id,
      exp: Time.now.to_i + 3600  # 1 hour
    }
    JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
  end

  def verify_token
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last

    return halt(401, { error: 'Missing token' }.to_json) unless token

    begin
      @current_user_id = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')[0]['user_id']
    rescue JWT::DecodeError
      halt 401, { error: 'Invalid token' }.to_json
    end
  end
end

post '/api/auth/login' do
  data = json_params

  # Authenticate user (simplified)
  if data[:username] == 'admin' && data[:password] == 'secret'
    token = generate_token(1)
    { token: token }.to_json
  else
    halt 401, { error: 'Invalid credentials' }.to_json
  end
end

# Protected routes
before '/api/protected/*' do
  verify_token
end

get '/api/protected/profile' do
  { user_id: @current_user_id, message: 'Protected data' }.to_json
end
```

## 🌍 CORS Configuration

```ruby
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
          'Access-Control-Allow-Headers' => 'Content-Type, Authorization, X-API-Key'
end

options '*' do
  200
end
```

## 📄 Pagination

```ruby
helpers do
  def paginate(collection, page: 1, per_page: 20)
    page = [page.to_i, 1].max
    per_page = [[per_page.to_i, 100].min, 1].max

    offset = (page - 1) * per_page
    items = collection[offset, per_page] || []

    {
      data: items,
      meta: {
        page: page,
        per_page: per_page,
        total: collection.length,
        total_pages: (collection.length.to_f / per_page).ceil
      }
    }
  end
end

get '/api/users' do
  all_users = User.all

  result = paginate(all_users,
    page: params[:page],
    per_page: params[:per_page]
  )

  result.to_json
end
```

## 🔍 Filtering and Sorting

```ruby
get '/api/users' do
  users = User.all

  # Filtering
  users = users.where(role: params[:role]) if params[:role]
  users = users.where('name LIKE ?', "%#{params[:search]}%") if params[:search]

  # Sorting
  if params[:sort]
    direction = params[:order] == 'desc' ? :desc : :asc
    users = users.order(params[:sort] => direction)
  end

  # Pagination
  page = (params[:page] || 1).to_i
  per_page = (params[:per_page] || 20).to_i

  {
    users: users.limit(per_page).offset((page - 1) * per_page),
    meta: {
      page: page,
      per_page: per_page,
      total: users.count
    }
  }.to_json
end
```

## 📊 Status Codes

Use appropriate HTTP status codes:

```ruby
# 200 OK - Successful GET/PUT
get '/api/users/:id' do
  status 200  # Default
  user.to_json
end

# 201 Created - Successful POST
post '/api/users' do
  user = User.create(json_params)
  status 201
  user.to_json
end

# 204 No Content - Successful DELETE
delete '/api/users/:id' do
  user.destroy
  status 204
end

# 400 Bad Request - Invalid input
post '/api/users' do
  halt 400, { error: 'Invalid request' }.to_json if invalid?
end

# 401 Unauthorized - Missing/invalid auth
before '/api/*' do
  halt 401, { error: 'Unauthorized' }.to_json unless authenticated?
end

# 403 Forbidden - Valid auth but insufficient permissions
get '/api/admin' do
  halt 403, { error: 'Forbidden' }.to_json unless admin?
end

# 404 Not Found - Resource doesn't exist
get '/api/users/:id' do
  user = User.find_by(id: params[:id])
  halt 404, { error: 'User not found' }.to_json unless user
  user.to_json
end

# 422 Unprocessable Entity - Validation errors
post '/api/users' do
  user = User.new(json_params)
  unless user.valid?
    halt 422, { errors: user.errors }.to_json
  end
  user.save
  status 201
  user.to_json
end

# 429 Too Many Requests - Rate limit exceeded
before '/api/*' do
  halt 429, { error: 'Rate limit exceeded' }.to_json if rate_limited?
end

# 500 Internal Server Error - Server error
error do
  status 500
  { error: 'Internal server error' }.to_json
end
```

## 📚 API Documentation

### Self-Documenting Endpoint

```ruby
get '/api' do
  {
    version: '1.0.0',
    endpoints: {
      users: {
        list: { method: 'GET', path: '/api/users', description: 'Get all users' },
        get: { method: 'GET', path: '/api/users/:id', description: 'Get user by ID' },
        create: { method: 'POST', path: '/api/users', description: 'Create new user' },
        update: { method: 'PUT', path: '/api/users/:id', description: 'Update user' },
        delete: { method: 'DELETE', path: '/api/users/:id', description: 'Delete user' }
      }
    },
    authentication: {
      type: 'API Key',
      header: 'X-API-Key'
    }
  }.to_json
end
```

## ✍️ Exercises

### Exercise 1: Blog API

Build a RESTful blog API:
- CRUD for posts
- Nested comments
- Authentication
- Pagination

**Solution:** [blog_api_app.rb](blog_api_app.rb)

### Exercise 2: Task API with Auth

Create a task management API:
- JWT authentication
- User-specific tasks
- Filtering and sorting
- API versioning

**Solution:** [task_api_app.rb](task_api_app.rb)

### Exercise 3: E-commerce API

Build an e-commerce API:
- Products with categories
- Shopping cart
- Orders
- Rate limiting

**Solution:** [ecommerce_api_app.rb](ecommerce_api_app.rb)

## 🎓 Key Concepts

1. **REST**: Representational State Transfer
2. **Resources**: Nouns, not verbs (e.g., `/users` not `/getUsers`)
3. **HTTP Methods**: GET (read), POST (create), PUT (update), DELETE (remove)
4. **Status Codes**: Proper codes for different responses
5. **Stateless**: Each request contains all needed information
6. **JSON**: Standard data format for APIs

## 🐞 Common Issues

### Issue 1: CORS Errors

**Problem:** Browser blocks API requests

**Solution:** Add CORS headers
```ruby
before do
  headers 'Access-Control-Allow-Origin' => '*'
end

options '*' do
  200
end
```

### Issue 2: JSON Parsing Fails

**Problem:** `JSON::ParserError`

**Solution:** Check content type and handle errors
```ruby
helpers do
  def json_params
    halt 400, { error: 'Content-Type must be application/json' }.to_json unless request.content_type == 'application/json'

    request.body.rewind
    JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end
end
```

## 📊 REST API Quick Reference

| Operation | HTTP Method | Path | Status |
|-----------|-------------|------|--------|
| List all | GET | `/api/resources` | 200 |
| Get one | GET | `/api/resources/:id` | 200/404 |
| Create | POST | `/api/resources` | 201 |
| Update (full) | PUT | `/api/resources/:id` | 200/404 |
| Update (partial) | PATCH | `/api/resources/:id` | 200/404 |
| Delete | DELETE | `/api/resources/:id` | 204/404 |

## 🔜 What's Next?

You now know:
- ✅ How to build RESTful APIs
- ✅ How to handle JSON requests and responses
- ✅ How to implement authentication
- ✅ How to version APIs
- ✅ How to handle errors properly
- ✅ REST best practices

## 📖 Additional Resources

- [REST API Design Best Practices](https://restfulapi.net/)
- [HTTP Status Codes](https://httpstatuses.com/)
- [JWT.io](https://jwt.io/)
- [OpenAPI Specification](https://swagger.io/specification/)

---

Congratulations! You've completed all Sinatra tutorials. You're now ready to build production-ready web applications and APIs with Sinatra!
