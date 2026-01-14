#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 8: Add Filtering
# Filter by category, status, and search

require 'sinatra/base'
require 'sequel'

DB = Sequel.sqlite('todos.db')

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

class Category < Sequel::Model
  one_to_many :tasks
end

class Task < Sequel::Model
  many_to_one :category

  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.strip.empty?
    errors.add(:title, 'must be between 2 and 100 characters') if title && (title.length < 2 || title.length > 100)
  end

  def before_update
    self.updated_at = Time.now
    super
  end
end

# Seed data
if Category.count == 0
  Category.create(name: 'Work', color: '#007bff')
  Category.create(name: 'Personal', color: '#28a745')
  Category.create(name: 'Shopping', color: '#ffc107')
end

if Task.count == 0
  Task.create(title: 'Learn Sinatra', description: 'Work through the tutorial', category_id: 1)
  Task.create(title: 'Buy groceries', description: 'Milk, bread, eggs', category_id: 3)
  Task.create(title: 'Exercise', description: 'Go for a run', category_id: 2, completed: true)
end

class TodoApp < Sinatra::Base
  enable :sessions
  set :session_secret, 'todo_app_secret_key_change_in_production'
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :public_folder, File.join(File.dirname(__FILE__), 'public')

  helpers do
    def h(text)
      Rack::Utils.escape_html(text.to_s)
    end

    def flash_messages
      return '' unless session[:flash]
      messages = session.delete(:flash)
      html = ''
      messages.each do |type, msg|
        html += %(<div class="alert alert-#{type}">#{h(msg)}</div>)
      end
      html
    end

    def filter_link(text, filter_params)
      current = { category: params[:category], status: params[:status], q: params[:q] }
      merged = current.merge(filter_params).reject { |_, v| v.nil? || v.empty? }
      query = merged.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join('&')
      href = query.empty? ? '/tasks' : "/tasks?#{query}"
      active = filter_params.all? { |k, v| params[k.to_s] == v }
      css_class = active ? 'btn btn-primary btn-sm' : 'btn btn-outline btn-sm'
      %(<a href="#{href}" class="#{css_class}">#{h(text)}</a>)
    end
  end

  def set_flash(type, message)
    session[:flash] ||= {}
    session[:flash][type] = message
  end

  get '/' do
    redirect '/tasks'
  end

  get '/tasks' do
    @categories = Category.all
    dataset = Task.dataset

    # Filter by category
    if params[:category] && !params[:category].empty?
      dataset = dataset.where(category_id: params[:category])
    end

    # Filter by status
    case params[:status]
    when 'active'
      dataset = dataset.where(completed: false)
    when 'completed'
      dataset = dataset.where(completed: true)
    end

    # Search
    if params[:q] && !params[:q].strip.empty?
      search = "%#{params[:q].strip}%"
      dataset = dataset.where(Sequel.ilike(:title, search) | Sequel.ilike(:description, search))
    end

    @tasks = dataset.order(Sequel.desc(:created_at)).all
    @total_count = Task.count
    @filtered = params[:category] || params[:status] || params[:q]

    erb :index
  end

  get '/tasks/new' do
    @task = Task.new
    @categories = Category.all
    erb :new
  end

  post '/tasks' do
    @task = Task.new(
      title: params[:title],
      description: params[:description],
      category_id: params[:category_id].to_s.empty? ? nil : params[:category_id]
    )

    if @task.valid? && @task.save
      set_flash(:success, 'Task created successfully!')
      redirect '/tasks'
    else
      @categories = Category.all
      erb :new
    end
  end

  get '/tasks/:id/edit' do
    @task = Task[params[:id]]
    halt 404, 'Task not found' unless @task
    @categories = Category.all
    erb :edit
  end

  put '/tasks/:id' do
    @task = Task[params[:id]]
    halt 404, 'Task not found' unless @task

    @task.set(
      title: params[:title],
      description: params[:description],
      category_id: params[:category_id].to_s.empty? ? nil : params[:category_id]
    )

    if @task.valid? && @task.save
      set_flash(:success, 'Task updated successfully!')
      redirect '/tasks'
    else
      @categories = Category.all
      erb :edit
    end
  end

  post '/tasks/:id' do
    if params[:_method] == 'put'
      request.env['REQUEST_METHOD'] = 'PUT'
      pass
    elsif params[:_method] == 'delete'
      request.env['REQUEST_METHOD'] = 'DELETE'
      pass
    end
  end

  delete '/tasks/:id' do
    task = Task[params[:id]]
    halt 404, 'Task not found' unless task
    task.delete
    set_flash(:info, 'Task deleted.')
    redirect '/tasks'
  end

  post '/tasks/:id/toggle' do
    task = Task[params[:id]]
    halt 404, 'Task not found' unless task
    task.update(completed: !task.completed)
    status = task.completed ? 'completed' : 'marked as active'
    set_flash(:success, "Task #{status}!")
    redirect back
  end
end

if __FILE__ == $0
  puts "🚀 Todo App starting..."
  puts "📝 Visit http://localhost:4567"
  TodoApp.run!(port: 4567, bind: '0.0.0.0')
end
