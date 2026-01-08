#!/usr/bin/env ruby
# Advanced Blocks, Procs, and Lambdas Practice Script

puts "=== Advanced Blocks, Procs, and Lambdas Practice ==="
puts

# Section 1: Block Basics with yield
puts "1. Blocks with yield"
puts "-" * 40

def greet(name)
  puts "Before block"
  yield name if block_given?
  puts "After block"
end

greet("Alice") { |name| puts "  Hello, #{name}!" }
greet("Bob")  # No block - no error because of block_given?
puts

# Section 2: Block Parameters
puts "2. Blocks with Multiple Parameters"
puts "-" * 40

def process_pair(a, b)
  result = yield a, b
  puts "Result: #{result}"
end

process_pair(10, 5) { |x, y| x + y }
process_pair(10, 5) { |x, y| x * y }
process_pair(10, 5) { |x, y| x - y }
puts

# Section 3: Capturing Blocks as Procs
puts "3. Capturing Blocks with &"
puts "-" * 40

def execute_block(&block)
  puts "Block class: #{block.class}"
  puts "Calling block..."
  result = block.call("from method")
  puts "Block returned: #{result}"
end

execute_block { |msg| "Received: #{msg}" }
puts

# Section 4: Creating Procs
puts "4. Creating and Using Procs"
puts "-" * 40

# Different ways to create Procs
doubler = Proc.new { |x| x * 2 }
tripler = proc { |x| x * 3 }  # proc is alias for Proc.new

puts "doubler.call(5) = #{doubler.call(5)}"
puts "tripler.call(5) = #{tripler.call(5)}"

# Procs are lenient with arguments
lenient = Proc.new { |a, b, c| "a=#{a}, b=#{b}, c=#{c}" }
puts "\nLenient Proc:"
puts "  With 1 arg: #{lenient.call(1)}"
puts "  With 2 args: #{lenient.call(1, 2)}"
puts "  With 3 args: #{lenient.call(1, 2, 3)}"
puts "  With 4 args: #{lenient.call(1, 2, 3, 4)}"  # Extra ignored
puts

# Section 5: Lambda Creation
puts "5. Creating and Using Lambdas"
puts "-" * 40

# Two syntaxes for lambdas
multiply = lambda { |x, y| x * y }
divide = ->(x, y) { x / y }  # Stabby lambda syntax (preferred)

puts "multiply.call(3, 4) = #{multiply.call(3, 4)}"
puts "divide.call(20, 5) = #{divide.call(20, 5)}"

# Lambdas are strict with arguments
strict = lambda { |a, b| "a=#{a}, b=#{b}" }
puts "\nStrict Lambda:"
puts "  With 2 args: #{strict.call(1, 2)}"
# strict.call(1)  # This would raise ArgumentError!
puts "  Missing args would raise ArgumentError"
puts

# Section 6: Proc vs Lambda - Argument Handling
puts "6. Proc vs Lambda - Argument Handling"
puts "-" * 40

my_proc = Proc.new { |x, y| [x, y] }
my_lambda = lambda { |x, y| [x, y] }

puts "Proc with wrong args:"
puts "  my_proc.call(1) = #{my_proc.call(1).inspect}"  # [1, nil]

puts "\nLambda with wrong args:"
begin
  puts "  my_lambda.call(1) = #{my_lambda.call(1).inspect}"
rescue ArgumentError => e
  puts "  ArgumentError: #{e.message}"
end
puts

# Section 7: Proc vs Lambda - Return Behavior
puts "7. Proc vs Lambda - Return Behavior"
puts "-" * 40

def test_proc_return
  my_proc = Proc.new { return "returned from proc" }
  my_proc.call
  "after proc call"  # This never executes!
end

def test_lambda_return
  my_lambda = lambda { return "returned from lambda" }
  result = my_lambda.call
  "after lambda call: #{result}"
end

puts "Proc return: #{test_proc_return}"
puts "Lambda return: #{test_lambda_return}"
puts

# Section 8: Closures - Capturing Variables
puts "8. Closures - Capturing Variables"
puts "-" * 40

def make_counter(start = 0)
  count = start
  lambda { count += 1 }
end

counter1 = make_counter(0)
counter2 = make_counter(100)

puts "Counter 1:"
puts "  #{counter1.call}, #{counter1.call}, #{counter1.call}"

puts "Counter 2:"
puts "  #{counter2.call}, #{counter2.call}, #{counter2.call}"
puts

# Section 9: Closures with Multiple Variables
puts "9. Complex Closures"
puts "-" * 40

def make_account(initial_balance)
  balance = initial_balance

  {
    deposit: lambda { |amount| balance += amount },
    withdraw: lambda { |amount| balance -= amount },
    balance: lambda { balance }
  }
end

account = make_account(1000)
puts "Initial balance: $#{account[:balance].call}"
account[:deposit].call(500)
puts "After deposit $500: $#{account[:balance].call}"
account[:withdraw].call(200)
puts "After withdraw $200: $#{account[:balance].call}"
puts

# Section 10: Practical Example - Custom Iterator
puts "10. Custom Iterator with Blocks"
puts "-" * 40

