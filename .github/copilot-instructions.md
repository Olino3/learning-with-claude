# GitHub Copilot Instructions for learning-with-claude

This is an **educational repository** teaching Ruby and Dart to developers (especially Python developers). Code suggestions should align with learning objectives and repository conventions.

## Repository Context

**Purpose:** Progressive learning materials for Ruby and Dart
**Target Audience:** Developers transitioning from Python or learning from scratch
**Structure:** Tutorials (progressive lessons) + Labs (hands-on projects)

## Tech Stack

**Ruby:**
- Version: 3.4.7
- Frameworks: Sinatra (web framework)
- Testing: RSpec, Minitest, Rack-Test, Capybara
- Linting: RuboCop
- Database: PostgreSQL (via pg gem), SQLite3, Redis
- ORM: ActiveRecord, Sequel
- Security: BCrypt, JWT, Rack::Protection
- WebSocket: Faye-WebSocket, EventMachine

**Dart:**
- Version: Latest stable
- Testing: package:test
- Package manager: pub

**Infrastructure:**
- Containerization: Docker & Docker Compose
- Development Tool: Tilt (optional)
- Databases: PostgreSQL 13+, Redis
- Web Servers: Puma, Thin, WEBrick

## Build, Test, and Lint Commands

All commands run inside Docker containers. **Never** suggest installing Ruby/Dart locally.

### Starting the Environment

```bash
make up-docker          # Start all containers
make down               # Stop all containers
make status             # Check container status
make logs               # View all logs
```

### Ruby Environment

```bash
make shell              # Open bash in Ruby container
make repl               # Start interactive Ruby (IRB)
make run-script SCRIPT=path/to/file.rb   # Run a Ruby script

# Example: Run a tutorial script
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/hello.rb
```

### Testing

```bash
# Run RSpec tests (inside Ruby container)
make shell
rspec spec/                              # Run all tests
rspec spec/path/to/specific_spec.rb      # Run specific test file
rspec spec/path/to/specific_spec.rb:42   # Run test at line 42
```

### Linting

```bash
# Run RuboCop (inside Ruby container)
make shell
rubocop                                  # Lint all Ruby files
rubocop path/to/file.rb                 # Lint specific file
rubocop -a                              # Auto-correct safe issues
```

### Sinatra Web Development

```bash
make sinatra-tutorial NUM=1             # Run tutorial 1-8
make sinatra-lab NUM=1                  # Run lab 1-4
make sinatra-start APP=path/to/app.rb   # Start custom Sinatra app
make sinatra-stop                       # Stop running Sinatra app
make sinatra-logs                       # View Sinatra logs

# Web ports:
# http://localhost:4567 - Default Sinatra
# http://localhost:9292 - Rack apps
# http://localhost:3000 - Alternative port
```

### Dart Environment

```bash
make dart-shell         # Open bash in Dart container
make dart-repl          # Start Dart REPL
make run-dart SCRIPT=path/to/file.dart   # Run Dart script
```

### Database Access

```bash
make db-console         # PostgreSQL psql console
make redis-cli          # Redis CLI
```

## Workflow Steps

### When Adding New Tutorial Content

1. **Plan:** Understand the learning objective and difficulty level
2. **Create:** Add files in appropriate tutorial/lab directory
3. **Structure:** Follow two-track pattern (README.md + STEPS.md)
4. **Test:** Run the code in the container to verify it works
5. **Document:** Include Python comparisons and clear explanations
6. **Commit:** Use meaningful messages like "Add Tutorial X: Topic"

### When Modifying Existing Code

1. **Understand:** Read the README and STEPS to understand the learning path
2. **Preserve:** Keep TODO markers and educational structure intact
3. **Test:** Verify changes work in the containerized environment
4. **Lint:** Run RuboCop if modifying Ruby code
5. **Validate:** Ensure difficulty level is appropriate for the tutorial

### When Reviewing Code

1. Check idiomatic usage (Ruby blocks, Dart null safety)
2. Verify Python comparison comments are accurate
3. Ensure containerized commands (not local installations)
4. Confirm educational clarity over cleverness
5. Validate progression matches tutorial level

## Code Suggestion Guidelines

### Match Tutorial Difficulty Level

When suggesting code in:

- **Beginner tutorials (1-10):** Simple, clear examples. Avoid advanced features.
- **Intermediate tutorials (11-16):** Introduce more Ruby/Dart-specific patterns.
- **Advanced tutorials (17-23):** Use sophisticated language features, metaprogramming, etc.
- **Labs:** Production-quality code with error handling and edge cases.

### Include Python Comparison Comments

When working in Ruby or Dart files, add helpful comments comparing to Python:

```ruby
# Python: list_comp = [x*2 for x in numbers]
# Ruby uses map with blocks:
doubled = numbers.map { |x| x * 2 }

# Python: if x in my_list:
# Ruby uses include?:
if my_list.include?(x)
```

### Follow Established Exercise Patterns

Exercises use specific patterns:

**TODO Markers for Student Completion:**
```ruby
# TODO: Implement the calculate_average method
def calculate_average(numbers)
  # Your code here
end
```

