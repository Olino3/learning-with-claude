# Tutorial 7: Middleware and Filters - Request/Response Processing

Learn how to use filters and middleware to process requests and responses, implement authentication, logging, and cross-cutting concerns in Sinatra.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use before and after filters
- Implement conditional filters
- Create and use Rack middleware
- Build authentication filters
- Add logging and monitoring
- Handle CORS requests
- Implement rate limiting

## 🐍➡️🔴 Coming from Flask

Filters in Sinatra are similar to Flask's before/after request hooks:

| Feature | Flask | Sinatra |
|---------|-------|---------|
| Before request | `@app.before_request` | `before do` |
| After request | `@app.after_request` | `after do` |
| Conditional | Check in function | `before '/path' do` |
| Middleware | WSGI middleware | Rack middleware |
| Decorators | `@login_required` | Filters or helpers |

## 🔄 Before Filters

Before filters run before each request:

### Basic Before Filter

```ruby
require 'sinatra'

before do
  puts "Request received: #{request.path}"
  @start_time = Time.now
end

get '/' do
  'Hello World!'
end
```

### Conditional Before Filters

```ruby
# Only for specific paths
before '/admin/*' do
  require_admin_login
end

# Using pattern matching
before %r{/api/v\d+/.*} do
  verify_api_key
end

# Multiple filters
before '/protected/*', '/secure/*' do
  require_authentication
end

# Conditional execution
before do
  pass unless request.path.start_with?('/api')
  content_type :json
end
```

## ⏭️ After Filters

After filters run after each request:

```ruby
after do
  # Add custom header
  response.headers['X-Server'] = 'Sinatra'

  # Log response time
  elapsed = Time.now - @start_time
  puts "Response time: #{elapsed}s"
end

# Conditional after filter
after '/api/*' do
  # Ensure all API responses are JSON
  content_type :json unless response.content_type
end
```

## 🐍 Flask Comparison

**Flask:**
```python
@app.before_request
def before_request():
    g.start_time = time.time()

@app.after_request
def after_request(response):
    elapsed = time.time() - g.start_time
    response.headers['X-Response-Time'] = str(elapsed)
    return response
```

**Sinatra:**
```ruby
before do
  @start_time = Time.now
end

after do
  elapsed = Time.now - @start_time
  response.headers['X-Response-Time'] = elapsed.to_s
end
```

## 🔐 Authentication Filters

### Basic Authentication Filter

```ruby
helpers do
  def authenticated?
    session[:user_id]
  end

  def require_login
    unless authenticated?
      session[:return_to] = request.path
      redirect '/login'
    end
  end
end

# Protect all admin routes
before '/admin/*' do
  require_login
end

get '/admin/dashboard' do
  'Admin Dashboard'
end
```

### Role-Based Access Control

```ruby
helpers do
  def current_user
    @current_user ||= User[session[:user_id]] if session[:user_id]
  end

  def require_role(role)
    halt 403, 'Forbidden' unless current_user && current_user.role == role
  end
end

before '/admin/*' do
  require_role('admin')
end

before '/moderator/*' do
  halt 403 unless current_user && ['admin', 'moderator'].include?(current_user.role)
end
```

## 📝 Logging Middleware

### Request Logging

```ruby
require 'sinatra'
require 'logger'

configure do
  set :logger, Logger.new($stdout)
end

before do
  logger.info "#{request.request_method} #{request.path}"
  logger.info "Params: #{params.inspect}"
end

after do
  logger.info "Status: #{response.status}"
end

get '/' do
  logger.debug "Processing home page request"
  'Hello World!'
end
```

### Custom Logger Middleware

```ruby
class RequestLogger
  def initialize(app, logger = nil)
    @app = app
    @logger = logger || Logger.new($stdout)
  end

  def call(env)
    request = Rack::Request.new(env)
    @logger.info "Started #{request.request_method} #{request.path}"

    status, headers, body = @app.call(env)

    @logger.info "Completed #{status} in #{Time.now}"

    [status, headers, body]
  end
end

use RequestLogger
```

