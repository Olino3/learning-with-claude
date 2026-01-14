#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 7: Tagging System
# Adding many-to-many relationships with tags

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
  user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User')

  ruby_tag = Tag.create!(name: 'ruby')
  sinatra_tag = Tag.create!(name: 'sinatra')
  api_tag = Tag.create!(name: 'api')

  post = user.posts.create!(title: 'My First Post', content: 'This is the content.', published: true)
  post.tags << [ruby_tag, sinatra_tag]

  post.comments.create!(content: 'Great post!', user: user)
  puts "Created sample data with tags"
end

# Helpers
helpers do
  def json_params
    JSON.parse(request.body.read) rescue halt(400, { error: 'Invalid JSON' }.to_json)
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

before { content_type :json }

# Auth routes
post('/api/v1/auth/register') { params = json_params; user = User.new(email: params['email'], password: params['password'], name: params['name']); user.save ? [201, { token: generate_token(user), user: user }.to_json] : [422, { errors: user.errors.full_messages }.to_json] }
post('/api/v1/auth/login') { params = json_params; user = User.find_by(email: params['email']); user&.authenticate(params['password']) ? { token: generate_token(user), user: user }.to_json : [401, { error: 'Invalid credentials' }.to_json] }
get('/api/v1/auth/me') { authenticate!; current_user.to_json }

# Post routes
get '/api/v1/posts' do
  posts = Post.includes(:user, :tags).order(created_at: :desc)
  posts = posts.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag]
  posts.to_json(include: { user: { only: [:id, :name] }, tags: { only: [:id, :name] } })
end

get '/api/v1/posts/:id' do
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  post.to_json(include: { user: { only: [:id, :name] }, tags: { only: [:id, :name] } })
end

post '/api/v1/posts' do
  authenticate!
  p = json_params
  post = current_user.posts.new(title: p['title'], content: p['content'], published: p['published'])

  if post.save
    if p['tags']&.is_a?(Array)
      p['tags'].each do |tag_name|
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
  post.update(p.slice('title', 'content', 'published'))

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
  { message: 'Deleted' }.to_json
end

# Comment routes
get('/api/v1/posts/:id/comments') { post = Post.find_by(id: params[:id]); halt(404, { error: 'Post not found' }.to_json) unless post; post.comments.includes(:user).order(created_at: :desc).to_json(include: { user: { only: [:id, :name] } }) }
post('/api/v1/posts/:id/comments') { authenticate!; post = Post.find_by(id: params[:id]); halt(404, { error: 'Post not found' }.to_json) unless post; p = json_params; comment = post.comments.new(content: p['content'], user: current_user); comment.save ? [201, comment.to_json(include: { user: { only: [:id, :name] } })] : [422, { errors: comment.errors.full_messages }.to_json] }
put('/api/v1/comments/:id') { authenticate!; comment = Comment.find_by(id: params[:id]); halt(404, { error: 'Comment not found' }.to_json) unless comment; halt(403, { error: 'Access denied' }.to_json) unless comment.user_id == current_user.id; p = json_params; comment.update(content: p['content']); comment.to_json }
delete('/api/v1/comments/:id') { authenticate!; comment = Comment.find_by(id: params[:id]); halt(404, { error: 'Comment not found' }.to_json) unless comment; halt(403, { error: 'Access denied' }.to_json) unless comment.user_id == current_user.id; comment.destroy; { message: 'Comment deleted' }.to_json }

# Tag routes
get '/api/v1/tags' do
  Tag.all.order(:name).to_json
end

get '/api/v1/tags/:id/posts' do
  tag = Tag.find_by(id: params[:id])
  halt 404, { error: 'Tag not found' }.to_json unless tag
  posts = tag.posts.includes(:user, :tags).where(published: true).order(created_at: :desc)
  { tag: tag, posts: posts.as_json(include: { user: { only: [:id, :name] }, tags: { only: [:id, :name] } }) }.to_json
end

if __FILE__ == $0
  puts "Starting Blog API with Tags..."
  Sinatra::Application.run!
end
