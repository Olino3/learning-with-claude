#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'json'
require_relative 'lib/models/room'
require_relative 'lib/models/message'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'chat-app-secret-key'

# Configure database
DB = Sequel.sqlite('chat.db')

# Create tables if they don't exist
DB.create_table? :rooms do
  primary_key :id
  String :name, null: false, unique: true
  String :description
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
end

DB.create_table? :messages do
  primary_key :id
  foreign_key :room_id, :rooms, null: false
  String :username, null: false
  String :content, null: false, text: true
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

  index :room_id
  index :created_at
end

# Initialize models
class Room < Sequel::Model
  one_to_many :messages

  def to_hash
    {
      id: id,
      name: name,
      description: description,
      created_at: created_at.iso8601,
      message_count: messages.count
    }
  end
end

class Message < Sequel::Model
  many_to_one :room

  def to_hash
    {
      id: id,
      username: username,
      content: content,
      created_at: created_at.iso8601
    }
  end
end

# Seed default rooms if none exist
if Room.count == 0
  Room.create(
    name: 'general',
    description: 'General discussion for everyone'
  )
  Room.create(
    name: 'ruby',
    description: 'Talk about Ruby programming'
  )
  Room.create(
    name: 'sinatra',
    description: 'Discuss Sinatra web framework'
  )
  Room.create(
    name: 'random',
    description: 'Random off-topic chat'
  )

  puts "✅ Created default chat rooms"
end

# Helpers
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def current_username
    session[:username]
  end

  def logged_in?
    !current_username.nil?
  end

  def require_username
    unless logged_in?
      redirect '/?login=required'
    end
  end

  def format_time(time)
    time.strftime('%I:%M %p')
  end

  def format_date(time)
    time.strftime('%b %d, %Y at %I:%M %p')
  end
end

# Routes

# Home page - room list
get '/' do
  if params[:login] == 'required'
    @error = 'Please enter your username to join the chat'
  end

  @rooms = Room.order(:name).all
  erb :index
end

# Set username
post '/username' do
  username = params[:username]&.strip

  if username.nil? || username.empty?
    redirect '/?error=empty'
  elsif username.length < 2
    redirect '/?error=short'
  elsif username.length > 20
    redirect '/?error=long'
  else
    session[:username] = username
    redirect params[:redirect_to] || '/rooms'
  end
end

# Rooms list
get '/rooms' do
  require_username
  @rooms = Room.order(:name).all
  erb :rooms
end

# Chat room
get '/rooms/:id' do
  require_username
  @room = Room[params[:id]]
  halt 404, 'Room not found' unless @room

  # Load recent messages (last 50)
  @messages = @room.messages.order(:created_at).limit(50).all

  erb :chat
end

# API: Get room messages (JSON)
get '/api/rooms/:id/messages' do
  content_type :json

  room = Room[params[:id]]
  halt 404, json({ error: 'Room not found' }) unless room

  # Get messages after a certain ID (for polling)
  messages = room.messages.order(:created_at)
  if params[:after]
    messages = messages.where(Sequel.lit('id > ?', params[:after].to_i))
  else
    messages = messages.limit(50)
  end

  messages.all.map(&:to_hash).to_json
end

# API: Get all rooms (JSON)
get '/api/rooms' do
  content_type :json
  Room.order(:name).all.map(&:to_hash).to_json
end

# Create new room (JSON)
post '/api/rooms' do
  content_type :json

  data = JSON.parse(request.body.read)
  name = data['name']&.strip&.downcase
  description = data['description']&.strip

  if name.nil? || name.empty?
    halt 400, json({ error: 'Room name is required' })
  end

  if Room.find(name: name)
    halt 400, json({ error: 'Room already exists' })
  end

  room = Room.create(name: name, description: description)
  room.to_hash.to_json
rescue JSON::ParserError
  halt 400, json({ error: 'Invalid JSON' })
end

# Logout
get '/logout' do
  session.clear
  redirect '/'
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

# Start the server
if __FILE__ == $0
  puts "🚀 Chat Web App starting..."
  puts "🌐 Visit http://localhost:#{settings.port}"
  puts "💬 Make sure WebSocket server is running on port 9292"
  puts "   Run: ruby chat_server.rb"
  puts "🛑 Press Ctrl+C to stop"
  Sinatra::Application.run!
end