## 🌐 CORS Middleware

### Simple CORS Implementation

```ruby
before do
  # Allow CORS for all origins
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
          'Access-Control-Allow-Headers' => 'Content-Type, Authorization'
end

# Handle OPTIONS preflight requests
options '*' do
  200
end
```

### Rack::Cors Middleware

```ruby
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :delete, :options],
      credentials: true,
      max_age: 600
  end

  allow do
    origins 'https://example.com'
    resource '/api/*',
      headers: :any,
      methods: [:get, :post],
      credentials: true
  end
end
```

## ⏱️ Rate Limiting

### Simple Rate Limiter

```ruby
require 'sinatra'

configure do
  set :rate_limits, {}
  set :rate_limit_window, 60  # seconds
  set :rate_limit_max, 100    # requests
end

helpers do
  def rate_limit_key
    request.ip
  end

  def check_rate_limit
    key = rate_limit_key
    now = Time.now.to_i
    window_start = now - settings.rate_limit_window

    # Initialize or clean old entries
    settings.rate_limits[key] ||= []
    settings.rate_limits[key].reject! { |time| time < window_start }

    # Check limit
    if settings.rate_limits[key].length >= settings.rate_limit_max
      halt 429, { error: 'Rate limit exceeded' }.to_json
    end

    # Add current request
    settings.rate_limits[key] << now
  end
end

before '/api/*' do
  check_rate_limit
end
```

### Rack::Attack Middleware

```ruby
require 'rack/attack'

class Rack::Attack
  # Throttle all requests by IP
  throttle('requests by ip', limit: 100, period: 60) do |request|
    request.ip
  end

  # Throttle login attempts
  throttle('login attempts', limit: 5, period: 60) do |request|
    if request.path == '/login' && request.post?
      request.ip
    end
  end

  # Block specific IPs
  blocklist('block specific IPs') do |request|
    ['192.168.1.100', '10.0.0.50'].include?(request.ip)
  end
end

use Rack::Attack
```

## 🔧 Custom Middleware

### Response Time Middleware

```ruby
class ResponseTimeMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.now

    status, headers, body = @app.call(env)

    elapsed = ((Time.now - start_time) * 1000).round(2)
    headers['X-Response-Time'] = "#{elapsed}ms"

    [status, headers, body]
  end
end

use ResponseTimeMiddleware
```

### API Key Validation Middleware

```ruby
class ApiKeyMiddleware
  def initialize(app, options = {})
    @app = app
    @api_keys = options[:api_keys] || []
  end

  def call(env)
    request = Rack::Request.new(env)

    # Skip validation for non-API routes
    return @app.call(env) unless request.path.start_with?('/api')

    api_key = request.get_header('HTTP_X_API_KEY')

    if api_key && @api_keys.include?(api_key)
      @app.call(env)
    else
      [401, {'Content-Type' => 'application/json'}, ['{"error": "Invalid API key"}']]
    end
  end
end

use ApiKeyMiddleware, api_keys: ['secret123', 'secret456']
```

## 🔒 Security Middleware

### Rack::Protection

Sinatra includes Rack::Protection by default:

```ruby
# Enabled by default
set :protection, true

# Disable specific protections
set :protection, except: [:json_csrf]

# Configure protection
set :protection, frame_options: :deny,
                 content_security_policy: "default-src 'self'"
```

### Custom Security Headers

```ruby
class SecurityHeadersMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    # Add security headers
    headers['X-Frame-Options'] = 'DENY'
    headers['X-Content-Type-Options'] = 'nosniff'
    headers['X-XSS-Protection'] = '1; mode=block'
    headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    headers['Content-Security-Policy'] = "default-src 'self'"

    [status, headers, body]
  end
end

use SecurityHeadersMiddleware
```

## 📊 Monitoring Middleware

### Performance Monitoring

