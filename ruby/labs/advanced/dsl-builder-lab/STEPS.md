# Progressive Learning Guide: DSL Builder Lab

Build three powerful Domain Specific Languages step by step.

## 🎯 Overview

This lab is divided into 3 main DSLs, each with progressive steps:
1. **Configuration DSL** - Rails-style configuration
2. **Route Mapper DSL** - Rails routing system
3. **Query Builder DSL** - ActiveRecord-style queries

Complete each DSL before moving to the next.

---

## Part 1: Configuration DSL

### Step 1: Basic Configuration with instance_eval

**Goal**: Create a simple configuration DSL that can set key-value pairs.

```ruby
# lib/config_dsl.rb
class AppConfig
  def self.configure(&block)
    @config = new
    @config.instance_eval(&block)
    @config
  end

  def self.config
    @config
  end

  def method_missing(method_name, *args)
    if args.empty?
      # Getter
      instance_variable_get("@#{method_name}")
    else
      # Setter
      instance_variable_set("@#{method_name}", args.first)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end
```

**Test it**:
```ruby
AppConfig.configure do
  app_name "My App"
  version "1.0.0"
end

puts AppConfig.config.app_name  # => "My App"
```

---

### Step 2: Add Nested Configuration

**Goal**: Support nested configuration blocks.

```ruby
class AppConfig
  # ... previous code ...

  def method_missing(method_name, *args, &block)
    if block_given?
      # Nested configuration
      nested = NestedConfig.new
      nested.instance_eval(&block)
      instance_variable_set("@#{method_name}", nested)
    elsif args.empty?
      instance_variable_get("@#{method_name}")
    else
      instance_variable_set("@#{method_name}", args.first)
    end
  end

  class NestedConfig
    def method_missing(method_name, *args)
      if args.empty?
        instance_variable_get("@#{method_name}")
      else
        instance_variable_set("@#{method_name}", args.first)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end
  end
end
```

**Test it**:
```ruby
AppConfig.configure do
  app_name "My App"

  database do
    host "localhost"
    port 5432
  end
end

puts AppConfig.config.database.host  # => "localhost"
```

---

### Step 3: Add Validation and Type Checking

**Goal**: Validate configuration values.

```ruby
class AppConfig
  # ... previous code ...

  def validate!
    raise ConfigError, "app_name is required" unless @app_name
    raise ConfigError, "version is required" unless @version

    if @database
      raise ConfigError, "database.host is required" unless @database.host
      raise ConfigError, "database.port must be a number" unless @database.port.is_a?(Integer)
    end
  end

  def to_h
    hash = {}
    instance_variables.each do |var|
      key = var.to_s.delete('@').to_sym
      value = instance_variable_get(var)
      hash[key] = value.respond_to?(:to_h) ? value.to_h : value
    end
    hash
  end
end

class ConfigError < StandardError; end
```

---

## Part 2: Route Mapper DSL

### Step 4: Basic Route Mapping

**Goal**: Create a DSL for defining HTTP routes.

```ruby
# lib/route_mapper.rb
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
```

**Test it**:
```ruby
Router.draw do
  get "/users", to: "users#index"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"
end

Router.routes.each { |r| puts "#{r[:method]} #{r[:path]} -> #{r[:controller]}##{r[:action]}" }
```

---

### Step 5: Add RESTful Resource Routing

**Goal**: Generate standard CRUD routes with `resource`.

```ruby
class RouteMapper
  # ... previous code ...

  def resource(name)
    get "/#{name}", to: "#{name}#index"
    get "/#{name}/new", to: "#{name}#new"
    post "/#{name}", to: "#{name}#create"
    get "/#{name}/:id", to: "#{name}#show"
    get "/#{name}/:id/edit", to: "#{name}#edit"
    put "/#{name}/:id", to: "#{name}#update"
    delete "/#{name}/:id", to: "#{name}#destroy"
  end

  def root(options = {})
    get "/", to: options[:to]
  end
end
```

**Test it**:
```ruby
Router.draw do
  root to: "home#index"
  resource :users
  resource :posts
end
```

---

### Step 6: Add Namespace Support

**Goal**: Group routes under a namespace.

```ruby
class RouteMapper
  # ... previous code ...

  def namespace(path, &block)
    @namespace_stack ||= []
    @namespace_stack.push(path)

    instance_eval(&block)

    @namespace_stack.pop
  end

  private

  def add_route(method, path, controller_action)
    full_path = @namespace_stack ? File.join(@namespace_stack + [path]) : path

    @routes << {
      method: method,
      path: full_path,
      controller: controller_action&.split('#')&.first,
      action: controller_action&.split('#')&.last
    }
  end
end
```

