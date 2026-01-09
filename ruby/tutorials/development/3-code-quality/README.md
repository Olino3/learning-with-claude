# Tutorial 3: Code Quality Tools - RuboCop & StandardRB

Master the tools that keep Ruby code clean, consistent, and maintainable. This tutorial covers RuboCop (the configurable style enforcer), StandardRB (zero-config linting), and how to integrate them into your development workflow and CI/CD pipeline.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Ruby style guides and conventions
- Configure and customize RuboCop
- Use StandardRB for zero-config linting
- Auto-fix common code style issues
- Create custom cops for team-specific rules
- Integrate linters into CI/CD pipelines
- Balance style enforcement with pragmatism
- Compare Ruby linters to Python tools

## 🐍➡️🔴 Coming from Python

If you're familiar with Python code quality tools, here's how Ruby tools compare:

| Concept | Python | Ruby | Key Difference |
|---------|--------|------|----------------|
| Style guide | PEP 8 | Ruby Style Guide | Both community-driven |
| Auto-formatter | Black | RuboCop --auto-correct | RuboCop more configurable |
| Linter | Flake8, Pylint | RuboCop | RuboCop does both |
| Type checker | mypy | Sorbet, RBS | Optional in both |
| Zero-config | Black | StandardRB | Similar philosophy |
| Import sorting | isort | No equivalent | N/A |
| Complexity checker | radon, mccabe | RuboCop metrics | Built into RuboCop |
| Security linter | bandit | Brakeman | Framework-specific |

> **📘 Python Note:** RuboCop is like combining Flake8, Black, and Pylint into one tool. StandardRB is Ruby's answer to Black's "uncompromising" approach.

## 📝 Part 1: Understanding Ruby Style

### The Ruby Style Guide

Ruby has a community-driven style guide that promotes readable, maintainable code.

```ruby
# Bad: Python-style naming
def calculate_total_price(item_list):
  total = 0
  for item in item_list:
    total = total + item.price
  end
  return total
end

# Good: Ruby style
def calculate_total_price(items)
  items.sum(&:price)
end
```

### Key Ruby Conventions

```ruby
# 1. Two-space indentation (not 4 like Python)
class User
  def initialize(name)
    @name = name
  end
end

# 2. snake_case for methods and variables
user_name = "Alice"
def get_user_name
  @user_name
end

# 3. CamelCase for classes and modules
class UserAccount
end

module PaymentProcessing
end

# 4. SCREAMING_SNAKE_CASE for constants
MAX_LOGIN_ATTEMPTS = 3
DEFAULT_TIMEOUT = 30

# 5. Predicate methods end with ?
def admin?
  role == 'admin'
end

# 6. Dangerous methods end with !
def save!
  raise unless valid?
  persist_to_database
end

# 7. Prefer implicit returns
def full_name
  "#{first_name} #{last_name}"  # No 'return' needed
end

# 8. Use symbols for keys
user = { name: 'Alice', age: 30 }  # Not { 'name' => 'Alice' }

# 9. Prefer do...end for multiline blocks
items.each do |item|
  process(item)
  log(item)
end

# 10. Prefer {...} for single-line blocks
items.map { |item| item.price }
```

