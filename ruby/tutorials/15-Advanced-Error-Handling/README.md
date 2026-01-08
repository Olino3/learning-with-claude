# Tutorial 15: Advanced Error Handling and Custom Exceptions

Welcome to advanced error handling in Ruby! While you've seen basic `begin/rescue/end`, this tutorial covers production-grade error handling patterns, custom exceptions, and recovery strategies used in real-world applications.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master begin/rescue/ensure/else patterns
- Create custom exception classes
- Understand exception hierarchy
- Use retry for transient failures
- Implement raise with custom messages
- Handle multiple exception types
- Use throw/catch for flow control
- Apply circuit breaker and retry patterns
- Understand when to rescue vs when to fail

## 🐍➡️🔴 Coming from Python

Ruby's exception handling is similar to Python's but with some differences:

| Concept | Python | Ruby |
|---------|--------|------|
| Try/catch block | `try/except` | `begin/rescue` |
| Finally | `finally` | `ensure` |
| Raise exception | `raise ValueError()` | `raise ArgumentError` |
| Custom exception | Inherit from `Exception` | Inherit from `StandardError` |
| Catch specific | `except ValueError:` | `rescue ArgumentError` |
| Catch all | `except:` | `rescue` |
| Re-raise | `raise` | `raise` |
| Exception object | `as e` | `=> e` |

> **📘 Python Note:** Ruby uses `rescue` instead of `except`, and the exception hierarchy is slightly different.

## 📝 Begin/Rescue/Ensure/Else

The complete error handling structure:

```ruby
begin
  # Code that might raise an exception
  risky_operation
rescue SpecificError => e
  # Handle specific error
  puts "Specific error: #{e.message}"
rescue => e
  # Handle any StandardError
  puts "General error: #{e.message}"
else
  # Runs if no exception was raised
  puts "Success!"
ensure
  # Always runs (like finally in Python)
  cleanup_resources
end
```

### Basic Example

```ruby
def divide(a, b)
  begin
    result = a / b
  rescue ZeroDivisionError => e
    puts "Error: #{e.message}"
    return nil
  else
    puts "Division successful"
    return result
  ensure
    puts "Cleaning up..."
  end
end

puts divide(10, 2)
puts divide(10, 0)
```

> **📘 Python Note:** The `else` block exists in both languages but is rarely used. `ensure` is like Python's `finally`.

## 📝 Exception Hierarchy

Understanding Ruby's exception hierarchy helps you rescue the right exceptions:

```
Exception
├── NoMemoryError
├── ScriptError
│   ├── LoadError
│   ├── NotImplementedError
│   └── SyntaxError
├── SecurityError
├── SignalException
│   └── Interrupt
├── StandardError (← Rescue this level by default)
│   ├── ArgumentError
│   ├── IOError
│   │   └── EOFError
│   ├── IndexError
│   ├── LocalJumpError
│   ├── NameError
│   │   └── NoMethodError
│   ├── RangeError
│   ├── RuntimeError
│   ├── SystemCallError
│   ├── ThreadError
│   ├── TypeError
│   └── ZeroDivisionError
└── SystemExit
```

### Important Rules

```ruby
# DON'T rescue Exception - too broad!
begin
  # code
rescue Exception => e  # BAD - catches everything including system exits
end

# DO rescue StandardError (or be more specific)
begin
  # code
rescue StandardError => e  # GOOD
end

# rescue without type catches StandardError
begin
  # code
rescue => e  # Catches StandardError and subclasses
end
```

> **📘 Python Note:** In Python, you'd inherit from `Exception`. In Ruby, inherit from `StandardError` for application exceptions.

## 📝 Custom Exceptions

Create custom exceptions for better error handling:

```ruby
# Basic custom exception
class ValidationError < StandardError
end

# With default message
class NotFoundError < StandardError
  def initialize(msg = "Record not found")
    super
  end
end

# With additional data
class APIError < StandardError
  attr_reader :status_code, :response

  def initialize(message, status_code, response = nil)
    super(message)
    @status_code = status_code
    @response = response
  end
end

# Usage
begin
  raise ValidationError, "Name cannot be blank"
rescue ValidationError => e
  puts "Validation failed: #{e.message}"
end

begin
  raise APIError.new("API request failed", 500, { error: "Server error" })
rescue APIError => e
  puts "API Error (#{e.status_code}): #{e.message}"
  puts "Response: #{e.response.inspect}"
end
```

