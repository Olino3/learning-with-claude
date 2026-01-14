#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 9: Error Handling & Polish
# Complete Blog API with standardized error responses

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'
require 'jwt'

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

  unless ActiveRecord::Base.connection.table_exists? 'comments'
    create_table :comments do |t|
      t.text :content, null: false
      t.references :post, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.table_exists? 'tags'
    create_table :tags do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end
  end

  unless ActiveRecord::Base.connection.table_exists? 'post_tags'
    create_table :post_tags, id: false do |t|
      t.references :post, foreign_key: true
      t.references :tag, foreign_key: true
    end
    add_index :post_tags, [:post_id, :tag_id], unique: true
  end
end

# Models
class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  attr_accessor :password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { password_digest.blank? }

  before_save :hash_password, if: -> { password.present? }

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def as_json(options = {})
    super(options.merge(except: [:password_digest]))
  end

  private

  def hash_password
    self.password_digest = BCrypt::Password.create(password)
  end
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :content, presence: true
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { minimum: 1, maximum: 500 }
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts

  validates :name, presence: true, uniqueness: true

  before_save { self.name = name.downcase.strip }
end

# Seed data
if User.count == 0
  user1 = User.create!(email: 'alice@example.com', password: 'password123', name: 'Alice Smith')
  user2 = User.create!(email: 'bob@example.com', password: 'password123', name: 'Bob Johnson')

  ruby_tag = Tag.create!(name: 'ruby')
  sinatra_tag = Tag.create!(name: 'sinatra')
  api_tag = Tag.create!(name: 'api')
  web_tag = Tag.create!(name: 'web')

  post1 = user1.posts.create!(
    title: 'Getting Started with Sinatra',
    content: 'Sinatra is a lightweight web framework for Ruby.',
    published: true
  )
  post1.tags << [ruby_tag, sinatra_tag, web_tag]

  post2 = user2.posts.create!(
    title: 'Building RESTful APIs',
    content: 'REST is an architectural style for building APIs.',
    published: true
  )
  post2.tags << [web_tag, api_tag]

  post1.comments.create!(content: 'Great introduction!', user: user2)
  post2.comments.create!(content: 'Very helpful for API design.', user: user1)

  puts "Created sample data"
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

  def paginate(collection, page = 1, per_page = 10)
    page = [page.to_i, 1].max
    per_page = [[per_page.to_i, 1].max, 100].min
    total = collection.count
    {
      data: collection.limit(per_page).offset((page - 1) * per_page),
      meta: { page: page, per_page: per_page, total: total, total_pages: (total.to_f / per_page).ceil }
    }
  end

  def json_response(data, status_code = 200)
    halt status_code, data.to_json
  end

  def json_error(message, status_code = 400)
    json_response({ error: message }, status_code)
  end
end

# CORS support
before do
  content_type :json
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
end

options '*' do
  200
end

# Root endpoint
get '/' do
  {
    name: 'Blog API',
    version: '1.0',
    endpoints: {
      auth: '/api/v1/auth/*',
      posts: '/api/v1/posts',
      comments: '/api/v1/comments',
      tags: '/api/v1/tags',
      users: '/api/v1/users'
    }
  }.to_json
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
  posts = Post.includes(:user, :tags).order(created_at: :desc)
  posts = posts.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag]
  posts = posts.where(user_id: params[:user_id]) if params[:user_id]
  if params[:search]
    posts = posts.where('title LIKE ? OR content LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
  end
  posts = posts.where(published: true) unless current_user

  result = paginate(posts, params[:page], params[:per_page])
  {
    posts: result[:data].as_json(include: { user: { only: [:id, :name] }, tags: { only: [:id, :name] } }),
    meta: result[:meta]
  }.to_json
end

get '/api/v1/posts/:id' do
  post = Post.includes(:user, :tags, :comments).find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  if !post.published && (!current_user || current_user.id != post.user_id)
    halt 403, { error: 'Access denied' }.to_json
  end
  post.to_json(include: { user: { only: [:id, :name] }, tags: { only: [:id, :name] } })
end

post '/api/v1/posts' do
  authenticate!
  params = json_params
  post = current_user.posts.new(title: params['title'], content: params['content'], published: params['published'] || false)

  if post.save
    if params['tags']&.is_a?(Array)
      params['tags'].each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name.downcase.strip)
        post.tags << tag unless post.tags.include?(tag)
      end
    end
    status 201
    post.to_json(include: { tags: { only: [:id, :name] } })
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

  p = json_params
  post.update(
    title: p['title'] || post.title,
    content: p['content'] || post.content,
    published: p.key?('published') ? p['published'] : post.published
  )

  if p['tags']&.is_a?(Array)
    post.tags.clear
    p['tags'].each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.downcase.strip)
      post.tags << tag
    end
  end

  post.to_json(include: { tags: { only: [:id, :name] } })
