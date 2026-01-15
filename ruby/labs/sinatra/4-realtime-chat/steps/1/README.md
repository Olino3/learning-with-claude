# Step 1: Basic Sinatra Setup

[Next Step →](../2/README.md)

**Estimated Time**: 20 minutes

## 🎯 Goal
Create a basic chat interface with rooms.

## 📝 Tasks

### 1. Create app.rb

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

### 2. Create rooms view (views/rooms.erb)

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

### 3. Create chat view (views/chat.erb)

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
  
  function sendMessage() {
    // Will implement with WebSocket later
    console.log('Message sent');
  }
</script>
```

### 4. Add basic CSS (public/css/style.css)

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, sans-serif;
  line-height: 1.6;
  color: #333;
  background: #f5f5f5;
  padding: 2rem;
}

.rooms-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  max-width: 900px;
  margin: 2rem auto;
}

.room-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.room-card h3 {
  margin-bottom: 1rem;
}

.btn {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background: #2c3e50;
  color: white;
  text-decoration: none;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn:hover {
  background: #34495e;
}

.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}
```

## ✅ Checkpoint

Run the lab with:
```bash
make sinatra-lab NUM=4
```

Test that:
- [ ] App runs at http://localhost:4567
- [ ] Rooms list displays three rooms
- [ ] Can navigate to each room
- [ ] Chat interface displays with input fields
- [ ] Basic styling works

## 💡 What You Learned

- Setting up a basic Sinatra web application
- Creating views for rooms and chat interface
- Using ERB for dynamic content
- Passing parameters through routes
- Basic grid layout with CSS

## 🎯 Tips

- The Makefile automatically starts the WebSocket server for this lab
- Keep the chat interface simple—we'll add real functionality next
- Use semantic HTML for better structure
- Grid layout makes rooms responsive automatically

---

[Next Step →](../2/README.md)
