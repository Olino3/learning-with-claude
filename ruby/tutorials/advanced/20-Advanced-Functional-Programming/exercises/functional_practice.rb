#!/usr/bin/env ruby
# Advanced Functional Programming Practice

puts "=" * 70
puts "ADVANCED FUNCTIONAL PROGRAMMING PRACTICE"
puts "=" * 70
puts

# Example 1: Currying Basics
puts "1. Currying Basics"
puts "-" * 70

add = ->(a, b, c) { a + b + c }
curried_add = add.curry

puts "Full application: #{curried_add.call(1, 2, 3)}"
puts "Partial: #{curried_add.call(1).call(2).call(3)}"

# URL builder with currying
build_url = ->(protocol, domain, path) { "#{protocol}://#{domain}#{path}" }
curried_url = build_url.curry

https = curried_url.call("https")
github = https.call("github.com")

puts github.call("/ruby/ruby")
puts github.call("/rails/rails")

puts

# Example 2: Method Objects
puts "2. Method Objects as First-Class Citizens"
puts "-" * 70

class Math
  def add(a, b) = a + b
  def multiply(a, b) = a * b
  def divide(a, b) = a / b.to_f
end

math = Math.new
operations = {
  add: math.method(:add),
  multiply: math.method(:multiply),
  divide: math.method(:divide)
}

operations.each do |name, op|
  puts "#{name}: #{op.call(10, 5)}"
end

puts

# Example 3: Function Composition
puts "3. Function Composition"
puts "-" * 70

double = ->(x) { x * 2 }
increment = ->(x) { x + 1 }
square = ->(x) { x ** 2 }

def compose(*fns)
  ->(x) { fns.reverse.reduce(x) { |acc, fn| fn.call(acc) } }
end

pipeline = compose(square, increment, double)
puts "compose(square, increment, double).call(3) = #{pipeline.call(3)}"

if RUBY_VERSION >= "2.6.0"
  pipeline2 = double >> increment >> square
  puts "double >> increment >> square = #{pipeline2.call(3)}"
end

puts

# Example 4: Lazy Evaluation
puts "4. Lazy Evaluation"
puts "-" * 70

# Efficient processing
numbers = (1..1_000_000).lazy
result = numbers
  .map { |n| n * 2 }
  .select { |n| n % 3 == 0 }
  .first(5)

puts "First 5 numbers (doubled) divisible by 3: #{result}"

# Infinite sequences
fibonacci = Enumerator.new do |y|
  a, b = 0, 1
  loop do
    y << a
    a, b = b, a + b
  end
end

puts "First 15 Fibonacci: #{fibonacci.lazy.first(15)}"
puts "First 10 even Fibonacci: #{fibonacci.lazy.select(&:even?).first(10)}"

puts

# Example 5: Immutable Data Structures
puts "5. Immutable Data Structures"
puts "-" * 70

person = { name: "Alice", age: 30 }.freeze
puts "Original: #{person}"

# Can't modify - create new instead
updated = person.merge(age: 31, city: "NYC")
puts "Updated: #{updated}"
puts "Original unchanged: #{person}"

# Immutable value object
class Point
  attr_reader :x, :y
  
  def initialize(x, y)
    @x, @y = x, y
    freeze
  end
  
  def move(dx, dy)
    Point.new(@x + dx, @y + dy)
  end
  
  def to_s = "(#{@x}, #{@y})"
end

p1 = Point.new(0, 0)
p2 = p1.move(5, 3)
p3 = p2.move(-2, 1)

puts "p1: #{p1}, p2: #{p2}, p3: #{p3}"

puts

# Example 6: Map-Filter-Reduce Pipeline
puts "6. Map-Filter-Reduce Pipeline"
puts "-" * 70

numbers = (1..20)
result = numbers
  .select(&:even?)
  .map { |n| n ** 2 }
  .reduce(0, :+)

puts "Sum of squares of even numbers (1-20): #{result}"

# With lazy for infinite
lazy_result = (1..Float::INFINITY).lazy
  .select(&:even?)
  .map { |n| n ** 2 }
  .first(5)
  .reduce(0, :+)

puts "Sum of first 5 even squares: #{lazy_result}"

puts

# Example 7: Curried Methods
puts "7. Curried Methods"
puts "-" * 70

def greet(greeting, title, name)
  "#{greeting}, #{title} #{name}!"
end

curried = method(:greet).to_proc.curry

hello = curried.call("Hello")
hello_mr = hello.call("Mr.")

puts hello_mr.call("Smith")
puts hello_mr.call("Jones")

goodbye_ms = curried.call("Goodbye").call("Ms.")
puts goodbye_ms.call("Alice")

puts

# Example 8: Higher-Order Functions
puts "8. Higher-Order Functions"
puts "-" * 70

def apply_twice(fn)
  ->(x) { fn.call(fn.call(x)) }
end

double = ->(x) { x * 2 }
quad = apply_twice(double)

puts "apply_twice(double).call(3) = #{quad.call(3)}"

increment = ->(x) { x + 1 }
add_two = apply_twice(increment)
puts "apply_twice(increment).call(5) = #{add_two.call(5)}"

puts

# Example 9: Partial Application
puts "9. Partial Application"
puts "-" * 70

multiply = ->(a, b, c) { a * b * c }
curried_multiply = multiply.curry

multiply_by_2 = curried_multiply.call(2)
multiply_by_2_and_3 = multiply_by_2.call(3)

puts "2 * 3 * 4 = #{multiply_by_2_and_3.call(4)}"
puts "2 * 3 * 5 = #{multiply_by_2_and_3.call(5)}"

puts

# Example 10: Lazy Chain Processing
puts "10. Lazy Chain Processing"
puts "-" * 70

# Process only what's needed
data = (1..1000).lazy
  .map { |n| n * 2 }
  .select { |n| n % 5 == 0 }
  .map { |n| n / 10 }
  .first(10)

puts "Lazy processing result: #{data}"

puts

# Example 11: Functional Memoization
puts "11. Functional Memoization"
puts "-" * 70

def memoize(fn)
  cache = {}
  ->(arg) { cache[arg] ||= fn.call(arg) }
end

factorial = ->(n) do
  return 1 if n <= 1
  n * factorial.call(n - 1)
end

memoized_factorial = memoize(factorial)

puts "factorial(10) = #{memoized_factorial.call(10)}"
puts "factorial(5) = #{memoized_factorial.call(5)}"  # Uses cache

puts

# Example 12: Functional Data Transformation
puts "12. Functional Data Transformation"
puts "-" * 70

users = [
  { name: "Alice", age: 30, active: true },
  { name: "Bob", age: 25, active: false },
  { name: "Charlie", age: 35, active: true },
  { name: "Diana", age: 28, active: true }
]

# Functional pipeline
active_user_names = users
  .select { |u| u[:active] }
  .map { |u| u[:name] }
  .sort

puts "Active users: #{active_user_names}"

average_age = users
  .map { |u| u[:age] }
  .reduce(0, :+) / users.size.to_f

puts "Average age: #{average_age.round(1)}"

puts

puts "=" * 70
puts "Practice complete! You've mastered functional programming!"
puts "=" * 70
