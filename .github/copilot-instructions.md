# GitHub Copilot Instructions for learning-with-claude

This is an **educational repository** teaching Ruby and Dart to developers (especially Python developers). Code suggestions should align with learning objectives and repository conventions.

## Repository Context

**Purpose:** Progressive learning materials for Ruby and Dart
**Target Audience:** Developers transitioning from Python or learning from scratch
**Structure:** Tutorials (progressive lessons) + Labs (hands-on projects)

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
