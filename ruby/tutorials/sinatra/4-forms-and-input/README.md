# Tutorial 4: Forms and User Input - Processing Data Safely

Learn how to handle form submissions, process user input, validate data, handle file uploads, and protect against CSRF attacks in Sinatra.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Handle POST requests and form data
- Process different input types (text, files, checkboxes)
- Validate user input
- Upload and handle files
- Implement CSRF protection
- Handle multi-part form data
- Work with nested parameters

## 🐍➡️🔴 Coming from Flask/WTForms

Form handling in Sinatra is more manual than Flask's WTForms, but also more flexible:

| Feature | Flask/WTForms | Sinatra |
|---------|--------------|---------|
| Form data access | `request.form['name']` | `params[:name]` |
| File upload | `request.files['file']` | `params[:file]` |
| CSRF protection | `FlaskForm` + `csrf_token()` | `rack-protection` gem |
| Validation | `wtforms.validators` | Manual or `sinatra/validation` |
| Multi-value fields | `request.form.getlist()` | `params[:field]` (array) |
| JSON data | `request.get_json()` | `JSON.parse(request.body.read)` |

## 📝 Basic Form Handling

### Simple Form

**views/contact_form.erb:**
```erb
<form action="/contact" method="post">
  <div>
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required>
  </div>

  <div>
    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>
  </div>

  <div>
    <label for="message">Message:</label>
    <textarea id="message" name="message" rows="5" required></textarea>
  </div>

  <button type="submit">Send Message</button>
</form>
```

**app.rb:**
```ruby
require 'sinatra'

get '/contact' do
  erb :contact_form
end

post '/contact' do
  name = params[:name]
  email = params[:email]
  message = params[:message]

  # Process the form data
  puts "Received message from #{name} (#{email}): #{message}"

  @success = "Thank you, #{name}! Your message has been sent."
  erb :contact_success
end
```

### 🐍 Flask Comparison

**Flask:**
```python
from flask import Flask, request, render_template

@app.route('/contact', methods=['GET'])
def contact_form():
    return render_template('contact_form.html')

@app.route('/contact', methods=['POST'])
def contact_submit():
    name = request.form['name']
    email = request.form['email']
    message = request.form['message']

    return render_template('contact_success.html', name=name)
```

**Sinatra:**
```ruby
get '/contact' do
  erb :contact_form
end

post '/contact' do
  @name = params[:name]
  erb :contact_success
end
```

## 🔍 Accessing Form Data

### The `params` Hash

All form data is available in the `params` hash:

```ruby
post '/user' do
  # Text input
  name = params[:name]

  # Email input
  email = params[:email]

  # Checkbox (present if checked, nil if not)
  newsletter = params[:newsletter]  # "on" or nil

  # Radio buttons
  gender = params[:gender]

  # Select dropdown
  country = params[:country]

  # Hidden field
  user_id = params[:user_id]

  # All params
  p params  # Hash of all form data
end
```

### Multiple Values (Checkboxes)

**Form:**
```erb
<form action="/preferences" method="post">
  <fieldset>
    <legend>Interests:</legend>
    <label>
      <input type="checkbox" name="interests[]" value="sports">
      Sports
    </label>
    <label>
      <input type="checkbox" name="interests[]" value="music">
      Music
    </label>
    <label>
      <input type="checkbox" name="interests[]" value="reading">
      Reading
    </label>
  </fieldset>
  <button type="submit">Save</button>
</form>
```

**Handler:**
```ruby
post '/preferences' do
  interests = params[:interests]  # Array: ["sports", "music"]

  if interests
    @message = "You selected: #{interests.join(', ')}"
  else
    @message = "No interests selected"
  end

  erb :preferences_saved
end
```

## ✅ Input Validation

### Manual Validation

```ruby
post '/register' do
  errors = []

  # Required fields
  errors << "Name is required" if params[:name].to_s.empty?
  errors << "Email is required" if params[:email].to_s.empty?

  # Email format
  unless params[:email] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    errors << "Email format is invalid"
  end

  # Password length
  if params[:password].to_s.length < 8
    errors << "Password must be at least 8 characters"
  end

  # Password confirmation
  if params[:password] != params[:password_confirmation]
    errors << "Passwords don't match"
  end

  if errors.empty?
    # Process registration
    @message = "Registration successful!"
    erb :registration_success
  else
    @errors = errors
    @name = params[:name]
    @email = params[:email]
    erb :register_form
  end
end
```

### Using Sinatra Validation Helper

