# Code Style and Conventions

## Ruby Conventions

### Idiomatic Ruby

- Use iterators (`.each`, `.map`, `.select`) not `for` loops
- Prefer symbols over strings for identifiers
- Use implicit returns
- Statement modifiers for simple conditions: `do_something if condition`
- Use blocks extensively
- Follow Ruby style guide (2 space indentation, snake_case)

### Ruby Anti-patterns to Avoid

- Python-style `for` loops
- Explicit `return` everywhere (use implicit)
- Verbose conditionals when modifiers suffice
- String keys where symbols are better
- Missing blocks when Ruby APIs expect them

### Examples

**Good Ruby:**
```ruby
# Iterators
users.each { |user| puts user.name }
active_users = users.select { |u| u.active? }

# Symbols for keys
config = { database: 'postgres', port: 5432 }

# Implicit returns
def full_name
  "#{first_name} #{last_name}"
end

# Statement modifiers
return unless valid?
send_email if user.confirmed?
```

**Avoid (Python-like):**
```ruby
# Don't use for loops
for user in users
  puts user.name
end

# Don't use string keys where symbols fit
config = { 'database' => 'postgres' }

# Don't over-use explicit returns
def full_name
  return "#{first_name} #{last_name}"
end
```

## Dart Conventions

### Idiomatic Dart

- Use null safety features (`?`, `!`, `??`)
- Prefer `final` over `var` when appropriate
- Use named parameters for clarity
- Cascade notation (`..`) for method chaining
- Async/await for asynchronous code
- Follow Dart style guide (2 space indentation, camelCase)

### Dart Anti-patterns to Avoid

- Ignoring null safety
- Python-style naming conventions (use camelCase not snake_case)
- Missing `async`/`await` keywords
- Not using Dart's built-in collection methods

### Examples

**Good Dart:**
```dart
// Null safety
String? nullableName;
final name = nullableName ?? 'Unknown';

// Named parameters
void createUser({required String email, String? name}) {
  // ...
}

// Cascade notation
final button = Button()
  ..text = 'Click me'
  ..onClick = handleClick
  ..render();

// Async/await
Future<User> fetchUser() async {
  final response = await http.get(url);
  return User.fromJson(response.body);
}
```

**Avoid:**
```dart
// Don't ignore null safety
String name = nullableName; // Error!

// Don't use Python-style naming
String user_name = 'John'; // Use userName instead
void fetch_user() {} // Use fetchUser instead
```

## General Guidelines

### All Code Must

- Run successfully in containers (Ruby 3.4.7 or Dart SDK)
- Follow language idioms (not direct Python translations)
- Include working examples with expected output
- Be properly formatted (2 spaces, consistent style)
- Have clear, concise comments where needed
- Demonstrate practical, real-world usage

### Container-First Development

**Important:** All code runs in containers. Never suggest local Ruby/Dart installations.

**Available containers:**
- `ruby-dev` - Ruby 3.4.7
- `dart-env` - Dart SDK
- `sinatra-web` - Sinatra web applications
- `postgres` - PostgreSQL database
- `redis` - Redis cache

**Key Makefile commands:**
- `make shell` - Ruby container shell
- `make repl` - Ruby IRB REPL
- `make run-script SCRIPT=path/to/script.rb`
- `make test` - Run tests
- See Makefile for 40+ additional commands
