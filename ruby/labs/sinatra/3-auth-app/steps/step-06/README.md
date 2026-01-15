# Step 6: Protected Routes

This step adds authorization helpers and protected routes.

## What's Included
- `require_login` helper for route protection
- Before filters to protect routes
- Return-to URL after login
- Profile page (protected)
- Warning flash messages

## How to Run
```bash
ruby app.rb
```

## Test Protected Routes
1. Try accessing http://localhost:4567/dashboard without logging in
2. You'll be redirected to login with a warning message
3. After login, you'll be redirected back to dashboard

## Access
Open http://localhost:4567 in your browser.
