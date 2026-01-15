#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 5: Create Tasks
# Adds form to create new tasks

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
end

# Seed categories
if Category.count == 0
  Category.create(name: 'Work', color: '#007bff')
  Category.create(name: 'Personal', color: '#28a745')
  Category.create(name: 'Shopping', color: '#ffc107')
end

class TodoApp < Sinatra::Base
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :public_folder, File.join(File.dirname(__FILE__), 'public')

  helpers do
    def h(text)
      Rack::Utils.escape_html(text.to_s)
    end
  end

  get '/' do
    redirect '/tasks'
  end

  # List tasks
  get '/tasks' do
    @tasks = Task.order(Sequel.desc(:created_at)).all
    @categories = Category.all
    erb :index
  end

  # New task form
  get '/tasks/new' do
    @task = Task.new
    @categories = Category.all
    erb :new
  end

  # Create task
  post '/tasks' do
    @task = Task.new(
      title: params[:title],
      description: params[:description],
      category_id: params[:category_id].to_s.empty? ? nil : params[:category_id]
    )

    if @task.valid? && @task.save
      redirect '/tasks'
    else
      @categories = Category.all
      erb :new
    end
  end
end

if __FILE__ == $0
  puts "🚀 Todo App starting..."
  puts "📝 Visit http://localhost:4567"
  TodoApp.run!(port: 4567, bind: '0.0.0.0')
end
