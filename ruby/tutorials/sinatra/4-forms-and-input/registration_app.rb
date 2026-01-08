require 'sinatra'
require 'sinatra/reloader' if development?
require 'bcrypt'

enable :sessions

helpers do
  def validate_username(username)
    errors = []
    if username.to_s.empty?
      errors << "Username is required"
    elsif username.length < 3
      errors << "Username must be at least 3 characters"
    elsif username.length > 20
      errors << "Username must be less than 20 characters"
    elsif username !~ /^[a-zA-Z0-9_]+$/
      errors << "Username can only contain letters, numbers, and underscores"
    end
    errors
  end

  def validate_email(email)
    errors = []
    if email.to_s.empty?
      errors << "Email is required"
    elsif email !~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      errors << "Email format is invalid"
    end
    errors
  end

  def validate_password(password)
    errors = []
    if password.to_s.empty?
      errors << "Password is required"
    elsif password.length < 8
      errors << "Password must be at least 8 characters"
    elsif password !~ /[A-Z]/
      errors << "Password must contain at least one uppercase letter"
    elsif password !~ /[a-z]/
      errors << "Password must contain at least one lowercase letter"
    elsif password !~ /[0-9]/
      errors << "Password must contain at least one number"
    end
    errors
  end

  def password_strength(password)
    score = 0
    score += 1 if password.length >= 8
    score += 1 if password.length >= 12
    score += 1 if password =~ /[A-Z]/
    score += 1 if password =~ /[a-z]/
    score += 1 if password =~ /[0-9]/
    score += 1 if password =~ /[^A-Za-z0-9]/

    case score
    when 0..2 then 'weak'
    when 3..4 then 'medium'
    else 'strong'
    end
  end

  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end
end

# Show registration form
get '/' do
  erb :register_form
end

# Handle registration
post '/register' do
  errors = []

  # Validate all fields
  errors += validate_username(params[:username])
  errors += validate_email(params[:email])
  errors += validate_password(params[:password])

  # Check password confirmation
  if params[:password] != params[:password_confirmation]
    errors << "Passwords don't match"
  end

  # Check terms acceptance
  unless params[:terms] == 'on'
    errors << "You must accept the terms and conditions"
  end

  if errors.empty?
    # In a real app, save to database
    username = params[:username]
    email = params[:email]
    password_hash = BCrypt::Password.create(params[:password])

    puts "\n" + "="*50
    puts "New User Registration:"
    puts "Username: #{username}"
    puts "Email: #{email}"
    puts "Password Hash: #{password_hash}"
    puts "="*50 + "\n"

    flash(:success, "Welcome, #{username}! Your account has been created.")
    redirect '/success'
  else
    @errors = errors
    @username = params[:username]
    @email = params[:email]
    erb :register_form
  end
end

get '/success' do
  @message = get_flash(:success)
  redirect '/' unless @message
  erb :success
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>User Registration</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }

    .container {
      max-width: 500px;
      margin: 0 auto;
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }

    h1 {
      color: #667eea;
      margin-bottom: 1.5rem;
      text-align: center;
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 600;
      color: #555;
    }

    input[type="text"],
    input[type="email"],
    input[type="password"] {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
    }

    input:focus {
      outline: none;
      border-color: #667eea;
    }

    .password-strength {
      margin-top: 0.5rem;
      padding: 0.5rem;
      border-radius: 3px;
      font-size: 0.875rem;
      font-weight: 600;
    }

    .strength-weak {
      background: #fee;
      color: #c00;
    }

    .strength-medium {
      background: #ffc;
      color: #c90;
    }

    .strength-strong {
      background: #efe;
      color: #060;
    }

    .checkbox-group {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .checkbox-group input {
      width: auto;
    }

    button {
      width: 100%;
      padding: 1rem;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
    }

    button:hover {
      transform: translateY(-2px);
    }

    .errors {
      background: #fee;
      border: 2px solid #fcc;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .errors h3 {
      color: #c00;
      margin-bottom: 0.5rem;
    }

    .errors ul {
      margin-left: 1.5rem;
      color: #c00;
    }

    .required {
      color: #c00;
    }

    .success-box {
      background: #efe;
      border: 2px solid #cfc;
      padding: 2rem;
      border-radius: 5px;
      text-align: center;
    }

    .success-box h2 {
      color: #060;
      margin-bottom: 1rem;
    }

    .success-box a {
      display: inline-block;
      margin-top: 1rem;
      padding: 0.75rem 1.5rem;
      background: #060;
      color: white;
      text-decoration: none;
      border-radius: 5px;
    }

    .help-text {
      font-size: 0.875rem;
      color: #666;
      margin-top: 0.25rem;
    }
  </style>
  <script>
    function checkPasswordStrength() {
      const password = document.getElementById('password').value;
      const strengthDiv = document.getElementById('strength');

      if (!password) {
        strengthDiv.style.display = 'none';
        return;
      }

      let score = 0;
      if (password.length >= 8) score++;
      if (password.length >= 12) score++;
      if (/[A-Z]/.test(password)) score++;
      if (/[a-z]/.test(password)) score++;
      if (/[0-9]/.test(password)) score++;
      if (/[^A-Za-z0-9]/.test(password)) score++;

      strengthDiv.style.display = 'block';

      if (score <= 2) {
        strengthDiv.className = 'password-strength strength-weak';
        strengthDiv.textContent = 'Password strength: Weak';
      } else if (score <= 4) {
        strengthDiv.className = 'password-strength strength-medium';
        strengthDiv.textContent = 'Password strength: Medium';
      } else {
        strengthDiv.className = 'password-strength strength-strong';
        strengthDiv.textContent = 'Password strength: Strong';
      }
    }
  </script>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@register_form
<h1>Create Account</h1>

<% if @errors %>
  <div class="errors">
    <h3>Please fix the following errors:</h3>
    <ul>
      <% @errors.each do |error| %>
        <li><%= error %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<form action="/register" method="post">
  <div class="form-group">
    <label for="username">Username <span class="required">*</span></label>
    <input type="text" id="username" name="username" value="<%= @username %>" required>
    <div class="help-text">3-20 characters, letters, numbers, and underscores only</div>
  </div>

  <div class="form-group">
    <label for="email">Email <span class="required">*</span></label>
    <input type="email" id="email" name="email" value="<%= @email %>" required>
  </div>

  <div class="form-group">
    <label for="password">Password <span class="required">*</span></label>
    <input type="password" id="password" name="password" required oninput="checkPasswordStrength()">
    <div id="strength" class="password-strength" style="display: none;"></div>
    <div class="help-text">At least 8 characters with uppercase, lowercase, and numbers</div>
  </div>

  <div class="form-group">
    <label for="password_confirmation">Confirm Password <span class="required">*</span></label>
    <input type="password" id="password_confirmation" name="password_confirmation" required>
  </div>

  <div class="form-group">
    <div class="checkbox-group">
      <input type="checkbox" id="terms" name="terms">
      <label for="terms">I accept the terms and conditions <span class="required">*</span></label>
    </div>
  </div>

  <button type="submit">Create Account</button>
</form>

@@success
<div class="success-box">
  <h2>✓ Registration Successful!</h2>
  <p><%= @message %></p>
  <a href="/">Back to Home</a>
</div>
