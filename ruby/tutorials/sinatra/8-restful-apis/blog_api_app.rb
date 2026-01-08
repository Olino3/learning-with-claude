require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/namespace'
require 'json'
require 'securerandom'

# Simple in-memory storage
POSTS = []
COMMENTS = {}

# Helpers
helpers do
  def json_params
    request.body.rewind
    JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end

  def find_post(id)
    post = POSTS.find { |p| p[:id] == id }
    halt 404, { error: 'Post not found', id: id }.to_json unless post
    post
  end

  def find_comment(post_id, comment_id)
    comments = COMMENTS[post_id] || []
    comment = comments.find { |c| c[:id] == comment_id }
    halt 404, { error: 'Comment not found' }.to_json unless comment
    comment
  end

  def paginate(collection)
    page = [params[:page].to_i, 1].max
    per_page = [[params[:per_page].to_i, 50].min, 10].max

    offset = (page - 1) * per_page
    items = collection[offset, per_page] || []

    {
      data: items,
      meta: {
        page: page,
        per_page: per_page,
        total: collection.length,
        total_pages: (collection.length.to_f / per_page).ceil
      }
    }
  end
end

# CORS
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers' => 'Content-Type'
  content_type :json
end

options '*' do
  200
end

# Root
get '/' do
  {
    name: 'Blog API',
    version: '1.0.0',
    endpoints: {
      posts: '/api/posts',
      post: '/api/posts/:id',
      comments: '/api/posts/:id/comments'
    }
  }.to_json
end

# API namespace
namespace '/api' do
  # List posts
  get '/posts' do
    posts = POSTS.dup

    # Search
    if params[:search]
      posts = posts.select { |p| p[:title].include?(params[:search]) || p[:body].include?(params[:search]) }
    end

    # Sort
    if params[:sort] == 'date'
      posts = posts.sort_by { |p| p[:created_at] }
      posts.reverse! if params[:order] == 'desc'
    end

    paginate(posts).to_json
  end

  # Get single post
  get '/posts/:id' do
    post = find_post(params[:id])
    comments = COMMENTS[post[:id]] || []

    {
      **post,
      comments_count: comments.length
    }.to_json
  end

  # Create post
  post '/posts' do
    data = json_params

    errors = []
    errors << 'Title is required' if data[:title].to_s.empty?
    errors << 'Body is required' if data[:body].to_s.empty?
    errors << 'Author is required' if data[:author].to_s.empty?

    if errors.any?
      halt 422, { error: 'Validation failed', details: errors }.to_json
    end

    post = {
      id: SecureRandom.uuid,
      title: data[:title],
      body: data[:body],
      author: data[:author],
      created_at: Time.now.to_i,
      updated_at: Time.now.to_i
    }

    POSTS << post
    status 201
    post.to_json
  end

  # Update post
  put '/posts/:id' do
    post = find_post(params[:id])
    data = json_params

    post[:title] = data[:title] if data[:title]
    post[:body] = data[:body] if data[:body]
    post[:updated_at] = Time.now.to_i

    post.to_json
  end

  # Delete post
  delete '/posts/:id' do
    post = find_post(params[:id])
    POSTS.delete(post)
    COMMENTS.delete(post[:id])

    status 204
  end

  # Get post comments
  get '/posts/:id/comments' do
    post = find_post(params[:id])
    comments = COMMENTS[post[:id]] || []

    { post_id: post[:id], comments: comments, count: comments.length }.to_json
  end

  # Create comment
  post '/posts/:id/comments' do
    post = find_post(params[:id])
    data = json_params

    errors = []
    errors << 'Body is required' if data[:body].to_s.empty?
    errors << 'Author is required' if data[:author].to_s.empty?

    if errors.any?
      halt 422, { error: 'Validation failed', details: errors }.to_json
    end

    COMMENTS[post[:id]] ||= []

    comment = {
      id: SecureRandom.uuid,
      body: data[:body],
      author: data[:author],
      created_at: Time.now.to_i
    }

    COMMENTS[post[:id]] << comment
    status 201
    comment.to_json
  end

  # Update comment
  put '/posts/:post_id/comments/:comment_id' do
    post = find_post(params[:post_id])
    comment = find_comment(post[:id], params[:comment_id])
    data = json_params

    comment[:body] = data[:body] if data[:body]
    comment.to_json
  end

  # Delete comment
  delete '/posts/:post_id/comments/:comment_id' do
    post = find_post(params[:post_id])
    comment = find_comment(post[:id], params[:comment_id])

    COMMENTS[post[:id]].delete(comment)
    status 204
  end
end

# Error handlers
not_found do
  { error: 'Endpoint not found', path: request.path }.to_json
end

error do
  { error: 'Internal server error' }.to_json
end
