# Step 6: Multiple Rooms Enhancement

[← Previous Step](../5/README.md) | [Next Step →](../7/README.md)

**Estimated Time**: 30 minutes

## 🎯 Goal
Improve room management with unread indicators and room statistics.

## 📝 Tasks

### 1. Add message count API endpoint to app.rb

```ruby
# Get room statistics
get '/api/rooms/:name/stats' do
  content_type :json
  room = Room.find_by(name: params[:name])
  halt 404 unless room

  {
    name: room.name,
    message_count: room.messages.count,
    last_message_at: room.messages.maximum(:created_at)&.strftime('%H:%M')
  }.to_json
end
```

### 2. Update rooms view (views/rooms.erb)

```erb
<h2>Chat Rooms</h2>

<div class="rooms-list">
  <% @rooms.each do |room| %>
    <div class="room-card" data-room="<%= room.name %>">
      <h3><%= room.name.capitalize %></h3>
      <div class="room-stats">
        <p class="room-info">
          <span class="message-count"><%= room.messages.count %> messages</span>
          <% if room.messages.any? %>
            <span class="last-active">
              Last: <%= room.messages.maximum(:created_at).strftime('%H:%M') %>
            </span>
          <% end %>
        </p>
      </div>
      <a href="/room/<%= room.name %>" class="btn">Enter Room</a>
    </div>
  <% end %>
</div>

<script src="/js/rooms.js"></script>
```

### 3. Create rooms JavaScript (public/js/rooms.js)

```javascript
// Connect to WebSocket to track room activity
const ws = new WebSocket('ws://localhost:9292/chat');

ws.onopen = () => {
  console.log('Connected to chat server for room monitoring');
  
  // Join all rooms for monitoring
  document.querySelectorAll('.room-card').forEach(card => {
    const roomName = card.dataset.room;
    ws.send(JSON.stringify({
      type: 'join',
      room: roomName,
      monitor: true  // Flag to indicate this is just monitoring
    }));
  });
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  
  if (data.type === 'message') {
    updateRoomCard(data.room, data.data);
  }
};

function updateRoomCard(roomName, message) {
  const card = document.querySelector(`.room-card[data-room="${roomName}"]`);
  if (!card) return;
  
  // Update message count
  const countEl = card.querySelector('.message-count');
  if (countEl) {
    const current = parseInt(countEl.textContent);
    countEl.textContent = `${current + 1} messages`;
  }
  
  // Add unread indicator
  if (!card.classList.contains('has-unread')) {
    card.classList.add('has-unread');
    const badge = document.createElement('span');
    badge.className = 'unread-badge';
    badge.textContent = 'New';
    card.querySelector('h3').appendChild(badge);
  }
}
```

### 4. Update chat_server.rb to broadcast room info

Modify the `handle_message` method:

```ruby
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
    room: data['room'],  # Add room name
    data: message.as_json
  })
```

### 5. Add room card styling (public/css/style.css)

```css
.room-card {
  position: relative;
  transition: transform 0.2s, box-shadow 0.2s;
}

.room-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.room-card.has-unread {
  border: 2px solid #2c3e50;
}

.room-stats {
  margin: 1rem 0;
}

.room-info {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  color: #666;
  font-size: 0.875rem;
}

.last-active {
  color: #999;
  font-size: 0.8rem;
}

.unread-badge {
  display: inline-block;
  margin-left: 0.5rem;
  padding: 0.25rem 0.5rem;
  background: #e74c3c;
  color: white;
  font-size: 0.75rem;
  border-radius: 12px;
  font-weight: normal;
}
```

### 6. Update chat view to clear unread on enter

Add to `views/chat.erb`:
```erb
<script>
  const ROOM_ID = '<%= @room_id %>';
  
  // Clear localStorage unread flag for this room
  localStorage.removeItem(`unread_${ROOM_ID}`);
</script>
<script src="/js/chat.js"></script>
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=4
```

Test multiple rooms:
- [ ] Room cards show message counts
- [ ] Last message time displays
- [ ] New message badge appears on activity
- [ ] Room cards highlight with border when unread
- [ ] Can switch between rooms seamlessly
- [ ] Message counts update in real-time

Test flow:
1. Open rooms list
2. In another tab, send message to a room
3. See "New" badge appear on room card
4. Click to enter room
5. Badge should clear

## 💡 What You Learned

- Real-time room statistics
- WebSocket monitoring pattern
- Dynamic DOM updates based on events
- CSS transitions for smooth effects
- Unread message indicators
- Multi-room WebSocket subscriptions

## 🎯 Tips

- Monitor mode allows joining multiple rooms without participating
- Use CSS transitions for smooth visual feedback
- LocalStorage can track unread state across pages
- The `data-*` attributes make element selection easy
- Real-time stats provide better UX than page refreshes

---

[← Previous Step](../5/README.md) | [Next Step →](../7/README.md)
