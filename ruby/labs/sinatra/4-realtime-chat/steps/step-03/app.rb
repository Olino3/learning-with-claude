#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 3: WebSocket Server Setup
# This is the web app - see chat_server.rb for WebSocket server

require 'sinatra'
require 'sequel'
require 'json'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, 'chat-app-secret-key'

# Configure database
DB = Sequel.sqlite('chat.db')

# Create tables
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

# Models
class Room < Sequel::Model
  one_to_many :messages
end

class Message < Sequel::Model
  many_to_one :room

  def to_hash
    { id: id, username: username, content: content, created_at: created_at.strftime('%H:%M') }
  end
end

# Seed default rooms
if Room.count == 0
  Room.create(name: 'general', description: 'General discussion')
  Room.create(name: 'ruby', description: 'Ruby programming')
  Room.create(name: 'random', description: 'Off-topic chat')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end
end

get '/' do
  erb :index
end

get '/rooms' do
  @rooms = Room.order(:name).all
  erb :rooms
end

get '/room/:name' do
  @room = Room.find(name: params[:name])
  halt 404, 'Room not found' unless @room
  @messages = @room.messages.order(:created_at).limit(50).all
  erb :chat
end

get '/api/rooms/:name/messages' do
  content_type :json
  room = Room.find(name: params[:name])
  halt 404 unless room
  room.messages.order(:created_at).limit(50).all.map(&:to_hash).to_json
end

if __FILE__ == $0
  puts "Starting Chat Web App..."
  puts "Make sure to run: ruby chat_server.rb (in another terminal)"
  Sinatra::Application.run!
end
