# Demonstrating Sinatra configuration options
# Shows various ways to configure your Sinatra application

require 'sinatra'

# ====== Configuration Section ======

# Server configuration
set :port, 4567                        # Port to run on (default: 4567)
set :bind, '0.0.0.0'                  # Bind to all network interfaces
set :environment, :development         # Environment: :development or :production
set :server, 'webrick'                # Web server: webrick, thin, puma

# Application settings
set :app_file, __FILE__               # The main application file
set :root, File.dirname(__FILE__)     # Application root directory
set :public_folder, 'public'          # Static files directory (if exists)
set :views, 'views'                   # Templates directory (if exists)

# Development-specific settings
configure :development do
  set :show_exceptions, true          # Show detailed error pages
  set :dump_errors, true              # Log errors to STDERR
  set :logging, true                  # Enable request logging
end

# Production-specific settings
configure :production do
  set :show_exceptions, false         # Don't show error details
  set :dump_errors, false             # Don't dump errors
  set :logging, false                 # Disable detailed logging
end

# Custom settings
set :app_name, 'Sinatra Configuration Demo'
set :version, '1.0.0'

# ====== Routes ======

get '/' do
  """
  <h1>#{settings.app_name}</h1>
  <p>Version: #{settings.version}</p>
  <p>Visit <a href='/config'>/config</a> to see all configuration settings</p>
  """
end

# Display configuration information
get '/config' do
  """
  <h1>Configuration Information</h1>

  <h2>Server Settings</h2>
  <ul>
    <li>Environment: #{settings.environment}</li>
    <li>Port: #{settings.port}</li>
    <li>Bind address: #{settings.bind}</li>
    <li>Server: #{settings.server}</li>
  </ul>

  <h2>Application Settings</h2>
  <ul>
    <li>App name: #{settings.app_name}</li>
    <li>Version: #{settings.version}</li>
    <li>Root directory: #{settings.root}</li>
    <li>Views folder: #{settings.views}</li>
    <li>Public folder: #{settings.public_folder}</li>
  </ul>

  <h2>Development Settings</h2>
  <ul>
    <li>Show exceptions: #{settings.show_exceptions}</li>
    <li>Dump errors: #{settings.dump_errors}</li>
    <li>Logging: #{settings.logging}</li>
  </ul>

  <h2>Ruby & Sinatra Info</h2>
  <ul>
    <li>Ruby version: #{RUBY_VERSION}</li>
    <li>Sinatra version: #{Sinatra::VERSION}</li>
  </ul>

  <p><a href='/'>Back to home</a></p>
  """
end

# Environment-specific route
get '/env' do
  case settings.environment
  when :development
    '<h1>Development Mode</h1>
     <p>Detailed errors are shown, logging is enabled</p>'
  when :production
    '<h1>Production Mode</h1>
     <p>Errors are hidden, logging is minimal</p>'
  else
    "<h1>Unknown Environment: #{settings.environment}</h1>"
  end
end

# ====== Application Startup Message ======

# This runs when the application starts
configure do
  puts "=" * 60
  puts "🚀 #{settings.app_name} v#{settings.version}"
  puts "=" * 60
  puts "Environment:  #{settings.environment}"
  puts "Server:       #{settings.server}"
  puts "Port:         #{settings.port}"
  puts "Bind:         #{settings.bind}"
  puts "Ruby:         #{RUBY_VERSION}"
  puts "Sinatra:      #{Sinatra::VERSION}"
  puts "=" * 60
  puts "Visit: http://localhost:#{settings.port}"
  puts "=" * 60
end

# 🐍 Python/Flask equivalent:
#
# from flask import Flask
#
# app = Flask(__name__)
#
# # Configuration
# app.config['DEBUG'] = True
# app.config['SERVER_NAME'] = 'localhost:5000'
# app.config['APPLICATION_ROOT'] = '/'
#
# # Custom settings
# app.config['APP_NAME'] = 'Flask Config Demo'
# app.config['VERSION'] = '1.0.0'
#
# @app.route('/config')
# def config():
#     return f"Environment: {app.config['ENV']}"
#
# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)