**Checkpoint Structure:**
```ruby
# Checkpoint 1: Basic Implementation
# Expected output: [2, 4, 6, 8]
# Run: ruby this_file.rb
```

**Numbered Examples:**
```ruby
# Example 1: Basic Usage
puts "Example 1: Creating an array"
# ...

# Example 2: Transforming Data
puts "Example 2: Using map"
# ...
```

### Suggest Idiomatic Ruby/Dart, Not Python Patterns

**Ruby - DO:**
```ruby
# Iterators instead of for loops
names.each { |name| puts name }

# Blocks for control flow
File.open('data.txt') do |file|
  file.each_line { |line| puts line }
end

# Implicit returns
def double(x)
  x * 2  # No return needed
end

# Statement modifiers for simple conditions
save_user if user.valid?

# Symbols for identifiers
options = { format: :json, verbose: true }
```

**Ruby - DON'T:**
```ruby
# Python-style for loops (not idiomatic)
for name in names
  puts name
end

# Explicit returns everywhere (verbose)
def double(x)
  return x * 2  # Unnecessary return
end

# String keys where symbols fit better
options = { "format" => "json", "verbose" => true }
```

**Dart - DO:**
```dart
// Null safety
String? nullable = null;
String nonNull = nullable ?? 'default';

// Named parameters for clarity
void greet({required String name, String greeting = 'Hello'}) {
  print('$greeting, $name!');
}

// Cascade notation
var user = User()
  ..name = 'Alice'
  ..email = 'alice@example.com'
  ..save();

// Async/await
Future<String> fetchData() async {
  final response = await http.get(url);
  return response.body;
}
```

**Dart - DON'T:**
```dart
// Ignoring null safety
String name = null;  // Error! Use String? instead

// Not using named parameters
void greet(String name, String greeting) { }  // Less clear

// Missing async/await
Future<String> fetchData() {
  return http.get(url).then((response) => response.body);  // Verbose
}
```

### Reference Related Tutorials

When suggesting implementations, point to relevant tutorials:

```ruby
# This pattern is covered in Tutorial 11: Advanced Blocks & Closures
# See: ruby/tutorials/11-Advanced-Blocks-Procs-Lambdas/README.md

users.each do |user|
  # ...
end
```

## Naming Conventions

**Ruby:**
- Variables/methods: `snake_case`
- Constants: `SCREAMING_SNAKE_CASE`
- Classes/modules: `PascalCase`
- Predicate methods: `valid?`, `empty?`
- Dangerous methods: `save!`, `update!`

**Dart:**
- Variables/methods: `camelCase`
- Constants: `lowerCamelCase` (with `const` or `final`)
- Classes: `PascalCase`
- Private members: `_leadingUnderscore`

## File Organization

**Tutorial Exercises:**
```ruby
#!/usr/bin/env ruby
# Tutorial Topic Practice

require 'some_library'

puts "=" * 70
puts "TUTORIAL TOPIC PRACTICE"
puts "=" * 70

# Example 1: Basic Concept
# ...

# Example 2: Intermediate Pattern
# ...
```

**Lab Solutions:**
```
lab-name/
├── lib/
│   ├── models/
│   ├── services/
│   └── utilities/
├── spec/           # RSpec tests
├── app.rb          # Main entry point
└── config/
```

## Testing Conventions

**Ruby (RSpec):**
```ruby
RSpec.describe Calculator do
  describe '#add' do
    it 'adds two numbers' do
      calc = Calculator.new
      expect(calc.add(2, 3)).to eq(5)
    end
  end
end
```

**Dart:**
```dart
import 'package:test/test.dart';

void main() {
  test('adds two numbers', () {
    final calc = Calculator();
    expect(calc.add(2, 3), equals(5));
  });
}
```

## Docker/Environment Awareness

All code runs in containers. Don't suggest:
- `gem install` (gems are pre-installed in container)
- Local Ruby/Dart installations
- Platform-specific paths

**Instead suggest:**
```bash
# Run in container
make shell           # Enter Ruby container
make repl           # Start IRB
make run-script SCRIPT=path/to/file.rb
```

## Common Patterns to Recognize

**Two-Track Learning:**
- `README.md` - Complete overview with full solution
- `STEPS.md` - Incremental build with 6-9 steps

**Challenge Files:**
- Include `# TODO:` markers for student completion
- Provide test cases to validate solutions
- Include hints in comments

**Git-Based Milestones:**
- Each step in STEPS.md corresponds to a commit
- Use meaningful commit messages like "Step 3: Add user authentication"

## Python Comparison Priority

Always help Python developers by:

1. **Commenting equivalents** in code suggestions
2. **Noting key differences** (e.g., truthiness, syntax)
3. **Providing mental models** (list comprehensions → map/select)
4. **Warning about pitfalls** (e.g., `elsif` not `elif`)

## Quality Checklist for Suggestions

- [ ] Matches tutorial difficulty level
- [ ] Uses Ruby/Dart idioms (not direct Python translations)
- [ ] Includes helpful comments
- [ ] Python comparisons when relevant
- [ ] Follows repository naming conventions
- [ ] Runs in containerized environment
- [ ] References related tutorials
- [ ] Clear and educational