> **📘 Python Note:** Ruby uses 2 spaces (vs Python's 4), has special method suffixes (?, !), and favors implicit returns.

## 📝 Part 2: RuboCop - The Configurable Linter

### Installing RuboCop

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false  # For Rails projects
end

# Install
bundle install

# Generate config file
rubocop --init
```

This creates `.rubocop.yml` for configuration.

### Running RuboCop

```bash
# Check all files
rubocop

# Check specific files
rubocop app/models/user.rb

# Check directory
rubocop app/

# Auto-correct safe offenses
rubocop --auto-correct
# or shorthand
rubocop -a

# Auto-correct all offenses (including unsafe)
rubocop --auto-correct-all
# or shorthand
rubocop -A

# Display cop names
rubocop --display-cop-names

# Show only errors
rubocop --fail-level error
```

### Understanding RuboCop Output

```ruby
# example.rb
def calculate_total( items )
  total=0
  items.each{|item|total+=item.price}
  return total
end
```

```bash
$ rubocop example.rb

Inspecting 1 file
C

Offenses:

example.rb:1:21: C: Layout/SpaceInsideParens: Space inside parentheses detected.
def calculate_total( items )
                    ^
example.rb:1:28: C: Layout/SpaceInsideParens: Space inside parentheses detected.
def calculate_total( items )
                           ^
example.rb:2:8: C: Layout/SpaceAroundOperators: Surrounding space missing for operator '='.
  total=0
       ^
example.rb:3:14: C: Layout/SpaceInsideBlockBraces: Space missing inside {.
  items.each{|item|total+=item.price}
             ^
example.rb:4:3: C: Style/RedundantReturn: Redundant 'return' detected.
  return total
  ^^^^^^

1 file inspected, 5 offenses detected, 5 offenses auto-correctable
```

### RuboCop Configuration

```yaml
# .rubocop.yml

# Inherit from shared config
inherit_from:
  - .rubocop_todo.yml

# Set target Ruby version
AllCops:
  TargetRubyVersion: 3.2
  NewCops: enable
  Exclude:
    - 'db/schema.rb'
    - 'db/migrate/**/*'
    - 'vendor/**/*'
    - 'bin/**/*'
    - 'node_modules/**/*'

# Metrics
Metrics/MethodLength:
  Max: 20
  Exclude:
    - 'spec/**/*'

Metrics/BlockLength:
  Max: 25
  Exclude:
    - 'spec/**/*'
    - 'config/**/*'

Metrics/ClassLength:
  Max: 150

Metrics/AbcSize:
  Max: 20

# Style preferences
Style/StringLiterals:
  EnforcedStyle: single_quotes

Style/Documentation:
  Enabled: false  # Don't require class documentation

Style/FrozenStringLiteralComment:
  Enabled: true

# Layout
Layout/LineLength:
  Max: 120
  AllowedPatterns: ['^#']  # Allow long comments

Layout/EmptyLinesAroundBlockBody:
  EnforcedStyle: no_empty_lines

# Naming
Naming/VariableNumber:
  EnforcedStyle: normalcase  # Allow user1 instead of user_1
```

> **📘 Python Note:** This is like configuring `pyproject.toml` for Black or `setup.cfg` for Flake8.

### Common RuboCop Cops

#### Layout Cops

```ruby
# Layout/LineLength
# Bad (>120 chars by default)
def some_method_with_a_very_long_name_that_takes_many_parameters(param1, param2, param3, param4, param5, param6)
end

# Good
def some_method_with_a_very_long_name(
  param1, param2, param3,
  param4, param5, param6
)
end

# Layout/SpaceAroundOperators
# Bad
sum=a+b*c

# Good
sum = a + b * c

# Layout/TrailingWhitespace
# Bad (spaces at end of line)
def hello
  puts "world"
end

# Good
def hello
  puts "world"
end
```

#### Style Cops

```ruby
# Style/StringLiterals
# Bad (inconsistent)
name = "Alice"
greeting = 'Hello'

# Good (consistent single quotes)
name = 'Alice'
greeting = 'Hello'

# Use double quotes only for interpolation
message = "Hello, #{name}"

# Style/RedundantReturn
# Bad
def full_name
  return "#{first_name} #{last_name}"
end

# Good
def full_name
  "#{first_name} #{last_name}"
end

# Style/SymbolArray
# Bad
STATUSES = ['pending', 'approved', 'rejected']

# Good
STATUSES = %w[pending approved rejected]

# Style/HashSyntax
# Bad (old syntax)
user = { :name => 'Alice', :age => 30 }

# Good (new syntax)
user = { name: 'Alice', age: 30 }
```

#### Metrics Cops

```ruby
# Metrics/MethodLength
# Bad (too long)
def process_order(order)
  # 50 lines of code
end

# Good (extracted)
def process_order(order)
  validate_order(order)
  calculate_totals(order)
  apply_discounts(order)
  charge_payment(order)
  send_confirmation(order)
end

# Metrics/CyclomaticComplexity
# Bad (too many branches)
def calculate_discount(user, order)
  if user.premium?
    if order.total > 100
      if user.loyalty_points > 1000
        return 0.30
      elsif user.loyalty_points > 500
        return 0.25
      else
        return 0.20
      end
    else
      return 0.15
    end
  else
    return 0.10
  end
end

# Good (simplified)
def calculate_discount(user, order)
  return base_discount(user) unless user.premium?
  premium_discount(user, order)
end

private

def base_discount(user)
  0.10
end

def premium_discount(user, order)
  return 0.15 unless order.total > 100
  loyalty_discount(user)
end

def loyalty_discount(user)
  case user.loyalty_points
  when 1000.. then 0.30
  when 500..999 then 0.25
  else 0.20
  end
end
```

### Auto-Correcting Code

```ruby
# Before
class User
  def initialize(name,email)
    @name=name
    @email=email
  end

  def greet
    return "Hello, #{@name}"
  end

  def admin?
    if @role == 'admin'
      return true
    else
      return false
    end
  end
end

# Run: rubocop -A

# After
class User
  def initialize(name, email)
    @name = name
    @email = email
  end

  def greet
    "Hello, #{@name}"
  end

  def admin?
    @role == 'admin'
  end
end
```

> **📘 Python Note:** This is like running `black .` to auto-format Python code.

## 📝 Part 3: StandardRB - Zero Configuration

StandardRB is Ruby's answer to Black: opinionated, zero-config, and uncompromising.

### Installing StandardRB

```ruby
# Gemfile
group :development, :test do
  gem 'standard', require: false
end

# Install
bundle install
```

### Using StandardRB

```bash
# Check all files
standardrb

# Auto-fix
standardrb --fix

# Generate TODO file for existing violations
standardrb --generate-todo
```

### StandardRB Philosophy

```ruby
# No configuration needed!
# StandardRB makes all decisions for you:
# - 2 space indentation
# - Single quotes for strings
# - No trailing commas
# - Max line length: 120
# - And many more...

# Before
class UserManager
  def initialize( name, email )
    @name=name
    @email=email
  end

  def process
    if valid?
      save
    end
  end

  private
  def valid?
    @name.present? && @email.present?
  end
end

# After (standardrb --fix)
class UserManager
  def initialize(name, email)
    @name = name
    @email = email
  end

  def process
    save if valid?
  end

  private

  def valid?
    @name.present? && @email.present?
  end
end
```

### When to Choose StandardRB vs RuboCop

**Choose StandardRB when:**
- ✅ You want zero configuration
- ✅ Team agrees to accept all defaults
- ✅ Starting a new project
- ✅ Want to avoid bikeshedding

**Choose RuboCop when:**
- ✅ Need custom rules
- ✅ Working with legacy code
- ✅ Have specific style preferences
- ✅ Need framework-specific cops (Rails, RSpec)

> **📘 Python Note:** StandardRB:RuboCop :: Black:Flake8. Both approaches are valid!

## 📝 Part 4: Custom Cops

Create custom cops for team-specific rules.

### Simple Custom Cop

```ruby
# lib/rubocop/cop/custom/no_sleep.rb
module RuboCop
  module Cop
    module Custom
      class NoSleep < Base
        MSG = 'Avoid using sleep in production code. Use a proper job scheduler.'

        def on_send(node)
          return unless node.method_name == :sleep

          add_offense(node)
        end
      end
    end
  end
end
```

### Registering Custom Cops

```ruby
# .rubocop.yml
require:
  - ./lib/rubocop/cop/custom/no_sleep

Custom/NoSleep:
  Enabled: true
  Exclude:
    - 'spec/**/*'
```

### Complex Custom Cop with Auto-Correction

```ruby
# lib/rubocop/cop/custom/prefer_service_object.rb
module RuboCop
  module Cop
    module Custom
      class PreferServiceObject < Base
        extend AutoCorrector

        MSG = 'Extract complex business logic to a service object.'

        def on_def(node)
          return unless node.body
          return unless complex_method?(node)

          add_offense(node) do |corrector|
            corrector.insert_before(
              node,
              "# TODO: Extract to service object\n"
            )
          end
        end

        private

        def complex_method?(node)
          node.body.begin_type? &&
            node.body.children.size > 10
        end
      end
    end
  end
end
```

## 📝 Part 5: CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/rubocop.yml
name: RuboCop

on: [push, pull_request]

jobs:
  rubocop:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Run RuboCop
        run: bundle exec rubocop --parallel

      - name: Run StandardRB
        run: bundle exec standardrb
```

### Pre-commit Hook

```ruby
# .git/hooks/pre-commit
#!/bin/bash

echo "Running RuboCop..."

# Get staged Ruby files
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.rb$')

if [ -n "$files" ]; then
  bundle exec rubocop $files
  if [ $? -ne 0 ]; then
    echo "RuboCop found issues. Please fix them before committing."
    echo "Run 'rubocop -a' to auto-fix."
    exit 1
  fi
fi

echo "RuboCop passed!"
exit 0
```

### Using Overcommit

```ruby
# Gemfile
group :development do
  gem 'overcommit'
end

# Install
bundle install
overcommit --install

# .overcommit.yml
PreCommit:
  RuboCop:
    enabled: true
    command: ['bundle', 'exec', 'rubocop']

  StandardRb:
    enabled: true
    command: ['bundle', 'exec', 'standardrb']
```

## 📝 Part 6: Managing Technical Debt

### RuboCop TODO File

```bash
# Generate TODO file for existing violations
rubocop --auto-gen-config

# This creates .rubocop_todo.yml
# Example:
# Metrics/MethodLength:
#   Max: 50  # Should be 20
#
# Style/Documentation:
#   Enabled: false  # Re-enable after documenting classes
```

### Gradual Improvement Strategy

```yaml
# .rubocop.yml

# Inherit TODO (violations we're ignoring for now)
inherit_from:
  - .rubocop_todo.yml

# Enable new cops by default
AllCops:
  NewCops: enable

# Prevent new violations in new code
Metrics/MethodLength:
  Max: 20
  Exclude:
    - 'app/models/legacy_*.rb'  # Old code exempt
```

### Measuring Progress

```bash
# Count total offenses
rubocop --format offenses

# Track over time
rubocop --format json > rubocop_$(date +%Y%m%d).json

# Compare
echo "Offense count trend:"
jq '.summary.offense_count' rubocop_*.json
```

## ✍️ Exercises

### Exercise 1: RuboCop Basics
👉 **[RuboCop Configuration](exercises/1-rubocop-basics.md)**

Practice:
- Configuring RuboCop for a project
- Auto-correcting violations
- Customizing cop settings
- Excluding files and directories

### Exercise 2: Custom Cops
👉 **[Writing Custom Cops](exercises/2-custom-cops.md)**

Build custom cops for:
- Enforcing team conventions
- Detecting anti-patterns
- Auto-correcting violations
- Testing custom cops

### Exercise 3: CI/CD Integration
👉 **[Linting in CI/CD](exercises/3-ci-cd-integration.md)**

Set up:
- GitHub Actions workflow
- Pre-commit hooks
- Automated code review
- Quality gates

## 📚 What You Learned

✅ Ruby style guide and conventions
✅ RuboCop configuration and customization
✅ StandardRB zero-config approach
✅ Auto-fixing code violations
✅ Creating custom cops
✅ CI/CD integration strategies
✅ Managing technical debt with TODO files
✅ Comparing Ruby and Python linters

## 🔜 Next Steps

**Next: [Tutorial 4: Design Patterns (Service Objects & More)](../4-design-patterns/README.md)**

Learn to:
- Implement Service Objects for business logic
- Use Decorators and Presenters
- Build Query Objects for complex queries
- Create Form Objects and Policy Objects

## 💡 Key Takeaways for Python Developers

1. **RuboCop ≈ Flake8 + Black + Pylint**: All-in-one linting and formatting
2. **StandardRB ≈ Black**: Zero-config, opinionated formatting
3. **2-space indentation**: Ruby standard (vs Python's 4)
4. **Auto-correction**: More powerful than Black (can fix logic issues)
5. **Custom cops**: Like writing custom Pylint plugins
6. **Metrics cops**: Similar to radon/mccabe for complexity
7. **Configuration**: YAML-based (like pyproject.toml)

## 🆘 Common Pitfalls

### Pitfall 1: Over-Configuring RuboCop

```yaml
# Bad: Fighting the style guide
Style/StringLiterals:
  EnforcedStyle: double_quotes  # Non-standard

Metrics/MethodLength:
  Max: 100  # Too permissive

# Good: Accept community standards
Style/StringLiterals:
  EnforcedStyle: single_quotes

Metrics/MethodLength:
  Max: 20
  Exclude:
    - 'spec/**/*'  # Only exempt tests
```

### Pitfall 2: Ignoring Metrics Violations

```ruby
# Bad: Keeping complex methods
def process_order(order)
  # 80 lines of complex logic
  # rubocop:disable Metrics/MethodLength
end

# Good: Refactor
def process_order(order)
  validate_order(order)
  calculate_totals(order)
  process_payment(order)
  send_notifications(order)
end
```

### Pitfall 3: Disabling Cops Globally

```yaml
# Bad: Disabling useful cops
Style/Documentation:
  Enabled: false

Metrics/AbcSize:
  Enabled: false

# Good: Disable for specific cases
Style/Documentation:
  Exclude:
    - 'spec/**/*'
    - 'lib/tasks/**/*'
```

### Pitfall 4: Not Auto-Correcting Regularly

```bash
# Bad: Accumulating violations
git commit -m "Add feature"  # 50 new violations

# Good: Auto-fix before committing
rubocop -a
git add -u
git commit -m "Add feature"
```

## 📖 Additional Resources

### RuboCop
- [RuboCop Documentation](https://docs.rubocop.org/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [RuboCop Performance](https://github.com/rubocop/rubocop-performance)
- [RuboCop Rails](https://github.com/rubocop/rubocop-rails)

### StandardRB
- [StandardRB Website](https://github.com/standardrb/standard)
- [StandardRB vs RuboCop](https://github.com/standardrb/standard#why-should-i-use-ruby-standard-style)

### Custom Cops
- [Writing Custom Cops](https://docs.rubocop.org/rubocop/development.html)
- [Custom Cop Examples](https://github.com/rubocop/rubocop/tree/master/lib/rubocop/cop)

### Style Guides
- [Ruby Style Guide (Community)](https://rubystyle.guide/)
- [GitHub Ruby Style Guide](https://github.com/github/rubocop-github/blob/main/STYLEGUIDE.md)
- [Shopify Ruby Style Guide](https://shopify.github.io/ruby-style-guide/)

---

Ready to enforce code quality? Start with **[Exercise 1: RuboCop Basics](exercises/1-rubocop-basics.md)**! 🎨
