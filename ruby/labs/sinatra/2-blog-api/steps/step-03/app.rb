#!/usr/bin/env ruby
# frozen_string_literal: true

# Step 3: User Model with Authentication
# Adding User model with BCrypt password hashing

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'bcrypt'

# Configure Sinatra
set :port, 4567
set :bind, '0.0.0.0'
set :database, { adapter: 'sqlite3', database: 'blog_api.db' }

# Create tables if they don't exist
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists? 'users'
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end

# User Model
class User < ActiveRecord::Base
  attr_accessor :password

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  before_save :hash_password, if: :password_present?

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def as_json(options = {})
    super(options.merge(except: [:password_digest]))
  end

  private

  def password_required?
    password_digest.blank?
  end

  def password_present?
    password.present?
  end

  def hash_password
    self.password_digest = BCrypt::Password.create(password)
  end
end

# Seed sample user
if User.count == 0
  User.create!(email: 'test@example.com', password: 'password123', name: 'Test User')
  puts "Created sample user: test@example.com / password123"
end

# Set content type to JSON for all responses
before do
  content_type :json
end

# API root
get '/' do
  {
    name: 'Blog API',
    version: '1.0',
    status: 'running'
  }.to_json
end

# Health check
get '/api/v1/health' do
  {
    status: 'ok',
    timestamp: Time.now,
    users_count: User.count
  }.to_json
end

# List users
get '/api/v1/users' do
  User.all.to_json
end

if __FILE__ == $0
  puts "Starting Blog API with User model..."
  Sinatra::Application.run!
end
