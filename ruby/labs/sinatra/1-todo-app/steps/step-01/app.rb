#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 1: Basic Sinatra Setup
# Creates your first Sinatra route

require 'sinatra/base'

class TodoApp < Sinatra::Base
  # Home route - returns a simple string
  get '/' do
    "Welcome to the Todo App! 📝"
  end

  # Tasks route - placeholder
  get '/tasks' do
    "Task list coming soon..."
  end
end

# Start the server when this file is executed directly
if __FILE__ == $0
  puts "🚀 Todo App starting..."
  puts "📝 Visit http://localhost:4567"
  puts "🛑 Press Ctrl+C to stop"
  TodoApp.run!(port: 4567, bind: '0.0.0.0')
end
