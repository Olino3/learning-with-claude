# Real-Time Chat App - Complete Solution

This folder contains the complete working solution for the Real-Time Chat lab.

## Prerequisites
- Docker environment running (`make up-docker`)

## How to Run

This lab requires running two servers:

### 1. Start the WebSocket Server
```bash
docker compose exec ruby-env bash
cd ruby/labs/sinatra/4-realtime-chat/solution
ruby chat_server.rb
```

### 2. Start the Web Server (in another terminal)
```bash
docker compose exec ruby-env bash
cd ruby/labs/sinatra/4-realtime-chat/solution
ruby app.rb -o 0.0.0.0
```

## Access
Open http://localhost:4567 in your browser.

## Features
- Multiple chat rooms
- Real-time WebSocket messaging
- Message persistence in SQLite
- User presence tracking
- Join/leave notifications
- Online user list per room

## Architecture
- `app.rb` - Sinatra web server (port 4567)
- `chat_server.rb` - WebSocket server using Faye (port 9292)
- SQLite database for message persistence

## Default Rooms
- General - General discussion
- Ruby - Ruby programming talk
- Sinatra - Sinatra web framework
- Random - Off-topic chat
