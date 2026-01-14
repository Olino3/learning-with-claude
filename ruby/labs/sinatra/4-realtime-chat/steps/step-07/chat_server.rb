#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 7: Complete WebSocket Server with User Presence

require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'sequel'

DB = Sequel.sqlite('chat.db')

class Message < Sequel::Model
  many_to_one :room
end

class Room < Sequel::Model
  one_to_many :messages
end

class ChatServer
  def initialize
    @clients = {}
    @rooms = Hash.new { |h, k| h[k] = [] }
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

    @clients[ws] = { username: username, room: room_name }
    @rooms[room_name] << ws

    broadcast_to_room(room_name, {
      type: 'join',
      username: username,
      timestamp: Time.now.iso8601
    })

    update_user_list(room_name)
    puts "#{username} joined room: #{room_name}"
  end

  def handle_chat(ws, message)
    username = message['username']
    room_name = message['room']
    content = message['content']

    room = Room.find(name: room_name)
    if room
      Message.create(
        room_id: room.id,
        username: username,
        content: content
      )
    end

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

    @rooms[room_name].delete(ws)

    broadcast_to_room(room_name, {
      type: 'leave',
      username: username,
      timestamp: Time.now.iso8601
    })

    update_user_list(room_name)
    @clients.delete(ws)

    puts "#{username} left room: #{room_name}"
  end

  def handle_disconnect(ws)
    client_info = @clients[ws]
    return unless client_info

    room_name = client_info[:room]
    username = client_info[:username]

    @rooms[room_name].delete(ws)

    broadcast_to_room(room_name, {
      type: 'leave',
      username: username,
      timestamp: Time.now.iso8601
    })

    update_user_list(room_name)
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

EM.run do
  server = ChatServer.new

  Rack::Handler.get('thin').run(
    server,
    Port: 9292,
    Host: '0.0.0.0'
  ) do |s|
    puts "WebSocket server started on ws://localhost:9292"
    puts "Ready to accept connections"
  end
end
