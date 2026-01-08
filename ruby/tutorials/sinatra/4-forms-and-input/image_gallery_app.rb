require 'sinatra'
require 'sinatra/reloader' if development?
require 'fileutils'
require 'securerandom'
require 'json'

configure do
  set :upload_dir, File.join(Dir.pwd, 'public', 'uploads')
  set :max_file_size, 5 * 1024 * 1024  # 5 MB
  set :allowed_extensions, %w[.jpg .jpeg .png .gif]
  set :images_file, File.join(Dir.pwd, 'images.json')

  # Create necessary directories
  FileUtils.mkdir_p(settings.upload_dir)

  # Initialize images file
  unless File.exist?(settings.images_file)
    File.write(settings.images_file, '[]')
  end
end

enable :sessions

helpers do
  def load_images
    JSON.parse(File.read(settings.images_file), symbolize_names: true)
  end

  def save_images(images)
    File.write(settings.images_file, JSON.pretty_generate(images))
  end

  def validate_file(file)
    errors = []

    return ["No file provided"] unless file && file[:tempfile]

    # Check file size
    size = file[:tempfile].size
    if size > settings.max_file_size
      max_mb = settings.max_file_size / (1024 * 1024)
      errors << "File too large (max #{max_mb}MB)"
    end

    if size == 0
      errors << "File is empty"
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

    # Check for directory traversal
    if file[:filename].include?('..') || file[:filename].include?('/')
      errors << "Invalid filename"
    end

    errors
  end

  def secure_filename(filename)
    ext = File.extname(filename)
    basename = File.basename(filename, ext).gsub(/[^a-zA-Z0-9_-]/, '_')
    timestamp = Time.now.to_i
    random = SecureRandom.hex(4)
    "#{basename}_#{timestamp}_#{random}#{ext}"
  end

  def format_file_size(bytes)
    if bytes < 1024
      "#{bytes} B"
    elsif bytes < 1024 * 1024
      "#{(bytes / 1024.0).round(2)} KB"
    else
      "#{(bytes / (1024.0 * 1024)).round(2)} MB"
    end
  end

  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end
end

# Home page - show gallery and upload form
get '/' do
  @images = load_images.reverse  # Show newest first
  @success = get_flash(:success)
  @errors = get_flash(:errors)
  erb :gallery
end

# Handle image upload
post '/upload' do
  file = params[:file]
  description = params[:description].to_s.strip

  errors = validate_file(file)

  if errors.empty?
    # Generate secure filename
    secure_name = secure_filename(file[:filename])
    filepath = File.join(settings.upload_dir, secure_name)

    # Save file
    File.open(filepath, 'wb') do |f|
      f.write(file[:tempfile].read)
    end

    # Get file size
    file_size = File.size(filepath)

    # Add to images database
    images = load_images
    images << {
      id: SecureRandom.uuid,
      filename: secure_name,
      original_filename: file[:filename],
      description: description,
      size: file_size,
      uploaded_at: Time.now.to_i
    }
    save_images(images)

    flash(:success, "Image '#{file[:filename]}' uploaded successfully!")
  else
    flash(:errors, errors)
  end

  redirect '/'
end

# Delete image
post '/delete/:id' do
  id = params[:id]
  images = load_images
  image = images.find { |img| img[:id] == id }

  if image
    # Delete file
    filepath = File.join(settings.upload_dir, image[:filename])
    File.delete(filepath) if File.exist?(filepath)

    # Remove from database
    images.reject! { |img| img[:id] == id }
    save_images(images)

    flash(:success, "Image deleted successfully!")
  else
    flash(:errors, ["Image not found"])
  end

  redirect '/'
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Image Gallery</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: #f5f5f5;
      padding: 2rem;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
    }

    h1 {
      color: #333;
      margin-bottom: 2rem;
      text-align: center;
    }

    .upload-section {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin-bottom: 2rem;
    }

    .upload-form {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .file-input-wrapper {
      flex: 1;
      min-width: 200px;
    }

    input[type="file"] {
      width: 100%;
      padding: 0.75rem;
      border: 2px dashed #667eea;
      border-radius: 5px;
      cursor: pointer;
    }

    input[type="text"] {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
    }

    button {
      padding: 0.75rem 2rem;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 5px;
      font-weight: 600;
      cursor: pointer;
    }

    button:hover {
      transform: translateY(-2px);
    }

    .message {
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1rem;
    }

    .success {
      background: #efe;
      border: 2px solid #cfc;
      color: #060;
    }

    .errors {
      background: #fee;
      border: 2px solid #fcc;
      color: #c00;
    }

    .errors ul {
      margin-left: 1.5rem;
    }

    .gallery {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 2rem;
    }

    .image-card {
      background: white;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      transition: transform 0.3s;
    }

    .image-card:hover {
      transform: translateY(-5px);
    }

    .image-wrapper {
      width: 100%;
      height: 250px;
      overflow: hidden;
      background: #f0f0f0;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .image-wrapper img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .image-info {
      padding: 1rem;
    }

    .image-description {
      color: #555;
      margin-bottom: 0.5rem;
    }

    .image-meta {
      font-size: 0.875rem;
      color: #888;
      margin-bottom: 0.5rem;
    }

    .delete-form {
      margin-top: 0.5rem;
    }

    .delete-btn {
      padding: 0.5rem 1rem;
      background: #dc3545;
      font-size: 0.875rem;
    }

    .empty-gallery {
      text-align: center;
      padding: 4rem;
      color: #888;
    }

    .file-requirements {
      font-size: 0.875rem;
      color: #666;
      margin-top: 0.5rem;
    }
  </style>
</head>
<body>
  <%= yield %>
</body>
</html>

@@gallery
<div class="container">
  <h1>📸 Image Gallery</h1>

  <% if @success %>
    <div class="message success">
      <%= @success %>
    </div>
  <% end %>

  <% if @errors %>
    <div class="message errors">
      <strong>Upload failed:</strong>
      <ul>
        <% @errors.each do |error| %>
          <li><%= error %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="upload-section">
    <h2>Upload Image</h2>
    <form action="/upload" method="post" enctype="multipart/form-data" class="upload-form">
      <div class="file-input-wrapper">
        <input type="file" name="file" accept="image/*" required>
        <div class="file-requirements">
          Max 5MB • JPG, PNG, GIF only
        </div>
      </div>

      <div class="file-input-wrapper">
        <input type="text" name="description" placeholder="Image description (optional)">
      </div>

      <button type="submit">Upload</button>
    </form>
  </div>

  <% if @images.empty? %>
    <div class="empty-gallery">
      <h2>No images yet</h2>
      <p>Upload your first image to get started!</p>
    </div>
  <% else %>
    <div class="gallery">
      <% @images.each do |image| %>
        <div class="image-card">
          <div class="image-wrapper">
            <img src="/uploads/<%= image[:filename] %>" alt="<%= image[:description] %>">
          </div>
          <div class="image-info">
            <% if !image[:description].empty? %>
              <div class="image-description">
                <%= image[:description] %>
              </div>
            <% end %>
            <div class="image-meta">
              <strong><%= image[:original_filename] %></strong><br>
              Size: <%= format_file_size(image[:size]) %><br>
              Uploaded: <%= Time.at(image[:uploaded_at]).strftime('%b %d, %Y at %I:%M %p') %>
            </div>
            <form action="/delete/<%= image[:id] %>" method="post" class="delete-form" onsubmit="return confirm('Are you sure you want to delete this image?')">
              <button type="submit" class="delete-btn">Delete</button>
            </form>
          </div>
        </div>
      <% end %>
    </div>
  <% end %>
</div>
