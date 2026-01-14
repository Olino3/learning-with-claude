#!/usr/bin/env ruby
# Step 7: Service Objects

puts "=" * 60
puts "Step 7: Service Objects"
puts "=" * 60
puts

class ValidationError < StandardError; end

# Base Service class
class Service
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs).call(&block)
  end

  def initialize(*args, **kwargs)
    # Override in subclasses
  end

  def call
    raise NotImplementedError, "Subclasses must implement #call"
  end
end

# Simple Model for demo
class User
  @@users = []
  @@id_counter = 0
  
  attr_reader :id, :name, :email
  
  def self.create(attrs)
    @@id_counter += 1
    user = new(@@id_counter, attrs[:name], attrs[:email])
    @@users << user
    user
  end
  
  def self.find_by_email(email)
    @@users.find { |u| u.email == email }
  end
  
  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end
end

# User Registration Service
class UserRegistrationService < Service
  def initialize(params)
    @params = params
  end

  def call
    validate_params!
    check_email_uniqueness!
    user = create_user
    send_welcome_email(user)
    
    { success: true, user: user }
  rescue ValidationError => e
    { success: false, error: e.message }
  end

  private

  def validate_params!
    raise ValidationError, "Name is required" if @params[:name].to_s.empty?
    raise ValidationError, "Email is required" if @params[:email].to_s.empty?
    raise ValidationError, "Invalid email format" unless @params[:email].to_s.include?("@")
  end

  def check_email_uniqueness!
    if User.find_by_email(@params[:email])
      raise ValidationError, "Email already taken"
    end
  end

  def create_user
    User.create(@params)
  end

  def send_welcome_email(user)
    puts "    [Email] Sending welcome email to #{user.email}"
  end
end

# Password Reset Service
class PasswordResetService < Service
  def initialize(email)
    @email = email
  end

  def call
    user = User.find_by_email(@email)
    raise ValidationError, "User not found" unless user
    
    token = generate_token
    send_reset_email(user, token)
    
    { success: true, message: "Reset email sent" }
  rescue ValidationError => e
    { success: false, error: e.message }
  end

  private

  def generate_token
    SecureRandom.hex(20) rescue "demo_token_#{rand(10000)}"
  end

  def send_reset_email(user, token)
    puts "    [Email] Sending password reset to #{user.email}"
  end
end

# Test services
puts "User Registration Service:"
puts "-" * 60

# Successful registration
result = UserRegistrationService.call(name: "Alice", email: "alice@example.com")
puts "  Register Alice: #{result[:success] ? "Success (ID: #{result[:user].id})" : result[:error]}"

# Duplicate email
result = UserRegistrationService.call(name: "Alice2", email: "alice@example.com")
puts "  Register duplicate: #{result[:success] ? 'Success' : result[:error]}"

# Missing fields
result = UserRegistrationService.call(name: "", email: "bob@example.com")
puts "  Register without name: #{result[:success] ? 'Success' : result[:error]}"

# Invalid email
result = UserRegistrationService.call(name: "Bob", email: "invalid-email")
puts "  Register invalid email: #{result[:success] ? 'Success' : result[:error]}"
puts

puts "Password Reset Service:"
puts "-" * 60

result = PasswordResetService.call("alice@example.com")
puts "  Reset for Alice: #{result[:success] ? result[:message] : result[:error]}"

result = PasswordResetService.call("unknown@example.com")
puts "  Reset for unknown: #{result[:success] ? result[:message] : result[:error]}"
puts

puts "✓ Step 7 complete!"
