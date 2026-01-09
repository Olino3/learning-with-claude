# frozen_string_literal: true

require 'redis'

# RateLimiter implements rate limiting using the token bucket algorithm
# to prevent API abuse and respect API rate limits.
#
# Design Patterns:
# - Token Bucket Algorithm: Fixed rate with burst capacity
# - Service Object: Encapsulates rate limiting logic
#
# Example:
#   limiter = RateLimiter.new(max_requests: 60, window: 60)
#   limiter.within_limit { api_call }
class RateLimiter
  class RateLimitExceededError < StandardError; end

  DEFAULT_MAX_REQUESTS = 60
  DEFAULT_WINDOW = 60 # seconds

  attr_reader :redis, :max_requests, :window, :namespace

  # Creates a new RateLimiter
  #
  # @param redis [Redis] Redis connection
  # @param max_requests [Integer] Maximum requests allowed
  # @param window [Integer] Time window in seconds
  # @param namespace [String] Redis key namespace
  def initialize(redis: nil, max_requests: DEFAULT_MAX_REQUESTS,
                 window: DEFAULT_WINDOW, namespace: 'rate_limit')
    @redis = redis || Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
    @max_requests = max_requests
    @window = window
    @namespace = namespace
  end

  # Checks if request is within rate limit
  #
  # @param identifier [String] Unique identifier (user ID, IP, etc.)
  # @return [Boolean] true if within limit
  def check_limit(identifier)
    key = build_key(identifier)
    current_count = redis.get(key).to_i

    current_count < max_requests
  end

  # Checks rate limit and raises error if exceeded
  #
  # @param identifier [String] Unique identifier
  # @raise [RateLimitExceededError] if limit exceeded
  def check_rate_limit!(identifier = 'default')
    return if check_limit(identifier)

    remaining_time = ttl(identifier)
    raise RateLimitExceededError, "Rate limit exceeded. Try again in #{remaining_time} seconds"
  end

  # Increments request counter
  #
  # @param identifier [String] Unique identifier
  # @return [Integer] Current request count
  def increment(identifier)
    key = build_key(identifier)

    count = redis.incr(key)
    redis.expire(key, window) if count == 1 # Set expiry on first request

    count
  end

  # Executes block if within rate limit
  #
  # @param identifier [String] Unique identifier
  # @yield Block to execute
  # @return [Object] Block return value
  # @raise [RateLimitExceededError] if limit exceeded
  def within_limit(identifier = 'default')
    check_rate_limit!(identifier)
    increment(identifier)
    yield if block_given?
  end

  # Gets remaining requests allowed
  #
  # @param identifier [String] Unique identifier
  # @return [Integer] Remaining requests
  def remaining(identifier)
    key = build_key(identifier)
    current = redis.get(key).to_i
    [max_requests - current, 0].max
  end

  # Gets TTL for the rate limit window
  #
  # @param identifier [String] Unique identifier
  # @return [Integer] Seconds until reset
  def ttl(identifier)
    key = build_key(identifier)
    ttl = redis.ttl(key)
    ttl.positive? ? ttl : window
  end

  # Resets rate limit for identifier
  #
  # @param identifier [String] Unique identifier
  def reset(identifier)
    key = build_key(identifier)
    redis.del(key)
  end

  # Gets rate limit info
  #
  # @param identifier [String] Unique identifier
  # @return [Hash] Rate limit information
  def info(identifier = 'default')
    {
      limit: max_requests,
      remaining: remaining(identifier),
      reset_in: ttl(identifier),
      window: window
    }
  end

  private

  # Builds Redis key
  def build_key(identifier)
    "#{namespace}:#{identifier}"
  end
end