## Example Code Comments

**Good:**
```ruby
# Python: squares = [x**2 for x in numbers]
# Ruby uses map with blocks:
squares = numbers.map { |x| x**2 }

# This demonstrates Ruby's block syntax covered in Tutorial 4
```

**Better:**
```ruby
# Transform array elements using map
# Python equivalent: squares = [x**2 for x in numbers]
# Tutorial 4 covers blocks: ruby/tutorials/4-Methods-and-Blocks/
squares = numbers.map { |x| x**2 }

# Alternative using do...end for multi-line blocks:
squares = numbers.map do |x|
  x**2
end
```

## Remember

Your suggestions are part of a learning journey. Prioritize:
1. **Clarity** over cleverness
2. **Idioms** over familiarity (teach Ruby/Dart way, not Python way)
3. **Education** over brevity (comments are good!)
4. **Progression** (respect the learning level)

Help developers become confident Ruby and Dart programmers! 🚀

## Explicit Boundaries - DO NOT Touch

**Files and Directories to Never Modify:**
- `.git/` - Git internals
- `.github/workflows/` - CI/CD configuration (unless explicitly tasked)
- `docker-compose.yml` - Infrastructure config (unless explicitly tasked)
- `Dockerfile` - Container definitions (unless explicitly tasked)
- `Gemfile.lock`, `pubspec.lock` - Dependency lock files (auto-generated)
- `.env` files - Environment variables and secrets
- `todos.db` - Database files

**Code to Preserve:**
- `# TODO:` markers in exercise files (for student completion)
- Checkpoint comments and expected output annotations
- Step-by-step progression in STEPS.md files
- Git commit history representing learning milestones

**Actions to Avoid:**
- Installing gems/packages directly (`gem install`, `pub add`) - use Gemfile/pubspec.yaml
- Running commands outside containers
- Modifying working solution code unless fixing a bug
- Removing educational comments or Python comparisons
- Changing tutorial difficulty levels arbitrarily
- Suggesting production patterns in beginner tutorials

## Security Guidelines

**Always:**
- Use `bcrypt` for password hashing (never plain text or MD5/SHA1)
- Sanitize user input in web applications
- Use parameterized queries to prevent SQL injection
- Enable Rack::Protection in Sinatra apps
- Use HTTPS in production examples
- Store secrets in environment variables, never in code

**Never:**
- Commit API keys, tokens, or passwords
- Use `eval()` or `instance_eval()` with user input
- Disable CSRF protection without explaining why
- Use `system()` or backticks with unsanitized input
- Store sensitive data in cookies without encryption

**In Examples:**
- Use placeholder values: `YOUR_API_KEY`, `example.com`
- Show `.env.example` files, not `.env` files
- Demonstrate secure patterns even in simple tutorials
- Add security comments when using authentication/authorization

## Acceptance Criteria - Definition of "Done"

Before considering a task complete:

### For New Tutorials
- [ ] Code runs successfully in Docker container
- [ ] Includes Python comparison comments (if Ruby/Dart code)
- [ ] Has clear learning objectives stated
- [ ] Follows established file structure (README.md + optional STEPS.md)
- [ ] Numbered examples with expected output
- [ ] Matches appropriate difficulty level
- [ ] Includes TODO markers for student exercises
- [ ] References related tutorials when relevant

### For Code Changes
- [ ] Tested in containerized environment (`make shell`, then run)
- [ ] Follows language idioms (not direct Python translation)
- [ ] Linted (RuboCop for Ruby, if applicable)
- [ ] Preserves educational structure (TODOs, checkpoints)
- [ ] Maintains or improves clarity
- [ ] Doesn't break existing tutorials/labs
- [ ] Security best practices followed

### For Documentation Updates
- [ ] Accurate command examples
- [ ] References correct file paths
- [ ] Markdown properly formatted
- [ ] Examples tested and verified
- [ ] Clear and beginner-friendly language

### For Lab Solutions
- [ ] Complete working implementation
- [ ] Error handling for edge cases
- [ ] Security best practices demonstrated
- [ ] Code organized in proper structure (lib/, spec/, etc.)
- [ ] Tests included (RSpec for Ruby labs)
- [ ] README with setup and usage instructions

## Quick Reference Card

**Repository Type:** Educational (Ruby & Dart learning materials)

**Target Users:** Python developers learning Ruby/Dart

**Key Patterns:**
- Two-track learning: README.md (full solution) + STEPS.md (incremental)
- TODO markers for student completion
- Python comparison comments
- Containerized development (Docker)
- Progressive difficulty (beginner → intermediate → advanced)

**Essential Commands:**
```bash
make up-docker                    # Start environment
make shell                        # Ruby container
make run-script SCRIPT=file.rb   # Run Ruby script
make sinatra-tutorial NUM=1      # Sinatra tutorial
rubocop                          # Lint (inside container)
rspec                            # Test (inside container)
```

**Core Principles:**
1. Clarity over cleverness
2. Idioms over familiarity
3. Education over brevity
4. Security by default
