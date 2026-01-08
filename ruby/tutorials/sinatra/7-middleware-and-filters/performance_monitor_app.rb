require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

# === PERFORMANCE MONITORING MIDDLEWARE ===

class PerformanceMonitor
  def initialize(app)
    @app = app
    @stats = Hash.new { |h, k| h[k] = { count: 0, total_time: 0, min_time: Float::INFINITY, max_time: 0, errors: 0 } }
  end

  def call(env)
    request = Rack::Request.new(env)
    path = normalize_path(request.path)
    start_time = Time.now

    status, headers, body = @app.call(env)

    elapsed = Time.now - start_time

    # Update stats
    @stats[path][:count] += 1
    @stats[path][:total_time] += elapsed
    @stats[path][:min_time] = elapsed if elapsed < @stats[path][:min_time]
    @stats[path][:max_time] = elapsed if elapsed > @stats[path][:max_time]
    @stats[path][:errors] += 1 if status >= 400

    # Add performance header
    headers['X-Response-Time'] = "#{(elapsed * 1000).round(2)}ms"

    # Log slow requests
    if elapsed > 0.5
      puts "SLOW REQUEST: #{request.request_method} #{path} took #{(elapsed * 1000).round(2)}ms"
    end

    [status, headers, body]
  end

  def stats
    @stats
  end

  private

  def normalize_path(path)
    # Normalize paths with IDs (e.g., /users/123 -> /users/:id)
    path.gsub(/\/\d+/, '/:id')
  end
end

# Create and use middleware
monitor = PerformanceMonitor.new(app)
use monitor

# Make stats accessible
set :performance_monitor, monitor

# === HELPERS ===

helpers do
  def format_time(seconds)
    "#{(seconds * 1000).round(2)}ms"
  end

  def format_percentage(part, total)
    return '0%' if total.zero?
    "#{((part.to_f / total) * 100).round(1)}%"
  end
end

# === ROUTES ===

get '/' do
  erb :index
end

get '/stats' do
  stats = settings.performance_monitor.stats

  erb :stats, locals: { stats: stats }
end

get '/stats/json' do
  content_type :json
  stats = settings.performance_monitor.stats

  formatted_stats = stats.map do |path, data|
    {
      path: path,
      requests: data[:count],
      total_time: format_time(data[:total_time]),
      avg_time: format_time(data[:total_time] / data[:count]),
      min_time: format_time(data[:min_time]),
      max_time: format_time(data[:max_time]),
      error_rate: format_percentage(data[:errors], data[:count])
    }
  end

  JSON.pretty_generate({
    endpoints: formatted_stats,
    generated_at: Time.now
  })
end

# Test endpoints
get '/fast' do
  'Fast response'
end

get '/slow' do
  sleep(0.5)
  'Slow response'
end

get '/very-slow' do
  sleep(1)
  'Very slow response'
end

get '/api/users/:id' do
  sleep(rand(0.1..0.3))
  content_type :json
  JSON.generate({ id: params[:id], name: "User #{params[:id]}" })
end

get '/error' do
  halt 500, 'Simulated error'
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Performance Monitor</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 2rem;
    }
    .container { max-width: 1200px; margin: 0 auto; }
    .card {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      margin-bottom: 1.5rem;
    }
    h1, h2 { color: #667eea; margin-bottom: 1rem; }
    table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
    th, td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #e0e0e0; }
    th { background: #667eea; color: white; }
    tr:hover { background: #f8f9fa; }
    .metric { display: inline-block; padding: 0.5rem 1rem; background: #f8f9fa; border-radius: 5px; margin: 0.5rem; }
    .metric-label { color: #666; font-size: 0.875rem; }
    .metric-value { font-size: 1.5rem; font-weight: bold; color: #667eea; }
    .btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      font-weight: 600;
      margin: 0.5rem;
    }
    .fast { color: #28a745; }
    .medium { color: #ffa502; }
    .slow { color: #ff4757; }
  </style>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@index
<div class="card">
  <h1>⚡ Performance Monitor</h1>
  <p>Monitor endpoint performance and response times.</p>

  <h3 style="margin-top: 2rem;">Test Endpoints:</h3>
  <div style="margin-top: 1rem;">
    <a href="/fast" class="btn">Fast Endpoint</a>
    <a href="/slow" class="btn">Slow Endpoint (500ms)</a>
    <a href="/very-slow" class="btn">Very Slow (1s)</a>
    <a href="/api/users/123" class="btn">API Endpoint</a>
    <a href="/error" class="btn" style="background: #dc3545;">Error Endpoint</a>
  </div>

  <h3 style="margin-top: 2rem;">Stats:</h3>
  <div style="margin-top: 1rem;">
    <a href="/stats" class="btn">View Stats Dashboard</a>
    <a href="/stats/json" class="btn">View JSON Stats</a>
  </div>
</div>

@@stats
<div class="card">
  <h1>📊 Performance Statistics</h1>

  <% if stats.empty? %>
    <p>No requests yet. Make some requests to see statistics.</p>
    <a href="/" class="btn">Go Back</a>
  <% else %>
    <% total_requests = stats.values.sum { |s| s[:count] } %>
    <% total_errors = stats.values.sum { |s| s[:errors] } %>
    <% avg_response = stats.values.sum { |s| s[:total_time] } / total_requests %>

    <div style="display: flex; justify-content: space-around; margin: 2rem 0;">
      <div class="metric">
        <div class="metric-label">Total Requests</div>
        <div class="metric-value"><%= total_requests %></div>
      </div>
      <div class="metric">
        <div class="metric-label">Avg Response Time</div>
        <div class="metric-value"><%= format_time(avg_response) %></div>
      </div>
      <div class="metric">
        <div class="metric-label">Error Rate</div>
        <div class="metric-value"><%= format_percentage(total_errors, total_requests) %></div>
      </div>
    </div>

    <h2>Endpoint Statistics:</h2>
    <table>
      <thead>
        <tr>
          <th>Endpoint</th>
          <th>Requests</th>
          <th>Avg Time</th>
          <th>Min Time</th>
          <th>Max Time</th>
          <th>Errors</th>
        </tr>
      </thead>
      <tbody>
        <% stats.sort_by { |_, v| -v[:total_time] / v[:count] }.each do |path, data| %>
          <% avg_time = data[:total_time] / data[:count] %>
          <% speed_class = avg_time < 0.1 ? 'fast' : (avg_time < 0.5 ? 'medium' : 'slow') %>
          <tr>
            <td><strong><%= path %></strong></td>
            <td><%= data[:count] %></td>
            <td class="<%= speed_class %>"><strong><%= format_time(avg_time) %></strong></td>
            <td><%= format_time(data[:min_time]) %></td>
            <td><%= format_time(data[:max_time]) %></td>
            <td><%= data[:errors] %> (<%= format_percentage(data[:errors], data[:count]) %>)</td>
          </tr>
        <% end %>
      </tbody>
    </table>

    <div style="margin-top: 2rem;">
      <a href="/" class="btn">Back to Home</a>
      <a href="/stats/json" class="btn">View as JSON</a>
    </div>
  <% end %>
</div>
