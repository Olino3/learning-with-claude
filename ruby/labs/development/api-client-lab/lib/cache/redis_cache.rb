# frozen_string_literal: true

require 'redis'
require 'json'

# RedisCache provides a caching layer using Redis for storing API responses
# and other frequently accessed data.
#
# Design Patterns:
# - Cache-Aside Pattern: Application manages cache explicitly
# - Namespace Pattern: Organizes cache keys by namespace
#
# Example:
#   cache = RedisCache.new(namespace: 'api')
#   cache.set('user:1', user_data, ttl: 3600)
#   user = cache.get('user:1')
class RedisCache
  DEFAULT_TTL = 3600 # 1 hour
  DEFAULT_NAMESPACE = 'app'

  attr_reader :redis, :namespace, :default_ttl

  # Creates a new RedisCache instance
  #
  # @param redis [Redis] Redis connection (optional)
  # @param namespace [String] Key namespace
  # @param default_ttl [Integer] Default TTL in seconds
  def initialize(redis: nil, namespace: DEFAULT_NAMESPACE, default_ttl: DEFAULT_TTL)
    @redis = redis || Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
    @namespace = namespace
    @default_ttl = default_ttl
  end

  # Fetches value from cache, or computes and stores it
  #
  # @param key [String] Cache key
  # @param ttl [Integer] Time to live in seconds
  # @yield Block to compute value if cache miss
  # @return [Object] Cached or computed value
  def fetch(key, ttl: default_ttl)
    value = get(key)
    return value unless value.nil?

    return nil unless block_given?

    computed_value = yield
    set(key, computed_value, ttl: ttl)
    computed_value
  end

  # Gets value from cache
  #
  # @param key [String] Cache key
  # @return [Object, nil] Cached value or nil
  def get(key)
    namespaced_key = build_key(key)
    value = redis.get(namespaced_key)
    return nil if value.nil?

    deserialize(value)
  rescue StandardError => e
    warn "Cache get error: #{e.message}"
    nil
  end

  # Sets value in cache
  #
  # @param key [String] Cache key
  # @param value [Object] Value to cache
  # @param ttl [Integer] Time to live in seconds
  def set(key, value, ttl: default_ttl)
    namespaced_key = build_key(key)
    serialized = serialize(value)
    redis.setex(namespaced_key, ttl, serialized)
    true
  rescue StandardError => e
    warn "Cache set error: #{e.message}"
    false
  end

  # Deletes a key from cache
  #
  # @param key [String] Cache key
  # @return [Boolean] true if deleted
  def delete(key)
    namespaced_key = build_key(key)
    redis.del(namespaced_key).positive?
  end

  # Checks if key exists in cache
  #
  # @param key [String] Cache key
  # @return [Boolean]
  def exists?(key)
    namespaced_key = build_key(key)
    redis.exists?(namespaced_key)
  end

  # Clears all keys in the namespace
  def clear
    pattern = "#{namespace}:*"
    keys = redis.keys(pattern)
    redis.del(*keys) unless keys.empty?
  end

  # Gets remaining TTL for a key
  #
  # @param key [String] Cache key
  # @return [Integer] Seconds remaining, -1 if no expiry, -2 if not found
  def ttl(key)
    namespaced_key = build_key(key)
    redis.ttl(namespaced_key)
  end

  private

  # Builds namespaced key
  def build_key(key)
    "#{namespace}:#{key}"
  end

  # Serializes value for storage
  def serialize(value)
    JSON.generate(value)
  end

  # Deserializes value from storage
  def deserialize(value)
    JSON.parse(value)
  end
end
