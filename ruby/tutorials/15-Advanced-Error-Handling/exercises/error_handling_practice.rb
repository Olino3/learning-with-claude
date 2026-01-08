#!/usr/bin/env ruby
# Advanced Error Handling Practice Script

puts "=== Advanced Error Handling Practice ==="
puts

# Section 1: Basic Begin/Rescue/Ensure
puts "1. Basic Begin/Rescue/Ensure"
puts "-" * 40

def divide(a, b)
  begin
    result = a / b
    puts "  Result: #{result}"
    result
  rescue ZeroDivisionError => e
    puts "  Error: Cannot divide by zero"
    nil
  ensure
    puts "  Cleanup completed"
  end
end

divide(10, 2)
divide(10, 0)
puts

# Section 2: Rescue with Else
puts "2. Rescue with Else"
puts "-" * 40

def parse_number(str)
  begin
    number = Integer(str)
  rescue ArgumentError => e
    puts "  Error: '#{str}' is not a valid number"
    return nil
  else
    puts "  Success: Parsed #{number}"
    return number
  ensure
    puts "  Parsing attempt completed"
  end
end

parse_number("42")
parse_number("not a number")
puts

# Section 3: Custom Exceptions
puts "3. Custom Exceptions"
puts "-" * 40

class ValidationError < StandardError; end

class NotFoundError < StandardError
  def initialize(resource, id)
    super("#{resource} with id #{id} not found")
    @resource = resource
    @id = id
  end

  attr_reader :resource, :id
end

class APIError < StandardError
  attr_reader :status_code, :response_body

  def initialize(message, status_code, response_body = nil)
    super(message)
    @status_code = status_code
    @response_body = response_body
  end
end

# Using custom exceptions
begin
  raise ValidationError, "Name cannot be blank"
rescue ValidationError => e
  puts "Validation failed: #{e.message}"
end

begin
  raise NotFoundError.new("User", 123)
rescue NotFoundError => e
  puts "Error: #{e.message}"
  puts "Resource: #{e.resource}, ID: #{e.id}"
end

begin
  raise APIError.new("Request failed", 500, { error: "Internal server error" })
rescue APIError => e
  puts "API Error (#{e.status_code}): #{e.message}"
  puts "Response: #{e.response_body.inspect}"
end
puts

# Section 4: Exception Hierarchy
puts "4. Exception Hierarchy"
puts "-" * 40

class ApplicationError < StandardError; end
class DatabaseError < ApplicationError; end
class ValidationError < ApplicationError; end

def risky_operation(type)
  case type
  when :database
    raise DatabaseError, "Database connection failed"
  when :validation
    raise ValidationError, "Invalid input"
  else
    raise ApplicationError, "Unknown error"
  end
end

[:database, :validation, :other].each do |type|
  begin
    risky_operation(type)
  rescue DatabaseError => e
    puts "Database error: #{e.message}"
  rescue ValidationError => e
    puts "Validation error: #{e.message}"
  rescue ApplicationError => e
    puts "Application error: #{e.message}"
  end
end
puts

# Section 5: Multiple Rescue Clauses
puts "5. Multiple Rescue Clauses"
puts "-" * 40

def process_file(filename)
  begin
    puts "  Opening #{filename}..."
    content = case filename
    when "missing.txt"
      raise Errno::ENOENT, "File not found"
    when "invalid.json"
      raise ArgumentError, "Invalid JSON"
    else
      "Valid content"
    end
    puts "  Successfully processed: #{content}"
  rescue Errno::ENOENT => e
    puts "  File error: #{e.message}"
  rescue ArgumentError => e
    puts "  Parse error: #{e.message}"
  rescue => e
    puts "  Unexpected error: #{e.class} - #{e.message}"
  end
end

process_file("valid.txt")
process_file("missing.txt")
process_file("invalid.json")
puts

# Section 6: Rescue Modifier
puts "6. Rescue Modifier (Inline Rescue)"
puts "-" * 40

# Instead of begin/rescue/end for simple cases
config = (raise "Config missing") rescue { default: true }
puts "Config: #{config.inspect}"

count = nil.length rescue 0
puts "Count: #{count}"

name = nil.fetch(:name) rescue "Unknown"
puts "Name: #{name}"
puts

# Section 7: Retry Mechanism
puts "7. Retry Mechanism"
puts "-" * 40

def fetch_with_retry(max_attempts = 3)
  attempts = 0

  begin
    attempts += 1
    puts "  Attempt #{attempts}..."

    # Simulate network request with random failure
    if rand < 0.6
      raise "Network timeout"
    end

    "Success!"
  rescue => e
    if attempts < max_attempts
      puts "  Failed: #{e.message}. Retrying..."
      sleep(0.2)
      retry
    else
      puts "  Failed after #{max_attempts} attempts"
      raise
    end
  end
end

begin
  result = fetch_with_retry
  puts "Final result: #{result}"
rescue => e
  puts "Could not complete: #{e.message}"
end
puts

# Section 8: Exponential Backoff
puts "8. Exponential Backoff"
puts "-" * 40

def fetch_with_backoff(max_attempts = 4)
  attempts = 0
  base_delay = 0.1

  begin
    attempts += 1
    puts "  Attempt #{attempts}..."

    # Simulate failure
    if rand < 0.7
      raise "Temporary failure"
    end

    "Data retrieved!"
  rescue => e
    if attempts < max_attempts
      delay = base_delay * (2 ** (attempts - 1))
      puts "  Failed. Waiting #{delay.round(2)}s before retry..."
      sleep(delay)
      retry
    else
      puts "  All attempts exhausted"
      raise
    end
  end
end

