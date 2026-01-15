# Step 2: Add Database

This step adds SQLite database for rooms and messages.

## What's Included
- Sequel ORM setup
- Rooms table with name and description
- Messages table with room_id, username, content
- Default rooms seeded
- API endpoint to fetch messages

## How to Run
```bash
ruby app.rb
```

## Test API
```bash
# Get messages for a room
curl http://localhost:4567/api/rooms/general/messages
```

## Access
Open http://localhost:4567 in your browser.
