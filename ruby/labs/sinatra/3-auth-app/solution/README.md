# Authentication Web App - Complete Solution

This folder contains the complete working solution for the Authentication Web App lab.

## Prerequisites
- Docker environment running (`make up-docker`)

## How to Run

```bash
# From the repository root
make sinatra-lab NUM=3
```

Or manually:
```bash
docker compose exec ruby-env bash
cd ruby/labs/sinatra/3-auth-app/solution
ruby app.rb -o 0.0.0.0
```

## Access
Open http://localhost:4567 in your browser.

## Features
- User registration with email validation
- BCrypt password hashing
- Session-based authentication
- Remember me with persistent cookies
- Protected routes with authorization helpers
- User profile management
- Password change functionality
- CSRF protection
- Flash messages

## Test Accounts
Register a new account to get started. The app creates a fresh database on first run.

## Routes
- `GET /` - Home page
- `GET /register` - Registration form
- `POST /register` - Create account
- `GET /login` - Login form
- `POST /login` - Authenticate
- `GET /logout` - Logout
- `GET /dashboard` - User dashboard (protected)
- `GET /profile` - User profile (protected)
- `GET /profile/edit` - Edit profile form (protected)
- `POST /profile/edit` - Update profile (protected)
- `POST /profile/password` - Change password (protected)
