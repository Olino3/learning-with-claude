# Step 7: User Presence Tracking

[← Previous Step](../6/README.md)

**Estimated Time**: 35 minutes

## 🎯 Goal
Track online users in each room and display user presence indicators.

## 📝 Tasks

### 1. Update chat_server.rb with presence tracking

Replace the ChatServer class with enhanced presence tracking:

```ruby
require 'faye/websocket'
require 'eventmachine'
require 'json'
require_relative 'config/database'
require_relative 'lib/models/room'
require_relative 'lib/models/message'

class ChatServer
  CLIENTS = Hash.new { |h, k| h[k] = [] }
  USERS = Hash.new { |h, k| h[k] = {} }  # room => {ws => username}

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
        handle_disconnect(ws)
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
      username = data['username'] || 'Guest'
      
      CLIENTS[room_name] << ws
      USERS[room_name][ws] = username
      
      puts "#{username} joined room: #{room_name}"
      
      # Send current user list to the joining user
      ws.send({
        type: 'user_list',
        users: USERS[room_name].values.uniq
      }.to_json)
      
      # Notify others that user joined
      broadcast(room_name, {
        type: 'user_joined',
        username: username,
        users: USERS[room_name].values.uniq
      })

    when 'message'
      room = Room.find_by(name: data['room'])
      return unless room

      message = room.messages.create(
        username: data['username'],
        content: data['content']
      )

      broadcast(data['room'], {
        type: 'message',
        room: data['room'],
        data: message.as_json
      })
      
    when 'typing'
      broadcast_except(data['room'], ws, {
        type: 'typing',
        username: data['username']
      })
    end
  end

  def handle_disconnect(ws)
    CLIENTS.each do |room_name, clients|
      if clients.include?(ws)
        username = USERS[room_name][ws]
        clients.delete(ws)
        USERS[room_name].delete(ws)
        
        # Notify others that user left
        broadcast(room_name, {
          type: 'user_left',
          username: username,
          users: USERS[room_name].values.uniq
        })
        
        puts "#{username} left room: #{room_name}"
      end
    end
  end

  def broadcast(room_name, message)
    CLIENTS[room_name].each do |client|
      client.send(message.to_json)
    end
  end

  def broadcast_except(room_name, sender_ws, message)
    CLIENTS[room_name].each do |client|
      client.send(message.to_json) unless client == sender_ws
    end
  end
end

ChatServer.start if __FILE__ == $0
```

### 2. Update chat JavaScript (public/js/chat.js)

Add user list handling:

```javascript
let ws;
let typingTimeout;

function connect() {
  ws = new WebSocket('ws://localhost:9292/chat');

  ws.onopen = () => {
    console.log('Connected to chat server');
    const username = document.getElementById('username').value.trim() || 'Guest';
    
    ws.send(JSON.stringify({
      type: 'join',
      room: ROOM_ID,
      username: username
    }));

    loadMessages();
  };

  ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    
    switch(data.type) {
      case 'message':
        displayMessage(data.data);
        break;
      case 'typing':
        showTypingIndicator(data.username);
        break;
      case 'user_joined':
        showSystemMessage(`${data.username} joined the room`);
        updateUserList(data.users);
        break;
      case 'user_left':
        showSystemMessage(`${data.username} left the room`);
        updateUserList(data.users);
        break;
      case 'user_list':
        updateUserList(data.users);
        break;
    }
  };

  ws.onerror = (error) => {
    console.error('WebSocket error:', error);
  };

  ws.onclose = () => {
    console.log('Disconnected from chat server');
    setTimeout(connect, 3000);
  };
}

function updateUserList(users) {
  let userListEl = document.getElementById('user-list');
  
  if (!userListEl) {
    // Create user list element if it doesn't exist
    userListEl = document.createElement('div');
    userListEl.id = 'user-list';
    userListEl.className = 'user-list';
    
    const header = document.querySelector('.chat-header');
    header.appendChild(userListEl);
  }
  
  // Update user count and list
  const uniqueUsers = [...new Set(users)];
  userListEl.innerHTML = `
    <div class="user-count">👥 ${uniqueUsers.length} online</div>
    <div class="user-names">${uniqueUsers.join(', ')}</div>
  `;
}

function showTypingIndicator(username) {
  let indicator = document.getElementById('typing-indicator');
  
  if (!indicator) {
    indicator = document.createElement('div');
    indicator.id = 'typing-indicator';
    indicator.className = 'typing-indicator';
    document.getElementById('messages').appendChild(indicator);
  }
  
  indicator.textContent = `${username} is typing...`;
  
  clearTimeout(typingTimeout);
  typingTimeout = setTimeout(() => {
    indicator.remove();
  }, 3000);
}

function showSystemMessage(text) {
  const messagesDiv = document.getElementById('messages');
  const messageEl = document.createElement('div');
  messageEl.className = 'message system-message';
  messageEl.textContent = text;
  messagesDiv.appendChild(messageEl);
  messagesDiv.scrollTop = messagesDiv.scrollHeight;
}

function notifyTyping() {
  const username = document.getElementById('username').value.trim() || 'Guest';
  
  ws.send(JSON.stringify({
    type: 'typing',
    room: ROOM_ID,
    username: username
  }));
}

async function loadMessages() {
  const response = await fetch(`/api/rooms/${ROOM_ID}/messages`);
  const messages = await response.json();
  messages.forEach(displayMessage);
}

function sendMessage() {
  const messageInput = document.getElementById('message');
  const usernameInput = document.getElementById('username');
  const content = messageInput.value.trim();
  const username = usernameInput.value.trim() || 'Guest';

  if (!content) return;

  ws.send(JSON.stringify({
    type: 'message',
    room: ROOM_ID,
    username: username,
    content: content
  }));

  messageInput.value = '';
  
  const indicator = document.getElementById('typing-indicator');
  if (indicator) indicator.remove();
}

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

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', () => {
  const messageInput = document.getElementById('message');
  
  messageInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      sendMessage();
    }
  });
  
  messageInput.addEventListener('input', () => {
    notifyTyping();
  });

  connect();
});
```

