# Tutorial 6: Sessions and Cookies - State Management in Web Applications

Learn how to manage user sessions, work with cookies, implement flash messages, and handle user authentication in Sinatra.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Configure and use sessions in Sinatra
- Work with cookies (reading and setting)
- Implement flash messages
- Build user authentication systems
- Use Redis for session storage
- Secure sessions and prevent attacks
- Handle "Remember Me" functionality

## 🐍➡️🔴 Coming from Flask

Sessions and cookies in Sinatra work similarly to Flask:

| Feature | Flask | Sinatra |
|---------|-------|---------|
| Enable sessions | `app.secret_key = 'key'` | `enable :sessions` |
| Session secret | `app.secret_key` | `set :session_secret` |
| Set session | `session['key'] = val` | `session[:key] = val` |
| Get session | `session.get('key')` | `session[:key]` |
| Clear session | `session.clear()` | `session.clear` |
| Flash messages | `flash('msg')` | Manual implementation |
| Set cookie | `resp.set_cookie()` | `response.set_cookie` |
| Get cookie | `request.cookies['key']` | `request.cookies['key']` |

## 🔐 Enabling Sessions

### Basic Session Configuration

```ruby
require 'sinatra'

# Enable sessions (uses cookie-based storage)
enable :sessions

# Set session secret (use environment variable in production)
set :session_secret, ENV['SESSION_SECRET'] || 'change_me_in_production'

get '/' do
  session[:visits] ||= 0
  session[:visits] += 1

  "You've visited this page #{session[:visits]} times"
end

get '/reset' do
  session.clear
  redirect '/'
end
```

### 🐍 Flask Comparison

**Flask:**
```python
from flask import Flask, session

app = Flask(__name__)
app.secret_key = 'your-secret-key'

@app.route('/')
def index():
    if 'visits' not in session:
        session['visits'] = 0
    session['visits'] += 1
    return f"Visits: {session['visits']}"

@app.route('/reset')
def reset():
    session.clear()
    return redirect('/')
```

**Sinatra:**
```ruby
enable :sessions
set :session_secret, 'your-secret-key'

get '/' do
  session[:visits] ||= 0
  session[:visits] += 1
  "Visits: #{session[:visits]}"
end

get '/reset' do
  session.clear
  redirect '/'
end
```

## 🍪 Working with Cookies

### Reading Cookies

```ruby
get '/' do
  # Get cookie value
  username = request.cookies['username']

  if username
    "Welcome back, #{username}!"
  else
    "Hello, stranger!"
  end
end
```

### Setting Cookies

```ruby
post '/login' do
  # Set simple cookie
  response.set_cookie('username', params[:username])

  # Set cookie with options
  response.set_cookie('username',
    value: params[:username],
    max_age: 30 * 24 * 60 * 60,  # 30 days in seconds
    path: '/',
    httponly: true,
    secure: production?,
    same_site: :strict
  )

  redirect '/'
end
```

### Deleting Cookies

```ruby
get '/logout' do
  response.delete_cookie('username')
  redirect '/'
end

# Or set with expired date
post '/logout' do
  response.set_cookie('username', value: '', max_age: 0)
  redirect '/'
end
```

### Cookie Options Explained

```ruby
response.set_cookie('name',
  value: 'value',           # Cookie value
  max_age: 3600,           # Expiry in seconds (1 hour)
  expires: Time.now + 3600, # Alternative to max_age
  path: '/',               # Cookie path
  domain: '.example.com',  # Cookie domain
  secure: true,            # Only send over HTTPS
  httponly: true,          # Not accessible via JavaScript
  same_site: :strict       # CSRF protection (:strict, :lax, :none)
)
```

## 🔔 Implementing Flash Messages

Flash messages are temporary messages that persist for one request:

### Basic Flash Implementation

```ruby
require 'sinatra'

enable :sessions

helpers do
  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    message = session["flash_#{key}".to_sym]
    session.delete("flash_#{key}".to_sym)
    message
  end
end

post '/login' do
  if params[:username] == 'admin' && params[:password] == 'secret'
    flash(:success, 'Login successful!')
    redirect '/dashboard'
  else
    flash(:error, 'Invalid credentials')
    redirect '/login'
  end
end

get '/dashboard' do
  @success = get_flash(:success)
  @error = get_flash(:error)
  erb :dashboard
end
```

### Using Sinatra-Flash Gem

