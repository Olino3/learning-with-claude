#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 7: Remember Me
# Persistent sessions with remember token

require 'sinatra'
require 'sequel'
require 'bcrypt'
require 'securerandom'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'auth-app-secret-key-change-in-production'
set :sessions, expire_after: 2592000 # 30 days

# Configure database
DB = Sequel.sqlite('auth_app.db')

# Create users table with remember_token
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

# Add remember_token column if it doesn't exist
begin
  DB.alter_table :users do
    add_column :remember_token, String unless DB[:users].columns.include?(:remember_token)
    add_column :last_login_at, DateTime unless DB[:users].columns.include?(:last_login_at)
  end
rescue Sequel::Error
  # Column might already exist
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
        expires: Time.now + (90 * 24 * 60 * 60), # 90 days
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
    session[:flash] = { success: "Welcome, #{@user.name}!" }
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
    session[:flash] = { error: 'Invalid email or password' }
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

if __FILE__ == $0
  puts "Starting Auth App with Remember Me..."
  Sinatra::Application.run!
end