**Test it**:
```ruby
Router.draw do
  namespace "/api" do
    namespace "/v1" do
      resource :users
      get "/status", to: "status#show"
    end
  end
end
```

---

## Part 3: Query Builder DSL

### Step 7: Basic Query Builder with Method Chaining

**Goal**: Create a chainable query interface.

```ruby
# lib/query_builder.rb
class QueryBuilder
  def initialize(table_name)
    @table = table_name
    @conditions = []
    @order_clause = nil
    @limit_value = nil
  end

  def where(conditions)
    if conditions.is_a?(Hash)
      conditions.each do |column, value|
        @conditions << "#{column} = '#{value}'"
      end
    elsif conditions.is_a?(String)
      @conditions << conditions
    end
    self
  end

  def order(column, direction = :asc)
    @order_clause = "#{column} #{direction.to_s.upcase}"
    self
  end

  def limit(count)
    @limit_value = count
    self
  end

  def to_sql
    sql = "SELECT * FROM #{@table}"

    unless @conditions.empty?
      sql += " WHERE #{@conditions.join(' AND ')}"
    end

    sql += " ORDER BY #{@order_clause}" if @order_clause
    sql += " LIMIT #{@limit_value}" if @limit_value

    sql
  end
end
```

**Test it**:
```ruby
query = QueryBuilder.new(:users)
                    .where(active: true)
                    .where("age > 18")
                    .order(:created_at, :desc)
                    .limit(10)

puts query.to_sql
# => SELECT * FROM users WHERE active = 'true' AND age > 18 ORDER BY created_at DESC LIMIT 10
```

---

### Step 8: Add Block-Based Conditions

**Goal**: Support block syntax for complex conditions.

```ruby
class QueryBuilder
  # ... previous code ...

  def where(conditions = nil, &block)
    if block_given?
      condition_builder = ConditionBuilder.new
      condition_builder.instance_eval(&block)
      @conditions << condition_builder.to_sql
    elsif conditions.is_a?(Hash)
      conditions.each do |column, value|
        @conditions << "#{column} = '#{value}'"
      end
    elsif conditions.is_a?(String)
      @conditions << conditions
    end
    self
  end
end

class ConditionBuilder
  def initialize
    @parts = []
  end

  def method_missing(method_name, *args)
    ColumnProxy.new(method_name.to_s)
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end

  def to_sql
    @parts.join(' AND ')
  end
end

class ColumnProxy
  attr_reader :column

  def initialize(column)
    @column = column
  end

  def >(value)
    "#{@column} > #{value}"
  end

  def <(value)
    "#{@column} < #{value}"
  end

  def ==(value)
    "#{@column} = '#{value}'"
  end

  def >=(value)
    "#{@column} >= #{value}"
  end

  def <=(value)
    "#{@column} <= #{value}"
  end
end
```

**Test it**:
```ruby
query = QueryBuilder.new(:users).where { age > 18 }
puts query.to_sql
```

---

### Step 9: Add Join Support

**Goal**: Support JOIN operations.

```ruby
class QueryBuilder
  def initialize(table_name)
    @table = table_name
    @conditions = []
    @joins = []
    @order_clause = nil
    @limit_value = nil
  end

  def join(table, on:)
    @joins << "INNER JOIN #{table} ON #{on}"
    self
  end

  def left_join(table, on:)
    @joins << "LEFT JOIN #{table} ON #{on}"
    self
  end

  def to_sql
    sql = "SELECT * FROM #{@table}"

    sql += " #{@joins.join(' ')}" unless @joins.empty?

    unless @conditions.empty?
      sql += " WHERE #{@conditions.join(' AND ')}"
    end

    sql += " ORDER BY #{@order_clause}" if @order_clause
    sql += " LIMIT #{@limit_value}" if @limit_value

    sql
  end
end
```

**Test it**:
```ruby
query = QueryBuilder.new(:users)
                    .join(:posts, on: "users.id = posts.user_id")
                    .where(active: true)
                    .limit(5)

puts query.to_sql
```

---

## 🎯 Final Challenge

1. Combine all three DSLs in `dsl_demo.rb`
2. Create a complete configuration
3. Define a full routing table
4. Build complex queries with joins

Run: `ruby dsl_demo.rb`

---

## ✅ Completion Checklist

- [ ] Configuration DSL with nested blocks
- [ ] Configuration validation
- [ ] Basic route mapping (GET, POST, etc.)
- [ ] RESTful resource routing
- [ ] Namespace support
- [ ] Query builder with method chaining
- [ ] Block-based query conditions
- [ ] JOIN support

---

**Excellent work!** You've mastered advanced metaprogramming! Next → [Concurrent Processor Lab](../concurrent-processor-lab/README.md)
