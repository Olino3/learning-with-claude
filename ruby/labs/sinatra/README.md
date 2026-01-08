# Sinatra Labs - Hands-On Projects

Comprehensive hands-on labs for mastering Sinatra web development. Each lab is a complete, production-ready application demonstrating real-world patterns and best practices.

## 🎯 Overview

These labs integrate concepts from the Sinatra tutorials into complete applications. Build real projects to solidify your understanding and gain practical experience.

## 🐍 For Python Developers

Each lab includes detailed comparisons with Python frameworks:

| Lab | Sinatra | Flask | Django | FastAPI |
|-----|---------|-------|--------|---------|
| Lab 1 | Todo App | ✅ Similar | ✅ Similar | ✅ With API |
| Lab 2 | Blog API | ✅ Flask-RESTful | ✅ DRF | ✅ Very similar |
| Lab 3 | Auth System | ✅ Flask-Login | ✅ Built-in auth | ✅ OAuth2 |
| Lab 4 | WebSocket Chat | ✅ Flask-SocketIO | ✅ Channels | ✅ WebSocket |

## 💎 Labs

### Lab 1: Todo Application
**Difficulty:** ⭐⭐ Intermediate
**Time:** 2-3 hours

Build a full-featured todo list application with categories, filtering, and flash messages.

👉 **[Start Lab 1: Todo App](1-todo-app/README.md)**

**What you'll build:**
- Complete CRUD operations for tasks
- Category management
- Task filtering and sorting
- Form validation
- Flash message system
- RESTful route design

**Technologies:**
- SQLite database
- Sequel ORM
- ERB templates
- Session management

**Python equivalent:** Flask + SQLAlchemy todo app

---

### Lab 2: Blog API with Database
**Difficulty:** ⭐⭐⭐ Intermediate/Advanced
**Time:** 3-4 hours

Create a RESTful API for a blog platform with authentication and full CRUD.

👉 **[Start Lab 2: Blog API](2-blog-api/README.md)**

**What you'll build:**
- User registration and JWT authentication
- Posts with authors and tags
- Nested comments on posts
- API versioning (v1)
- Pagination and filtering
- JSON error handling

**Technologies:**
- PostgreSQL/SQLite
- ActiveRecord ORM
- JWT authentication
- JSON APIs

**Python equivalent:** Django REST Framework or FastAPI blog

---

### Lab 3: Web App with Authentication
**Difficulty:** ⭐⭐⭐ Intermediate/Advanced
**Time:** 3-4 hours

Build a secure web application with user authentication, registration, and protected routes.

👉 **[Start Lab 3: Authentication App](3-auth-app/README.md)**

**What you'll build:**
- User registration with validation
- Secure login/logout system
- BCrypt password hashing
- Session management
- "Remember me" functionality
- Protected routes
- User profiles
- CSRF protection

**Technologies:**
- ActiveRecord ORM
- BCrypt for passwords
- Rack::Protection
- Session cookies

**Python equivalent:** Flask-Login or Django authentication

---

### Lab 4: Real-Time Chat with WebSockets
**Difficulty:** ⭐⭐⭐⭐ Advanced
**Time:** 4-5 hours

Create a real-time chat application with WebSockets, multiple rooms, and user presence.

👉 **[Start Lab 4: Real-Time Chat](4-realtime-chat/README.md)**

**What you'll build:**
- WebSocket server with Faye-WebSocket
- Multiple chat rooms
- Real-time messaging
- User presence tracking
- Message persistence
- Client-side JavaScript
- EventMachine for async

**Technologies:**
- Faye-WebSocket
- EventMachine
- SQLite for messages
- JavaScript WebSocket client

**Python equivalent:** Flask-SocketIO, Django Channels, or FastAPI WebSocket

---

## 🚀 Getting Started

### Prerequisites

Complete at least the first 6 Sinatra tutorials before attempting these labs:

1. ✅ Hello Sinatra
2. ✅ Routes and Parameters
3. ✅ Templates and Views
4. ✅ Forms and User Input
5. ✅ Working with Databases
6. ✅ Sessions and Cookies

### Setup

1. **Start the development environment:**
```bash
tilt up
```

2. **Access the Sinatra container:**
```bash
docker-compose exec sinatra-web bash
```

3. **Navigate to a lab:**
```bash
cd ruby/labs/sinatra/1-todo-app
```

4. **Install dependencies (if needed):**
```bash
bundle install
```

5. **Set up the database:**
```bash
ruby app.rb  # Will auto-create database
```

6. **Run the application:**
```bash
ruby app.rb
```

7. **Visit in browser:**
```
http://localhost:4567
```

## 📊 Lab Comparison

| Lab | Concepts | Database | Auth | API | Real-time |
|-----|----------|----------|------|-----|-----------|
| 1 | CRUD, Forms, Sessions | SQLite | - | - | - |
| 2 | REST, JWT, JSON | PostgreSQL | ✅ | ✅ | - |
| 3 | Authentication, Security | SQLite | ✅ | - | - |
| 4 | WebSockets, Async | SQLite | - | - | ✅ |

