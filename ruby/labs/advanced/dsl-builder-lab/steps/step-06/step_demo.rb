#!/usr/bin/env ruby
# Step 6: Namespace Support

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
    @namespace_stack = []
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

  def root(options = {})
    get "/", to: options[:to]
  end

  # NEW: Namespace support
  def namespace(path, &block)
    @namespace_stack.push(path.to_s)
    instance_eval(&block)
    @namespace_stack.pop
  end

  private

  def add_route(method, path, controller_action)
    # Build full path with namespace prefixes
    full_path = @namespace_stack.empty? ? path : "/#{@namespace_stack.join('/')}#{path}"
    
    @routes << {
      method: method,
      path: full_path,
      controller: controller_action&.split('#')&.first,
      action: controller_action&.split('#')&.last
    }
  end
end

# Test it
puts "=" * 60
puts "Step 6: Namespace Support"
puts "=" * 60
puts

Router.draw do
  root to: "home#index"
  resource :users

  namespace :api do
    namespace :v1 do
      resource :users
      get "/status", to: "status#show"
    end
    
    namespace :v2 do
      resource :users
    end
  end

  namespace :admin do
    get "/dashboard", to: "dashboard#index"
    resource :settings
  end
end

puts "Routes with namespaces:"
puts "-" * 70
printf "%-8s %-35s -> %s\n", "METHOD", "PATH", "CONTROLLER#ACTION"
puts "-" * 70

Router.routes.each do |r|
  printf "%-8s %-35s -> %s#%s\n", r[:method], r[:path], r[:controller], r[:action]
end

puts
puts "Total routes: #{Router.routes.size}"
puts
puts "✓ Step 6 complete!"
