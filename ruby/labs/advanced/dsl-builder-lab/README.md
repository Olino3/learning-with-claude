# Advanced Lab 1: DSL Builder

Build powerful Domain Specific Languages (DSLs) using Ruby's advanced metaprogramming features.

## 🎯 Learning Objectives

This lab demonstrates:
- Building configuration DSLs with `instance_eval`
- Creating route mapping systems (Rails-style)
- Implementing query builders with method chaining
- Using `class_eval` and `define_method` for DSL creation
- Applying `method_missing` for dynamic DSLs

## 📋 Project Structure

```
dsl-builder-lab/
├── README.md (this file)
├── STEPS.md                   # Step-by-step build guide
├── solution/                  # Complete working solution
│   ├── RUN.md                 # How to run the solution
│   ├── dsl_demo.rb            # Main demo application
│   └── lib/
│       ├── config_dsl.rb      # Configuration DSL implementation
│       ├── route_mapper.rb    # Route mapping DSL (Rails-style)
│       └── query_builder.rb   # SQL query builder DSL
└── steps/                     # Step-by-step implementation
    ├── step-01/               # Intro to DSLs and instance_eval
    ├── step-02/               # Config DSL basic structure
    ├── step-03/               # Nested configuration blocks
    ├── step-04/               # Route Mapper basic routes
    ├── step-05/               # Resources and namespaces
    ├── step-06/               # Query Builder chaining
    ├── step-07/               # WHERE conditions
    ├── step-08/               # Aggregate functions
    └── step-09/               # Advanced method_missing
```

## 🚀 Running the Lab

### Quick Start

Run the complete DSL demo:

```bash
make advanced-lab NUM=1
```

### Learning Approaches

**Option 1: Study Complete System** (Quick Overview)
- Run the complete system with `make advanced-lab NUM=1`
- Review the code in `solution/dsl_demo.rb` and `solution/lib/` directory
- See all DSL patterns working together

**Option 2: Progressive Building** (Recommended for Learning)
- Follow the step-by-step guide in the `steps/` directory
- Each step introduces new DSL concepts
- Run each step's demo: `ruby steps/step-01/step_demo.rb`
- Steps: instance_eval basics → Config DSL → Route Mapper → Query Builder

**Option 3: Read Solution Guide**
- Check [solution/README.md](solution/README.md) for detailed implementation notes
- Review code organization and patterns used

### Manual Execution

If you prefer to run manually:

```bash
docker compose exec ruby-env ruby ruby/labs/advanced/dsl-builder-lab/solution/dsl_demo.rb
```

## 🎓 Concepts Demonstrated

### 1. Configuration DSL

Build an elegant configuration system:

```ruby
AppConfig.configure do
  app_name "My Awesome App"
  version "2.0.0"
  
  database do
    host "localhost"
    port 5432
    name "myapp_production"
  end
  
  cache do
    enabled true
    ttl 3600
  end
end
```

### 2. Route Mapper DSL

Create a Rails-style routing DSL:

```ruby
Router.draw do
  root to: "home#index"
  
  resource :users
  resource :posts
  
  namespace "/api/v1" do
    get "/status", to: "status#show"
    resource :articles
  end
  
  get "/about", to: "pages#about"
  post "/contact", to: "contact#create"
end
```

### 3. Query Builder DSL

Implement a fluent query builder:

```ruby
User.where(active: true)
    .where { |u| u.age > 18 }
    .order(:created_at, :desc)
    .limit(10)
    .to_sql

# => "SELECT * FROM users WHERE active = true AND age > 18 ORDER BY created_at DESC LIMIT 10"
```

## 🐍 For Python Developers

This lab demonstrates patterns you might implement with:
- **Django settings**: Our configuration DSL
- **Flask routing**: Our route mapper
- **SQLAlchemy**: Our query builder
- **Decorators**: Ruby uses `instance_eval` instead

Key differences:
- Ruby DSLs use blocks and `instance_eval`
- Python uses decorators and class-based configs
- Ruby's approach is more declarative
- Method chaining is more natural in Ruby

## 💡 Implementation Highlights

### Configuration DSL

- Uses nested `instance_eval` for hierarchical configs
- Implements `method_missing` for dynamic setters
- Supports validation and type checking
- Provides getter methods with dot notation

### Route Mapper

- Implements RESTful resource routing
- Supports namespacing with scope
- Generates standard CRUD routes automatically
- Stores routes in a registry

### Query Builder

- Method chaining for fluent interface
- Block-based conditions with `instance_eval`
- Lazy evaluation until `to_sql` or `execute`
- Supports joins, aggregations, and subqueries

## 🎯 Challenges

Try extending the DSLs with:

1. **Configuration DSL**
   - Add environment-specific configs
   - Implement config validation
   - Add encrypted secrets support
   - Create config reload mechanism

2. **Route Mapper**
   - Add route constraints (e.g., id must be numeric)
   - Implement route helpers (e.g., `user_path(id)`)
   - Add route namespacing with modules
   - Create route testing utilities

3. **Query Builder**
   - Implement JOIN operations
   - Add GROUP BY and HAVING
   - Support subqueries
   - Create query optimization hints

## 📚 What You'll Learn

After completing this lab, you'll understand:
- How to design clean, expressive DSLs
- When to use `instance_eval` vs `class_eval`
- How to implement method chaining
- How Rails routing and ActiveRecord work internally
- The power and pitfalls of metaprogramming

## 🔧 Technical Details

### Metaprogramming Techniques Used

1. **instance_eval**: Execute blocks in object context
2. **method_missing**: Handle undefined method calls
3. **define_method**: Create methods dynamically
4. **class_eval**: Modify classes at runtime
5. **Method chaining**: Return `self` for fluent interface

### Design Patterns

- **Builder Pattern**: Query builder with method chaining
- **Interpreter Pattern**: Configuration DSL
- **Chain of Responsibility**: Route matching
- **Fluent Interface**: All DSLs use method chaining

## 📖 Additional Resources

- [Ruby DSL Guide](https://www.leighhalliday.com/creating-ruby-dsl)
- [Metaprogramming Ruby](https://pragprog.com/titles/ppmetr2/metaprogramming-ruby-2/)
- [Rails Routing Guide](https://guides.rubyonrails.org/routing.html)
- [ActiveRecord Query Interface](https://guides.rubyonrails.org/active_record_querying.html)

---

Ready to build powerful DSLs? Run the examples and explore the code!
