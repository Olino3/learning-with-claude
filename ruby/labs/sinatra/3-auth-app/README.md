# Sinatra Lab 3: Web App with Authentication

A full-featured web application demonstrating user authentication, session management, and security best practices with Sinatra.

## 🎯 Learning Objectives

This lab demonstrates:
- **User Authentication**: Registration and login system
- **Password Security**: BCrypt password hashing
- **Session Management**: Cookie-based sessions
- **Protected Routes**: Authorization with before filters
- **User Profiles**: User account management
- **Remember Me**: Persistent login functionality
- **CSRF Protection**: Cross-site request forgery prevention
- **Flash Messages**: User feedback across requests
- **Form Validation**: Server-side validation
- **Security Best Practices**: Production-ready security patterns

## 📋 Project Structure

```
3-auth-app/
├── README.md (this file)
├── app.rb (main Sinatra application)
├── lib/
│   ├── models/
│   │   └── user.rb (user model with authentication)
│   └── auth_helpers.rb (authentication helper methods)
├── views/
│   ├── layout.erb (main layout with navigation)
│   ├── home.erb (public homepage)
│   ├── login.erb (login form)
│   ├── register.erb (registration form)
│   ├── dashboard.erb (authenticated user dashboard)
│   ├── profile.erb (user profile page)
│   └── edit_profile.erb (edit profile form)
└── public/
    └── css/
        └── style.css (application styles)
```

## 🚀 Running the Lab

```bash
# Install dependencies
gem install sinatra sequel sqlite3 bcrypt

# Run the application
cd ruby/labs/sinatra/3-auth-app
ruby app.rb

# Visit http://localhost:4567
```

## 🎓 Features Implemented

### 1. User Registration
- Email and password validation
- Unique email constraint
- Password strength requirements
- Automatic login after registration
- Welcome message

### 2. User Login
- Email and password authentication
- "Remember me" checkbox
- Secure session handling
- Failed login attempts tracking
- Redirect to intended page after login

### 3. Session Management
- Encrypted session cookies
- Session expiration
- Persistent sessions with "remember me"
- Secure logout

### 4. Protected Routes
- Before filters for authentication
- Authorization checks
- Redirect to login for unauthenticated users
- Store intended URL for post-login redirect

### 5. User Profile
- View profile information
- Edit profile (name, email)
- Change password
- Account statistics
- Profile completion indicator

### 6. Security Features
- BCrypt password hashing
- CSRF token validation
- XSS protection via HTML escaping
- SQL injection protection via ORM
- Secure session cookies
- Password complexity requirements

## 🔍 Application Routes

### Public Routes
```
GET    /                # Homepage
GET    /register        # Registration form
POST   /register        # Create new account
GET    /login           # Login form
POST   /login           # Authenticate user
GET    /logout          # Logout user
```

### Protected Routes (require authentication)
```
GET    /dashboard       # User dashboard
GET    /profile         # User profile
GET    /profile/edit    # Edit profile form
POST   /profile/edit    # Update profile
POST   /profile/password # Change password
```

## 📝 Example Usage

### Registration Flow
1. User visits `/register`
2. Fills out registration form (name, email, password)
3. Server validates input
4. Password is hashed with BCrypt
5. User account is created
6. User is automatically logged in
7. Redirected to dashboard

### Login Flow
1. User visits `/login`
2. Enters email and password
3. Server verifies credentials
4. If "remember me" is checked, create persistent session
5. Session is created
6. User is redirected to dashboard or intended page

### Protected Route Access
1. User tries to access `/dashboard` without login
2. Before filter checks authentication
3. User is redirected to `/login`
4. After successful login, user is redirected back to `/dashboard`

## 🐍 For Python Developers

This Sinatra authentication app compares to these Python frameworks:

### Flask-Login Equivalent
```python
from flask import Flask, render_template, redirect, url_for, flash, request
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'your-secret-key'

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user = User(
            email=request.form['email'],
            name=request.form['name']
        )
        user.password_hash = generate_password_hash(request.form['password'])
        db.session.add(user)
        db.session.commit()
        login_user(user)
        flash('Registration successful!', 'success')
        return redirect(url_for('dashboard'))
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = User.query.filter_by(email=request.form['email']).first()
        if user and check_password_hash(user.password_hash, request.form['password']):
            login_user(user, remember=request.form.get('remember'))
            next_page = request.args.get('next')
            return redirect(next_page or url_for('dashboard'))
        flash('Invalid credentials', 'error')
    return render_template('login.html')

@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html', user=current_user)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))
```

