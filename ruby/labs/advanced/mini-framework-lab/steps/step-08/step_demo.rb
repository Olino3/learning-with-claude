#!/usr/bin/env ruby
# Step 8: Design Patterns

puts "=" * 60
puts "Step 8: Design Patterns"
puts "=" * 60
puts

# ============================================================
# Pattern 1: Singleton
# ============================================================
puts "1. Singleton Pattern (Configuration)"
puts "-" * 60

require 'singleton'

class Configuration
  include Singleton

  attr_accessor :database_url, :api_key, :debug_mode

  def initialize
    @database_url = "localhost:5432"
    @api_key = "default_key"
    @debug_mode = false
  end
end

# Both references point to the same instance
config1 = Configuration.instance
config2 = Configuration.instance

config1.debug_mode = true
puts "  config1.debug_mode = true"
puts "  config2.debug_mode = #{config2.debug_mode}"
puts "  Same instance? #{config1.object_id == config2.object_id}"
puts

# ============================================================
# Pattern 2: Factory
# ============================================================
puts "2. Factory Pattern"
puts "-" * 60

class Controller
  def handle
    "Base handler"
  end
end

class UsersController < Controller
  def handle
    "Users handler"
  end
end

class PostsController < Controller
  def handle
    "Posts handler"
  end
end

class ControllerFactory
  CONTROLLERS = {
    "users" => UsersController,
    "posts" => PostsController
  }

  def self.create(name)
    klass = CONTROLLERS[name] || Controller
    klass.new
  end
end

["users", "posts", "unknown"].each do |name|
  controller = ControllerFactory.create(name)
  puts "  Factory.create('#{name}') => #{controller.class.name}.handle => #{controller.handle}"
end
puts

# ============================================================
# Pattern 3: Decorator
# ============================================================
puts "3. Decorator Pattern (Cached Model)"
puts "-" * 60

class UserModel
  def find(id)
    puts "    [DB] Fetching user #{id} from database..."
    sleep(0.1)  # Simulate slow query
    { id: id, name: "User #{id}" }
  end

  def all
    puts "    [DB] Fetching all users from database..."
    sleep(0.1)
    [{ id: 1, name: "Alice" }, { id: 2, name: "Bob" }]
  end
end

class CachedModel
  def initialize(model)
    @model = model
    @cache = {}
  end

  def find(id)
    puts "    [Cache] Checking cache for user #{id}..."
    @cache["find_#{id}"] ||= @model.find(id)
  end

  def all
    puts "    [Cache] Checking cache for all users..."
    @cache["all"] ||= @model.all
  end

  def invalidate_cache
    @cache.clear
    puts "    [Cache] Cache invalidated"
  end
end

model = CachedModel.new(UserModel.new)

puts "  First call (cache miss):"
model.find(1)

puts "  Second call (cache hit):"
model.find(1)

puts "  Third call (different ID, cache miss):"
model.find(2)
puts

# ============================================================
# Pattern 4: Observer (simple version)
# ============================================================
puts "4. Observer Pattern (Events)"
puts "-" * 60

class EventEmitter
  def initialize
    @listeners = Hash.new { |h, k| h[k] = [] }
  end

  def on(event, &block)
    @listeners[event] << block
  end

  def emit(event, *args)
    @listeners[event].each { |listener| listener.call(*args) }
  end
end

events = EventEmitter.new

events.on(:user_created) { |user| puts "    [Logger] User created: #{user[:name]}" }
events.on(:user_created) { |user| puts "    [Email] Welcome email sent to #{user[:email]}" }
events.on(:user_deleted) { |id| puts "    [Cleanup] Removing data for user #{id}" }

puts "  Emitting :user_created"
events.emit(:user_created, { name: "Alice", email: "alice@example.com" })

puts "  Emitting :user_deleted"
events.emit(:user_deleted, 42)
puts

puts "✓ Step 8 complete!"
