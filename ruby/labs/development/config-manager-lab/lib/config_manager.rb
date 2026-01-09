# frozen_string_literal: true

require_relative 'loaders/env_loader'
require_relative 'validators/config_validator'
require_relative 'encryption/encryptor'

# ConfigManager is the main facade for configuration management,
# providing loading, validation, and encryption services.
#
# Design Patterns:
# - Facade Pattern: Simplifies complex subsystem
# - Singleton: Shared configuration state
#
# Example:
#   config = ConfigManager.new
#   database_url = config.get('DATABASE_URL')
#   config.validate!
class ConfigManager
  attr_reader :loader, :validator, :encryptor, :config

  # Creates a new ConfigManager
  #
  # @param loader [EnvLoader] Configuration loader
  # @param validator [ConfigValidator] Configuration validator
  # @param encryptor [Encryptor] Encryption service
  # @param schema [Hash] Validation schema (optional)
  def initialize(loader: nil, validator: nil, encryptor: nil, schema: nil)
    @loader = loader || EnvLoader.new
    @validator = validator || (schema ? ConfigValidator.new(schema) : nil)
    @encryptor = encryptor || (ENV['ENCRYPTION_KEY'] ? Encryptor.new : nil)
    @config = nil
  end

  # Loads configuration
  #
  # @return [Hash] Configuration hash
  def load
    @config = loader.load
  end

  # Gets configuration value
  #
  # @param key [String] Configuration key
  # @param default [Object] Default value if key not found
  # @return [Object] Configuration value
  def get(key, default: nil)
    load unless @config
    @config[key] || default
  end

  # Sets configuration value
  #
  # @param key [String] Configuration key
  # @param value [Object] Configuration value
  def set(key, value)
    load unless @config
    @config[key] = value
  end

  # Checks if key exists
  #
  # @param key [String] Configuration key
  # @return [Boolean] true if key exists
  def key?(key)
    load unless @config
    @config.key?(key)
  end

  # Validates configuration
  #
  # @raise [ConfigValidator::ValidationError] if invalid
  def validate!
    raise 'No validator configured' unless validator

    load unless @config
    validator.validate!(@config)
  end

  # Checks if configuration is valid
  #
  # @return [Boolean] true if valid
  def valid?
    return false unless validator

    load unless @config
    validator.valid?(@config)
  end

  # Encrypts a value
  #
  # @param plaintext [String] Value to encrypt
  # @return [String] Encrypted value
  # @raise [StandardError] if no encryptor configured
  def encrypt(plaintext)
    raise 'No encryptor configured' unless encryptor

    encryptor.encrypt(plaintext)
  end

  # Decrypts a value
  #
  # @param encrypted [String] Encrypted value
  # @return [String] Decrypted value
  # @raise [StandardError] if no encryptor configured
  def decrypt(encrypted)
    raise 'No encryptor configured' unless encryptor

    encryptor.decrypt(encrypted)
  end

  # Gets configuration as hash with sensitive values masked
  #
  # @return [Hash] Masked configuration
  def to_h(mask_sensitive: true)
    load unless @config

    if mask_sensitive
      @config.transform_values do |key, value|
        EnvLoader.mask_value(key, value)
      end
    else
      @config.dup
    end
  end

  # Exports configuration to .env format
  #
  # @return [String] .env format
  def to_env
    load unless @config
    EnvLoader.to_env_format(@config)
  end

  # Reloads configuration from source
  def reload
    @config = nil
    load
  end
end
