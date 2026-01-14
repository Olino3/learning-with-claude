#!/usr/bin/env ruby
# frozen_string_literal: true

require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'sequel'
require 'rack/handler/puma'

# Connect to database
DB = Sequel.sqlite('chat.db')

# Message model
class Message < Sequel::Model
  many_to_one :room
end

# Room model
class Room < Sequel::Model
  one_to_many :messages
end

# WebSocket Chat Server
class ChatServer
  def initialize
    @clients = {} # { ws => { username:, room: } }
    @rooms = Hash.new { |h, k| h[k] = [] } # { room_name => [ws, ws, ...] }
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      ws.on :open do |event|
        puts "Client connected: #{ws.object_id}"
      end

      ws.on :message do |event|
        handle_message(ws, event.data)
      end

      ws.on :close do |event|
        handle_disconnect(ws)
        puts "Client disconnected: #{ws.object_id}"
      end

      # Return async Rack response
      ws.rack_response
    else
      [200, { 'Content-Type' => 'text/plain' }, ['WebSocket Server']]
    end
  end

  private

  def handle_message(ws, data)
    message = JSON.parse(data)
    type = message['type']

    case type
    when 'join'
      handle_join(ws, message)
    when 'chat'
      handle_chat(ws, message)
    when 'leave'
      handle_leave(ws, message)
    else
      puts "Unknown message type: #{type}"
    end
  rescue JSON::ParserError => e
    puts "JSON parse error: #{e.message}"
  end

  def handle_join(ws, message)
    username = message['username']
    room_name = message['room']

    # Store client info
    @clients[ws] = {
      username: username,
      room: room_name
    }

    # Add to room
    @rooms[room_name] << ws

    # Broadcast join notification
    broadcast_to_room(room_name, {
      type: 'join',
      username: username,
      timestamp: Time.now.iso8601
    })

    # Send user list to all clients in room
    update_user_list(room_name)

    puts "#{username} joined room: #{room_name}"
  end

  def handle_chat(ws, message)
    username = message['username']
    room_name = message['room']
    content = message['content']

    # Save message to database
    room = Room.find(name: room_name)
    if room
      Message.create(
        room_id: room.id,
        username: username,
        content: content
      )
    end

    # Broadcast message to room
    broadcast_to_room(room_name, {
      type: 'chat',
      username: username,
      content: content,
      timestamp: Time.now.iso8601
    })

    puts "#{username} in #{room_name}: #{content[0..50]}"
  end

  def handle_leave(ws, message)
    username = message['username']
    room_name = message['room']

    # Remove from room
    @rooms[room_name].delete(ws)

    # Broadcast leave notification
    broadcast_to_room(room_name, {
      type: 'leave',
      username: username,
      timestamp: Time.now.iso8601
    })

    # Update user list
    update_user_list(room_name)

    # Clean up client info
    @clients.delete(ws)

    puts "#{username} left room: #{room_name}"
  end

  def handle_disconnect(ws)
    client_info = @clients[ws]
    return unless client_info

    room_name = client_info[:room]
    username = client_info[:username]

    # Remove from room
    @rooms[room_name].delete(ws)

    # Broadcast leave notification
    broadcast_to_room(room_name, {
      type: 'leave',
      username: username,
      timestamp: Time.now.iso8601
    })

    # Update user list
    update_user_list(room_name)

    # Clean up
    @clients.delete(ws)
  end

  def broadcast_to_room(room_name, message)
    json = message.to_json
    @rooms[room_name].each do |client|
      client.send(json) if client.ready_state == Faye::WebSocket::OPEN
    end
  end

  def update_user_list(room_name)
    users = @rooms[room_name].map do |ws|
      @clients[ws][:username]
    end.compact.uniq

    broadcast_to_room(room_name, {
      type: 'users',
      users: users,
      count: users.length
    })
  end
end

# Start WebSocket server using Puma (which is already installed)
puts "🔌 WebSocket server starting on ws://0.0.0.0:9292"
puts "📡 Ready to accept connections"
puts "🛑 Press Ctrl+C to stop"
puts ""

server = ChatServer.new

# Use Puma to run the Rack app
Rack::Handler::Puma.run(
  server,
  Port: 9292,
  Host: '0.0.0.0',
  Verbose: false
)
