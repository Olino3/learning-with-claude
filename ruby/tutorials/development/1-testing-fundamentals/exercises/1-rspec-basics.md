# Exercise 1: RSpec Basics

Practice writing RSpec tests to build your testing muscle memory.

## 🎯 Objectives

- Write describe/context/it blocks
- Use RSpec matchers
- Implement before/after hooks
- Use let for test data
- Run and debug tests

## 📝 Part 1: Shopping Cart Tests

Create a `ShoppingCart` class with tests.

### Step 1: Create the test file

```bash
mkdir -p spec
touch spec/shopping_cart_spec.rb
```

### Step 2: Write the tests FIRST (TDD!)

```ruby
# spec/shopping_cart_spec.rb
require 'rspec'
require_relative '../lib/shopping_cart'

RSpec.describe ShoppingCart do
  describe '#initialize' do
    it 'starts with an empty items array' do
      cart = ShoppingCart.new
      expect(cart.items).to eq([])
    end

    it 'starts with zero total' do
      cart = ShoppingCart.new
      expect(cart.total).to eq(0)
    end
  end

  describe '#add_item' do
    let(:cart) { ShoppingCart.new }

    it 'adds an item to the cart' do
      cart.add_item('Apple', 1.50)
      expect(cart.items.length).to eq(1)
    end

    it 'stores item name and price' do
      cart.add_item('Apple', 1.50)
      expect(cart.items.first).to eq({ name: 'Apple', price: 1.50 })
    end

    it 'allows multiple items' do
      cart.add_item('Apple', 1.50)
      cart.add_item('Banana', 0.75)
      expect(cart.items.length).to eq(2)
    end
  end

  describe '#total' do
    let(:cart) { ShoppingCart.new }

    context 'with no items' do
      it 'returns zero' do
        expect(cart.total).to eq(0)
      end
    end

    context 'with one item' do
      before do
        cart.add_item('Apple', 1.50)
      end

      it 'returns the item price' do
        expect(cart.total).to eq(1.50)
      end
    end

    context 'with multiple items' do
      before do
        cart.add_item('Apple', 1.50)
        cart.add_item('Banana', 0.75)
        cart.add_item('Orange', 2.00)
      end

      it 'returns the sum of all prices' do
        expect(cart.total).to eq(4.25)
      end
    end
  end

  describe '#remove_item' do
    let(:cart) { ShoppingCart.new }

    before do
      cart.add_item('Apple', 1.50)
      cart.add_item('Banana', 0.75)
    end

    it 'removes an item by name' do
      cart.remove_item('Apple')
      expect(cart.items.length).to eq(1)
    end

    it 'updates the total' do
      cart.remove_item('Apple')
      expect(cart.total).to eq(0.75)
    end

    it 'returns nil if item not found' do
      result = cart.remove_item('NonExistent')
      expect(result).to be_nil
    end
  end

  describe '#clear' do
    let(:cart) { ShoppingCart.new }

    before do
      cart.add_item('Apple', 1.50)
      cart.add_item('Banana', 0.75)
    end

    it 'removes all items' do
      cart.clear
      expect(cart.items).to be_empty
    end

    it 'resets total to zero' do
      cart.clear
      expect(cart.total).to eq(0)
    end
  end
end
```

### Step 3: Run the tests (they should fail!)

```bash
docker exec ruby-scripts rspec spec/shopping_cart_spec.rb
```

### Step 4: Implement the ShoppingCart class

```ruby
# lib/shopping_cart.rb
class ShoppingCart
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(name, price)
    @items << { name: name, price: price }
  end

  def total
    @items.sum { |item| item[:price] }
  end

  def remove_item(name)
    @items.delete_if { |item| item[:name] == name }
  end

  def clear
    @items = []
  end
end
```

### Step 5: Run tests again (they should pass!)

```bash
docker exec ruby-scripts rspec spec/shopping_cart_spec.rb
```

## 📝 Part 2: User Authentication Tests

Practice with more complex scenarios.

