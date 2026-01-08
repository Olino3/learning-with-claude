# Exercise 3: TDD Kata - String Calculator

Practice Test-Driven Development by building a String Calculator using the Red-Green-Refactor cycle.

## 🎯 Objective

Build a `StringCalculator` class that parses and evaluates string expressions using strict TDD:
1. **RED**: Write a failing test
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Improve code while keeping tests green

## 📝 The Kata

### Step 1: Empty String

**RED - Write the test:**

```ruby
# spec/string_calculator_spec.rb
require 'rspec'
require_relative '../lib/string_calculator'

RSpec.describe StringCalculator do
  describe '#add' do
    it 'returns 0 for an empty string' do
      calc = StringCalculator.new
      expect(calc.add('')).to eq(0)
    end
  end
end
```

**Run:** `rspec spec/string_calculator_spec.rb` → Should FAIL

**GREEN - Write minimal code:**

```ruby
# lib/string_calculator.rb
class StringCalculator
  def add(numbers)
    0
  end
end
```

**Run:** `rspec` → Should PASS ✅

### Step 2: Single Number

**RED - Add test:**

```ruby
it 'returns the number for a single number' do
  calc = StringCalculator.new
  expect(calc.add('5')).to eq(5)
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
class StringCalculator
  def add(numbers)
    return 0 if numbers.empty?
    numbers.to_i
  end
end
```

**Run:** PASS ✅

### Step 3: Two Numbers

**RED - Add test:**

```ruby
it 'returns sum of two comma-separated numbers' do
  calc = StringCalculator.new
  expect(calc.add('1,2')).to eq(3)
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
class StringCalculator
  def add(numbers)
    return 0 if numbers.empty?

    nums = numbers.split(',').map(&:to_i)
    nums.sum
  end
end
```

**Run:** PASS ✅

**REFACTOR - Clean up:**

```ruby
class StringCalculator
  def add(numbers)
    return 0 if numbers.empty?
    parse_numbers(numbers).sum
  end

  private

  def parse_numbers(numbers)
    numbers.split(',').map(&:to_i)
  end
end
```

**Run:** Still PASS ✅

### Step 4: Multiple Numbers

**RED - Add test:**

```ruby
it 'handles any amount of numbers' do
  calc = StringCalculator.new
  expect(calc.add('1,2,3,4,5')).to eq(15)
end
```

**Run:** Already PASS! ✅ (Our implementation already handles this)

### Step 5: Newline Delimiter

**RED - Add test:**

```ruby
it 'handles newlines as delimiters' do
  calc = StringCalculator.new
  expect(calc.add("1\n2,3")).to eq(6)
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
def parse_numbers(numbers)
  numbers.split(/[,\n]/).map(&:to_i)
end
```

**Run:** PASS ✅

### Step 6: Custom Delimiters

**RED - Add test:**

```ruby
it 'supports custom delimiters' do
  calc = StringCalculator.new
  expect(calc.add("//;\n1;2")).to eq(3)
end

it 'supports different custom delimiters' do
  calc = StringCalculator.new
  expect(calc.add("//|\n1|2|3")).to eq(6)
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
class StringCalculator
  def add(numbers)
    return 0 if numbers.empty?

    delimiter, nums = extract_delimiter(numbers)
    parse_numbers(nums, delimiter).sum
  end

  private

  def extract_delimiter(numbers)
    if numbers.start_with?('//')
      delimiter = numbers[2]
      nums = numbers.split("\n", 2)[1]
      [delimiter, nums]
    else
      [',', numbers]
    end
  end

  def parse_numbers(numbers, delimiter)
    regex = Regexp.escape(delimiter)
    numbers.split(/[#{regex}\n]/).map(&:to_i)
  end
end
```

**Run:** PASS ✅

### Step 7: Negative Numbers

**RED - Add test:**

```ruby
it 'throws exception for negative numbers' do
  calc = StringCalculator.new
  expect { calc.add('-1,2,-3') }.to raise_error(
    StringCalculator::NegativeNumberError,
    'Negative numbers not allowed: -1, -3'
  )
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
class StringCalculator
  class NegativeNumberError < StandardError; end

  def add(numbers)
    return 0 if numbers.empty?

    delimiter, nums = extract_delimiter(numbers)
    parsed = parse_numbers(nums, delimiter)

    check_for_negatives(parsed)
    parsed.sum
  end

  private

  def check_for_negatives(numbers)
    negatives = numbers.select { |n| n < 0 }
    unless negatives.empty?
      raise NegativeNumberError,
            "Negative numbers not allowed: #{negatives.join(', ')}"
    end
  end

  # ... rest of the code
end
```

