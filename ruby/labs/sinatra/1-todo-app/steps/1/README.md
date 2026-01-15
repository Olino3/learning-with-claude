# Step 1: Basic Sinatra Setup

**Estimated Time:** 15 minutes

[Next Step →](../2/README.md)

---

## 🎯 Goal

Create a basic Sinatra application with a home route.

## 📝 Tasks

### 1. Create the main application file (`app.rb`)

```ruby
require 'sinatra'

get '/' do
  "Hello, Todo App!"
end
```

### 2. Run the application

```bash
ruby app.rb
```

### 3. Visit `http://localhost:4567` in your browser

You should see "Hello, Todo App!" displayed.

### 4. Enhance the home route

Update your `app.rb` to redirect to the tasks route:

```ruby
require 'sinatra'

get '/' do
  redirect '/tasks'
end

get '/tasks' do
  "Your tasks will appear here"
end
```

Restart the server and verify the redirect works.

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Sinatra app runs without errors
- [ ] You can access localhost:4567
- [ ] Routes redirect properly from `/` to `/tasks`

## 🎓 What You Learned

- How to create a basic Sinatra application
- Defining GET routes
- Using the `redirect` helper
- Running a Sinatra server locally

---

[Next Step: Add Database →](../2/README.md)
