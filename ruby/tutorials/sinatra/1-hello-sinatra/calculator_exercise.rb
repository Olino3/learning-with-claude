# Exercise 4 Solution: Calculator API
#
# Requirements:
# - GET /add/:a/:b returns sum of a and b as JSON
# - GET /multiply/:a/:b returns product of a and b as JSON

require 'sinatra'
require 'json'

# Set JSON content type for all responses
before do
  content_type :json
end

# Addition endpoint
get '/add/:a/:b' do
  a = params[:a].to_f
  b = params[:b].to_f
  result = a + b

  {
    operation: 'addition',
    a: a,
    b: b,
    result: result,
    expression: "#{a} + #{b} = #{result}"
  }.to_json
end

# Multiplication endpoint
get '/multiply/:a/:b' do
  a = params[:a].to_f
  b = params[:b].to_f
  result = a * b

  {
    operation: 'multiplication',
    a: a,
    b: b,
    result: result,
    expression: "#{a} × #{b} = #{result}"
  }.to_json
end

# Bonus: Add more operations

# Subtraction
get '/subtract/:a/:b' do
  a = params[:a].to_f
  b = params[:b].to_f
  result = a - b

  {
    operation: 'subtraction',
    a: a,
    b: b,
    result: result,
    expression: "#{a} - #{b} = #{result}"
  }.to_json
end

# Division
get '/divide/:a/:b' do
  a = params[:a].to_f
  b = params[:b].to_f

  if b == 0
    status 400
    {
      error: 'Division by zero',
      message: 'Cannot divide by zero'
    }.to_json
  else
    result = a / b
    {
      operation: 'division',
      a: a,
      b: b,
      result: result,
      expression: "#{a} ÷ #{b} = #{result}"
    }.to_json
  end
end

# Power
get '/power/:a/:b' do
  a = params[:a].to_f
  b = params[:b].to_f
  result = a ** b

  {
    operation: 'power',
    base: a,
    exponent: b,
    result: result,
    expression: "#{a}^#{b} = #{result}"
  }.to_json
end

# Square root
get '/sqrt/:a' do
  a = params[:a].to_f

  if a < 0
    status 400
    {
      error: 'Invalid input',
      message: 'Cannot calculate square root of negative number'
    }.to_json
  else
    result = Math.sqrt(a)
    {
      operation: 'square_root',
      value: a,
      result: result,
      expression: "√#{a} = #{result}"
    }.to_json
  end
end

# API documentation (HTML)
get '/' do
  content_type :html
  """
  <h1>Calculator API</h1>

  <h2>Available Operations:</h2>
  <ul>
    <li><code>GET /add/:a/:b</code> - Add two numbers</li>
    <li><code>GET /subtract/:a/:b</code> - Subtract two numbers</li>
    <li><code>GET /multiply/:a/:b</code> - Multiply two numbers</li>
    <li><code>GET /divide/:a/:b</code> - Divide two numbers</li>
    <li><code>GET /power/:a/:b</code> - Raise a to the power of b</li>
    <li><code>GET /sqrt/:a</code> - Square root of a</li>
  </ul>

  <h2>Examples:</h2>
  <ul>
    <li><a href='/add/5/3' target='_blank'>/add/5/3</a> → 8</li>
    <li><a href='/subtract/10/4' target='_blank'>/subtract/10/4</a> → 6</li>
    <li><a href='/multiply/7/6' target='_blank'>/multiply/7/6</a> → 42</li>
    <li><a href='/divide/15/3' target='_blank'>/divide/15/3</a> → 5</li>
    <li><a href='/power/2/8' target='_blank'>/power/2/8</a> → 256</li>
    <li><a href='/sqrt/16' target='_blank'>/sqrt/16</a> → 4</li>
  </ul>

  <h2>Features:</h2>
  <ul>
    <li>✅ Supports decimals (try /add/3.5/2.7)</li>
    <li>✅ Returns JSON responses</li>
    <li>✅ Error handling for division by zero</li>
    <li>✅ Validates square root input</li>
  </ul>
  """
end

# 🐍 Python/Flask equivalent:
#
# from flask import Flask, jsonify
#
# @app.route('/add/<float:a>/<float:b>')
# def add(a, b):
#     result = a + b
#     return jsonify({
#         'operation': 'addition',
#         'a': a,
#         'b': b,
#         'result': result
#     })
#
# @app.route('/multiply/<float:a>/<float:b>')
# def multiply(a, b):
#     result = a * b
#     return jsonify({
#         'operation': 'multiplication',
#         'a': a,
#         'b': b,
#         'result': result
#     })