**Run:** PASS ✅

### Step 8: Ignore Numbers > 1000

**RED - Add test:**

```ruby
it 'ignores numbers greater than 1000' do
  calc = StringCalculator.new
  expect(calc.add('2,1001')).to eq(2)
  expect(calc.add('1000,1001,2')).to eq(1002)
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
def add(numbers)
  return 0 if numbers.empty?

  delimiter, nums = extract_delimiter(numbers)
  parsed = parse_numbers(nums, delimiter)

  check_for_negatives(parsed)
  parsed.select { |n| n <= 1000 }.sum
end
```

**Run:** PASS ✅

### Step 9: Multi-character Delimiters

**RED - Add test:**

```ruby
it 'supports multi-character delimiters' do
  calc = StringCalculator.new
  expect(calc.add("//[***]\n1***2***3")).to eq(6)
end
```

**Run:** FAIL ❌

**GREEN - Update code:**

```ruby
def extract_delimiter(numbers)
  if numbers.start_with?('//')
    if numbers[2] == '['
      # Multi-char delimiter: //[***]\n
      delimiter = numbers.match(/\[(.*?)\]/)[1]
      nums = numbers.split("\n", 2)[1]
      [delimiter, nums]
    else
      # Single-char delimiter: //;\n
      delimiter = numbers[2]
      nums = numbers.split("\n", 2)[1]
      [delimiter, nums]
    end
  else
    [',', numbers]
  end
end
```

**Run:** PASS ✅

### Step 10: Multiple Delimiters

**RED - Add test:**

```ruby
it 'supports multiple delimiters' do
  calc = StringCalculator.new
  expect(calc.add("//[*][%]\n1*2%3")).to eq(6)
end
```

**Run:** FAIL ❌

**GREEN - Final code:**

```ruby
class StringCalculator
  class NegativeNumberError < StandardError; end

  def add(numbers)
    return 0 if numbers.empty?

    delimiters, nums = extract_delimiters(numbers)
    parsed = parse_numbers(nums, delimiters)

    check_for_negatives(parsed)
    parsed.select { |n| n <= 1000 }.sum
  end

  private

  def extract_delimiters(numbers)
    if numbers.start_with?('//')
      if numbers[2] == '['
        # Multiple or multi-char delimiters: //[*][%]\n or //[***]\n
        delimiters = numbers.scan(/\[(.*?)\]/).flatten
        nums = numbers.split("\n", 2)[1]
        [delimiters, nums]
      else
        # Single-char delimiter: //;\n
        delimiter = numbers[2]
        nums = numbers.split("\n", 2)[1]
        [[delimiter], nums]
      end
    else
      [[','], numbers]
    end
  end

  def parse_numbers(numbers, delimiters)
    regex = delimiters.map { |d| Regexp.escape(d) }.join('|')
    numbers.split(/[#{regex}\n]/).map(&:to_i)
  end

  def check_for_negatives(numbers)
    negatives = numbers.select { |n| n < 0 }
    unless negatives.empty?
      raise NegativeNumberError,
            "Negative numbers not allowed: #{negatives.join(', ')}"
    end
  end
end
```

**Run:** PASS ✅

## 📝 Your Full Test Suite

