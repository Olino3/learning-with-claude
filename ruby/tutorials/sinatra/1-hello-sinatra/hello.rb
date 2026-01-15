# The simplest Sinatra application possible
# This is the "Hello World" of web development in Ruby

require 'sinatra'

# Configure Sinatra to bind to all interfaces (for Docker)
set :bind, ENV.fetch('SINATRA_BIND', '0.0.0.0')
set :port, ENV.fetch('PORT', 4567)

# Define a route that responds to GET requests at the root path
get '/' do
  'Hello World!'
end

# How to run this:
# 1. In the container: make sinatra-tutorial NUM=1
# 2. Visit: http://localhost:4567
#
# 🐍 Python/Flask equivalent:
# from flask import Flask
# app = Flask(__name__)
#
# @app.route('/')
# def hello():
#     return 'Hello World!'
#
# if __name__ == '__main__':
#     app.run()
