#!/usr/bin/env ruby
# Step 1: Basic Configuration with instance_eval

class AppConfig
  def self.configure(&block)
    @config = new
    @config.instance_eval(&block)
    @config
  end

  def self.config
    @config
  end

  def method_missing(method_name, *args)
    if args.empty?
      # Getter
      instance_variable_get("@#{method_name}")
    else
      # Setter
      instance_variable_set("@#{method_name}", args.first)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end

# Test it
puts "=" * 60
puts "Step 1: Basic Configuration DSL"
puts "=" * 60
puts

AppConfig.configure do
  app_name "My App"
  version "1.0.0"
  environment "development"
end

puts "Configuration values:"
puts "  app_name: #{AppConfig.config.app_name}"
puts "  version: #{AppConfig.config.version}"
puts "  environment: #{AppConfig.config.environment}"
puts
puts "✓ Step 1 complete!"
