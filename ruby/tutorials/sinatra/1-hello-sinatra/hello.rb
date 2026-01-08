# The simplest Sinatra application possible
# This is the "Hello World" of web development in Ruby

require 'sinatra'

# Define a route that responds to GET requests at the root path
get '/' do
  'Hello World!'
end

# How to run this:
# 1. In the container: docker-compose exec sinatra-web ruby ruby/tutorials/sinatra/1-hello-sinatra/hello.rb
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