### Django Authentication Equivalent
```python
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.shortcuts import render, redirect
from django.contrib import messages

def register(request):
    if request.method == 'POST':
        user = User.objects.create_user(
            username=request.POST['email'],
            email=request.POST['email'],
            password=request.POST['password'],
            first_name=request.POST['name']
        )
        login(request, user)
        messages.success(request, 'Registration successful!')
        return redirect('dashboard')
    return render(request, 'register.html')

def login_view(request):
    if request.method == 'POST':
        user = authenticate(
            request,
            username=request.POST['email'],
            password=request.POST['password']
        )
        if user is not None:
            login(request, user)
            next_url = request.GET.get('next', 'dashboard')
            return redirect(next_url)
        messages.error(request, 'Invalid credentials')
    return render(request, 'login.html')

@login_required
def dashboard(request):
    return render(request, 'dashboard.html')

@login_required
def profile(request):
    if request.method == 'POST':
        request.user.first_name = request.POST['name']
        request.user.email = request.POST['email']
        request.user.save()
        messages.success(request, 'Profile updated!')
        return redirect('profile')
    return render(request, 'profile.html')

def logout_view(request):
    logout(request)
    return redirect('home')
```

### FastAPI with Sessions
```python
from fastapi import FastAPI, Depends, HTTPException, status, Request, Response
from fastapi.security import HTTPBasic, HTTPBasicCredentials
from fastapi.templating import Jinja2Templates
from starlette.middleware.sessions import SessionMiddleware
from passlib.context import CryptContext

app = FastAPI()
app.add_middleware(SessionMiddleware, secret_key="your-secret-key")

templates = Jinja2Templates(directory="templates")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_current_user(request: Request):
    user_id = request.session.get('user_id')
    if not user_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated"
        )
    return User.get(user_id)

@app.post("/register")
async def register(request: Request, email: str, password: str, name: str):
    hashed_password = pwd_context.hash(password)
    user = User.create(email=email, password_hash=hashed_password, name=name)
    request.session['user_id'] = user.id
    return {"message": "Registration successful"}

@app.post("/login")
async def login(request: Request, email: str, password: str, remember: bool = False):
    user = User.get_by_email(email)
    if not user or not pwd_context.verify(password, user.password_hash):
        raise HTTPException(status_code=400, detail="Invalid credentials")

    request.session['user_id'] = user.id
    if remember:
        request.session['permanent'] = True
    return {"message": "Login successful"}

@app.get("/dashboard")
async def dashboard(user: User = Depends(get_current_user)):
    return templates.TemplateResponse("dashboard.html", {"user": user})

@app.get("/logout")
async def logout(request: Request):
    request.session.clear()
    return {"message": "Logged out"}
```

### Key Differences
- **Sinatra**: Minimalist, manual session management, flexible
- **Flask-Login**: Similar approach with extension, more automated
- **Django**: Built-in auth system, very comprehensive
- **FastAPI**: Modern async approach, middleware-based sessions

## 📊 Database Schema

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_digest TEXT NOT NULL,
  name TEXT NOT NULL,
  remember_token TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login_at TIMESTAMP
);
```

## 🎯 Challenges

Try extending the application with:

1. **Email Verification**: Send confirmation email on registration
2. **Password Reset**: Forgot password functionality
3. **Two-Factor Authentication**: TOTP-based 2FA
4. **Social Login**: OAuth with Google, GitHub, etc.
5. **Account Lockout**: Lock account after failed login attempts
6. **Activity Log**: Track user login history
7. **Profile Pictures**: Upload and display avatars
8. **Email Notifications**: Send email on security events
9. **API Tokens**: Generate tokens for API access
10. **Admin Dashboard**: User management interface

## 📚 Concepts Covered

After completing this lab, you'll understand:

- **Authentication vs Authorization**: Difference and implementation
- **Session Management**: How cookies and sessions work
- **Password Security**: Proper password hashing with BCrypt
- **CSRF Protection**: Preventing cross-site attacks
- **Before Filters**: Route protection patterns
- **Flash Messages**: Cross-request messaging
- **Form Validation**: Server-side validation
- **Security Best Practices**: Production-ready security
- **User Experience**: Login flows and redirects

## 🔧 Technical Details

### Dependencies
- **sinatra**: Web framework (~> 3.0)
- **sequel**: ORM for database access (~> 5.0)
- **sqlite3**: Database driver (~> 1.6)
- **bcrypt**: Password hashing (~> 3.1)
- **rack-protection**: CSRF and security middleware

### Security Features
- BCrypt with cost factor of 12
- Secure session cookies with secret
- CSRF token validation
- HTML escaping in views
- SQL injection protection via ORM
- Password complexity requirements

### Session Management
- Cookie-based sessions
- Session expiration after 30 days
- "Remember me" for 90 days
- Secure flag in production
- HttpOnly flag to prevent XSS

---

Ready to build a secure web app? Run `ruby app.rb` and register your first user!
