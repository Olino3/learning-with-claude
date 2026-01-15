#!/usr/bin/env ruby
# Step 4: Base Controller

require 'json'

puts "=" * 60
puts "Step 4: Base Controller"
puts "=" * 60
puts

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

  def redirect(location)
    @status = 302
    @headers['Location'] = location
    self
  end
end

# Base Controller
class Controller
  attr_reader :request, :response

  def initialize(request, response)
    @request = request
    @response = response
  end

  def render(view_name, locals = {})
    @response.html("Rendered: #{view_name} with #{locals}")
  end

  def redirect_to(path)
    @response.redirect(path)
  end

  def json(data)
    @response.json(data)
  end

  def params
    @request.params
  end

  # Class method to create action handler
  def self.action(action_name)
    ->(request, response) do
      controller = new(request, response)
      controller.send(action_name)
      response
    end
  end
end

# Example controller
class UsersController < Controller
  def index
    users = [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" },
      { id: 3, name: "Charlie" }
    ]
    json(users)
  end

  def show
    user_id = params["id"]
    json({ id: user_id, name: "User #{user_id}" })
  end

  def create
    json({ created: true, name: params["name"] })
  end
end

class PostsController < Controller
  def index
    json([{ id: 1, title: "Hello World" }])
  end
end

# Test controllers
puts "Testing UsersController:"
puts "-" * 60

# Index action
request = Request.new(method: :GET, path: "/users")
response = Response.new
controller = UsersController.new(request, response)
controller.index
puts "  GET /users"
puts "  Response: #{response.body}"
puts

# Show action
request = Request.new(method: :GET, path: "/users/42", params: { "id" => "42" })
response = Response.new
controller = UsersController.new(request, response)
controller.show
puts "  GET /users/42"
puts "  Response: #{response.body}"
puts

# Create action
request = Request.new(method: :POST, path: "/users", params: { "name" => "Dave" })
response = Response.new
controller = UsersController.new(request, response)
controller.create
puts "  POST /users"
puts "  Response: #{response.body}"
puts

# Using Controller.action helper
puts "Using Controller.action helper:"
handler = UsersController.action(:index)
request = Request.new(method: :GET, path: "/users")
response = Response.new
handler.call(request, response)
puts "  Handler response: #{response.body}"
puts

puts "✓ Step 4 complete!"
