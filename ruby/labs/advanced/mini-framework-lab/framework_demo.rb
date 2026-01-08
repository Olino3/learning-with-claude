#!/usr/bin/env ruby
# Mini Framework Lab - Demonstrating Design Patterns

# Simple router
class Router
  def initialize
    @routes = []
  end
  
  def get(path, &handler)
    @routes << { method: :GET, path: path, handler: handler }
  end
  
  def post(path, &handler)
    @routes << { method: :POST, path: path, handler: handler }
  end
  
  def route(method, path)
    @routes.find { |r| r[:method] == method && r[:path] == path }
  end
end

# Base controller
class Controller
  def render(data)
    { status: 200, body: data.to_s }
  end
  
  def json(data)
    { status: 200, body: data.inspect, content_type: 'application/json' }
  end
end

# Service object pattern
class UserService
  def create(params)
    # Business logic here
    { id: rand(1000), name: params[:name], created_at: Time.now }
  end
end

puts "=" * 70
puts "MINI FRAMEWORK LAB"
puts "=" * 70
puts

# Demo application
router = Router.new

router.get("/") { "Welcome to Mini Framework!" }
router.get("/users") { "User List" }
router.post("/users") { |params| UserService.new.create(params) }

# Simulate requests
puts "GET /:"
route = router.route(:GET, "/")
puts "  Response: #{route[:handler].call}"
puts

puts "GET /users:"
route = router.route(:GET, "/users")
puts "  Response: #{route[:handler].call}"
puts

puts "POST /users:"
route = router.route(:POST, "/users")
result = route[:handler].call({ name: "Alice" })
puts "  Response: #{result}"

puts
puts "=" * 70
puts "Framework patterns demonstrated!"
puts "=" * 70
