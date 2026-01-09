# Tutorial 7: Background Jobs & Performance

Master background job processing and performance optimization in Ruby applications. This tutorial covers Sidekiq for async jobs, Bullet for N+1 detection, caching strategies, and performance monitoring techniques.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Process background jobs with Sidekiq
- Queue and schedule asynchronous work
- Detect and fix N+1 queries with Bullet
- Implement multi-level caching strategies
- Monitor application performance
- Optimize database queries
- Compare Ruby solutions to Python tools
- Build performant, scalable applications

## 🐍➡️🔴 Coming from Python

If you're familiar with Python async tools, here's how Ruby tools compare:

| Concept | Python | Ruby | Key Difference |
|---------|--------|------|----------------|
| Task queue | Celery | Sidekiq | Sidekiq lighter, faster |
| Message broker | RabbitMQ, Redis | Redis | Sidekiq uses Redis |
| Task definition | @task decorator | class with perform | Class-based in Ruby |
| Scheduling | celery beat | sidekiq-cron | Similar functionality |
| N+1 detection | django-debug-toolbar | Bullet | Bullet more focused |
| Query optimization | Django ORM select_related | includes/eager_load | Similar concept |
| Caching | Django cache | Rails.cache | Similar API |
| Background workers | Gunicorn workers | Puma threads | Different concurrency |

> **📘 Python Note:** Sidekiq is simpler than Celery—no separate broker setup, just Redis. It's more like Python RQ but with better features.

## 📝 Part 1: Sidekiq - Background Jobs

Sidekiq processes background jobs efficiently using threads and Redis.

### Installing Sidekiq

```ruby
# Gemfile
gem 'sidekiq', '~> 7.0'
gem 'sidekiq-cron'  # For scheduled jobs

# Install Redis
# macOS: brew install redis
# Ubuntu: sudo apt-get install redis-server
```

### Basic Job

```ruby
# app/workers/welcome_email_worker.rb
class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.welcome(user).deliver_now
  end
end

# Enqueue job
WelcomeEmailWorker.perform_async(user.id)

# Enqueue with delay
WelcomeEmailWorker.perform_in(1.hour, user.id)
WelcomeEmailWorker.perform_at(tomorrow_at_noon, user.id)
```

> **📘 Python Note:** Similar to Celery:
> ```python
> @app.task
> def send_welcome_email(user_id):
>     user = User.objects.get(id=user_id)
>     send_mail(...)
>
> send_welcome_email.delay(user.id)
> ```

### Worker Options

```ruby
class ReportGeneratorWorker
  include Sidekiq::Worker

  # Retry configuration
  sidekiq_options retry: 5,
                  queue: :critical,
                  backtrace: true,
                  dead: false

  # Retry with custom backoff
  sidekiq_retry_in do |count, exception|
    case exception
    when NetworkError
      10 * (count + 1)  # 10, 20, 30, etc.
    else
      (count**4) + 15   # Exponential backoff
    end
  end

  # Skip retry for certain errors
  sidekiq_retries_exhausted do |msg, exception|
    Rails.logger.error "Job failed permanently: #{msg}"
    Bugsnag.notify(exception)
  end

  def perform(report_id)
    report = Report.find(report_id)
    generate_pdf(report)
    upload_to_s3(report)
  rescue ActiveRecord::RecordNotFound => e
    # Don't retry if record deleted
    logger.warn "Report #{report_id} not found"
  end
end
```

### Job Queues and Priorities

```ruby
# config/sidekiq.yml
:queues:
  - critical
  - default
  - low_priority
  - mailers

# Workers on different queues
class CriticalWorker
  include Sidekiq::Worker
  sidekiq_options queue: :critical
end

class EmailWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailers
end

class CleanupWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority
end
```

### Batches and Chains

```ruby
# Gemfile
gem 'sidekiq-pro'  # Commercial, supports batches

# Batch processing
batch = Sidekiq::Batch.new
batch.description = "Import users from CSV"
batch.on(:complete, CSVImportCallback)

batch.jobs do
  csv_rows.each do |row|
    ImportUserWorker.perform_async(row)
  end
end

# Job chaining
class ProcessImageWorker
  include Sidekiq::Worker

  def perform(image_id)
    image = Image.find(image_id)
    process_image(image)

    # Chain next jobs
    ThumbnailWorker.perform_async(image_id)
    WatermarkWorker.perform_async(image_id)
  end
end
```