```ruby
# spec/user_authenticator_spec.rb
require 'rspec'
require_relative '../lib/user_authenticator'

RSpec.describe UserAuthenticator do
  let(:authenticator) { UserAuthenticator.new }

  describe '#register' do
    it 'creates a new user with username and password' do
      user = authenticator.register('alice', 'password123')
      expect(user[:username]).to eq('alice')
    end

    it 'stores hashed password, not plain text' do
      user = authenticator.register('alice', 'password123')
      expect(user[:password_hash]).not_to eq('password123')
    end

    it 'raises error for duplicate username' do
      authenticator.register('alice', 'password123')
      expect {
        authenticator.register('alice', 'different_password')
      }.to raise_error(UserAuthenticator::DuplicateUserError)
    end

    it 'raises error for weak password (< 8 chars)' do
      expect {
        authenticator.register('alice', 'weak')
      }.to raise_error(UserAuthenticator::WeakPasswordError)
    end
  end

  describe '#authenticate' do
    before do
      authenticator.register('alice', 'password123')
    end

    context 'with valid credentials' do
      it 'returns true' do
        expect(authenticator.authenticate('alice', 'password123')).to be true
      end
    end

    context 'with invalid password' do
      it 'returns false' do
        expect(authenticator.authenticate('alice', 'wrong_password')).to be false
      end
    end

    context 'with non-existent username' do
      it 'returns false' do
        expect(authenticator.authenticate('bob', 'password123')).to be false
      end
    end
  end

  describe '#user_exists?' do
    before do
      authenticator.register('alice', 'password123')
    end

    it 'returns true for existing user' do
      expect(authenticator.user_exists?('alice')).to be true
    end

    it 'returns false for non-existent user' do
      expect(authenticator.user_exists?('bob')).to be false
    end
  end

  describe '#change_password' do
    before do
      authenticator.register('alice', 'old_password')
    end

    context 'with correct old password' do
      it 'changes the password' do
        authenticator.change_password('alice', 'old_password', 'new_password')
        expect(authenticator.authenticate('alice', 'new_password')).to be true
      end

      it 'invalidates old password' do
        authenticator.change_password('alice', 'old_password', 'new_password')
        expect(authenticator.authenticate('alice', 'old_password')).to be false
      end
    end

    context 'with incorrect old password' do
      it 'raises error' do
        expect {
          authenticator.change_password('alice', 'wrong_password', 'new_password')
        }.to raise_error(UserAuthenticator::InvalidCredentialsError)
      end
    end

    context 'with weak new password' do
      it 'raises error' do
        expect {
          authenticator.change_password('alice', 'old_password', 'weak')
        }.to raise_error(UserAuthenticator::WeakPasswordError)
      end
    end
  end
end
```

### Your Task: Implement UserAuthenticator

Create `lib/user_authenticator.rb` that makes all tests pass.

Hints:
- Store users in a hash: `@users = {}`
- Use `Digest::SHA256` for password hashing
- Define custom error classes
- Check password length before storing

## 📝 Part 3: Practice RSpec Matchers

Write tests using different matchers:

