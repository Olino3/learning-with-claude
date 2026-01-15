#!/usr/bin/env ruby
# Mini Framework Lab - Complete Solution Demo

require_relative 'lib/router'
require_relative 'lib/request_response'
require_relative 'lib/application'
require_relative 'lib/controller'
require_relative 'lib/model'
require_relative 'lib/service'
require_relative 'lib/plugin'

puts "=" * 70
puts "MINI FRAMEWORK LAB - COMPLETE SOLUTION"
puts "=" * 70
puts

# ============================================================
# Part 1: Routing System
# ============================================================
puts "Part 1: Routing System"
puts "-" * 70

router = Router.new
router.get("/", ->(params) { "Home page" })
router.get("/users/:id", ->(params) { "User #{params['id']}" })
router.post("/users", ->(params) { "Create user" })
router.get("/posts/:post_id/comments/:id", ->(params) { 
  "Comment #{params['id']} on post #{params['post_id']}" 
})

puts "Testing routes:"
[
  [:GET, "/"],
  [:GET, "/users/123"],
  [:GET, "/posts/5/comments/42"],
  [:POST, "/users"],
  [:GET, "/nonexistent"]
].each do |method, path|
  result = router.match(method, path)
  if result
    output = result[:handler].call(result[:params])
    puts "  #{method} #{path} => #{output}"
  else
    puts "  #{method} #{path} => 404 Not Found"
  end
end
puts

# ============================================================
# Part 2: Request/Response
# ============================================================
puts "Part 2: Request/Response Objects"
puts "-" * 70

request = Request.new(
  method: :GET,
  path: "/users/42",
  params: { format: "json" },
  headers: { "Accept" => "application/json" }
)

response = Response.new
response.json({ id: 42, name: "Alice" })

puts "Request: #{request.method} #{request.path}"
puts "Response: #{response.status} #{response.headers['Content-Type']}"
puts "  Body: #{response.body}"
puts

# ============================================================
# Part 3: MVC - Controller
# ============================================================
puts "Part 3: Controllers"
puts "-" * 70

class UsersController < Controller
  def index
    json([{ id: 1, name: "Alice" }, { id: 2, name: "Bob" }])
  end

  def show
    json({ id: params["id"], name: "User #{params['id']}" })
  end
end

request = Request.new(method: :GET, path: "/users/42", params: { "id" => "42" })
response = Response.new
controller = UsersController.new(request, response)
controller.show

puts "Controller action result:"
puts "  Status: #{response.status}"
puts "  Body: #{response.body}"
puts

# ============================================================
# Part 4: Model Layer
# ============================================================
puts "Part 4: Model Layer"
puts "-" * 70

class User < Model; end
class Post < Model; end

user1 = User.create(name: "Alice", email: "alice@example.com")
user2 = User.create(name: "Bob", email: "bob@example.com")
post1 = Post.create(title: "Hello World", user_id: user1.id)

puts "Created records:"
puts "  Users: #{User.all.map(&:name).join(', ')}"
puts "  Posts: #{Post.all.map(&:title).join(', ')}"
puts "  Find user: #{User.find(user1.id)&.name}"
puts

# ============================================================
# Part 5: Service Objects
# ============================================================
puts "Part 5: Service Objects"
puts "-" * 70

class CreateUserService < Service
  def initialize(params)
    @params = params
  end

  def call
    validate!
    user = User.create(@params)
    notify_admin(user)
    { success: true, user: user }
  rescue ValidationError => e
    { success: false, error: e.message }
  end

  private

  def validate!
    raise ValidationError, "Name required" unless @params[:name]
    raise ValidationError, "Email required" unless @params[:email]
  end

  def notify_admin(user)
    puts "  [Service] Notifying admin about new user: #{user.name}"
  end
end

result = CreateUserService.call(name: "Charlie", email: "charlie@example.com")
puts "  Service result: #{result[:success] ? 'Success' : result[:error]}"
puts

# ============================================================
# Part 6: Application with Plugins
# ============================================================
puts "Part 6: Application with Plugins"
puts "-" * 70

app = Application.new

# Add logging middleware
app.use(LoggingPlugin.middleware)

# Define routes
app.get("/") { |req, res| res.html("<h1>Welcome!</h1>") }
app.get("/api/status") { |req, res| res.json({ status: "ok" }) }

# Simulate request
request = Request.new(method: :GET, path: "/api/status")
response = app.call(request)

puts "  Final response: #{response.body}"
puts

puts "=" * 70
puts "Mini Framework Lab complete!"
puts "=" * 70
