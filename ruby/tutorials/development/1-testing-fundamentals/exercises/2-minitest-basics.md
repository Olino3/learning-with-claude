# Exercise 2: Minitest Basics

Practice writing Minitest tests using Ruby's built-in testing framework.

## 🎯 Objectives

- Write test classes and methods
- Use Minitest assertions
- Implement setup/teardown
- Run tests with rake
- Understand Minitest spec style

## 📝 Part 1: Calculator Tests

Create a `Calculator` class with Minitest tests.

### Step 1: Create the test file

```bash
mkdir -p test
touch test/calculator_test.rb
```

### Step 2: Write the tests FIRST

```ruby
# test/calculator_test.rb
require 'minitest/autorun'
require_relative '../lib/calculator'

class CalculatorTest < Minitest::Test
  def setup
    @calc = Calculator.new
  end

  def test_add_two_positive_numbers
    result = @calc.add(2, 3)
    assert_equal 5, result
  end

  def test_add_negative_numbers
    result = @calc.add(-5, -3)
    assert_equal(-8, result)
  end

  def test_add_positive_and_negative
    result = @calc.add(10, -3)
    assert_equal 7, result
  end

  def test_subtract_two_numbers
    result = @calc.subtract(10, 3)
    assert_equal 7, result
  end

  def test_subtract_negative_result
    result = @calc.subtract(3, 10)
    assert_equal(-7, result)
  end

  def test_multiply_two_numbers
    result = @calc.multiply(4, 5)
    assert_equal 20, result
  end

  def test_multiply_by_zero
    result = @calc.multiply(5, 0)
    assert_equal 0, result
  end

  def test_multiply_negative_numbers
    result = @calc.multiply(-3, -4)
    assert_equal 12, result
  end

  def test_divide_two_numbers
    result = @calc.divide(10, 2)
    assert_equal 5, result
  end

  def test_divide_with_remainder
    result = @calc.divide(10, 3)
    assert_in_delta 3.33, result, 0.01
  end

  def test_divide_by_zero_raises_error
    assert_raises(ZeroDivisionError) do
      @calc.divide(10, 0)
    end
  end

  def test_power_raises_to_power
    result = @calc.power(2, 3)
    assert_equal 8, result
  end

  def test_power_zero_exponent
    result = @calc.power(5, 0)
    assert_equal 1, result
  end

  def test_square_root
    result = @calc.sqrt(16)
    assert_equal 4, result
  end

  def test_square_root_negative_raises_error
    assert_raises(ArgumentError) do
      @calc.sqrt(-1)
    end
  end
end
```

### Step 3: Implement the Calculator

```ruby
# lib/calculator.rb
class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  def divide(a, b)
    raise ZeroDivisionError, "Cannot divide by zero" if b == 0
    a / b.to_f
  end

  def power(base, exponent)
    base ** exponent
  end

  def sqrt(number)
    raise ArgumentError, "Cannot calculate square root of negative number" if number < 0
    Math.sqrt(number)
  end
end
```

### Step 4: Run the tests

```bash
docker exec ruby-scripts ruby test/calculator_test.rb
# or
docker exec ruby-scripts rake test
```

## 📝 Part 2: Array Utilities Tests

Practice with more Minitest assertions.

