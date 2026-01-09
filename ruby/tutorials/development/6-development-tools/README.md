# Tutorial 6: Development Tools - Bundler, Pry & Debugging

Master the essential tools that make Ruby development productive and enjoyable. This tutorial covers Bundler for dependency management, Pry and byebug for debugging, IRB improvements, and the basics of gem development.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master Bundler for dependency management
- Debug effectively with Pry and byebug
- Use IRB's modern features
- Manage gem versions and conflicts
- Create your own Ruby gems
- Set up productive development workflows
- Compare Ruby tools to Python equivalents

## 🐍➡️🔴 Coming from Python

If you're familiar with Python development tools, here's how Ruby tools compare:

| Tool | Python | Ruby | Key Difference |
|------|--------|------|----------------|
| Package manager | pip | gem | Similar functionality |
| Dependency file | requirements.txt | Gemfile | Gemfile more expressive |
| Lock file | requirements.txt (pinned) | Gemfile.lock | Lock file auto-generated |
| Virtual env | venv, virtualenv | bundler, rbenv/rvm | Bundler handles isolation |
| Debugger | pdb, ipdb | pry, byebug | Pry more powerful REPL |
| REPL | python, ipython | irb, pry | Both interactive |
| Package publish | twine | gem push | gem simpler |
| Package index | PyPI | RubyGems.org | Similar concept |

> **📘 Python Note:** Bundler combines the functionality of pip + virtualenv + pip-tools into one tool.

## 📝 Part 1: Bundler Deep Dive

Bundler manages dependencies and ensures consistent environments across development, testing, and production.

### Basic Gemfile

```ruby
# Gemfile
source 'https://rubygems.org'

# Specify Ruby version
ruby '3.2.0'

# Production dependencies
gem 'rails', '~> 7.0'
gem 'pg', '~> 1.4'
gem 'puma', '~> 6.0'

# Development and test
group :development, :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
end

# Development only
group :development do
  gem 'rubocop', require: false
  gem 'bullet'
end

# Test only
group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
```

> **📘 Python Note:** This is like requirements.txt but with:
> ```
> # requirements.txt
> Django==4.2.0
> psycopg2==2.9.5
> pytest==7.3.0
> ```

### Version Constraints

```ruby
# Gemfile

# Exact version
gem 'rails', '7.0.4'

# Pessimistic operator (>= 7.0.0, < 7.1.0)
gem 'rails', '~> 7.0.0'

# Pessimistic (>= 7.0, < 8.0)
gem 'rails', '~> 7.0'

# Greater than or equal
gem 'rails', '>= 7.0'

# Range
gem 'rails', '>= 7.0', '< 8.0'

# Multiple sources
gem 'my_gem', source: 'https://my-private-source.com'

# Git repository
gem 'my_gem', git: 'https://github.com/user/my_gem.git'
gem 'my_gem', git: 'https://github.com/user/my_gem.git', branch: 'develop'
gem 'my_gem', git: 'https://github.com/user/my_gem.git', tag: 'v1.0.0'

# Local path (for development)
gem 'my_gem', path: '../my_gem'

# Require specific file
gem 'rspec', require: 'spec'

# Don't auto-require
gem 'rubocop', require: false
```

### Bundler Commands

```bash
# Install all dependencies
bundle install

# Update all gems to latest allowed versions
bundle update

# Update specific gem
bundle update rails

# Show outdated gems
bundle outdated

# Check for security vulnerabilities
bundle audit

# Show dependency tree
bundle viz

# Show where a gem is installed
bundle show rails

# Execute command in bundle context
bundle exec rails server
bundle exec rspec

# Create bundle binstubs
bundle binstubs rspec-core

# Clean up unused gems
bundle clean

# Package gems for deployment
bundle package

# List all gems
bundle list

# Show gem path
bundle info rails
```

### Bundle Config

```bash
# Set number of parallel jobs
bundle config set --local jobs 4

# Use local gems when available
bundle config set --local local.my_gem ../my_gem

# Don't install certain groups
bundle config set --local without 'development test'

# Retry failed downloads
bundle config set --local retry 3

# Deployment mode (production)
bundle config set --local deployment true

# Path for gem installation
bundle config set --local path 'vendor/bundle'

# View all configs
bundle config list
```

