# Demonstrating different HTTP methods in Sinatra
# Shows how to handle GET, POST, PUT, PATCH, and DELETE requests

require 'sinatra'

# GET - Retrieve resource
get '/users' do
  '<h1>User List</h1>
   <p>GET request to retrieve all users</p>
   <ul>
     <li>Alice (ID: 1)</li>
     <li>Bob (ID: 2)</li>
     <li>Charlie (ID: 3)</li>
   </ul>'
end

# POST - Create new resource
post '/users' do
  '<h1>User Created</h1>
   <p>POST request to create a new user</p>
   <p>In a real app, this would save to a database</p>'
end

# GET - Retrieve specific resource
get '/users/:id' do
  id = params[:id]
  "<h1>User Details</h1>
   <p>GET request for user ID: #{id}</p>
   <p>Name: User #{id}</p>"
end

# PUT - Update entire resource
put '/users/:id' do
  id = params[:id]
  "<h1>User Updated</h1>
   <p>PUT request to completely update user #{id}</p>
   <p>In a real app, this would update the database</p>"
end

# PATCH - Partial update of resource
patch '/users/:id' do
  id = params[:id]
  "<h1>User Partially Updated</h1>
   <p>PATCH request to partially update user #{id}</p>
   <p>In a real app, this would update specific fields</p>"
end

# DELETE - Remove resource
delete '/users/:id' do
  id = params[:id]
  "<h1>User Deleted</h1>
   <p>DELETE request to remove user #{id}</p>
   <p>In a real app, this would delete from database</p>"
end

# Info page with instructions
get '/' do
  """
  <h1>HTTP Methods Demo</h1>
  <p>This app demonstrates different HTTP methods.</p>

  <h2>Try these routes:</h2>
  <ul>
    <li>GET <a href='/users'>/users</a> - List all users</li>
    <li>GET <a href='/users/1'>/users/1</a> - Get specific user</li>
    <li>POST /users - Create new user (use curl or Postman)</li>
    <li>PUT /users/1 - Update user (use curl or Postman)</li>
    <li>PATCH /users/1 - Partial update (use curl or Postman)</li>
    <li>DELETE /users/1 - Delete user (use curl or Postman)</li>
  </ul>

  <h2>Test with curl:</h2>
  <pre>
  # GET
  curl http://localhost:4567/users

  # POST
  curl -X POST http://localhost:4567/users

  # PUT
  curl -X PUT http://localhost:4567/users/1

  # PATCH
  curl -X PATCH http://localhost:4567/users/1

  # DELETE
  curl -X DELETE http://localhost:4567/users/1
  </pre>
  """
end

# 🐍 Python/Flask equivalent:
#
# @app.route('/users', methods=['GET'])
# def get_users():
#     return 'User List'
#
# @app.route('/users', methods=['POST'])
# def create_user():
#     return 'User Created'
#
# @app.route('/users/<id>', methods=['PUT'])
# def update_user(id):
#     return f'Update user {id}'
#
# @app.route('/users/<id>', methods=['DELETE'])
# def delete_user(id):
#     return f'Delete user {id}'
