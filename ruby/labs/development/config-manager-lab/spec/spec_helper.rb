# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage 85
end

require_relative '../lib/config_manager'
require_relative '../lib/encryption/encryptor'
require_relative '../lib/validators/config_validator'
require_relative '../lib/loaders/env_loader'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.disable_monkey_patching!
  config.order = :random
end
