# Exercise 1: RuboCop Basics

Practice configuring and using RuboCop to enforce code quality standards.

## Objective

Learn to configure RuboCop, run it on code, auto-correct violations, and customize settings for your project.

## Setup

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop', '~> 1.50'
  gem 'rubocop-performance'
end
```

```bash
bundle install
rubocop --init
```

## Part 1: Finding and Fixing Violations

### Task 1.1: Analyze Messy Code

Given this code with multiple violations:

```ruby
# lib/user_manager.rb
class userManager
  def initialize(name,email,age)
    @name=name
    @email=email
    @age=age
  end

  def is_adult?
    if @age >= 18
      return true
    else
      return false
    end
  end

  def send_email(subject,body)
    return "Sending email to #{@email}: #{subject}"
  end

  def update_profile( name, email )
    @name=name unless name.nil?
    @email=email unless email.nil?
    return { :success => true, :message => "Profile updated" }
  end
end
```

**Tasks:**
1. Run RuboCop and identify all violations
2. Run `rubocop -a` to auto-fix safe violations
3. Manually fix remaining violations
4. Ensure all tests pass with 0 offenses

<details>
<summary>Solution</summary>

```ruby
# lib/user_manager.rb
class UserManager
  def initialize(name, email, age)
    @name = name
    @email = email
    @age = age
  end

  def adult?
    @age >= 18
  end

  def send_email(subject, body)
    "Sending email to #{@email}: #{subject}"
  end

  def update_profile(name, email)
    @name = name unless name.nil?
    @email = email unless email.nil?
    { success: true, message: 'Profile updated' }
  end
end
```

Violations fixed:
- Class name: `userManager` → `UserManager`
- Spacing around operators and parentheses
- Redundant `return` statements
- Predicate method naming: `is_adult?` → `adult?`
- Hash syntax: `=>` → `:`
- String quotes: double → single
</details>

## Part 2: Custom Configuration

### Task 2.1: Configure Line Length

Create a `.rubocop.yml` that:
- Sets max line length to 100
- Allows comments to exceed line length
- Excludes `db/` and `vendor/` directories

<details>
<summary>Solution</summary>

```yaml
# .rubocop.yml
AllCops:
  TargetRubyVersion: 3.2
  Exclude:
    - 'db/**/*'
    - 'vendor/**/*'

Layout/LineLength:
  Max: 100
  AllowedPatterns: ['^#']
```
</details>

### Task 2.2: Configure Metrics

Allow longer methods in test files:

```yaml
Metrics/MethodLength:
  Max: 15
  Exclude:
    - 'spec/**/*'

Metrics/BlockLength:
  Max: 25
  Exclude:
    - 'spec/**/*'
    - 'config/routes.rb'
```

## Part 3: Working with TODO File

### Task 3.1: Generate TODO for Legacy Code

Given a legacy project with 100+ violations:

```bash
# Generate TODO file
rubocop --auto-gen-config

# Verify it works
rubocop  # Should show 0 offenses
```

This creates `.rubocop_todo.yml` with all current violations.

### Task 3.2: Incremental Cleanup

Update `.rubocop.yml`:

```yaml
inherit_from:
  - .rubocop_todo.yml

AllCops:
  NewCops: enable
  TargetRubyVersion: 3.2

# Pick one cop to fix
Layout/TrailingWhitespace:
  Enabled: true
  Exclude: []  # Remove from TODO
```

Fix all trailing whitespace:
```bash
rubocop -a --only Layout/TrailingWhitespace
```

## Part 4: Real-World Scenario

### Task 4.1: Review This Pull Request

```ruby
# app/services/order_processor.rb
class OrderProcessor
  def initialize(order)
    @order=order
  end

  def process
    if valid?
      if payment_successful?
        @order.status='completed'
        send_confirmation_email
        update_inventory
        create_invoice
        return { success: true }
      else
        @order.status='failed'
        return { success: false, error: 'Payment failed' }
      end
    else
      return { success: false, error: 'Invalid order' }
    end
  end

  private

  def valid?
    @order.items.any? && @order.total > 0
  end

  def payment_successful?
    PaymentGateway.charge(@order.total)
  end

  def send_confirmation_email
    OrderMailer.confirmation(@order).deliver_now
  end

  def update_inventory
    @order.items.each{|item| item.decrement_stock}
  end

  def create_invoice
    Invoice.create(order: @order, total: @order.total)
  end
end
```

**Tasks:**
1. Run RuboCop and list all violations
2. Fix spacing and style issues
3. Reduce cyclomatic complexity of `process` method
4. Add proper error handling

<details>
<summary>Solution</summary>

```ruby
# app/services/order_processor.rb
class OrderProcessor
  def initialize(order)
    @order = order
  end

  def process
    return validation_error unless valid?
    return payment_error unless payment_successful?

    complete_order
    { success: true }
  end

  private

  def valid?
    @order.items.any? && @order.total.positive?
  end

  def payment_successful?
    PaymentGateway.charge(@order.total)
  end

  def complete_order
    @order.status = 'completed'
    send_confirmation_email
    update_inventory
    create_invoice
  end

  def validation_error
    { success: false, error: 'Invalid order' }
  end

  def payment_error
    @order.status = 'failed'
    { success: false, error: 'Payment failed' }
  end

  def send_confirmation_email
    OrderMailer.confirmation(@order).deliver_now
  end

  def update_inventory
    @order.items.each(&:decrement_stock)
  end

  def create_invoice
    Invoice.create(order: @order, total: @order.total)
  end
end
```

Improvements:
- Fixed spacing around `=`
- Reduced nesting with guard clauses
- Extracted error responses to methods
- Used `&:` shorthand for blocks
- Used `positive?` instead of `> 0`
- Removed redundant `return` statements
</details>

## Verification

Run these commands to verify your solutions:

```bash
# Check all files
rubocop

# Check specific file
rubocop lib/user_manager.rb

# Verify auto-correction
rubocop -a

# Final check
rubocop --display-cop-names
```

## Bonus Challenges

1. **Custom Excludes**: Exclude specific cops for `spec/` files
2. **Performance Cops**: Enable `rubocop-performance` and fix violations
3. **Parallel Execution**: Run RuboCop with `--parallel` flag
4. **Format Options**: Try different output formats (`--format json`, `--format html`)

## Key Learnings

- RuboCop finds style, layout, and complexity issues
- Auto-correction saves time but review changes
- Configuration allows team-specific preferences
- TODO files help manage technical debt
- Guard clauses reduce complexity
- Consistent style improves readability

## Next Steps

Move on to **[Exercise 2: Custom Cops](2-custom-cops.md)** to create your own linting rules!
