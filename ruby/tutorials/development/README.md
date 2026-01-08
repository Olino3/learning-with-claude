# Professional Ruby Development

Welcome to the Professional Ruby Development track! These tutorials will elevate you from writing functional code to building production-grade software. Learn the tools, patterns, and practices that professional Ruby developers use every day.

## 🎯 Track Overview

This track is designed for developers who understand Ruby basics and want to master professional development practices. These tutorials are especially valuable for Python engineers transitioning to Ruby, as we'll compare and contrast approaches throughout.

## 📚 Tutorial Series

### Part 1: Testing & Quality Assurance

1. **[Testing Fundamentals: RSpec & Minitest](1-testing-fundamentals/README.md)**
   - Master Test-Driven Development (TDD)
   - Learn RSpec's BDD-style syntax
   - Understand Minitest's minimalist approach
   - Write effective unit and integration tests

2. **[Advanced Testing: FactoryBot & Capybara](2-advanced-testing/README.md)**
   - Generate test data with FactoryBot
   - Simulate user interactions with Capybara
   - Write feature tests for web applications
   - Master test doubles and mocking

3. **[Code Quality Tools: RuboCop & StandardRB](3-code-quality/README.md)**
   - Enforce Ruby style guidelines
   - Auto-format code with RuboCop
   - Adopt StandardRB's zero-config approach
   - Integrate linting into your workflow

### Part 2: Software Design & Architecture

4. **[Design Patterns: Service Objects & Decorators](4-design-patterns/README.md)**
   - Extract complex logic into Service Objects
   - Clean up views with Decorators/Presenters
   - Implement Query Objects for database queries
   - Apply Form Objects for complex forms

5. **[SOLID Principles in Ruby](5-solid-principles/README.md)**
   - Single Responsibility Principle
   - Open/Closed Principle
   - Liskov Substitution Principle
   - Interface Segregation Principle
   - Dependency Inversion Principle

### Part 3: Professional Tools & Workflows

6. **[Essential Development Tools](6-development-tools/README.md)**
   - Master Bundler for dependency management
   - Debug with Pry and break points
   - Use byebug for step-through debugging
   - Leverage gem ecosystem effectively

7. **[Background Jobs & Performance](7-background-jobs/README.md)**
   - Process async tasks with Sidekiq
   - Detect N+1 queries with Bullet
   - Implement caching strategies
   - Monitor application performance

8. **[Ruby Data Structures & Algorithms](8-data-structures/README.md)**
   - Master Enumerable methods deeply
   - Understand Ruby's internal data structures
   - Implement efficient algorithms
   - Use memoization patterns

9. **[Security & Environment Management](9-security-environment/README.md)**
   - Manage secrets securely
   - Use environment variables properly
   - Prevent common vulnerabilities
   - Apply security best practices

## 🐍 For Python Engineers

As an experienced Python developer, you'll find many familiar concepts here with Ruby twists:

| Python | Ruby | Key Difference |
|--------|------|----------------|
| pytest | RSpec | RSpec uses BDD DSL |
| unittest | Minitest | Minitest is built into Ruby |
| fixtures | FactoryBot | Dynamic generation vs static |
| Selenium | Capybara | More Ruby-idiomatic |
| Black/Flake8 | RuboCop/StandardRB | More configurable |
| mypy | Sorbet (optional) | Ruby typing is optional |
| Celery | Sidekiq | Sidekiq uses threads |
| pip/venv | Bundler/rbenv | Bundler locks versions |
| SQLAlchemy | ActiveRecord | AR more convention-based |

## 🧪 Hands-On Labs

Apply what you learn with comprehensive labs:

1. **[TDD Task Manager](../../labs/development/task-manager-lab/)** - Build a CLI app with full test coverage
2. **[Web Scraper Lab](../../labs/development/web-scraper-lab/)** - Apply design patterns to real-world scraping
3. **[API Client Lab](../../labs/development/api-client-lab/)** - Background jobs and caching
4. **[Secure Config Manager](../../labs/development/config-manager-lab/)** - Security and environment management

## 🎓 Learning Path

### For Beginners to Professional Ruby
1. Complete Ruby fundamentals (Tutorials 1-10)
2. Work through intermediate Ruby (Tutorials 11-16)
3. Start this professional development track
4. Complete each tutorial's exercises
5. Build the corresponding lab
6. Apply to your own projects

