#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 6: Multiple Rooms Support

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
      handle_join(ws, message)
    when 'chat'
      handle_chat(ws, message)
    when 'leave'
      handle_leave(ws, message)
    end
  rescue JSON::ParserError
    puts "Invalid JSON"
  end

  def handle_join(ws, message)
    room = message['room']
    username = message['username']

    @clients[ws] = { username: username, room: room }
    @rooms[room] << ws

    broadcast_to_room(room, {
      type: 'join',
      username: username,
      timestamp: Time.now.strftime('%H:%M')
    })

    puts "#{username} joined #{room}"
  end

  def handle_chat(ws, message)
    room_name = message['room']

    room = Room.find(name: room_name)
    if room
      Message.create(
        room_id: room.id,
        username: message['username'],
        content: message['content']
      )
    end

    broadcast_to_room(room_name, {
      type: 'chat',
      username: message['username'],
      content: message['content'],
      timestamp: Time.now.strftime('%H:%M')
    })
  end

  def handle_leave(ws, message)
    room = message['room']
    username = message['username']

    @rooms[room].delete(ws)
    @clients.delete(ws)

    broadcast_to_room(room, {
      type: 'leave',
      username: username,
      timestamp: Time.now.strftime('%H:%M')
    })

    puts "#{username} left #{room}"
  end

  def handle_disconnect(ws)
    info = @clients[ws]
    return unless info

    @rooms[info[:room]].delete(ws)

    broadcast_to_room(info[:room], {
      type: 'leave',
      username: info[:username],
      timestamp: Time.now.strftime('%H:%M')
    })

    @clients.delete(ws)
  end

  def broadcast_to_room(room, message)
    json = message.to_json
    @rooms[room].each do |client|
      client.send(json) if client.ready_state == Faye::WebSocket::OPEN
    end
  end
end

EM.run do
  Rack::Handler.get('thin').run(
    ChatServer.new,
    Port: 9292,
    Host: '0.0.0.0'
  ) do |s|
    puts "WebSocket server on ws://localhost:9292"
  end
end
