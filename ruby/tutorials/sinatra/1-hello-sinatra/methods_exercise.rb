# Exercise 2 Solution: Multiple HTTP Methods
#
# Requirements:
# - GET /tasks returns "Viewing all tasks"
# - POST /tasks returns "Creating a new task"
# - DELETE /tasks/1 returns "Deleting task 1"

require 'sinatra'

# GET - View all tasks
get '/tasks' do
  'Viewing all tasks'
end

# POST - Create a new task
post '/tasks' do
  'Creating a new task'
end

# DELETE - Delete a specific task
delete '/tasks/:id' do
  id = params[:id]
  "Deleting task #{id}"
end

# Bonus: Add more CRUD operations
# PUT - Update a task
put '/tasks/:id' do
  id = params[:id]
  "Updating task #{id}"
end

# GET - View a specific task
get '/tasks/:id' do
  id = params[:id]
  "Viewing task #{id}"
end

# Info page
get '/' do
  """
  <h1>Task Manager API</h1>
  <h2>Available Operations:</h2>
  <ul>
    <li>GET /tasks - View all tasks</li>
    <li>POST /tasks - Create a new task</li>
    <li>GET /tasks/:id - View specific task</li>
    <li>PUT /tasks/:id - Update task</li>
    <li>DELETE /tasks/:id - Delete task</li>
  </ul>

  <h2>Test with curl:</h2>
  <pre>
  curl http://localhost:4567/tasks
  curl -X POST http://localhost:4567/tasks
  curl -X DELETE http://localhost:4567/tasks/1
  </pre>
  """
end

# 🐍 Python/Flask equivalent:
#
# @app.route('/tasks', methods=['GET'])
# def view_tasks():
#     return 'Viewing all tasks'
#
# @app.route('/tasks', methods=['POST'])
# def create_task():
#     return 'Creating a new task'
#
# @app.route('/tasks/<id>', methods=['DELETE'])
# def delete_task(id):
#     return f'Deleting task {id}'
