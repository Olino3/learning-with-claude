# Step 5: Message Broadcasting Improvements

[← Previous Step](../4/README.md) | [Next Step →](../6/README.md)

**Estimated Time**: 25 minutes

## 🎯 Goal
Improve message broadcasting with delivery confirmation and typing indicators.

## 📝 Tasks

### 1. Add typing indicator to chat_server.rb

Update the `handle_message` method in `chat_server.rb`:

```ruby
def handle_message(ws, data)
  case data['type']
  when 'join'
    room_name = data['room']
    CLIENTS[room_name] << ws
    puts "Client joined room: #{room_name}"
    
    # Notify others that user joined
    broadcast(room_name, {
      type: 'user_joined',
      username: data['username'] || 'Guest'
    })

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
    
  when 'typing'
    # Broadcast typing indicator (don't save to DB)
    broadcast_except(data['room'], ws, {
      type: 'typing',
      username: data['username']
    })
  end
end

# Broadcast to all except sender
def broadcast_except(room_name, sender_ws, message)
  CLIENTS[room_name].each do |client|
    client.send(message.to_json) unless client == sender_ws
  end
end
```

### 2. Update client JavaScript (public/js/chat.js)

Add typing indicator functionality:

```javascript
let ws;
let typingTimeout;

// Connect to WebSocket
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

// Show typing indicator
function showTypingIndicator(username) {
  let indicator = document.getElementById('typing-indicator');
  
  if (!indicator) {
    indicator = document.createElement('div');
    indicator.id = 'typing-indicator';
    indicator.className = 'typing-indicator';
    document.getElementById('messages').appendChild(indicator);
  }
  
  indicator.textContent = `${username} is typing...`;
  
  // Clear after 3 seconds
  clearTimeout(typingTimeout);
  typingTimeout = setTimeout(() => {
    indicator.remove();
  }, 3000);
}

// Show system message
function showSystemMessage(text) {
  const messagesDiv = document.getElementById('messages');
  const messageEl = document.createElement('div');
  messageEl.className = 'message system-message';
  messageEl.textContent = text;
  messagesDiv.appendChild(messageEl);
  messagesDiv.scrollTop = messagesDiv.scrollHeight;
}

// Send typing notification
function notifyTyping() {
  const username = document.getElementById('username').value.trim() || 'Guest';
  
  ws.send(JSON.stringify({
    type: 'typing',
    room: ROOM_ID,
    username: username
  }));
}

// Load message history
async function loadMessages() {
  const response = await fetch(`/api/rooms/${ROOM_ID}/messages`);
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
    room: ROOM_ID,
    username: username,
    content: content
  }));

  messageInput.value = '';
  
  // Clear typing indicator
  const indicator = document.getElementById('typing-indicator');
  if (indicator) indicator.remove();
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

// Event listeners
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

### 3. Add typing indicator CSS (public/css/style.css)

```css
.typing-indicator {
  padding: 0.5rem;
  color: #666;
  font-style: italic;
  font-size: 0.875rem;
}

.system-message {
  background: #e3f2fd !important;
  color: #1976d2;
  text-align: center;
  font-style: italic;
  font-size: 0.875rem;
}
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=4
```

Test improvements:
- [ ] Typing indicator appears when someone types
- [ ] Indicator disappears after 3 seconds or on send
- [ ] User join notifications appear
- [ ] System messages are styled differently
- [ ] Messages still broadcast correctly

Test with two tabs:
- [ ] Start typing in one tab
- [ ] See "User is typing..." in the other tab
- [ ] Join a room and see join notification

## 💡 What You Learned

- Broadcasting to all except sender
- Implementing typing indicators
- System messages vs chat messages
- Managing timeouts for ephemeral indicators
- Different message types in WebSocket communication
- Input event handling for real-time feedback

## 🎯 Tips

- Use `broadcast_except` to avoid echoing back to sender
- Clear typing timeout before setting a new one
- Typing indicators should be ephemeral (not saved to DB)
- System messages provide context for room activity
- Input events fire on every keystroke

---

[← Previous Step](../4/README.md) | [Next Step →](../6/README.md)
