# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage 80
end

require 'webmock/rspec'
require 'mock_redis'

# Load application code
require_relative '../lib/api_client'
require_relative '../lib/cache/redis_cache'
require_relative '../lib/services/rate_limiter'
require_relative '../lib/services/github_service'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.disable_monkey_patching!
  config.order = :random

  # Mock Redis for tests
  config.before(:each) do
    @mock_redis = MockRedis.new
    allow(Redis).to receive(:new).and_return(@mock_redis)
  end

  config.after(:each) do
    @mock_redis.flushdb if @mock_redis
  end
end

WebMock.disable_net_connect!(allow_localhost: true)
