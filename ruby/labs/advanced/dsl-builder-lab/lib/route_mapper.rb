# Route Mapper DSL - Rails-style routing

class RouteMapper
  def initialize
    @routes = []
    @prefix = ""
  end
  
  # HTTP verb methods
  [:get, :post, :put, :patch, :delete].each do |verb|
    define_method(verb) do |path, to: nil, &block|
      add_route(verb, path, to, block)
    end
  end
  
  # Root route
  def root(to:)
    add_route(:get, "/", to, nil)
  end
  
  # RESTful resource
  def resource(name)
    singular = name.to_s
    get "/#{name}", to: "#{singular}#index"
    get "/#{name}/new", to: "#{singular}#new"
    post "/#{name}", to: "#{singular}#create"
    get "/#{name}/:id", to: "#{singular}#show"
    get "/#{name}/:id/edit", to: "#{singular}#edit"
    put "/#{name}/:id", to: "#{singular}#update"
    patch "/#{name}/:id", to: "#{singular}#update"
    delete "/#{name}/:id", to: "#{singular}#destroy"
  end
  
  # Nested namespace
  def namespace(path, &block)
    old_prefix = @prefix
    @prefix = @prefix + path
    instance_eval(&block)
    @prefix = old_prefix
  end
  
  # Route grouping
  def scope(path, &block)
    namespace(path, &block)
  end
  
  # Get all routes
  def routes
    @routes
  end
  
  # Print routes table
  def print_routes
    puts "\n" + "=" * 80
    puts "ROUTES"
    puts "=" * 80
    printf "%-8s %-30s => %-30s\n", "METHOD", "PATH", "CONTROLLER#ACTION"
    puts "-" * 80
    
    @routes.each do |route|
      printf "%-8s %-30s => %-30s\n",
             route[:method].to_s.upcase,
             route[:path],
             route[:controller] || route[:handler] ? "block" : "N/A"
    end
    puts "=" * 80
  end
  
  # Class method to draw routes
  def self.draw(&block)
    mapper = new
    mapper.instance_eval(&block)
    mapper
  end
  
  private
  
  def add_route(method, path, controller, handler)
    full_path = @prefix + path
    @routes << {
      method: method,
      path: full_path,
      controller: controller,
      handler: handler
    }
  end
end

# Advanced router with constraints and helpers
class AdvancedRouter < RouteMapper
  def initialize
    super
    @constraints = {}
    @helpers = {}
  end
  
  def constraints(hash)
    @current_constraints = hash
    yield if block_given?
    @current_constraints = nil
  end
  
  def match(path, to:, via: :get)
    Array(via).each do |verb|
      send(verb, path, to: to)
    end
  end
  
  private
  
  def add_route(method, path, controller, handler)
    route = super
    route[:constraints] = @current_constraints if @current_constraints
    route
  end
end