```ruby
require 'sinatra'
require 'sinatra/flash'

enable :sessions

post '/login' do
  if valid_login?
    flash[:success] = 'Welcome!'
    redirect '/dashboard'
  else
    flash.now[:error] = 'Invalid credentials'
    erb :login
  end
end
```

## 🔐 User Authentication Example

### Simple Authentication System

```ruby
require 'sinatra'
require 'bcrypt'

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)

# Simulated user database
USERS = {
  'alice' => BCrypt::Password.create('password123'),
  'bob' => BCrypt::Password.create('secret456')
}

helpers do
  def current_user
    @current_user ||= session[:username]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      session[:return_to] = request.path
      redirect '/login'
    end
  end

  def authenticate(username, password)
    return false unless USERS[username]
    BCrypt::Password.new(USERS[username]) == password
  end
end

# Public routes
get '/' do
  erb :home
end

get '/login' do
  redirect '/dashboard' if logged_in?
  erb :login
end

post '/login' do
  username = params[:username]
  password = params[:password]

  if authenticate(username, password)
    session[:username] = username
    session[:logged_in_at] = Time.now

    # Remember me functionality
    if params[:remember_me]
      response.set_cookie('remember_token',
        value: generate_token(username),
        max_age: 30 * 24 * 60 * 60,  # 30 days
        httponly: true,
        secure: production?
      )
    end

    return_to = session.delete(:return_to) || '/dashboard'
    redirect return_to
  else
    @error = 'Invalid username or password'
    erb :login
  end
end

get '/logout' do
  session.clear
  response.delete_cookie('remember_token')
  redirect '/'
end

# Protected routes
get '/dashboard' do
  require_login
  erb :dashboard
end

get '/profile' do
  require_login
  erb :profile
end
```

## 🗝️ Remember Me Functionality

```ruby
require 'securerandom'

# Token storage (use database in production)
REMEMBER_TOKENS = {}

helpers do
  def generate_token(username)
    token = SecureRandom.hex(32)
    REMEMBER_TOKENS[token] = {
      username: username,
      created_at: Time.now
    }
    token
  end

  def find_user_by_token(token)
    return nil unless REMEMBER_TOKENS[token]

    data = REMEMBER_TOKENS[token]

    # Token expires after 30 days
    if Time.now - data[:created_at] > 30 * 24 * 60 * 60
      REMEMBER_TOKENS.delete(token)
      return nil
    end

    data[:username]
  end

  def auto_login_from_cookie
    return if logged_in?

    token = request.cookies['remember_token']
    return unless token

    username = find_user_by_token(token)
    if username
      session[:username] = username
      @current_user = username
    else
      response.delete_cookie('remember_token')
    end
  end
end

before do
  auto_login_from_cookie
end

post '/login' do
  # ... authentication logic ...

  if params[:remember_me]
    token = generate_token(username)
    response.set_cookie('remember_token',
      value: token,
      max_age: 30 * 24 * 60 * 60,
      httponly: true,
      secure: production?
    )
  end

  redirect '/dashboard'
end
```

## 🗄️ Redis-Based Sessions

For production applications with multiple servers:

```ruby
require 'sinatra'
require 'rack/session/redis'

use Rack::Session::Redis,
  redis_server: {
    host: ENV['REDIS_HOST'] || 'localhost',
    port: ENV['REDIS_PORT'] || 6379,
    db: 0
  },
  key: 'my_app_session',
  expire_after: 30 * 24 * 60 * 60  # 30 days

get '/' do
  session[:visits] ||= 0
  session[:visits] += 1
  "Visits: #{session[:visits]}"
end
```

### Installing Redis Dependencies

```bash
gem install redis
gem install rack-session
```

## 🔒 Session Security Best Practices

### 1. Secure Session Configuration

```ruby
require 'securerandom'

configure do
  # Use strong secret key
  set :session_secret, ENV.fetch('SESSION_SECRET') {
    raise 'SESSION_SECRET environment variable must be set'
  }

  # Session configuration
  use Rack::Session::Cookie,
    key: 'myapp.session',
    secret: settings.session_secret,
    httponly: true,
    secure: production?,
    same_site: :strict,
    expire_after: 2592000  # 30 days
end
```

### 2. Session Timeout

