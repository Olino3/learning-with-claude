require 'sinatra'
require 'sinatra/reloader' if development?
require 'securerandom'
require 'json'

configure do
  set :surveys_file, File.join(Dir.pwd, 'surveys.json')

  # Initialize surveys file
  unless File.exist?(settings.surveys_file)
    File.write(settings.surveys_file, '[]')
  end
end

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)

helpers do
  # CSRF Protection
  def csrf_token
    session[:csrf_token] ||= SecureRandom.hex(32)
  end

  def csrf_token_tag
    "<input type='hidden' name='csrf_token' value='#{csrf_token}'>"
  end

  def verify_csrf_token
    unless params[:csrf_token] == session[:csrf_token]
      halt 403, erb(:error, locals: { message: "Invalid CSRF token. Please try again." })
    end
  end

  # Survey data
  def load_surveys
    JSON.parse(File.read(settings.surveys_file), symbolize_names: true)
  end

  def save_survey(data)
    surveys = load_surveys
    surveys << data
    File.write(settings.surveys_file, JSON.pretty_generate(surveys))
  end

  # Validation
  def validate_survey
    errors = []

    if params[:name].to_s.strip.empty?
      errors << "Name is required"
    end

    if params[:email].to_s.strip.empty?
      errors << "Email is required"
    elsif params[:email] !~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      errors << "Email format is invalid"
    end

    unless params[:age_group]
      errors << "Please select an age group"
    end

    unless params[:experience]
      errors << "Please select your experience level"
    end

    if params[:rating].to_s.empty?
      errors << "Please provide a rating"
    end

    if params[:comments].to_s.length < 10
      errors << "Comments must be at least 10 characters"
    end

    unless params[:newsletter]
      errors << "You must agree to receive the newsletter (checkbox)"
    end

    errors
  end

  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end
end

# Show survey form
get '/' do
  erb :survey_form
end

# Handle survey submission
post '/submit' do
  verify_csrf_token

  errors = validate_survey

  if errors.empty?
    # Save survey data
    survey_data = {
      id: SecureRandom.uuid,
      name: params[:name],
      email: params[:email],
      age_group: params[:age_group],
      experience: params[:experience],
      technologies: params[:technologies] || [],
      rating: params[:rating].to_i,
      comments: params[:comments],
      newsletter: params[:newsletter] == 'on',
      submitted_at: Time.now.to_i
    }

    save_survey(survey_data)

    flash(:success, true)
    flash(:name, params[:name])
    redirect '/thank-you'
  else
    @errors = errors
    @params = params  # Preserve form data
    erb :survey_form
  end
end

# Thank you page
get '/thank-you' do
  redirect '/' unless get_flash(:success)
  @name = get_flash(:name)
  erb :thank_you
end

