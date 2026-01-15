# Step 8: User Profiles (Complete)

This is the complete Auth App with profile management.

## What's Included
- Profile viewing and editing
- Password change functionality
- CSRF protection on forms
- Enhanced dashboard with stats
- Error handling pages
- Full security features

## How to Run
```bash
ruby app.rb
```

## Test Profile Features
1. Login to your account
2. Visit http://localhost:4567/profile
3. Click "Edit Profile" to update your info
4. Try changing your password

## Routes
- `GET /` - Home page
- `GET /register` - Registration form
- `POST /register` - Create account
- `GET /login` - Login form
- `POST /login` - Authenticate
- `GET /logout` - Logout
- `GET /dashboard` - User dashboard
- `GET /profile` - User profile
- `GET /profile/edit` - Edit profile form
- `POST /profile/edit` - Update profile
- `POST /profile/password` - Change password

## Access
Open http://localhost:4567 in your browser.
