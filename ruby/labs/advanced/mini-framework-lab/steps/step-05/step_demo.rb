#!/usr/bin/env ruby
# Step 5: Simple Template System

puts "=" * 60
puts "Step 5: Simple Template System"
puts "=" * 60
puts

class View
  def initialize(template_name, locals = {})
    @template_name = template_name
    @locals = locals
  end

  def render
    template = load_template
    evaluate_template(template)
  end

  private

  def load_template
    # In a real app, this would load from a file
    # For demo, we use inline templates
    templates = {
      "users/index" => <<~HTML,
        <h1>Users</h1>
        <ul>
          {{ users_list }}
        </ul>
      HTML
      "users/show" => <<~HTML,
        <h1>User Profile</h1>
        <p>Name: {{ name }}</p>
        <p>Email: {{ email }}</p>
      HTML
      "home/index" => <<~HTML
        <h1>Welcome, {{ username }}!</h1>
        <p>Today is {{ date }}</p>
      HTML
    }

    templates[@template_name] || "<p>Template not found: #{@template_name}</p>"
  end

  def evaluate_template(template)
    result = template.dup
    @locals.each do |key, value|
      result.gsub!(/\{\{\s*#{key}\s*\}\}/, value.to_s)
    end
    result
  end
end

# ERB-style View (bonus)
require 'erb'

class ERBView
  def initialize(template_string, locals = {})
    @template = template_string
    @locals = locals
  end

  def render
    # Create binding with locals
    b = binding
    @locals.each do |key, value|
      b.local_variable_set(key, value)
    end
    ERB.new(@template).result(b)
  end
end

# Test simple View
puts "Simple Template System:"
puts "-" * 60

view = View.new("home/index", {
  username: "Alice",
  date: Time.now.strftime("%B %d, %Y")
})
puts view.render
puts

view = View.new("users/show", {
  name: "Bob",
  email: "bob@example.com"
})
puts view.render
puts

# Test ERB View
puts "ERB-style Template:"
puts "-" * 60

erb_template = <<~ERB
  <h1>Products</h1>
  <ul>
  <% products.each do |product| %>
    <li><%= product[:name] %> - $<%= product[:price] %></li>
  <% end %>
  </ul>
ERB

erb_view = ERBView.new(erb_template, {
  products: [
    { name: "Widget", price: 9.99 },
    { name: "Gadget", price: 19.99 },
    { name: "Gizmo", price: 29.99 }
  ]
})
puts erb_view.render
puts

puts "✓ Step 5 complete!"
