#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 2: Add Database with ActiveRecord
# Setting up SQLite database with ActiveRecord ORM

require 'sinatra'
require 'sinatra/activerecord'
require 'json'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
set :database, { adapter: 'sqlite3', database: 'blog_api.db' }

# Set content type to JSON for all responses
before do
  content_type :json
end

# API root
get '/' do
  {
    name: 'Blog API',
    version: '1.0',
    status: 'running',
    database: 'connected'
  }.to_json
end

# Health check
get '/api/v1/health' do
  {
    status: 'ok',
    timestamp: Time.now,
    database: ActiveRecord::Base.connected? ? 'connected' : 'disconnected'
  }.to_json
end

# API info
get '/api/v1' do
  {
    message: 'Blog API v1',
    status: 'running',
    database: 'connected'
  }.to_json
end

if __FILE__ == $0
  puts "Starting Blog API with database..."
  Sinatra::Application.run!
end
