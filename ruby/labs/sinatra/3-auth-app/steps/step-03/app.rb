#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 3: User Model
# User model with basic validations

require 'sinatra'
require 'sequel'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'auth-app-secret-key-change-in-production'

# Configure database
DB = Sequel.sqlite('auth_app.db')

# Create users table
DB.create_table? :users do
  primary_key :id
  String :email, null: false, unique: true
  String :password_digest, null: false
  String :name, null: false
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
end

# User model with validations
class User < Sequel::Model
  def validate
    super
    errors.add(:email, 'cannot be empty') if !email || email.strip.empty?
    errors.add(:email, 'is not valid') unless email =~ URI::MailTo::EMAIL_REGEXP
    errors.add(:name, 'cannot be empty') if !name || name.strip.empty?
    errors.add(:name, 'must be at least 2 characters') if name && name.length < 2
  end

  def before_save
    self.email = email.downcase.strip if email
    self.updated_at = Time.now
    super
  end
end

# Home page
get '/' do
  erb :home
end

# List users (for testing)
get '/users' do
  content_type :json
  User.all.map { |u| { id: u.id, email: u.email, name: u.name } }.to_json
end

if __FILE__ == $0
  puts "Starting Auth App with User Model..."
  Sinatra::Application.run!
end
