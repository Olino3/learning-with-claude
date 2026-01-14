#!/usr/bin/env ruby
# Step 5: RESTful Resource Routing

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

  # NEW: RESTful resource routing
  def resource(name)
    controller = name.to_s
    get "/#{name}", to: "#{controller}#index"
    get "/#{name}/new", to: "#{controller}#new"
    post "/#{name}", to: "#{controller}#create"
    get "/#{name}/:id", to: "#{controller}#show"
    get "/#{name}/:id/edit", to: "#{controller}#edit"
    put "/#{name}/:id", to: "#{controller}#update"
    delete "/#{name}/:id", to: "#{controller}#destroy"
  end

  # NEW: Root route
  def root(options = {})
    get "/", to: options[:to]
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
puts "Step 5: RESTful Resource Routing"
puts "=" * 60
puts

Router.draw do
  root to: "home#index"
  resource :users
  resource :posts
end

puts "Generated routes:"
puts "-" * 60
printf "%-8s %-25s -> %s\n", "METHOD", "PATH", "CONTROLLER#ACTION"
puts "-" * 60

Router.routes.each do |r|
  printf "%-8s %-25s -> %s#%s\n", r[:method], r[:path], r[:controller], r[:action]
end

puts
puts "Total routes: #{Router.routes.size}"
puts
puts "✓ Step 5 complete!"
