#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'bcrypt'
require_relative 'lib/auth_helpers'
require_relative 'lib/models/user'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'auth-app-secret-key-change-in-production-this-must-be-at-least-64-bytes-long'
set :sessions, expire_after: 2592000 # 30 days

# Enable security features
use Rack::Protection
use Rack::Protection::AuthenticityToken

# Configure database
DB = Sequel.sqlite('auth_app.db')

# Create users table if it doesn't exist
DB.create_table? :users do
  primary_key :id
  String :email, null: false, unique: true
  String :password_digest, null: false
  String :name, null: false
  String :remember_token
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
  DateTime :last_login_at
end

# Initialize User model
class User < Sequel::Model
  # BCrypt password handling
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

  # Validations
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

  # Callbacks
  def before_save
    self.email = email.downcase.strip if email
    self.updated_at = Time.now
    super
  end

  # Generate remember token
  def generate_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
    save
    remember_token
  end

  # Clear remember token
  def clear_remember_token
    self.remember_token = nil
    save
  end

  # Update last login
  def update_last_login
    self.last_login_at = Time.now
    save
  end
end

# Helpers
helpers do
  include AuthHelpers

  def csrf_token
    session[:csrf] ||= SecureRandom.hex(32)
  end

  def csrf_tag
    "<input type='hidden' name='authenticity_token' value='#{csrf_token}'>"
  end

  def verify_csrf_token
    halt 403, 'Invalid CSRF token' unless params[:authenticity_token] == session[:csrf]
  end
end

# Before filter for authentication
before do
  # Skip authentication for public routes
  public_routes = ['/', '/login', '/register', '/logout']
  return if public_routes.include?(request.path_info) || request.path_info.start_with?('/css')

  # Check authentication
  unless authenticated?
    session[:return_to] = request.path_info
    flash[:warning] = 'Please log in to access this page.'
    redirect '/login'
  end
end

# Routes

# Home page
get '/' do
  erb :home
end

# Registration form
get '/register' do
  redirect '/dashboard' if authenticated?
  @user = User.new
  erb :register
end

# Create new user
post '/register' do
  redirect '/dashboard' if authenticated?

  @user = User.new(
    email: params[:email],
    name: params[:name],
    password: params[:password]
  )

  if params[:password] != params[:password_confirmation]
    @user.errors.add(:password_confirmation, 'does not match password')
    return erb :register
  end

  if @user.valid? && @user.save
    login(@user)
    flash[:success] = "Welcome, #{@user.name}! Your account has been created."
    redirect '/dashboard'
  else
    erb :register
  end
end

# Login form
get '/login' do
  redirect '/dashboard' if authenticated?
  erb :login
end

# Authenticate user
post '/login' do
  redirect '/dashboard' if authenticated?

  user = User.find(email: params[:email].downcase.strip)

  if user && user.authenticate(params[:password])
    login(user, remember: params[:remember_me] == 'on')
    user.update_last_login

    flash[:success] = "Welcome back, #{user.name}!"

    # Redirect to intended page or dashboard
    return_to = session.delete(:return_to) || '/dashboard'
    redirect return_to
  else
    flash[:error] = 'Invalid email or password.'
    erb :login
  end
end

# Logout
get '/logout' do
  logout
  flash[:success] = 'You have been logged out.'
  redirect '/'
end

# Dashboard (protected)
get '/dashboard' do
  erb :dashboard
end

# User profile (protected)
get '/profile' do
  erb :profile
end

# Edit profile form (protected)
get '/profile/edit' do
  erb :edit_profile
end

# Update profile (protected)
post '/profile/edit' do
  verify_csrf_token

  current_user.name = params[:name]

  # Check if email is changing
  if params[:email].downcase.strip != current_user.email
    current_user.email = params[:email]
  end

  if current_user.valid? && current_user.save
    flash[:success] = 'Profile updated successfully!'
    redirect '/profile'
  else
    erb :edit_profile
  end
end

# Change password (protected)
post '/profile/password' do
  verify_csrf_token

  unless current_user.authenticate(params[:current_password])
    flash[:error] = 'Current password is incorrect.'
    redirect '/profile/edit'
  end

  if params[:new_password] != params[:new_password_confirmation]
    flash[:error] = 'New passwords do not match.'
    redirect '/profile/edit'
  end

  if params[:new_password].length < 6
    flash[:error] = 'New password must be at least 6 characters.'
    redirect '/profile/edit'
  end

  current_user.password = params[:new_password]
  if current_user.save
    flash[:success] = 'Password changed successfully!'
    redirect '/profile'
  else
    flash[:error] = 'Failed to change password.'
    redirect '/profile/edit'
  end
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

# Start the server if this file is executed directly
if __FILE__ == $0
  puts "🚀 Auth App starting..."
  puts "🔐 Visit http://localhost:#{settings.port}"
  puts "📝 Register a new account to get started"
  puts "🛑 Press Ctrl+C to stop"
  Sinatra::Application.run!
end
