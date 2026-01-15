#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 8: User Profiles (Complete)
# User dashboard, profile editing, and password change

require 'sinatra'
require 'sequel'
require 'bcrypt'
require 'securerandom'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'auth-app-secret-key-change-in-production'
set :sessions, expire_after: 2592000 # 30 days

# Enable security features
use Rack::Protection
use Rack::Protection::AuthenticityToken

# Configure database
DB = Sequel.sqlite('auth_app.db')

# Create users table
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

  def generate_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
    save
    remember_token
  end

  def clear_remember_token
    self.remember_token = nil
    save
  end

  def update_last_login
    self.last_login_at = Time.now
    save
  end
end

# Helpers
helpers do
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = nil

    if session[:user_id]
      @current_user = User[session[:user_id]]
    elsif request.cookies['remember_token']
      user = User.find(remember_token: request.cookies['remember_token'])
      if user
        session[:user_id] = user.id
        @current_user = user
      end
    end

    @current_user
  end

  def logged_in?
    !!current_user
  end

  def login(user, remember: false)
    session[:user_id] = user.id
    @current_user = user

    if remember
      token = user.generate_remember_token
      response.set_cookie('remember_token', {
        value: token,
        expires: Time.now + (90 * 24 * 60 * 60),
        httponly: true,
        path: '/'
      })
    end
  end

  def logout
    current_user&.clear_remember_token
    session.delete(:user_id)
    response.delete_cookie('remember_token', path: '/')
    @current_user = nil
  end

  def require_login
    unless logged_in?
      session[:return_to] = request.path_info
      session[:flash] = { warning: 'Please log in to access this page.' }
      redirect '/login'
    end
  end

  def csrf_token
    session[:csrf] ||= SecureRandom.hex(32)
  end

  def csrf_tag
    "<input type='hidden' name='authenticity_token' value='#{csrf_token}'>"
  end

  def verify_csrf_token
    halt 403, 'Invalid CSRF token' unless params[:authenticity_token] == session[:csrf]
  end

  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end

  def flash
    @flash ||= session.delete(:flash) || {}
  end
end

# Before filters
before '/dashboard' do
  require_login
end

before '/profile*' do
  require_login
end

# Routes
get '/' do
  erb :home
end

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
    login(@user)
    session[:flash] = { success: "Welcome, #{@user.name}! Your account has been created." }
    redirect '/dashboard'
  else
    @errors = @user.errors.full_messages
    erb :register
  end
end

get '/login' do
  redirect '/dashboard' if logged_in?
  erb :login
end

post '/login' do
  redirect '/dashboard' if logged_in?

  user = User.find(email: params[:email].downcase.strip)

  if user && user.authenticate(params[:password])
    remember = params[:remember_me] == 'on'
    login(user, remember: remember)
    user.update_last_login

    session[:flash] = { success: "Welcome back, #{user.name}!" }

    return_to = session.delete(:return_to) || '/dashboard'
    redirect return_to
  else
    session[:flash] = { error: 'Invalid email or password.' }
    erb :login
  end
end

get '/logout' do
  logout
  session[:flash] = { success: 'You have been logged out.' }
  redirect '/'
end

get '/dashboard' do
  erb :dashboard
end

get '/profile' do
  erb :profile
end

get '/profile/edit' do
  erb :edit_profile
end

post '/profile/edit' do
  verify_csrf_token

  current_user.name = params[:name]

  if params[:email].downcase.strip != current_user.email
    current_user.email = params[:email]
  end

  if current_user.valid? && current_user.save
    session[:flash] = { success: 'Profile updated successfully!' }
    redirect '/profile'
  else
    @errors = current_user.errors.full_messages
    erb :edit_profile
  end
end

post '/profile/password' do
  verify_csrf_token

  unless current_user.authenticate(params[:current_password])
    session[:flash] = { error: 'Current password is incorrect.' }
    redirect '/profile/edit'
  end

  if params[:new_password] != params[:new_password_confirmation]
    session[:flash] = { error: 'New passwords do not match.' }
    redirect '/profile/edit'
  end

  if params[:new_password].length < 6
    session[:flash] = { error: 'New password must be at least 6 characters.' }
    redirect '/profile/edit'
  end

  current_user.password = params[:new_password]
  if current_user.save
    session[:flash] = { success: 'Password changed successfully!' }
    redirect '/profile'
  else
    session[:flash] = { error: 'Failed to change password.' }
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

if __FILE__ == $0
  puts "Starting Auth App (Complete)..."
  puts "Visit http://localhost:#{settings.port}"
  Sinatra::Application.run!
end
