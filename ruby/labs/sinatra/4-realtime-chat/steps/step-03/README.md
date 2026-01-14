# Step 3: WebSocket Server

This step adds the basic WebSocket server using Faye-WebSocket.

## What's Included
- Faye-WebSocket server with EventMachine
- Basic connection handling
- Message echo to all clients

## How to Run

**Terminal 1 - WebSocket Server:**
```bash
ruby chat_server.rb
```

**Terminal 2 - Web App:**
```bash
ruby app.rb
```

## Test WebSocket
You can test with a WebSocket client or browser console:
```javascript
let ws = new WebSocket('ws://localhost:9292');
ws.onmessage = (e) => console.log(e.data);
ws.send(JSON.stringify({type: 'test', message: 'hello'}));
```

## Access
Open http://localhost:4567 in your browser.
