#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 5: Post Model and CRUD
# Blog posts with full CRUD operations

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'
require 'jwt'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
set :database, { adapter: 'sqlite3', database: 'blog_api.db' }

JWT_SECRET = ENV['JWT_SECRET'] || 'change_this_secret_key_in_production'

# Create tables
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists? 'users'
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :name, null: false
      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.table_exists? 'posts'
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :published, default: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

# Models
class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  attr_accessor :password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
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

class Post < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :user, presence: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }
end

# Seed data
if User.count == 0
  user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User')
  user.posts.create!(title: 'My First Post', content: 'This is the content of my first blog post.', published: true)
  puts "Created sample user and post"
end

# Helpers
helpers do
  def json_params
    JSON.parse(request.body.read)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end

  def generate_token(user)
    JWT.encode({ user_id: user.id, exp: Time.now.to_i + 24 * 3600 }, JWT_SECRET, 'HS256')
  end

  def current_user
    return @current_user if defined?(@current_user)
    auth_header = request.env['HTTP_AUTHORIZATION']
    return nil unless auth_header
    token = auth_header.split(' ').last
    payload = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256').first rescue nil
    @current_user = User.find_by(id: payload&.dig('user_id'))
  end

  def authenticate!
    halt 401, { error: 'Authentication required' }.to_json unless current_user
  end
end

before do
  content_type :json
end

# Auth routes
post '/api/v1/auth/register' do
  params = json_params
  user = User.new(email: params['email'], password: params['password'], name: params['name'])
  if user.save
    status 201
    { token: generate_token(user), user: user }.to_json
  else
    status 422
    { errors: user.errors.full_messages }.to_json
  end
end

post '/api/v1/auth/login' do
  params = json_params
  user = User.find_by(email: params['email'])
  if user&.authenticate(params['password'])
    { token: generate_token(user), user: user }.to_json
  else
    status 401
    { error: 'Invalid email or password' }.to_json
  end
end

get '/api/v1/auth/me' do
  authenticate!
  current_user.to_json
end

# Post routes
get '/api/v1/posts' do
  Post.includes(:user).recent.to_json(include: { user: { only: [:id, :name] } })
end

get '/api/v1/posts/:id' do
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  post.to_json(include: { user: { only: [:id, :name] } })
end

post '/api/v1/posts' do
  authenticate!
  params = json_params
  post = current_user.posts.new(title: params['title'], content: params['content'], published: params['published'] || false)
  if post.save
    status 201
    post.to_json
  else
    status 422
    { errors: post.errors.full_messages }.to_json
  end
end

put '/api/v1/posts/:id' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  halt 403, { error: 'Access denied' }.to_json unless post.user_id == current_user.id

  params = json_params
  if post.update(title: params['title'] || post.title, content: params['content'] || post.content, published: params['published'])
    post.to_json
  else
    status 422
    { errors: post.errors.full_messages }.to_json
  end
end

delete '/api/v1/posts/:id' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  halt 403, { error: 'Access denied' }.to_json unless post.user_id == current_user.id
  post.destroy
  { message: 'Post deleted' }.to_json
end

if __FILE__ == $0
  puts "Starting Blog API with Posts..."
  Sinatra::Application.run!
end
