require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'dev_secret_change_in_production'

# Product catalog
PRODUCTS = {
  1 => { id: 1, name: 'Laptop', price: 999.99, image: '💻' },
  2 => { id: 2, name: 'Mouse', price: 29.99, image: '🖱️' },
  3 => { id: 3, name: 'Keyboard', price: 79.99, image: '⌨️' },
  4 => { id: 4, name: 'Monitor', price: 349.99, image: '🖥️' },
  5 => { id: 5, name: 'Headphones', price: 149.99, image: '🎧' },
  6 => { id: 6, name: 'Webcam', price: 89.99, image: '📹' },
  7 => { id: 7, name: 'Microphone', price: 129.99, image: '🎤' },
  8 => { id: 8, name: 'USB Cable', price: 12.99, image: '🔌' }
}

helpers do
  def cart
    session[:cart] ||= {}
  end

  def cart_count
    cart.values.sum
  end

  def cart_total
    cart.sum do |product_id, quantity|
      product = PRODUCTS[product_id.to_i]
      product ? product[:price] * quantity : 0
    end
  end

  def cart_items
    cart.map do |product_id, quantity|
      product = PRODUCTS[product_id.to_i]
      next unless product

      {
        product: product,
        quantity: quantity,
        subtotal: product[:price] * quantity
      }
    end.compact
  end

  def flash(key, message)
    session["flash_#{key}".to_sym] = message
  end

  def get_flash(key)
    session.delete("flash_#{key}".to_sym)
  end

  def format_price(price)
    sprintf('$%.2f', price)
  end
end

# Home page - product catalog
get '/' do
  @products = PRODUCTS.values
  @success = get_flash(:success)
  erb :index
end

# View cart
get '/cart' do
  @cart_items = cart_items
  @total = cart_total
  @success = get_flash(:success)
  erb :cart
end

# Add to cart
post '/cart/add/:id' do
  product_id = params[:id].to_i
  product = PRODUCTS[product_id]

  halt 404, 'Product not found' unless product

  quantity = params[:quantity]&.to_i || 1
  cart[product_id] ||= 0
  cart[product_id] += quantity

  flash(:success, "#{product[:name]} added to cart!")

  if request.xhr?
    content_type :json
    { success: true, cart_count: cart_count }.to_json
  else
    redirect back
  end
end

# Update cart quantity
post '/cart/update/:id' do
  product_id = params[:id].to_i
  quantity = params[:quantity].to_i

  if quantity > 0
    cart[product_id] = quantity
    flash(:success, 'Cart updated!')
  elsif quantity == 0
    cart.delete(product_id)
    flash(:success, 'Item removed from cart')
  end

  redirect '/cart'
end

# Remove from cart
post '/cart/remove/:id' do
  product_id = params[:id].to_i
  product = PRODUCTS[product_id]

  if cart.delete(product_id)
    flash(:success, "#{product[:name]} removed from cart")
  end

  redirect '/cart'
end

# Clear cart
post '/cart/clear' do
  session.delete(:cart)
  flash(:success, 'Cart cleared!')
  redirect '/'
end

# Checkout
get '/checkout' do
  redirect '/cart' if cart.empty?

  @cart_items = cart_items
  @total = cart_total
  erb :checkout
end

# Process checkout
post '/checkout' do
  halt 400, 'Cart is empty' if cart.empty?

  # In a real app, process payment here
  order_number = rand(10000..99999)
  total = cart_total

  # Clear cart after checkout
  session.delete(:cart)

  @order_number = order_number
  @total = total
  erb :order_confirmation
