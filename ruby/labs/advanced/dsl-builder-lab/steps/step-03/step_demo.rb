#!/usr/bin/env ruby
# Step 3: Validation and Type Checking

class ConfigError < StandardError; end

class AppConfig
  def self.configure(&block)
    @config = new
    @config.instance_eval(&block)
    @config
  end

  def self.config
    @config
  end

  def method_missing(method_name, *args, &block)
    if block_given?
      nested = NestedConfig.new
      nested.instance_eval(&block)
      instance_variable_set("@#{method_name}", nested)
    elsif args.empty?
      instance_variable_get("@#{method_name}")
    else
      instance_variable_set("@#{method_name}", args.first)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end

  def validate!
    raise ConfigError, "app_name is required" unless @app_name
    raise ConfigError, "version is required" unless @version

    if @database
      raise ConfigError, "database.host is required" unless @database.host
      raise ConfigError, "database.port must be a number" unless @database.port.is_a?(Integer)
    end
    
    true
  end

  def to_h
    hash = {}
    instance_variables.each do |var|
      key = var.to_s.delete('@').to_sym
      value = instance_variable_get(var)
      hash[key] = value.respond_to?(:to_h) ? value.to_h : value
    end
    hash
  end

  class NestedConfig
    def method_missing(method_name, *args)
      if args.empty?
        instance_variable_get("@#{method_name}")
      else
        instance_variable_set("@#{method_name}", args.first)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end

    def to_h
      hash = {}
      instance_variables.each do |var|
        key = var.to_s.delete('@').to_sym
        value = instance_variable_get(var)
        hash[key] = value
      end
      hash
    end
  end
end

# Test it
puts "=" * 60
puts "Step 3: Configuration Validation"
puts "=" * 60
puts

# Valid configuration
config = AppConfig.configure do
  app_name "My App"
  version "1.0.0"

  database do
    host "localhost"
    port 5432
  end
end

puts "Valid configuration:"
puts "  Validation: #{config.validate! ? 'passed' : 'failed'}"
puts "  As hash: #{config.to_h}"
puts

# Invalid configuration test
puts "Testing invalid configuration..."
begin
  invalid_config = AppConfig.configure do
    # Missing app_name!
    version "1.0.0"
  end
  invalid_config.validate!
rescue ConfigError => e
  puts "  ✓ Caught validation error: #{e.message}"
end

puts
puts "✓ Step 3 complete!"
