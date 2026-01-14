#!/usr/bin/env ruby
# Step 2: Nested Configuration

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
      # Nested configuration
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
  end
end

# Test it
puts "=" * 60
puts "Step 2: Nested Configuration DSL"
puts "=" * 60
puts

AppConfig.configure do
  app_name "My App"
  version "1.0.0"

  database do
    host "localhost"
    port 5432
    name "myapp_db"
  end

  cache do
    enabled true
    ttl 3600
  end
end

puts "Configuration with nesting:"
puts "  app_name: #{AppConfig.config.app_name}"
puts "  database.host: #{AppConfig.config.database.host}"
puts "  database.port: #{AppConfig.config.database.port}"
puts "  cache.enabled: #{AppConfig.config.cache.enabled}"
puts "  cache.ttl: #{AppConfig.config.cache.ttl}"
puts
puts "✓ Step 2 complete!"
