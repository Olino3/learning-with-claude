# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'

  add_group 'Models', 'lib/models'
  add_group 'Services', 'lib/services'
  add_group 'Parsers', 'lib/parsers'
  add_group 'Decorators', 'lib/decorators'

  minimum_coverage 85
end

require 'webmock/rspec'
require 'vcr'

# Load application code
require_relative '../lib/web_scraper'
require_relative '../lib/models/article'
require_relative '../lib/parsers/html_parser'
require_relative '../lib/parsers/blog_parser'
require_relative '../lib/parsers/news_parser'
require_relative '../lib/services/scrape_service'
require_relative '../lib/decorators/article_decorator'

# RSpec configuration
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  # Shared context for sample articles
  config.shared_context 'sample articles' do
    let(:sample_article) do
      Article.new(
        title: 'Ruby Programming Tips',
        url: 'https://example.com/ruby-tips',
        author: 'Jane Doe',
        published_at: Time.parse('2024-01-15'),
        content: 'Ruby is a dynamic programming language...',
        excerpt: 'Learn Ruby programming'
      )
    end

    let(:minimal_article) do
      Article.new(
        title: 'Minimal Article',
        url: 'https://example.com/minimal'
      )
    end
  end

  config.include_context 'sample articles', include_shared: true
end

# WebMock configuration
WebMock.disable_net_connect!(allow_localhost: true)

# VCR configuration
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
end

# Helper method to load fixture files
def load_fixture(filename)
  File.read(File.join(__dir__, 'fixtures', filename))
end
