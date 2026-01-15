# Model with ActiveRecord Pattern

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

  def attributes
    @attributes.merge(id: @id, created_at: @created_at)
  end

  private

  def generate_id
    "#{self.class.name.downcase}_#{Time.now.to_i}_#{rand(10000)}"
  end

  def create_accessors
    @attributes.each do |key, value|
      define_singleton_method(key) { @attributes[key] }
      define_singleton_method("#{key}=") { |val| @attributes[key] = val }
    end
  end
end
