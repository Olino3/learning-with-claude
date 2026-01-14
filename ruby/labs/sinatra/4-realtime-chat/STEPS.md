# Progressive Building Guide: Real-Time Chat App

Build a real-time chat application with WebSockets, multiple rooms, and persistent messages.

## 🎯 Overview

This guide breaks down the chat app into 7 progressive steps:
1. **Basic Sinatra Setup** - Web app with rooms
2. **Add Database** - Rooms and messages storage
3. **WebSocket Server** - Faye-WebSocket setup
4. **Client-Side WebSocket** - JavaScript client
5. **Message Broadcasting** - Real-time message delivery
6. **Multiple Rooms** - Room-based chat
7. **User Presence** - Online user tracking

**Estimated Time**: 4-5 hours

**Note**: This is an advanced lab requiring understanding of:
- Asynchronous programming
- WebSocket protocol
- EventMachine
- JavaScript

---

## Step 1: Basic Sinatra Setup (20 min)

### 🎯 Goal
Create a basic chat interface with rooms.

### 📝 Tasks

1. **Create app.rb**:
   ```ruby
   require 'sinatra'

   get '/' do
     redirect '/rooms'
   end

   get '/rooms' do
     erb :rooms
   end

   get '/room/:id' do
     @room_id = params[:id]
     erb :chat
   end
   ```

2. **Create rooms view** (`views/rooms.erb`):
   ```erb
   <h2>Chat Rooms</h2>

   <div class="rooms-list">
     <div class="room-card">
       <h3>General</h3>
       <a href="/room/general" class="btn">Enter Room</a>
     </div>

     <div class="room-card">
       <h3>Random</h3>
       <a href="/room/random" class="btn">Enter Room</a>
     </div>

     <div class="room-card">
       <h3>Tech Talk</h3>
       <a href="/room/tech" class="btn">Enter Room</a>
     </div>
   </div>
   ```

3. **Create chat view** (`views/chat.erb`):
   ```erb
   <div class="chat-container">
     <div class="chat-header">
       <h2>Room: <%= @room_id.capitalize %></h2>
       <a href="/rooms" class="btn btn-sm">← Back to Rooms</a>
     </div>

     <div id="messages" class="messages"></div>

     <div class="chat-input">
       <input type="text" id="username" placeholder="Your name" value="Guest">
       <input type="text" id="message" placeholder="Type a message...">
       <button onclick="sendMessage()" class="btn">Send</button>
     </div>
   </div>

   <script>
     const ROOM_ID = '<%= @room_id %>';
     // WebSocket code will go here
   </script>
   ```

### ✅ Checkpoint
- [ ] Can view rooms list
- [ ] Can enter a room
- [ ] Chat interface displays

---

## Step 2: Add Database for Persistence (25 min)

### 🎯 Goal
Store rooms and messages in database.

### 📝 Tasks

1. **Install gems**:
   ```bash
   gem install activerecord sqlite3
   ```

2. **Create database config** (`config/database.rb`):
   ```ruby
   require 'active_record'

   ActiveRecord::Base.establish_connection(
     adapter: 'sqlite3',
     database: 'chat_app.db'
   )
   ```

3. **Create models** (`lib/models/room.rb` and `lib/models/message.rb`):
   ```ruby
   # lib/models/room.rb
   class Room < ActiveRecord::Base
     has_many :messages, dependent: :destroy

     validates :name, presence: true, uniqueness: true
   end

   # lib/models/message.rb
   class Message < ActiveRecord::Base
     belongs_to :room

     validates :username, presence: true
     validates :content, presence: true

     def as_json(options = {})
       {
         id: id,
         username: username,
         content: content,
         timestamp: created_at.strftime('%H:%M')
       }
     end
   end
   ```

4. **Create tables** (`db/migrate.rb`):
   ```ruby
   require_relative '../config/database'

   ActiveRecord::Base.connection.create_table :rooms, force: true do |t|
     t.string :name, null: false
     t.timestamps
   end

   ActiveRecord::Base.connection.add_index :rooms, :name, unique: true

   ActiveRecord::Base.connection.create_table :messages, force: true do |t|
     t.string :username, null: false
     t.text :content, null: false
     t.references :room, foreign_key: true
     t.timestamps
   end

   # Seed rooms
   require_relative '../lib/models/room'
   Room.create(name: 'general')
   Room.create(name: 'random')
   Room.create(name: 'tech')

   puts "✓ Database created and seeded"
   ```

5. **Run migration**:
   ```bash
   ruby db/migrate.rb
   ```

6. **Update app.rb**:
   ```ruby
   require 'sinatra'
   require_relative 'config/database'
   require_relative 'lib/models/room'
   require_relative 'lib/models/message'

   get '/rooms' do
     @rooms = Room.all
     erb :rooms
   end

   get '/room/:name' do
     @room = Room.find_by(name: params[:name])
     halt 404, "Room not found" unless @room
     @messages = @room.messages.order(:created_at).limit(50)
     erb :chat
   end

   # API endpoint to get messages
   get '/api/rooms/:name/messages' do
     content_type :json
     room = Room.find_by(name: params[:name])
     halt 404 unless room

     messages = room.messages.order(:created_at).limit(50)
     messages.map(&:as_json).to_json
   end
   ```

### ✅ Checkpoint
- [ ] Database tables created
- [ ] Rooms are seeded
- [ ] Can fetch messages via API

---

## Step 3: WebSocket Server Setup (35 min)

