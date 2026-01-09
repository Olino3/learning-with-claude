# Ruby Development Labs

Professional Ruby development labs demonstrating real-world project structures, design patterns, and best practices.

## Overview

This directory contains 4 comprehensive labs that showcase production-quality Ruby applications. Each lab is a complete mini-application with proper project structure, comprehensive tests, and detailed documentation.

## Labs

### Lab 1: TDD Task Manager
**Directory**: `task-manager-lab/`

A CLI task manager built with Test-Driven Development principles.

**Key Concepts**:
- Test-Driven Development (TDD)
- Repository Pattern
- Service Objects
- CLI Design
- RSpec Testing
- Rubocop Linting

**Technologies**: Ruby, RSpec, JSON file storage

**Patterns Demonstrated**:
- Repository Pattern (data persistence abstraction)
- Service Object Pattern (business logic)
- Value Objects (immutable task entities)
- SOLID Principles

[View Lab 1 README](./task-manager-lab/README.md)

---

### Lab 2: Web Scraper
**Directory**: `web-scraper-lab/`

A web scraping application demonstrating advanced design patterns.

**Key Concepts**:
- Service Objects
- Decorator Pattern
- Strategy Pattern
- HTTP Mocking with WebMock
- Nokogiri and HTTParty

**Technologies**: Ruby, Nokogiri, HTTParty, WebMock, VCR

**Patterns Demonstrated**:
- Service Object Pattern (scraping logic)
- Decorator Pattern (article presentation)
- Strategy Pattern (interchangeable parsers)
- Facade Pattern (simplified interface)

[View Lab 2 README](./web-scraper-lab/README.md)

---

### Lab 3: API Client
**Directory**: `api-client-lab/`

An API client with background job processing and caching.

**Key Concepts**:
- Background Jobs with Sidekiq
- Redis Caching
- Rate Limiting
- HTTParty API Clients
- Service Objects

**Technologies**: Ruby, Sidekiq, Redis, HTTParty, WebMock

**Patterns Demonstrated**:
- Background Job Pattern (asynchronous processing)
- Cache-Aside Pattern (caching layer)
- Rate Limiter Pattern (token bucket algorithm)
- Service Object Pattern (API interaction)

[View Lab 3 README](./api-client-lab/README.md)

---

### Lab 4: Secure Config Manager
**Directory**: `config-manager-lab/`

A configuration management tool with encryption and validation.

**Key Concepts**:
- Security Best Practices
- Encryption (AES-256-GCM)
- Configuration Validation
- Environment Variables
- Dotenv Integration

**Technologies**: Ruby, OpenSSL, Dotenv

**Patterns Demonstrated**:
- Service Object Pattern (encryption, validation)
- Validator Pattern (schema validation)
- Loader Pattern (configuration loading)
- Facade Pattern (unified interface)

[View Lab 4 README](./config-manager-lab/README.md)

---

## Learning Path

### Recommended Order

1. **Lab 1: TDD Task Manager** - Start here to learn TDD fundamentals and basic patterns
2. **Lab 2: Web Scraper** - Build on Lab 1 with more advanced patterns
3. **Lab 3: API Client** - Learn background processing and caching
4. **Lab 4: Secure Config Manager** - Master security and configuration management

### Skill Levels

- **Beginner**: Complete Lab 1, understand the tests and patterns
- **Intermediate**: Complete Labs 1-3, implement the suggested exercises
- **Advanced**: Complete all labs, extend with custom features

## Common Setup

All labs require:
- Ruby 3.0 or higher
- Bundler gem

Some labs have additional requirements:
- **Lab 3**: Redis server
- **Lab 4**: OpenSSL (usually pre-installed)

## Project Structure

Each lab follows Ruby best practices:

```
lab-name/
├── lib/              # Application code
│   ├── main.rb       # Main class
│   ├── models/       # Data models
│   ├── services/     # Service objects
│   └── ...           # Other components
├── spec/             # RSpec tests
│   ├── spec_helper.rb
│   └── **/*_spec.rb  # Test files
├── bin/              # Executables (optional)
├── config/           # Configuration (optional)
├── Gemfile           # Dependencies
├── Rakefile          # Task automation
├── .rspec            # RSpec configuration
├── .rubocop.yml      # Rubocop configuration
├── .gitignore        # Git ignore rules
└── README.md         # Documentation
```

## Running Tests

Each lab includes comprehensive test suites:

```bash
cd lab-name/
bundle install
bundle exec rspec
```

## Code Quality

All labs use Rubocop for code quality:

```bash
bundle exec rubocop
```

## Design Patterns Covered

Across all labs, you'll learn:

1. **Creational Patterns**
   - Factory Pattern (creating objects)
   - Singleton Pattern (shared instances)

2. **Structural Patterns**
   - Decorator Pattern (adding functionality)
   - Facade Pattern (simplified interfaces)
   - Repository Pattern (data abstraction)

3. **Behavioral Patterns**
   - Strategy Pattern (interchangeable algorithms)
   - Service Object Pattern (business logic)
   - Observer Pattern (event handling)

4. **Architectural Patterns**
   - MVC (Model-View-Controller)
   - Layered Architecture
   - Dependency Injection

## Best Practices Demonstrated

### Code Organization
- Separation of Concerns
- Single Responsibility Principle
- DRY (Don't Repeat Yourself)

### Testing
- Test-Driven Development (TDD)
- Arrange-Act-Assert pattern
- Mocking and stubbing
- Test coverage (>85%)

### Security
- Input validation
- Error handling
- Encryption
- Secret management

### Documentation
- Comprehensive READMEs
- Code comments
- Usage examples
- API documentation

## Exercises

Each lab includes exercises at three levels:

- **Beginner**: Simple enhancements to existing features
- **Intermediate**: New features requiring multiple components
- **Advanced**: Complex features requiring architectural changes

## Real-World Applications

These labs demonstrate patterns used in:

- **Task Manager**: Project management tools, TODO apps
- **Web Scraper**: Price monitoring, news aggregation, data collection
- **API Client**: Third-party integrations, microservices communication
- **Config Manager**: Application configuration, secrets management

## Additional Resources

### Ruby Documentation
- [Ruby Style Guide](https://rubystyle.guide/)
- [RSpec Documentation](https://rspec.info/)
- [Ruby API Documentation](https://ruby-doc.org/)

### Design Patterns
- [Refactoring Guru - Design Patterns](https://refactoring.guru/design-patterns)
- [Ruby Design Patterns](https://github.com/davidgf/design-patterns-in-ruby)

### Testing
- [Better Specs](https://www.betterspecs.org/)
- [RSpec Best Practices](https://github.com/rubocop/rspec-style-guide)

## Getting Help

If you encounter issues:

1. Check the lab's README.md
2. Review the test files for usage examples
3. Run tests to see what's expected: `bundle exec rspec --format documentation`
4. Check Rubocop for code style issues: `bundle exec rubocop`

## Contributing

These labs are designed for educational purposes. Feel free to:
- Complete the suggested exercises
- Extend the labs with new features
- Share your implementations
- Report issues or suggest improvements

## License

Educational use only - part of the Learning with Claude Ruby curriculum.

---

## Quick Start

```bash
# Clone or navigate to a lab
cd task-manager-lab/

# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run the application
ruby bin/task_manager
# or
./bin/task_manager

# Check code quality
bundle exec rubocop
```

Happy coding! 🚀