```ruby
# spec/matchers_practice_spec.rb
require 'rspec'

RSpec.describe 'RSpec Matchers Practice' do
  describe 'equality matchers' do
    it 'uses eq for value equality' do
      expect(5).to eq(5)
      expect('hello').to eq('hello')
    end

    it 'uses be for identity equality' do
      a = 'hello'
      b = a
      expect(a).to be(b)  # Same object
    end

    it 'uses eql for strict equality' do
      expect(5).to eql(5)
      expect('hello').to eql('hello')
    end
  end

  describe 'comparison matchers' do
    it 'compares numbers' do
      expect(10).to be > 5
      expect(10).to be >= 10
      expect(5).to be < 10
      expect(5).to be <= 5
    end

    it 'checks ranges' do
      expect(5).to be_between(1, 10).inclusive
      expect(5).to be_between(1, 10).exclusive  # Fails
    end
  end

  describe 'type/class matchers' do
    it 'checks types' do
      expect(5).to be_a(Integer)
      expect('hello').to be_an_instance_of(String)
      expect([1, 2, 3]).to respond_to(:each)
    end
  end

  describe 'truthiness matchers' do
    it 'checks truthiness' do
      expect(true).to be_truthy
      expect(false).to be_falsey
      expect(nil).to be_nil
      expect('').not_to be_nil
    end
  end

  describe 'collection matchers' do
    let(:array) { [1, 2, 3, 4, 5] }
    let(:hash) { { name: 'Alice', age: 30 } }

    it 'checks inclusion' do
      expect(array).to include(1, 3, 5)
      expect(hash).to include(name: 'Alice')
    end

    it 'checks emptiness' do
      expect([]).to be_empty
      expect(array).not_to be_empty
    end

    it 'checks exact contents' do
      expect(array).to contain_exactly(5, 4, 3, 2, 1)  # Order doesn't matter
    end

    it 'checks hash keys' do
      expect(hash).to have_key(:name)
      expect(hash).not_to have_key(:email)
    end
  end

  describe 'string matchers' do
    let(:text) { 'Hello, Ruby World!' }

    it 'matches patterns' do
      expect(text).to match(/Ruby/)
      expect(text).to match(/^Hello/)
    end

    it 'checks start and end' do
      expect(text).to start_with('Hello')
      expect(text).to end_with('World!')
    end
  end

  describe 'change matchers' do
    let(:counter) { { count: 0 } }

    it 'detects changes' do
      expect {
        counter[:count] += 1
      }.to change { counter[:count] }.by(1)
    end

    it 'detects changes from/to' do
      expect {
        counter[:count] = 5
      }.to change { counter[:count] }.from(0).to(5)
    end
  end

  describe 'exception matchers' do
    it 'expects errors' do
      expect { raise StandardError, 'Oops!' }.to raise_error(StandardError)
      expect { raise StandardError, 'Oops!' }.to raise_error('Oops!')
      expect { raise StandardError, 'Oops!' }.to raise_error(StandardError, 'Oops!')
    end

    it 'expects no errors' do
      expect { 1 + 1 }.not_to raise_error
    end
  end
end
```

Run this file to see all matchers in action:

```bash
docker exec ruby-scripts rspec spec/matchers_practice_spec.rb
```

## 🎯 Challenge: Build a Bank Account

Write tests FIRST for a `BankAccount` class that supports:

1. **Initialization**
   - Starts with zero balance
   - Can initialize with starting balance
   - Rejects negative starting balance

2. **Deposits**
   - Increases balance
   - Rejects negative amounts
   - Rejects zero amounts

3. **Withdrawals**
   - Decreases balance
   - Rejects withdrawal greater than balance
   - Rejects negative amounts

4. **Transfers**
   - Transfers money between accounts
   - Rejects transfer greater than balance
   - Updates both account balances

5. **History**
   - Records all transactions
   - Shows transaction type, amount, and timestamp

Then implement the class to make your tests pass!

## 🐍 Python Comparison

```python
# Python (pytest)
class TestShoppingCart:
    def test_starts_empty(self):
        cart = ShoppingCart()
        assert cart.items == []

    def test_add_item(self):
        cart = ShoppingCart()
        cart.add_item('Apple', 1.50)
        assert len(cart.items) == 1
```

```ruby
# Ruby (RSpec)
RSpec.describe ShoppingCart do
  it 'starts with empty items array' do
    cart = ShoppingCart.new
    expect(cart.items).to eq([])
  end

  it 'adds item to cart' do
    cart = ShoppingCart.new
    cart.add_item('Apple', 1.50)
    expect(cart.items.length).to eq(1)
  end
end
```

## ✅ Success Criteria

- [ ] All ShoppingCart tests pass
- [ ] UserAuthenticator tests pass
- [ ] Understand different RSpec matchers
- [ ] Can write tests before implementation
- [ ] Comfortable with describe/context/it structure
- [ ] Know when to use let vs before

## 📖 Additional Practice

Try writing tests for:
- A `TodoList` class
- A `PasswordValidator` class
- A `StringCalculator` that parses and evaluates expressions
- A `RomanNumeral` converter

---

**Need help?** Check the [RSpec documentation](https://rspec.info/) or review the tutorial!
