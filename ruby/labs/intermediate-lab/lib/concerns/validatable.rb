# Validatable Concern (Tutorial 13 + 14: Mixins + Metaprogramming)
# Provides validation framework using DSL

module Validatable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      @validations = []
    end
  end

  module ClassMethods
    attr_reader :validations

    # DSL for defining validations (Tutorial 14: Metaprogramming)
    def validates(attribute, *rules, **options)
      @validations ||= []

      # Presence validation
      if options[:presence]
        @validations << {
          attribute: attribute,
          validator: ->(value) { !value.nil? && !value.to_s.strip.empty? },
          message: "#{attribute} can't be blank"
        }
      end

      # Length validation
      if options[:length]
        min = options[:length][:min] || options[:length][:minimum]
        max = options[:length][:max] || options[:length][:maximum]

        if min
          @validations << {
            attribute: attribute,
            validator: ->(value) { value.to_s.length >= min },
            message: "#{attribute} must be at least #{min} characters"
          }
        end

        if max
          @validations << {
            attribute: attribute,
            validator: ->(value) { value.to_s.length <= max },
            message: "#{attribute} must be at most #{max} characters"
          }
        end
      end

      # Custom lambda validator (Tutorial 11: Closures)
      rules.each do |rule|
        if rule.is_a?(Proc)
          @validations << {
            attribute: attribute,
            validator: rule,
            message: "#{attribute} is invalid"
          }
        end
      end
    end
  end

  def valid?
    errors.empty?
  end

  def errors
    @errors ||= []
    @errors.clear

    self.class.validations&.each do |validation|
      attribute = validation[:attribute]
      value = send(attribute) rescue nil

      unless validation[:validator].call(value)
        @errors << validation[:message]
      end
    end

    @errors
  end

  def validate!
    raise BlogSystem::ValidationError.new(errors) unless valid?
  end
end
