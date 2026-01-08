# Exercise 2 Solution: Blog Post Routes
require 'sinatra'
require 'json'

# Sample blog posts
POSTS = [
  { id: 1, title: 'Getting Started with Ruby', slug: 'getting-started-ruby', date: '2024-01-15', content: 'Ruby is amazing!' },
  { id: 2, title: 'Sinatra Web Framework', slug: 'sinatra-web-framework', date: '2024-02-20', content: 'Learn Sinatra' },
  { id: 3, title: 'Building APIs', slug: 'building-apis', date: '2024-03-10', content: 'RESTful APIs' }
]

# List all posts with pagination
get '/blog' do
  page = (params[:page] || 1).to_i
  per_page = (params[:per_page] || 5).to_i
  start = (page - 1) * per_page

  paginated_posts = POSTS[start, per_page] || []
  total_pages = (POSTS.length / per_page.to_f).ceil

  """
  <h1>Blog Posts</h1>
  <p>Page #{page} of #{total_pages}</p>

  #{paginated_posts.map { |post|
    "<div>
      <h2><a href='/blog/2024/01/15/#{post[:slug]}'>#{post[:title]}</a></h2>
      <p>#{post[:date]}</p>
      <p>#{post[:content]}</p>
    </div>"
  }.join('<hr>')}

  <p>
    #{page > 1 ? "<a href='/blog?page=#{page - 1}'>Previous</a>" : ''}
    #{page < total_pages ? "<a href='/blog?page=#{page + 1}'>Next</a>" : ''}
  </p>
  """
end

# Show specific post by date and slug
get '/blog/:year/:month/:day/:slug' do
  year = params[:year]
  month = params[:month]
  day = params[:day]
  slug = params[:slug]

  date_str = "#{year}-#{month}-#{day}"
  post = POSTS.find { |p| p[:date] == date_str && p[:slug] == slug }

  if post
    """
    <h1>#{post[:title]}</h1>
    <p>Published: #{post[:date]}</p>
    <p>#{post[:content]}</p>
    <p><a href='/blog'>Back to blog</a></p>
    """
  else
    status 404
    "<h1>Post not found</h1><p><a href='/blog'>Back to blog</a></p>"
  end
end

# Search posts
get '/blog/search' do
  query = params[:q]

  if query && !query.empty?
    results = POSTS.select { |p| p[:title].downcase.include?(query.downcase) || p[:content].downcase.include?(query.downcase) }

    """
    <h1>Search Results for '#{query}'</h1>
    <p>Found #{results.length} post(s)</p>

    #{results.map { |post|
      "<div>
        <h2><a href='/blog/2024/01/15/#{post[:slug]}'>#{post[:title]}</a></h2>
        <p>#{post[:content]}</p>
      </div>"
    }.join('<hr>')}

    <p><a href='/blog'>Back to blog</a></p>
    """
  else
    """
    <h1>Search</h1>
    <form action='/blog/search' method='get'>
      <input type='text' name='q' placeholder='Search...'>
      <button type='submit'>Search</button>
    </form>
    <p><a href='/blog'>Back to blog</a></p>
    """
  end
end

get '/' do
  redirect '/blog'
end
