#!/usr/bin/env ruby
# frozen_string_literal: true

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

# Initialize models
class Category < Sequel::Model
  one_to_many :tasks
end

class Task < Sequel::Model
  many_to_one :category

  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.strip.empty?
    errors.add(:title, 'must be between 2 and 100 characters') if title && (title.length < 2 || title.length > 100)
    errors.add(:description, 'must be less than 500 characters') if description && description.length > 500
  end

  def before_update
    self.updated_at = Time.now
    super
  end
end

# Seed default categories if none exist
if Category.count == 0
  Category.create(name: 'Work', color: '#007bff')
  Category.create(name: 'Personal', color: '#28a745')
  Category.create(name: 'Shopping', color: '#ffc107')
  Category.create(name: 'Health', color: '#dc3545')
  Category.create(name: 'Learning', color: '#6f42c1')
end

class TodoApp < Sinatra::Base
  enable :sessions
  set :session_secret, 'todo_app_super_secret_key_that_is_at_least_64_characters_long_for_security'
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :public_folder, File.join(File.dirname(__FILE__), 'public')

  # Include helpers from lib
  require_relative 'lib/helpers'

  # Helper methods
  helpers TodoHelpers

  helpers do
    def flash
      @flash ||= session.delete(:flash) || {}
    end

    def set_flash(type, message)
      session[:flash] = { type => message }
    end
  end

  # Routes

  # Home - redirect to tasks
  get '/' do
    redirect '/tasks'
  end

  # Index - List all tasks
  get '/tasks' do
    @filter = params[:filter] || 'all'
    @category_id = params[:category]
    @search = params[:search]

    @tasks = Task.dataset

    # Apply filters
    case @filter
    when 'active'
      @tasks = @tasks.where(completed: false)
    when 'completed'
      @tasks = @tasks.where(completed: true)
    end

    # Filter by category
    @tasks = @tasks.where(category_id: @category_id) if @category_id

    # Search by title
    @tasks = @tasks.where(Sequel.like(:title, "%#{@search}%")) if @search && !@search.empty?

    @tasks = @tasks.order(Sequel.desc(:created_at)).all
    @categories = Category.all

    # Calculate statistics
    all_tasks = Task.all
    @total_count = all_tasks.count
    @completed_count = all_tasks.count { |t| t.completed }
    @active_count = @total_count - @completed_count

    erb :index
  end

  # New - Show form for new task
  get '/tasks/new' do
    @task = Task.new
    @categories = Category.all
    erb :new
  end

  # Create - Create a new task
  post '/tasks' do
    task = Task.new(
      title: params[:title],
      description: params[:description],
      category_id: params[:category_id]
    )

    if task.valid? && task.save
      set_flash(:success, 'Task created successfully!')
      redirect '/tasks'
    else
      set_flash(:error, task.errors.full_messages.join(', '))
      @task = task
      @categories = Category.all
      erb :new
    end
  end

  # Edit - Show form to edit task
  get '/tasks/:id/edit' do
    @task = Task[params[:id]]
    halt 404, 'Task not found' unless @task

    @categories = Category.all
    erb :edit
  end

  # Update - Update a task
  put '/tasks/:id' do
    task = Task[params[:id]]
    halt 404, 'Task not found' unless task

    task.set(
      title: params[:title],
      description: params[:description],
      category_id: params[:category_id]
    )

    if task.valid? && task.save
      set_flash(:success, 'Task updated successfully!')
      redirect '/tasks'
    else
      set_flash(:error, task.errors.full_messages.join(', '))
      @task = task
      @categories = Category.all
      erb :edit
    end
  end

  # Update - Update a task (for browsers that don't support PUT)
  post '/tasks/:id' do
    if params[:_method] == 'put'
      request.env['REQUEST_METHOD'] = 'PUT'
      pass
    elsif params[:_method] == 'delete'
      request.env['REQUEST_METHOD'] = 'DELETE'
      pass
    end
  end

  # Delete - Delete a task
  delete '/tasks/:id' do
    task = Task[params[:id]]
    halt 404, 'Task not found' unless task

    task.delete
    set_flash(:success, 'Task deleted successfully!')
    redirect '/tasks'
  end

  # Toggle - Toggle task completion
  post '/tasks/:id/toggle' do
    task = Task[params[:id]]
    halt 404, 'Task not found' unless task

    task.update(completed: !task.completed)

    message = task.completed ? 'Task marked as complete!' : 'Task marked as incomplete!'
    set_flash(:success, message)

    redirect '/tasks'
  end

  # Categories listing
  get '/categories' do
    @categories = Category.all
    erb :categories
  end

  # Error handlers
  not_found do
    @error = 'Page not found'
    erb :error
  end

  error do
    @error = env['sinatra.error'].message
    erb :error
  end
end

# Start the server when this file is executed directly
if __FILE__ == $0
  puts "🚀 Todo App starting..."
  puts "📝 Visit http://localhost:4567"
  puts "🛑 Press Ctrl+C to stop"
  TodoApp.run!(port: 4567, bind: '0.0.0.0')
end
