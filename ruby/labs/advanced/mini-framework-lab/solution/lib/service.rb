# Service Objects

class ValidationError < StandardError; end

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

# Example service implementations
class CreateRecordService < Service
  def initialize(model_class, params)
    @model_class = model_class
    @params = params
  end

  def call
    validate!
    record = @model_class.create(@params)
    after_create(record)
    { success: true, record: record }
  rescue ValidationError => e
    { success: false, error: e.message }
  end

  private

  def validate!
    # Override in subclasses
  end

  def after_create(record)
    # Override in subclasses
  end
end
