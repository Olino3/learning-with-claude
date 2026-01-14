# Step 2: Add Database with ActiveRecord

This step adds SQLite database connection using ActiveRecord.

## What's Included
- ActiveRecord database connection
- SQLite database file
- Health endpoint shows database status

## How to Run
```bash
ruby app.rb
```

## Test Endpoints
```bash
curl http://localhost:4567/api/v1/health
# Should show database: connected
```
