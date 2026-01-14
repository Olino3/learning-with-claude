#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 3: Basic WebSocket Server
# Faye-WebSocket setup with EventMachine

require 'faye/websocket'
require 'eventmachine'
require 'json'

class ChatServer
  def initialize
    @clients = []
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      ws.on :open do |event|
        @clients << ws
        puts "Client connected (#{@clients.length} total)"
      end

      ws.on :message do |event|
        data = JSON.parse(event.data)
        puts "Received: #{data}"

        # Echo back to all clients
        @clients.each do |client|
          client.send(event.data) if client.ready_state == Faye::WebSocket::OPEN
        end
      end

      ws.on :close do |event|
        @clients.delete(ws)
        puts "Client disconnected (#{@clients.length} remaining)"
      end

      ws.rack_response
    else
      [200, { 'Content-Type' => 'text/plain' }, ['WebSocket Server']]
    end
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
  end
end
