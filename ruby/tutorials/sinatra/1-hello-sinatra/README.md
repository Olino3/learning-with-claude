# Tutorial 1: Hello Sinatra - Your First Web Application

Welcome to Sinatra! In this tutorial, you'll create your first web application using Sinatra, Ruby's elegant micro web framework.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand what Sinatra is and how it works
- Create a basic Sinatra application
- Define routes and handlers
- Run a development web server
- Handle different HTTP methods
- Return different types of responses

## 🐍➡️🔴 Coming from Flask

Sinatra and Flask share the same philosophy: stay small, be flexible. Here's a comparison:

| Concept | Flask (Python) | Sinatra (Ruby) |
|---------|---------------|----------------|
| Import framework | `from flask import Flask` | `require 'sinatra'` |
| Create app | `app = Flask(__name__)` | Not needed for simple apps |
| Define route | `@app.route('/')` | `get '/' do` |
| Return response | `return 'Hello'` | `'Hello'` (implicit return) |
| Run server | `app.run()` | Automatic when file runs |
| Debug mode | `debug=True` | `set :environment, :development` |

## 📝 What is Sinatra?

Sinatra is a **Domain Specific Language (DSL)** for quickly creating web applications in Ruby with minimal effort.

### Key Features:
- **Lightweight:** ~2000 lines of code (Flask is ~7000 lines)
- **Elegant:** Uses Ruby blocks for clean, readable routes
- **Flexible:** No assumptions about database, ORM, or structure
- **Fast:** Minimal overhead compared to full frameworks
- **Rack-based:** Built on Rack (Ruby's WSGI)

### When to Use Sinatra:
✅ Small web applications
✅ RESTful APIs
✅ Microservices
✅ Prototypes and MVPs
✅ Learning web development

### When to Use Rails Instead:
- Large, complex applications
- Need conventions and structure
- Want integrated ORM, testing, etc.
- Building traditional CRUD apps

## 🚀 Your First Sinatra App

### The Simplest App

Create `hello.rb`:

```ruby
require 'sinatra'

get '/' do
  'Hello World!'
end
```

Run it:
```bash
ruby hello.rb
```

Visit: http://localhost:4567

That's it! 🎉

### Understanding the Code

```ruby
require 'sinatra'  # Load the Sinatra library
```
Like `from flask import Flask` in Python, but Sinatra is automatically available once required.

```ruby
get '/' do
  'Hello World!'
end
```

This defines a **route** that:
- Responds to `GET` requests
- Matches the `/` URL path
- Executes the block (code between `do` and `end`)
- Returns `'Hello World!'` as the response

**Ruby note:** The last expression in a block is automatically returned!

### 🐍 Flask Comparison

```python
# Flask (Python)
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()
```

```ruby
# Sinatra (Ruby)
require 'sinatra'

get '/' do
  'Hello World!'
end
```

Notice:
- Sinatra: No app instance needed, no `if __name__` check
- Sinatra: Routes use blocks, not decorators
- Sinatra: Implicit return (no `return` keyword needed)
- Sinatra: Server starts automatically

## 📚 Multiple Routes

```ruby
require 'sinatra'

get '/' do
  'Welcome to my site!'
end

get '/about' do
  'This is the about page'
end

get '/contact' do
  'Email us at: hello@example.com'
end
```

Each `get` defines a new route. The block runs when that URL is accessed.

## 🔧 HTTP Methods

Sinatra supports all HTTP methods:

```ruby
require 'sinatra'

# GET request - retrieve data
get '/users' do
  'List of users'
end

# POST request - create new data
post '/users' do
  'Create a new user'
end

# PUT request - update data
put '/users/:id' do
  "Update user #{params[:id]}"
end

# DELETE request - remove data
delete '/users/:id' do
  "Delete user #{params[:id]}"
end

# PATCH request - partial update
patch '/users/:id' do
  "Partially update user #{params[:id]}"
end
```

### 🐍 Flask Comparison

```python
# Flask
@app.route('/users', methods=['GET'])
def get_users():
    return 'List of users'

@app.route('/users', methods=['POST'])
def create_user():
    return 'Create a new user'
```

```ruby
# Sinatra - cleaner, more explicit
get '/users' do
  'List of users'
end

post '/users' do
  'Create a new user'
end
```

Sinatra's approach is more RESTful and readable.

## 📄 Returning Different Content Types

### HTML Response

```ruby
get '/' do
  '<h1>Hello World!</h1>
   <p>This is HTML</p>'
end
```

### JSON Response

```ruby
require 'sinatra'
require 'json'

get '/api/status' do
  content_type :json
  { status: 'ok', message: 'Server is running' }.to_json
end
```

**🐍 Python equivalent:**
```python
from flask import Flask, jsonify

@app.route('/api/status')
def status():
    return jsonify(status='ok', message='Server is running')
```

### Plain Text Response

```ruby
get '/hello.txt' do
  content_type :txt
  'Hello from a text file!'
end
```

## ⚙️ Configuration Options

```ruby
require 'sinatra'

# Configure Sinatra settings
set :port, 3000                    # Change port (default: 4567)
set :bind, '0.0.0.0'              # Bind to all interfaces
set :environment, :development     # Environment mode
set :server, 'webrick'            # Web server choice

get '/' do
  "Running on port #{settings.port}"
end
```

### 🐍 Flask Comparison

```python
# Flask
app = Flask(__name__)
app.config['DEBUG'] = True

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
```

```ruby
# Sinatra
set :bind, '0.0.0.0'
set :port, 3000
set :environment, :development
```

## 🎨 The `settings` Object

Access configuration in your routes:

```ruby
get '/info' do
  """
  Environment: #{settings.environment}
  Port: #{settings.port}
  Root: #{settings.root}
  """
end
```

## 📦 Project Structure

For this tutorial, we use a simple structure:

```
1-hello-sinatra/
├── README.md          # This file
├── hello.rb           # Simplest app
├── routes_demo.rb     # Multiple routes example
├── methods_demo.rb    # HTTP methods example
├── json_api.rb        # JSON API example
└── configured_app.rb  # Configuration example
```

## ✍️ Exercises

### Exercise 1: Hello World

Create a Sinatra app with these routes:
- `/` - Returns "Welcome to my website!"
- `/hello` - Returns "Hello, Sinatra!"
- `/time` - Returns the current time

**Hint:** Use `Time.now` to get the current time.

**Solution:** [hello_exercise.rb](hello_exercise.rb)

### Exercise 2: Multiple HTTP Methods

Create an app that handles:
- `GET /tasks` - Returns "Viewing all tasks"
- `POST /tasks` - Returns "Creating a new task"
- `DELETE /tasks/1` - Returns "Deleting task 1"

**Solution:** [methods_exercise.rb](methods_exercise.rb)

### Exercise 3: JSON API

Create a simple API with these endpoints:
- `GET /api/users` - Returns JSON array of users
- `GET /api/health` - Returns health status as JSON

**Solution:** [api_exercise.rb](api_exercise.rb)

### Exercise 4: Calculator API

Build a calculator API:
- `GET /add/:a/:b` - Returns sum of a and b
- `GET /multiply/:a/:b` - Returns product of a and b

Return results as JSON.

**Solution:** [calculator_exercise.rb](calculator_exercise.rb)

## 🎓 Key Concepts

### 1. Routes

Routes map URL paths to code blocks:

```ruby
get '/path' do
  # code here
end
```

### 2. Blocks

Ruby blocks are chunks of code between `do...end` or `{...}`:

```ruby
# Multi-line block
get '/' do
  x = 5
  y = 10
  x + y
end

# Single-line block
get '/' { 'Hello' }
```

### 3. Implicit Returns

The last expression in a block is automatically returned:

```ruby
get '/' do
  name = "Alice"
  "Hello, #{name}!"  # This is returned
end
```

### 4. String Interpolation

Use `#{}` to embed expressions in strings:

```ruby
get '/greet/:name' do
  "Hello, #{params[:name]}!"
end
```

## 🐞 Common Issues

### Issue 1: Port Already in Use

**Error:** `Address already in use - bind(2) for 0.0.0.0:4567`

**Solution:**
```ruby
set :port, 3000  # Use a different port
```

Or kill the process using port 4567:
```bash
lsof -ti:4567 | xargs kill -9
```

### Issue 2: Auto-Reload Not Working

Sinatra doesn't auto-reload by default. Install `sinatra-contrib`:

```ruby
require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  'Hello'  # Changes reload automatically
end
```

### Issue 3: `require` Errors

**Error:** `cannot load such file -- sinatra`

**Solution:** Install the gem:
```bash
gem install sinatra
```

## 📊 Sinatra vs Flask Quick Reference

| Task | Flask | Sinatra |
|------|-------|---------|
| Install | `pip install flask` | `gem install sinatra` |
| Import | `from flask import Flask` | `require 'sinatra'` |
| Create app | `app = Flask(__name__)` | Not needed |
| Route | `@app.route('/')` | `get '/' do` |
| Run server | `app.run()` | Automatic |
| JSON response | `jsonify()` | `.to_json` |
| Template | `render_template()` | `erb :template` |
| Request data | `request.form['key']` | `params[:key]` |

## 🔜 What's Next?

Congratulations! You now know:
- ✅ How to create a Sinatra application
- ✅ How to define routes
- ✅ How to handle different HTTP methods
- ✅ How to return various response types
- ✅ Basic configuration

In the next tutorial, you'll learn about:
- Route parameters and patterns
- Query strings
- Request and response objects
- More advanced routing

**Next:** [Tutorial 2: Routes and Parameters](../2-routes-and-parameters/README.md)

## 📖 Additional Resources

- [Sinatra Official Documentation](http://sinatrarb.com/intro.html)
- [Sinatra README](http://sinatrarb.com/documentation.html)
- [Rack Documentation](https://rack.github.io/)
- [Ruby Blocks Tutorial](https://www.rubyguides.com/2016/02/ruby-procs-and-lambdas/)

---

Ready to practice? Start with **Exercise 1: Hello World**!
