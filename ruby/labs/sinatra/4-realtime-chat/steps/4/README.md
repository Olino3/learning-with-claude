# Step 4: Client-Side WebSocket

[← Previous Step](../3/README.md) | [Next Step →](../5/README.md)

**Estimated Time**: 30 minutes

## 🎯 Goal
Connect client to WebSocket server and implement send/receive functionality.

## 📝 Tasks

### 1. Create chat JavaScript file (public/js/chat.js)

```javascript
let ws;

// Connect to WebSocket
function connect() {
  ws = new WebSocket('ws://localhost:9292/chat');

  ws.onopen = () => {
    console.log('Connected to chat server');
    // Join the room
    ws.send(JSON.stringify({
      type: 'join',
      room: ROOM_ID
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
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('message').addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      sendMessage();
    }
  });

  // Connect on page load
  connect();
});
```

### 2. Update chat view (views/chat.erb)

Replace the script section:
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
</script>
<script src="/js/chat.js"></script>
```

### 3. Add chat CSS (public/css/style.css)

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

.message .content {
  display: inline;
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

.chat-input button {
  flex: 0 0 auto;
}
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=4
```

Test the chat:
- [ ] WebSocket connects (check browser console)
- [ ] Can send messages
- [ ] Messages appear in real-time
- [ ] Message history loads on connect
- [ ] Enter key sends messages
- [ ] Messages are HTML-escaped (try sending `<script>`)
- [ ] Auto-scrolls to newest message

Test with multiple tabs:
- [ ] Open room in two browser tabs
- [ ] Send message from one tab
- [ ] Message appears instantly in both tabs

## 💡 What You Learned

- Client-side WebSocket connection
- Asynchronous JavaScript with async/await
- Fetch API for loading message history
- Real-time message broadcasting
- HTML escaping to prevent XSS attacks
- Auto-reconnection on disconnect
- DOM manipulation for dynamic content

## 🎯 Tips

- Always escape user-generated content to prevent XSS
- Auto-reconnect improves resilience
- Use `DOMContentLoaded` to ensure elements exist
- `scrollTop = scrollHeight` scrolls to bottom
- WebSocket events are asynchronous
- Test with multiple tabs to verify broadcasting

---

[← Previous Step](../3/README.md) | [Next Step →](../5/README.md)
