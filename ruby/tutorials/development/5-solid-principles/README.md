# Tutorial 5: SOLID Principles in Ruby

Master the five fundamental principles of object-oriented design that make code maintainable, flexible, and testable. This tutorial demonstrates how to apply SOLID principles in Ruby with practical examples and comparisons to Python.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Apply Single Responsibility Principle (SRP)
- Follow Open/Closed Principle (OCP)
- Understand Liskov Substitution Principle (LSP)
- Implement Interface Segregation Principle (ISP)
- Use Dependency Inversion Principle (DIP)
- Recognize SOLID violations in code
- Refactor code to follow SOLID principles
- Compare Ruby and Python approaches

## 🐍➡️🔴 Coming from Python

SOLID principles apply to both Ruby and Python, but implementation differs:

| Principle | Python Approach | Ruby Approach | Key Difference |
|-----------|----------------|---------------|----------------|
| SRP | Classes with single purpose | Service objects, small classes | Similar philosophy |
| OCP | Duck typing, protocols | Modules, inheritance | Ruby uses mixins more |
| LSP | ABC, Protocol | Duck typing, interfaces | Ruby more dynamic |
| ISP | Small interfaces | Role-based modules | Ruby's modules excel here |
| DIP | Dependency injection | Constructor injection | Both support DI |

> **📘 Python Note:** SOLID works similarly in both languages, but Ruby's modules and mixins make some principles easier to implement.

## 📝 Part 1: Single Responsibility Principle (SRP)

**"A class should have one, and only one, reason to change."**

### Violation Example

```ruby
# Bad: User class doing too much
class User < ApplicationRecord
  def create_with_notification
    save!
    send_welcome_email
    log_creation
    update_analytics
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def log_creation
    logger = Logger.new('log/users.log')
    logger.info("User created: #{email}")
  end

  def update_analytics
    Analytics.track('user_created', {
      user_id: id,
      email: email,
      created_at: created_at
    })
  end

  def export_to_csv
    CSV.generate do |csv|
      csv << ['ID', 'Email', 'Name']
      csv << [id, email, name]
    end
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end
end
```

### Refactored with SRP

```ruby
# Good: Each class has single responsibility

# app/models/user.rb - Data and domain logic only
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end

# app/services/users/creation_service.rb - User creation orchestration
module Users
  class CreationService
    def initialize(params)
      @params = params
    end

    def call
      user = User.create!(@params)

      NotificationService.welcome(user)
      LoggingService.log_user_creation(user)
      AnalyticsService.track_user_creation(user)

      user
    end
  end
end

# app/services/notification_service.rb - Email notifications
class NotificationService
  def self.welcome(user)
    UserMailer.welcome(user).deliver_later
  end
end

# app/services/logging_service.rb - Logging
class LoggingService
  def self.log_user_creation(user)
    Rails.logger.info("User created: #{user.email}")
  end
end

# app/services/analytics_service.rb - Analytics tracking
class AnalyticsService
  def self.track_user_creation(user)
    Analytics.track('user_created', {
      user_id: user.id,
      email: user.email,
      created_at: user.created_at
    })
  end
end

# app/exporters/user_exporter.rb - Export functionality
class UserExporter
  def initialize(users)
    @users = users
  end

  def to_csv
    CSV.generate do |csv|
      csv << ['ID', 'Email', 'Name']
      @users.each do |user|
        csv << [user.id, user.email, user.full_name]
      end
    end
  end
end
```

> **📘 Python Note:** Similar to Django's separation of models, views, and services:
> ```python
> class User(models.Model):  # Data only
>     email = models.EmailField()
>
> class UserCreationService:  # Business logic
>     def create_user(self, data):
>         # Creation logic
> ```

## 📝 Part 2: Open/Closed Principle (OCP)

**"Software entities should be open for extension, but closed for modification."**

### Violation Example