```ruby
require 'sinatra'
require 'sinatra/validation'

post '/user' do
  # Validate presence
  validate_presence :name, :email

  # Validate format
  validate_format :email, /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Validate length
  validate_length :password, min: 8, max: 100

  # Custom validation
  validate :age do |value|
    value.to_i >= 18
  end

  if valid?
    # Process the data
    erb :success
  else
    @errors = errors
    erb :form
  end
end
```

### Validation Helper Methods

```ruby
helpers do
  def validate_required(*fields)
    errors = []
    fields.each do |field|
      if params[field].to_s.strip.empty?
        errors << "#{field.to_s.capitalize} is required"
      end
    end
    errors
  end

  def validate_email(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end

  def validate_length(field, min: 0, max: Float::INFINITY)
    value = params[field].to_s
    value.length >= min && value.length <= max
  end

  def sanitize(input)
    # Remove HTML tags and dangerous characters
    input.to_s.gsub(/<[^>]*>/, '').strip
  end
end

post '/comment' do
  errors = validate_required(:name, :email, :comment)
  errors << "Invalid email" unless validate_email(params[:email])
  errors << "Comment too short" unless validate_length(:comment, min: 10)

  if errors.empty?
    @name = sanitize(params[:name])
    @comment = sanitize(params[:comment])
    erb :comment_posted
  else
    @errors = errors
    erb :comment_form
  end
end
```

## 🐍 Flask Validation Comparison

**Flask with WTForms:**
```python
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField
from wtforms.validators import DataRequired, Email, Length

class RegistrationForm(FlaskForm):
    name = StringField('Name', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[
        DataRequired(), Length(min=8)
    ])
```

**Sinatra (Manual):**
```ruby
post '/register' do
  errors = []
  errors << "Name required" if params[:name].to_s.empty?
  errors << "Invalid email" unless params[:email] =~ /@/
  errors << "Password too short" if params[:password].to_s.length < 8

  # Handle errors or process
end
```

## 📤 File Uploads

### Basic File Upload

**views/upload_form.erb:**
```erb
<form action="/upload" method="post" enctype="multipart/form-data">
  <div>
    <label for="file">Choose file:</label>
    <input type="file" id="file" name="file" required>
  </div>

  <div>
    <label for="description">Description:</label>
    <input type="text" id="description" name="description">
  </div>

  <button type="submit">Upload</button>
</form>
```

**app.rb:**
```ruby
require 'sinatra'
require 'fileutils'

post '/upload' do
  if params[:file]
    file = params[:file]

    # File properties
    filename = file[:filename]
    tempfile = file[:tempfile]
    content_type = file[:type]

    # Save file
    upload_dir = File.join('public', 'uploads')
    FileUtils.mkdir_p(upload_dir)

    filepath = File.join(upload_dir, filename)
    File.open(filepath, 'wb') do |f|
      f.write(tempfile.read)
    end

    @message = "File '#{filename}' uploaded successfully!"
    @filepath = "/uploads/#{filename}"
  else
    @error = "No file selected"
  end

  erb :upload_result
end
```

### Secure File Upload with Validation

```ruby
require 'sinatra'
require 'fileutils'
require 'securerandom'

configure do
  set :upload_dir, File.join(Dir.pwd, 'public', 'uploads')
  set :max_file_size, 5 * 1024 * 1024  # 5 MB
  set :allowed_extensions, %w[.jpg .jpeg .png .gif .pdf .txt]
end

helpers do
  def validate_file(file)
    errors = []

    # Check if file exists
    return ["No file provided"] unless file

    # Check file size
    size = file[:tempfile].size
    if size > settings.max_file_size
      errors << "File too large (max 5MB)"
    end

    # Check file extension
    ext = File.extname(file[:filename]).downcase
    unless settings.allowed_extensions.include?(ext)
      errors << "File type not allowed. Allowed: #{settings.allowed_extensions.join(', ')}"
    end

    # Check for null bytes (security)
    if file[:filename].include?("\x00")
      errors << "Invalid filename"
    end

    errors
  end

  def secure_filename(filename)
    # Generate unique filename
    ext = File.extname(filename)
    basename = File.basename(filename, ext)
    timestamp = Time.now.to_i
    random = SecureRandom.hex(8)
    "#{basename}_#{timestamp}_#{random}#{ext}"
  end
end

post '/upload' do
  file = params[:file]
  errors = validate_file(file)

  if errors.empty?
    # Create upload directory
    FileUtils.mkdir_p(settings.upload_dir)

    # Generate secure filename
    secure_name = secure_filename(file[:filename])
    filepath = File.join(settings.upload_dir, secure_name)

    # Save file
    File.open(filepath, 'wb') do |f|
      f.write(file[:tempfile].read)
    end

    @message = "File uploaded successfully!"
    @filename = secure_name
    @url = "/uploads/#{secure_name}"
    erb :upload_success
  else
    @errors = errors
    erb :upload_form
  end
end
```

