#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative 'lib/auth'
require_relative 'lib/serializers'
require_relative 'lib/models/user'
require_relative 'lib/models/post'
require_relative 'lib/models/comment'
require_relative 'lib/models/tag'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
set :database, { adapter: 'sqlite3', database: 'blog_api.db' }

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

# Seed sample data
if User.count == 0
  user1 = User.create!(email: 'alice@example.com', password: 'password123', name: 'Alice Smith')
  user2 = User.create!(email: 'bob@example.com', password: 'password123', name: 'Bob Johnson')

  ruby_tag = Tag.create!(name: 'ruby')
  sinatra_tag = Tag.create!(name: 'sinatra')
  web_tag = Tag.create!(name: 'web')
  api_tag = Tag.create!(name: 'api')

  post1 = user1.posts.create!(
    title: 'Getting Started with Sinatra',
    content: 'Sinatra is a lightweight web framework for Ruby. It provides a simple DSL for building web applications without the overhead of larger frameworks like Rails.',
    published: true
  )
  post1.tags << [ruby_tag, sinatra_tag, web_tag]

  post2 = user2.posts.create!(
    title: 'Building RESTful APIs',
    content: 'REST is an architectural style for building APIs. It uses standard HTTP methods (GET, POST, PUT, DELETE) and returns data in JSON format.',
    published: true
  )
  post2.tags << [web_tag, api_tag]

  post1.comments.create!(content: 'Great introduction to Sinatra!', user: user2)
  post2.comments.create!(content: 'Very helpful for API design.', user: user1)

  puts "✅ Database seeded with sample data"
end

# Helpers
helpers do
  include AuthHelpers
  include Serializers

  def json_params
    JSON.parse(request.body.read)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end

  def json(data, status_code = 200)
    content_type :json
    halt status_code, data.to_json
  end

  def json_error(message, status_code = 400)
    json({ error: message }, status_code)
  end

  def authenticate!
    halt 401, { error: 'Authentication required' }.to_json unless current_user
  end

  def paginate(collection, page = 1, per_page = 10)
    page = [page.to_i, 1].max
    per_page = [[per_page.to_i, 1].max, 100].min
    {
      data: collection.limit(per_page).offset((page - 1) * per_page),
      meta: {
        page: page,
        per_page: per_page,
        total: collection.count,
        total_pages: (collection.count.to_f / per_page).ceil
      }
    }
  end
end

# CORS
before do
  content_type :json
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
end

options '*' do
  200
end

# Root
get '/' do
  json({
    name: 'Blog API',
    version: '1.0',
    endpoints: {
      auth: '/api/v1/auth/*',
      posts: '/api/v1/posts',
      comments: '/api/v1/comments',
      tags: '/api/v1/tags',
      users: '/api/v1/users'
    }
  })
end

# ============================================
# Authentication Routes
# ============================================

post '/api/v1/auth/register' do
  params = json_params
  user = User.new(email: params['email'], password: params['password'], name: params['name'])

  if user.save
    token = generate_token(user)
    json({ token: token, user: serialize_user(user) }, 201)
  else
    json_error(user.errors.full_messages.join(', '), 422)
  end
end

post '/api/v1/auth/login' do
  params = json_params
  user = User.find_by(email: params['email'])

  if user&.authenticate(params['password'])
    token = generate_token(user)
    json({ token: token, user: serialize_user(user) })
  else
    json_error('Invalid email or password', 401)
  end
end

get '/api/v1/auth/me' do
  authenticate!
  json({ user: serialize_user(current_user) })
end

# ============================================
# Posts Routes
# ============================================

get '/api/v1/posts' do
  posts = Post.includes(:user, :tags).order(created_at: :desc)
  posts = posts.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag]
  posts = posts.where(user_id: params[:user_id]) if params[:user_id]
  if params[:search]
    posts = posts.where('title LIKE ? OR content LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
  end
  posts = posts.where(published: true) unless current_user

  result = paginate(posts, params[:page], params[:per_page])
  json({ posts: result[:data].map { |p| serialize_post(p) }, meta: result[:meta] })
end

get '/api/v1/posts/:id' do
  post = Post.includes(:user, :tags, :comments).find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  if !post.published && (!current_user || current_user.id != post.user_id)
    halt 403, { error: 'Access denied' }.to_json
  end
  json({ post: serialize_post(post, include_comments: true) })
end

post '/api/v1/posts' do
  authenticate!
  params = json_params
  post = current_user.posts.new(
    title: params['title'],
    content: params['content'],
    published: params['published'] || false
  )

  if post.save
    if params['tags']&.is_a?(Array)
      params['tags'].each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name.downcase)
        post.tags << tag unless post.tags.include?(tag)
      end
    end
    json({ post: serialize_post(post) }, 201)
  else
    json_error(post.errors.full_messages.join(', '), 422)
  end
