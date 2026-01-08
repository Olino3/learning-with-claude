#!/usr/bin/env ruby
# Advanced Metaprogramming & DSL Practice

puts "=" * 70
puts "ADVANCED METAPROGRAMMING & DSL PRACTICE"
puts "=" * 70
puts

# Example 1: instance_eval - Accessing Private Context
puts "1. instance_eval - Accessing Private Context"
puts "-" * 70

class SecretVault
  def initialize(secret)
    @secret = secret
  end
  
  private
  
  def reveal_secret
    "The secret is: #{@secret}"
  end
end

vault = SecretVault.new("Ruby is awesome!")

# Access private data and methods
vault.instance_eval do
  puts "Private instance variable: #{@secret}"
  puts "Private method: #{reveal_secret}"
end

puts

# Example 2: class_eval - Dynamic Class Modification
puts "2. class_eval - Dynamic Class Modification"
puts "-" * 70

class DynamicClass
  # Empty class initially
end

# Add methods dynamically
DynamicClass.class_eval do
  attr_accessor :name, :value
  
  def display
    "Name: #{name}, Value: #{value}"
  end
  
  def self.description
    "Dynamically enhanced class"
  end
end

obj = DynamicClass.new
obj.name = "Test"
obj.value = 42
puts obj.display
puts DynamicClass.description

puts

# Example 3: Binding - Capturing Execution Context
puts "3. Binding - Capturing Execution Context"
puts "-" * 70

def create_context
  local_var = "I'm local!"
  @instance_var = "I'm an instance variable"
  
  binding
end

ctx = create_context

puts "Accessing local variable: #{ctx.eval('local_var')}"
puts "Accessing instance variable: #{ctx.eval('@instance_var')}"
puts "Local variables in binding: #{ctx.local_variables}"

# Modify through binding
ctx.eval('local_var = "Modified!"')
puts "Modified local variable: #{ctx.eval('local_var')}"

puts

# Example 4: Refinements - Scoped Monkey Patching
puts "4. Refinements - Scoped Monkey Patching"
puts "-" * 70

module StringRefinements
  refine String do
    def shout
      upcase + "!!!"
    end
    
    def whisper
      downcase + "..."
    end
  end
end

module IntegerRefinements
  refine Integer do
    def factorial
      return 1 if self <= 1
      self * (self - 1).factorial
    end
  end
end

class RefinedCalculator
  using StringRefinements
  using IntegerRefinements
  
  def self.demo
    puts "hello".shout
    puts "WORLD".whisper
    puts "5 factorial: #{5.factorial}"
  end
end

RefinedCalculator.demo

# Outside the class, refinements don't apply
puts "Without refinements, these would cause NoMethodError"

puts

# Example 5: Building a Configuration DSL
puts "5. Building a Configuration DSL"
puts "-" * 70

class AppConfig
  @settings = {}
  
  def self.configure(&block)
    instance_eval(&block)
  end
  
  def self.set(key, value)
    @settings[key] = value
  end
  
  def self.get(key)
    @settings[key]
  end
  
  def self.method_missing(name, *args)
    if args.empty?
      get(name)
    else
      set(name, args.first)
    end
  end
end

AppConfig.configure do
  app_name "My Awesome App"
  version "1.0.0"
  debug true
  api_url "https://api.example.com"
  timeout 30
end

puts "App Name: #{AppConfig.app_name}"
puts "Version: #{AppConfig.version}"
puts "Debug: #{AppConfig.debug}"
puts "API URL: #{AppConfig.api_url}"
puts "Timeout: #{AppConfig.timeout}"

puts

# Example 6: HTML Builder DSL
puts "6. HTML Builder DSL"
puts "-" * 70

class HTMLBuilder
  def initialize
    @html = []
    @indent = 0
  end
  
  def tag(name, attributes = {}, &block)
    attrs = attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    opening = "<#{name}#{attrs.empty? ? '' : ' ' + attrs}>"
    
    if block
      @html << "  " * @indent + opening
      @indent += 1
      instance_eval(&block)
      @indent -= 1
      @html << "  " * @indent + "</#{name}>"
    else
      @html << "  " * @indent + opening + "</#{name}>"
    end
  end
  
  def text(content)
    @html << "  " * @indent + content
  end
  
  def method_missing(name, *args, &block)
    if block || args.empty? || args.first.is_a?(Hash)
      tag(name, args.first || {}, &block)
    else
      tag(name) { text(args.first) }
    end
  end
  
  def to_s
    @html.join("\n")
  end
  
  def self.build(&block)
    builder = new
    builder.instance_eval(&block)
    builder.to_s
  end
end