### For Experienced Python Developers
1. Skim Ruby fundamentals (focus on syntax differences)
2. Read Tutorial 16 (Idiomatic Ruby)
3. Jump into this professional development track
4. Focus on Ruby-specific tools and patterns
5. Compare with your Python experience

## 📋 Prerequisites

Before starting this track, you should:
- ✅ Understand Ruby syntax and basics
- ✅ Be comfortable with object-oriented programming
- ✅ Know how to use blocks, procs, and lambdas
- ✅ Have worked with Ruby classes and modules
- ✅ Understand file I/O and error handling

If you need a refresher, review:
- [Tutorial 6: Object-Oriented Programming](../6-OOP/README.md)
- [Tutorial 7: Modules and Mixins](../7-Modules-and-Mixins/README.md)
- [Tutorial 16: Idiomatic Ruby](../16-Idiomatic-Ruby/README.md)

## 🎯 Learning Objectives

By completing this track, you will:
- Write professional-grade Ruby code
- Apply Test-Driven Development (TDD) workflow
- Use industry-standard tools and patterns
- Build maintainable, scalable applications
- Follow Ruby community best practices
- Debug efficiently with professional tools
- Handle security concerns properly
- Optimize code for performance

## 🛠️ Development Environment

All tutorials and labs use the containerized development environment:

```bash
# Start the environment
tilt up
# or
make up

# Run tests
docker exec ruby-dev-lab bundle exec rspec

# Access development shell
docker exec -it ruby-dev-lab bash
```

The labs have dedicated containers with isolated dependencies and services (PostgreSQL, Redis, etc.).

## 📖 Additional Resources

### Ruby Testing
- [RSpec Documentation](https://rspec.info/)
- [Minitest Guide](https://github.com/minitest/minitest)
- [Effective Testing with RSpec](https://pragprog.com/titles/rspec3/)
- [FactoryBot Guide](https://github.com/thoughtbot/factory_bot)

### Code Quality
- [Ruby Style Guide](https://rubystyle.guide/)
- [RuboCop Documentation](https://rubocop.org/)
- [StandardRB](https://github.com/standardrb/standard)

### Design & Architecture
- [Refactoring: Ruby Edition](https://www.amazon.com/Refactoring-Ruby-Addison-Wesley-Professional/dp/0321984137)
- [Practical Object-Oriented Design](https://www.poodr.com/)
- [Rails Design Patterns](https://blog.appsignal.com/category/design-patterns.html)

### Tools & Performance
- [Sidekiq Documentation](https://github.com/sidekiq/sidekiq/wiki)
- [Pry Guide](https://pry.github.io/)
- [Ruby Performance Optimization](https://pragprog.com/titles/adrpo/ruby-performance-optimization/)

## 💡 Pro Tips

1. **Embrace TDD**: Write tests first, even when it feels slow initially
2. **Use RuboCop early**: Bad habits are hard to break
3. **Learn Pry deeply**: It's your best debugging friend
4. **Study open source**: Read gems' source code to learn patterns
5. **Join Ruby communities**: Ruby Weekly, Ruby Rogues podcast
6. **Contribute to gems**: Best way to learn professional practices
7. **Read The Ruby Style Guide**: Internalize community conventions

## 🚦 Getting Started

Ready to become a professional Rubyist? Start with:

👉 **[Tutorial 1: Testing Fundamentals](1-testing-fundamentals/README.md)**

Or explore the comparison of core tools:

| Category | Standard Tool | Alternative | When to Use |
|----------|---------------|-------------|-------------|
| Testing | RSpec | Minitest | RSpec for BDD, Minitest for speed |
| Linting | RuboCop | StandardRB | RuboCop for customization, Standard for simplicity |
| Debugging | Pry | debug.gem | Pry for interactive, debug.gem for breakpoints |
| Background Jobs | Sidekiq | Solid Queue | Sidekiq for mature apps, Solid Queue for Rails 7.1+ |
| Test Data | FactoryBot | Fixtures | FactoryBot for dynamic, fixtures for static |
| Web Testing | Capybara | Selenium-webdriver | Capybara for Ruby DSL, Selenium for cross-language |

---

**Let's build professional Ruby software together!** 🚀
