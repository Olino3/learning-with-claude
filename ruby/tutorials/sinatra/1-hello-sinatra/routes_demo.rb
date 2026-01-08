# Demonstrating multiple routes in Sinatra
# Each route handles a different URL path

require 'sinatra'

# Home page
get '/' do
  '<h1>Welcome to my Sinatra site!</h1>
   <p>Visit <a href="/about">/about</a> or <a href="/contact">/contact</a></p>'
end

# About page
get '/about' do
  '<h1>About Us</h1>
   <p>This is a simple Sinatra application demonstrating multiple routes.</p>
   <p><a href="/">Go back home</a></p>'
end

# Contact page
get '/contact' do
  '<h1>Contact</h1>
   <p>Email: hello@example.com</p>
   <p>Phone: (555) 123-4567</p>
   <p><a href="/">Go back home</a></p>'
end

# Info page showing server details
get '/info' do
  """
  <h1>Server Information</h1>
  <ul>
    <li>Environment: #{settings.environment}</li>
    <li>Port: #{settings.port}</li>
    <li>Server: #{settings.server}</li>
    <li>Root directory: #{settings.root}</li>
  </ul>
  <p><a href="/">Go back home</a></p>
  """
end

# 🐍 Python/Flask equivalent:
#
# @app.route('/')
# def index():
#     return '<h1>Welcome!</h1>'
#
# @app.route('/about')
# def about():
#     return '<h1>About Us</h1>'
#
# @app.route('/contact')
# def contact():
#     return '<h1>Contact</h1>'
