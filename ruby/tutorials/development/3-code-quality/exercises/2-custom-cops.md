# Exercise 2: Writing Custom Cops

Learn to create custom RuboCop cops to enforce team-specific conventions and catch project-specific anti-patterns.

## Objective

Build custom cops that detect violations, report them, and optionally auto-correct them.

## Setup

```ruby
# lib/rubocop/cop/custom/base.rb
module RuboCop
  module Cop
    module Custom
    end
  end
end
```

```yaml
# .rubocop.yml
require:
  - ./lib/rubocop/cop/custom/no_debug_statements
  - ./lib/rubocop/cop/custom/prefer_service_objects
  - ./lib/rubocop/cop/custom/no_direct_model_usage

Custom/NoDebugStatements:
  Enabled: true

Custom/PreferServiceObjects:
  Enabled: true

Custom/NoDirectModelUsage:
  Enabled: true
```

## Part 1: Simple Detection Cop

### Task 1.1: No Debug Statements in Production

Create a cop that prevents debug statements from being committed.

```ruby
# lib/rubocop/cop/custom/no_debug_statements.rb
module RuboCop
  module Cop
    module Custom
      class NoDebugStatements < Base
        MSG = 'Remove debug statement before committing.'
        DEBUG_METHODS = %i[puts p pp].freeze

        # TODO: Implement the cop
        # Detect calls to puts, p, pp
        # Add offense when found
      end
    end
  end
end
```

**Test cases:**

```ruby
# Bad - should be flagged
def calculate_total(items)
  puts "Calculating total..."  # Offense
  total = items.sum(&:price)
  p total  # Offense
  total
end

# Good - should not be flagged
def calculate_total(items)
  items.sum(&:price)
end
```

<details>
<summary>Solution</summary>

```ruby
# lib/rubocop/cop/custom/no_debug_statements.rb
module RuboCop
  module Cop
    module Custom
      class NoDebugStatements < Base
        MSG = 'Remove debug statement before committing.'
        DEBUG_METHODS = %i[puts p pp].freeze

        def on_send(node)
          return unless DEBUG_METHODS.include?(node.method_name)
          return if in_spec_file?

          add_offense(node)
        end

        private

        def in_spec_file?
          processed_source.file_path.include?('/spec/')
        end
      end
    end
  end
end
```
</details>

### Task 1.2: Test Your Cop

```ruby
# spec/lib/rubocop/cop/custom/no_debug_statements_spec.rb
require 'spec_helper'
require 'rubocop'
require 'rubocop/rspec/support'
require_relative '../../../../lib/rubocop/cop/custom/no_debug_statements'

RSpec.describe RuboCop::Cop::Custom::NoDebugStatements do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }

  it 'registers an offense for puts' do
    expect_offense(<<~RUBY)
      def hello
        puts "Debug"
        ^^^^^^^^^^^^ Remove debug statement before committing.
      end
    RUBY
  end

  it 'registers an offense for p' do
    expect_offense(<<~RUBY)
      p "Debug"
      ^^^^^^^^^ Remove debug statement before committing.
    RUBY
  end

  it 'does not register offense in spec files' do
    # Implement test
  end
end
```

## Part 2: Auto-Correcting Cop

### Task 2.1: Prefer Modern Hash Syntax

Create a cop that auto-corrects old hash rocket syntax to modern syntax.

```ruby
# lib/rubocop/cop/custom/modern_hash_syntax.rb
module RuboCop
  module Cop
    module Custom
      class ModernHashSyntax < Base
        extend AutoCorrector

        MSG = 'Use modern hash syntax.'

        # TODO: Implement
        # Detect: { :key => value }
        # Suggest: { key: value }
        # Auto-correct to modern syntax
      end
    end
  end
end
```

**Test cases:**

```ruby
# Bad
user = { :name => 'Alice', :age => 30 }

# Good
user = { name: 'Alice', age: 30 }
```

<details>
<summary>Solution</summary>

```ruby
# lib/rubocop/cop/custom/modern_hash_syntax.rb
module RuboCop
  module Cop
    module Custom
      class ModernHashSyntax < Base
        extend AutoCorrector

        MSG = 'Use modern hash syntax (key: value).'

        def on_hash(node)
          node.pairs.each do |pair|
            next unless old_syntax?(pair)

            add_offense(pair) do |corrector|
              autocorrect(corrector, pair)
            end
          end
        end

        private

        def old_syntax?(pair)
          pair.hash_rocket? && pair.key.sym_type?
        end

        def autocorrect(corrector, pair)
          key = pair.key.source[1..-1]  # Remove leading :
          value = pair.value.source

          corrector.replace(pair, "#{key}: #{value}")
        end
      end
    end
  end
end
```
</details>

## Part 3: Complex Business Logic Cop

### Task 3.1: Prefer Service Objects for Complex Controllers

Create a cop that detects controllers with complex logic that should be extracted to service objects.

```ruby
# lib/rubocop/cop/custom/prefer_service_objects.rb
module RuboCop
  module Cop
    module Custom
      class PreferServiceObjects < Base
        MSG = 'Extract complex business logic to a service object.'

        # TODO: Implement
        # Detect controller actions with:
        # - More than 10 lines
        # - Multiple database queries
        # - Complex conditionals
      end
    end
  end
end
```

