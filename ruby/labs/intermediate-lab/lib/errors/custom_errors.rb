# Custom Error Hierarchy (Tutorial 15: Error Handling)

module BlogSystem
  # Base application error
  class Error < StandardError
    attr_reader :context

    def initialize(message, context = {})
      super(message)
      @context = context
    end

    def full_message
      return message if context.empty?

      details = context.map { |k, v| "#{k}: #{v}" }.join(", ")
      "#{message} (#{details})"
    end
  end

  # Validation errors
  class ValidationError < Error
    attr_reader :errors

    def initialize(errors = [])
      @errors = errors
      super("Validation failed: #{errors.join(', ')}")
    end
  end

  # Not found errors
  class NotFoundError < Error
    def initialize(resource, id = nil)
      message = id ? "#{resource} with id #{id} not found" : "#{resource} not found"
      super(message, { resource: resource, id: id })
    end
  end

  # Database errors
  class DatabaseError < Error; end

  # Permission errors
  class PermissionError < Error; end
end
