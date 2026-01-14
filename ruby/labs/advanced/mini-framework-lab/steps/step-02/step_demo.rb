#!/usr/bin/env ruby
# Step 2: Request and Response Objects

require 'json'

puts "=" * 60
puts "Step 2: Request and Response Objects"
puts "=" * 60
puts

class Request
  attr_reader :method, :path, :headers
  attr_accessor :params

  def initialize(method:, path:, params: {}, headers: {})
    @method = method
    @path = path
    @params = params
    @headers = headers
  end

  def get?
    @method == :GET
  end

  def post?
    @method == :POST
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
    @headers['Content-Type'] = 'text/html'
    @body = content
    self
  end

  def redirect(location)
    @status = 302
    @headers['Location'] = location
    self
  end

  def to_s
    "HTTP/1.1 #{@status}\n#{headers_string}\n\n#{@body}"
  end

  private

  def headers_string
    @headers.map { |k, v| "#{k}: #{v}" }.join("\n")
  end
end

# Test Request
puts "Request object:"
request = Request.new(
  method: :GET,
  path: "/users/42",
  params: { format: "json" },
  headers: { "Accept" => "application/json" }
)
puts "  Method: #{request.method}"
puts "  Path: #{request.path}"
puts "  Params: #{request.params}"
puts "  Is GET? #{request.get?}"
puts

# Test Response - HTML
puts "Response (HTML):"
response = Response.new
response.html("<h1>Hello World</h1>")
puts "  Status: #{response.status}"
puts "  Content-Type: #{response.headers['Content-Type']}"
puts "  Body: #{response.body}"
puts

# Test Response - JSON
puts "Response (JSON):"
response = Response.new
response.json({ id: 42, name: "Alice", active: true })
puts "  Status: #{response.status}"
puts "  Content-Type: #{response.headers['Content-Type']}"
puts "  Body: #{response.body}"
puts

# Test Response - Redirect
puts "Response (Redirect):"
response = Response.new
response.redirect("/login")
puts "  Status: #{response.status}"
puts "  Location: #{response.headers['Location']}"
puts

puts "✓ Step 2 complete!"
