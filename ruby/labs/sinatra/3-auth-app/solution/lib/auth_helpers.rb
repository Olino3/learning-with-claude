# frozen_string_literal: true

require 'securerandom'

# Authentication helper methods
#
# Provides session-based authentication for Sinatra applications.
# Handles login, logout, and current user management.
#
# For Python developers:
# - Similar to Flask-Login's login_user, logout_user, current_user
# - Django's request.user and login/logout functions
# - FastAPI's session-based authentication

module AuthHelpers
  # Get the current logged-in user
  #
  # @return [User, nil] the current user or nil if not logged in
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = nil

    # Check session for user_id
    if session[:user_id]
      @current_user = User[session[:user_id]]
    elsif request.cookies['remember_token']
      # Check remember me cookie
      user = User.find(remember_token: request.cookies['remember_token'])
      if user
        session[:user_id] = user.id
        @current_user = user
      end
    end

    @current_user
  end

  # Check if user is authenticated
  #
  # @return [Boolean] true if user is logged in
  def authenticated?
    !current_user.nil?
  end

  # Login a user
  #
  # @param user [User] the user to log in
  # @param remember [Boolean] whether to create a persistent session
  def login(user, remember: false)
    session[:user_id] = user.id
    @current_user = user

    if remember
      token = user.generate_remember_token
      response.set_cookie 'remember_token', 
        value: token,
        expires: Time.now + (90 * 24 * 60 * 60), # 90 days
        httponly: true,
        secure: production?
    end
  end

  # Logout the current user
  def logout
    if current_user
      current_user.clear_remember_token
    end

    session.delete(:user_id)
    response.delete_cookie('remember_token')
    @current_user = nil
  end

  # Require authentication (use in routes)
  def require_authentication!
    return if authenticated?

    session[:return_to] = request.path_info
    flash[:warning] = 'Please log in to access this page.'
    redirect '/login'
  end

  # Require no authentication (redirect if logged in)
  def require_no_authentication!
    redirect '/dashboard' if authenticated?
  end

  # Check if current user is the owner of a resource
  #
  # @param resource [Object] object with user_id attribute
  # @return [Boolean] true if current user owns the resource
  def authorized?(resource)
    return false unless authenticated?
    return false unless resource.respond_to?(:user_id)

    current_user.id == resource.user_id
  end

  # Flash message helpers
  def flash
    @flash ||= session.delete(:flash) || {}
  end

  def flash=(message)
    session[:flash] = message
  end

  # Check if running in production
  def production?
    ENV['RACK_ENV'] == 'production'
  end

  # HTML escape helper
  def h(text)
    Rack::Utils.escape_html(text)
  end

  # Format date in a human-readable way
  def format_date(datetime)
    return '' unless datetime
    datetime.strftime('%B %d, %Y at %I:%M %p')
  end

  # Get relative time (e.g., "2 days ago")
  def time_ago_in_words(datetime)
    return '' unless datetime

    diff = Time.now - datetime
    case diff
    when 0..59
      'just now'
    when 60..3599
      "#{(diff / 60).to_i} minutes ago"
    when 3600..86399
      "#{(diff / 3600).to_i} hours ago"
    when 86400..2591999
      "#{(diff / 86400).to_i} days ago"
    else
      format_date(datetime)
    end
  end
end

=begin

Python equivalents:

# Flask-Login
from flask_login import (
    LoginManager, UserMixin, login_user, logout_user,
    login_required, current_user
)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route('/login', methods=['POST'])
def login():
    user = User.query.filter_by(email=request.form['email']).first()
    if user and user.check_password(request.form['password']):
        remember = request.form.get('remember') == 'on'
        login_user(user, remember=remember)
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))

@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html', user=current_user)

# Django
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

def login_view(request):
    if request.method == 'POST':
        user = authenticate(
            username=request.POST['email'],
            password=request.POST['password']
        )
        if user:
            login(request, user)
            return redirect('dashboard')
    return render(request, 'login.html')

@login_required
def dashboard(request):
    return render(request, 'dashboard.html', {'user': request.user})

def logout_view(request):
    logout(request)
    return redirect('home')

# FastAPI with sessions
from fastapi import Depends, HTTPException, Request
from starlette.middleware.sessions import SessionMiddleware

app.add_middleware(SessionMiddleware, secret_key="secret")

def get_current_user(request: Request):
    user_id = request.session.get('user_id')
    if not user_id:
        raise HTTPException(status_code=401, detail="Not authenticated")
    return User.get(user_id)

@app.post("/login")
async def login(request: Request, email: str, password: str):
    user = authenticate(email, password)
    if user:
        request.session['user_id'] = user.id
        return {"message": "Logged in"}
    raise HTTPException(status_code=400, detail="Invalid credentials")

@app.get("/dashboard")
async def dashboard(user: User = Depends(get_current_user)):
    return {"user": user.to_dict()}

@app.get("/logout")
async def logout(request: Request):
    request.session.clear()
    return {"message": "Logged out"}

=end