```ruby
# Bad: Modifying class for new payment methods
class PaymentProcessor
  def process(order, payment_method)
    case payment_method
    when 'credit_card'
      process_credit_card(order)
    when 'paypal'
      process_paypal(order)
    when 'bitcoin'
      process_bitcoin(order)
    # Need to modify this method for each new payment type!
    else
      raise "Unknown payment method"
    end
  end

  private

  def process_credit_card(order)
    Stripe::Charge.create(amount: order.total_cents)
  end

  def process_paypal(order)
    PayPal::Payment.create(amount: order.total)
  end

  def process_bitcoin(order)
    Bitcoin::Transaction.create(amount: order.total)
  end
end
```

### Refactored with OCP

```ruby
# Good: Extensible without modification

# Base interface
class PaymentMethod
  def process(order)
    raise NotImplementedError, "Subclasses must implement process"
  end

  def refund(order)
    raise NotImplementedError, "Subclasses must implement refund"
  end
end

# Concrete implementations
class CreditCardPayment < PaymentMethod
  def process(order)
    Stripe::Charge.create(
      amount: order.total_cents,
      currency: 'usd',
      customer: order.user.stripe_customer_id
    )
  end

  def refund(order)
    Stripe::Refund.create(charge: order.payment_id)
  end
end

class PayPalPayment < PaymentMethod
  def process(order)
    PayPal::Payment.create(
      amount: order.total,
      currency: 'USD',
      recipient: order.merchant_email
    )
  end

  def refund(order)
    PayPal::Refund.create(payment_id: order.payment_id)
  end
end

class BitcoinPayment < PaymentMethod
  def process(order)
    Bitcoin::Transaction.create(
      amount: order.total,
      address: order.bitcoin_address
    )
  end

  def refund(order)
    Bitcoin::Transaction.create(
      amount: order.total,
      address: order.user.bitcoin_address
    )
  end
end

# Processor doesn't need to change for new payment methods
class PaymentProcessor
  def initialize(payment_method)
    @payment_method = payment_method
  end

  def process(order)
    @payment_method.process(order)
  end

  def refund(order)
    @payment_method.refund(order)
  end
end

# Usage - Adding new payment methods doesn't modify existing code
processor = PaymentProcessor.new(CreditCardPayment.new)
processor.process(order)

# Easy to add new payment method
class ApplePayPayment < PaymentMethod
  def process(order)
    ApplePay::Transaction.create(amount: order.total)
  end

  def refund(order)
    ApplePay::Refund.create(transaction_id: order.payment_id)
  end
end
```

### Using Strategy Pattern with Modules

```ruby
# Alternative: Using modules for extensibility
module PaymentStrategies
  class Base
    def process(order)
      raise NotImplementedError
    end
  end

  class Stripe < Base
    def process(order)
      # Stripe processing
    end
  end

  class PayPal < Base
    def process(order)
      # PayPal processing
    end
  end
end

class PaymentProcessor
  STRATEGIES = {
    'stripe' => PaymentStrategies::Stripe,
    'paypal' => PaymentStrategies::PayPal
  }.freeze

  def self.process(order, payment_type)
    strategy = STRATEGIES[payment_type].new
    strategy.process(order)
  end
end
```

> **📘 Python Note:** Similar to Python's Strategy pattern with ABC:
> ```python
> from abc import ABC, abstractmethod
>
> class PaymentMethod(ABC):
>     @abstractmethod
>     def process(self, order):
>         pass
> ```

## 📝 Part 3: Liskov Substitution Principle (LSP)

**"Objects should be replaceable with instances of their subtypes without altering correctness."**

### Violation Example

```ruby
# Bad: Subclass changes expected behavior
class Bird
  def fly
    puts "Flying high!"
  end
end

class Penguin < Bird
  def fly
    raise "Penguins can't fly!"  # Violates LSP!
  end
end

# This breaks when we substitute
def make_bird_fly(bird)
  bird.fly  # Expects all birds to fly
end

make_bird_fly(Bird.new)     # Works
make_bird_fly(Penguin.new)  # Raises error!
```

