# frozen_string_literal: true

require 'redis'

# Redis configuration for the application
module RedisConfig
  # Gets Redis connection
  #
  # @return [Redis] Redis connection
  def self.connection
    @connection ||= Redis.new(
      url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
      timeout: 5,
      reconnect_attempts: 3
    )
  end

  # Resets connection (useful for testing)
  def self.reset!
    @connection&.quit
    @connection = nil
  end

  # Tests connection
  #
  # @return [Boolean] true if connected
  def self.connected?
    connection.ping == 'PONG'
  rescue StandardError
    false
  end
end
