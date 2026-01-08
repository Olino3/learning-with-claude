require 'sinatra'
require 'sinatra/reloader' if development?

# Enable sessions for flash messages
enable :sessions

helpers do
  def validate_required(*fields)
    errors = []
    fields.each do |field|
      if params[field].to_s.strip.empty?
        errors << "#{field.to_s.capitalize.gsub('_', ' ')} is required"
      end
    end
    errors
  end

  def validate_email(email)
    email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    email =~ email_regex
  end

  def sanitize(input)
    # Remove HTML tags and dangerous characters
    input.to_s.gsub(/<[^>]*>/, '').strip
  end

  def flash_message
    message = session.delete(:flash_message)
    message
  end

  def flash_errors
    errors = session.delete(:flash_errors)
    errors
  end
end

# Home page - show contact form
get '/' do
  erb :contact_form
end

# Handle form submission
post '/contact' do
  errors = []

  # Validate required fields
  errors += validate_required(:name, :email, :subject, :message)

  # Validate email format
  if params[:email] && !params[:email].empty?
    unless validate_email(params[:email])
      errors << "Email format is invalid"
    end
  end

  # Validate message length
  if params[:message].to_s.length < 10
    errors << "Message must be at least 10 characters long"
  end

  if errors.empty?
    # In a real app, you would send an email or save to database
    name = sanitize(params[:name])
    email = sanitize(params[:email])
    subject = sanitize(params[:subject])
    message = sanitize(params[:message])

    puts "\n" + "="*50
    puts "Contact Form Submission:"
    puts "From: #{name} (#{email})"
    puts "Subject: #{subject}"
    puts "Message: #{message}"
    puts "="*50 + "\n"

    session[:flash_message] = "Thank you, #{name}! Your message has been sent successfully."
    redirect '/success'
  else
    session[:flash_errors] = errors
    redirect '/'
  end
end

# Success page
get '/success' do
  @message = flash_message
  redirect '/' unless @message
  erb :success
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Contact Form Demo</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }

    .container {
      max-width: 600px;
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
    textarea {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
      transition: border-color 0.3s;
    }

    input:focus,
    textarea:focus {
      outline: none;
      border-color: #667eea;
    }

    textarea {
      resize: vertical;
      min-height: 120px;
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
      transition: transform 0.2s;
    }

    button:hover {
      transform: translateY(-2px);
    }

    .errors {
      background: #fee;
      border: 2px solid #fcc;
      border-radius: 5px;
      padding: 1rem;
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

    .success-message {
      background: #efe;
      border: 2px solid #cfc;
      border-radius: 5px;
      padding: 1.5rem;
      text-align: center;
      color: #060;
    }

    .success-message h2 {
      color: #060;
      margin-bottom: 1rem;
    }

    .success-message a {
      display: inline-block;
      margin-top: 1rem;
      padding: 0.75rem 1.5rem;
      background: #060;
      color: white;
      text-decoration: none;
      border-radius: 5px;
    }

    .required {
      color: #c00;
    }
  </style>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@contact_form
<h1>Contact Us</h1>

<% if errors = flash_errors %>
  <div class="errors">
    <h3>Please fix the following errors:</h3>
    <ul>
      <% errors.each do |error| %>
        <li><%= error %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<form action="/contact" method="post">
  <div class="form-group">
    <label for="name">Name <span class="required">*</span></label>
    <input type="text" id="name" name="name" value="<%= params[:name] %>">
  </div>

  <div class="form-group">
    <label for="email">Email <span class="required">*</span></label>
    <input type="email" id="email" name="email" value="<%= params[:email] %>">
  </div>

  <div class="form-group">
    <label for="subject">Subject <span class="required">*</span></label>
    <input type="text" id="subject" name="subject" value="<%= params[:subject] %>">
  </div>

  <div class="form-group">
    <label for="message">Message <span class="required">*</span></label>
    <textarea id="message" name="message"><%= params[:message] %></textarea>
  </div>

  <button type="submit">Send Message</button>
</form>

@@success
<div class="success-message">
  <h2>✓ Success!</h2>
  <p><%= @message %></p>
  <a href="/">Send Another Message</a>
</div>