begin
  result = fetch_with_backoff
  puts "Result: #{result}"
rescue => e
  puts "Failed: #{e.message}"
end
puts

# Section 9: Raise Variations
puts "9. Different Ways to Raise"
puts "-" * 40

begin
  # raise ArgumentError  # With default message
  # raise ArgumentError, "Custom message"  # With message
  raise ArgumentError.new("Detailed message with data: #{123}")  # Preferred
rescue => e
  puts "Caught: #{e.class} - #{e.message}"
end

# Re-raising
begin
  begin
    raise "Inner error"
  rescue => e
    puts "Inner rescue: #{e.message}"
    raise  # Re-raises the same exception
  end
rescue => e
  puts "Outer rescue: #{e.message}"
end
puts

# Section 10: Throw and Catch (Flow Control)
puts "10. Throw and Catch (Not Exceptions!)"
puts "-" * 40

def find_in_nested(data, target)
  catch(:found) do
    data.each do |group|
      group[:items].each do |item|
        if item[:name] == target
          throw(:found, item)
        end
      end
    end
    nil  # Not found
  end
end

data = [
  { group: "A", items: [{ name: "item1" }, { name: "item2" }] },
  { group: "B", items: [{ name: "item3" }, { name: "target" }] },
  { group: "C", items: [{ name: "item4" }, { name: "item5" }] }
]

result = find_in_nested(data, "target")
puts "Found: #{result.inspect}"

result = find_in_nested(data, "missing")
puts "Found: #{result.inspect}"
puts

# Section 11: Error with Context
puts "11. Error with Context"
puts "-" * 40

class ContextualError < StandardError
  attr_reader :context

  def initialize(message, context = {})
    super(message)
    @context = context
  end

  def full_message
    parts = [message]
    parts << "Context:" if context.any?
    context.each { |k, v| parts << "  #{k}: #{v}" }
    parts.join("\n")
  end
end

begin
  raise ContextualError.new(
    "Order processing failed",
    {
      order_id: 12345,
      user_id: 67890,
      timestamp: Time.now,
      amount: 99.99
    }
  )
rescue ContextualError => e
  puts e.full_message
end
puts

# Section 12: Circuit Breaker Pattern
puts "12. Circuit Breaker Pattern"
puts "-" * 40

class CircuitBreaker
  attr_reader :state, :failure_count

  def initialize(failure_threshold: 3, timeout: 5)
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
        puts "  Circuit breaker: HALF-OPEN (testing)"
        @state = :half_open
        attempt_call { yield }
      else
        raise "Circuit breaker is OPEN (#{@failure_count} failures)"
      end
    when :half_open, :closed
      attempt_call { yield }
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
    puts "  Circuit breaker: CLOSED (healthy)"
  end

  def failure
    @failure_count += 1
    @last_failure_time = Time.now

    if @failure_count >= @failure_threshold
      @state = :open
      puts "  Circuit breaker: OPEN (too many failures)"
    end
  end
end

breaker = CircuitBreaker.new(failure_threshold: 2, timeout: 2)

8.times do |i|
  begin
    breaker.call do
      # Simulate flaky service
      if i < 3 || i > 5
        raise "Service unavailable"
      end
      puts "  Request #{i}: SUCCESS"
    end
  rescue => e
    puts "  Request #{i}: FAILED - #{e.message}"
  end
  sleep(0.3)
end
puts

# Section 13: Safe Navigation with Rescue
puts "13. Safe Navigation with Rescue"
puts "-" * 40

users = [
  { name: "Alice", email: "alice@example.com" },
  { name: "Bob" },  # No email
  nil
]

users.each_with_index do |user, i|
  email = (user[:email] rescue "No email") || "No email"
  name = (user[:name] rescue "Unknown") || "Unknown"
  puts "User #{i}: #{name} - #{email}"
end
puts

# Section 14: Ensure for Cleanup
puts "14. Ensure for Cleanup"
puts "-" * 40

class Resource
  def initialize(name)
    @name = name
    @open = true
    puts "  Opened: #{@name}"
  end

  def use
    raise "Resource error!" if @name == "bad_resource"
    puts "  Using: #{@name}"
  end

  def close
    return unless @open
    @open = false
    puts "  Closed: #{@name}"
  end
end

def use_resource(name)
  resource = Resource.new(name)
  begin
    resource.use
  ensure
    resource.close
  end
rescue => e
  puts "  Error handled: #{e.message}"
end

use_resource("good_resource")
use_resource("bad_resource")
puts

# Section 15: Custom Error Logger
puts "15. Error Logging Pattern"
puts "-" * 40

class ErrorLogger
  def self.log(message, exception: nil, context: {})
    log_entry = {
      timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      level: "ERROR",
      message: message,
      context: context
    }

    if exception
      log_entry[:exception] = {
        class: exception.class.name,
        message: exception.message,
        backtrace: exception.backtrace&.first(3)
      }
    end

    puts "LOG: #{log_entry.inspect}"
  end
end

begin
  raise "Something went wrong"
rescue => e
  ErrorLogger.log(
    "Operation failed",
    exception: e,
    context: { user_id: 123, action: "update_profile" }
  )
end
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. rescue = except, ensure = finally"
puts "2. Always inherit custom exceptions from StandardError"
puts "3. Use 'rescue => e' to catch StandardError and subclasses"
puts "4. Never rescue Exception (too broad)"
puts "5. retry is built into Ruby (no manual loops needed)"
puts "6. Rescue modifier for simple cases: value rescue default"
puts "7. throw/catch for flow control, not exceptions"
puts "8. Use ensure for cleanup (like Python's finally)"
puts