### Multiple File Uploads

```erb
<form action="/upload-multiple" method="post" enctype="multipart/form-data">
  <div>
    <label for="files">Choose files:</label>
    <input type="file" id="files" name="files[]" multiple required>
  </div>
  <button type="submit">Upload All</button>
</form>
```

```ruby
post '/upload-multiple' do
  files = params[:files]
  uploaded = []
  errors = []

  if files.is_a?(Array)
    files.each do |file|
      file_errors = validate_file(file)

      if file_errors.empty?
        secure_name = secure_filename(file[:filename])
        filepath = File.join(settings.upload_dir, secure_name)

        File.open(filepath, 'wb') do |f|
          f.write(file[:tempfile].read)
        end

        uploaded << secure_name
      else
        errors << "#{file[:filename]}: #{file_errors.join(', ')}"
      end
    end
  end

  @uploaded = uploaded
  @errors = errors
  erb :upload_multiple_result
end
```

## 🐍 Flask File Upload Comparison

**Flask:**
```python
from werkzeug.utils import secure_filename

@app.route('/upload', methods=['POST'])
def upload():
    if 'file' not in request.files:
        return 'No file'

    file = request.files['file']
    filename = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
    return 'Uploaded'
```

**Sinatra:**
```ruby
post '/upload' do
  file = params[:file]
  filename = secure_filename(file[:filename])

  File.open(File.join(settings.upload_dir, filename), 'wb') do |f|
    f.write(file[:tempfile].read)
  end

  'Uploaded'
end
```

## 🛡️ CSRF Protection

### Using Rack Protection

Sinatra includes basic CSRF protection via `rack-protection`:

```ruby
require 'sinatra'
require 'rack/protection'

# Enable CSRF protection (enabled by default in Sinatra)
set :protection, :except => []  # Enable all protections

# Or configure specific protections
set :protection, :except => [:json_csrf]

get '/form' do
  erb :form
end

post '/submit' do
  # Automatically protected against CSRF
  @message = "Form submitted successfully!"
  erb :success
end
```

### Using session-based CSRF tokens

```ruby
require 'sinatra'
require 'securerandom'

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || SecureRandom.hex(64)

helpers do
  def csrf_token
    session[:csrf_token] ||= SecureRandom.hex(32)
  end

  def csrf_token_tag
    "<input type='hidden' name='csrf_token' value='#{csrf_token}'>"
  end

  def verify_csrf_token
    halt 403, "Invalid CSRF token" unless params[:csrf_token] == session[:csrf_token]
  end
end

get '/form' do
  erb :protected_form
end

post '/submit' do
  verify_csrf_token

  # Process form
  @message = "Form submitted securely!"
  erb :success
end
```

**views/protected_form.erb:**
```erb
<form action="/submit" method="post">
  <%= csrf_token_tag %>

  <div>
    <label for="data">Data:</label>
    <input type="text" id="data" name="data">
  </div>

  <button type="submit">Submit</button>
</form>
```

## 🔄 Nested Parameters

### Handling Complex Forms

**Form:**
```erb
<form action="/user" method="post">
  <fieldset>
    <legend>User Information</legend>
    <input type="text" name="user[name]" placeholder="Name">
    <input type="email" name="user[email]" placeholder="Email">
  </fieldset>

  <fieldset>
    <legend>Address</legend>
    <input type="text" name="user[address][street]" placeholder="Street">
    <input type="text" name="user[address][city]" placeholder="City">
    <input type="text" name="user[address][zip]" placeholder="ZIP">
  </fieldset>

  <button type="submit">Create User</button>
</form>
```

**Handler:**
```ruby
require 'sinatra'

post '/user' do
  user = params[:user]

  # Access nested data
  name = user[:name]
  email = user[:email]
  street = user[:address][:street]
  city = user[:address][:city]

  # Or work with the hash directly
  p user
  # {
  #   "name" => "Alice",
  #   "email" => "alice@example.com",
  #   "address" => {
  #     "street" => "123 Main St",
  #     "city" => "Springfield",
  #     "zip" => "12345"
  #   }
  # }

  @user = user
  erb :user_created
end
```

## 📊 Working with JSON Data

### Accepting JSON Requests

