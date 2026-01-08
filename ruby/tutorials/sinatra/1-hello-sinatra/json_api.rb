# Demonstrating JSON API responses in Sinatra
# Shows how to build a simple RESTful API

require 'sinatra'
require 'json'

# Sample data (in a real app, this would be from a database)
USERS = [
  { id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' },
  { id: 2, name: 'Bob', email: 'bob@example.com', role: 'user' },
  { id: 3, name: 'Charlie', email: 'charlie@example.com', role: 'user' }
]

# Helper to set JSON content type
before do
  content_type :json
end

# API root - documentation
get '/' do
  {
    message: 'Welcome to the Sinatra JSON API',
    version: '1.0',
    endpoints: {
      users: '/api/users',
      health: '/api/health',
      status: '/api/status'
    }
  }.to_json
end

# Get all users
get '/api/users' do
  USERS.to_json
end

# Get specific user by ID
get '/api/users/:id' do
  id = params[:id].to_i
  user = USERS.find { |u| u[:id] == id }

  if user
    user.to_json
  else
    status 404
    { error: 'User not found', id: id }.to_json
  end
end

# Health check endpoint
get '/api/health' do
  {
    status: 'healthy',
    timestamp: Time.now.iso8601,
    uptime: 'unknown'
  }.to_json
end

# Status endpoint with server information
get '/api/status' do
  {
    status: 'running',
    environment: settings.environment.to_s,
    port: settings.port,
    ruby_version: RUBY_VERSION,
    sinatra_version: Sinatra::VERSION
  }.to_json
end

# 404 handler for API routes
not_found do
  {
    error: 'Not Found',
    message: 'The requested endpoint does not exist',
    status: 404
  }.to_json
end

# 🐍 Python/Flask equivalent:
#
# from flask import Flask, jsonify
#
# USERS = [
#     {'id': 1, 'name': 'Alice', 'email': 'alice@example.com'},
#     {'id': 2, 'name': 'Bob', 'email': 'bob@example.com'}
# ]
#
# @app.route('/api/users')
# def get_users():
#     return jsonify(USERS)
#
# @app.route('/api/users/<int:id>')
# def get_user(id):
#     user = next((u for u in USERS if u['id'] == id), None)
#     if user:
#         return jsonify(user)
#     return jsonify({'error': 'Not found'}), 404
#
# @app.route('/api/health')
# def health():
#     return jsonify({'status': 'healthy'})
