# frozen_string_literal: true

# ConfigValidator validates configuration against defined schemas
# to ensure data integrity and type safety.
#
# Design Patterns:
# - Validator Pattern: Encapsulates validation logic
# - Strategy Pattern: Different validation strategies
#
# Example:
#   schema = {
#     'DATABASE_URL' => { type: :string, required: true },
#     'PORT' => { type: :integer, required: false, default: 3000 }
#   }
#   validator = ConfigValidator.new(schema)
#   validator.validate!(config)
class ConfigValidator
  class ValidationError < StandardError; end

  VALID_TYPES = %i[string integer float boolean].freeze

  attr_reader :schema

  # Creates a new ConfigValidator
  #
  # @param schema [Hash] Validation schema
  def initialize(schema = {})
    @schema = schema
    validate_schema!
  end

  # Validates configuration
  #
  # @param config [Hash] Configuration to validate
  # @return [Boolean] true if valid
  # @raise [ValidationError] if validation fails
  def validate!(config)
    errors = []

    schema.each do |key, rules|
      value = config[key]

      # Check required
      if rules[:required] && (value.nil? || value.to_s.strip.empty?)
        errors << "#{key} is required but missing"
        next
      end

      # Skip further validation if optional and missing
      next if value.nil? && !rules[:required]

      # Type validation
      if rules[:type]
        unless valid_type?(value, rules[:type])
          errors << "#{key} must be of type #{rules[:type]}, got #{value.class}"
        end
      end

      # Pattern validation (for strings)
      if rules[:pattern] && value.is_a?(String)
        unless value.match?(rules[:pattern])
          errors << "#{key} does not match required pattern"
        end
      end

      # Range validation (for numbers)
      if rules[:min] && value.is_a?(Numeric) && value < rules[:min]
        errors << "#{key} must be at least #{rules[:min]}"
      end

      if rules[:max] && value.is_a?(Numeric) && value > rules[:max]
        errors << "#{key} must be at most #{rules[:max]}"
      end

      # Enum validation
      if rules[:enum] && !rules[:enum].include?(value)
        errors << "#{key} must be one of: #{rules[:enum].join(', ')}"
      end
    end

    raise ValidationError, "Validation failed:\n  - #{errors.join("\n  - ")}" unless errors.empty?

    true
  end

  # Checks if configuration is valid
  #
  # @param config [Hash] Configuration to validate
  # @return [Boolean] true if valid
  def valid?(config)
    validate!(config)
    true
  rescue ValidationError
    false
  end

  # Validates a single key
  #
  # @param key [String] Configuration key
  # @param value [Object] Value to validate
  # @return [Boolean] true if valid
  def valid_key?(key, value)
    return true unless schema.key?(key)

    rules = schema[key]

    return false if rules[:required] && value.nil?
    return true if value.nil? && !rules[:required]

    valid_type?(value, rules[:type]) if rules[:type]
  end

  private

  # Validates schema definition
  def validate_schema!
    schema.each do |key, rules|
      next unless rules[:type]

      unless VALID_TYPES.include?(rules[:type])
        raise ArgumentError, "Invalid type for #{key}: #{rules[:type]}"
      end
    end
  end

  # Checks if value matches expected type
  def valid_type?(value, type)
    case type
    when :string
      value.is_a?(String)
    when :integer
      value.is_a?(Integer) || (value.is_a?(String) && value.match?(/\A-?\d+\z/))
    when :float
      value.is_a?(Float) || value.is_a?(Numeric)
    when :boolean
      [true, false, 'true', 'false', '1', '0'].include?(value)
    else
      false
    end
  end
end
