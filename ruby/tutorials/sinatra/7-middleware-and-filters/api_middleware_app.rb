require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

# === MIDDLEWARE ===

# API Key Middleware
class ApiKeyMiddleware
  VALID_KEYS = ['test-key-123', 'demo-key-456']

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Skip for non-API routes
    return @app.call(env) unless request.path.start_with?('/api')

    api_key = request.get_header('HTTP_X_API_KEY')

    if VALID_KEYS.include?(api_key)
      @app.call(env)
    else
      [401, {'Content-Type' => 'application/json'}, 
       [JSON.generate({ error: 'Invalid or missing API key' })]]
    end
  end
end

# Rate Limit Middleware
class RateLimitMiddleware
  def initialize(app, limit: 10, window: 60)
    @app = app
    @limit = limit
    @window = window
    @requests = Hash.new { |h, k| h[k] = [] }
  end

  def call(env)
    request = Rack::Request.new(env)
    key = request.ip
    now = Time.now.to_i

    # Clean old requests
    @requests[key].reject! { |time| time < now - @window }

    # Check limit
    if @requests[key].length >= @limit
      return [429, {'Content-Type' => 'application/json', 'Retry-After' => @window.to_s},
              [JSON.generate({ error: 'Rate limit exceeded', retry_after: @window })]]
    end

    @requests[key] << now
    @app.call(env)
  end
end

# CORS Middleware
class CorsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['REQUEST_METHOD'] == 'OPTIONS'
      return [200, cors_headers, ['']]
    end

    status, headers, body = @app.call(env)
    headers.merge!(cors_headers)
    [status, headers, body]
  end

  private

  def cors_headers
    {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers' => 'Content-Type, X-API-Key',
      'Access-Control-Max-Age' => '600'
    }
  end
end

# Request Logger Middleware
class RequestLoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    start_time = Time.now

    puts "\n=== Request ==="
    puts "#{request.request_method} #{request.path}"
    puts "IP: #{request.ip}"
    puts "Headers: #{request.env.select { |k, v| k.start_with?('HTTP_') }}"

    status, headers, body = @app.call(env)

    elapsed = ((Time.now - start_time) * 1000).round(2)
    puts "Status: #{status}"
    puts "Time: #{elapsed}ms"
    puts "===============\n"

    [status, headers, body]
  end
end

# Apply middleware
use RequestLoggerMiddleware
use CorsMiddleware
use ApiKeyMiddleware
use RateLimitMiddleware, limit: 10, window: 60

# === CONFIGURATION ===

set :show_exceptions, false

before do
  content_type :json
end

# === ERROR HANDLERS ===

error 404 do
  JSON.generate({ error: 'Not found', path: request.path })
end

error 500 do
  JSON.generate({ error: 'Internal server error' })
end

# === ROUTES ===

get '/' do
  JSON.generate({
    message: 'API Middleware Demo',
    version: '1.0.0',
    endpoints: [
      'GET /api/health',
      'GET /api/users',
      'GET /api/users/:id',
      'POST /api/users',
      'GET /api/protected'
    ],
    authentication: {
      method: 'API Key',
      header: 'X-API-Key',
      test_keys: ['test-key-123', 'demo-key-456']
    },
    rate_limit: {
      limit: 10,
      window: 60,
      unit: 'seconds'
    }
  })
end

get '/api/health' do
  JSON.generate({
    status: 'ok',
    timestamp: Time.now.to_i,
    uptime: Process.clock_gettime(Process::CLOCK_MONOTONIC).round
  })
end

get '/api/users' do
  users = [
    { id: 1, name: 'Alice', email: 'alice@example.com' },
    { id: 2, name: 'Bob', email: 'bob@example.com' },
    { id: 3, name: 'Charlie', email: 'charlie@example.com' }
  ]

  JSON.generate({ users: users, count: users.length })
end

get '/api/users/:id' do
  id = params[:id].to_i

  user = case id
         when 1 then { id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' }
         when 2 then { id: 2, name: 'Bob', email: 'bob@example.com', role: 'user' }
         when 3 then { id: 3, name: 'Charlie', email: 'charlie@example.com', role: 'user' }
         else nil
         end

  if user
    JSON.generate(user)
  else
    status 404
    JSON.generate({ error: 'User not found', id: id })
  end
end

post '/api/users' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  # Validation
  errors = []
  errors << 'Name is required' if data['name'].to_s.empty?
  errors << 'Email is required' if data['email'].to_s.empty?

  if errors.any?
    status 400
    return JSON.generate({ error: 'Validation failed', details: errors })
  end

  # Create user (simulated)
  user = {
    id: rand(100..999),
    name: data['name'],
    email: data['email'],
    created_at: Time.now.to_i
  }

  status 201
  JSON.generate({ message: 'User created', user: user })
end

get '/api/protected' do
  JSON.generate({
    message: 'This is a protected endpoint',
    user: 'authenticated',
    timestamp: Time.now.to_i
  })
end