### Gemfile.lock

```ruby
# Gemfile.lock - Auto-generated, commit to version control
GEM
  remote: https://rubygems.org/
  specs:
    actioncable (7.0.4)
      actionpack (= 7.0.4)
      activesupport (= 7.0.4)
      nio4r (~> 2.0)
      websocket-driver (>= 0.6.1)
    actionpack (7.0.4)
      actionview (= 7.0.4)
      activesupport (= 7.0.4)
      rack (~> 2.0)
      rack-test (>= 0.6.3)
      rails-dom-testing (~> 2.0)
      rails-html-sanitizer (~> 1.0, >= 1.2.0)
    # ... more dependencies

PLATFORMS
  x86_64-linux

DEPENDENCIES
  rails (~> 7.0)
  rspec-rails (~> 6.0)

RUBY VERSION
   ruby 3.2.0p0

BUNDLED WITH
   2.4.6
```

> **📘 Python Note:** Similar to pip's freeze output or Poetry's lock file.

## 📝 Part 2: Pry - The Powerful REPL

Pry is an IRB alternative with powerful features for debugging and exploration.

### Installing Pry

```ruby
# Gemfile
group :development, :test do
  gem 'pry'
  gem 'pry-byebug'  # Adds step-through debugging
  gem 'pry-doc'     # Adds MRI Core documentation
  gem 'pry-rails'   # Rails console uses Pry
end
```

### Basic Pry Usage

```ruby
# Drop into Pry anywhere
require 'pry'

def complex_method
  result = some_calculation
  binding.pry  # Execution stops here
  process(result)
end

# Pry session
[1] pry(main)> result
=> 42

[2] pry(main)> result * 2
=> 84

[3] pry(main)> ls  # List available methods and variables
=> Shows all methods and variables

[4] pry(main)> cd result  # Change context
[5] pry(42):1> self
=> 42

[6] pry(42):1> cd ..  # Go back
```

### Pry Commands

```ruby
# Navigation
ls                    # List methods and variables
ls -m                 # Methods only
ls -i                 # Instance variables
ls ClassName          # Methods on class

cd object             # Change context to object
cd ..                 # Go back
cd /                  # Return to main

# Documentation
show-doc Array#each   # Show documentation
show-source User#authenticate  # Show source code
? Array#each          # Shortcut for show-doc

# Finding
find-method user      # Find methods with 'user' in name
find-method -c User   # Find methods on User class

# History
hist                  # Show command history
hist --grep pattern   # Search history
hist --replay 1..5    # Replay commands 1-5

# Shell
.ls                   # Run shell command
shell-mode            # Enter shell mode

# Introspection
whereami              # Show current location in code
wtf?                  # Show last exception backtrace
stat ClassName        # Show class/method statistics

# Edit
edit                  # Open editor
edit Class#method     # Edit specific method
edit-method User#name # Edit method in editor
```

### Pry for Debugging

```ruby
# app/services/order_processor.rb
class OrderProcessor
  def process(order)
    binding.pry  # Breakpoint

    calculate_total(order)
    charge_payment(order)
    send_confirmation(order)
  end

  private

  def calculate_total(order)
    binding.pry if order.items.empty?  # Conditional breakpoint

    order.items.sum(&:price)
  end
end

# Pry session with debugging
[1] pry(#<OrderProcessor>)> order
=> #<Order id: 1, total: 100.0>

[2] pry(#<OrderProcessor>)> order.items.count
=> 3

[3] pry(#<OrderProcessor>)> next  # Step to next line (with pry-byebug)

[4] pry(#<OrderProcessor>)> step  # Step into method

[5] pry(#<OrderProcessor>)> continue  # Continue execution
```

### .pryrc Configuration

```ruby
# ~/.pryrc
Pry.config.editor = 'vim'

# Custom prompt
Pry.config.prompt = Pry::Prompt.new(
  'custom',
  'Custom Pry Prompt',
  [
    proc { |obj, nest_level, _| "[#{obj}] > " },
    proc { |obj, nest_level, _| "[#{obj}] * " }
  ]
)

# Aliases
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'

# Custom commands
Pry::Commands.create_command 'show-routes' do
  description 'Show Rails routes'

  def process
    output.puts `bundle exec rails routes`
  end
end

# Load Rails console extensions
if defined?(Rails)
  require 'rails/console/app'
  require 'rails/console/helpers'
end
```

