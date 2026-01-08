# Tutorial 2: Routes and Parameters - Dynamic URL Handling

Learn how to create dynamic routes with parameters, handle query strings, and build flexible routing patterns in Sinatra.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use named parameters in routes
- Handle wildcard and splat routes
- Work with query parameters
- Understand route conditions and patterns
- Access the request object
- Build RESTful URL structures

## 🐍➡️🔴 Coming from Flask

Route parameters work similarly in Sinatra and Flask, but with Ruby syntax:

| Feature | Flask (Python) | Sinatra (Ruby) |
|---------|---------------|----------------|
| Named param | `<name>` | `:name` |
| Type conversion | `<int:id>` | `params[:id].to_i` |
| Optional param | Complex | Use conditions or multiple routes |
| Query string | `request.args['key']` | `params[:key]` |
| Wildcard | `<path:path>` | `*` (splat) |
| Access params | Dictionary | Hash with symbols |

## 📝 Named Parameters

Named parameters capture parts of the URL path:

```ruby
require 'sinatra'

# Basic named parameter
get '/hello/:name' do
  name = params[:name]
  "Hello, #{name}!"
end

# Visit: /hello/Alice → "Hello, Alice!"
# Visit: /hello/Bob → "Hello, Bob!"
```

### Multiple Parameters

```ruby
# Multiple parameters in one route
get '/users/:id/posts/:post_id' do
  user_id = params[:id]
  post_id = params[:post_id]
  "User #{user_id}, Post #{post_id}"
end

# Visit: /users/123/posts/456 → "User 123, Post 456"
```

### 🐍 Flask Comparison

```python
# Flask
@app.route('/hello/<name>')
def hello(name):
    return f'Hello, {name}!'

@app.route('/users/<int:user_id>/posts/<int:post_id>')
def user_post(user_id, post_id):
    return f'User {user_id}, Post {post_id}'
```

```ruby
# Sinatra
get '/hello/:name' do
  "Hello, #{params[:name]}!"
end

get '/users/:id/posts/:post_id' do
  "User #{params[:id]}, Post #{params[:post_id]}"
end
```

**Key differences:**
- Sinatra: Parameters accessed via `params` hash
- Sinatra: Type conversion done explicitly (`.to_i`, `.to_f`)
- Sinatra: Uses symbols (`:name`) not strings (`'name'`)

## 🔢 Type Conversion

Parameters are always strings. Convert them as needed:

```ruby
get '/square/:number' do
  # params[:number] is a string
  num = params[:number].to_i
  result = num ** 2
  "The square of #{num} is #{result}"
end

# Visit: /square/7 → "The square of 7 is 49"
```

Common conversions:
```ruby
params[:id].to_i      # String to integer
params[:price].to_f   # String to float
params[:active].to_s  # Ensure string
params[:tags].split(',')  # String to array
```

## 🔍 Query Parameters

Query parameters come from the URL query string (`?key=value&key2=value2`):

```ruby
# Query parameters (after ?)
get '/search' do
  query = params[:q]          # From ?q=ruby
  page = params[:page] || 1   # From ?page=2, default to 1
  limit = params[:limit] || 10

  "Searching for '#{query}' (page #{page}, limit #{limit})"
end

# Visit: /search?q=ruby&page=2&limit=20
# Output: "Searching for 'ruby' (page 2, limit 20)"
```

### Combining Path and Query Parameters

```ruby
get '/users/:id' do
  user_id = params[:id]           # From path
  include_posts = params[:posts]  # From query string
  format = params[:format] || 'html'

  if include_posts
    "User #{user_id} with posts (format: #{format})"
  else
    "User #{user_id} (format: #{format})"
  end
end

# Visit: /users/123?posts=true&format=json
# Output: "User 123 with posts (format: json)"
```

### 🐍 Flask Comparison

```python
# Flask
from flask import request

@app.route('/search')
def search():
    query = request.args.get('q')
    page = request.args.get('page', 1, type=int)
    return f'Searching for {query} (page {page})'
```

```ruby
# Sinatra
get '/search' do
  query = params[:q]
  page = (params[:page] || 1).to_i
  "Searching for #{query} (page #{page})"
end
```

