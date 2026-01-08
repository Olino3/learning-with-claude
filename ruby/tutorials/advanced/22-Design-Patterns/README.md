# Tutorial 22: Design Patterns (Ruby Edition)

Master Ruby-specific implementations of classic design patterns, taking advantage of Ruby's dynamic nature and metaprogramming.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Implement Proxy and Decorator patterns with SimpleDelegator
- Use Service Objects and Interactors for business logic
- Apply the Singleton pattern effectively
- Understand Observer pattern with Ruby's built-in Observable
- Master Factory and Builder patterns
- Know when to use each pattern in Ruby

## 🐍➡️🔴 Coming from Python

Design patterns are universal, but Ruby's implementation differs:

| Pattern | Python | Ruby |
|---------|--------|------|
| Singleton | Custom metaclass or decorator | `Singleton` module or class variables |
| Decorator | `@decorator` syntax | `SimpleDelegator`, modules |
| Proxy | Custom `__getattr__` | `SimpleDelegator`, `Forwardable` |
| Observer | Manual implementation | `Observable` module (stdlib) |
| Factory | Class methods | Class methods or modules |
| Builder | Fluent interface | Method chaining, DSLs |

> **📘 Python Note:** Ruby's dynamic nature and mixins often provide simpler pattern implementations than Python's class-based approach.

## 📝 Proxy and Decorator Patterns

### SimpleDelegator - The Ruby Way

```ruby
require 'delegate'

class User
  attr_accessor :name, :email
  
  def initialize(name, email)
    @name = name
    @email = email
  end
  
  def info
    "#{name} <#{email}>"
  end
end

# Decorator using SimpleDelegator
class UserDecorator < SimpleDelegator
  def formatted_name
    __getobj__.name.upcase
  end
  
  def info
    "USER: #{super}"  # Can call original method
  end
  
  def admin?
    false
  end
end

user = User.new("Alice", "alice@example.com")
decorated = UserDecorator.new(user)

puts decorated.name              # Delegates to user
puts decorated.formatted_name    # New method
puts decorated.info              # Enhanced method
puts decorated.admin?            # New method
```

### Forwardable for Delegation

```ruby
require 'forwardable'

class Account
  attr_reader :balance
  
  def initialize
    @balance = 0
  end
  
  def deposit(amount)
    @balance += amount
  end
  
  def withdraw(amount)
    @balance -= amount if @balance >= amount
  end
end

class User
  extend Forwardable
  
  attr_reader :name, :account
  
  def_delegators :@account, :balance, :deposit, :withdraw
  
  def initialize(name)
    @name = name
    @account = Account.new
  end
end

user = User.new("Alice")
user.deposit(100)
user.withdraw(30)
puts "Balance: #{user.balance}"
```

> **📘 Python Note:** Simpler than Python's `__getattr__` approach. `Forwardable` explicitly delegates specific methods.

## 📝 Service Objects and Interactors

Service objects encapsulate business logic, keeping models thin:

```ruby
# Service Object Pattern
class UserRegistrationService
  def initialize(params)
    @params = params
  end
  
  def call
    return failure("Invalid params") unless valid?
    
    user = create_user
    send_welcome_email(user)
    log_registration(user)
    
    success(user)
  rescue => e
    failure(e.message)
  end
  
  private
  
  def valid?
    @params[:email] && @params[:password]
  end
  
  def create_user
    User.new(@params[:email], @params[:password])
  end
  
  def send_welcome_email(user)
    puts "Sending welcome email to #{user.email}"
  end
  
  def log_registration(user)
    puts "User #{user.email} registered at #{Time.now}"
  end
  
  def success(user)
    { success: true, user: user }
  end
  
  def failure(message)
    { success: false, error: message }
  end
end

# Usage
service = UserRegistrationService.new(
  email: "alice@example.com",
  password: "secret123"
)
result = service.call

if result[:success]
  puts "Registration successful!"
else
  puts "Error: #{result[:error]}"
end
```

