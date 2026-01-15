#!/usr/bin/env ruby
# Step 3: Application Class

require 'json'

puts "=" * 60
puts "Step 3: Application Class"
puts "=" * 60
puts

# Simplified Router
class Router
  def initialize
    @routes = []
  end

  def get(pattern, handler)
    @routes << { method: :GET, pattern: pattern, handler: handler }
  end

  def post(pattern, handler)
    @routes << { method: :POST, pattern: pattern, handler: handler }
  end

  def match(method, path)
    @routes.find { |r| r[:method] == method && r[:pattern] == path }
  end
end

# Request/Response
class Request
  attr_reader :method, :path
  attr_accessor :params

  def initialize(method:, path:, params: {})
    @method = method
    @path = path
    @params = params
  end
end

class Response
  attr_accessor :status, :headers, :body

  def initialize
    @status = 200
    @headers = { 'Content-Type' => 'text/html' }
    @body = ""
  end

  def json(data)
    @headers['Content-Type'] = 'application/json'
    @body = data.to_json
    self
  end

  def html(content)
    @body = content
    self
  end
end

# Application Class
class Application
  def initialize
    @router = Router.new
    @middleware = []
  end

  def get(pattern, &handler)
    @router.get(pattern, handler)
  end

  def post(pattern, &handler)
    @router.post(pattern, handler)
  end

  def use(middleware)
    @middleware << middleware
  end

  def call(request)
    response = Response.new

    # Apply middleware
    @middleware.each { |m| m.call(request, response) }

    # Find and execute route
    route = @router.match(request.method, request.path)

    if route
      result = route[:handler].call(request, response)
      response.body = result if result.is_a?(String)
    else
      response.status = 404
      response.body = "Not Found"
    end

    response
  end
end

# Test the application
app = Application.new

# Add logging middleware
app.use(->(req, res) {
  puts "  [Middleware] #{req.method} #{req.path}"
})

# Define routes
app.get("/") do |req, res|
  res.html("<h1>Welcome!</h1>")
end

app.get("/api/users") do |req, res|
  res.json([{ id: 1, name: "Alice" }, { id: 2, name: "Bob" }])
end

app.post("/api/users") do |req, res|
  res.json({ created: true })
end

# Simulate requests
puts "Testing application:"
puts "-" * 60

[
  [:GET, "/"],
  [:GET, "/api/users"],
  [:POST, "/api/users"],
  [:GET, "/unknown"]
].each do |method, path|
  request = Request.new(method: method, path: path)
  response = app.call(request)
  puts "  Response: #{response.status} - #{response.body[0..50]}..."
  puts
end

puts "✓ Step 3 complete!"