Both use a similar hash/dictionary-like interface!

## ⭐ Splat Parameters (Wildcards)

Splats capture multiple path segments:

```ruby
# Single splat - captures rest of path
get '/say/*/to/*' do
  # params[:splat] is an array
  message = params[:splat][0]
  recipient = params[:splat][1]
  "#{message} to #{recipient}"
end

# Visit: /say/hello/to/world → "hello to world"
# Visit: /say/goodbye/to/Alice → "goodbye to Alice"
```

```ruby
# Named splat for clarity
get '/download/*' do
  file_path = params[:splat][0]
  "Downloading file: #{file_path}"
end

# Visit: /download/docs/manual.pdf → "Downloading file: docs/manual.pdf"
```

### 🐍 Flask Comparison

```python
# Flask
@app.route('/download/<path:filepath>')
def download(filepath):
    return f'Downloading: {filepath}'
```

```ruby
# Sinatra
get '/download/*' do
  filepath = params[:splat][0]
  "Downloading: #{filepath}"
end
```

## 🎯 Route Patterns with Regular Expressions

Use regex for fine-grained control:

```ruby
# Match only numbers
get %r{/posts/(\d+)} do
  post_id = params[:captures][0]
  "Post ID: #{post_id}"
end

# Match specific pattern
get %r{/user/([a-z]+)} do
  username = params[:captures][0]
  "Username: #{username} (lowercase only)"
end
```

### Using Named Captures

```ruby
# Ruby 2.4+ named captures
get %r{/(?<year>\d{4})/(?<month>\d{2})/(?<day>\d{2})} do
  "Date: #{params[:year]}-#{params[:month]}-#{params[:day]}"
end

# Visit: /2024/03/15 → "Date: 2024-03-15"
```

## ⚙️ Route Conditions

Add conditions to routes for more control:

```ruby
# Only match if user agent contains "Mobile"
get '/mobile', agent: /Mobile/ do
  'Mobile version'
end

get '/' do
  'Desktop version'
end
```

```ruby
# Match based on host
get '/', host: 'admin.example.com' do
  'Admin panel'
end

get '/' do
  'Main site'
end
```

## 📦 The `params` Hash

All parameters (path, query, form) are in the `params` hash:

```ruby
get '/demo/:id' do
  # Access parameters
  path_param = params[:id]           # From URL path
  query_param = params[:search]      # From query string
  all_params = params.inspect        # See everything

  """
  <h1>Parameters Demo</h1>
  <p>Path parameter (id): #{path_param}</p>
  <p>Query parameter (search): #{query_param}</p>
  <p>All parameters: #{all_params}</p>
  """
end

# Visit: /demo/123?search=ruby&page=1
```

## 📱 The `request` Object

Access detailed request information:

```ruby
get '/request-info' do
  """
  <h1>Request Information</h1>
  <ul>
    <li>Path: #{request.path}</li>
    <li>Method: #{request.request_method}</li>
    <li>URL: #{request.url}</li>
    <li>Host: #{request.host}</li>
    <li>Port: #{request.port}</li>
    <li>Scheme: #{request.scheme}</li>
    <li>User Agent: #{request.user_agent}</li>
    <li>IP: #{request.ip}</li>
    <li>Referrer: #{request.referrer}</li>
  </ul>
  """
end
```

Useful request methods:
```ruby
request.get?          # Is it a GET request?
request.post?         # Is it a POST request?
request.xhr?          # Is it an AJAX request?
request.secure?       # Is it HTTPS?
request.cookies       # Access cookies
request.env           # Rack environment hash
```

## 🏗️ RESTful Routes Example

Build a RESTful API with proper route structure:

```ruby
require 'sinatra'
require 'json'

# List all posts
get '/posts' do
  page = (params[:page] || 1).to_i
  limit = (params[:limit] || 10).to_i
  "Listing posts (page #{page}, limit #{limit})"
end

# Show specific post
get '/posts/:id' do
  post_id = params[:id].to_i
  "Showing post #{post_id}"
end

# Create new post
post '/posts' do
  "Creating new post"
end

# Update post
put '/posts/:id' do
  post_id = params[:id].to_i
  "Updating post #{post_id}"
end

# Partial update
patch '/posts/:id' do
  post_id = params[:id].to_i
  "Partially updating post #{post_id}"
end

# Delete post
delete '/posts/:id' do
  post_id = params[:id].to_i
  "Deleting post #{post_id}"
end

# Nested resources
get '/users/:user_id/posts' do
  user_id = params[:user_id].to_i
  "Listing posts for user #{user_id}"
end
```

## ✍️ Exercises

### Exercise 1: User Profile Routes

Create routes for a user profile system:
- `GET /profile/:username` - Show user profile
- `GET /profile/:username/posts` - Show user's posts
- Add query parameter support for pagination

**Solution:** [profile_routes.rb](profile_routes.rb)

### Exercise 2: Blog Post Routes

Create a blog with these routes:
- `GET /blog` - List all posts (with pagination)
- `GET /blog/:year/:month/:day/:slug` - Show specific post
- `GET /blog/search` - Search posts by query

**Solution:** [blog_routes.rb](blog_routes.rb)

### Exercise 3: File Browser

Create a file browser API:
- `GET /files/*` - Browse files at any path depth
- Support query parameter `?download=true`
- Show file details using the request object

**Solution:** [file_browser.rb](file_browser.rb)

### Exercise 4: Advanced API

Build an API with:
- Multiple parameter types (path, query)
- Type conversions
- Default values
- Error handling for invalid parameters

**Solution:** [advanced_api.rb](advanced_api.rb)

## 🎓 Key Concepts

### 1. Parameter Access

```ruby
params[:name]        # Named parameter from route
params[:query]       # Query parameter from URL
params[:splat]       # Array of splat captures
```

### 2. Type Safety

Always convert and validate:
```ruby
id = params[:id].to_i
return halt 400, "Invalid ID" unless id > 0
```

### 3. Default Values

Use `||` operator for defaults:
```ruby
page = params[:page] || 1
limit = (params[:limit] || 10).to_i
```

## 🐞 Common Issues

### Issue 1: Parameter is Always String

**Problem:** `params[:id] + 1` fails

**Solution:** Convert first
```ruby
id = params[:id].to_i
result = id + 1
```

### Issue 2: Optional Parameters

**Problem:** Can't make parameters optional in route

**Solution:** Use query parameters or multiple routes
```ruby
# Option 1: Query parameter
get '/users' do
  id = params[:id]
  id ? "User #{id}" : "All users"
end

# Option 2: Multiple routes
get '/users/:id' do
  "User #{params[:id]}"
end

get '/users' do
  "All users"
end
```

### Issue 3: Splat Returns Array

**Problem:** Expected string, got array

**Solution:** Access array elements
```ruby
get '/files/*' do
  path = params[:splat][0]  # Get first element
  "Path: #{path}"
end
```

## 📊 Parameter Types Cheat Sheet

| Type | Access | Example | Conversion |
|------|--------|---------|------------|
| Named | `params[:name]` | `/user/:id` | `.to_i`, `.to_f` |
| Query | `params[:key]` | `?key=value` | `.to_i`, `.to_f` |
| Splat | `params[:splat][0]` | `/files/*` | Array access |
| Form | `params[:field]` | POST data | Next tutorial |

## 🔜 What's Next?

You now know:
- ✅ How to use named parameters
- ✅ How to handle query strings
- ✅ How to use splats for wildcards
- ✅ How to access request information
- ✅ How to build RESTful routes

Next up:
- Templates and views with ERB
- Rendering HTML dynamically
- Layouts and partials
- Passing data to templates

**Next:** [Tutorial 3: Templates and Views](../3-templates-and-views/README.md)

## 📖 Additional Resources

- [Sinatra Routing Documentation](http://sinatrarb.com/intro.html#Routes)
- [Rack Request Documentation](https://rubydoc.info/github/rack/rack/Rack/Request)
- [Ruby Regular Expressions](https://ruby-doc.org/core/Regexp.html)

---

Ready to practice? Start with **Exercise 1: User Profile Routes**!
