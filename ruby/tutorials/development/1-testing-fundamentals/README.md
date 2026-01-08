# Tutorial 1: Testing Fundamentals - RSpec & Minitest

Welcome to the foundation of professional Ruby development: testing! In Ruby culture, you aren't "done" with a feature until it has passing tests. This tutorial covers both RSpec (the industry standard) and Minitest (built into Ruby).

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Test-Driven Development (TDD) workflow
- Write tests using RSpec's BDD-style syntax
- Use Minitest for unit testing
- Know when to choose RSpec vs Minitest
- Write effective assertions and expectations
- Organize test suites with describe/context blocks
- Use before/after hooks
- Understand test doubles and mocking basics

## 🐍➡️🔴 Coming from Python

If you're familiar with Python testing, here's how Ruby testing compares:

| Concept | Python | Ruby (RSpec) | Ruby (Minitest) |
|---------|--------|--------------|-----------------|
| Test framework | pytest, unittest | RSpec | Minitest |
| Test file naming | `test_*.py` | `*_spec.rb` | `test_*.rb` |
| Test organization | Classes/functions | describe/context/it | test methods |
| Assertions | `assert x == y` | `expect(x).to eq(y)` | `assert_equal y, x` |
| Setup/teardown | `setUp/tearDown` | `before/after` | `setup/teardown` |
| Fixtures | pytest fixtures | FactoryBot/fixtures | Fixtures |
| Mocking | unittest.mock | rspec-mocks | Minitest::Mock |
| Test runner | pytest, nose | rspec | rake test |

> **📘 Python Note:** RSpec is more like pytest (flexible, BDD-style) while Minitest is like unittest (minimal, xUnit-style).

## 📝 Why Testing Matters

```ruby
# Without tests: "It works on my machine" 🤷
def calculate_total(items)
  items.sum { |item| item[:price] * item[:quantity] }
end

# With tests: Confidence and documentation 🎉
RSpec.describe '#calculate_total' do
  it 'sums up item prices multiplied by quantities' do
    items = [
      { price: 10, quantity: 2 },
      { price: 5, quantity: 3 }
    ]
    expect(calculate_total(items)).to eq(35)
  end

  it 'returns 0 for empty items' do
    expect(calculate_total([])).to eq(0)
  end
end
```

### Benefits of Testing
1. **Confidence**: Refactor without fear
2. **Documentation**: Tests show how code should be used
3. **Design**: TDD drives better design
4. **Regression prevention**: Catch bugs before production
5. **Faster debugging**: Pinpoint failures quickly

## 📝 RSpec: The Ruby Standard

RSpec uses a Domain-Specific Language (DSL) for Behavior-Driven Development (BDD).

### Installing RSpec

```ruby
# Gemfile
gem 'rspec', '~> 3.13'

# Install
bundle install

# Initialize RSpec
rspec --init
```

This creates:
- `.rspec` - RSpec configuration
- `spec/spec_helper.rb` - Test setup

### Your First RSpec Test

```ruby
# spec/calculator_spec.rb
RSpec.describe Calculator do
  describe '#add' do
    it 'adds two numbers' do
      calculator = Calculator.new
      result = calculator.add(2, 3)
      expect(result).to eq(5)
    end

    it 'handles negative numbers' do
      calculator = Calculator.new
      expect(calculator.add(-1, -2)).to eq(-3)
    end
  end

  describe '#divide' do
    it 'divides two numbers' do
      calculator = Calculator.new
      expect(calculator.divide(10, 2)).to eq(5)
    end

    it 'raises error when dividing by zero' do
      calculator = Calculator.new
      expect { calculator.divide(10, 0) }.to raise_error(ZeroDivisionError)
    end
  end
end
```

### RSpec Structure

```ruby
RSpec.describe 'What you are testing' do
  # describe: groups related tests (usually a class or method)
  describe '#method_name' do
    # context: different scenarios
    context 'when condition is true' do
      # it: individual test case
      it 'does something specific' do
        # Arrange: set up test data
        user = User.new(name: 'Alice')

        # Act: perform the action
        result = user.greet

        # Assert: verify the result
        expect(result).to eq('Hello, Alice!')
      end
    end
  end
end
```

### RSpec Matchers

RSpec provides expressive matchers (like pytest assertions):

