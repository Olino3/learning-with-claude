# Step 5: Message Broadcasting

This step adds message persistence and proper broadcasting.

## What's Included
- Messages saved to SQLite database
- Real-time broadcast to all room members
- Message history loads on join
- Polling for missed messages

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
1. Open two browser windows
2. Join the same room in both
3. Send messages - they appear in both windows!
4. Refresh - messages persist

## Access
Open http://localhost:4567 in your browser.
