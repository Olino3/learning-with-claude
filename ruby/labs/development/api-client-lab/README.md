# Lab 3: API Client with Background Jobs

A production-quality API client demonstrating background job processing, caching strategies, and rate limiting for scalable applications.

## Learning Objectives

- **Background Jobs**: Processing work asynchronously with Sidekiq
- **Caching Strategies**: Using Redis for performance optimization
- **Rate Limiting**: Preventing API abuse and respecting limits
- **Service Objects**: Clean API client architecture
- **Error Handling**: Retry strategies and circuit breakers
- **Testing**: Mocking external APIs and Redis

## Project Structure

```
api-client-lab/
├── lib/
│   ├── api_client.rb             # Main API client
│   ├── workers/
│   │   └── sync_worker.rb        # Sidekiq background worker
│   ├── services/
│   │   ├── rate_limiter.rb       # Rate limiting service
│   │   └── github_service.rb     # GitHub API service
│   └── cache/
│       └── redis_cache.rb        # Redis caching layer
├── config/
│   └── redis.rb                  # Redis configuration
├── spec/                         # Comprehensive test suite
├── Gemfile
└── README.md
```

## Design Patterns

### 1. Background Job Pattern
Sidekiq workers process long-running API tasks asynchronously:

```ruby
SyncWorker.perform_async(repo_name)
```

### 2. Caching Layer
Redis caches API responses to reduce external calls:

```ruby
cache = RedisCache.new
data = cache.fetch('key') { expensive_api_call }
```

### 3. Rate Limiting
Prevents overwhelming the API with too many requests:

```ruby
limiter = RateLimiter.new(max_requests: 60, window: 60)
limiter.check_rate_limit!
```

## Setup Instructions

### Prerequisites
- Ruby 3.0+
- Redis server running locally or accessible
- Bundler

### Installation

1. **Install dependencies**:
   ```bash
   bundle install
   ```

2. **Start Redis** (if not running):
   ```bash
   redis-server
   ```

3. **Configure environment** (optional):
   ```bash
   cp .env.example .env
   # Edit .env with your API tokens
   ```

4. **Run tests**:
   ```bash
   bundle exec rspec
   ```

## Usage Examples

### Basic API Client

```ruby
require_relative 'lib/api_client'

client = ApiClient.new
repos = client.fetch_repositories('rails')
repos.each { |repo| puts repo['name'] }
```

### With Caching

```ruby
# First call hits API
repos = client.fetch_repositories('rails')

# Second call uses cache (fast!)
repos = client.fetch_repositories('rails')
```

### Background Processing

```ruby
# Queue background job
SyncWorker.perform_async('rails/rails')

# Start Sidekiq worker
# bundle exec sidekiq -r ./lib/workers/sync_worker.rb
```

### Rate Limiting

```ruby
limiter = RateLimiter.new(max_requests: 60, window: 60)

100.times do
  limiter.within_limit do
    client.fetch_user('github')
  end
end
```

## Testing

Tests use mocked HTTP responses and mock Redis:

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rake coverage

# Run specific tests
bundle exec rspec spec/services/rate_limiter_spec.rb
```

## Key Components

### API Client
Main interface for making API requests with caching and rate limiting.

### Sync Worker
Background worker for syncing data asynchronously.

### Rate Limiter
Implements token bucket algorithm for rate limiting.

### Redis Cache
Provides caching with TTL and namespace support.

## Exercises

### Beginner
1. Add authentication token support
2. Implement cache invalidation
3. Add request logging

### Intermediate
4. Implement pagination handling
5. Add circuit breaker pattern
6. Create retry strategies

### Advanced
7. Implement request batching
8. Add metrics collection
9. Create webhook handlers

## License

Educational use only.
