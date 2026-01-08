require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/namespace'
require 'json'
require 'jwt'
require 'securerandom'

# Storage
USERS = {}
TASKS = []

# JWT Secret
JWT_SECRET = ENV['JWT_SECRET'] || 'dev_secret_change_in_production'

# Helpers
helpers do
  def json_params
    request.body.rewind
    JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end

  def generate_token(user_id)
    payload = { user_id: user_id, exp: Time.now.to_i + 86400 }
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  def verify_token!
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
    halt 401, { error: 'Missing token' }.to_json unless token

    begin
      payload = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
      @current_user_id = payload['user_id']
      @current_user = USERS[@current_user_id]
      halt 401, { error: 'User not found' }.to_json unless @current_user
    rescue JWT::DecodeError
      halt 401, { error: 'Invalid token' }.to_json
    end
  end

  def find_task(id)
    task = TASKS.find { |t| t[:id] == id && t[:user_id] == @current_user_id }
    halt 404, { error: 'Task not found' }.to_json unless task
    task
  end
end

# CORS
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers' => 'Content-Type, Authorization'
  content_type :json
end

options '*' do
  200
end

# Auth routes
post '/auth/register' do
  data = json_params

  errors = []
  errors << 'Email is required' if data[:email].to_s.empty?
  errors << 'Password is required' if data[:password].to_s.empty?
  errors << 'Email already exists' if USERS.values.any? { |u| u[:email] == data[:email] }

  halt 422, { error: 'Validation failed', details: errors }.to_json if errors.any?

  user_id = SecureRandom.uuid
  USERS[user_id] = {
    id: user_id,
    email: data[:email],
    password: data[:password],  # In production: use bcrypt!
    created_at: Time.now.to_i
  }

  token = generate_token(user_id)
  status 201
  { token: token, user_id: user_id }.to_json
end

post '/auth/login' do
  data = json_params

  user = USERS.values.find { |u| u[:email] == data[:email] && u[:password] == data[:password] }
  halt 401, { error: 'Invalid credentials' }.to_json unless user

  token = generate_token(user[:id])
  { token: token, user_id: user[:id] }.to_json
end

# Protected API
namespace '/api' do
  before do
    verify_token!
  end

  # V1: Basic task API
  namespace '/v1' do
    get '/tasks' do
      tasks = TASKS.select { |t| t[:user_id] == @current_user_id }

      # Filter
      tasks = tasks.select { |t| t[:completed] == (params[:completed] == 'true') } if params[:completed]
      tasks = tasks.select { |t| t[:title].include?(params[:search]) } if params[:search]

      { version: 1, tasks: tasks, count: tasks.length }.to_json
    end

    get '/tasks/:id' do
      task = find_task(params[:id])
      task.to_json
    end

    post '/tasks' do
      data = json_params

      errors = []
      errors << 'Title is required' if data[:title].to_s.empty?
      halt 422, { error: 'Validation failed', details: errors }.to_json if errors.any?

      task = {
        id: SecureRandom.uuid,
        user_id: @current_user_id,
        title: data[:title],
        description: data[:description],
        completed: false,
        created_at: Time.now.to_i
      }

      TASKS << task
      status 201
      task.to_json
    end

    put '/tasks/:id' do
      task = find_task(params[:id])
      data = json_params

      task[:title] = data[:title] if data[:title]
      task[:description] = data[:description] if data.key?(:description)
      task[:completed] = data[:completed] if data.key?(:completed)
      task[:updated_at] = Time.now.to_i

      task.to_json
    end

    delete '/tasks/:id' do
      task = find_task(params[:id])
      TASKS.delete(task)
      status 204
    end
  end

  # V2: Enhanced API with tags
  namespace '/v2' do
    get '/tasks' do
      tasks = TASKS.select { |t| t[:user_id] == @current_user_id }

      tasks = tasks.select { |t| t[:completed] == (params[:completed] == 'true') } if params[:completed]
      tasks = tasks.select { |t| (t[:tags] || []).include?(params[:tag]) } if params[:tag]

      {
        version: 2,
        tasks: tasks,
        meta: {
          total: tasks.length,
          completed: tasks.count { |t| t[:completed] },
          pending: tasks.count { |t| !t[:completed] }
        }
      }.to_json
    end

    post '/tasks' do
      data = json_params

      task = {
        id: SecureRandom.uuid,
        user_id: @current_user_id,
        title: data[:title],
        description: data[:description],
        completed: false,
        tags: data[:tags] || [],
        priority: data[:priority] || 'normal',
        created_at: Time.now.to_i
      }

      TASKS << task
      status 201
      task.to_json
    end
  end
end

# Root
get '/' do
  {
    name: 'Task API',
    versions: ['v1', 'v2'],
    endpoints: {
      register: 'POST /auth/register',
      login: 'POST /auth/login',
      v1_tasks: '/api/v1/tasks',
      v2_tasks: '/api/v2/tasks'
    }
  }.to_json
end
