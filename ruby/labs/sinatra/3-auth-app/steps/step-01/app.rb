#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 1: Basic Web App Setup
# Sinatra web application with views and layout

require 'sinatra'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'auth-app-secret-key-change-in-production'

# Home page
get '/' do
  erb :home
end

if __FILE__ == $0
  puts "Starting Auth App..."
  Sinatra::Application.run!
end
