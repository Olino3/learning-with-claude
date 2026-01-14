#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 5: Message Broadcasting with Database Persistence

require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'sequel'

DB = Sequel.sqlite('chat.db')

class Room < Sequel::Model
  one_to_many :messages
end

class Message < Sequel::Model
  many_to_one :room
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
        puts "Client connected"
      end

      ws.on :message do |event|
        handle_message(ws, event.data)
      end

      ws.on :close do |event|
        handle_disconnect(ws)
      end

      ws.rack_response
    else
      [200, { 'Content-Type' => 'text/plain' }, ['WebSocket Server']]
    end
  end

  private

  def handle_message(ws, data)
    message = JSON.parse(data)

    case message['type']
    when 'join'
      room = message['room']
      @clients[ws] = { username: message['username'], room: room }
      @rooms[room] << ws
      puts "#{message['username']} joined #{room}"
    when 'chat'
      room_name = message['room']

      # Save to database
      room = Room.find(name: room_name)
      if room
        Message.create(
          room_id: room.id,
          username: message['username'],
          content: message['content']
        )
      end

      # Broadcast to all clients in room
      broadcast_to_room(room_name, {
        type: 'chat',
        username: message['username'],
        content: message['content'],
        timestamp: Time.now.strftime('%H:%M')
      })
    end
  rescue JSON::ParserError
    puts "Invalid JSON"
  end

  def broadcast_to_room(room, message)
    json = message.to_json
    @rooms[room].each do |client|
      client.send(json) if client.ready_state == Faye::WebSocket::OPEN
    end
  end

  def handle_disconnect(ws)
    info = @clients[ws]
    return unless info
    @rooms[info[:room]].delete(ws)
    @clients.delete(ws)
    puts "#{info[:username]} disconnected"
  end
end

EM.run do
  Rack::Handler.get('thin').run(
    ChatServer.new,
    Port: 9292,
    Host: '0.0.0.0'
  ) do |s|
    puts "WebSocket server on ws://localhost:9292"
    puts "Messages are saved to database"
  end
end