### Scheduled Jobs

```ruby
# Gemfile
gem 'sidekiq-cron'

# config/initializers/sidekiq.rb
require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Daily Report',
  cron: '0 0 * * *',  # Every day at midnight
  class: 'DailyReportWorker'
)

Sidekiq::Cron::Job.create(
  name: 'Weekly Cleanup',
  cron: '0 2 * * 0',  # Every Sunday at 2am
  class: 'WeeklyCleanupWorker'
)

Sidekiq::Cron::Job.create(
  name: 'Hourly Sync',
  cron: '0 * * * *',  # Every hour
  class: 'SyncWorker'
)
```

### Testing Workers

```ruby
# spec/workers/welcome_email_worker_spec.rb
RSpec.describe WelcomeEmailWorker do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'sends welcome email' do
      expect(UserMailer).to receive(:welcome)
        .with(user)
        .and_return(double(deliver_now: true))

      described_class.new.perform(user.id)
    end

    context 'with inline processing' do
      around do |example|
        Sidekiq::Testing.inline! do
          example.run
        end
      end

      it 'processes immediately' do
        expect {
          WelcomeEmailWorker.perform_async(user.id)
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with fake processing' do
      it 'enqueues job' do
        expect {
          WelcomeEmailWorker.perform_async(user.id)
        }.to change(WelcomeEmailWorker.jobs, :size).by(1)
      end
    end
  end
end
```

## 📝 Part 2: Bullet - N+1 Query Detection

Bullet detects N+1 queries and unused eager loading.

### Installing Bullet

```ruby
# Gemfile
group :development do
  gem 'bullet'
end

# config/environments/development.rb
config.after_initialize do
  Bullet.enable = true
  Bullet.alert = true           # JavaScript alert
  Bullet.bullet_logger = true   # Log to bullet.log
  Bullet.console = true          # Log to console
  Bullet.rails_logger = true    # Log to Rails log
  Bullet.add_footer = true      # Add footer to pages

  # Notifications (optional)
  # Bullet.slack = { webhook_url: 'http://slack.com/webhook' }
  # Bullet.bugsnag = true
end
```

### N+1 Query Example

```ruby
# Bad: N+1 query
def index
  @posts = Post.all
end

# View causes N+1
<% @posts.each do |post| %>
  <h2><%= post.title %></h2>
  <p>By <%= post.author.name %></p>  # N+1: queries author for each post
  <p><%= post.comments.count %> comments</p>  # N+1: counts comments for each post
<% end %>

# Bullet warning:
# USE eager loading detected
#   Post => [:author, :comments]
# Add to your finder: :includes => [:author, :comments]

# Fixed: Eager loading
def index
  @posts = Post.includes(:author, :comments).all
end
```

### Common N+1 Patterns

```ruby
# Pattern 1: Belongs_to association
# Bad
users = User.all
users.each { |user| puts user.profile.bio }  # N+1

# Good
users = User.includes(:profile).all

# Pattern 2: Has_many association
# Bad
posts = Post.all
posts.each { |post| puts post.comments.count }  # N+1

# Good
posts = Post.includes(:comments).all

# Pattern 3: Nested associations
# Bad
posts = Post.all
posts.each do |post|
  post.comments.each { |comment| puts comment.user.name }  # N+1
end

# Good
posts = Post.includes(comments: :user).all

# Pattern 4: Multiple associations
# Bad
posts = Post.all
posts.each do |post|
  puts post.author.name          # N+1
  puts post.category.name        # N+1
  puts post.comments.count       # N+1
end

# Good
posts = Post.includes(:author, :category, :comments).all
```

### Eager Loading vs Preloading vs Joins

