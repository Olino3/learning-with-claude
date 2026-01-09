# Exercise 1: Sidekiq Background Jobs

Build a comprehensive background job system with Sidekiq.

## Challenge: Email Notification System

Create workers for different notification types with proper error handling and retries.

```ruby
# app/workers/notification_worker.rb
class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3, queue: :notifications

  def perform(user_id, notification_type, data)
    # TODO: Implement notification logic
  end
end
```

**Requirements:**
1. Welcome email worker
2. Password reset worker
3. Order confirmation worker
4. Weekly digest worker (scheduled)
5. Proper error handling
6. Test coverage

## Key Learning

Background jobs should be idempotent and handle failures gracefully.
