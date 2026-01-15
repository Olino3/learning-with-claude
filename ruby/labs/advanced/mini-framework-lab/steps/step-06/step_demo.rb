#!/usr/bin/env ruby
# Step 6: Model Layer

puts "=" * 60
puts "Step 6: Model Layer (ActiveRecord Pattern)"
puts "=" * 60
puts

class Model
  @@stores = {}

  def self.inherited(subclass)
    @@stores[subclass] = []
  end

  def self.store
    @@stores[self] ||= []
  end

  def self.all
    store
  end

  def self.find(id)
    store.find { |record| record.id == id }
  end

  def self.where(conditions)
    store.select do |record|
      conditions.all? { |attr, value| record.send(attr) == value }
    end
  end

  def self.create(attributes)
    instance = new(attributes)
    instance.save
    instance
  end

  def self.count
    store.size
  end

  attr_reader :id, :created_at

  def initialize(attributes = {})
    @id = generate_id
    @created_at = Time.now
    @attributes = attributes
    create_accessors
  end

  def save
    self.class.store << self unless self.class.store.include?(self)
    self
  end

  def update(attributes)
    @attributes.merge!(attributes)
    create_accessors
    self
  end

  def destroy
    self.class.store.delete(self)
  end

  private

  def generate_id
    self.class.store.size + 1
  end

  def create_accessors
    @attributes.each do |key, value|
      define_singleton_method(key) { @attributes[key] }
      define_singleton_method("#{key}=") { |val| @attributes[key] = val }
    end
  end
end

# Define models
class User < Model; end
class Post < Model; end

# Test Model operations
puts "Creating records:"
puts "-" * 60

alice = User.create(name: "Alice", email: "alice@example.com", active: true)
bob = User.create(name: "Bob", email: "bob@example.com", active: true)
charlie = User.create(name: "Charlie", email: "charlie@example.com", active: false)

post1 = Post.create(title: "Hello World", user_id: alice.id)
post2 = Post.create(title: "Ruby Tips", user_id: alice.id)
post3 = Post.create(title: "First Post", user_id: bob.id)

puts "Created #{User.count} users and #{Post.count} posts"
puts

puts "Query operations:"
puts "-" * 60

puts "All users:"
User.all.each { |u| puts "  - #{u.name} (#{u.email})" }
puts

puts "Find user by ID (#{alice.id}):"
found = User.find(alice.id)
puts "  Found: #{found&.name}"
puts

puts "Where active: true:"
User.where(active: true).each { |u| puts "  - #{u.name}" }
puts

puts "Update and delete:"
puts "-" * 60

bob.update(name: "Robert", email: "robert@example.com")
puts "Updated Bob to: #{bob.name} (#{bob.email})"

charlie.destroy
puts "Deleted Charlie"
puts "Remaining users: #{User.count}"
puts

puts "✓ Step 6 complete!"
