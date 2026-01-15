# DSL Builder Lab - Solution

## Overview

This solution demonstrates three powerful Domain Specific Languages built with Ruby metaprogramming:

1. **Configuration DSL** - Rails-style nested configuration
2. **Route Mapper DSL** - Rails-like routing system
3. **Query Builder DSL** - ActiveRecord-style query interface

## Files

```
solution/
├── RUN.md              # This file
├── dsl_demo.rb         # Main demo script
└── lib/
    ├── config_dsl.rb   # Configuration DSL implementation
    ├── route_mapper.rb # Route Mapper DSL implementation
    └── query_builder.rb # Query Builder DSL implementation
```

## Prerequisites

- Ruby 3.0+ (recommended)
- No external gems required

## Running the Solution

```bash
cd ruby/labs/advanced/dsl-builder-lab/solution
ruby dsl_demo.rb
```

## Expected Output

The demo will show:

1. **Configuration DSL**: Creating nested app configuration with validation
2. **Route Mapper DSL**: Defining routes with namespaces and resources
3. **Query Builder DSL**: Building SQL queries with method chaining

## Key Concepts Demonstrated

- `instance_eval` for DSL block evaluation
- `method_missing` for dynamic method handling
- `define_method` for generating HTTP verb methods
- Method chaining (returning `self`)
- Fluent interfaces
- Block-based configuration

## Try It Yourself

Modify `dsl_demo.rb` to:

1. Add new configuration options
2. Create custom routes with constraints
3. Build complex queries with multiple joins
