# frozen_string_literal: true

require_relative 'services/github_service'
require_relative 'cache/redis_cache'
require_relative 'services/rate_limiter'

# ApiClient provides a facade for interacting with the GitHub API
# with built-in caching and rate limiting.
#
# Design Patterns:
# - Facade Pattern: Simplifies complex subsystem interactions
# - Dependency Injection: Services are configurable
#
# Example:
#   client = ApiClient.new
#   repos = client.fetch_repositories('rails')
class ApiClient
  attr_reader :github_service

  # Creates a new ApiClient
  #
  # @param github_service [GitHubService] GitHub service instance (optional)
  def initialize(github_service: nil)
    @github_service = github_service || GitHubService.new
  end

  # Fetches repositories matching query
  #
  # @param query [String] Search query
  # @param per_page [Integer] Results per page
  # @return [Array<Hash>] Repository data
  def fetch_repositories(query, per_page: 30)
    github_service.fetch_repositories(query, per_page: per_page)
  end

  # Fetches user information
  #
  # @param username [String] GitHub username
  # @return [Hash] User data
  def fetch_user(username)
    github_service.fetch_user(username)
  end

  # Fetches repository details
  #
  # @param owner [String] Repository owner
  # @param repo [String] Repository name
  # @return [Hash] Repository data
  def fetch_repository(owner, repo)
    github_service.fetch_repository(owner, repo)
  end

  # Clears all cached data
  def clear_cache
    github_service.clear_cache
  end

  # Gets rate limit information
  #
  # @return [Hash] Rate limit info
  def rate_limit_info
    github_service.rate_limit_info
  end
end