> **📘 Python Note:** Pry is like ipdb + ipython combined:
> ```python
> import ipdb; ipdb.set_trace()  # Similar to binding.pry
> ```

## 📝 Part 3: Byebug - Step-Through Debugger

```ruby
# Gemfile
gem 'byebug', group: [:development, :test]

# Usage
def calculate_discount(price, discount_rate)
  byebug  # Debugger stops here

  discounted_price = price * (1 - discount_rate)
  discounted_price.round(2)
end

# Byebug commands
(byebug) next       # Execute next line
(byebug) step       # Step into method call
(byebug) continue   # Continue execution
(byebug) finish     # Run until current method returns

(byebug) list       # Show code around current line
(byebug) list 1-20  # Show lines 1-20

(byebug) var local  # Show local variables
(byebug) var instance  # Show instance variables
(byebug) var global    # Show global variables

(byebug) display price  # Display variable on each step
(byebug) undisplay 1    # Remove display

(byebug) break 10       # Set breakpoint at line 10
(byebug) break ClassName#method  # Breakpoint at method
(byebug) info breakpoints  # List breakpoints
(byebug) delete 1       # Delete breakpoint

(byebug) backtrace  # Show call stack (or 'bt')
(byebug) up         # Move up call stack
(byebug) down       # Move down call stack

(byebug) eval price * 2  # Evaluate expression
(byebug) p price    # Print variable
(byebug) pp price   # Pretty-print variable

(byebug) help       # Show help
(byebug) quit       # Exit debugger
```

## 📝 Part 4: Modern IRB

Ruby 3.0+ includes a much-improved IRB with features like autocomplete and multi-line editing.

```ruby
# ~/.irbrc
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = '~/.irb_history'

# Use autocomplete
require 'irb/completion'

# Colorize output
require 'irb/color'
IRB.conf[:USE_COLORIZE] = true

# Enable multi-line editing
IRB.conf[:USE_MULTILINE] = true

# Helpers
def time(&block)
  start = Time.now
  result = block.call
  puts "Time: #{Time.now - start}s"
  result
end

# Rails helpers
if defined?(Rails)
  def sql(query)
    ActiveRecord::Base.connection.execute(query).to_a
  end

  def reload!
    reload!
  end
end
```

## 📝 Part 5: Creating Ruby Gems

### Gem Structure

```bash
my_gem/
├── lib/
│   ├── my_gem.rb           # Main entry point
│   ├── my_gem/
│   │   ├── version.rb      # Version constant
│   │   └── core.rb         # Core functionality
├── spec/
│   ├── spec_helper.rb
│   └── my_gem_spec.rb
├── bin/
│   └── console             # Development console
├── my_gem.gemspec          # Gem specification
├── Gemfile                 # Development dependencies
├── Rakefile                # Rake tasks
├── README.md
├── LICENSE
└── CHANGELOG.md
```

### Creating a Gem

```bash
# Using bundler to scaffold gem
bundle gem my_awesome_gem

# Or manually
mkdir my_awesome_gem
cd my_awesome_gem
```

### Gemspec File

```ruby
# my_awesome_gem.gemspec
require_relative 'lib/my_awesome_gem/version'

Gem::Specification.new do |spec|
  spec.name          = 'my_awesome_gem'
  spec.version       = MyAwesomeGem::VERSION
  spec.authors       = ['Your Name']
  spec.email         = ['your.email@example.com']

  spec.summary       = 'An awesome Ruby gem'
  spec.description   = 'A longer description of what this gem does'
  spec.homepage      = 'https://github.com/username/my_awesome_gem'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/username/my_awesome_gem/issues',
    'changelog_uri' => 'https://github.com/username/my_awesome_gem/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/username/my_awesome_gem',
    'documentation_uri' => 'https://rubydoc.info/gems/my_awesome_gem'
  }

  spec.files = Dir.glob('{lib,bin}/**/*') + %w[README.md LICENSE CHANGELOG.md]
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'activesupport', '~> 7.0'

  # Development dependencies
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.50'
end
```

