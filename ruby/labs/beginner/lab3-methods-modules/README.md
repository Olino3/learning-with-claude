# Lab 3: Methods & Modules

Build a calculator with utility modules to learn method design and code reusability.

## 🎯 Learning Objectives

- Method parameters: positional, keyword, default values
- Variable-length arguments (*args, **kwargs)
- Creating and including modules
- Module mixins vs class inheritance
- Method visibility (public, private, protected)
- Module composition patterns

## � Running the Lab

### Step-by-Step Learning (Recommended)

Follow the progressive steps in this README to build the calculator with modules incrementally.

**Estimated Time**: 2-3 hours

### Quick Start with Make

Run the complete solution:
```bash
make beginner-lab NUM=3
```

This runs `solution.rb` which demonstrates all module patterns.

### How to Practice

1. **Create your own file** (e.g., `my_calculator.rb`) in this directory
2. **Follow each step** to build the calculator and modules
3. **Test your code** with:
   ```bash
   make run-script SCRIPT=ruby/labs/beginner/lab3-methods-modules/my_calculator.rb
   ```
4. **Compare with** `solution.rb` for reference

---

## �📋 What You'll Build

A calculator system with:
- `Calculator` class with basic operations
- `Statistics` module for statistical functions
- `Formatter` module for output formatting
- `Logger` module for operation history

## 🚀 Progressive Steps

### Step 1: Basic Calculator with Method Parameters

```ruby
class Calculator
  attr_reader :name

  def initialize(name = "Calculator")
    @name = name
  end

  # Simple positional parameters
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  # Variable-length arguments
  def sum(*numbers)
    numbers.sum
  end

  # Method with default parameter
  def power(base, exponent = 2)
    base ** exponent
  end

  # Keyword arguments
  def divide(dividend:, divisor:, round_to: 2)
    result = dividend.to_f / divisor
    result.round(round_to)
  end
end
```

**Test it**:
```ruby
calc = Calculator.new("MyCalc")
puts calc.add(5, 3)           # => 8
puts calc.sum(1, 2, 3, 4, 5)  # => 15
puts calc.power(2, 3)         # => 8
puts calc.power(5)            # => 25 (uses default exponent=2)
puts calc.divide(dividend: 10, divisor: 3)  # => 3.33
```

---

### Step 2: Create the Statistics Module

```ruby
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
```

**Include in Calculator**:
```ruby
class Calculator
  include Statistics

  # ... previous methods ...
end
```

**Test it**:
```ruby
calc = Calculator.new
puts calc.mean(1, 2, 3, 4, 5)        # => 3.0
puts calc.median(1, 2, 3, 4, 5)      # => 3.0
puts calc.std_deviation(2, 4, 4, 4, 5, 5, 7, 9)  # => 2.0
```

---

### Step 3: Add Formatter Module

```ruby
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
```

---

### Step 4: Add Logger Module with Private Methods

```ruby
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

  private

  def log_if_enabled(operation, result)
    log_operation(operation, result) if @logging_enabled
  end
end
```

---

### Step 5: Enhanced Calculator with All Modules

```ruby
class EnhancedCalculator
  include Statistics
  include Formatter
  include Logger

  attr_accessor :logging_enabled

  def initialize(name = "Calculator")
    super()  # Calls Logger's initialize
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

  # Private helper method
  private

  def validate_non_zero(value)
    raise ArgumentError, "Cannot divide by zero" if value.zero?
  end
end
```

---

### Step 6: Method Visibility and Module Methods

```ruby
module MathHelpers
  # Module method (called on module itself)
  def self.factorial(n)
    return 1 if n <= 1
    (2..n).reduce(:*)
  end

  def self.fibonacci(n)
    return n if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end

  # Instance method (when included)
  def percentage_change(old_value, new_value)
    return 0 if old_value.zero?
    ((new_value - old_value).to_f / old_value * 100).round(2)
  end
end

class ScientificCalculator < EnhancedCalculator
  include MathHelpers

  def factorial(n)
    result = MathHelpers.factorial(n)
    log_operation("#{n}!", result)
    result
  end

  def combination(n, r)
    result = MathHelpers.factorial(n) / (MathHelpers.factorial(r) * MathHelpers.factorial(n - r))
    log_operation("C(#{n},#{r})", result)
    result
  end

  private

  def validate_positive(value)
    raise ArgumentError, "Value must be positive" if value < 0
  end
end
```

**Test it**:
```ruby
calc = ScientificCalculator.new("SciCalc")
puts calc.factorial(5)         # => 120
puts calc.combination(5, 2)    # => 10
puts calc.percentage_change(100, 150)  # => 50.0

# Call module method directly
puts MathHelpers.factorial(6)  # => 720

calc.show_history
```

---

## 🎯 Final Challenge

Create a complete system with:
1. A calculator with all operations
2. All three modules included
3. Logging enabled
4. Various calculations demonstrating all features
5. Display formatted history

**Solution**: See `solution.rb`

---

## ✅ Checklist

- [ ] Method parameters: positional, keyword, default
- [ ] Variable-length arguments: `*args`, `**kwargs`
- [ ] Creating modules with `module`
- [ ] Including modules with `include`
- [ ] Module methods with `self.method_name`
- [ ] Private vs public methods
- [ ] Method visibility keywords
- [ ] `super` to call parent methods
- [ ] Module composition patterns

---

## 🐍 Python Comparison

| Ruby | Python |
|------|--------|
| `def method(a, b = 5)` | `def method(a, b=5):` |
| `def method(*args)` | `def method(*args):` |
| `def method(**kwargs)` | `def method(**kwargs):` |
| `def method(name:, age:)` | `def method(*, name, age):` |
| `module MyModule` | No direct equivalent |
| `include MyModule` | Multiple inheritance |
| `private` | `_private` convention |
| `self.class_method` | `@classmethod` |

---

**Fantastic!** You've completed the beginner labs! Ready for intermediate challenges? → [Intermediate Labs](../../intermediate-lab/README.md)
