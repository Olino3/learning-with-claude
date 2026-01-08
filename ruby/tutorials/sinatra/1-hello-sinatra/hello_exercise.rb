# Exercise 1 Solution: Hello World with Multiple Routes
#
# Requirements:
# - '/' returns "Welcome to my website!"
# - '/hello' returns "Hello, Sinatra!"
# - '/time' returns the current time

require 'sinatra'

get '/' do
  'Welcome to my website!'
end

get '/hello' do
  'Hello, Sinatra!'
end

get '/time' do
  "The current time is: #{Time.now}"
end

# Bonus: Add some formatting to make it nicer
get '/time/formatted' do
  current_time = Time.now
  """
  <h1>Current Time</h1>
  <p>#{current_time.strftime('%B %d, %Y at %I:%M:%S %p')}</p>
  <p>Unix timestamp: #{current_time.to_i}</p>
  """
end

# 🐍 Python/Flask equivalent:
#
# from datetime import datetime
#
# @app.route('/')
# def index():
#     return 'Welcome to my website!'
#
# @app.route('/hello')
# def hello():
#     return 'Hello, Sinatra!'
#
# @app.route('/time')
# def time():
#     return f'The current time is: {datetime.now()}'
