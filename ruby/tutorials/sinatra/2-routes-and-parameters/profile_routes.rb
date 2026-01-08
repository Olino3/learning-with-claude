# Exercise 1 Solution: User Profile Routes
require 'sinatra'

# Sample user data
USERS = {
  'alice' => { name: 'Alice Johnson', bio: 'Software Engineer', posts_count: 42 },
  'bob' => { name: 'Bob Smith', bio: 'Designer', posts_count: 28 },
  'charlie' => { name: 'Charlie Brown', bio: 'Product Manager', posts_count: 15 }
}

# Show user profile
get '/profile/:username' do
  username = params[:username]
  user = USERS[username]

  if user
    """
    <h1>#{user[:name]}</h1>
    <p>@#{username}</p>
    <p>Bio: #{user[:bio]}</p>
    <p>Posts: #{user[:posts_count]}</p>
    <p><a href='/profile/#{username}/posts'>View Posts</a></p>
    """
  else
    status 404
    "<h1>User not found</h1><p>Username '#{username}' does not exist</p>"
  end
end

# Show user's posts with pagination
get '/profile/:username/posts' do
  username = params[:username]
  user = USERS[username]

  unless user
    status 404
    return "<h1>User not found</h1>"
  end

  page = (params[:page] || 1).to_i
  per_page = (params[:per_page] || 10).to_i
  start = (page - 1) * per_page

  total_posts = user[:posts_count]
  total_pages = (total_posts / per_page.to_f).ceil

  """
  <h1>Posts by #{user[:name]}</h1>
  <p>Showing posts #{start + 1}-#{[start + per_page, total_posts].min} of #{total_posts}</p>
  <p>Page #{page} of #{total_pages}</p>

  <ul>
    #{per_page.times.map { |i| "<li>Post #{start + i + 1}</li>" }.join}
  </ul>

  <p>
    #{page > 1 ? "<a href='/profile/#{username}/posts?page=#{page - 1}&per_page=#{per_page}'>Previous</a>" : ''}
    #{page < total_pages ? "<a href='/profile/#{username}/posts?page=#{page + 1}&per_page=#{per_page}'>Next</a>" : ''}
  </p>
  <p><a href='/profile/#{username}'>Back to profile</a></p>
  """
end

get '/' do
  """
  <h1>User Profiles</h1>
  <ul>
    <li><a href='/profile/alice'>Alice</a></li>
    <li><a href='/profile/bob'>Bob</a></li>
    <li><a href='/profile/charlie'>Charlie</a></li>
  </ul>
  """
end
