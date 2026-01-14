# Sinatra Lab 4: Real-time Chat with WebSockets

A real-time chat application demonstrating WebSocket communication, asynchronous programming, and real-time features with Sinatra.

## 🎯 Learning Objectives

This lab demonstrates:
- **WebSocket Communication**: Bidirectional real-time messaging
- **EventMachine**: Asynchronous, event-driven programming
- **Faye-WebSocket**: WebSocket server implementation
- **Multiple Chat Rooms**: Channel-based messaging
- **User Presence**: Online/offline status tracking
- **Message History**: Database-backed message persistence
- **Markdown Support**: Rich text message formatting
- **Broadcasting**: Message distribution to multiple clients
- **Connection Management**: Handle connects/disconnects
- **Client-side JavaScript**: WebSocket client implementation

## 📋 Project Structure

```
4-realtime-chat/
├── README.md (this file)
├── app.rb (Sinatra web application)
├── chat_server.rb (WebSocket server with EventMachine)
├── lib/
│   └── models/
│       ├── message.rb (message model)
│       └── room.rb (chat room model)
├── views/
│   ├── layout.erb (main layout)
│   ├── index.erb (room list)
│   └── chat.erb (chat interface)
└── public/
    ├── css/
    │   └── style.css (chat UI styles)
    └── js/
        └── chat.js (WebSocket client)
```

## 🚀 Running the Lab

### Step-by-Step Guide (Recommended)

Start from scratch and build the real-time chat app incrementally through 7 steps:

👉 **[Start with Step 1 →](steps/1/README.md)**

Each step builds on the previous one:
1. Basic Sinatra Setup (20 min)
2. Add Database for Persistence (25 min)
3. WebSocket Server Setup (35 min)
4. Client-Side WebSocket (30 min)
5. Message Broadcasting Improvements (25 min)
6. Multiple Rooms Enhancement (30 min)
7. User Presence Tracking (35 min)

**Total Time**: ~4-5 hours

### Quick Start with Make

```bash
make sinatra-lab NUM=4
```

This command:
- Starts both the web app and WebSocket server in Docker
- Opens the app at http://localhost:4567
- WebSocket server runs automatically on port 9292
- Follow [Step 1](steps/1/README.md) to begin building

### Run Complete Solution

To see the finished application:

👉 **[View Solution Guide →](solution/README.md)**

## 🎓 Features Implemented

### 1. Real-time Messaging
- Instant message delivery via WebSockets
- No page refresh required
- Sub-second latency
- Automatic reconnection

### 2. Multiple Chat Rooms
- Create custom chat rooms
- Switch between rooms
- Room-specific message history
- Active user count per room

### 3. User Presence
- Online/offline indicators
- Join/leave notifications
- Active users list
- Real-time user count

### 4. Message Features
- Markdown formatting support
- Timestamps on all messages
- Message persistence in database
- Load message history on join
- System notifications

### 5. User Experience
- Responsive chat interface
- Auto-scroll to new messages
- Message input with Enter to send
- Visual feedback for connection status
- Typing indicators (concept)

## 🔍 How It Works

### WebSocket Flow
```
1. Client opens WebSocket connection to ws://localhost:9292
2. Client sends JOIN message with username and room
3. Server broadcasts join notification to room
4. Client sends CHAT messages with content
5. Server broadcasts messages to all users in room
6. Client receives messages and displays them
7. On disconnect, server broadcasts leave notification
```

### Message Protocol
```javascript
// Join a room
{
  type: 'join',
  username: 'Alice',
  room: 'general'
}

// Send a message
{
  type: 'chat',
  username: 'Alice',
  room: 'general',
  content: 'Hello everyone!'
}

// Leave a room
{
  type: 'leave',
  username: 'Alice',
  room: 'general'
}
```

## 📝 Example Usage

### Connect to Chat
```javascript
// Client-side JavaScript
const ws = new WebSocket('ws://localhost:9292');

ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'join',
    username: 'Alice',
    room: 'general'
  }));
};

ws.onmessage = (event) => {
  const message = JSON.parse(event.data);
  displayMessage(message);
};
```

### Send a Message
```javascript
function sendMessage(content) {
  ws.send(JSON.stringify({
    type: 'chat',
    username: currentUser,
    room: currentRoom,
    content: content
  }));
}
```

### Receive Messages
```javascript
ws.onmessage = (event) => {
  const data = JSON.parse(event.data);

  switch(data.type) {
    case 'chat':
      addChatMessage(data);
      break;
    case 'join':
      addSystemMessage(`${data.username} joined`);
      break;
    case 'leave':
      addSystemMessage(`${data.username} left`);
      break;
    case 'users':
      updateUsersList(data.users);
      break;
  }
};
```

## 🐍 For Python Developers

This Sinatra WebSocket chat compares to these Python frameworks:

### Flask-SocketIO Equivalent
```python
from flask import Flask, render_template
from flask_socketio import SocketIO, emit, join_room, leave_room

app = Flask(__name__)
socketio = SocketIO(app)

@socketio.on('join')
def on_join(data):
    username = data['username']
    room = data['room']
    join_room(room)
    emit('system', {
        'message': f'{username} has joined'
    }, room=room)

@socketio.on('chat')
def on_chat(data):
    room = data['room']
    emit('chat', {
        'username': data['username'],
        'content': data['content'],
        'timestamp': datetime.now().isoformat()
    }, room=room)

@socketio.on('leave')
def on_leave(data):
    username = data['username']
    room = data['room']
    leave_room(room)
    emit('system', {
        'message': f'{username} has left'
    }, room=room)

if __name__ == '__main__':
    socketio.run(app, debug=True)
```

### Django Channels Equivalent
```python
# consumers.py
from channels.generic.websocket import AsyncWebsocketConsumer
import json

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = f'chat_{self.room_name}'

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data['message']
        username = data['username']

        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message,
                'username': username
            }
        )

    async def chat_message(self, event):
        await self.send(text_data=json.dumps({
            'message': event['message'],
            'username': event['username']
        }))

# routing.py
from django.urls import re_path
from . import consumers

websocket_urlpatterns = [
    re_path(r'ws/chat/(?P<room_name>\w+)/$', consumers.ChatConsumer.as_asgi()),
]
```

### FastAPI WebSocket Equivalent
```python
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import Dict, Set
import json

app = FastAPI()

class ConnectionManager:
    def __init__(self):
        self.rooms: Dict[str, Set[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, room: str):
        await websocket.accept()
        if room not in self.rooms:
            self.rooms[room] = set()
        self.rooms[room].add(websocket)

    def disconnect(self, websocket: WebSocket, room: str):
        if room in self.rooms:
            self.rooms[room].discard(websocket)

    async def broadcast(self, message: dict, room: str):
        if room in self.rooms:
            for connection in self.rooms[room]:
                await connection.send_json(message)

manager = ConnectionManager()

@app.websocket("/ws/{room}")
async def websocket_endpoint(websocket: WebSocket, room: str):
    await manager.connect(websocket, room)
    try:
        while True:
            data = await websocket.receive_json()

            if data['type'] == 'chat':
                await manager.broadcast({
                    'type': 'chat',
                    'username': data['username'],
                    'content': data['content'],
                    'timestamp': datetime.now().isoformat()
                }, room)

            elif data['type'] == 'join':
                await manager.broadcast({
                    'type': 'system',
                    'message': f"{data['username']} joined"
                }, room)

    except WebSocketDisconnect:
        manager.disconnect(websocket, room)
        await manager.broadcast({
            'type': 'system',
            'message': f"User left"
        }, room)
```

### Key Differences
- **Sinatra + Faye**: Manual WebSocket handling, flexible
- **Flask-SocketIO**: High-level SocketIO abstraction, easy to use
- **Django Channels**: Channel layers, Redis backend, scalable
- **FastAPI WebSockets**: Native async/await, modern Python

## 📊 Database Schema

```sql
CREATE TABLE rooms (
  id INTEGER PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
  id INTEGER PRIMARY KEY,
  room_id INTEGER NOT NULL,
  username TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE INDEX idx_messages_room ON messages(room_id);
CREATE INDEX idx_messages_created ON messages(created_at DESC);
```

## 🎯 Challenges

Try extending the chat application with:

1. **Private Messages**: Direct messaging between users
2. **File Uploads**: Share images and files in chat
3. **Typing Indicators**: Show when users are typing
4. **Read Receipts**: Track message read status
5. **Message Reactions**: Emoji reactions to messages
6. **User Authentication**: Require login to chat
7. **Message Encryption**: End-to-end encryption
8. **Voice/Video Chat**: WebRTC integration
9. **Message Search**: Full-text search in history
10. **Moderation Tools**: Ban users, delete messages

## 📚 Concepts Covered

After completing this lab, you'll understand:

- **WebSocket Protocol**: Full-duplex communication over TCP
- **EventMachine**: Event-driven I/O for Ruby
- **Asynchronous Programming**: Non-blocking operations
- **Broadcasting**: Pub/sub messaging patterns
- **Connection Management**: Handle client lifecycle
- **Real-time Features**: Instant updates without polling
- **Client-Server Architecture**: WebSocket client/server model
- **Message Protocols**: Custom message formats
- **State Management**: Track users and rooms

## 🔧 Technical Details

### Dependencies
- **sinatra**: Web framework (~> 3.0)
- **faye-websocket**: WebSocket server (~> 0.11)
- **eventmachine**: Async event library (~> 1.2)
- **thin**: EventMachine-based server (~> 1.8)
- **sequel**: ORM for database (~> 5.0)
- **sqlite3**: Database driver (~> 1.6)
- **redcarpet**: Markdown processor (~> 3.6)

### Architecture
- Separate WebSocket server (port 9292)
- Web application server (port 4567)
- SQLite for message persistence
- Client-side JavaScript for UI

### Performance
- Handles hundreds of concurrent connections
- Sub-second message delivery
- Minimal server resources
- Efficient broadcasting

---

Ready to build real-time chat? Start both servers and begin chatting!