## 🎓 What You'll Learn

After completing these labs, you'll understand:

### Lab 1: Foundation
- ✅ Sinatra project structure
- ✅ Database integration with ORMs
- ✅ Form handling and validation
- ✅ Session-based flash messages
- ✅ RESTful route design

### Lab 2: APIs
- ✅ Building RESTful APIs
- ✅ JWT authentication
- ✅ API versioning strategies
- ✅ JSON serialization
- ✅ Error handling patterns

### Lab 3: Security
- ✅ User authentication systems
- ✅ Password hashing with BCrypt
- ✅ Session management
- ✅ CSRF protection
- ✅ Secure cookie handling

### Lab 4: Real-Time
- ✅ WebSocket communication
- ✅ EventMachine async programming
- ✅ Real-time broadcasting
- ✅ Connection management
- ✅ Client-side JavaScript integration

## 💡 Learning Path

**Recommended order:**

1. **Start with Lab 1** - Build foundation skills
2. **Then Lab 2 OR Lab 3** - Choose based on interest:
   - Lab 2 if you want to build APIs
   - Lab 3 if you want to build web apps
3. **Finish with Lab 4** - Most advanced, requires async understanding

**Alternative approach:**

- **API Track:** Lab 1 → Lab 2 → Lab 4
- **Web App Track:** Lab 1 → Lab 3 → Lab 4

## 🔧 Lab Structure

Each lab follows this structure:

```
lab-name/
├── README.md           # Lab documentation
├── app.rb              # Main application
├── lib/                # Application logic
│   ├── models/         # Database models
│   └── helpers.rb      # Helper methods
├── views/              # ERB templates
│   ├── layout.erb      # Main layout
│   └── *.erb           # Page templates
└── public/             # Static assets
    ├── css/            # Stylesheets
    └── js/             # JavaScript
```

## 📚 Additional Challenges

After completing each lab, try these enhancements:

### Lab 1 Extensions
- Add task due dates and reminders
- Implement task priority levels
- Add task notes/descriptions
- Create task search functionality
- Export tasks to JSON/CSV

### Lab 2 Extensions
- Add post drafts and publishing
- Implement post scheduling
- Add image uploads for posts
- Create search with Elasticsearch
- Add rate limiting

### Lab 3 Extensions
- Add OAuth login (Google, GitHub)
- Implement two-factor authentication
- Add password reset via email
- Create admin dashboard
- Add user roles and permissions

### Lab 4 Extensions
- Add private messaging
- Implement typing indicators
- Add emoji support
- Create file sharing
- Add message search

## 🐞 Troubleshooting

### Database Issues

**Problem:** Database not found

**Solution:**
```bash
# Lab will auto-create database on first run
ruby app.rb
```

### Port Conflicts

**Problem:** Port 4567 already in use

**Solution:**
```ruby
# In app.rb
set :port, 3000  # Use different port
```

### Gem Missing

**Problem:** `LoadError: cannot load such file`

**Solution:**
```bash
gem install gem-name
# or
bundle install
```

## 📖 Resources

### Sinatra
- [Official Documentation](http://sinatrarb.com/)
- [Sinatra Recipes](http://recipes.sinatrarb.com/)
- [Sinatra Book](https://github.com/sinatra/sinatra-book)

### ORMs
- [Sequel Documentation](https://sequel.jeremyevans.net/)
- [ActiveRecord Guides](https://guides.rubyonrails.org/active_record_basics.html)

### Authentication
- [BCrypt-Ruby](https://github.com/bcrypt-ruby/bcrypt-ruby)
- [JWT Ruby](https://github.com/jwt/ruby-jwt)

### WebSockets
- [Faye-WebSocket](https://github.com/faye/faye-websocket-ruby)
- [EventMachine](https://github.com/eventmachine/eventmachine)

## 🎯 Next Steps

After completing these labs:

1. **Build Your Own Project**
   - Apply what you've learned
   - Choose a project that interests you
   - Start small and iterate

2. **Explore Advanced Topics**
   - Background jobs (Sidekiq)
   - Caching (Redis)
   - Testing (RSpec)
   - Deployment (Heroku, Docker)

3. **Contribute to Open Source**
   - Find Sinatra gems to contribute to
   - Share your own Sinatra projects
   - Help others learning Sinatra

4. **Learn Larger Frameworks**
   - **Rails** - Full-stack framework
   - **Roda** - High-performance routing
   - **Hanami** - Modern architecture

## 🤝 Support

Having issues? Check:
- Lab README for specific instructions
- Tutorial documentation
- [Sinatra GitHub Issues](https://github.com/sinatra/sinatra/issues)
- Ruby community forums

---

**Ready to build?** Start with **[Lab 1: Todo Application](1-todo-app/README.md)**!

Happy coding! 🚀💎
