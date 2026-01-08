# Exercise 3 Solution: JSON API
#
# Requirements:
# - GET /api/users returns JSON array of users
# - GET /api/health returns health status as JSON

require 'sinatra'
require 'json'

# Sample user data
USERS = [
  { id: 1, name: 'Alice Johnson', email: 'alice@example.com' },
  { id: 2, name: 'Bob Smith', email: 'bob@example.com' },
  { id: 3, name: 'Charlie Brown', email: 'charlie@example.com' }
]

# Set JSON content type for all API routes
before '/api/*' do
  content_type :json
end

# GET all users
get '/api/users' do
  USERS.to_json
end

# GET health status
get '/api/health' do
  {
    status: 'healthy',
    timestamp: Time.now.iso8601,
    version: '1.0.0'
  }.to_json
end

# Bonus: Add more API endpoints

# GET specific user by ID
get '/api/users/:id' do
  id = params[:id].to_i
  user = USERS.find { |u| u[:id] == id }

  if user
    user.to_json
  else
    status 404
    { error: 'User not found' }.to_json
  end
end

# GET user count
get '/api/users/count' do
  { count: USERS.length }.to_json
end

# API documentation (HTML)
get '/' do
  content_type :html
  """
  <h1>User API Documentation</h1>

  <h2>Endpoints:</h2>
  <ul>
    <li><code>GET /api/users</code> - Get all users</li>
    <li><code>GET /api/users/:id</code> - Get specific user</li>
    <li><code>GET /api/users/count</code> - Get user count</li>
    <li><code>GET /api/health</code> - Health check</li>
  </ul>

  <h2>Try it:</h2>
  <ul>
    <li><a href='/api/users' target='_blank'>/api/users</a></li>
    <li><a href='/api/users/1' target='_blank'>/api/users/1</a></li>
    <li><a href='/api/users/count' target='_blank'>/api/users/count</a></li>
    <li><a href='/api/health' target='_blank'>/api/health</a></li>
  </ul>
  """
end

# 🐍 Python/Flask equivalent:
#
# from flask import Flask, jsonify
#
# USERS = [
#     {'id': 1, 'name': 'Alice Johnson', 'email': 'alice@example.com'},
#     {'id': 2, 'name': 'Bob Smith', 'email': 'bob@example.com'}
# ]
#
# @app.route('/api/users')
# def get_users():
#     return jsonify(USERS)
#
# @app.route('/api/health')
# def health():
#     return jsonify({
#         'status': 'healthy',
#         'timestamp': datetime.now().isoformat()
#     })
