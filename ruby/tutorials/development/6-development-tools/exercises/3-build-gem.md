# Exercise 3: Build Your First Gem

Create a simple but useful Ruby gem.

## Project: String Transformer Gem

Build a gem that provides string transformation utilities.

```ruby
# Usage
StringTransformer.slugify("Hello World!")
# => "hello-world"

StringTransformer.titleize("hello_world")
# => "Hello World"

StringTransformer.excerpt("Long text...", length: 50)
# => "Long text... (truncated)"
```

## Steps

1. Scaffold with `bundle gem string_transformer`
2. Implement transformations in `lib/string_transformer.rb`
3. Write RSpec tests
4. Add documentation
5. Build and test locally
6. (Optional) Publish to RubyGems

## Key Learning

Building gems teaches Ruby best practices and promotes code reuse.
