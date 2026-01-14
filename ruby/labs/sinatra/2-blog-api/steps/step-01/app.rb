#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 1: Basic API Setup
# A minimal Sinatra API that returns JSON responses

require 'sinatra'
require 'json'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'

# Set content type to JSON for all responses
before do
  content_type :json
end

# API root
get '/' do
  {
    name: 'Blog API',
    version: '1.0',
    status: 'running'
  }.to_json
end

# Health check
get '/api/v1/health' do
  {
    status: 'ok',
    timestamp: Time.now
  }.to_json
end

# API info
get '/api/v1' do
  {
    message: 'Blog API v1',
    status: 'running'
  }.to_json
end

if __FILE__ == $0
  puts "Starting Blog API..."
  Sinatra::Application.run!
end
