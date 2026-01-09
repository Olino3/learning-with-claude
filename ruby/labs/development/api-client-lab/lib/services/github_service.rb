# frozen_string_literal: true

require 'httparty'
require_relative '../cache/redis_cache'
require_relative 'rate_limiter'

# GitHubService provides a clean interface to the GitHub API with
# caching and rate limiting built in.
#
# Design Patterns:
# - Service Object: Encapsulates API interaction logic
# - Dependency Injection: Cache and rate limiter are injectable
#
# Example:
#   service = GitHubService.new
#   repos = service.fetch_repositories('ruby')
class GitHubService
  include HTTParty

  base_uri 'https://api.github.com'

  attr_reader :cache, :rate_limiter, :token

  DEFAULT_CACHE_TTL = 300 # 5 minutes

  # Creates a new GitHubService
  #
  # @param cache [RedisCache] Cache instance
  # @param rate_limiter [RateLimiter] Rate limiter instance
  # @param token [String] GitHub API token (optional)
  def initialize(cache: nil, rate_limiter: nil, token: nil)
    @cache = cache || RedisCache.new(namespace: 'github')
    @rate_limiter = rate_limiter || RateLimiter.new(max_requests: 60, window: 3600)
    @token = token || ENV['GITHUB_TOKEN']
  end

  # Fetches repositories matching query
  #
  # @param query [String] Search query
  # @param per_page [Integer] Results per page
  # @return [Array<Hash>] Repository data
  def fetch_repositories(query, per_page: 30)
    cache_key = "repos:#{query}:#{per_page}"

    cache.fetch(cache_key, ttl: DEFAULT_CACHE_TTL) do
      rate_limiter.within_limit('github_api') do
        response = self.class.get('/search/repositories', {
                                    query: { q: query, per_page: per_page },
                                    headers: headers
                                  })

        handle_response(response)['items']
      end
    end
  end

  # Fetches user information
  #
  # @param username [String] GitHub username
  # @return [Hash] User data
  def fetch_user(username)
    cache_key = "user:#{username}"

    cache.fetch(cache_key, ttl: DEFAULT_CACHE_TTL) do
      rate_limiter.within_limit('github_api') do
        response = self.class.get("/users/#{username}", headers: headers)
        handle_response(response)
      end
    end
  end

  # Fetches repository details
  #
  # @param owner [String] Repository owner
  # @param repo [String] Repository name
  # @return [Hash] Repository data
  def fetch_repository(owner, repo)
    cache_key = "repo:#{owner}/#{repo}"

    cache.fetch(cache_key, ttl: DEFAULT_CACHE_TTL) do
      rate_limiter.within_limit('github_api') do
        response = self.class.get("/repos/#{owner}/#{repo}", headers: headers)
        handle_response(response)
      end
    end
  end

  # Clears all cached data
  def clear_cache
    cache.clear
  end

  # Gets rate limit information
  #
  # @return [Hash] Rate limit info
  def rate_limit_info
    rate_limiter.info('github_api')
  end

  private

  # Builds request headers
  #
  # @return [Hash] Headers
  def headers
    h = {
      'Accept' => 'application/vnd.github.v3+json',
      'User-Agent' => 'Ruby API Client Lab'
    }
    h['Authorization'] = "token #{token}" if token
    h
  end

  # Handles API response
  #
  # @param response [HTTParty::Response]
  # @return [Hash] Parsed response
  # @raise [StandardError] on error
  def handle_response(response)
    case response.code
    when 200..299
      response.parsed_response
    when 404
      raise "Resource not found: #{response.code}"
    when 403
      raise "API rate limit exceeded: #{response.code}"
    when 401
      raise "Authentication failed: #{response.code}"
    else
      raise "API error: #{response.code} - #{response.message}"
    end
  end
end
