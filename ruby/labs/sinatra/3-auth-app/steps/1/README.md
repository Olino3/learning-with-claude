# Step 1: Basic Web App Setup

[Next Step →](../2/README.md)

**Estimated Time**: 20 minutes

## 🎯 Goal
Create a Sinatra web application with views and layout.

## 📝 Tasks

### 1. Create app.rb

```ruby
require 'sinatra'

enable :sessions
set :session_secret, ENV.fetch('SESSION_SECRET', 'change_this_in_production')

get '/' do
  erb :home
end
```

### 2. Create layout (views/layout.erb)

```erb
<!DOCTYPE html>
<html>
<head>
  <title>Auth App</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/css/style.css">
</head>
<body>
  <header>
    <div class="container">
      <h1>🔐 Auth App</h1>
      <nav>
        <a href="/">Home</a>
      </nav>
    </div>
  </header>

  <main class="container">
    <%= yield %>
  </main>
</body>
</html>
```

### 3. Create home view (views/home.erb)

```erb
<div class="hero">
  <h2>Welcome to Auth App</h2>
  <p>A demonstration of secure authentication with Sinatra</p>
</div>
```

### 4. Add basic CSS (public/css/style.css)

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, sans-serif;
  line-height: 1.6;
  color: #333;
  background: #f5f5f5;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
}

header {
  background: #2c3e50;
  color: white;
  padding: 1rem 0;
}

header nav {
  margin-top: 1rem;
}

header nav a {
  color: white;
  margin-right: 1rem;
  text-decoration: none;
}

main {
  padding: 2rem 0;
}

.hero {
  background: white;
  padding: 3rem;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
```

## ✅ Checkpoint

Run the lab with:
```bash
make sinatra-lab NUM=3
```

Test that:
- [ ] App runs and displays home page at http://localhost:4567
- [ ] Layout and styling work correctly
- [ ] Sessions are enabled (check app.rb)

## 💡 What You Learned

- Setting up a Sinatra web application with views
- Enabling session support for authentication
- Creating a layout template for consistent page structure
- Basic CSS styling for a clean, modern interface
- ERB templating with yield for content injection

## 🎯 Tips

- The `enable :sessions` line is crucial for authentication
- `session_secret` should be random and kept secure in production
- Use environment variables for sensitive configuration
- The layout.erb file provides the HTML structure for all pages

---

[Next Step →](../2/README.md)
