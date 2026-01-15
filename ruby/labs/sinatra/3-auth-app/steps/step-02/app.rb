#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 2: Add Database
# SQLite database with Sequel ORM

require 'sinatra'
require 'sequel'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'auth-app-secret-key-change-in-production'

# Configure database
DB = Sequel.sqlite('auth_app.db')

# Create users table if it doesn't exist
DB.create_table? :users do
  primary_key :id
  String :email, null: false, unique: true
  String :password_digest, null: false
  String :name, null: false
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
end

puts "Database connected: auth_app.db"

# Home page
get '/' do
  erb :home
end

# Health check showing database status
get '/health' do
  content_type :json
  { status: 'ok', database: 'connected', tables: DB.tables }.to_json
end

if __FILE__ == $0
  puts "Starting Auth App with Database..."
  Sinatra::Application.run!
end
