# Python Comparison Guidelines

Every tutorial should help Python developers transition smoothly. Use these patterns consistently.

## 1. Comparison Tables

At the start of each major section, include a comparison table:

```markdown
| Python | Ruby | Notes |
|--------|------|-------|
| `for item in list:` | `list.each do |item|` | Ruby uses blocks |
| `elif` | `elsif` | Note spelling difference |
| `None` | `nil` | Ruby's null value |
| `True/False` | `true/false` | Lowercase in Ruby |
| `len(list)` | `list.length` or `list.size` | Method call, not function |
```

## 2. Python Note Callouts

Throughout the content, add "📘 Python Note:" callouts:

```markdown
📘 **Python Note:** Ruby's `elsif` is like Python's `elif`, but
note the spelling difference. Also, Ruby uses `end` instead of
indentation to close blocks.
```

**When to add Python Notes:**
- Major syntax differences
- Different mental models
- Confusing similarities (false friends)
- Idiomatic approaches that differ
- Common mistakes Python developers make

**Minimum:** 3-4 Python Notes per tutorial

## 3. Mental Model Bridges

Help translate concepts, not just syntax:

```markdown
If you're used to Python's list comprehensions `[x*2 for x in nums]`,
Ruby's equivalent is `nums.map { |x| x * 2 }`. Both create new
collections by transforming each element.
```

**Good bridges explain:**
- The underlying concept
- Why the approaches differ
- When to use each pattern
- What's gained/lost in translation

## 4. Common Pitfalls

Warn about differences that cause bugs:

```markdown
⚠️ **Python developers beware:** In Ruby, only `false` and `nil`
are falsy. Unlike Python, `0`, `""`, and `[]` are all truthy!

# Python
if []:  # False
    print("won't print")

# Ruby
if []  # True!
  puts "will print"
end
```

## Key Differences to Emphasize

### Truthiness

**Python:** `False`, `None`, `0`, `""`, `[]`, `{}` are falsy
**Ruby:** Only `false` and `nil` are falsy

### Blocks vs Comprehensions

**Python:**
```python
squares = [x**2 for x in numbers]
evens = [x for x in numbers if x % 2 == 0]
```

**Ruby:**
```ruby
squares = numbers.map { |x| x**2 }
evens = numbers.select { |x| x.even? }
```

### Method Calls vs Functions

**Python:**
```python
len(list)
str(42)
type(obj)
```

**Ruby:**
```ruby
list.length
42.to_s
obj.class
```

### Naming Conventions

**Python:**
```python
snake_case for variables, functions
PascalCase for classes
UPPER_CASE for constants
```

**Ruby:**
```ruby
snake_case for variables, methods
PascalCase for classes, modules
UPPER_CASE for constants
Symbols: :like_this
```

### String Interpolation

**Python:**
```python
f"Hello, {name}!"
"Hello, {}!".format(name)
```

**Ruby:**
```ruby
"Hello, #{name}!"
# Note: Only works in double quotes, not single
```

## Python Comparison Checklist

For every tutorial, ensure you have:
- [ ] Comparison table at the start
- [ ] 3-4 Python Note callouts minimum
- [ ] Mental model bridges for major concepts
- [ ] Common pitfall warnings
- [ ] Python equivalent links in Further Reading
- [ ] Examples show both Python and Ruby side-by-side

## Target Audience Context

**Primary audience:** Developers transitioning from Python to Ruby/Dart

**Assumptions you can make:**
- Comfortable with Python syntax
- Understand OOP concepts
- Know common data structures
- Familiar with functional programming basics
- May not know compiled languages (for Dart)

**Don't assume:**
- Ruby/Dart knowledge
- Web framework experience
- Database knowledge beyond basics
- Advanced functional programming

## Writing Tone for Comparisons

**Do:**
- "If you're used to Python's..."
- "Similar to Python's..., but..."
- "Python developers often expect..."
- "Unlike Python, Ruby..."

**Don't:**
- "This is better than Python's..."
- "Python does this wrong..."
- Criticize either language
- Assume one approach is superior

**Remember:** Comparisons help build bridges, not walls. Both languages are excellent tools with different philosophies.