```ruby
require 'sinatra'
require 'json'

before do
  if request.content_type == 'application/json'
    request.body.rewind
    @json_body = JSON.parse(request.body.read, symbolize_names: true)
  end
end

post '/api/users' do
  content_type :json

  # Access JSON data
  name = @json_body[:name]
  email = @json_body[:email]

  # Validate
  if name && email
    { status: 'success', message: 'User created', data: @json_body }.to_json
  else
    status 400
    { status: 'error', message: 'Missing required fields' }.to_json
  end
end

# Test with curl:
# curl -X POST http://localhost:4567/api/users \
#   -H "Content-Type: application/json" \
#   -d '{"name":"Alice","email":"alice@example.com"}'
```

### Handling Both Form and JSON

```ruby
helpers do
  def request_data
    if request.content_type&.include?('application/json')
      request.body.rewind
      JSON.parse(request.body.read, symbolize_names: true)
    else
      params
    end
  end
end

post '/data' do
  data = request_data

  name = data[:name]
  email = data[:email]

  # Process the same way regardless of format
  if request.content_type&.include?('application/json')
    content_type :json
    { status: 'ok', name: name }.to_json
  else
    @name = name
    erb :success
  end
end
```

## ✍️ Exercises

### Exercise 1: Contact Form with Validation

Create a contact form with:
- Name, email, subject, and message fields
- Full validation
- Error display
- Success message

**Solution:** [contact_form_app.rb](contact_form_app.rb)

### Exercise 2: User Registration System

Build a registration system with:
- Username, email, password fields
- Password confirmation
- Password strength validation
- Error handling and display

**Solution:** [registration_app.rb](registration_app.rb)

### Exercise 3: Image Upload Gallery

Create an image upload system with:
- File upload with validation
- Image type restriction
- File size limits
- Gallery display
- Delete functionality

**Solution:** [image_gallery_app.rb](image_gallery_app.rb)

### Exercise 4: Survey Form with CSRF

Build a survey form with:
- Multiple input types (text, radio, checkboxes)
- CSRF protection
- Data validation
- Results display

**Solution:** [survey_app.rb](survey_app.rb)

## 🎓 Key Concepts

1. **Form Data**: Access via `params` hash, automatically parsed
2. **Validation**: Manual validation or helper methods
3. **File Uploads**: Use `params[:file][:tempfile]` and save securely
4. **CSRF Protection**: Built-in via rack-protection or manual tokens
5. **Nested Parameters**: Use bracket notation `user[address][city]`

## 🐞 Common Issues

### Issue 1: File Upload Not Working

**Problem:** `params[:file]` is nil

**Solution:** Add `enctype="multipart/form-data"` to form tag
```erb
<form method="post" enctype="multipart/form-data">
```

### Issue 2: Checkbox Always Nil

**Problem:** Unchecked checkboxes don't send data

**Solution:** Check for presence
```ruby
newsletter = params[:newsletter] == 'on'
```

Or use a hidden field trick:
```erb
<input type="hidden" name="newsletter" value="0">
<input type="checkbox" name="newsletter" value="1">
```

### Issue 3: Form Data Empty

**Problem:** `params` is empty on POST

**Solution:** Check form method and ensure name attributes exist
```erb
<form method="post">  <!-- Must be POST for post route -->
  <input name="field">  <!-- Must have name attribute -->
</form>
```

## 📊 Form Handling Quick Reference

| Task | Flask | Sinatra |
|------|-------|---------|
| Get form field | `request.form['name']` | `params[:name]` |
| Get query param | `request.args.get('q')` | `params[:q]` |
| File upload | `request.files['file']` | `params[:file]` |
| JSON body | `request.get_json()` | `JSON.parse(request.body.read)` |
| CSRF token | `{{ csrf_token() }}` | `csrf_token_tag` (custom) |
| Flash message | `flash('message')` | `session[:flash]` (manual) |

## 🔜 What's Next?

You now know:
- ✅ How to handle forms and user input
- ✅ How to validate data
- ✅ How to upload files securely
- ✅ How to protect against CSRF
- ✅ How to work with nested parameters

Next: Working with databases using Sequel and ActiveRecord!

**Next:** [Tutorial 5: Working with Databases](../5-working-with-databases/README.md)

## 📖 Additional Resources

- [Rack Protection Documentation](https://github.com/sinatra/sinatra/tree/master/rack-protection)
- [Ruby File I/O](https://ruby-doc.org/core/File.html)
- [SecureRandom Documentation](https://ruby-doc.org/stdlib/libdoc/securerandom/rdoc/SecureRandom.html)
- [Regular Expressions in Ruby](https://ruby-doc.org/core/Regexp.html)

---

Ready to practice? Start with **Exercise 1: Contact Form with Validation**!
