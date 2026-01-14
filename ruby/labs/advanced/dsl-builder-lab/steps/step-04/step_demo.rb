#!/usr/bin/env ruby
# Step 4: Basic Route Mapping

class Router
  def self.draw(&block)
    @routes = []
    mapper = RouteMapper.new(@routes)
    mapper.instance_eval(&block)
    @routes
  end

  def self.routes
    @routes || []
  end
end

class RouteMapper
  def initialize(routes)
    @routes = routes
  end

  def get(path, options = {})
    add_route(:GET, path, options[:to])
  end

  def post(path, options = {})
    add_route(:POST, path, options[:to])
  end

  def put(path, options = {})
    add_route(:PUT, path, options[:to])
  end

  def delete(path, options = {})
    add_route(:DELETE, path, options[:to])
  end

  private

  def add_route(method, path, controller_action)
    @routes << {
      method: method,
      path: path,
      controller: controller_action&.split('#')&.first,
      action: controller_action&.split('#')&.last
    }
  end
end

# Test it
puts "=" * 60
puts "Step 4: Basic Route Mapping"
puts "=" * 60
puts

Router.draw do
  get "/users", to: "users#index"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"
  put "/users/:id", to: "users#update"
  delete "/users/:id", to: "users#destroy"
end

puts "Registered routes:"
puts "-" * 60
printf "%-8s %-20s -> %s\n", "METHOD", "PATH", "CONTROLLER#ACTION"
puts "-" * 60

Router.routes.each do |r|
  printf "%-8s %-20s -> %s#%s\n", r[:method], r[:path], r[:controller], r[:action]
end

puts
puts "✓ Step 4 complete!"
