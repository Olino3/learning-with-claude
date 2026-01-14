#!/usr/bin/env ruby
# Step 1: Basic Router with Pattern Matching

puts "=" * 60
puts "Step 1: Basic Router with Pattern Matching"
puts "=" * 60
puts

class Router
  def initialize
    @routes = []
  end

  def get(pattern, handler)
    add_route(:GET, pattern, handler)
  end

  def post(pattern, handler)
    add_route(:POST, pattern, handler)
  end

  def add_route(method, pattern, handler)
    @routes << {
      method: method,
      pattern: compile_pattern(pattern),
      handler: handler,
      param_names: extract_param_names(pattern)
    }
  end

  def match(method, path)
    @routes.each do |route|
      next unless route[:method] == method

      if match_data = route[:pattern].match(path)
        params = {}
        route[:param_names].each_with_index do |name, i|
          params[name] = match_data[i + 1]
        end

        return { handler: route[:handler], params: params }
      end
    end

    nil
  end

  private

  # Convert "/users/:id" to regex /^\/users\/([^\/]+)$/
  def compile_pattern(pattern)
    regex_pattern = pattern.gsub(/:(\w+)/, '([^/]+)')
    Regexp.new("^#{regex_pattern}$")
  end

  def extract_param_names(pattern)
    pattern.scan(/:(\w+)/).flatten
  end
end

# Test it
router = Router.new

router.get("/", ->(params) { "Home page" })
router.get("/users", ->(params) { "User list" })
router.get("/users/:id", ->(params) { "User #{params['id']}" })
router.post("/users", ->(params) { "Create user" })
router.get("/posts/:post_id/comments/:id", ->(params) { 
  "Comment #{params['id']} on post #{params['post_id']}" 
})

puts "Testing routes:"
puts "-" * 60

[
  [:GET, "/"],
  [:GET, "/users"],
  [:GET, "/users/123"],
  [:GET, "/users/456"],
  [:POST, "/users"],
  [:GET, "/posts/10/comments/5"],
  [:GET, "/nonexistent"]
].each do |method, path|
  result = router.match(method, path)
  if result
    output = result[:handler].call(result[:params])
    puts "  #{method} #{path}"
    puts "    => #{output}"
    puts "    params: #{result[:params]}" unless result[:params].empty?
  else
    puts "  #{method} #{path}"
    puts "    => 404 Not Found"
  end
end

puts
puts "✓ Step 1 complete!"