```ruby
helpers do
  def check_session_timeout
    if session[:last_activity]
      # 30 minutes timeout
      if Time.now - session[:last_activity] > 1800
        session.clear
        flash(:warning, 'Session expired. Please login again.')
        redirect '/login'
      end
    end
    session[:last_activity] = Time.now
  end
end

before do
  check_session_timeout if logged_in?
end
```

### 3. Session Regeneration

```ruby
helpers do
  def regenerate_session
    old_session = session.dup
    session.clear
    old_session.each { |key, value| session[key] = value }
  end
end

post '/login' do
  if authenticate(username, password)
    regenerate_session  # Prevent session fixation
    session[:username] = username
    redirect '/dashboard'
  end
end
```

## 🐍 Flask Session Comparison

**Flask:**
```python
from flask import Flask, session

app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=30)

@app.route('/login', methods=['POST'])
def login():
    if authenticate(username, password):
        session['username'] = username
        session.permanent = True
        return redirect('/dashboard')
```

**Sinatra:**
```ruby
use Rack::Session::Cookie,
  expire_after: 30 * 24 * 60 * 60

post '/login' do
  if authenticate(username, password)
    session[:username] = username
    redirect '/dashboard'
  end
end
```

## ✍️ Exercises

### Exercise 1: Shopping Cart

Build a shopping cart using sessions:
- Add/remove items
- View cart
- Calculate total
- Persist across requests

**Solution:** [shopping_cart_app.rb](shopping_cart_app.rb)

### Exercise 2: User Authentication

Create a complete auth system:
- Registration
- Login/logout
- Protected routes
- Flash messages
- Session timeout

**Solution:** [auth_system_app.rb](auth_system_app.rb)

### Exercise 3: Multi-Language Site

Build a language selector:
- Cookie-based language preference
- Switch between languages
- Persist selection
- Translate common phrases

**Solution:** [language_selector_app.rb](language_selector_app.rb)

## 🎓 Key Concepts

1. **Sessions**: Server-side storage for user data across requests
2. **Cookies**: Client-side storage (sent with every request)
3. **Flash Messages**: Temporary messages that expire after one request
4. **Session Security**: HTTPOnly, Secure, SameSite attributes
5. **Remember Me**: Long-lived authentication tokens
6. **Session Storage**: Cookie-based, Redis, Memcached

## 🐞 Common Issues

### Issue 1: Sessions Not Persisting

**Problem:** Session data is lost between requests

**Solution:** Ensure sessions are enabled and secret is set
```ruby
enable :sessions
set :session_secret, 'your-secret-key-here'
```

### Issue 2: Cookie Not Being Set

**Problem:** `response.set_cookie` doesn't work

**Solution:** Make sure to set cookie before redirect
```ruby
post '/login' do
  response.set_cookie('user', 'alice')
  # Cookie is set before redirect
  redirect '/'
end
```

### Issue 3: Session Security Warning

**Problem:** Warning about session secret

**Solution:** Set explicit session secret
```ruby
set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)
```

## 📊 Sessions Quick Reference

| Task | Flask | Sinatra |
|------|-------|---------|
| Enable | `app.secret_key = 'key'` | `enable :sessions` |
| Set value | `session['key'] = val` | `session[:key] = val` |
| Get value | `session.get('key')` | `session[:key]` |
| Check exists | `'key' in session` | `session.key?(:key)` |
| Delete key | `session.pop('key')` | `session.delete(:key)` |
| Clear all | `session.clear()` | `session.clear` |
| Set cookie | `resp.set_cookie()` | `response.set_cookie()` |
| Get cookie | `request.cookies['key']` | `request.cookies['key']` |

## 🔜 What's Next?

You now know:
- ✅ How to use sessions and cookies
- ✅ How to implement flash messages
- ✅ How to build authentication systems
- ✅ How to secure sessions
- ✅ How to use Redis for session storage

Next: Middleware and filters for request processing!

**Next:** [Tutorial 7: Middleware and Filters](../7-middleware-and-filters/README.md)

## 📖 Additional Resources

- [Rack Session Documentation](https://github.com/rack/rack-session)
- [Cookie Security Best Practices](https://owasp.org/www-community/controls/SecureCookieAttribute)
- [Redis Session Store](https://github.com/redis-store/redis-rack)
- [OWASP Session Management](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/06-Session_Management_Testing/01-Testing_for_Session_Management_Schema)

---

Ready to practice? Start with **Exercise 1: Shopping Cart**!
