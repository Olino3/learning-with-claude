#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 2: Add Database
# Sets up SQLite with Sequel ORM

require 'sinatra/base'
require 'sequel'

# Configure database
DB = Sequel.sqlite('todos.db')

# Create tables if they don't exist
DB.create_table? :categories do
  primary_key :id
  String :name, null: false, unique: true
  String :color, null: false, default: '#007bff'
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
end

DB.create_table? :tasks do
  primary_key :id
  String :title, null: false
  String :description, text: true
  TrueClass :completed, default: false
  foreign_key :category_id, :categories
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
end

puts "✅ Database tables created!"
puts "   - categories"
puts "   - tasks"

class TodoApp < Sinatra::Base
  get '/' do
    "Welcome to the Todo App! 📝\n\nDatabase is ready!"
  end

  get '/tasks' do
    # Query database directly for now
    task_count = DB[:tasks].count
    "Found #{task_count} tasks in database"
  end
end

if __FILE__ == $0
  puts "🚀 Todo App starting..."
  puts "📝 Visit http://localhost:4567"
  TodoApp.run!(port: 4567, bind: '0.0.0.0')
end