```ruby
# test/array_utils_test.rb
require 'minitest/autorun'
require_relative '../lib/array_utils'

class ArrayUtilsTest < Minitest::Test
  def setup
    @utils = ArrayUtils.new
  end

  def teardown
    @utils = nil
  end

  # Sum tests
  def test_sum_empty_array
    result = @utils.sum([])
    assert_equal 0, result
  end

  def test_sum_single_element
    result = @utils.sum([5])
    assert_equal 5, result
  end

  def test_sum_multiple_elements
    result = @utils.sum([1, 2, 3, 4, 5])
    assert_equal 15, result
  end

  # Average tests
  def test_average_empty_array_returns_nil
    result = @utils.average([])
    assert_nil result
  end

  def test_average_calculates_correctly
    result = @utils.average([2, 4, 6, 8, 10])
    assert_equal 6, result
  end

  def test_average_with_floats
    result = @utils.average([1.5, 2.5, 3.5])
    assert_in_delta 2.5, result, 0.01
  end

  # Max tests
  def test_max_returns_largest
    result = @utils.max([1, 5, 3, 9, 2])
    assert_equal 9, result
  end

  def test_max_with_negatives
    result = @utils.max([-5, -2, -10, -1])
    assert_equal(-1, result)
  end

  def test_max_empty_array_returns_nil
    result = @utils.max([])
    assert_nil result
  end

  # Min tests
  def test_min_returns_smallest
    result = @utils.min([5, 2, 8, 1, 9])
    assert_equal 1, result
  end

  # Contains tests
  def test_contains_returns_true_when_present
    result = @utils.contains?([1, 2, 3, 4, 5], 3)
    assert result
  end

  def test_contains_returns_false_when_absent
    result = @utils.contains?([1, 2, 3, 4, 5], 10)
    refute result
  end

  # Remove duplicates tests
  def test_remove_duplicates
    result = @utils.remove_duplicates([1, 2, 2, 3, 3, 3, 4])
    assert_equal [1, 2, 3, 4], result
  end

  def test_remove_duplicates_preserves_order
    result = @utils.remove_duplicates([3, 1, 2, 1, 3])
    assert_equal [3, 1, 2], result
  end

  # Reverse tests
  def test_reverse_array
    result = @utils.reverse([1, 2, 3, 4, 5])
    assert_equal [5, 4, 3, 2, 1], result
  end

  def test_reverse_empty_array
    result = @utils.reverse([])
    assert_empty result
  end

  # Type checking tests
  def test_all_integers
    result = @utils.all_integers?([1, 2, 3, 4])
    assert result
  end

  def test_not_all_integers
    result = @utils.all_integers?([1, 2, '3', 4])
    refute result
  end

  # Chunk tests
  def test_chunk_array
    result = @utils.chunk([1, 2, 3, 4, 5, 6], 2)
    assert_equal [[1, 2], [3, 4], [5, 6]], result
  end

  def test_chunk_with_remainder
    result = @utils.chunk([1, 2, 3, 4, 5], 2)
    assert_equal [[1, 2], [3, 4], [5]], result
  end
end
```

### Your Task: Implement ArrayUtils

Create `lib/array_utils.rb` that makes all tests pass.

## 📝 Part 3: Minitest Spec Style

Try the RSpec-like syntax with Minitest::Spec:

```ruby
# test/stack_spec.rb
require 'minitest/autorun'

describe Stack do
  before do
    @stack = Stack.new
  end

  describe 'when new' do
    it 'must be empty' do
      _(@stack.empty?).must_equal true
    end

    it 'must have size zero' do
      _(@stack.size).must_equal 0
    end
  end

  describe 'when pushing items' do
    it 'adds item to stack' do
      @stack.push(1)
      _(@stack.size).must_equal 1
    end

    it 'returns the pushed item' do
      result = @stack.push(5)
      _(result).must_equal 5
    end

    it 'makes stack not empty' do
      @stack.push(1)
      _(@stack.empty?).must_equal false
    end
  end

  describe 'when popping items' do
    before do
      @stack.push(1)
      @stack.push(2)
      @stack.push(3)
    end

    it 'removes and returns last item' do
      result = @stack.pop
      _(result).must_equal 3
    end

    it 'decreases size' do
      @stack.pop
      _(@stack.size).must_equal 2
    end

    it 'returns items in LIFO order' do
      _(@stack.pop).must_equal 3
      _(@stack.pop).must_equal 2
      _(@stack.pop).must_equal 1
    end

    it 'returns nil when empty' do
      3.times { @stack.pop }
      _(@stack.pop).must_be_nil
    end
  end

  describe 'when peeking' do
    before do
      @stack.push(1)
      @stack.push(2)
    end

    it 'returns top item without removing' do
      result = @stack.peek
      _(result).must_equal 2
      _(@stack.size).must_equal 2
    end

    it 'returns nil when empty' do
      empty_stack = Stack.new
      _(empty_stack.peek).must_be_nil
    end
  end

  describe 'when clearing' do
    before do
      @stack.push(1)
      @stack.push(2)
      @stack.push(3)
    end

    it 'removes all items' do
      @stack.clear
      _(@stack.empty?).must_equal true
    end

    it 'resets size to zero' do
      @stack.clear
      _(@stack.size).must_equal 0
    end
  end
end
```

### Your Task: Implement Stack

Create `lib/stack.rb` with a LIFO stack implementation.

## 📝 Part 4: Custom Assertions

Create reusable custom assertions:

```ruby
# test/test_helper.rb
require 'minitest/autorun'

module CustomAssertions
  def assert_valid_email(email)
    assert_match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, email,
                 "Expected #{email} to be a valid email address")
  end

  def assert_sorted(array, order: :asc)
    sorted = order == :asc ? array.sort : array.sort.reverse
    assert_equal sorted, array, "Expected array to be sorted in #{order} order"
  end

  def assert_includes_keys(hash, *keys)
    keys.each do |key|
      assert_includes hash.keys, key, "Expected hash to have key: #{key}"
    end
  end

  def assert_positive(number)
    assert number > 0, "Expected #{number} to be positive"
  end

  def assert_even(number)
    assert number.even?, "Expected #{number} to be even"
  end
end

class Minitest::Test
  include CustomAssertions
end
```

Use custom assertions:

```ruby
# test/custom_assertions_test.rb
require_relative 'test_helper'

class CustomAssertionsTest < Minitest::Test
  def test_valid_email
    assert_valid_email 'user@example.com'
  end

  def test_invalid_email
    assert_raises(Minitest::Assertion) do
      assert_valid_email 'not-an-email'
    end
  end

  def test_array_is_sorted
    assert_sorted [1, 2, 3, 4, 5]
  end

  def test_array_is_sorted_descending
    assert_sorted [5, 4, 3, 2, 1], order: :desc
  end

  def test_hash_includes_keys
    hash = { name: 'Alice', age: 30, email: 'alice@example.com' }
    assert_includes_keys hash, :name, :email
  end

  def test_number_is_positive
    assert_positive 42
  end

  def test_number_is_even
    assert_even 4
  end
end
```

## 🎯 Challenge: Build a Queue

Write tests for a `Queue` class that supports:

1. **Initialization**
   - Starts empty
   - Can initialize with items

2. **Enqueue**
   - Adds items to rear
   - Increases size
   - Returns enqueued item

3. **Dequeue**
   - Removes items from front (FIFO)
   - Decreases size
   - Returns nil when empty

4. **Peek**
   - Returns front item without removing
   - Returns nil when empty

5. **Contains**
   - Checks if item exists in queue

Implement both:
- Traditional Minitest style (`CalculatorTest < Minitest::Test`)
- Spec style (`describe Queue do`)

## 🐍 Python Comparison

```python
# Python (unittest)
import unittest

class TestCalculator(unittest.TestCase):
    def setUp(self):
        self.calc = Calculator()

    def test_add(self):
        result = self.calc.add(2, 3)
        self.assertEqual(result, 5)

    def tearDown(self):
        self.calc = None
```

```ruby
# Ruby (Minitest)
class CalculatorTest < Minitest::Test
  def setup
    @calc = Calculator.new
  end

  def test_add
    result = @calc.add(2, 3)
    assert_equal 5, result
  end

  def teardown
    @calc = nil
  end
end
```

## 📊 Minitest Assertion Reference

| Assertion | Description | Example |
|-----------|-------------|---------|
| `assert` | Value is truthy | `assert value` |
| `refute` | Value is falsey | `refute value` |
| `assert_equal` | Values are equal | `assert_equal 5, result` |
| `refute_equal` | Values are not equal | `refute_equal 5, result` |
| `assert_nil` | Value is nil | `assert_nil value` |
| `refute_nil` | Value is not nil | `refute_nil value` |
| `assert_empty` | Collection is empty | `assert_empty array` |
| `refute_empty` | Collection not empty | `refute_empty array` |
| `assert_includes` | Collection includes item | `assert_includes array, 5` |
| `assert_instance_of` | Object is exact type | `assert_instance_of String, obj` |
| `assert_kind_of` | Object is type or subclass | `assert_kind_of Numeric, obj` |
| `assert_match` | String matches regex | `assert_match /hello/, str` |
| `assert_raises` | Block raises exception | `assert_raises(Error) { code }` |
| `assert_silent` | Block produces no output | `assert_silent { code }` |
| `assert_in_delta` | Float within tolerance | `assert_in_delta 3.14, pi, 0.01` |

## ✅ Success Criteria

- [ ] Calculator tests pass
- [ ] ArrayUtils tests pass
- [ ] Stack tests pass (spec style)
- [ ] Created custom assertions
- [ ] Understand setup/teardown lifecycle
- [ ] Comfortable with both test styles

## 📖 Additional Practice

Implement with Minitest:
- `LinkedList` class
- `HashTable` class
- `EmailValidator` class
- `DateParser` class

---

**Minitest is fast and simple!** Run your tests with:
```bash
ruby test/your_test.rb
# or
rake test
```