### Interactor Pattern

```ruby
# Interactor pattern with context
class Interactor
  def self.call(*args)
    new(*args).call
  end
  
  class Context
    attr_accessor :success, :error
    
    def initialize(attributes = {})
      attributes.each { |key, value| send("#{key}=", value) }
      @success = true
    end
    
    def success?
      @success
    end
    
    def fail!(error)
      @success = false
      @error = error
      raise StopExecution
    end
    
    class StopExecution < StandardError; end
  end
end

class CreateOrder < Interactor
  def call
    validate_items
    calculate_total
    process_payment
    create_order_record
  rescue Context::StopExecution
    # Context already has error set
  end
  
  private
  
  def validate_items
    context.fail!("No items") if context.items.empty?
  end
  
  def calculate_total
    context.total = context.items.sum { |item| item[:price] * item[:quantity] }
  end
  
  def process_payment
    puts "Processing payment of $#{context.total}"
    # Payment logic here
  end
  
  def create_order_record
    context.order = { id: rand(1000), total: context.total }
    puts "Order created: #{context.order}"
  end
  
  attr_reader :context
  
  def initialize(context)
    @context = context
  end
end

# Usage
context = CreateOrder::Context.new(
  items: [
    { name: "Book", price: 20, quantity: 2 },
    { name: "Pen", price: 5, quantity: 3 }
  ]
)

CreateOrder.call(context)

if context.success?
  puts "Order successful: #{context.order}"
else
  puts "Order failed: #{context.error}"
end
```

> **📘 Python Note:** Similar to Django's service layer or Flask's business logic separation. Ruby's approach uses simple objects rather than complex frameworks.

## 📝 Singleton Pattern

```ruby
require 'singleton'

class Configuration
  include Singleton
  
  attr_accessor :api_key, :api_url, :timeout
  
  def initialize
    @api_key = nil
    @api_url = "https://api.example.com"
    @timeout = 30
  end
end

# Can't use new
# Configuration.new  # NoMethodError

# Access singleton instance
config = Configuration.instance
config.api_key = "secret-key"
config.timeout = 60

# Same instance everywhere
config2 = Configuration.instance
puts config.object_id == config2.object_id  # => true
puts config2.api_key  # => "secret-key"
```

### Manual Singleton (without module)

```ruby
class Database
  @instance = nil
  
  def self.instance
    @instance ||= new
  end
  
  def connect
    puts "Connected to database"
  end
  
  private_class_method :new
end

db1 = Database.instance
db2 = Database.instance

puts db1.object_id == db2.object_id  # => true
```

## 📝 Observer Pattern

```ruby
require 'observer'

class Stock
  include Observable
  
  attr_reader :symbol, :price
  
  def initialize(symbol, price)
    @symbol = symbol
    @price = price
  end
  
  def price=(new_price)
    @price = new_price
    changed
    notify_observers(self)
  end
end

class StockObserver
  def update(stock)
    puts "#{self.class.name} notified: #{stock.symbol} is now $#{stock.price}"
  end
end

class EmailNotifier < StockObserver
  def update(stock)
    puts "📧 Email: Stock #{stock.symbol} changed to $#{stock.price}"
  end
end

class SMSNotifier < StockObserver
  def update(stock)
    puts "📱 SMS: #{stock.symbol} = $#{stock.price}"
  end
end

# Setup
stock = Stock.new("RUBY", 100)

email = EmailNotifier.new
sms = SMSNotifier.new

stock.add_observer(email)
stock.add_observer(sms)

# Trigger notifications
stock.price = 105
stock.price = 110

# Remove observer
stock.delete_observer(sms)
stock.price = 115  # Only email notified
```

## 📝 Factory Pattern