end

put '/api/v1/posts/:id' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  halt 403, { error: 'Access denied' }.to_json unless post.user_id == current_user.id

  params = json_params
  if post.update(
    title: params['title'] || post.title,
    content: params['content'] || post.content,
    published: params.key?('published') ? params['published'] : post.published
  )
    if params['tags']&.is_a?(Array)
      post.tags.clear
      params['tags'].each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name.downcase)
        post.tags << tag
      end
    end
    json({ post: serialize_post(post) })
  else
    json_error(post.errors.full_messages.join(', '), 422)
  end
end

delete '/api/v1/posts/:id' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  halt 403, { error: 'Access denied' }.to_json unless post.user_id == current_user.id
  post.destroy
  json({ message: 'Post deleted successfully' })
end

get '/api/v1/posts/:id/comments' do
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post
  comments = post.comments.includes(:user).order(created_at: :desc)
  json({ comments: comments.map { |c| serialize_comment(c) } })
end

post '/api/v1/posts/:id/comments' do
  authenticate!
  post = Post.find_by(id: params[:id])
  halt 404, { error: 'Post not found' }.to_json unless post

  params = json_params
  comment = post.comments.new(content: params['content'], user: current_user)

  if comment.save
    json({ comment: serialize_comment(comment) }, 201)
  else
    json_error(comment.errors.full_messages.join(', '), 422)
  end
end

# ============================================
# Comments Routes
# ============================================

put '/api/v1/comments/:id' do
  authenticate!
  comment = Comment.find_by(id: params[:id])
  halt 404, { error: 'Comment not found' }.to_json unless comment
  halt 403, { error: 'Access denied' }.to_json unless comment.user_id == current_user.id

  params = json_params
  if comment.update(content: params['content'])
    json({ comment: serialize_comment(comment) })
  else
    json_error(comment.errors.full_messages.join(', '), 422)
  end
end

delete '/api/v1/comments/:id' do
  authenticate!
  comment = Comment.find_by(id: params[:id])
  halt 404, { error: 'Comment not found' }.to_json unless comment
  can_delete = comment.user_id == current_user.id || comment.post.user_id == current_user.id
  halt 403, { error: 'Access denied' }.to_json unless can_delete
  comment.destroy
  json({ message: 'Comment deleted successfully' })
end

# ============================================
# Tags Routes
# ============================================

get '/api/v1/tags' do
  tags = Tag.all.order(:name)
  json({ tags: tags.map { |t| serialize_tag(t) } })
end

get '/api/v1/tags/:id/posts' do
  tag = Tag.find_by(id: params[:id])
  halt 404, { error: 'Tag not found' }.to_json unless tag
  posts = tag.posts.includes(:user, :tags).where(published: true).order(created_at: :desc)
  result = paginate(posts, params[:page], params[:per_page])
  json({ tag: serialize_tag(tag), posts: result[:data].map { |p| serialize_post(p) }, meta: result[:meta] })
end

# ============================================
# Users Routes
# ============================================

get '/api/v1/users/:id' do
  user = User.find_by(id: params[:id])
  halt 404, { error: 'User not found' }.to_json unless user
  json({ user: serialize_user(user, include_stats: true) })
end

get '/api/v1/users/:id/posts' do
  user = User.find_by(id: params[:id])
  halt 404, { error: 'User not found' }.to_json unless user
  posts = user.posts.includes(:user, :tags).where(published: true).order(created_at: :desc)
  result = paginate(posts, params[:page], params[:per_page])
  json({ user: serialize_user(user), posts: result[:data].map { |p| serialize_post(p) }, meta: result[:meta] })
end

# Error handlers
not_found do
  { error: 'Endpoint not found' }.to_json
end

error 500 do
  { error: 'Internal server error' }.to_json
end

if __FILE__ == $0
  puts "🚀 Blog API starting..."
  puts "📝 API available at http://localhost:#{settings.port}"
  Sinatra::Application.run!
end