### 🎯 Goal
Set up Faye-WebSocket server with EventMachine.

### 📝 Tasks

1. **Install gems**:
   ```bash
   gem install faye-websocket eventmachine
   ```

2. **Create WebSocket server** (`chat_server.rb`):
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

3. **Start the WebSocket server**:
   ```bash
   ruby chat_server.rb
   # Keep this running in a separate terminal
   ```

### ✅ Checkpoint
- [ ] WebSocket server starts
- [ ] Can accept connections
- [ ] No errors on startup

---

## Step 4: Client-Side WebSocket (30 min)

### 🎯 Goal
Connect to WebSocket and send/receive messages.

### 📝 Tasks

1. **Create client JavaScript** (add to `views/chat.erb` or create `public/js/chat.js`):
   ```javascript
   let ws;
   const roomId = ROOM_ID; // From ERB template

   // Connect to WebSocket
   function connect() {
     ws = new WebSocket('ws://localhost:9292/chat');

     ws.onopen = () => {
       console.log('Connected to chat server');
       // Join the room
       ws.send(JSON.stringify({
         type: 'join',
         room: roomId
       }));

       loadMessages();
     };

     ws.onmessage = (event) => {
       const data = JSON.parse(event.data);
       if (data.type === 'message') {
         displayMessage(data.data);
       }
     };

     ws.onerror = (error) => {
       console.error('WebSocket error:', error);
     };

     ws.onclose = () => {
       console.log('Disconnected from chat server');
       setTimeout(connect, 3000); // Reconnect after 3 seconds
     };
   }

   // Load message history
   async function loadMessages() {
     const response = await fetch(`/api/rooms/${roomId}/messages`);
     const messages = await response.json();
     messages.forEach(displayMessage);
   }

   // Send message
   function sendMessage() {
     const messageInput = document.getElementById('message');
     const usernameInput = document.getElementById('username');
     const content = messageInput.value.trim();
     const username = usernameInput.value.trim() || 'Guest';

     if (!content) return;

     ws.send(JSON.stringify({
       type: 'message',
       room: roomId,
       username: username,
       content: content
     }));

     messageInput.value = '';
   }

   // Display message in chat
   function displayMessage(message) {
     const messagesDiv = document.getElementById('messages');
     const messageEl = document.createElement('div');
     messageEl.className = 'message';

     messageEl.innerHTML = `
       <span class="username">${escapeHtml(message.username)}</span>
       <span class="content">${escapeHtml(message.content)}</span>
       <span class="timestamp">${message.timestamp}</span>
     `;

     messagesDiv.appendChild(messageEl);
     messagesDiv.scrollTop = messagesDiv.scrollHeight;
   }

   // Escape HTML to prevent XSS
   function escapeHtml(text) {
     const div = document.createElement('div');
     div.textContent = text;
     return div.innerHTML;
   }

   // Send message on Enter key
   document.getElementById('message').addEventListener('keypress', (e) => {
     if (e.key === 'Enter') {
       sendMessage();
     }
   });

   // Connect on page load
   connect();
   ```

2. **Add chat CSS** (`public/css/style.css`):
   ```css
   .chat-container {
     max-width: 800px;
     margin: 0 auto;
     background: white;
     border-radius: 8px;
     box-shadow: 0 2px 4px rgba(0,0,0,0.1);
     height: 600px;
     display: flex;
     flex-direction: column;
   }

   .chat-header {
     padding: 1rem;
     border-bottom: 1px solid #ddd;
     display: flex;
     justify-content: space-between;
     align-items: center;
   }

   .messages {
     flex: 1;
     overflow-y: auto;
     padding: 1rem;
   }

   .message {
     margin-bottom: 1rem;
     padding: 0.75rem;
     background: #f5f5f5;
     border-radius: 4px;
   }

   .message .username {
     font-weight: bold;
     color: #2c3e50;
     margin-right: 0.5rem;
   }

   .message .timestamp {
     float: right;
     color: #999;
     font-size: 0.875rem;
   }

   .chat-input {
     padding: 1rem;
     border-top: 1px solid #ddd;
     display: flex;
     gap: 0.5rem;
   }

   .chat-input input {
     flex: 1;
     padding: 0.75rem;
     border: 1px solid #ddd;
     border-radius: 4px;
   }

   .chat-input input:first-child {
     flex: 0 0 150px;
   }
   ```

### ✅ Checkpoint
- [ ] WebSocket connects
- [ ] Can send messages
- [ ] Messages appear in chat
- [ ] Message history loads

---

## Steps 5-7: Quick Summary

### Step 5: Message Broadcasting
- Ensure messages broadcast to all room members
- Add typing indicators
- Message delivery confirmation

### Step 6: Multiple Rooms
- Room switching
- Unread message indicators
- Room-specific user lists

### Step 7: User Presence
- Track online users
- Show who's typing
- User join/leave notifications

See complete `chat_server.rb` for full implementation!

---

## 🎉 Completion!

You've built a real-time chat application with:

✅ WebSocket communication
✅ Multiple chat rooms
✅ Message persistence
✅ Real-time broadcasting
✅ Client-server architecture

### 📚 What You Learned

- WebSocket protocol
- EventMachine async programming
- Real-time data broadcasting
- Client-side JavaScript
- Connection management
- Database persistence for real-time data

**Congratulations!** You've completed all Sinatra labs!

### 🎯 Next Steps

- Add authentication to chat
- Implement private messaging
- Add file sharing
- Deploy to production
- Build your own Sinatra app!
