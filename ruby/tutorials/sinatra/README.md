# Sinatra Web Development Tutorials

Progressive tutorials for learning Sinatra web development, designed for intermediate and advanced Python engineers familiar with Flask, Django, and FastAPI.

## 🎯 What is Sinatra?

Sinatra is a lightweight, elegant web framework for Ruby. Think of it as Ruby's equivalent to Flask - minimalist, flexible, and perfect for everything from microservices to small web applications.

## 🐍 For Python Developers

If you're coming from Python, here's how Sinatra compares:

| Framework | Python | Ruby |
|-----------|--------|------|
| **Micro-framework** | Flask | **Sinatra** |
| **Full-featured** | Django | Rails |
| **Modern/Async** | FastAPI | Roda/Hanami |

**Sinatra is like Flask:**
- Minimal and unopinionated
- Great for APIs and small apps
- Easy to learn and get started
- Doesn't include an ORM by default
- Routes are defined directly in code

**Key differences:**
- Sinatra uses blocks for route handlers (Ruby's unique feature)
- Template syntax: ERB instead of Jinja2
- Less "magic" than Flask's request context
- More explicit about configuration

## 📚 Learning Path

These tutorials build progressively. Complete them in order:

### Tutorial 1: Hello Sinatra
**Status:** ✅ Ready

Learn the basics of Sinatra and create your first web application.

👉 **[Start Tutorial 1: Hello Sinatra](1-hello-sinatra/README.md)**

**You'll learn:**
- Installing and setting up Sinatra
- Creating routes and handlers
- Running a development server
- Basic HTTP methods (GET, POST)
- Comparison with Flask

**Python equivalent:** Flask's `@app.route()` and `app.run()`

---

### Tutorial 2: Routes and Parameters
**Status:** ✅ Ready

Master routing patterns, URL parameters, and query strings.

👉 **[Start Tutorial 2: Routes and Parameters](2-routes-and-parameters/README.md)**

**You'll learn:**
- Named parameters in routes
- Wildcards and splat operators
- Query parameters
- Route patterns and conditions
- Request object details

**Python equivalent:** Flask's `<variable>` URL patterns and `request.args`

---

### Tutorial 3: Templates and Views
**Status:** ✅ Ready

Work with ERB templates to generate dynamic HTML.

👉 **[Start Tutorial 3: Templates and Views](3-templates-and-views/README.md)**

**You'll learn:**
- ERB template syntax
- Passing data to templates
- Layouts and partials
- Template helpers
- Static files and assets

**Python equivalent:** Jinja2 templates in Flask

---

### Tutorial 4: Forms and User Input
**Status:** ✅ Ready

Handle form submissions and user input safely.

👉 **[Start Tutorial 4: Forms and User Input](4-forms-and-input/README.md)**

**You'll learn:**
- Processing form data
- POST request handling
- Input validation
- CSRF protection
- File uploads

**Python equivalent:** Flask's `request.form` and WTForms

---

### Tutorial 5: Working with Databases
**Status:** ✅ Ready

Integrate databases using Sequel and ActiveRecord ORMs.

👉 **[Start Tutorial 5: Working with Databases](5-working-with-databases/README.md)**

**You'll learn:**
- SQLite and PostgreSQL setup
- Sequel ORM (like SQLAlchemy)
- ActiveRecord (Django ORM style)
- Migrations and schemas
- Database queries

**Python equivalent:** SQLAlchemy (Sequel) or Django ORM (ActiveRecord)

---

### Tutorial 6: Sessions and Cookies
**Status:** ✅ Ready

Manage user sessions and maintain state across requests.

👉 **[Start Tutorial 6: Sessions and Cookies](6-sessions-and-cookies/README.md)**

**You'll learn:**
- Session configuration
- Storing user data in sessions
- Cookie handling
- Session security
- Redis-backed sessions

**Python equivalent:** Flask's `session` object

---

### Tutorial 7: Middleware and Filters
**Status:** ✅ Ready

Use Rack middleware and Sinatra filters for request processing.

👉 **[Start Tutorial 7: Middleware and Filters](7-middleware-and-filters/README.md)**

**You'll learn:**
- Before and after filters
- Rack middleware stack
- Custom middleware
- Authentication filters
- Logging and monitoring

**Python equivalent:** Flask's `@app.before_request` and WSGI middleware

---

### Tutorial 8: RESTful APIs
**Status:** ✅ Ready

Build production-ready RESTful APIs with JSON responses.

👉 **[Start Tutorial 8: RESTful APIs](8-restful-apis/README.md)**

**You'll learn:**
- RESTful route design
- JSON APIs
- Error handling
- API versioning
- CORS configuration

**Python equivalent:** Flask-RESTful or FastAPI

---

## 📊 Tutorial Overview

| # | Tutorial | Topics | Difficulty | Python Equivalent |
|---|----------|--------|------------|-------------------|
| 1 | Hello Sinatra | Routes, handlers, server | ⭐ Beginner | Flask basics |
| 2 | Routes & Parameters | URL params, query strings | ⭐⭐ Beginner | Flask routing |
| 3 | Templates & Views | ERB, layouts, partials | ⭐⭐ Beginner | Jinja2 |
| 4 | Forms & Input | Form processing, validation | ⭐⭐ Intermediate | WTForms |
| 5 | Databases | ORMs, migrations, queries | ⭐⭐⭐ Intermediate | SQLAlchemy |
| 6 | Sessions & Cookies | State management | ⭐⭐ Intermediate | Flask sessions |
| 7 | Middleware & Filters | Request pipeline | ⭐⭐⭐ Intermediate | WSGI middleware |
| 8 | RESTful APIs | JSON APIs, REST design | ⭐⭐⭐ Intermediate | FastAPI/Flask-RESTful |

## 💎 Hands-On Labs

After completing the tutorials, build real applications with these labs:

- **[Lab 1: Todo Application](../../labs/sinatra/1-todo-app/)** - Classic CRUD app with database
- **[Lab 2: Blog API](../../labs/sinatra/2-blog-api/)** - RESTful API with authentication
- **[Lab 3: Authentication App](../../labs/sinatra/3-auth-app/)** - User registration, login, sessions
- **[Lab 4: Real-Time Chat](../../labs/sinatra/4-realtime-chat/)** - WebSocket-powered chat room

## 🐍➡️🔴 Key Concepts for Python Developers

### 1. Routes Use Blocks
```ruby
# Sinatra (Ruby)
get '/hello' do
  'Hello World'
end

# Flask (Python)
@app.route('/hello')
def hello():
    return 'Hello World'
```

### 2. Instance Variables for Templates
```ruby
# Sinatra
get '/user' do
  @name = "Alice"  # Accessible in template
  erb :user
end

# Flask
@app.route('/user')
def user():
    name = "Alice"
    return render_template('user.html', name=name)
```

### 3. Symbols for Keys
```ruby
# Sinatra
params[:name]  # Like request.args['name'] in Flask
session[:user_id]  # Like session['user_id'] in Flask
```

### 4. Implicit Returns
```ruby
# Sinatra - last expression is returned
get '/api/status' do
  { status: 'ok' }.to_json  # Automatically returned
end
```

### 5. No Application Instance
```ruby
# Sinatra - no app instance needed for simple apps
require 'sinatra'

get '/' do
  'Hello'
end

# Flask - always needs an app instance
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello'
```

## 🚀 Getting Started

### Prerequisites

Before starting, ensure you're comfortable with:
- Basic Ruby syntax (complete Ruby tutorials 1-10)
- HTTP fundamentals
- Web development concepts
- At least one Python web framework (Flask, Django, or FastAPI)

### Setup

1. **Start the development environment:**
```bash
tilt up
```

2. **Verify Sinatra is installed:**
```bash
docker-compose exec sinatra-web ruby -e "require 'sinatra'; puts Sinatra::VERSION"
```

3. **Run your first Sinatra app:**
```bash
docker-compose exec sinatra-web ruby ruby/tutorials/sinatra/1-hello-sinatra/app.rb
```

4. **Visit in your browser:**
```
http://localhost:4567
```

### Development Workflow

```bash
# Run a Sinatra application
docker-compose exec sinatra-web ruby path/to/app.rb

# Run with auto-reload (using rerun gem)
docker-compose exec sinatra-web rerun 'ruby path/to/app.rb'

# Access the web container shell
docker-compose exec sinatra-web bash

# Check logs
docker-compose logs -f sinatra-web

# Access database
docker-compose exec postgres psql -U postgres -d sinatra_dev

# Access Redis
docker-compose exec redis redis-cli
```

## 💡 Learning Tips

1. **Compare with Python:** Each tutorial includes Python comparisons
2. **Experiment in IRB:** Test Sinatra concepts in the Ruby REPL
3. **Read the source:** Sinatra's source code is remarkably readable
4. **Build, don't just read:** Complete all exercises and labs
5. **Use the browser:** Web development is visual - see your work!

## 🎓 What You'll Learn

After completing these tutorials, you'll be able to:
- ✅ Build web applications with Sinatra
- ✅ Understand Rack (Ruby's WSGI equivalent)
- ✅ Work with databases in Ruby web apps
- ✅ Create RESTful APIs
- ✅ Handle authentication and sessions
- ✅ Deploy Sinatra applications
- ✅ Compare Ruby and Python web frameworks

## 📖 Additional Resources

- [Official Sinatra Documentation](http://sinatrarb.com/)
- [Sinatra Recipes](http://recipes.sinatrarb.com/)
- [Rack Documentation](https://rack.github.io/)
- [Sinatra Book](https://github.com/sinatra/sinatra-book)
- [Ruby Style Guide](https://rubystyle.guide/)

## 🔜 Next Steps After Sinatra

Once you master Sinatra, explore:
- **Rails** - Full-featured web framework (like Django)
- **Roda** - High-performance routing tree framework
- **Hanami** - Modern, full-stack Ruby framework
- **Grape** - REST-like API framework

## 🆚 Framework Comparison

| Feature | Flask | Sinatra | Rails |
|---------|-------|---------|-------|
| Learning curve | Easy | Easy | Moderate |
| Size | Micro | Micro | Full-stack |
| Flexibility | High | High | Opinionated |
| ORM included | No | No | Yes |
| Best for | Small apps, APIs | Small apps, APIs | Large apps |
| Template engine | Jinja2 | ERB/Haml | ERB |
| Performance | Good | Good | Good |

---

**Ready to start?** Begin with **[Tutorial 1: Hello Sinatra](1-hello-sinatra/README.md)**!

Happy learning! 🚀💎
