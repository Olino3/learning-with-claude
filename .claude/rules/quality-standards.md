# Quality Standards and Writing Style

## Quality Checklist

Before considering any content complete:

- [ ] All code examples run successfully
- [ ] Python comparisons included (for Ruby/Dart content)
- [ ] Follows repository patterns and conventions
- [ ] Cross-references updated
- [ ] Exercise file created and validated
- [ ] Main README updated
- [ ] Markdown properly formatted
- [ ] No broken links
- [ ] Appropriate emoji usage for visual hierarchy
- [ ] Estimated time to complete provided (for labs)

## Writing Style

### Tone

- **Clear and concise** - Respect learner's time
- **Encouraging** - Learning is a journey
- **Practical** - Real examples, not toy code
- **Progressive** - Build on previous knowledge
- **Comparative** - Always bridge to Python when relevant
- **Visual** - Use emoji, tables, code blocks effectively
- **Tested** - Every code example must work

### Voice and Perspective

- Use second person ("you will learn")
- Active voice preferred
- Direct and friendly
- Professional but approachable
- Avoid jargon without explanation

### Example Formats

**Good:**
```markdown
You'll learn to use Ruby's blocks to iterate over collections. This is
similar to Python's list comprehensions, but more flexible.
```

**Avoid:**
```markdown
The utilization of block constructs enables iteration functionality...
```

## Code Example Standards

### Every Code Example Must:

1. **Run successfully** in the container environment
2. **Include output** as comments showing expected results
3. **Be practical** - real-world usage, not toy examples
4. **Have context** - explain what it demonstrates
5. **Be progressive** - build complexity gradually

### Code Example Format:

```ruby
# Example: [What this demonstrates]
# [Brief explanation if needed]

[code here]

# Output:
# => [expected output]
# => [more output if applicable]
```

### Python Comparison in Code:

```ruby
# Python equivalent: numbers = [x**2 for x in range(10)]
# Ruby approach uses map:
squares = (0..9).map { |x| x**2 }
# => [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

## Emoji Usage

Use emoji consistently for visual hierarchy:

- 🎯 **Learning objectives, prerequisites, challenges**
- 📋 **Lists, checklists, structured content**
- 🐍➡️🔴 **Python to Ruby transitions**
- 📘 **Python Note callouts**
- 📝 **Deep dive sections, main content**
- 📚 **Further reading, references**
- 🛠️ **Tools, setup, technical details**
- ✅ **Completed items, success**
- ⚠️ **Warnings, pitfalls**
- 🚀 **Getting started, quick start**
- 🔍 **Troubleshooting, debugging**
- 🎨 **Features, design**
- 🧪 **Testing, validation**
- 🏆 **Extra credit, achievements**

**Don't overuse emoji** - Use for structure, not decoration.

## Markdown Standards

### Headers

```markdown
# Title (H1) - Once per file
## Major Section (H2)
### Subsection (H3)
#### Minor point (H4) - Use sparingly
```

### Code Blocks

Always specify the language:

````markdown
```ruby
# Ruby code
```

```dart
// Dart code
```

```bash
# Shell commands
```
````

### Lists

Consistent formatting:

```markdown
- Unordered list item
- Another item
  - Nested item (2 space indent)

1. Ordered list item
2. Second item
3. Third item
```

### Links

```markdown
[Descriptive text](path/to/file.md)
[Tutorial 5: Collections](../5-Collections/README.md)
```

### Tables

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data     | Data     | Data     |
```

## File Organization

### Tutorial Files

```
tutorial-name/
├── README.md (400-700 lines)
├── exercises/
│   └── topic_practice.rb (250-500 lines)
└── assets/ (optional)
    └── images/
```

### Lab Files

```
lab-name/
├── README.md (comprehensive overview)
├── STEPS.md (step-by-step guide)
├── solution/ (complete working code)
├── steps/ (progressive implementations)
└── challenges/ (extension exercises)
```

## Testing Requirements

### All Code Must:

1. Run in the appropriate container
2. Produce expected output
3. Handle common error cases
4. Follow language conventions
5. Pass validation scripts

### Validation Commands:

```bash
# Ruby
make run-script SCRIPT=path/to/script.rb
ruby scripts/validate_exercise.rb path/to/exercise.rb

# Dart
make dart-run SCRIPT=path/to/script.dart
```

## Cross-Reference Standards

### When Adding New Content:

1. Update main README files
2. Add links from related tutorials
3. Update learning path recommendations
4. Add to appropriate category index
5. Check for broken links

### Link Patterns:

```markdown
# From tutorial to tutorial
[Tutorial 5: Collections](../5-Collections/README.md)

# From tutorial to lab
[Beginner Lab 1](../../labs/beginner/lab1/README.md)

# From lab to tutorial
[Tutorial 3: Control Flow](../../tutorials/3-Control-Flow/README.md)
```

## Version and Date Standards

### Update When:

- Ruby/Dart version changes
- Major features added/removed
- Breaking changes to examples
- Dependency updates

### Format:

```markdown
**Last Updated:** 2025-01-17
**Ruby Version:** 3.4.7
**Dart Version:** 3.x
```

## Remember

**Your goal:** Help developers become confident Ruby and Dart programmers through clear, progressive, practical learning experiences with explicit bridges from Python where relevant.

**Quality over quantity:** Better to have 10 excellent tutorials than 20 mediocre ones.

**Consistency is key:** Follow established patterns so learners can focus on content, not structure.
