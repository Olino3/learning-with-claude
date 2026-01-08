#!/usr/bin/env ruby
# DSL Builder Lab - Main Demo

require_relative 'lib/config_dsl'
require_relative 'lib/route_mapper'
require_relative 'lib/query_builder'

puts "=" * 80
puts "DSL BUILDER LAB - ADVANCED METAPROGRAMMING"
puts "=" * 80
puts

# Demo 1: Configuration DSL
puts "1. Configuration DSL"
puts "-" * 80

config = AppConfig.build do
  app_name "MyAwesomeApp"
  version "2.0.0"
  environment "production"
  
  database do
    host "localhost"
    port 5432
    name "myapp_production"
    username "dbuser"
  end
  
  cache do
    enabled true
    ttl 3600
    backend "redis"
  end
  
  logging do
    level "info"
    output "stdout"
  end
end

puts "App Configuration:"
puts "  Name: #{config[:app_name]}"
puts "  Version: #{config[:version]}"
puts "  Database: #{config[:database][:name]} at #{config[:database][:host]}:#{config[:database][:port]}"
puts "  Cache: #{config[:cache][:backend]} (TTL: #{config[:cache][:ttl]}s)"
puts "  Logging: #{config[:logging][:level]} to #{config[:logging][:output]}"

puts

# Demo 2: Route Mapper DSL
puts "2. Route Mapper DSL (Rails-style)"
puts "-" * 80

router = RouteMapper.draw do
  root to: "home#index"
  
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  post "/contact", to: "contact#create"
  
  resource :users
  resource :posts
  resource :comments
  
  namespace "/api/v1" do
    get "/status", to: "api/status#show"
    
    resource :articles
    resource :tags
    
    namespace "/admin" do
      resource :users
      get "/dashboard", to: "admin/dashboard#index"
    end
  end
  
  namespace "/blog" do
    get "/", to: "blog#index"
    get "/:slug", to: "blog#show"
  end
end

router.print_routes

puts

# Demo 3: Query Builder DSL
puts "3. Query Builder DSL (ActiveRecord-style)"
puts "-" * 80

# Simple query
query1 = User.where(active: true).order(:created_at, :desc).limit(10)
puts "Query 1: Active users, newest first, limit 10"
puts "  SQL: #{query1.to_sql}"
puts

# Complex query with joins
query2 = QueryBuilder.from(:posts)
  .select(:posts.*, :users.name)
  .join(:users, on: "posts.user_id = users.id")
  .where(published: true)
  .where("posts.view_count > 100")
  .order(:created_at, :desc)
  .limit(20)

puts "Query 2: Published posts with >100 views, with user names"
puts "  SQL: #{query2.to_sql}"
puts

# Query with grouping
query3 = QueryBuilder.from(:comments)
  .select("post_id", "COUNT(*) as comment_count")
  .group(:post_id)
  .having("COUNT(*) > 5")
  .order("comment_count", :desc)

puts "Query 3: Posts with more than 5 comments"
puts "  SQL: #{query3.to_sql}"
puts

# Method chaining demonstration
query4 = Post
  .where(published: true)
  .where("created_at > '2024-01-01'")
  .order(:title)
  .limit(5)
  .offset(10)

puts "Query 4: Published posts from 2024, page 3 (5 per page)"
puts "  SQL: #{query4.to_sql}"
puts

puts "=" * 80
puts "Lab complete! You've built powerful DSLs with metaprogramming!"
puts "=" * 80
puts
puts "Key Techniques Used:"
puts "✓ instance_eval for DSL blocks"
puts "✓ method_missing for dynamic methods"
puts "✓ define_method for HTTP verbs"
puts "✓ Method chaining (return self)"
puts "✓ Fluent interfaces"
puts "✓ Block-based configuration"
puts
puts "Try modifying the examples in examples/ directory!"