```ruby
# spec/string_calculator_spec.rb
require 'rspec'
require_relative '../lib/string_calculator'

RSpec.describe StringCalculator do
  let(:calc) { StringCalculator.new }

  describe '#add' do
    context 'with empty string' do
      it 'returns 0' do
        expect(calc.add('')).to eq(0)
      end
    end

    context 'with single number' do
      it 'returns the number' do
        expect(calc.add('5')).to eq(5)
      end
    end

    context 'with two numbers' do
      it 'returns their sum' do
        expect(calc.add('1,2')).to eq(3)
      end
    end

    context 'with multiple numbers' do
      it 'returns sum of all numbers' do
        expect(calc.add('1,2,3,4,5')).to eq(15)
      end
    end

    context 'with newline delimiters' do
      it 'handles newlines as delimiters' do
        expect(calc.add("1\n2,3")).to eq(6)
      end
    end

    context 'with custom single-char delimiter' do
      it 'supports semicolon' do
        expect(calc.add("//;\n1;2")).to eq(3)
      end

      it 'supports pipe' do
        expect(calc.add("//|\n1|2|3")).to eq(6)
      end
    end

    context 'with negative numbers' do
      it 'raises error with negative numbers listed' do
        expect { calc.add('-1,2,-3') }.to raise_error(
          StringCalculator::NegativeNumberError,
          'Negative numbers not allowed: -1, -3'
        )
      end
    end

    context 'with numbers greater than 1000' do
      it 'ignores numbers > 1000' do
        expect(calc.add('2,1001')).to eq(2)
      end

      it 'includes 1000 but ignores 1001' do
        expect(calc.add('1000,1001,2')).to eq(1002)
      end
    end

    context 'with multi-character delimiters' do
      it 'supports delimiter in brackets' do
        expect(calc.add("//[***]\n1***2***3")).to eq(6)
      end
    end

    context 'with multiple delimiters' do
      it 'supports multiple single-char delimiters' do
        expect(calc.add("//[*][%]\n1*2%3")).to eq(6)
      end

      it 'supports multiple multi-char delimiters' do
        expect(calc.add("//[**][%%]\n1**2%%3")).to eq(6)
      end
    end
  end
end
```

## 🎯 Challenge: Extend the Calculator

Add these features using TDD:

1. **Subtraction**
   ```ruby
   calc.subtract('5,3') # => 2
   calc.subtract('10,3,2') # => 5
   ```

2. **Multiplication**
   ```ruby
   calc.multiply('2,3,4') # => 24
   ```

3. **Division**
   ```ruby
   calc.divide('100,5,2') # => 10
   # Handle division by zero
   ```

4. **Order of Operations**
   ```ruby
   calc.calculate('2+3*4') # => 14 (not 20)
   ```

5. **Parentheses**
   ```ruby
   calc.calculate('(2+3)*4') # => 20
   ```

## 🐍 Python TDD Comparison

```python
# Python TDD
class TestStringCalculator:
    def test_empty_string_returns_zero(self):
        calc = StringCalculator()
        assert calc.add('') == 0

    def test_single_number(self):
        calc = StringCalculator()
        assert calc.add('5') == 5
```

```ruby
# Ruby TDD
RSpec.describe StringCalculator do
  let(:calc) { StringCalculator.new }

  it 'returns 0 for empty string' do
    expect(calc.add('')).to eq(0)
  end

  it 'returns the number for single number' do
    expect(calc.add('5')).to eq(5)
  end
end
```

## 💡 TDD Principles Reinforced

1. **Red-Green-Refactor**: Always follow the cycle
2. **Smallest step**: Write minimal code to pass
3. **Test first**: Never write code without a failing test
4. **Refactor confidently**: Tests provide safety net
5. **Descriptive tests**: Tests document behavior
6. **One assertion per test**: Keep tests focused

## ✅ Success Criteria

- [ ] Implemented StringCalculator with TDD
- [ ] All 10 steps completed
- [ ] Followed Red-Green-Refactor for each step
- [ ] Tests are descriptive and organized
- [ ] Code is clean and refactored
- [ ] Comfortable with TDD workflow

## 📖 Additional Katas

Practice TDD with these classic katas:

1. **FizzBuzz**
   - Print numbers 1-100
   - "Fizz" for multiples of 3
   - "Buzz" for multiples of 5
   - "FizzBuzz" for multiples of both

2. **Bowling Game**
   - Score a 10-pin bowling game
   - Handle strikes and spares
   - Complex scoring rules

3. **Roman Numerals**
   - Convert integers to Roman numerals
   - Convert Roman numerals to integers
   - Handle subtractive notation

4. **Bank Account**
   - Deposit and withdraw
   - Check balance
   - Transaction history
   - Overdraft protection

5. **Gilded Rose**
   - Refactoring kata
   - Update quality of shop items
   - Complex business rules

## 🎓 What You Learned

- ✅ Test-Driven Development workflow
- ✅ Red-Green-Refactor cycle
- ✅ Writing tests before code
- ✅ Incremental development
- ✅ Refactoring with confidence
- ✅ Test organization and naming

---

**TDD transforms how you code!** Practice these katas regularly to build TDD instincts. 🥋