### Refactored with LSP

```ruby
# Good: Design doesn't assume all birds fly
class Bird
  def move
    raise NotImplementedError
  end
end

class FlyingBird < Bird
  def move
    fly
  end

  def fly
    puts "Flying high!"
  end
end

class FlightlessBird < Bird
  def move
    walk
  end

  def walk
    puts "Walking..."
  end
end

class Eagle < FlyingBird
end

class Penguin < FlightlessBird
end

# Now substitution works correctly
def move_bird(bird)
  bird.move  # Works for all bird types
end

move_bird(Eagle.new)    # Flies
move_bird(Penguin.new)  # Walks
```

### Real-World Example: Repository Pattern

```ruby
# Bad: Violates LSP
class Repository
  def find(id)
    Model.find(id)
  end

  def all
    Model.all.to_a
  end
end

class CachedRepository < Repository
  def all
    # Returns different type - violates LSP!
    Rails.cache.fetch('all_records') { super }
  end
end

# Good: Maintains contract
class Repository
  def find(id)
    fetch_one(id)
  end

  def all
    fetch_all
  end

  protected

  def fetch_one(id)
    raise NotImplementedError
  end

  def fetch_all
    raise NotImplementedError
  end
end

class ActiveRecordRepository < Repository
  def fetch_one(id)
    Model.find(id)
  end

  def fetch_all
    Model.all.to_a
  end
end

class CachedRepository < Repository
  def initialize(base_repository)
    @base_repository = base_repository
  end

  def fetch_one(id)
    Rails.cache.fetch("model_#{id}") do
      @base_repository.fetch_one(id)
    end
  end

  def fetch_all
    Rails.cache.fetch('all_models') do
      @base_repository.fetch_all
    end
  end
end
```

## 📝 Part 4: Interface Segregation Principle (ISP)

**"Clients should not be forced to depend on interfaces they don't use."**

### Violation Example

```ruby
# Bad: Fat interface forces unnecessary dependencies
module Worker
  def work
    raise NotImplementedError
  end

  def eat
    raise NotImplementedError
  end

  def sleep
    raise NotImplementedError
  end
end

class Human
  include Worker

  def work
    puts "Working..."
  end

  def eat
    puts "Eating..."
  end

  def sleep
    puts "Sleeping..."
  end
end

class Robot
  include Worker

  def work
    puts "Working..."
  end

  def eat
    # Robots don't eat - forced to implement!
    raise "Robots don't eat"
  end

  def sleep
    # Robots don't sleep - forced to implement!
    raise "Robots don't sleep"
  end
end
```

### Refactored with ISP

```ruby
# Good: Segregated interfaces
module Workable
  def work
    raise NotImplementedError
  end
end

module Eatable
  def eat
    raise NotImplementedError
  end
end

module Sleepable
  def sleep
    raise NotImplementedError
  end
end

class Human
  include Workable
  include Eatable
  include Sleepable

  def work
    puts "Working..."
  end

  def eat
    puts "Eating..."
  end

  def sleep
    puts "Sleeping..."
  end
end

class Robot
  include Workable  # Only what it needs!

  def work
    puts "Working 24/7..."
  end
end

# Different worker types
class Manager
  include Workable
  include Eatable
  include Sleepable

  def work
    puts "Managing..."
  end

  def eat
    puts "Business lunch..."
  end

  def sleep
    puts "Power nap..."
  end
end
```

### Real-World Example: Model Concerns

```ruby
# Good: Small, focused modules
module Timestampable
  extend ActiveSupport::Concern

  included do
    before_create :set_timestamps
  end

  private

  def set_timestamps
    self.created_at = Time.current
    self.updated_at = Time.current
  end
end

module Publishable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where(published: true) }
    scope :draft, -> { where(published: false) }
  end

  def publish!
    update!(published: true, published_at: Time.current)
  end

  def unpublish!
    update!(published: false)
  end
end

module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug
  end

  private

  def generate_slug
    self.slug = title.parameterize if title.present?
  end
end

# Models include only what they need
class Post < ApplicationRecord
  include Timestampable
  include Publishable
  include Sluggable
end

class Comment < ApplicationRecord
  include Timestampable  # Only timestamps, no publishing
end
```

