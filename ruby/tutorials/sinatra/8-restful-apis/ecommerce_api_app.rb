require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/namespace'
require 'json'
require 'securerandom'

# Storage
PRODUCTS = [
  { id: 1, name: 'Laptop', price: 999.99, category: 'Electronics', stock: 10 },
  { id: 2, name: 'Mouse', price: 29.99, category: 'Electronics', stock: 50 },
  { id: 3, name: 'Desk', price: 299.99, category: 'Furniture', stock: 5 },
  { id: 4, name: 'Chair', price: 199.99, category: 'Furniture', stock: 8 }
]

CARTS = {}
ORDERS = []

# Rate limiting
RATE_LIMITS = Hash.new { |h, k| h[k] = [] }

# Helpers
helpers do
  def json_params
    request.body.rewind
    JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end

  def rate_limit(limit: 20, window: 60)
    key = request.ip
    now = Time.now.to_i

    RATE_LIMITS[key].reject! { |t| t < now - window }

    if RATE_LIMITS[key].length >= limit
      halt 429, {
        error: 'Rate limit exceeded',
        limit: limit,
        window: window,
        retry_after: window
      }.to_json
    end

    RATE_LIMITS[key] << now
  end

  def find_product(id)
    product = PRODUCTS.find { |p| p[:id] == id.to_i }
    halt 404, { error: 'Product not found' }.to_json unless product
    product
  end

  def get_cart(cart_id)
    CARTS[cart_id] ||= { id: cart_id, items: [], created_at: Time.now.to_i }
  end
end

# CORS & Rate Limiting
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers' => 'Content-Type'
  content_type :json
  rate_limit
end

options '*' do
  200
end

# Root
get '/' do
  {
    name: 'E-commerce API',
    version: '1.0.0',
    endpoints: {
      products: '/api/products',
      categories: '/api/categories',
      cart: '/api/cart/:cart_id',
      orders: '/api/orders'
    }
  }.to_json
end

namespace '/api' do
  # Products
  get '/products' do
    products = PRODUCTS.dup

    # Filter by category
    products = products.select { |p| p[:category] == params[:category] } if params[:category]

    # Filter by price range
    if params[:min_price]
      products = products.select { |p| p[:price] >= params[:min_price].to_f }
    end
    if params[:max_price]
      products = products.select { |p| p[:price] <= params[:max_price].to_f }
    end

    # Search
    if params[:search]
      products = products.select { |p| p[:name].downcase.include?(params[:search].downcase) }
    end

    # Sort
    case params[:sort]
    when 'price_asc'
      products = products.sort_by { |p| p[:price] }
    when 'price_desc'
      products = products.sort_by { |p| -p[:price] }
    when 'name'
      products = products.sort_by { |p| p[:name] }
    end

    { products: products, count: products.length }.to_json
  end

  get '/products/:id' do
    product = find_product(params[:id])
    product.to_json
  end

  # Categories
  get '/categories' do
    categories = PRODUCTS.map { |p| p[:category] }.uniq.sort
    { categories: categories, count: categories.length }.to_json
  end

  # Cart
  get '/cart/:cart_id' do
    cart = get_cart(params[:cart_id])

    total = cart[:items].sum { |item| item[:price] * item[:quantity] }

    {
      **cart,
      total: total,
      item_count: cart[:items].sum { |i| i[:quantity] }
    }.to_json
  end

  post '/cart/:cart_id/items' do
    cart = get_cart(params[:cart_id])
    data = json_params

    product = find_product(data[:product_id])

    # Check stock
    if product[:stock] < data[:quantity].to_i
      halt 400, { error: 'Insufficient stock', available: product[:stock] }.to_json
    end

    # Add or update item
    existing = cart[:items].find { |i| i[:product_id] == product[:id] }

    if existing
      existing[:quantity] += data[:quantity].to_i
    else
      cart[:items] << {
        product_id: product[:id],
        name: product[:name],
        price: product[:price],
        quantity: data[:quantity].to_i
      }
    end

    status 201
    cart.to_json
  end

  delete '/cart/:cart_id/items/:product_id' do
    cart = get_cart(params[:cart_id])
    cart[:items].reject! { |i| i[:product_id] == params[:product_id].to_i }

    cart.to_json
  end

  # Orders
  post '/orders' do
    data = json_params

    cart = get_cart(data[:cart_id])
    halt 400, { error: 'Cart is empty' }.to_json if cart[:items].empty?

    # Validate stock
    cart[:items].each do |item|
      product = PRODUCTS.find { |p| p[:id] == item[:product_id] }
      if product[:stock] < item[:quantity]
        halt 400, {
          error: 'Insufficient stock',
          product: product[:name],
          available: product[:stock]
        }.to_json
      end
    end

    # Create order
    order = {
      id: SecureRandom.uuid,
      items: cart[:items],
      total: cart[:items].sum { |i| i[:price] * i[:quantity] },
      customer: data[:customer],
      status: 'pending',
      created_at: Time.now.to_i
    }

    # Update stock
    cart[:items].each do |item|
      product = PRODUCTS.find { |p| p[:id] == item[:product_id] }
      product[:stock] -= item[:quantity]
    end

    ORDERS << order
    CARTS.delete(cart[:id])

    status 201
    order.to_json
  end

  get '/orders/:id' do
    order = ORDERS.find { |o| o[:id] == params[:id] }
    halt 404, { error: 'Order not found' }.to_json unless order

    order.to_json
  end
end