### Exception Hierarchy for Domain

```ruby
class ApplicationError < StandardError; end

class DatabaseError < ApplicationError; end
class ConnectionError < DatabaseError; end
class QueryError < DatabaseError; end

class ValidationError < ApplicationError; end
class PresenceError < ValidationError; end
class FormatError < ValidationError; end

# Now you can rescue broadly or specifically
begin
  # database operations
rescue DatabaseError => e
  # Handles both ConnectionError and QueryError
  puts "Database problem: #{e.message}"
rescue ValidationError => e
  # Handles PresenceError and FormatError
  puts "Validation problem: #{e.message}"
rescue ApplicationError => e
  # Catches everything else
  puts "Application error: #{e.message}"
end
```

## 📝 Rescue Modifiers

Inline rescue for simple cases:

```ruby
# Instead of:
begin
  result = risky_operation
rescue
  result = default_value
end

# Use inline rescue:
result = risky_operation rescue default_value

# Examples
config = load_config rescue {}
count = items.length rescue 0
name = user.name rescue "Unknown"
```

> **⚠️ Warning:** Only use rescue modifier for simple cases. It rescues StandardError and all subclasses.

## 📝 Retry - Handling Transient Failures

Use `retry` to retry after an error:

```ruby
def fetch_data(url, max_attempts = 3)
  attempts = 0

  begin
    attempts += 1
    puts "Attempt #{attempts}..."

    # Simulate network request
    raise "Network timeout" if rand < 0.7

    "Data from #{url}"
  rescue => e
    if attempts < max_attempts
      puts "Failed: #{e.message}. Retrying..."
      sleep(1)
      retry  # Goes back to begin
    else
      puts "Failed after #{max_attempts} attempts"
      raise
    end
  end
end

# result = fetch_data("https://api.example.com/data")
```

### Exponential Backoff

```ruby
def fetch_with_backoff(max_attempts = 5)
  attempts = 0
  base_delay = 1

  begin
    attempts += 1
    # Risky operation
    raise "Temporary failure" if rand < 0.8

    "Success!"
  rescue => e
    if attempts < max_attempts
      delay = base_delay * (2 ** (attempts - 1))
      puts "Attempt #{attempts} failed. Waiting #{delay}s..."
      sleep(delay)
      retry
    else
      raise
    end
  end
end
```

## 📝 Raise - Raising Exceptions

Different ways to raise exceptions:

```ruby
# Raise with default message
raise ArgumentError

# Raise with custom message
raise ArgumentError, "Invalid argument provided"

# Raise with new exception (preferred)
raise ArgumentError.new("Invalid argument: #{arg}")

# Re-raise current exception
begin
  risky_operation
rescue => e
  log_error(e)
  raise  # Re-raises the same exception
end

# Raise with cause (Ruby 2.1+)
begin
  inner_operation
rescue => e
  raise CustomError, "Outer error", cause: e
end
```

## 📝 Multiple Rescue Clauses

Handle different exceptions differently:

```ruby
def process_file(filename)
  begin
    file = File.open(filename)
    data = parse_data(file.read)
    process(data)
  rescue Errno::ENOENT => e
    puts "File not found: #{filename}"
  rescue JSON::ParserError => e
    puts "Invalid JSON in file: #{e.message}"
  rescue => e
    puts "Unexpected error: #{e.class} - #{e.message}"
  ensure
    file&.close
  end
end
```

## 📝 Throw and Catch - Flow Control

`throw` and `catch` are NOT for exceptions - they're for flow control:

```ruby
# Finding first match in nested structure
def find_user(users, target_name)
  catch(:found) do
    users.each do |user|
      user[:friends].each do |friend|
        throw(:found, friend) if friend[:name] == target_name
      end
    end
    nil  # Not found
  end
end

users = [
  { name: "Alice", friends: [
    { name: "Bob" },
    { name: "Charlie" }
  ]},
  { name: "David", friends: [
    { name: "Eve" },
    { name: "Frank" }
  ]}
]

result = find_user(users, "Eve")
puts result.inspect
```

> **📘 Python Note:** Python doesn't have throw/catch. Use exceptions or return values instead.

## 📝 Production Patterns

### 1. Error Context

