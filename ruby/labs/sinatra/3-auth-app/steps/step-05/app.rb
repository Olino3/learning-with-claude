#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 5: Login System
# Session-based authentication with login/logout

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

# User model
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
  def current_user
    @current_user ||= User[session[:user_id]] if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end

  def flash
    @flash ||= session.delete(:flash) || {}
  end
end

# Home page
get '/' do
  erb :home
end

# Registration
get '/register' do
  redirect '/dashboard' if logged_in?
  @user = User.new
  @errors = []
  erb :register
end

post '/register' do
  redirect '/dashboard' if logged_in?

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
    session[:flash] = { success: "Welcome, #{@user.name}!" }
    redirect '/dashboard'
  else
    @errors = @user.errors.full_messages
    erb :register
  end
end

# Login
get '/login' do
  redirect '/dashboard' if logged_in?
  erb :login
end

post '/login' do
  redirect '/dashboard' if logged_in?

  user = User.find(email: params[:email].downcase.strip)

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    session[:flash] = { success: "Welcome back, #{user.name}!" }
    redirect '/dashboard'
  else
    session[:flash] = { error: 'Invalid email or password' }
    erb :login
  end
end

# Logout
get '/logout' do
  session.clear
  session[:flash] = { success: 'You have been logged out.' }
  redirect '/'
end

# Dashboard (protected)
get '/dashboard' do
  redirect '/login' unless logged_in?
  erb :dashboard
end

if __FILE__ == $0
  puts "Starting Auth App with Login System..."
  Sinatra::Application.run!
end