```ruby
# Factory Method Pattern
class DocumentFactory
  def self.create(type, content)
    case type
    when :pdf
      PDFDocument.new(content)
    when :word
      WordDocument.new(content)
    when :text
      TextDocument.new(content)
    else
      raise "Unknown document type: #{type}"
    end
  end
end

class PDFDocument
  def initialize(content)
    @content = content
  end
  
  def render
    "PDF: #{@content}"
  end
end

class WordDocument
  def initialize(content)
    @content = content
  end
  
  def render
    "WORD: #{@content}"
  end
end

class TextDocument
  def initialize(content)
    @content = content
  end
  
  def render
    "TEXT: #{@content}"
  end
end

# Usage
pdf = DocumentFactory.create(:pdf, "Hello PDF")
word = DocumentFactory.create(:word, "Hello Word")

puts pdf.render
puts word.render
```

### Abstract Factory

```ruby
# Abstract Factory for UI components
class UIFactory
  def self.for_platform(platform)
    case platform
    when :windows
      WindowsFactory.new
    when :mac
      MacFactory.new
    else
      raise "Unknown platform"
    end
  end
end

class WindowsFactory
  def create_button
    WindowsButton.new
  end
  
  def create_checkbox
    WindowsCheckbox.new
  end
end

class MacFactory
  def create_button
    MacButton.new
  end
  
  def create_checkbox
    MacCheckbox.new
  end
end

class WindowsButton
  def render
    "[Windows Button]"
  end
end

class MacButton
  def render
    "(Mac Button)"
  end
end

# Usage
factory = UIFactory.for_platform(:mac)
button = factory.create_button
puts button.render  # => "(Mac Button)"
```

## 📝 Builder Pattern

```ruby
class QueryBuilder
  def initialize(table)
    @table = table
    @wheres = []
    @orders = []
    @limit_value = nil
  end
  
  def where(condition)
    @wheres << condition
    self  # Return self for chaining
  end
  
  def order(field, direction = :asc)
    @orders << "#{field} #{direction.to_s.upcase}"
    self
  end
  
  def limit(n)
    @limit_value = n
    self
  end
  
  def to_sql
    sql = "SELECT * FROM #{@table}"
    sql += " WHERE #{@wheres.join(' AND ')}" unless @wheres.empty?
    sql += " ORDER BY #{@orders.join(', ')}" unless @orders.empty?
    sql += " LIMIT #{@limit_value}" if @limit_value
    sql
  end
end

# Fluent interface
query = QueryBuilder.new(:users)
  .where("age > 18")
  .where("active = true")
  .order(:created_at, :desc)
  .limit(10)

puts query.to_sql
```

## ✍️ Practice Exercise

```bash
ruby ruby/tutorials/advanced/22-Design-Patterns/exercises/patterns_practice.rb
```

## 📚 What You Learned

✅ Proxy/Decorator with SimpleDelegator and Forwardable
✅ Service Objects and Interactors for business logic
✅ Singleton pattern implementation
✅ Observer pattern with Observable module
✅ Factory and Abstract Factory patterns
✅ Builder pattern with method chaining
✅ When to use each pattern in Ruby

## 🔜 Next Steps

Congratulations! You've completed the advanced Ruby tutorials. Now:
- Work through the advanced labs
- Build real projects using these patterns
- Contribute to open-source Ruby projects
- Explore frameworks like Rails and their pattern usage

## 💡 Key Takeaways for Python Developers

1. **SimpleDelegator**: Simpler than `__getattr__` for delegation
2. **Service Objects**: Similar to Django/Flask service layers
3. **Singleton module**: Built-in, unlike Python's various approaches
4. **Observable**: Built into stdlib, unlike Python
5. **Patterns are simpler**: Ruby's dynamic nature simplifies implementations
6. **Metaprogramming enables patterns**: Many patterns use Ruby's dynamic features

## 📖 Additional Resources

- [Design Patterns in Ruby](https://refactoring.guru/design-patterns/ruby)
- [Ruby Design Patterns](https://github.com/davidgf/design-patterns-in-ruby)
- [Forwardable Documentation](https://ruby-doc.org/stdlib/libdoc/forwardable/rdoc/Forwardable.html)

---

Congratulations on completing the advanced tutorials!
