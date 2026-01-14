# Mini Framework Lab - Solution

## Overview

This solution demonstrates building a minimal web framework to understand design patterns:

1. **Routing System** - URL routing with pattern matching
2. **MVC Pattern** - Model-View-Controller architecture
3. **Service Layer** - Business logic separation
4. **Plugin System** - Framework extensibility

## Files

```
solution/
├── RUN.md                    # This file
├── framework_demo.rb         # Main demo script
└── lib/
    ├── router.rb             # URL routing system
    ├── request_response.rb   # Request/Response objects
    ├── application.rb        # Application class
    ├── controller.rb         # Base controller
    ├── view.rb               # Template rendering
    ├── model.rb              # ActiveRecord-style models
    ├── service.rb            # Service objects
    └── plugin.rb             # Plugin system
```

## Prerequisites

- Ruby 3.0+ (recommended)
- No external gems required

## Running the Solution

```bash
cd ruby/labs/advanced/mini-framework-lab/solution
ruby framework_demo.rb
```

## Expected Output

The demo will show:

1. **Router**: Pattern matching with URL parameters
2. **Request/Response**: HTTP abstractions
3. **Controllers**: Action methods with rendering
4. **Models**: Simple ActiveRecord-style persistence
5. **Services**: Business logic encapsulation
6. **Plugins**: Middleware-style extensions

## Design Patterns Demonstrated

- **MVC**: Model-View-Controller separation
- **Singleton**: Configuration instance
- **Factory**: Controller creation
- **Decorator**: Model caching
- **Service Object**: Encapsulated business logic
- **Plugin/Middleware**: Extensible request pipeline