class NumberRange
  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def each(&block)
    current = @start
    while current <= @finish
      block.call(current)
      current += 1
    end
  end

  def map(&block)
    results = []
    each { |n| results << block.call(n) }
    results
  end

  def select(&block)
    results = []
    each { |n| results << n if block.call(n) }
    results
  end
end

range = NumberRange.new(1, 10)

puts "Each:"
range.each { |n| puts "  #{n}" }

puts "\nMap (square each):"
squares = range.map { |n| n ** 2 }
puts "  #{squares.inspect}"

puts "\nSelect (even numbers):"
evens = range.select { |n| n.even? }
puts "  #{evens.inspect}"
puts

# Section 11: Event System with Callbacks
puts "11. Event System with Callbacks"
puts "-" * 40

class EventEmitter
  def initialize
    @listeners = Hash.new { |h, k| h[k] = [] }
  end

  def on(event, &handler)
    @listeners[event] << handler
  end

  def emit(event, *args)
    @listeners[event].each { |handler| handler.call(*args) }
  end
end

emitter = EventEmitter.new

emitter.on(:user_login) { |user| puts "  📧 Sending welcome email to #{user}" }
emitter.on(:user_login) { |user| puts "  📊 Logging user activity: #{user}" }
emitter.on(:user_login) { |user| puts "  🔔 Notifying admins about #{user}" }

puts "User 'Alice' logs in:"
emitter.emit(:user_login, "Alice")
puts

# Section 12: Lazy Evaluation
puts "12. Lazy Evaluation with Lambdas"
puts "-" * 40

def lazy(&computation)
  puts "  Creating lazy computation..."
  lambda { computation.call }
end

expensive = lazy do
  puts "  Expensive computation running..."
  sleep(0.5)
  42 * 42
end

puts "Lazy computation created (not executed yet)"
puts "Calling computation now:"
result = expensive.call
puts "Result: #{result}"
puts

# Section 13: Method Factories
puts "13. Method Factories"
puts "-" * 40

def make_adder(n)
  lambda { |x| x + n }
end

def make_multiplier(n)
  lambda { |x| x * n }
end

add_5 = make_adder(5)
add_10 = make_adder(10)
times_2 = make_multiplier(2)
times_3 = make_multiplier(3)

puts "add_5.call(100) = #{add_5.call(100)}"
puts "add_10.call(100) = #{add_10.call(100)}"
puts "times_2.call(50) = #{times_2.call(50)}"
puts "times_3.call(50) = #{times_3.call(50)}"
puts

# Section 14: Symbol to Proc Magic
puts "14. Symbol to Proc (&:method_name)"
puts "-" * 40

numbers = [1, 2, 3, 4, 5]
strings = ["hello", "world", "ruby"]

puts "numbers.map(&:to_s) = #{numbers.map(&:to_s).inspect}"
puts "strings.map(&:upcase) = #{strings.map(&:upcase).inspect}"
puts "strings.map(&:length) = #{strings.map(&:length).inspect}"

# This is equivalent to:
puts "\nEquivalent without & magic:"
puts "numbers.map { |n| n.to_s } = #{numbers.map { |n| n.to_s }.inspect}"
puts

# Section 15: Combining Blocks and Arguments
puts "15. Methods with Both Arguments and Blocks"
puts "-" * 40

def with_timing(label, &block)
  puts "Starting: #{label}"
  start = Time.now
  result = block.call
  elapsed = Time.now - start
  puts "Finished: #{label} (took #{elapsed.round(3)}s)"
  result
end

result = with_timing("computation") do
  sum = 0
  (1..1000).each { |n| sum += n }
  sum
end
puts "Result: #{result}"
puts

# Section 16: Proc Composition
puts "16. Composing Procs"
puts "-" * 40

add_one = ->(x) { x + 1 }
double = ->(x) { x * 2 }
square = ->(x) { x ** 2 }

# Compose manually
def compose(f, g)
  ->(x) { f.call(g.call(x)) }
end

add_one_then_double = compose(double, add_one)
puts "add_one_then_double.call(5) = #{add_one_then_double.call(5)}"  # (5+1)*2 = 12

double_then_square = compose(square, double)
puts "double_then_square.call(5) = #{double_then_square.call(5)}"    # (5*2)^2 = 100
puts

# Section 17: Partial Application
puts "17. Partial Application"
puts "-" * 40

def partial(fn, *args)
  lambda { |*rest| fn.call(*args, *rest) }
end

multiply = ->(x, y, z) { x * y * z }
double_and = partial(multiply, 2)
double_and_triple = partial(double_and, 3)

puts "multiply.call(2, 3, 4) = #{multiply.call(2, 3, 4)}"
puts "double_and.call(3, 4) = #{double_and.call(3, 4)}"
puts "double_and_triple.call(4) = #{double_and_triple.call(4)}"
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. Blocks are Ruby's primary iteration mechanism (vs Python's for loops)"
puts "2. Three types: Blocks (syntax), Procs (lenient), Lambdas (strict)"
puts "3. Procs return from method, Lambdas return to caller"
puts "4. Use &:symbol to convert symbols to procs (.map(&:to_s))"
puts "5. Closures capture variables from surrounding scope"
puts "6. block_given? checks if a block was passed"
puts "7. & converts between blocks and procs"
puts