> **📘 Python Note:** Similar to Python's mixins and protocols:
> ```python
> class Workable(Protocol):
>     def work(self) -> None: ...
>
> class Eatable(Protocol):
>     def eat(self) -> None: ...
> ```

## 📝 Part 5: Dependency Inversion Principle (DIP)

**"Depend on abstractions, not concretions."**

### Violation Example

```ruby
# Bad: High-level module depends on low-level implementation
class OrderProcessor
  def process(order)
    # Directly coupled to MySQL implementation
    mysql = MysqlDatabase.new
    mysql.save(order)

    # Directly coupled to SMTP email
    smtp = SmtpMailer.new
    smtp.send_confirmation(order)

    # Directly coupled to Stripe
    stripe = StripePayment.new
    stripe.charge(order.total)
  end
end
```

### Refactored with DIP

```ruby
# Good: Depend on abstractions via dependency injection

# Abstractions (interfaces)
class Database
  def save(record)
    raise NotImplementedError
  end
end

class Mailer
  def send_confirmation(order)
    raise NotImplementedError
  end
end

class PaymentGateway
  def charge(amount)
    raise NotImplementedError
  end
end

# Concrete implementations
class MysqlDatabase < Database
  def save(record)
    # MySQL-specific implementation
  end
end

class PostgresDatabase < Database
  def save(record)
    # Postgres-specific implementation
  end
end

class SmtpMailer < Mailer
  def send_confirmation(order)
    # SMTP implementation
  end
end

class SendGridMailer < Mailer
  def send_confirmation(order)
    # SendGrid implementation
  end
end

class StripePayment < PaymentGateway
  def charge(amount)
    # Stripe implementation
  end
end

# High-level module depends on abstractions
class OrderProcessor
  def initialize(database:, mailer:, payment_gateway:)
    @database = database
    @mailer = mailer
    @payment_gateway = payment_gateway
  end

  def process(order)
    @database.save(order)
    @mailer.send_confirmation(order)
    @payment_gateway.charge(order.total)
  end
end

# Dependency injection in action
processor = OrderProcessor.new(
  database: PostgresDatabase.new,
  mailer: SendGridMailer.new,
  payment_gateway: StripePayment.new
)

processor.process(order)

# Easy to swap implementations
test_processor = OrderProcessor.new(
  database: InMemoryDatabase.new,
  mailer: MockMailer.new,
  payment_gateway: MockPayment.new
)
```

### Using Dry-Container for DI

```ruby
# Gemfile
gem 'dry-container'
gem 'dry-auto_inject'

# config/container.rb
class Container
  extend Dry::Container::Mixin

  register :database do
    Rails.env.test? ? InMemoryDatabase.new : PostgresDatabase.new
  end

  register :mailer do
    SendGridMailer.new
  end

  register :payment_gateway do
    StripePayment.new
  end
end

# Auto-inject dependencies
Import = Dry::AutoInject(Container)

# app/services/order_processor.rb
class OrderProcessor
  include Import[:database, :mailer, :payment_gateway]

  def process(order)
    database.save(order)
    mailer.send_confirmation(order)
    payment_gateway.charge(order.total)
  end
end

# Dependencies automatically injected
processor = OrderProcessor.new
processor.process(order)
```

### Testing with DIP

