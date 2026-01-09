# frozen_string_literal: true

require 'httparty'
require_relative '../models/article'

# ScrapeService implements the Service Object pattern, encapsulating
# the complex logic of fetching and parsing web content.
#
# Design Patterns:
# - Service Object: Encapsulates business logic
# - Strategy Pattern: Uses injected parser strategy
# - Error Handling: Robust error handling with retries
#
# Example:
#   service = ScrapeService.new(parser: BlogParser.new)
#   articles = service.scrape('https://example.com')
class ScrapeService
  # Custom errors
  class NetworkError < StandardError
    attr_reader :retryable

    def initialize(message, retryable: true)
      super(message)
      @retryable = retryable
    end

    def retryable?
      @retryable
    end
  end

  class TimeoutError < NetworkError; end

  class HttpError < NetworkError; end

  attr_reader :parser, :max_retries, :timeout, :user_agent

  DEFAULT_USER_AGENT = 'Mozilla/5.0 (compatible; RubyScraper/1.0; +https://example.com/bot)'
  DEFAULT_TIMEOUT = 30
  DEFAULT_MAX_RETRIES = 3

  # Creates a new ScrapeService
  #
  # @param parser [HtmlParser] Parser strategy to use
  # @param max_retries [Integer] Maximum number of retry attempts
  # @param timeout [Integer] Request timeout in seconds
  # @param user_agent [String] User agent string
  def initialize(parser:, max_retries: DEFAULT_MAX_RETRIES,
                 timeout: DEFAULT_TIMEOUT, user_agent: DEFAULT_USER_AGENT)
    @parser = parser
    @max_retries = max_retries
    @timeout = timeout
    @user_agent = user_agent
  end

  # Scrapes a URL and returns Article objects
  #
  # @param url [String] URL to scrape
  # @return [Array<Article>] Array of Article objects
  # @raise [NetworkError] if network operation fails
  # @raise [HtmlParser::ParseError] if parsing fails
  def scrape(url)
    html = fetch(url)
    article_data_list = parser.parse(html)

    article_data_list.map do |data|
      Article.new(**data)
    end
  end

  # Fetches HTML content from URL
  #
  # @param url [String] URL to fetch
  # @return [String] HTML content
  # @raise [NetworkError] if fetch fails
  def fetch(url)
    retries = 0

    begin
      response = http_get(url)
      validate_response!(response)
      response.body
    rescue Timeout::Error, Net::OpenTimeout => e
      retries += 1
      retry if retries <= max_retries
      raise TimeoutError.new("Request timed out after #{max_retries} retries: #{e.message}")
    rescue SocketError, Errno::ECONNREFUSED => e
      raise NetworkError.new("Network error: #{e.message}", retryable: false)
    rescue StandardError => e
      retries += 1
      retry if retries <= max_retries && retryable_error?(e)
      raise NetworkError.new("Failed to fetch URL: #{e.message}", retryable: false)
    end
  end

  private

  # Performs HTTP GET request
  #
  # @param url [String]
  # @return [HTTParty::Response]
  def http_get(url)
    HTTParty.get(url, {
                   headers: { 'User-Agent' => user_agent },
                   timeout: timeout,
                   follow_redirects: true
                 })
  end

  # Validates HTTP response
  #
  # @param response [HTTParty::Response]
  # @raise [HttpError] if response is invalid
  def validate_response!(response)
    case response.code
    when 200..299
      # Success
    when 400..499
      raise HttpError.new("HTTP #{response.code}: Client error", retryable: false)
    when 500..599
      raise HttpError.new("HTTP #{response.code}: Server error", retryable: true)
    else
      raise HttpError.new("HTTP #{response.code}: Unexpected status", retryable: false)
    end
  end

  # Checks if error is retryable
  #
  # @param error [StandardError]
  # @return [Boolean]
  def retryable_error?(error)
    # Add logic to determine if error should be retried
    error.is_a?(Timeout::Error) ||
      error.is_a?(Net::OpenTimeout) ||
      (error.respond_to?(:retryable?) && error.retryable?)
  end
end
