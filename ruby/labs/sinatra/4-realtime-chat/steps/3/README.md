# Step 3: WebSocket Server Setup

[← Previous Step](../2/README.md) | [Next Step →](../4/README.md)

**Estimated Time**: 35 minutes

## 🎯 Goal
Set up Faye-WebSocket server with EventMachine for real-time communication.

## 📝 Tasks

### 1. Install gems

```bash
gem install faye-websocket eventmachine thin
```

### 2. Create WebSocket server (chat_server.rb)

```ruby
require 'faye/websocket'
require 'eventmachine'
require 'json'
require_relative 'config/database'
require_relative 'lib/models/room'
require_relative 'lib/models/message'

class ChatServer
  CLIENTS = Hash.new { |h, k| h[k] = [] }

  def self.start
    EM.run do
      @app = Rack::Builder.new do
        map '/chat' do
          run ChatServer.new
        end
      end

      Rack::Handler::Thin.run(@app, Port: 9292)
      puts "🚀 WebSocket server running on ws://localhost:9292/chat"
    end
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      ws.on :open do |event|
        puts "Client connected"
      end

      ws.on :message do |event|
        data = JSON.parse(event.data)
        handle_message(ws, data)
      end

      ws.on :close do |event|
        CLIENTS.each do |room, clients|
          clients.delete(ws)
        end
        puts "Client disconnected"
      end

      ws.rack_response
    else
      [400, {}, ['WebSocket connection required']]
    end
  end

  private

  def handle_message(ws, data)
    case data['type']
    when 'join'
      room_name = data['room']
      CLIENTS[room_name] << ws
      puts "Client joined room: #{room_name}"

    when 'message'
      room = Room.find_by(name: data['room'])
      return unless room

      # Save message to database
      message = room.messages.create(
        username: data['username'],
        content: data['content']
      )

      # Broadcast to all clients in the room
      broadcast(data['room'], {
        type: 'message',
        data: message.as_json
      })
    end
  end

  def broadcast(room_name, message)
    CLIENTS[room_name].each do |client|
      client.send(message.to_json)
    end
  end
end

ChatServer.start if __FILE__ == $0
```

### 3. Start the WebSocket server

The Makefile automatically starts the WebSocket server when you run:
```bash
make sinatra-lab NUM=4
```

Or start it manually in a separate terminal:
```bash
ruby chat_server.rb
```

## ✅ Checkpoint

Verify the server:
- [ ] WebSocket server starts on port 9292
- [ ] Console shows "WebSocket server running"
- [ ] No errors on startup
- [ ] Server accepts connections (test in next step)

## 💡 What You Learned

- WebSocket protocol basics
- EventMachine for asynchronous Ruby
- Faye-WebSocket gem usage
- Rack application structure
- Managing WebSocket connections
- Broadcasting messages to multiple clients
- Room-based client organization

## 🎯 Tips

- EventMachine runs in a single event loop
- CLIENTS hash groups connections by room
- WebSocket has 4 events: open, message, close, error
- Faye handles low-level WebSocket protocol
- Thin is required as the Rack handler for EventMachine
- The server must be kept running in the background

## 🔍 Understanding the Code

**CLIENTS Hash**: Groups WebSocket connections by room name
```ruby
CLIENTS['general'] = [ws1, ws2, ws3]  # Three clients in general room
```

**Event Handlers**:
- `on :open` - New WebSocket connection
- `on :message` - Message received from client
- `on :close` - Connection closed

**Message Types**:
- `join` - Client joins a room
- `message` - Client sends a chat message

---

[← Previous Step](../2/README.md) | [Next Step →](../4/README.md)
