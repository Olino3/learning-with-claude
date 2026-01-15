#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 3: Create Models
# Defines Sequel models with validations and associations

require 'sinatra/base'
require 'sequel'

# Configure database
DB = Sequel.sqlite('todos.db')

# Create tables
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

# Define models
class Category < Sequel::Model
  one_to_many :tasks
end

class Task < Sequel::Model
  many_to_one :category

  # Validations
  def validate
    super
    errors.add(:title, 'cannot be empty') if !title || title.strip.empty?
    errors.add(:title, 'must be between 2 and 100 characters') if title && (title.length < 2 || title.length > 100)
    errors.add(:description, 'must be less than 500 characters') if description && description.length > 500
  end

  # Callback: update timestamp on save
  def before_update
    self.updated_at = Time.now
    super
  end
end

# Seed default categories if none exist
if Category.count == 0
  puts "🌱 Seeding default categories..."
  Category.create(name: 'Work', color: '#007bff')
  Category.create(name: 'Personal', color: '#28a745')
  Category.create(name: 'Shopping', color: '#ffc107')
  Category.create(name: 'Health', color: '#dc3545')
  Category.create(name: 'Learning', color: '#6f42c1')
  puts "   Created #{Category.count} categories"
end

class TodoApp < Sinatra::Base
  get '/' do
    "Welcome to the Todo App! 📝"
  end

  get '/tasks' do
    tasks = Task.all
    categories = Category.all

    output = "Tasks (#{tasks.count}):\n"
    tasks.each { |t| output += "  - #{t.title} (#{t.completed ? 'done' : 'active'})\n" }
    output += "\nCategories (#{categories.count}):\n"
    categories.each { |c| output += "  - #{c.name}\n" }
    output
  end

  # Test model validation
  get '/test-validation' do
    task = Task.new(title: 'x')  # Too short
    if task.valid?
      "Valid!"
    else
      "Validation errors: #{task.errors.full_messages.join(', ')}"
    end
  end
end

if __FILE__ == $0
  puts "🚀 Todo App starting..."
  puts "📝 Visit http://localhost:4567"
  TodoApp.run!(port: 4567, bind: '0.0.0.0')
end