# View results (admin)
get '/results' do
  @surveys = load_surveys.reverse
  erb :results
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Developer Survey</title>
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
      max-width: 700px;
      margin: 0 auto;
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }

    h1 {
      color: #667eea;
      margin-bottom: 1rem;
      text-align: center;
    }

    .subtitle {
      text-align: center;
      color: #666;
      margin-bottom: 2rem;
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
    input[type="number"],
    textarea,
    select {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
      font-family: inherit;
    }

    textarea {
      resize: vertical;
      min-height: 100px;
    }

    input:focus,
    textarea:focus,
    select:focus {
      outline: none;
      border-color: #667eea;
    }

    .radio-group,
    .checkbox-group {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }

    .radio-item,
    .checkbox-item {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .radio-item input,
    .checkbox-item input {
      width: auto;
    }

    .rating-group {
      display: flex;
      gap: 0.5rem;
      justify-content: space-between;
    }

    .rating-item {
      flex: 1;
      text-align: center;
    }

    .rating-item input[type="radio"] {
      display: none;
    }

    .rating-item label {
      display: block;
      padding: 1rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      cursor: pointer;
      transition: all 0.3s;
    }

    .rating-item input:checked + label {
      background: #667eea;
      border-color: #667eea;
      color: white;
    }

    .rating-item label:hover {
      border-color: #667eea;
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
      text-align: center;
      padding: 2rem;
    }

    .success-box h2 {
      color: #060;
      margin-bottom: 1rem;
    }

    .success-box a {
      display: inline-block;
      margin-top: 1rem;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 5px;
    }

    .results-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
    }

    .results-table th,
    .results-table td {
      padding: 0.75rem;
      border: 1px solid #ddd;
      text-align: left;
    }

    .results-table th {
      background: #667eea;
      color: white;
    }

    .results-table tr:nth-child(even) {
      background: #f9f9f9;
    }
  </style>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@survey_form
<h1>Developer Survey 2026</h1>
<p class="subtitle">Help us understand the developer community better</p>

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

<form action="/submit" method="post">
  <%= csrf_token_tag %>

  <div class="form-group">
    <label for="name">Name <span class="required">*</span></label>
    <input type="text" id="name" name="name" value="<%= @params && @params[:name] %>" required>
  </div>

  <div class="form-group">
    <label for="email">Email <span class="required">*</span></label>
    <input type="email" id="email" name="email" value="<%= @params && @params[:email] %>" required>
  </div>

  <div class="form-group">
    <label>Age Group <span class="required">*</span></label>
    <div class="radio-group">
      <div class="radio-item">
        <input type="radio" id="age1" name="age_group" value="18-24" <%= 'checked' if @params && @params[:age_group] == '18-24' %>>
        <label for="age1">18-24</label>
      </div>
      <div class="radio-item">
        <input type="radio" id="age2" name="age_group" value="25-34" <%= 'checked' if @params && @params[:age_group] == '25-34' %>>
        <label for="age2">25-34</label>
      </div>
      <div class="radio-item">
        <input type="radio" id="age3" name="age_group" value="35-44" <%= 'checked' if @params && @params[:age_group] == '35-44' %>>
        <label for="age3">35-44</label>
      </div>
      <div class="radio-item">
        <input type="radio" id="age4" name="age_group" value="45+" <%= 'checked' if @params && @params[:age_group] == '45+' %>>
        <label for="age4">45+</label>
      </div>
    </div>
  </div>

  <div class="form-group">
    <label for="experience">Experience Level <span class="required">*</span></label>
    <select id="experience" name="experience" required>
      <option value="">Select...</option>
      <option value="beginner" <%= 'selected' if @params && @params[:experience] == 'beginner' %>>Beginner (0-2 years)</option>
      <option value="intermediate" <%= 'selected' if @params && @params[:experience] == 'intermediate' %>>Intermediate (3-5 years)</option>
      <option value="advanced" <%= 'selected' if @params && @params[:experience] == 'advanced' %>>Advanced (6-10 years)</option>
      <option value="expert" <%= 'selected' if @params && @params[:experience] == 'expert' %>>Expert (10+ years)</option>
    </select>
  </div>

  <div class="form-group">
    <label>Technologies You Use (check all that apply):</label>
    <div class="checkbox-group">
      <% techs = ['Ruby', 'Python', 'JavaScript', 'Go', 'Rust', 'Java'] %>
      <% selected_techs = @params && @params[:technologies] || [] %>
      <% techs.each do |tech| %>
        <div class="checkbox-item">
          <input type="checkbox" id="tech_<%= tech %>" name="technologies[]" value="<%= tech %>" <%= 'checked' if selected_techs.include?(tech) %>>
          <label for="tech_<%= tech %>"><%= tech %></label>
        </div>
      <% end %>
    </div>
  </div>

  <div class="form-group">
    <label>Rate Sinatra (1-5) <span class="required">*</span></label>
    <div class="rating-group">
      <% (1..5).each do |rating| %>
        <div class="rating-item">
          <input type="radio" id="rating_<%= rating %>" name="rating" value="<%= rating %>" <%= 'checked' if @params && @params[:rating].to_i == rating %>>
          <label for="rating_<%= rating %>"><%= rating %></label>
        </div>
      <% end %>
    </div>
  </div>

  <div class="form-group">
    <label for="comments">Comments <span class="required">*</span></label>
    <textarea id="comments" name="comments" required><%= @params && @params[:comments] %></textarea>
  </div>

  <div class="form-group">
    <div class="checkbox-item">
      <input type="checkbox" id="newsletter" name="newsletter" <%= 'checked' if @params && @params[:newsletter] %>>
      <label for="newsletter">Subscribe to newsletter <span class="required">*</span></label>
    </div>
  </div>

  <button type="submit">Submit Survey</button>
</form>

<p style="text-align: center; margin-top: 1rem; color: #666;">
  <a href="/results" style="color: #667eea;">View Results</a>
</p>

@@thank_you
<div class="success-box">
  <h2>✓ Thank You!</h2>
  <p>Thank you, <strong><%= @name %></strong>, for completing our survey!</p>
  <p>Your feedback helps us improve the developer experience.</p>
  <a href="/">Take Another Survey</a>
  <a href="/results" style="margin-left: 1rem;">View Results</a>
</div>

@@results
<h1>Survey Results</h1>
<p class="subtitle">Total responses: <%= @surveys.length %></p>

<% if @surveys.empty? %>
  <p style="text-align: center; padding: 2rem; color: #666;">
    No survey responses yet.
  </p>
<% else %>
  <table class="results-table">
    <thead>
      <tr>
        <th>Name</th>
        <th>Age Group</th>
        <th>Experience</th>
        <th>Technologies</th>
        <th>Rating</th>
        <th>Date</th>
      </tr>
    </thead>
    <tbody>
      <% @surveys.each do |survey| %>
        <tr>
          <td><%= survey[:name] %></td>
          <td><%= survey[:age_group] %></td>
          <td><%= survey[:experience] %></td>
          <td><%= survey[:technologies].join(', ') %></td>
          <td><%= survey[:rating] %>/5</td>
          <td><%= Time.at(survey[:submitted_at]).strftime('%m/%d/%Y') %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
<% end %>

<p style="text-align: center; margin-top: 2rem;">
  <a href="/" style="color: #667eea;">Back to Survey</a>
</p>

@@error
<div class="errors">
  <h2>Error</h2>
  <p><%= message %></p>
  <p style="margin-top: 1rem;">
    <a href="/" style="color: #c00;">Go Back</a>
  </p>
</div>