```ruby
# spec/services/order_processor_spec.rb
RSpec.describe OrderProcessor do
  let(:database) { instance_double(Database) }
  let(:mailer) { instance_double(Mailer) }
  let(:payment_gateway) { instance_double(PaymentGateway) }
  let(:order) { build(:order) }

  subject(:processor) do
    OrderProcessor.new(
      database: database,
      mailer: mailer,
      payment_gateway: payment_gateway
    )
  end

  describe '#process' do
    it 'saves order to database' do
      expect(database).to receive(:save).with(order)
      allow(mailer).to receive(:send_confirmation)
      allow(payment_gateway).to receive(:charge)

      processor.process(order)
    end

    it 'sends confirmation email' do
      allow(database).to receive(:save)
      expect(mailer).to receive(:send_confirmation).with(order)
      allow(payment_gateway).to receive(:charge)

      processor.process(order)
    end

    it 'charges payment' do
      allow(database).to receive(:save)
      allow(mailer).to receive(:send_confirmation)
      expect(payment_gateway).to receive(:charge).with(order.total)

      processor.process(order)
    end
  end
end
```

## ✍️ Exercises

### Exercise 1: SRP Refactoring
👉 **[Single Responsibility Practice](exercises/1-srp-refactoring.md)**

Refactor:
- God object into focused classes
- Controller with business logic
- Model with reporting logic
- Fat service objects

### Exercise 2: OCP Implementation
👉 **[Open/Closed Practice](exercises/2-ocp-implementation.md)**

Build extensible:
- Report generator (PDF, Excel, CSV)
- Notification system (Email, SMS, Push)
- Discount calculator (Percentage, Fixed, BOGO)
- Validation pipeline

### Exercise 3: Full SOLID Application
👉 **[Complete SOLID App](exercises/3-solid-application.md)**

Build a blogging platform following all SOLID principles:
- Post publishing workflow
- Comment moderation
- User permissions
- Email notifications

## 📚 What You Learned

✅ Single Responsibility Principle
✅ Open/Closed Principle
✅ Liskov Substitution Principle
✅ Interface Segregation Principle
✅ Dependency Inversion Principle
✅ Recognizing SOLID violations
✅ Refactoring techniques
✅ Ruby-specific SOLID implementations

## 🔜 Next Steps

**Next: [Tutorial 6: Development Tools](../6-development-tools/README.md)**

Learn to:
- Master Bundler for dependency management
- Debug with Pry and byebug
- Develop Ruby gems
- Use IRB effectively

## 💡 Key Takeaways for Python Developers

1. **SRP**: Same in both languages - one class, one job
2. **OCP**: Ruby's modules make extension easier
3. **LSP**: Duck typing makes this natural in both
4. **ISP**: Ruby's mixins perfect for this
5. **DIP**: Constructor injection works in both
6. **Testing**: SOLID makes testing easier in both languages
7. **Refactoring**: Similar patterns, different syntax

## 🆘 Common Pitfalls

### Pitfall 1: Over-Engineering

```ruby
# Bad: Too many layers for simple logic
class UserNameFormatter
  def initialize(user_name_provider)
    @provider = user_name_provider
  end

  def format
    @provider.get_name
  end
end

# Good: Simple when simple is enough
class User
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

### Pitfall 2: Abstract for Everything

```ruby
# Bad: Unnecessary abstraction
class PaymentProcessor
  def initialize(payment_gateway)
    @gateway = payment_gateway
  end

  def process(amount)
    @gateway.charge(amount)
  end
end

# Only one implementation exists and won't change
# Just use Stripe directly until you need abstraction
```

### Pitfall 3: Interface Explosion

```ruby
# Bad: Too granular
module Creatable; end
module Updatable; end
module Deletable; end
module Findable; end
module Saveable; end

# Good: Logical grouping
module Persistable
  def save; end
  def update; end
  def delete; end
end
```

## 📖 Additional Resources

- [SOLID Principles in Ruby](https://www.sihui.io/solid-principles/)
- [Practical Object-Oriented Design in Ruby (POODR)](https://www.poodr.com/)
- [Clean Architecture in Ruby](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Dependency Injection in Ruby](https://solnic.codes/2013/12/17/the-world-needs-another-post-about-dependency-injection-in-ruby/)

---

Ready to write SOLID code? Start with **[Exercise 1: SRP Refactoring](exercises/1-srp-refactoring.md)**! 🏛️
