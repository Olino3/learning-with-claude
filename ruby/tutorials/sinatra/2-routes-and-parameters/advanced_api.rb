# Exercise 4 Solution: Advanced API with Validation
require 'sinatra'
require 'json'

# Helper methods for validation
helpers do
  def validate_integer(value, name, min: nil, max: nil)
    return nil if value.nil?

    int_value = value.to_i
    return halt 400, { error: "#{name} must be a number" }.to_json if int_value.to_s != value.to_s.strip

    if min && int_value < min
      halt 400, { error: "#{name} must be at least #{min}" }.to_json
    end

    if max && int_value > max
      halt 400, { error: "#{name} must be at most #{max}" }.to_json
    end

    int_value
  end

  def validate_required(value, name)
    if value.nil? || value.empty?
      halt 400, { error: "#{name} is required" }.to_json
    end
    value
  end
end

before do
  content_type :json
end

# Advanced API with multiple parameter types
get '/api/products' do
  # Query parameters with defaults and validation
  page = validate_integer(params[:page], 'page', min: 1) || 1
  limit = validate_integer(params[:limit], 'limit', min: 1, max: 100) || 10
  sort = params[:sort] || 'name'
  order = params[:order] || 'asc'

  # Validate sort field
  valid_sorts = ['name', 'price', 'date']
  unless valid_sorts.include?(sort)
    halt 400, { error: "Invalid sort field. Must be one of: #{valid_sorts.join(', ')}" }.to_json
  end

  # Validate order
  valid_orders = ['asc', 'desc']
  unless valid_orders.include?(order)
    halt 400, { error: "Invalid order. Must be 'asc' or 'desc'" }.to_json
  end

  {
    products: [],
    pagination: {
      page: page,
      limit: limit,
      total: 0
    },
    sort: {
      field: sort,
      order: order
    }
  }.to_json
end

# Product by ID with validation
get '/api/products/:id' do
  id = validate_integer(params[:id], 'id', min: 1)

  {
    id: id,
    name: "Product #{id}",
    price: 99.99,
    in_stock: true
  }.to_json
end

# Search with required parameter
get '/api/search' do
  query = validate_required(params[:q], 'query parameter (q)')
  category = params[:category]
  min_price = validate_integer(params[:min_price], 'min_price', min: 0) || 0
  max_price = validate_integer(params[:max_price], 'max_price', min: 0)

  if max_price && min_price > max_price
    halt 400, { error: 'min_price cannot be greater than max_price' }.to_json
  end

  {
    query: query,
    category: category,
    price_range: {
      min: min_price,
      max: max_price
    },
    results: []
  }.to_json
end

# Date range with validation
get '/api/reports/:type' do
  type = params[:type]
  start_date = validate_required(params[:start_date], 'start_date')
  end_date = validate_required(params[:end_date], 'end_date')

  # Validate date format (simple check)
  date_regex = /^\d{4}-\d{2}-\d{2}$/
  unless start_date.match?(date_regex)
    halt 400, { error: 'start_date must be in YYYY-MM-DD format' }.to_json
  end

  unless end_date.match?(date_regex)
    halt 400, { error: 'end_date must be in YYYY-MM-DD format' }.to_json
  end

  {
    report_type: type,
    period: {
      start: start_date,
      end: end_date
    },
    data: []
  }.to_json
end

# API documentation
get '/' do
  content_type :html
  """
  <h1>Advanced API</h1>

  <h2>Endpoints:</h2>

  <h3>GET /api/products</h3>
  <p>List products with pagination and sorting</p>
  <ul>
    <li><code>page</code> (optional, integer, min: 1, default: 1)</li>
    <li><code>limit</code> (optional, integer, 1-100, default: 10)</li>
    <li><code>sort</code> (optional, string, options: name/price/date, default: name)</li>
    <li><code>order</code> (optional, string, options: asc/desc, default: asc)</li>
  </ul>
  <p>Example: <a href='/api/products?page=1&limit=5&sort=price&order=desc'>/api/products?page=1&limit=5&sort=price&order=desc</a></p>

  <h3>GET /api/products/:id</h3>
  <p>Get specific product by ID</p>
  <p>Example: <a href='/api/products/123'>/api/products/123</a></p>

  <h3>GET /api/search</h3>
  <p>Search products</p>
  <ul>
    <li><code>q</code> (required, string) - Search query</li>
    <li><code>category</code> (optional, string)</li>
    <li><code>min_price</code> (optional, integer, min: 0)</li>
    <li><code>max_price</code> (optional, integer, min: 0)</li>
  </ul>
  <p>Example: <a href='/api/search?q=laptop&category=electronics&min_price=500&max_price=2000'>/api/search?q=laptop&category=electronics&min_price=500&max_price=2000</a></p>

  <h3>GET /api/reports/:type</h3>
  <p>Generate reports</p>
  <ul>
    <li><code>start_date</code> (required, YYYY-MM-DD)</li>
    <li><code>end_date</code> (required, YYYY-MM-DD)</li>
  </ul>
  <p>Example: <a href='/api/reports/sales?start_date=2024-01-01&end_date=2024-12-31'>/api/reports/sales?start_date=2024-01-01&end_date=2024-12-31</a></p>
  """
end

# Error handling
error 400 do
  content_type :json
  { error: env['sinatra.error'].message }.to_json
end