end

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Shopping Cart Demo</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
      background: #f5f5f5;
      padding-bottom: 2rem;
    }

    header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 1.5rem 0;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .header-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    header h1 {
      font-size: 1.75rem;
    }

    header a {
      color: white;
      text-decoration: none;
    }

    .cart-badge {
      position: relative;
      display: inline-block;
    }

    .cart-count {
      position: absolute;
      top: -8px;
      right: -8px;
      background: #ff4757;
      color: white;
      border-radius: 50%;
      width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.75rem;
      font-weight: bold;
    }

    .container {
      max-width: 1200px;
      margin: 2rem auto;
      padding: 0 2rem;
    }

    .success {
      background: #d4edda;
      border: 1px solid #c3e6cb;
      color: #155724;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 1.5rem;
    }

    .product-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 2rem;
    }

    .product-card {
      background: white;
      border-radius: 10px;
      padding: 1.5rem;
      text-align: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      transition: transform 0.2s;
    }

    .product-card:hover {
      transform: translateY(-5px);
    }

    .product-image {
      font-size: 4rem;
      margin-bottom: 1rem;
    }

    .product-name {
      font-size: 1.25rem;
      font-weight: 600;
      margin-bottom: 0.5rem;
      color: #333;
    }

    .product-price {
      font-size: 1.5rem;
      color: #667eea;
      font-weight: bold;
      margin-bottom: 1rem;
    }

    .btn {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      border: none;
      cursor: pointer;
      font-size: 1rem;
      font-weight: 600;
      transition: transform 0.2s;
    }

    .btn:hover {
      transform: translateY(-2px);
    }

    .btn-danger {
      background: #dc3545;
    }

    .btn-success {
      background: #28a745;
    }

    .btn-small {
      padding: 0.5rem 1rem;
      font-size: 0.875rem;
    }

    .cart-table {
      width: 100%;
      background: white;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .cart-table th,
    .cart-table td {
      padding: 1rem;
      text-align: left;
    }

    .cart-table th {
      background: #667eea;
      color: white;
    }

    .cart-table tr:nth-child(even) {
      background: #f8f9fa;
    }

    .quantity-control {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .quantity-control input {
      width: 60px;
      padding: 0.5rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      text-align: center;
    }

    .cart-summary {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      margin-top: 2rem;
    }

    .summary-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 1rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid #e0e0e0;
    }

    .summary-row:last-child {
      border-bottom: none;
      font-size: 1.5rem;
      font-weight: bold;
      color: #667eea;
    }

    .empty-cart {
      text-align: center;
      padding: 4rem 2rem;
      background: white;
      border-radius: 10px;
    }

    .empty-cart h2 {
      color: #999;
      margin-bottom: 1rem;
    }

    .checkout-form {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      margin-top: 2rem;
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 600;
      color: #555;
    }

    input[type="text"],
    input[type="email"],
    select {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e0e0e0;
      border-radius: 5px;
      font-size: 1rem;
    }

    .confirmation-box {
      background: white;
      padding: 3rem;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .confirmation-box h1 {
      color: #28a745;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>
  <header>
    <div class="header-content">
      <h1><a href="/">🛒 Shopping Cart Demo</a></h1>
      <div>
        <a href="/cart" class="cart-badge">
          🛒 Cart
          <% if cart_count > 0 %>
            <span class="cart-count"><%= cart_count %></span>
          <% end %>
        </a>
      </div>
    </div>
  </header>

  <div class="container">
    <%= yield %>
  </div>
</body>
</html>

@@index
<% if @success %>
  <div class="success"><%= @success %></div>
<% end %>

<h2 style="margin-bottom: 1.5rem;">Products</h2>

<div class="product-grid">
  <% @products.each do |product| %>
    <div class="product-card">
      <div class="product-image"><%= product[:image] %></div>
      <div class="product-name"><%= product[:name] %></div>
      <div class="product-price"><%= format_price(product[:price]) %></div>
      <form action="/cart/add/<%= product[:id] %>" method="post">
        <button type="submit" class="btn">Add to Cart</button>
      </form>
    </div>
  <% end %>
</div>

@@cart
<% if @success %>
  <div class="success"><%= @success %></div>
<% end %>

<h2 style="margin-bottom: 1.5rem;">Shopping Cart</h2>

<% if @cart_items.empty? %>
  <div class="empty-cart">
    <h2>Your cart is empty</h2>
    <p>Add some products to get started!</p>
    <a href="/" class="btn" style="margin-top: 1rem;">Continue Shopping</a>
  </div>
<% else %>
  <table class="cart-table">
    <thead>
      <tr>
        <th>Product</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% @cart_items.each do |item| %>
        <tr>
          <td>
            <strong><%= item[:product][:image] %> <%= item[:product][:name] %></strong>
          </td>
          <td><%= format_price(item[:product][:price]) %></td>
          <td>
            <form action="/cart/update/<%= item[:product][:id] %>" method="post" class="quantity-control">
              <input type="number" name="quantity" value="<%= item[:quantity] %>" min="0">
              <button type="submit" class="btn btn-small">Update</button>
            </form>
          </td>
          <td><strong><%= format_price(item[:subtotal]) %></strong></td>
          <td>
            <form action="/cart/remove/<%= item[:product][:id] %>" method="post" style="display: inline;">
              <button type="submit" class="btn btn-small btn-danger">Remove</button>
            </form>
          </td>
        </tr>
      <% end %>
    </tbody>
  </table>

  <div class="cart-summary">
    <div class="summary-row">
      <span>Total:</span>
      <span><%= format_price(@total) %></span>
    </div>

    <div style="display: flex; gap: 1rem; justify-content: flex-end; margin-top: 1.5rem;">
      <a href="/" class="btn" style="background: #6c757d;">Continue Shopping</a>
      <form action="/cart/clear" method="post" style="display: inline;" onsubmit="return confirm('Clear entire cart?')">
        <button type="submit" class="btn btn-danger">Clear Cart</button>
      </form>
      <a href="/checkout" class="btn btn-success">Proceed to Checkout</a>
    </div>
  </div>
<% end %>

@@checkout
<h2 style="margin-bottom: 1.5rem;">Checkout</h2>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
  <div class="checkout-form">
    <h3 style="margin-bottom: 1.5rem;">Shipping Information</h3>
    <form action="/checkout" method="post">
      <div class="form-group">
        <label for="name">Full Name *</label>
        <input type="text" id="name" name="name" required>
      </div>

      <div class="form-group">
        <label for="email">Email *</label>
        <input type="email" id="email" name="email" required>
      </div>

      <div class="form-group">
        <label for="address">Address *</label>
        <input type="text" id="address" name="address" required>
      </div>

      <div class="form-group">
        <label for="city">City *</label>
        <input type="text" id="city" name="city" required>
      </div>

      <div class="form-group">
        <label for="country">Country *</label>
        <select id="country" name="country" required>
          <option value="">Select country</option>
          <option value="US">United States</option>
          <option value="CA">Canada</option>
          <option value="UK">United Kingdom</option>
          <option value="AU">Australia</option>
        </select>
      </div>

      <button type="submit" class="btn btn-success" style="width: 100%;">
        Place Order
      </button>
    </form>
  </div>

  <div>
    <div class="cart-summary">
      <h3 style="margin-bottom: 1.5rem;">Order Summary</h3>

      <% @cart_items.each do |item| %>
        <div class="summary-row">
          <span><%= item[:product][:name] %> × <%= item[:quantity] %></span>
          <span><%= format_price(item[:subtotal]) %></span>
        </div>
      <% end %>

      <div class="summary-row">
        <span>Shipping:</span>
        <span>FREE</span>
      </div>

      <div class="summary-row">
        <strong>Total:</strong>
        <strong><%= format_price(@total) %></strong>
      </div>
    </div>
  </div>
</div>

@@order_confirmation
<div class="confirmation-box">
  <h1>✅ Order Confirmed!</h1>
  <p style="font-size: 1.25rem; color: #666; margin: 1rem 0;">
    Thank you for your order!
  </p>
  <div style="background: #f8f9fa; padding: 2rem; border-radius: 10px; margin: 2rem 0;">
    <p style="font-size: 0.875rem; color: #666;">Order Number</p>
    <p style="font-size: 2rem; font-weight: bold; color: #667eea;">
      #<%= @order_number %>
    </p>
    <p style="font-size: 1.5rem; margin-top: 1rem;">
      Total: <%= format_price(@total) %>
    </p>
  </div>
  <p style="color: #666; margin-bottom: 2rem;">
    A confirmation email has been sent to your email address.
  </p>
  <a href="/" class="btn">Continue Shopping</a>
</div>
