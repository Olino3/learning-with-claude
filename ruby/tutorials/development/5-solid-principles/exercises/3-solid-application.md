# Exercise 3: Complete SOLID Application

Build a blogging platform that demonstrates all five SOLID principles.

## Requirements

1. **SRP**: Separate concerns (models, services, policies, presenters)
2. **OCP**: Extensible notification system
3. **LSP**: Proper inheritance hierarchies
4. **ISP**: Role-based modules
5. **DIP**: Dependency injection throughout

## Architecture

```
app/
├── models/
│   ├── post.rb (domain model only)
│   ├── comment.rb
│   └── user.rb
├── services/
│   ├── posts/
│   │   ├── create_service.rb (SRP)
│   │   └── publish_service.rb (SRP)
│   └── notifications/
│       ├── base.rb (OCP, LSP)
│       ├── email.rb (OCP)
│       └── sms.rb (OCP)
├── policies/
│   └── post_policy.rb (ISP)
├── decorators/
│   └── post_decorator.rb (SRP)
└── repositories/
    └── post_repository.rb (DIP)
```

## Solution Highlights

```ruby
# SRP: Service handles one operation
class Posts::PublishService
  include Import[:notifier, :repository]

  def call(post)
    post.publish!
    repository.save(post)
    notifier.notify_subscribers(post)
  end
end

# OCP: Extensible notifications
class Notifications::Base
  def notify(user, message)
    raise NotImplementedError
  end
end

class Notifications::Email < Notifications::Base
  def notify(user, message)
    UserMailer.notification(user, message).deliver_later
  end
end

# ISP: Small, focused modules
module Publishable
  def publish!
    self.published = true
  end
end

module Commentable
  def add_comment(comment)
    comments << comment
  end
end

# DIP: Depend on abstraction
class Posts::CreateService
  def initialize(repository:, notifier:)
    @repository = repository
    @notifier = notifier
  end

  def call(params)
    post = @repository.create(params)
    @notifier.notify_creation(post)
    post
  end
end
```

## Key Learning

SOLID principles work together to create maintainable, testable, and flexible applications.