end

delete '/api/v1/posts/:id' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  halt 403, { error: 'Access denied' }.to_json unless post.user_id == current_user.id
  post.destroy
  { message: 'Post deleted successfully' }.to_json
end

# Post comments routes
get '/api/v1/posts/:id/comments' do
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  post.comments.includes(:user).order(created_at: :desc).to_json(include: { user: { only: [:id, :name] } })
end

post '/api/v1/posts/:id/comments' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post

  p = json_params
  comment = post.comments.new(content: p['content'], user: current_user)

  if comment.save
    status 201
    comment.to_json(include: { user: { only: [:id, :name] } })
  else
    status 422
    { errors: comment.errors.full_messages }.to_json
  end
end

# Comment routes
put '/api/v1/comments/:id' do
  authenticate!
  comment = Comment.find_by(id: params[:id])
  halt 404, { error: 'Comment not found' }.to_json unless comment
  halt 403, { error: 'Access denied' }.to_json unless comment.user_id == current_user.id

  p = json_params
  if comment.update(content: p['content'])
    comment.to_json(include: { user: { only: [:id, :name] } })
  else
    status 422
    { errors: comment.errors.full_messages }.to_json
  end
end

delete '/api/v1/comments/:id' do
  authenticate!
  comment = Comment.find_by(id: params[:id])
  halt 404, { error: 'Comment not found' }.to_json unless comment
  can_delete = comment.user_id == current_user.id || comment.post.user_id == current_user.id
  halt 403, { error: 'Access denied' }.to_json unless can_delete
  comment.destroy
  { message: 'Comment deleted successfully' }.to_json
end

# Tag routes
get '/api/v1/tags' do
  Tag.all.order(:name).to_json
end

get '/api/v1/tags/:id/posts' do
  tag = Tag.find_by(id: params[:id])
  halt 404, { error: 'Tag not found' }.to_json unless tag
  posts = tag.posts.includes(:user, :tags).where(published: true).order(created_at: :desc)

  result = paginate(posts, params[:page], params[:per_page])
  {
    tag: tag,
    posts: result[:data].as_json(include: { user: { only: [:id, :name] }, tags: { only: [:id, :name] } }),
    meta: result[:meta]
  }.to_json
end

# User routes
get '/api/v1/users/:id' do
  user = User.find_by(id: params[:id])
  halt 404, { error: 'User not found' }.to_json unless user
  {
    user: user,
    stats: {
      posts_count: user.posts.count,
      comments_count: user.comments.count
    }
  }.to_json
end

get '/api/v1/users/:id/posts' do
  user = User.find_by(id: params[:id])
  halt 404, { error: 'User not found' }.to_json unless user
  posts = user.posts.includes(:tags).where(published: true).order(created_at: :desc)

  result = paginate(posts, params[:page], params[:per_page])
  {
    user: user,
    posts: result[:data].as_json(include: { tags: { only: [:id, :name] } }),
    meta: result[:meta]
  }.to_json
end

# Error handlers
not_found do
  { error: 'Endpoint not found' }.to_json
end

error 500 do
  { error: 'Internal server error' }.to_json
end

if __FILE__ == $0
  puts "Starting Blog API (Complete)..."
  puts "API available at http://localhost:#{settings.port}"
  Sinatra::Application.run!
end
