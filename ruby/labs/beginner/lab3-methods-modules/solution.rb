# Lab 3: Methods & Modules - Complete Solution

module Statistics
  def mean(*numbers)
    return 0 if numbers.empty?
    numbers.sum.to_f / numbers.length
  end

  def median(*numbers)
    return 0 if numbers.empty?
    sorted = numbers.sort
    mid = sorted.length / 2
    sorted.length.odd? ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2.0
  end

  def variance(*numbers)
    return 0 if numbers.empty?
    avg = mean(*numbers)
    sum_of_squares = numbers.sum { |n| (n - avg) ** 2 }
    sum_of_squares / numbers.length
  end

  def std_deviation(*numbers)
    Math.sqrt(variance(*numbers))
  end
end

module Formatter
  def format_result(operation, result, **options)
    precision = options[:precision] || 2
    formatted_value = result.is_a?(Float) ? result.round(precision) : result

    if options[:style] == :detailed
      "Operation: #{operation}\nResult: #{formatted_value}"
    else
      "#{operation} = #{formatted_value}"
    end
  end

  def format_array(numbers, separator: ", ")
    numbers.join(separator)
  end

  def format_percentage(value, total, decimals: 1)
    percentage = (value.to_f / total * 100).round(decimals)
    "#{percentage}%"
  end
end

module Logger
  def self.included(base)
    base.class_eval do
      attr_reader :history
    end
  end

  def initialize(*args)
    super(*args) if defined?(super)
    @history = []
  end

  def log_operation(operation, result)
    @history << { operation: operation, result: result, timestamp: Time.now }
  end

  def show_history(limit: 10)
    puts "\nCalculation History (last #{limit}):"
    @history.last(limit).each_with_index do |entry, index|
      time = entry[:timestamp].strftime("%H:%M:%S")
      puts "  #{index + 1}. [#{time}] #{entry[:operation]} = #{entry[:result]}"
    end
  end

  def clear_history
    count = @history.length
    @history.clear
    "Cleared #{count} history entries"
  end
end

module MathHelpers
  def self.factorial(n)
    return 1 if n <= 1
    (2..n).reduce(:*)
  end

  def self.fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end

  def percentage_change(old_value, new_value)
    return 0 if old_value.zero?
    ((new_value - old_value).to_f / old_value * 100).round(2)
  end
end

class EnhancedCalculator
  include Statistics
  include Formatter
  include Logger

  attr_accessor :logging_enabled
  attr_reader :name

  def initialize(name = "Calculator")
    super()
    @name = name
    @logging_enabled = true
  end

  def add(a, b, log: true)
    result = a + b
    log_operation("#{a} + #{b}", result) if log
    result
  end

  def subtract(a, b, log: true)
    result = a - b
    log_operation("#{a} - #{b}", result) if log
    result
  end

  def sum(*numbers, log: true)
    result = numbers.sum
    log_operation("sum(#{format_array(numbers)})", result) if log
    result
  end

  def calculate_average(*numbers, format: :simple)
    result = mean(*numbers)
    operation = "average(#{format_array(numbers)})"
    log_operation(operation, result)

    format_result(operation, result, precision: 2, style: format)
  end
end

class ScientificCalculator < EnhancedCalculator
  include MathHelpers

  def factorial(n)
    validate_non_negative(n)
    result = MathHelpers.factorial(n)
    log_operation("#{n}!", result)
    result
  end

  def combination(n, r)
    validate_non_negative(n)
    validate_non_negative(r)
    result = MathHelpers.factorial(n) / (MathHelpers.factorial(r) * MathHelpers.factorial(n - r))
    log_operation("C(#{n},#{r})", result)
    result
  end

  def fibonacci_sequence(count)
    sequence = (0...count).map { |n| MathHelpers.fibonacci(n) }
    log_operation("fibonacci(#{count})", sequence.inspect)
    sequence
  end

  private

  def validate_non_negative(value)
    raise ArgumentError, "Value must be non-negative" if value < 0
  end
end

# Main Program
puts "=" * 70
puts " " * 18 + "ENHANCED CALCULATOR DEMO"
puts "=" * 70

calc = ScientificCalculator.new("Scientific Calculator Pro")
puts "\nUsing: #{calc.name}"

# Basic operations
puts "\n--- Basic Operations ---"
puts "5 + 3 = #{calc.add(5, 3)}"
puts "10 - 4 = #{calc.subtract(10, 4)}"
puts "Sum of 1,2,3,4,5 = #{calc.sum(1, 2, 3, 4, 5)}"

# Statistical operations
puts "\n--- Statistical Operations ---"
data = [2, 4, 4, 4, 5, 5, 7, 9]
puts "Data: #{data.inspect}"
puts "Mean: #{calc.mean(*data)}"
puts "Median: #{calc.median(*data)}"
puts "Std Deviation: #{calc.std_deviation(*data).round(2)}"

# Scientific operations
puts "\n--- Scientific Operations ---"
puts "5! = #{calc.factorial(5)}"
puts "C(10, 3) = #{calc.combination(10, 3)}"
puts "Fibonacci(10): #{calc.fibonacci_sequence(10).join(', ')}"

# Percentage calculations
puts "\n--- Percentage Calculations ---"
puts "Change from 100 to 150: #{calc.percentage_change(100, 150)}%"
puts "Change from 200 to 150: #{calc.percentage_change(200, 150)}%"

# Formatted results
puts "\n--- Formatted Results ---"
puts calc.calculate_average(10, 20, 30, 40, 50)
puts calc.calculate_average(10, 20, 30, 40, 50, format: :detailed)

# Show history
puts "\n" + "=" * 70
puts " " * 25 + "HISTORY"
puts "=" * 70
calc.show_history

puts "\n" + "=" * 70
