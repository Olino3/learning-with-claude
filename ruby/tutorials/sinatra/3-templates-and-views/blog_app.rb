# Exercise 1 Solution: Blog with Layout
require 'sinatra'

# Sample blog posts data
POSTS = [
  {
    id: 1,
    title: 'Getting Started with Sinatra',
    excerpt: 'Learn the basics of building web apps with Sinatra',
    content: 'Sinatra is a DSL for quickly creating web applications in Ruby...',
    author: 'Alice',
    date: Time.new(2024, 1, 15)
  },
  {
    id: 2,
    title: 'ERB Templates Guide',
    excerpt: 'Master ERB templates for dynamic HTML generation',
    content: 'ERB allows you to embed Ruby code in your HTML templates...',
    author: 'Bob',
    date: Time.new(2024, 2, 20)
  },
  {
    id: 3,
    title: 'Building RESTful APIs',
    excerpt: 'Create clean, RESTful APIs with Sinatra',
    content: 'REST is an architectural style for designing networked applications...',
    author: 'Charlie',
    date: Time.new(2024, 3, 10)
  }
]

helpers do
  def format_date(date)
    date.strftime('%B %d, %Y')
  end

  def active_page(path)
    request.path == path ? 'active' : ''
  end
end

# Home page - list all posts
get '/' do
  @title = 'Home'
  @posts = POSTS
  erb :home
end

# Individual post page
get '/posts/:id' do
  @post = POSTS.find { |p| p[:id] == params[:id].to_i }
  halt 404, erb(:not_found) unless @post

  @title = @post[:title]
  erb :post
end

# About page
get '/about' do
  @title = 'About'
  erb :about
end

# 404 handler
not_found do
  @title = '404 - Page Not Found'
  erb :not_found
end
