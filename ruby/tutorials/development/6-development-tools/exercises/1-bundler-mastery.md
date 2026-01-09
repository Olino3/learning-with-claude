# Exercise 1: Bundler Mastery

Practice advanced Bundler techniques for dependency management.

## Challenge: Resolve Version Conflict

Given conflicting gem requirements, resolve them using Bundler.

```ruby
# Gemfile with conflicts
gem 'rails', '~> 7.0'
gem 'devise', '~> 4.9'     # Requires rails >= 6.0
gem 'admin_toolkit'        # Requires rails ~> 6.1
```

**Tasks:**
1. Identify the conflict
2. Find compatible versions
3. Use `bundle update` strategically
4. Document the resolution

## Key Commands

```bash
bundle outdated --strict    # Check version constraints
bundle viz                  # Visualize dependencies
bundle clean --force        # Remove unused gems
```

## Key Learning

Bundler resolves complex dependency graphs automatically, but understanding version constraints helps fix conflicts.
