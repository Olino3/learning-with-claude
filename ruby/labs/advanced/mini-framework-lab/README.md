# Advanced Lab 4: Mini Framework

Build a minimal web framework demonstrating Ruby design patterns and architecture.

## 🎯 Learning Objectives

- Implement framework design patterns
- Build service layer architecture
- Create plugin system with modules
- Apply Rack interface
- Use design patterns (Singleton, Factory, etc.)

## 📋 Project Structure

```
mini-framework-lab/
├── README.md (this file)
├── STEPS.md                   # Step-by-step build guide
├── solution/                  # Complete working solution
│   ├── RUN.md                 # How to run the solution
│   ├── framework_demo.rb      # Main demo application
│   └── lib/
│       ├── router.rb          # Request routing
│       ├── request_response.rb # HTTP abstractions
│       ├── application.rb     # Core application class
│       ├── controller.rb      # Base controller
│       ├── view.rb            # Template system
│       ├── model.rb           # ActiveRecord-style model
│       ├── service.rb         # Service objects
│       └── plugin.rb          # Plugin/middleware system
└── steps/                     # Step-by-step implementation
    ├── step-01/               # Basic Router
    ├── step-02/               # Request/Response Objects
    ├── step-03/               # Application Class
    ├── step-04/               # Base Controller
    ├── step-05/               # Simple Template System
    ├── step-06/               # Model Layer
    ├── step-07/               # Service Objects
    ├── step-08/               # Design Patterns
    └── step-09/               # Plugin System
```

## 🚀 Running the Lab

### Quick Start

Run the complete mini framework demo:

```bash
make advanced-lab NUM=4
```

### Learning Approaches

**Option 1: Study Complete System** (Quick Overview)
- Run the complete system with `make advanced-lab NUM=4`
- Review the code in `solution/framework_demo.rb` and `solution/lib/` directory
- See design patterns and framework architecture in action

**Option 2: Progressive Building** (Recommended for Learning)
- Follow the step-by-step guide in the `steps/` directory
- Each step introduces new framework components
- Run each step's demo: `ruby steps/step-01/step_demo.rb`
- Steps: Router → Request/Response → Controllers → Models → Service Layer

**Option 3: Read Solution Guide**
- Check [solution/README.md](solution/README.md) for detailed implementation notes
- Review design patterns and architectural decisions

### Manual Execution

If you prefer to run manually:

```bash
docker compose exec ruby-env ruby ruby/labs/advanced/mini-framework-lab/solution/framework_demo.rb
```

## 🐍 For Python Developers

Similar to:
- **Flask**: Minimal web framework
- **Werkzeug**: Request/response handling
- **Django patterns**: Service layer, middleware
- **FastAPI**: Modern async patterns

## 🎓 Features

1. **Routing System**: Pattern matching for URLs
2. **Controllers**: MVC pattern implementation
3. **Service Layer**: Business logic separation
4. **Middleware**: Request/response processing
5. **Plugin System**: Extensibility via modules

## 🎯 Challenges

- Add template rendering
- Implement ORM-like query interface
- Create authentication middleware
- Build REST API support
- Add WebSocket support

---

Ready to build a framework? Run the demo!