```ruby
# includes - Automatic (uses preload or eager_load based on query)
Post.includes(:author).all
# SELECT * FROM posts
# SELECT * FROM authors WHERE id IN (...)

# preload - Separate queries (use when no WHERE on association)
Post.preload(:author).all
# SELECT * FROM posts
# SELECT * FROM authors WHERE id IN (...)

# eager_load - Single LEFT OUTER JOIN (use with WHERE on association)
Post.eager_load(:author).where(authors: { verified: true })
# SELECT * FROM posts LEFT OUTER JOIN authors ON ...

# joins - INNER JOIN (doesn't load association)
Post.joins(:author).where(authors: { verified: true })
# SELECT posts.* FROM posts INNER JOIN authors ON ...
```

## 📝 Part 3: Caching Strategies

Multi-level caching improves performance dramatically.

### Rails Cache Types

```ruby
# config/environments/production.rb

# Memory store (single server)
config.cache_store = :memory_store, { size: 64.megabytes }

# File store
config.cache_store = :file_store, '/var/cache/rails'

# Redis (recommended for production)
config.cache_store = :redis_cache_store, {
  url: ENV['REDIS_URL'],
  expires_in: 1.hour,
  namespace: 'myapp'
}

# Memcached
config.cache_store = :mem_cache_store, 'cache-1.example.com', 'cache-2.example.com'
```

### Low-Level Caching

```ruby
class Product < ApplicationRecord
  def expensive_calculation
    Rails.cache.fetch("product:#{id}:calculation", expires_in: 1.hour) do
      # Expensive operation
      complex_math_operation
    end
  end

  def self.featured_products
    Rails.cache.fetch('products:featured', expires_in: 15.minutes) do
      where(featured: true).includes(:images).to_a
    end
  end

  # Cache with dependencies
  def related_products
    cache_key = "product:#{id}:related:#{updated_at.to_i}"
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      Product.where(category: category).limit(5).to_a
    end
  end

  # Conditional caching
  def stats
    return expensive_stats unless Rails.cache.exist?("product:#{id}:stats")

    Rails.cache.fetch("product:#{id}:stats", expires_in: 5.minutes) do
      expensive_stats
    end
  end

  # Cache deletion
  def clear_cache
    Rails.cache.delete("product:#{id}:calculation")
    Rails.cache.delete("product:#{id}:related:*")
  end
end
```

### Fragment Caching

```ruby
# View caching
<% cache @product do %>
  <h1><%= @product.name %></h1>
  <p><%= @product.description %></p>
<% end %>

# Collection caching
<% cache @products do %>
  <% @products.each do |product| %>
    <% cache product do %>
      <%= render product %>
    <% end %>
  <% end %>
<% end %>

# Conditional caching
<% cache_if user_signed_in?, @product do %>
  <%= render @product %>
<% end %>

# Cache with dependencies
<% cache [@product, @product.category] do %>
  <%= render @product %>
<% end %>
```

### Russian Doll Caching

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments
  belongs_to :author

  # Touch parent when changed
  touch: true
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post, touch: true
end

# View with nested caching
<% cache @post do %>
  <h1><%= @post.title %></h1>

  <% cache @post.author do %>
    <p>By <%= @post.author.name %></p>
  <% end %>

  <% @post.comments.each do |comment| %>
    <% cache comment do %>
      <%= render comment %>
    <% end %>
  <% end %>
<% end %>
```

### HTTP Caching

```ruby
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])

    # Conditional GET (ETag)
    if stale?(etag: @post, last_modified: @post.updated_at)
      respond_to do |format|
        format.html
        format.json { render json: @post }
      end
    end

    # Or use fresh_when for read-only resources
    fresh_when @post, public: true
  end

  def index
    @posts = Post.all

    # Cache entire response
    expires_in 1.hour, public: true

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
end
```

## 📝 Part 4: Performance Monitoring

### Rack Mini Profiler

```ruby
# Gemfile
gem 'rack-mini-profiler'
gem 'memory_profiler'
gem 'stackprof'  # For Ruby 2.1+

# Shows performance badge on every page in development
# ?pp=help - Show help
# ?pp=profile-gc - Profile garbage collection
# ?pp=profile-memory - Profile memory allocation
```

### Skylight / New Relic

```ruby
# Gemfile (choose one)
gem 'skylight'
# or
gem 'newrelic_rpm'

