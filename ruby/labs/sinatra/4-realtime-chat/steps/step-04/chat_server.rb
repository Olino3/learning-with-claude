#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 4: WebSocket Server with Room Support

require 'faye/websocket'
require 'eventmachine'
require 'json'

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
      room = message['room']
      broadcast_to_room(room, {
        type: 'chat',
        username: message['username'],
        content: message['content'],
        timestamp: Time.now.strftime('%H:%M')
      })
    end
  rescue JSON::ParserError
    puts "Invalid JSON received"
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
    puts "#{info[:username]} disconnected from #{info[:room]}"
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
