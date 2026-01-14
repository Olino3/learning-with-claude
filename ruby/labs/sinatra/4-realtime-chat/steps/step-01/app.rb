#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 1: Basic Sinatra Setup
# Web app with rooms interface

require 'sinatra'

set :port, 4567
set :bind, '0.0.0.0'
enable :sessions
set :session_secret, 'chat-app-secret-key'

# Helpers
helpers do
  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end
end

# Home page - room list
get '/' do
  erb :index
end

# Rooms list
get '/rooms' do
  erb :rooms
end

# Chat room
get '/room/:id' do
  @room_id = params[:id]
  erb :chat
end

if __FILE__ == $0
  puts "Starting Chat App..."
  Sinatra::Application.run!
end