### 3. Add user list styling (public/css/style.css)

```css
.chat-header {
  padding: 1rem;
  border-bottom: 1px solid #ddd;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.user-list {
  display: flex;
  align-items: center;
  gap: 1rem;
  font-size: 0.875rem;
}

.user-count {
  background: #2c3e50;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-weight: 500;
}

.user-names {
  color: #666;
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=4
```

Test user presence:
- [ ] User count displays in header
- [ ] User names shown in header
- [ ] Count updates when users join
- [ ] Count updates when users leave
- [ ] Join/leave notifications appear
- [ ] User list updates in real-time

Test with multiple tabs:
1. Open room in first tab (1 online)
2. Open same room in second tab (2 online)
3. Close first tab (back to 1 online)
4. Verify counts and notifications

## 💡 What You Learned

- User presence tracking with WebSocket
- Managing user state on server
- Broadcasting presence updates
- Handling disconnections gracefully
- Displaying online user lists
- Real-time user join/leave notifications

## 🎯 Tips

- Track both connections (CLIENTS) and user info (USERS)
- Use Set to ensure unique usernames in display
- Handle disconnects in `on :close` event
- Update user lists on all presence events
- Consider username conflicts in production apps

---

## 🎉 Completion!

You've built a complete real-time chat application with:

✅ WebSocket communication  
✅ Multiple chat rooms  
✅ Message persistence with database  
✅ Real-time message broadcasting  
✅ Typing indicators  
✅ User presence tracking  
✅ Join/leave notifications  
✅ Online user lists  

### 📚 What You Learned

- WebSocket protocol and real-time communication
- EventMachine for asynchronous Ruby programming
- Faye-WebSocket gem for WebSocket handling
- Managing stateful connections on the server
- Client-side WebSocket in JavaScript
- Broadcasting patterns (all, except sender)
- User presence and activity tracking
- Graceful reconnection handling

### 🚀 Next Steps

You've completed all 4 Sinatra labs! Consider exploring:

- **Production deployment** - Deploy to Heroku or similar platform
- **Advanced features** - File sharing, emoji reactions, private messages
- **Scaling** - Redis pub/sub for multi-server deployments
- **Security** - Authentication, rate limiting, message encryption
- **Other frameworks** - Try Rails, Hanami, or Roda

### 📖 Additional Resources

- [WebSocket RFC](https://tools.ietf.org/html/rfc6455)
- [Faye-WebSocket Documentation](https://github.com/faye/faye-websocket-ruby)
- [EventMachine Guide](https://github.com/eventmachine/eventmachine/wiki)
- [Sinatra Documentation](http://sinatrarb.com/documentation.html)

---

[← Previous Step](../6/README.md)