# config/skylight.yml
authentication: <%= ENV['SKYLIGHT_AUTHENTICATION'] %>

# Tracks:
# - Response times
# - Database queries
# - Background jobs
# - External API calls
# - Memory usage
```

### Custom Instrumentation

```ruby
# app/services/report_generator.rb
class ReportGenerator
  def generate(report_id)
    ActiveSupport::Notifications.instrument(
      'generate.report',
      report_id: report_id
    ) do
      # Report generation logic
    end
  end
end

# config/initializers/notifications.rb
ActiveSupport::Notifications.subscribe('generate.report') do |name, start, finish, id, payload|
  duration = finish - start
  Rails.logger.info "Report #{payload[:report_id]} generated in #{duration}ms"

  # Send to monitoring service
  StatsD.measure('report.generation_time', duration)
end
```

## ✍️ Exercises

### Exercise 1: Sidekiq Jobs
👉 **[Background Processing](exercises/1-sidekiq-jobs.md)**

Build:
- Email notification system
- Image processing pipeline
- Report generation worker
- Scheduled cleanup jobs

### Exercise 2: Query Optimization
👉 **[Fix N+1 Queries](exercises/2-query-optimization.md)**

Optimize:
- Blog with posts, comments, authors
- E-commerce product listings
- Social media feed
- Analytics dashboard

### Exercise 3: Caching Strategy
👉 **[Implement Caching](exercises/3-caching-strategy.md)**

Cache:
- Product catalog
- User dashboards
- API responses
- Search results

## 📚 What You Learned

✅ Background job processing with Sidekiq
✅ Job queues, retries, and scheduling
✅ N+1 query detection and fixes
✅ Eager loading vs preloading
✅ Multi-level caching strategies
✅ Fragment and Russian Doll caching
✅ Performance monitoring tools
✅ Query optimization techniques

## 🔜 Next Steps

**Next: [Tutorial 8: Data Structures & Algorithms](../8-data-structures/README.md)**

Learn to:
- Master Enumerable methods
- Understand Ruby data structures
- Implement algorithms in Ruby
- Optimize with memoization

## 💡 Key Takeaways for Python Developers

1. **Sidekiq ≈ Celery**: Simpler setup, Redis-only, thread-based
2. **Bullet ≈ django-debug-toolbar**: Focused on query optimization
3. **includes ≈ select_related**: Eager loading associations
4. **Rails.cache ≈ Django cache**: Similar API and concepts
5. **ActiveJob**: Rails abstraction over Sidekiq, Resque, etc.
6. **Fragment caching**: More prominent in Rails than Django
7. **Performance**: Similar tools and techniques

## 🆘 Common Pitfalls

### Pitfall 1: Passing Objects to Workers

```ruby
# Bad: Serialization issues
WelcomeEmailWorker.perform_async(user)  # Serializes entire object

# Good: Pass IDs
WelcomeEmailWorker.perform_async(user.id)  # Serialize simple value
```

### Pitfall 2: Over-Eager Loading

```ruby
# Bad: Loading too much
Post.includes(:author, :comments, :tags, :category).all

# Good: Only what you need
Post.includes(:author).all
```

### Pitfall 3: Caching Stale Data

```ruby
# Bad: No expiration
Rails.cache.fetch('users') { User.all.to_a }

# Good: Expire cache
Rails.cache.fetch('users', expires_in: 5.minutes) { User.all.to_a }
```

## 📖 Additional Resources

### Sidekiq
- [Sidekiq Documentation](https://github.com/sidekiq/sidekiq/wiki)
- [Sidekiq Best Practices](https://github.com/sidekiq/sidekiq/wiki/Best-Practices)

### Performance
- [Bullet Gem](https://github.com/flyerhzm/bullet)
- [Rails Guides: Caching](https://guides.rubyonrails.org/caching_with_rails.html)
- [Complete Guide to Rails Performance](https://www.speedshop.co/2015/05/27/a-complete-guide-to-rails-caching.html)

---

Ready to optimize? Start with **[Exercise 1: Sidekiq Jobs](exercises/1-sidekiq-jobs.md)**! ⚡
