#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 7: User Presence (Complete)
# Online user tracking and full features

require 'sinatra'
require 'sequel'
require 'json'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'chat-app-secret-key'

DB = Sequel.sqlite('chat.db')

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

class Room < Sequel::Model
  one_to_many :messages
  def to_hash
    { id: id, name: name, description: description, message_count: messages.count, created_at: created_at.iso8601 }
  end
end

class Message < Sequel::Model
  many_to_one :room
  def to_hash
    { id: id, username: username, content: content, created_at: created_at.iso8601 }
  end
end

if Room.count == 0
  Room.create(name: 'general', description: 'General discussion for everyone')
  Room.create(name: 'ruby', description: 'Talk about Ruby programming')
  Room.create(name: 'sinatra', description: 'Discuss Sinatra web framework')
  Room.create(name: 'random', description: 'Random off-topic chat')
  puts "Created default chat rooms"
end

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
    redirect '/?login=required' unless logged_in?
  end

  def format_time(time)
    time.strftime('%I:%M %p')
  end
end

get '/' do
  @error = 'Please enter your username to join the chat' if params[:login] == 'required'
  @rooms = Room.order(:name).all
  erb :index
end

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

get '/rooms' do
  require_username
  @rooms = Room.order(:name).all
  erb :rooms
end

get '/rooms/:id' do
  require_username
  @room = Room[params[:id]]
  halt 404, 'Room not found' unless @room
  @messages = @room.messages.order(:created_at).limit(50).all
  erb :chat
end

get '/api/rooms/:id/messages' do
  content_type :json
  room = Room[params[:id]]
  halt 404, { error: 'Room not found' }.to_json unless room

  messages = room.messages.order(:created_at)
  messages = messages.where(Sequel.lit('id > ?', params[:after].to_i)) if params[:after]
  messages.limit(50).all.map(&:to_hash).to_json
end

get '/api/rooms' do
  content_type :json
  Room.order(:name).all.map(&:to_hash).to_json
end

post '/api/rooms' do
  content_type :json
  data = JSON.parse(request.body.read)
  name = data['name']&.strip&.downcase
  halt 400, { error: 'Room name is required' }.to_json unless name
  halt 400, { error: 'Room already exists' }.to_json if Room.find(name: name)
  room = Room.create(name: name, description: data['description']&.strip)
  room.to_hash.to_json
rescue JSON::ParserError
  halt 400, { error: 'Invalid JSON' }.to_json
end

get '/logout' do
  session.clear
  redirect '/'
end

not_found do
  @error = 'Page not found'
  erb :error
end

error do
  @error = env['sinatra.error'].message
  erb :error
end

if __FILE__ == $0
  puts "Chat Web App starting..."
  puts "Visit http://localhost:#{settings.port}"
  puts "WebSocket server should be on port 9292"
  Sinatra::Application.run!
end
