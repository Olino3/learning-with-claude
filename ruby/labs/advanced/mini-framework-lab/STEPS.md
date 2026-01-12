# Progressive Learning Guide: Mini Framework

Build a minimal web framework to understand design patterns.

## 🎯 Overview

Build a mini framework with:
1. **Routing System** - URL routing and request handling
2. **MVC Pattern** - Model-View-Controller architecture
3. **Service Layer** - Business logic separation
4. **Plugin System** - Extensibility with plugins

---

## Part 1: Routing System

### Step 1: Basic Router with Pattern Matching

**Goal**: Create a router that matches URLs to handlers.

```ruby
# lib/router.rb
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

  def compile_pattern(pattern)
    # Convert "/users/:id" to regex /^\/users\/([^\/]+)$/
    regex_pattern = pattern.gsub(/:\w+/, '([^/]+)')
    Regexp.new("^#{regex_pattern}$")
  end

  def extract_param_names(pattern)
    pattern.scan(/:(\w+)/).flatten
  end
end
```

**Test it**:
```ruby
router = Router.new
router.get("/users/:id", ->(params) { "User #{params['id']}" })

result = router.match(:GET, "/users/123")
puts result[:handler].call(result[:params])  # => "User 123"
```

---

### Step 2: Add Request and Response Objects

**Goal**: Wrap HTTP request/response data.

```ruby
# lib/request.rb
class Request
  attr_reader :method, :path, :params, :headers

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

# lib/response.rb
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
```

---

### Step 3: Create Application Class

**Goal**: Tie routing and request handling together.

```ruby
# lib/application.rb
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

  def call(request)
    response = Response.new

    # Apply middleware
    @middleware.each { |m| m.call(request, response) }

    # Find and execute route
    route = @router.match(request.method, request.path)

    if route
      request.params.merge!(route[:params])
      result = route[:handler].call(request, response)
      response.body = result if result.is_a?(String)
    else
      response.status = 404
      response.body = "Not Found"
    end

    response
  end

  def use(middleware)
    @middleware << middleware
  end
end
```

**Test it**:
```ruby
app = Application.new

app.get("/") do |req, res|
  res.html("<h1>Welcome!</h1>")
end

app.get("/users/:id") do |req, res|
  res.html("<h1>User #{req.params['id']}</h1>")
end

request = Request.new(method: :GET, path: "/users/42")
response = app.call(request)
puts response.to_s
```

---

## Part 2: MVC Pattern

### Step 4: Create Base Controller

**Goal**: Implement controller pattern with actions.

```ruby
# lib/controller.rb
class Controller
  attr_reader :request, :response

  def initialize(request, response)
    @request = request
    @response = response
  end

  def render(view_name, locals = {})
    view = View.new(view_name, locals)
    @response.html(view.render)
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

  def self.action(action_name)
    ->(request, response) do
      controller = new(request, response)
      controller.send(action_name)
      response
    end
  end
end
```

---

### Step 5: Add Simple Template System

**Goal**: Render views with data.

```ruby
# lib/view.rb
class View
  def initialize(template_name, locals = {})
    @template_name = template_name
    @locals = locals
  end

  def render
    template = load_template
    evaluate_template(template)
  end

  private

  def load_template
    path = "views/#{@template_name}.html.erb"
    File.read(path)
  end

  def evaluate_template(template)
    # Simple variable substitution
    result = template.dup

    @locals.each do |key, value|
      result.gsub!(/\{\{\s*#{key}\s*\}\}/, value.to_s)
    end

    result
  end
end

# Alternative: Use ERB
require 'erb'

class ERBView
  def initialize(template_name, locals = {})
    @template_name = template_name
    @locals = locals
  end

  def render
    template = load_template
    ERB.new(template).result(binding)
  end

  private

  def load_template
    path = "views/#{@template_name}.html.erb"
    File.read(path)
  end

  def method_missing(method_name, *args)
    @locals[method_name] || super
  end

  def respond_to_missing?(method_name, include_private = false)
    @locals.key?(method_name) || super
  end
end
```

---

### Step 6: Implement Models with ActiveRecord Pattern

**Goal**: Create simple model layer.