html = HTMLBuilder.build do
  html do
    head do
      title "DSL Demo"
    end
    body do
      h1 "Welcome to DSL Building"
      div class: "content" do
        p "This HTML was generated using a Ruby DSL!"
        ul do
          li "Clean syntax"
          li "Powerful metaprogramming"
          li "Ruby elegance"
        end
      end
    end
  end
end

puts html

puts

# Example 7: Query Builder DSL
puts "7. Query Builder DSL"
puts "-" * 70

class QueryBuilder
  def initialize(table)
    @table = table
    @conditions = []
    @order = nil
    @limit_value = nil
  end
  
  def where(condition)
    @conditions << condition
    self  # Return self for chaining
  end
  
  def order(column)
    @order = column
    self
  end
  
  def limit(n)
    @limit_value = n
    self
  end
  
  def to_sql
    sql = "SELECT * FROM #{@table}"
    
    unless @conditions.empty?
      where_clauses = @conditions.map do |cond|
        if cond.is_a?(Hash)
          cond.map { |k, v| "#{k} = '#{v}'" }.join(" AND ")
        else
          cond
        end
      end
      sql += " WHERE #{where_clauses.join(" AND ")}"
    end
    
    sql += " ORDER BY #{@order}" if @order
    sql += " LIMIT #{@limit_value}" if @limit_value
    
    sql
  end
  
  def self.from(table, &block)
    builder = new(table)
    builder.instance_eval(&block) if block
    builder
  end
end

query = QueryBuilder.from(:users) do
  where(status: 'active')
  where("age > 18")
  order('created_at DESC')
  limit(10)
end

puts query.to_sql

puts

# Example 8: Validation DSL
puts "8. Validation DSL"
puts "-" * 70

class Validator
  def initialize
    @rules = {}
  end
  
  def validates(field, **options)
    @rules[field] = options
  end
  
  def check(object)
    errors = []
    
    @rules.each do |field, options|
      value = object.send(field) rescue nil
      
      if options[:presence] && (value.nil? || value.to_s.empty?)
        errors << "#{field} is required"
      end
      
      if options[:min_length] && value && value.to_s.length < options[:min_length]
        errors << "#{field} must be at least #{options[:min_length]} characters"
      end
      
      if options[:format] && value && !value.to_s.match?(options[:format])
        errors << "#{field} has invalid format"
      end
      
      if options[:custom] && value
        result = options[:custom].call(value)
        errors << "#{field}: #{result}" unless result == true
      end
    end
    
    errors
  end
  
  def self.define(&block)
    validator = new
    validator.instance_eval(&block)
    validator
  end
end

# Define validation rules using DSL
user_validator = Validator.define do
  validates :email, 
    presence: true,
    format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :password,
    presence: true,
    min_length: 8
  
  validates :age,
    custom: ->(val) { val >= 18 ? true : "must be 18 or older" }
end

# Test with sample data
User = Struct.new(:email, :password, :age)

puts "Testing valid user:"
valid_user = User.new("alice@example.com", "secret123", 25)
errors = user_validator.check(valid_user)
puts errors.empty? ? "✓ Valid!" : errors.join("\n")

puts "\nTesting invalid user:"
invalid_user = User.new("invalid-email", "short", 16)
errors = user_validator.check(invalid_user)
puts errors.empty? ? "✓ Valid!" : errors.join("\n")

puts

# Example 9: Route Mapper DSL (Rails-style)
puts "9. Route Mapper DSL (Rails-style)"
puts "-" * 70

class Router
  def initialize
    @routes = []
    @prefix = ""
  end
  
  [:get, :post, :put, :delete, :patch].each do |method|
    define_method(method) do |path, to: nil|
      @routes << {
        method: method.to_s.upcase,
        path: @prefix + path,
        controller: to
      }
    end
  end
  
  def namespace(path, &block)
    old_prefix = @prefix
    @prefix = @prefix + path
    instance_eval(&block)
    @prefix = old_prefix
  end
  
  def resource(name)
    get "/#{name}", to: "#{name}#index"
    get "/#{name}/:id", to: "#{name}#show"
    post "/#{name}", to: "#{name}#create"
    put "/#{name}/:id", to: "#{name}#update"
    delete "/#{name}/:id", to: "#{name}#destroy"
  end
  
  def routes
    @routes
  end
  
  def self.draw(&block)
    router = new
    router.instance_eval(&block)
    router.routes
  end
end

routes = Router.draw do
  get "/", to: "home#index"
  
  namespace "/api/v1" do
    resource :users
    resource :posts
    get "/status", to: "status#show"
  end
  
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end

puts "Defined Routes:"
routes.each do |route|
  puts "#{route[:method].ljust(7)} #{route[:path].ljust(30)} => #{route[:controller]}"
end

puts
puts "=" * 70
puts "Practice complete! You've mastered advanced metaprogramming and DSLs!"
puts "=" * 70
