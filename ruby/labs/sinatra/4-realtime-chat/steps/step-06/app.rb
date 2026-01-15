#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 6: Multiple Rooms
# Room switching and dynamic room management

require 'sinatra'
require 'sequel'
require 'json'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, 'chat-app-secret-key'

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
end

class Room < Sequel::Model
  one_to_many :messages
  def to_hash
    { id: id, name: name, description: description, message_count: messages.count }
  end
end

class Message < Sequel::Model
  many_to_one :room
  def to_hash
    { id: id, username: username, content: content, created_at: created_at.strftime('%H:%M') }
  end
end

if Room.count == 0
  Room.create(name: 'general', description: 'General discussion')
  Room.create(name: 'ruby', description: 'Ruby programming')
  Room.create(name: 'sinatra', description: 'Sinatra framework')
  Room.create(name: 'random', description: 'Off-topic chat')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end

  def current_username
    session[:username]
  end

  def logged_in?
    !current_username.nil?
  end
end

get '/' do
  @rooms = Room.order(:name).all
  erb :index
end

post '/username' do
  username = params[:username]&.strip
  if username && username.length >= 2
    session[:username] = username
    redirect '/rooms'
  else
    redirect '/'
  end
end

get '/rooms' do
  redirect '/' unless logged_in?
  @rooms = Room.order(:name).all
  erb :rooms
end

get '/room/:name' do
  redirect '/' unless logged_in?
  @room = Room.find(name: params[:name])
  halt 404, 'Room not found' unless @room
  @messages = @room.messages.order(:created_at).limit(50).all
  erb :chat
end

get '/api/rooms' do
  content_type :json
  Room.order(:name).all.map(&:to_hash).to_json
end

get '/api/rooms/:name/messages' do
  content_type :json
  room = Room.find(name: params[:name])
  halt 404 unless room
  room.messages.order(:created_at).limit(50).all.map(&:to_hash).to_json
end

post '/api/rooms' do
  content_type :json
  data = JSON.parse(request.body.read)
  name = data['name']&.strip&.downcase
  halt 400, { error: 'Name required' }.to_json unless name
  halt 400, { error: 'Room exists' }.to_json if Room.find(name: name)
  room = Room.create(name: name, description: data['description'])
  room.to_hash.to_json
end

get '/logout' do
  session.clear
  redirect '/'
end

if __FILE__ == $0
  puts "Starting Chat App..."
  Sinatra::Application.run!
end
