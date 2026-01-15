# Step 6: Multiple Rooms

This step adds proper room management and switching.

## What's Included
- Username required before joining
- Room switching support
- Join/leave notifications
- Create new rooms via API
- Room message counts

## How to Run

**Terminal 1:**
```bash
ruby chat_server.rb
```

**Terminal 2:**
```bash
ruby app.rb
```

## Test
1. Enter username on home page
2. Select a room to join
3. Open another browser, enter different username
4. Both see join/leave notifications

## Create New Room
```bash
curl -X POST http://localhost:4567/api/rooms \
  -H "Content-Type: application/json" \
  -d '{"name":"newroom","description":"A new room"}'
```

## Access
Open http://localhost:4567 in your browser.
