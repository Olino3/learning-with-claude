#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 4: Password Security
# BCrypt password hashing and registration

require 'sinatra'
require 'sequel'
require 'bcrypt'

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

# User model with BCrypt
class User < Sequel::Model
  def password=(new_password)
    @password = new_password
    self.password_digest = BCrypt::Password.create(new_password) if new_password
  end

  def password
    @password
  end

  def authenticate(attempted_password)
    BCrypt::Password.new(password_digest) == attempted_password
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def validate
    super
    errors.add(:email, 'cannot be empty') if !email || email.strip.empty?
    errors.add(:email, 'is not valid') unless email =~ URI::MailTo::EMAIL_REGEXP
    errors.add(:name, 'cannot be empty') if !name || name.strip.empty?
    errors.add(:name, 'must be at least 2 characters') if name && name.length < 2

    if new? || password
      errors.add(:password, 'cannot be empty') if !password || password.strip.empty?
      errors.add(:password, 'must be at least 6 characters') if password && password.length < 6
    end
  end

  def before_save
    self.email = email.downcase.strip if email
    self.updated_at = Time.now
    super
  end
end

# Helpers
helpers do
  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end
end

# Home page
get '/' do
  erb :home
end

# Registration form
get '/register' do
  @user = User.new
  @errors = []
  erb :register
end

# Create new user
post '/register' do
  @user = User.new(
    email: params[:email],
    name: params[:name],
    password: params[:password]
  )

  @errors = []
  if params[:password] != params[:password_confirmation]
    @errors << 'Passwords do not match'
    return erb :register
  end

  if @user.valid? && @user.save
    session[:user_id] = @user.id
    redirect '/success'
  else
    @errors = @user.errors.full_messages
    erb :register
  end
end

# Success page
get '/success' do
  erb :success
end

if __FILE__ == $0
  puts "Starting Auth App with Registration..."
  Sinatra::Application.run!
end