```ruby
class PerformanceMonitor
  def initialize(app)
    @app = app
    @stats = Hash.new { |h, k| h[k] = { count: 0, total_time: 0 } }
  end

  def call(env)
    request = Rack::Request.new(env)
    start_time = Time.now

    status, headers, body = @app.call(env)

    elapsed = Time.now - start_time
    path = request.path

    @stats[path][:count] += 1
    @stats[path][:total_time] += elapsed

    puts "Stats for #{path}: " +
         "#{@stats[path][:count]} requests, " +
         "avg time: #{(@stats[path][:total_time] / @stats[path][:count]).round(3)}s"

    [status, headers, body]
  end
end

use PerformanceMonitor
```

## 🔄 Pass and Halt

### Pass Control

```ruby
# Pass to next matching route
get '/?' do
  pass if params[:skip]
  'First route'
end

get '/' do
  'Second route'
end
```

### Halt Execution

```ruby
before do
  halt 401, 'Unauthorized' unless authenticated?
end

get '/admin' do
  halt 403, 'Forbidden' unless admin?
  'Admin page'
end
```

## ✍️ Exercises

### Exercise 1: Authentication System

Build an auth system with filters:
- Login requirement filter
- Role-based access control
- Session timeout check
- Audit logging

**Solution:** [auth_filters_app.rb](auth_filters_app.rb)

### Exercise 2: API with Middleware

Create an API with:
- API key validation
- Rate limiting
- Request logging
- CORS support
- Error handling

**Solution:** [api_middleware_app.rb](api_middleware_app.rb)

### Exercise 3: Performance Monitor

Build a monitoring system:
- Request timing
- Endpoint statistics
- Slow request detection
- Performance dashboard

**Solution:** [performance_monitor_app.rb](performance_monitor_app.rb)

## 🎓 Key Concepts

1. **Before Filters**: Run before route handlers
2. **After Filters**: Run after route handlers
3. **Middleware**: Wrap the entire application
4. **Halt**: Stop execution and return response
5. **Pass**: Skip to next matching route
6. **Conditional Filters**: Apply only to specific routes

## 🐞 Common Issues

### Issue 1: Filter Order Matters

Filters execute in the order they're defined:

```ruby
# This won't work as expected
get '/admin' do
  'Admin'
end

before '/admin' do
  require_login  # Defined after route
end

# Correct order
before '/admin' do
  require_login
end

get '/admin' do
  'Admin'
end
```

### Issue 2: After Filter Not Modifying Body

After filters can modify headers but not body directly:

```ruby
# Won't work
after do
  body << "Footer"
end

# Use template or build response in route
get '/' do
  content = "Main content"
  footer = "Footer"
  content + footer
end
```

## 📊 Middleware Quick Reference

| Task | Flask/WSGI | Sinatra/Rack |
|------|------------|--------------|
| Before request | `@before_request` | `before do` |
| After request | `@after_request` | `after do` |
| Middleware | WSGI middleware | `use Middleware` |
| Stop execution | `abort()` | `halt status, body` |
| Skip route | N/A | `pass` |
| Request logging | Flask logging | Rack::CommonLogger |
| CORS | flask-cors | rack-cors |
| Rate limiting | flask-limiter | rack-attack |

## 🔜 What's Next?

You now know:
- ✅ How to use before and after filters
- ✅ How to implement authentication filters
- ✅ How to create custom middleware
- ✅ How to handle CORS and rate limiting
- ✅ How to add logging and monitoring

Next: Building RESTful APIs with proper structure!

**Next:** [Tutorial 8: RESTful APIs](../8-restful-apis/README.md)

## 📖 Additional Resources

- [Sinatra Filters Documentation](http://sinatrarb.com/intro.html#Filters)
- [Rack Middleware](https://github.com/rack/rack/wiki/List-of-Middleware)
- [Rack::Protection](https://github.com/sinatra/sinatra/tree/master/rack-protection)
- [Rack::Attack](https://github.com/rack/rack-attack)
- [Rack::Cors](https://github.com/cyu/rack-cors)

---

Ready to practice? Start with **Exercise 1: Authentication System**!