```ruby
# Equality
expect(value).to eq(5)              # ==
expect(value).to be(5)              # equal? (same object)
expect(value).to eql(5)             # eql? (same value and type)

# Comparison
expect(value).to be > 5
expect(value).to be <= 10
expect(value).to be_between(1, 10).inclusive

# Types and Classes
expect(value).to be_a(String)
expect(value).to be_an_instance_of(String)
expect(value).to respond_to(:upcase)

# Truthiness
expect(value).to be_truthy          # Not nil or false
expect(value).to be_falsey          # nil or false
expect(value).to be_nil

# Collections
expect(array).to include(1, 2, 3)
expect(array).to contain_exactly(1, 2, 3)  # Order doesn't matter
expect(hash).to have_key(:name)
expect(array).to be_empty

# Strings
expect(string).to match(/pattern/)
expect(string).to start_with('Hello')
expect(string).to end_with('world')

# Exceptions
expect { dangerous_method }.to raise_error(StandardError)
expect { safe_method }.not_to raise_error

# Changes
expect { user.save }.to change { User.count }.by(1)
expect { user.update(name: 'Bob') }.to change(user, :name).from('Alice').to('Bob')
```

> **📘 Python Note:** RSpec matchers are like pytest's `assert` with helpers, but more readable: `expect(x).to eq(y)` vs `assert x == y`.

### Before/After Hooks

```ruby
RSpec.describe User do
  # Run before each test
  before(:each) do
    @user = User.new(name: 'Alice')
  end

  # Run after each test
  after(:each) do
    @user = nil
  end

  # Run once before all tests
  before(:all) do
    @admin = User.create(name: 'Admin', role: :admin)
  end

  # Run once after all tests
  after(:all) do
    User.destroy_all
  end

  it 'has a name' do
    expect(@user.name).to eq('Alice')
  end
end
```

### Let and Let!

```ruby
RSpec.describe Order do
  # let: lazy evaluation (only runs when called)
  let(:user) { User.new(name: 'Alice') }
  let(:order) { Order.new(user: user) }

  # let!: eager evaluation (runs before each test)
  let!(:admin) { User.create(name: 'Admin', role: :admin) }

  it 'belongs to a user' do
    expect(order.user).to eq(user)
  end

  it 'can be accessed by admin' do
    expect(admin.can_access?(order)).to be true
  end
end
```

> **📘 Python Note:** `let` is like pytest fixtures - reusable test data that's created on demand.

### Shared Examples

```ruby
# spec/support/shared_examples/timestampable.rb
RSpec.shared_examples 'timestampable' do
  it 'has created_at timestamp' do
    expect(subject.created_at).to be_a(Time)
  end

  it 'has updated_at timestamp' do
    expect(subject.updated_at).to be_a(Time)
  end
end

# spec/models/user_spec.rb
RSpec.describe User do
  subject { User.create(name: 'Alice') }
  it_behaves_like 'timestampable'
end

# spec/models/post_spec.rb
RSpec.describe Post do
  subject { Post.create(title: 'Hello') }
  it_behaves_like 'timestampable'
end
```

## 📝 Minitest: Ruby's Built-in Testing

Minitest is Ruby's default testing library - lightweight, fast, and uses plain Ruby syntax.

### Your First Minitest Test

```ruby
# test/calculator_test.rb
require 'minitest/autorun'
require_relative '../lib/calculator'

class CalculatorTest < Minitest::Test
  def setup
    @calculator = Calculator.new
  end

  def test_add_two_numbers
    result = @calculator.add(2, 3)
    assert_equal 5, result
  end

  def test_add_negative_numbers
    result = @calculator.add(-1, -2)
    assert_equal(-3, result)
  end

  def test_divide_two_numbers
    result = @calculator.divide(10, 2)
    assert_equal 5, result
  end

  def test_divide_by_zero_raises_error
    assert_raises(ZeroDivisionError) do
      @calculator.divide(10, 0)
    end
  end
end
```

### Minitest Assertions

```ruby
# Equality
assert_equal expected, actual
refute_equal expected, actual

# Identity
assert_same expected, actual       # Same object
refute_same expected, actual

# Truthiness
assert value
refute value
assert_nil value
refute_nil value

# Collections
assert_includes collection, item
assert_empty collection
refute_empty collection

# Types
assert_instance_of Class, object
assert_kind_of Class, object       # Includes subclasses
assert_respond_to object, :method_name

# Strings/Patterns
assert_match /pattern/, string
refute_match /pattern/, string

# Exceptions
assert_raises(ExceptionClass) { code }
assert_silent { code }             # No output

# Custom messages
assert_equal 5, result, "Expected result to be 5"
```

### Minitest Spec Style

Minitest also supports RSpec-style syntax:

```ruby
require 'minitest/autorun'

describe Calculator do
  before do
    @calculator = Calculator.new
  end

  describe '#add' do
    it 'adds two numbers' do
      _(@calculator.add(2, 3)).must_equal 5
    end

    it 'handles negative numbers' do
      _(@calculator.add(-1, -2)).must_equal(-3)
    end
  end

  describe '#divide' do
    it 'divides two numbers' do
      _(@calculator.divide(10, 2)).must_equal 5
    end

    it 'raises error for division by zero' do
      _ { @calculator.divide(10, 0) }.must_raise ZeroDivisionError
    end
  end
end
```

## 📝 RSpec vs Minitest: When to Use What

### Choose RSpec When:
- ✅ Team prefers BDD-style tests
- ✅ Building large applications
- ✅ Need extensive mocking/stubbing
- ✅ Want rich matcher library
- ✅ Working with Rails (convention)

### Choose Minitest When:
- ✅ Prefer simple, fast tests
- ✅ Like plain Ruby syntax
- ✅ Building libraries or gems
- ✅ Want minimal dependencies
- ✅ Need fast test suite execution

> **📘 Python Note:** RSpec is more popular (like pytest) but Minitest is faster and simpler (like unittest).

## 📝 Test-Driven Development (TDD) Workflow

The Red-Green-Refactor cycle:

```ruby
# 1. RED: Write a failing test
RSpec.describe BankAccount do
  it 'starts with zero balance' do
    account = BankAccount.new
    expect(account.balance).to eq(0)
  end
end

# Run: rspec
# Error: uninitialized constant BankAccount

# 2. GREEN: Write minimum code to pass
class BankAccount
  attr_reader :balance

  def initialize
    @balance = 0
  end
end

# Run: rspec
# ✅ 1 example, 0 failures

# 3. REFACTOR: Improve the code
class BankAccount
  def initialize(starting_balance: 0)
    @balance = starting_balance
  end

  def balance
    @balance
  end
end

# Run: rspec
# ✅ Still passing!
```

### TDD Benefits for Python Developers

```python
# Python: You might write code first
def calculate_discount(price, discount_percentage):
    return price - (price * discount_percentage / 100)

# Then test it
def test_calculate_discount():
    assert calculate_discount(100, 10) == 90.0
```

```ruby
# Ruby TDD: Write test first
RSpec.describe '#calculate_discount' do
  it 'applies percentage discount to price' do
    expect(calculate_discount(100, 10)).to eq(90.0)
  end

  it 'handles zero discount' do
    expect(calculate_discount(100, 0)).to eq(100.0)
  end

  it 'handles full discount' do
    expect(calculate_discount(100, 100)).to eq(0.0)
  end
end

# Then implement
def calculate_discount(price, discount_percentage)
  price - (price * discount_percentage / 100.0)
end
```

## 📝 Test Organization

### RSpec File Structure

```
project/
├── lib/
│   ├── calculator.rb
│   └── user.rb
├── spec/
│   ├── spec_helper.rb
│   ├── calculator_spec.rb
│   ├── user_spec.rb
│   └── support/
│       └── shared_examples/
```

### Minitest File Structure

```
project/
├── lib/
│   ├── calculator.rb
│   └── user.rb
├── test/
│   ├── test_helper.rb
│   ├── calculator_test.rb
│   └── user_test.rb
```

## 📝 Testing Best Practices

### 1. Write Descriptive Test Names

```ruby
# Bad
it 'works' do
  expect(result).to be true
end

# Good
it 'authenticates user with valid credentials' do
  expect(user.authenticate('password123')).to be true
end
```

### 2. Test One Thing Per Test

```ruby
# Bad: Testing multiple things
it 'creates and saves user' do
  user = User.new(name: 'Alice')
  expect(user.name).to eq('Alice')
  expect(user.save).to be true
  expect(User.count).to eq(1)
end

# Good: Separate tests
it 'initializes with a name' do
  user = User.new(name: 'Alice')
  expect(user.name).to eq('Alice')
end

it 'saves to database' do
  user = User.new(name: 'Alice')
  expect { user.save }.to change { User.count }.by(1)
end
```

### 3. Use Contexts for Different Scenarios

```ruby
RSpec.describe User do
  describe '#can_vote?' do
    context 'when user is 18 or older' do
      it 'returns true' do
        user = User.new(age: 18)
        expect(user.can_vote?).to be true
      end
    end

    context 'when user is under 18' do
      it 'returns false' do
        user = User.new(age: 17)
        expect(user.can_vote?).to be false
      end
    end
  end
end
```