### Main Gem File

```ruby
# lib/my_awesome_gem.rb
require_relative 'my_awesome_gem/version'
require_relative 'my_awesome_gem/core'
require_relative 'my_awesome_gem/helpers'

module MyAwesomeGem
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key, :timeout

    def initialize
      @api_key = nil
      @timeout = 30
    end
  end
end
```

### Publishing a Gem

```bash
# Build gem
gem build my_awesome_gem.gemspec

# Test locally
gem install ./my_awesome_gem-0.1.0.gem

# Push to RubyGems.org
gem push my_awesome_gem-0.1.0.gem

# Tag release
git tag -a v0.1.0 -m "Version 0.1.0"
git push --tags
```

## ✍️ Exercises

### Exercise 1: Bundler Mastery
👉 **[Bundler Deep Dive](exercises/1-bundler-mastery.md)**

Practice:
- Managing gem dependencies
- Resolving version conflicts
- Using private gem sources
- Bundle for deployment

### Exercise 2: Debugging with Pry
👉 **[Pry Debugging](exercises/2-pry-debugging.md)**

Debug:
- Complex service objects
- N+1 queries
- Performance bottlenecks
- Test failures

### Exercise 3: Build a Gem
👉 **[Create Your Gem](exercises/3-build-gem.md)**

Create:
- String manipulation gem
- API wrapper gem
- Rails generator gem
- Command-line tool gem

## 📚 What You Learned

✅ Bundler for dependency management
✅ Pry for powerful debugging
✅ Byebug for step-through debugging
✅ Modern IRB features
✅ Gem development basics
✅ Publishing gems to RubyGems
✅ Development workflow optimization

## 🔜 Next Steps

**Next: [Tutorial 7: Background Jobs & Performance](../7-background-jobs/README.md)**

Learn to:
- Process background jobs with Sidekiq
- Detect and fix N+1 queries
- Implement caching strategies
- Monitor application performance

## 💡 Key Takeaways for Python Developers

1. **Bundler ≈ pip + venv**: All-in-one dependency management
2. **Pry ≈ ipdb**: Powerful debugging REPL
3. **Gemfile ≈ requirements.txt**: More expressive syntax
4. **Gemfile.lock ≈ pip freeze**: Auto-generated, committed
5. **Gem ≈ Python package**: Similar publishing process
6. **bundle exec ≈ python -m**: Run in isolated environment
7. **IRB ≈ Python REPL**: Interactive Ruby shell

## 🆘 Common Pitfalls

### Pitfall 1: Not Using Bundle Exec

```bash
# Bad: Uses system gem
rspec spec/

# Good: Uses bundled gem
bundle exec rspec spec/

# Or use binstub
bin/rspec spec/
```

### Pitfall 2: Committing Gemfile.lock in Gems

```ruby
# For applications: ALWAYS commit Gemfile.lock
# For gems: Add to .gitignore

# .gitignore (for gems)
Gemfile.lock
```

### Pitfall 3: Forgetting binding.pry in Production

```ruby
# Bad: Left in production code
def process_payment
  binding.pry  # DANGER!
  charge_card
end

# Good: Use only in development
def process_payment
  binding.pry if Rails.env.development?
  charge_card
end
```

## 📖 Additional Resources

### Bundler
- [Bundler Documentation](https://bundler.io/)
- [Bundler Best Practices](https://bundler.io/guides/best_practices.html)

### Pry
- [Pry Documentation](https://pry.github.io/)
- [Pry Wiki](https://github.com/pry/pry/wiki)
- [Pry Byebug](https://github.com/deivid-rodriguez/pry-byebug)

### Gem Development
- [RubyGems Guides](https://guides.rubygems.org/)
- [Make Your Own Gem](https://guides.rubygems.org/make-your-own-gem/)
- [Gem Specification Reference](https://guides.rubygems.org/specification-reference/)

---

Ready to master Ruby tools? Start with **[Exercise 1: Bundler Mastery](exercises/1-bundler-mastery.md)**! 🛠️
