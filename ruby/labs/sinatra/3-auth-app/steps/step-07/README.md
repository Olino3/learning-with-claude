# Step 7: Remember Me

This step adds persistent sessions with remember tokens.

## What's Included
- Remember me checkbox on login
- Remember token stored in database
- 90-day persistent cookie
- Last login tracking
- Auto-login from cookie

## How to Run
```bash
ruby app.rb
```

## Test Remember Me
1. Login with "Remember me" checked
2. Close browser completely
3. Reopen and visit the app
4. You should still be logged in

## Access
Open http://localhost:4567 in your browser.