**Test case:**

```ruby
# Bad - too complex for controller
class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.valid?
      @order.calculate_tax
      @order.calculate_shipping
      @order.apply_discounts

      if @order.save
        PaymentProcessor.charge(@order.total)
        OrderMailer.confirmation(@order).deliver_later
        InventoryService.update_stock(@order.items)
        redirect_to @order
      else
        render :new
      end
    else
      render :new
    end
  end
end

# Good - extracted to service
class OrdersController < ApplicationController
  def create
    result = Orders::CreateService.call(
      params: order_params,
      user: current_user
    )

    if result.success?
      redirect_to result.order
    else
      @order = result.order
      render :new
    end
  end
end
```

<details>
<summary>Solution</summary>

```ruby
# lib/rubocop/cop/custom/prefer_service_objects.rb
module RuboCop
  module Cop
    module Custom
      class PreferServiceObjects < Base
        MSG = 'Extract complex business logic to a service object.'

        def on_def(node)
          return unless in_controller?
          return unless action_method?(node)
          return unless complex_action?(node)

          add_offense(node)
        end

        private

        def in_controller?
          processed_source.file_path.include?('/controllers/')
        end

        def action_method?(node)
          return false if node.method_name.to_s.start_with?('_')
          return false if %i[initialize].include?(node.method_name)

          true
        end

        def complex_action?(node)
          return false unless node.body

          line_count = node.body.source.lines.count
          conditional_count = count_conditionals(node.body)

          line_count > 10 || conditional_count > 2
        end

        def count_conditionals(node)
          return 0 unless node

          count = 0
          count += 1 if %i[if case].include?(node.type)

          node.each_child_node do |child|
            count += count_conditionals(child)
          end

          count
        end
      end
    end
  end
end
```
</details>

## Part 4: Project-Specific Conventions

### Task 4.1: No Direct ActiveRecord in Services

Enforce that service objects use repository pattern instead of direct ActiveRecord calls.

```ruby
# lib/rubocop/cop/custom/no_direct_model_usage.rb
module RuboCop
  module Cop
    module Custom
      class NoDirectModelUsage < Base
        MSG = 'Use repository pattern instead of direct model calls in services.'
        ACTIVE_RECORD_METHODS = %i[
          find find_by where all create update destroy
        ].freeze

        # TODO: Implement
        # Detect: User.find(id) in service objects
        # Suggest: user_repository.find(id)
      end
    end
  end
end
```

**Test case:**

```ruby
# Bad - direct ActiveRecord in service
class Users::CreateService
  def call
    user = User.create!(name: 'Alice')  # Offense
    user
  end
end

# Good - using repository
class Users::CreateService
  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  def call
    @user_repository.create(name: 'Alice')
  end
end
```

<details>
<summary>Solution</summary>

```ruby
# lib/rubocop/cop/custom/no_direct_model_usage.rb
module RuboCop
  module Cop
    module Custom
      class NoDirectModelUsage < Base
        MSG = 'Use repository pattern instead of direct model calls in services.'
        ACTIVE_RECORD_METHODS = %i[
          find find_by find_by! where all
          create create! update update!
          destroy destroy! delete delete_all
        ].freeze

        def on_send(node)
          return unless in_service_file?
          return unless active_record_call?(node)

          add_offense(node)
        end

        private

        def in_service_file?
          processed_source.file_path.include?('/services/')
        end

        def active_record_call?(node)
          return false unless node.receiver
          return false unless model_constant?(node.receiver)

          ACTIVE_RECORD_METHODS.include?(node.method_name)
        end

        def model_constant?(node)
          return false unless node.const_type?

          # Check if constant name looks like a model (singular, capitalized)
          node.short_name.to_s[0] == node.short_name.to_s[0].upcase
        end
      end
    end
  end
end
```
</details>

## Part 5: Integration

### Task 5.1: Add All Cops to CI

```yaml
# .github/workflows/rubocop.yml
name: RuboCop Custom Cops

on: [push, pull_request]

jobs:
  custom-cops:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Run Custom Cops
        run: |
          bundle exec rubocop --only Custom/NoDebugStatements
          bundle exec rubocop --only Custom/PreferServiceObjects
          bundle exec rubocop --only Custom/NoDirectModelUsage
```

## Verification

Test your custom cops:

```bash
# Run specific custom cop
rubocop --only Custom/NoDebugStatements

# Run all custom cops
rubocop --only Custom

# Auto-correct with custom cops
rubocop -a --only Custom/ModernHashSyntax

# Test in spec
bundle exec rspec spec/lib/rubocop/
```

## Bonus Challenges

1. **Logging Cop**: Create cop that enforces using Rails.logger instead of puts
2. **N+1 Detection**: Detect potential N+1 queries in controllers
3. **Test Coverage Cop**: Enforce that new files have corresponding test files
4. **Documentation Cop**: Require YARD documentation for public methods

## Key Learnings

- Custom cops extend RuboCop's capabilities
- `on_send` detects method calls
- `on_def` detects method definitions
- `AutoCorrector` enables auto-fixing
- Test your cops with RSpec
- File path checking enables context-specific rules
- Custom cops enforce team conventions

## Next Steps

Continue to **[Exercise 3: CI/CD Integration](3-ci-cd-integration.md)** to automate your linting workflow!
