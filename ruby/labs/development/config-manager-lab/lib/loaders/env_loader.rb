# frozen_string_literal: true

require 'dotenv'

# EnvLoader loads configuration from environment variables and .env files.
#
# Design Patterns:
# - Loader Pattern: Abstracts configuration loading
# - Singleton: Shared configuration state
#
# Example:
#   loader = EnvLoader.new
#   config = loader.load
class EnvLoader
  SENSITIVE_KEYS = %w[
    PASSWORD
    SECRET
    KEY
    TOKEN
    API_KEY
    PRIVATE
    CREDENTIAL
  ].freeze

  attr_reader :env_file

  # Creates a new EnvLoader
  #
  # @param env_file [String] Path to .env file
  def initialize(env_file: '.env')
    @env_file = env_file
  end

  # Loads configuration from environment
  #
  # @return [Hash] Configuration hash
  def load
    # Load .env file if it exists
    Dotenv.load(env_file) if File.exist?(env_file)

    # Convert ENV to hash
    ENV.to_h
  end

  # Loads with validation
  #
  # @param required_keys [Array<String>] Required environment variables
  # @return [Hash] Configuration hash
  # @raise [ArgumentError] if required keys are missing
  def load!(required_keys = [])
    config = load

    missing_keys = required_keys.reject { |key| config.key?(key) }
    raise ArgumentError, "Missing required keys: #{missing_keys.join(', ')}" unless missing_keys.empty?

    config
  end

  # Checks if key contains sensitive data
  #
  # @param key [String] Configuration key
  # @return [Boolean] true if sensitive
  def self.sensitive_key?(key)
    SENSITIVE_KEYS.any? { |pattern| key.upcase.include?(pattern) }
  end

  # Masks sensitive value for logging
  #
  # @param key [String] Configuration key
  # @param value [String] Configuration value
  # @return [String] Masked or original value
  def self.mask_value(key, value)
    return '[MASKED]' if sensitive_key?(key)

    value
  end

  # Exports configuration to .env format
  #
  # @param config [Hash] Configuration hash
  # @return [String] .env format string
  def self.to_env_format(config)
    config.map do |key, value|
      escaped_value = value.to_s.include?(' ') ? "\"#{value}\"" : value
      "#{key}=#{escaped_value}"
    end.join("\n")
  end
end
