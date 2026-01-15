#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 4: JWT Authentication
# Token-based authentication with JWT

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'
require 'jwt'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
set :database, { adapter: 'sqlite3', database: 'blog_api.db' }

# JWT Configuration
JWT_SECRET = ENV['JWT_SECRET'] || 'change_this_secret_key_in_production'

# Create tables if they don't exist
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists? 'users'
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end

# User Model
class User < ActiveRecord::Base
  attr_accessor :password

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  before_save :hash_password, if: :password_present?

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def as_json(options = {})
    super(options.merge(except: [:password_digest]))
  end

  private

  def password_required?
    password_digest.blank?
  end

  def password_present?
    password.present?
  end

  def hash_password
    self.password_digest = BCrypt::Password.create(password)
  end
end

# Seed sample user
if User.count == 0
  User.create!(email: 'test@example.com', password: 'password123', name: 'Test User')
  puts "Created sample user: test@example.com / password123"
end

# Helpers
helpers do
  def json_params
    JSON.parse(request.body.read)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end

  def generate_token(user)
    payload = { user_id: user.id, exp: Time.now.to_i + 24 * 3600 }
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256').first
  rescue JWT::DecodeError
    nil
  end

  def current_user
    return @current_user if defined?(@current_user)

    auth_header = request.env['HTTP_AUTHORIZATION']
    return nil unless auth_header

    token = auth_header.split(' ').last
    payload = decode_token(token)
    return nil unless payload

    @current_user = User.find_by(id: payload['user_id'])
  end

  def authenticate!
    halt 401, { error: 'Authentication required' }.to_json unless current_user
  end
end

# Set content type to JSON for all responses
before do
  content_type :json
end

# API root
get '/' do
  {
    name: 'Blog API',
    version: '1.0',
    status: 'running'
  }.to_json
end

# Register
post '/api/v1/auth/register' do
  params = json_params
  user = User.new(email: params['email'], password: params['password'], name: params['name'])

  if user.save
    token = generate_token(user)
    status 201
    { token: token, user: user }.to_json
  else
    status 422
    { errors: user.errors.full_messages }.to_json
  end
end

# Login
post '/api/v1/auth/login' do
  params = json_params
  user = User.find_by(email: params['email'])

  if user&.authenticate(params['password'])
    token = generate_token(user)
    { token: token, user: user }.to_json
  else
    status 401
    { error: 'Invalid email or password' }.to_json
  end
end

# Get current user (protected)
get '/api/v1/auth/me' do
  authenticate!
  current_user.to_json
end

if __FILE__ == $0
  puts "Starting Blog API with JWT authentication..."
  Sinatra::Application.run!
end