### 4. Keep Tests DRY (But Not Too DRY)

```ruby
# Good use of let
RSpec.describe Order do
  let(:user) { User.new(name: 'Alice') }
  let(:product) { Product.new(price: 100) }
  let(:order) { Order.new(user: user, product: product) }

  it 'calculates total' do
    expect(order.total).to eq(100)
  end

  it 'belongs to user' do
    expect(order.user).to eq(user)
  end
end
```

### 5. Test Edge Cases

```ruby
RSpec.describe '#divide' do
  it 'divides positive numbers' do
    expect(divide(10, 2)).to eq(5)
  end

  it 'handles division by zero' do
    expect { divide(10, 0) }.to raise_error(ZeroDivisionError)
  end

  it 'handles negative divisor' do
    expect(divide(10, -2)).to eq(-5)
  end

  it 'returns float for non-divisible numbers' do
    expect(divide(10, 3)).to be_within(0.01).of(3.33)
  end
end
```

## ✍️ Exercises

### Exercise 1: RSpec Basics
👉 **[RSpec Fundamentals](exercises/1-rspec-basics.md)**

Practice writing RSpec tests with:
- Basic expectations
- describe/context/it blocks
- before/after hooks
- let and subject

### Exercise 2: Minitest Basics
👉 **[Minitest Fundamentals](exercises/2-minitest-basics.md)**

Practice writing Minitest tests with:
- Basic assertions
- setup/teardown
- Test organization
- Custom assertions

### Exercise 3: TDD Practice
👉 **[TDD Kata](exercises/3-tdd-kata.md)**

Build a String Calculator using TDD:
- Write tests first
- Implement incrementally
- Refactor with confidence

## 📚 What You Learned

✅ Test-Driven Development (TDD) workflow
✅ RSpec's BDD-style testing
✅ Minitest's xUnit-style testing
✅ Writing effective assertions
✅ Test organization with describe/context
✅ Using hooks and shared examples
✅ When to choose RSpec vs Minitest
✅ Testing best practices

## 🔜 Next Steps

**Next: [Tutorial 2: Advanced Testing (FactoryBot & Capybara)](../2-advanced-testing/README.md)**

Learn to:
- Generate test data with FactoryBot
- Simulate user interactions with Capybara
- Write integration and feature tests
- Mock external dependencies

## 💡 Key Takeaways for Python Developers

1. **RSpec vs pytest**: Both use expressive assertions and fixtures
2. **Minitest vs unittest**: Both use xUnit-style with setup/teardown
3. **TDD is cultural**: Ruby community emphasizes TDD more than Python
4. **describe/context**: Like nested test classes in Python
5. **let/let!**: Like pytest fixtures with lazy/eager loading
6. **Matchers**: More readable than plain assertions
7. **Test files**: `*_spec.rb` for RSpec, `test_*.rb` for Minitest

## 🆘 Common Pitfalls

### Pitfall 1: Not Testing Edge Cases
```ruby
# Bad: Only happy path
it 'processes payment' do
  expect(process_payment(100)).to be true
end

# Good: Test edge cases
it 'rejects negative amounts' do
  expect { process_payment(-100) }.to raise_error(ArgumentError)
end

it 'handles zero amount' do
  expect(process_payment(0)).to be false
end
```

### Pitfall 2: Testing Implementation Details
```ruby
# Bad: Testing private methods
it 'calls private method' do
  expect(user).to receive(:generate_token)
  user.sign_in
end

# Good: Test public behavior
it 'generates authentication token on sign in' do
  user.sign_in
  expect(user.auth_token).to be_present
end
```

### Pitfall 3: Brittle Tests
```ruby
# Bad: Too specific
it 'returns welcome message' do
  expect(user.greeting).to eq("Hello, Alice! Welcome to our app!")
end

# Good: Test essence
it 'includes user name in greeting' do
  expect(user.greeting).to include('Alice')
end
```

## 📖 Additional Resources

- [RSpec Documentation](https://rspec.info/)
- [Better Specs](https://www.betterspecs.org/)
- [Minitest Quick Reference](https://github.com/minitest/minitest#readme)
- [Effective Testing with RSpec 3](https://pragprog.com/titles/rspec3/)
- [The RSpec Book](https://pragprog.com/titles/achbd/the-rspec-book/)

---

Ready to write your first tests? Start with **[Exercise 1: RSpec Basics](exercises/1-rspec-basics.md)**! 🚀