```ruby
# lib/model.rb
class Model
  def self.inherited(subclass)
    subclass.instance_variable_set(:@records, [])
  end

  def self.all
    @records ||= []
  end

  def self.find(id)
    all.find { |record| record.id == id }
  end

  def self.where(conditions)
    all.select do |record|
      conditions.all? { |attr, value| record.send(attr) == value }
    end
  end

  def self.create(attributes)
    instance = new(attributes)
    instance.save
    instance
  end

  attr_reader :id

  def initialize(attributes = {})
    @id = generate_id
    @attributes = attributes
    create_accessors
  end

  def save
    self.class.all << self unless self.class.all.include?(self)
    self
  end

  def update(attributes)
    @attributes.merge!(attributes)
    create_accessors
    self
  end

  def destroy
    self.class.all.delete(self)
  end

  private

  def generate_id
    "#{self.class.name.downcase}_#{Time.now.to_i}_#{rand(1000)}"
  end

  def create_accessors
    @attributes.each do |key, value|
      define_singleton_method(key) { @attributes[key] }
      define_singleton_method("#{key}=") { |val| @attributes[key] = val }
    end
  end
end
```

**Test it**:
```ruby
class User < Model; end

user = User.create(name: "Alice", email: "alice@example.com")
puts user.name  # => "Alice"

all_users = User.all
```

---

## Part 3: Service Layer and Patterns

### Step 7: Implement Service Objects

**Goal**: Extract business logic into service classes.

```ruby
# lib/service.rb
class Service
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs).call(&block)
  end

  def initialize(*args, **kwargs)
    # Override in subclasses
  end

  def call
    raise NotImplementedError, "Subclasses must implement #call"
  end
end

# Example: User Registration Service
class UserRegistrationService < Service
  def initialize(params)
    @params = params
  end

  def call
    validate_params
    create_user
    send_welcome_email
    { success: true, user: @user }
  rescue ValidationError => e
    { success: false, error: e.message }
  end

  private

  def validate_params
    raise ValidationError, "Email is required" unless @params[:email]
    raise ValidationError, "Name is required" unless @params[:name]
  end

  def create_user
    @user = User.create(@params)
  end

  def send_welcome_email
    # Email sending logic
    puts "Sending welcome email to #{@user.email}"
  end
end
```

---

### Step 8: Add Design Patterns

**Goal**: Implement common patterns.

```ruby
# Singleton Pattern
class Configuration
  include Singleton

  attr_accessor :database_url, :api_key

  def initialize
    @database_url = "localhost"
    @api_key = "default_key"
  end
end

# Factory Pattern
class ControllerFactory
  def self.create(controller_name, request, response)
    controller_class = Object.const_get("#{controller_name.capitalize}Controller")
    controller_class.new(request, response)
  end
end

# Decorator Pattern
class CachedModel
  def initialize(model)
    @model = model
    @cache = {}
  end

  def find(id)
    @cache[id] ||= @model.find(id)
  end

  def all
    @cache[:all] ||= @model.all
  end

  def invalidate_cache
    @cache.clear
  end

  def method_missing(method_name, *args, &block)
    @model.send(method_name, *args, &block)
  end
end
```

---

### Step 9: Create Plugin System

**Goal**: Allow framework extensibility.

```ruby
# lib/plugin.rb
class Plugin
  def self.install(app)
    raise NotImplementedError
  end
end

# Example: Logging Plugin
class LoggingPlugin < Plugin
  def self.install(app)
    app.use(Logger.new)
  end

  class Logger
    def call(request, response)
      start_time = Time.now
      puts "[#{Time.now}] #{request.method} #{request.path}"

      yield if block_given?

      duration = Time.now - start_time
      puts "  Completed in #{(duration * 1000).round(2)}ms"
    end
  end
end

# Example: Authentication Plugin
class AuthenticationPlugin < Plugin
  def self.install(app, secret_key:)
    app.use(Auth.new(secret_key))
  end

  class Auth
    def initialize(secret_key)
      @secret_key = secret_key
    end

    def call(request, response)
      unless request.headers['Authorization']
        response.status = 401
        response.body = "Unauthorized"
        return response
      end

      yield if block_given?
    end
  end
end
```

---

## 🎯 Final Challenge

Build a complete mini application:
1. User management (CRUD)
2. Authentication
3. Logging
4. At least 3 controllers
5. Service objects for business logic

Run: `ruby framework_demo.rb`

---

## ✅ Completion Checklist

- [ ] Router with pattern matching
- [ ] Request/Response objects
- [ ] Application class
- [ ] Base controller
- [ ] View rendering
- [ ] Model layer
- [ ] Service objects
- [ ] Design patterns (Singleton, Factory, Decorator)
- [ ] Plugin system

---

**Congratulations!** You've mastered advanced Ruby patterns and built a mini framework!