```ruby
class ContextualError < StandardError
  attr_reader :context

  def initialize(message, context = {})
    super(message)
    @context = context
  end

  def full_message
    "#{message}\nContext: #{context.inspect}"
  end
end

begin
  process_order(order_id: 123, user_id: 456)
rescue => e
  raise ContextualError.new(
    "Order processing failed",
    {
      order_id: 123,
      user_id: 456,
      original_error: e.message
    }
  )
end
```

### 2. Circuit Breaker Pattern

```ruby
class CircuitBreaker
  def initialize(failure_threshold: 5, timeout: 60)
    @failure_threshold = failure_threshold
    @timeout = timeout
    @failure_count = 0
    @last_failure_time = nil
    @state = :closed
  end

  def call
    case @state
    when :open
      if Time.now - @last_failure_time > @timeout
        @state = :half_open
        attempt_call
      else
        raise "Circuit breaker is OPEN"
      end
    when :half_open, :closed
      attempt_call
    end
  end

  private

  def attempt_call
    yield
    success
  rescue => e
    failure
    raise
  end

  def success
    @failure_count = 0
    @state = :closed
  end

  def failure
    @failure_count += 1
    @last_failure_time = Time.now

    if @failure_count >= @failure_threshold
      @state = :open
    end
  end
end

# Usage
breaker = CircuitBreaker.new(failure_threshold: 3, timeout: 10)

5.times do |i|
  begin
    breaker.call do
      raise "Service unavailable" if rand < 0.8
      puts "Request #{i} succeeded"
    end
  rescue => e
    puts "Request #{i} failed: #{e.message}"
  end
  sleep(0.5)
end
```

### 3. Logging with Errors

```ruby
class Logger
  def self.error(message, exception: nil, context: {})
    log = {
      level: "ERROR",
      message: message,
      timestamp: Time.now,
      context: context
    }

    if exception
      log[:exception] = {
        class: exception.class.name,
        message: exception.message,
        backtrace: exception.backtrace&.first(5)
      }
    end

    puts JSON.generate(log)
  end
end

begin
  risky_operation
rescue => e
  Logger.error(
    "Operation failed",
    exception: e,
    context: { user_id: 123, operation: "update_profile" }
  )
end
```

## ✍️ Practice Exercise

Run the practice script to see all these concepts in action:

```bash
ruby ruby/tutorials/15-Advanced-Error-Handling/exercises/error_handling_practice.rb
```

## 📚 What You Learned

✅ Complete begin/rescue/ensure/else syntax
✅ Ruby's exception hierarchy
✅ Creating custom exception classes
✅ Using retry for transient failures
✅ Multiple rescue clauses
✅ Rescue modifiers for simple cases
✅ throw/catch for flow control
✅ Production patterns (circuit breaker, logging)

## 🔜 Next Steps

**Next tutorial: 16-Idiomatic-Ruby-Patterns** - Learn enumerable patterns, duck typing, memoization, and other idiomatic Ruby techniques.

## 💡 Key Takeaways for Python Developers

1. **rescue vs except**: Same concept, different keywords
2. **ensure vs finally**: Identical behavior
3. **StandardError**: Always inherit from this for custom exceptions
4. **Rescue modifier**: `value rescue default` is concise but use carefully
5. **throw/catch**: Not for exceptions - use for flow control
6. **retry**: Built-in retry mechanism (Python needs manual loops)

## 🆘 Common Pitfalls

### Pitfall 1: Rescuing Exception
```ruby
# BAD - catches system exits and other critical errors
rescue Exception => e

# GOOD - catches application errors
rescue StandardError => e
# or just
rescue => e
```

### Pitfall 2: Empty rescue
```ruby
# BAD - swallows all errors
begin
  something
rescue
end

# GOOD - at least log the error
begin
  something
rescue => e
  log_error(e)
  raise
end
```

### Pitfall 3: Rescue in wrong place
```ruby
# BAD - rescues in loop
10.times do
  begin
    might_fail
  rescue
    # Creates new rescue context 10 times!
  end
end

# GOOD - rescue outside loop if possible
begin
  10.times do
    might_fail
  end
rescue => e
  # Handle once
end
```

## 📖 Additional Resources

- [Ruby Exceptions](https://ruby-doc.org/core-3.4.0/Exception.html)
- [Error Handling Best Practices](https://www.honeybadger.io/blog/a-beginner-s-guide-to-exceptions-in-ruby/)
- [Ruby rescue vs ensure](https://www.rubyguides.com/2019/06/ruby-rescue-exceptions/)

---

Ready to handle errors like a pro? Run the exercises and master error handling!
