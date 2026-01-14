#!/usr/bin/env ruby
# Step 9: Plugin System

require 'json'

puts "=" * 60
puts "Step 9: Plugin System"
puts "=" * 60
puts

# Simplified Request/Response
class Request
  attr_reader :method, :path, :headers
  attr_accessor :params

  def initialize(method:, path:, headers: {})
    @method = method
    @path = path
    @headers = headers
    @params = {}
  end
end

class Response
  attr_accessor :status, :headers, :body

  def initialize
    @status = 200
    @headers = {}
    @body = ""
  end

  def json(data)
    @headers['Content-Type'] = 'application/json'
    @body = data.to_json
  end
end

# Base Plugin class
class Plugin
  def self.install(app, **options)
    raise NotImplementedError
  end
end

# Logging Plugin
class LoggingPlugin < Plugin
  def self.install(app)
    app.use(->(req, res, next_middleware) {
      start_time = Time.now
      puts "  [LOG] #{Time.now.strftime('%H:%M:%S')} #{req.method} #{req.path}"
      
      next_middleware.call
      
      duration = ((Time.now - start_time) * 1000).round(2)
      puts "  [LOG] Completed #{res.status} in #{duration}ms"
    })
  end
end

# Authentication Plugin
class AuthPlugin < Plugin
  def self.install(app, api_key:)
    app.use(->(req, res, next_middleware) {
      if req.headers['Authorization'] == "Bearer #{api_key}"
        puts "  [AUTH] Valid API key"
        next_middleware.call
      else
        puts "  [AUTH] Invalid or missing API key"
        res.status = 401
        res.body = "Unauthorized"
      end
    })
  end
end

# CORS Plugin
class CorsPlugin < Plugin
  def self.install(app, origins: "*")
    app.use(->(req, res, next_middleware) {
      res.headers['Access-Control-Allow-Origin'] = origins
      res.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
      puts "  [CORS] Headers added for origin: #{origins}"
      next_middleware.call
    })
  end
end

# Application with middleware support
class Application
  def initialize
    @middleware = []
    @handler = nil
  end

  def use(middleware)
    @middleware << middleware
  end

  def handle(&block)
    @handler = block
  end

  def call(request)
    response = Response.new
    
    # Build middleware chain
    chain = @middleware.reverse.reduce(@handler) do |next_handler, middleware|
      ->(req, res) { middleware.call(req, res, -> { next_handler.call(req, res) }) }
    end

    chain.call(request, response)
    response
  end
end

# Create application
app = Application.new

# Install plugins
puts "Installing plugins:"
puts "-" * 60
LoggingPlugin.install(app)
CorsPlugin.install(app, origins: "https://example.com")
AuthPlugin.install(app, api_key: "secret123")
puts

# Define handler
app.handle do |req, res|
  res.json({ message: "Hello from the API!", path: req.path })
end

# Test requests
puts "Testing requests:"
puts "-" * 60

puts "\n1. Request without auth:"
request = Request.new(method: :GET, path: "/api/data", headers: {})
response = app.call(request)
puts "   Response: #{response.status} - #{response.body}"

puts "\n2. Request with valid auth:"
request = Request.new(
  method: :GET,
  path: "/api/data",
  headers: { 'Authorization' => 'Bearer secret123' }
)
response = app.call(request)
puts "   Response: #{response.status} - #{response.body}"
puts "   CORS Header: #{response.headers['Access-Control-Allow-Origin']}"
puts

puts "=" * 60
puts "✓ Step 9 complete! Mini Framework Lab finished!"
puts "=" * 60
