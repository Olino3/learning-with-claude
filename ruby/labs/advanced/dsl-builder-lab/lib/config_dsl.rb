# Configuration DSL - Build elegant configuration systems

class ConfigDSL
  def initialize
    @config = {}
  end
  
  def configure(&block)
    instance_eval(&block)
    self
  end
  
  def method_missing(method_name, *args, &block)
    method_str = method_name.to_s
    
    if block
      # Nested configuration
      nested = ConfigDSL.new
      nested.instance_eval(&block)
      @config[method_name] = nested.to_h
    elsif args.size == 1
      # Simple setter
      @config[method_name] = args.first
    elsif args.empty?
      # Getter
      @config[method_name]
    else
      super
    end
  end
  
  def respond_to_missing?(method_name, include_private = false)
    true
  end
  
  def to_h
    @config
  end
  
  def get(key)
    @config[key]
  end
  
  def [](key)
    @config[key]
  end
  
  def self.build(&block)
    new.configure(&block)
  end
end

# Application Configuration with validation
class AppConfig < ConfigDSL
  REQUIRED_FIELDS = [:app_name, :version].freeze
  
  def validate!
    missing = REQUIRED_FIELDS.select { |field| @config[field].nil? }
    raise "Missing required fields: #{missing.join(', ')}" unless missing.empty?
  end
  
  def self.load(&block)
    config = build(&block)
    config.validate!
    config
  end
end

# Database Configuration DSL
class DatabaseConfig < ConfigDSL
  def adapter(name)
    @config[:adapter] = name
    self
  end
  
  def connection_pool(size)
    @config[:pool_size] = size
    self
  end
  
  def timeout(seconds)
    @config[:timeout] = seconds
    self
  end
end
