# Phase 3: Generate Beginner Tutorials (1-10)

**Objective:** Create the first 10 tutorials covering {LANGUAGE_DISPLAY} fundamentals.

---

## 📋 Context

Beginner tutorials (1-10) follow a standardized curriculum across all languages:

1. Getting Started
2. {LANGUAGE} Basics
3. Control Flow
4. Functions
5. Collections
6. Object-Oriented Programming
7. {Language-Specific Feature}
8. Error Handling
9. File I/O or Async Programming
10. {Advanced Topic}

Each tutorial follows the template in `.templates/tutorial_template.md` and includes Python comparisons.

---

## 🎯 Hybrid Approach

You can generate tutorials using either:

**Option A: Single Command** - Generate all 10 tutorials at once (faster, requires strong AI agent)

**Option B: Step-by-Step** - Use individual prompts for each tutorial (more control, better quality)

---

## 📝 Option A: Generate All Tutorials (Single Prompt)

Use this comprehensive prompt to generate all beginner tutorials in one session:

### Master Prompt for Tutorials 1-10

```
You are creating the complete beginner tutorial series (Tutorials 1-10) for {LANGUAGE_DISPLAY} in the learning-with-claude repository.

**CRITICAL REQUIREMENTS:**

1. **Read Templates First:**
   - Read `.templates/tutorial_template.md` for structure
   - Study `ruby/tutorials/2-Ruby-Basics/README.md` as a reference
   - Study `dart/tutorials/2-Dart-Basics/README.md` as a reference

2. **Python Comparison Research:**
   - For EACH tutorial, research the official Python documentation
   - Create accurate side-by-side comparison tables
   - Include minimum 3-4 "📘 Python Note:" callouts per tutorial
   - Use resources: https://docs.python.org/3/

3. **Language Documentation Research:**
   - Reference official {LANGUAGE_DISPLAY} documentation: {DOCS_URL}
   - Use current language version: {VERSION}
   - Verify all syntax with official examples

4. **Tutorial Structure:**
   - Follow `.templates/tutorial_template.md` exactly
   - Include 6-8 learning objectives
   - Create 4-6 major content sections
   - Add 3-5 challenge exercises
   - Create executable code examples (all must run without errors)

5. **Create for Each Tutorial (1-10):**
   - `{LANGUAGE}/tutorials/{N}-{Topic}/README.md`
   - `{LANGUAGE}/tutorials/{N}-{Topic}/exercises/{topic}_practice.{EXT}`
   - Numbered example files if needed

6. **Update Index:**
   - Mark completed tutorials with ✅ in `{LANGUAGE}/tutorials/README.md`

**TUTORIAL CURRICULUM:**

**Tutorial 1: Getting Started**
- Topics: Environment setup, first program, Hello World, running scripts
- Special: Include Docker commands, Makefile usage
- Exercise: Create multiple "hello" variations

**Tutorial 2: {LANGUAGE_DISPLAY} Basics**
- Topics: Variables, data types, operators, type system
- Python comparisons: type declaration, mutability, operators
- Exercise: Variable manipulation, type conversion

**Tutorial 3: Control Flow**
- Topics: if/else, loops (for, while), break/continue, pattern matching
- Python comparisons: elif vs elif/elsif, loop syntax differences
- Exercise: FizzBuzz, number guessing game

**Tutorial 4: Functions**
- Topics: Function definition, parameters, returns, scope, closures
- Python comparisons: function syntax, default parameters
- Exercise: Calculator functions, recursion

**Tutorial 5: Collections**
- Topics: Arrays/Lists, Maps/Hashes, Sets, iteration methods
- Python comparisons: list comprehensions vs map/filter, dict vs hash
- Exercise: Data manipulation, collection operations

**Tutorial 6: Object-Oriented Programming**
- Topics: Classes, objects, inheritance, encapsulation, polymorphism
- Python comparisons: __init__ vs initialize, @property vs attr_accessor
- Exercise: Class hierarchy, object interactions

**Tutorial 7: {LANGUAGE_SPECIFIC_FEATURE}**
- Choose THE defining feature of {LANGUAGE}:
  - Ruby: Modules and Mixins
  - Dart: Null Safety
  - Go: Concurrency with Goroutines
  - Rust: Ownership and Borrowing
  - Python: Decorators (if adding Python tutorials)
- Deep dive with multiple examples
- Exercise: Practical application of the feature

**Tutorial 8: Error Handling**
- Topics: Exceptions, try/catch, custom errors, error propagation
- Python comparisons: try/except vs try/catch, raise vs throw/raise
- Exercise: Robust error handling

**Tutorial 9: File I/O or Async Programming**
- Choose based on language strengths:
  - File I/O: Reading, writing, file operations, paths
  - Async: Promises/Futures, async/await patterns
- Exercise: File processing or async operations

**Tutorial 10: {ADVANCED_TOPIC}**
- Choose an advanced topic:
  - Language idioms
  - Testing frameworks
  - Package management
  - Reflection/introspection
- Bridge to intermediate tutorials
- Exercise: Real-world scenario

**VALIDATION FOR EACH TUTORIAL:**

Before completing, verify:
- [ ] README.md follows template structure exactly
- [ ] Includes Python comparison table
- [ ] Minimum 3-4 Python Note callouts
- [ ] All code examples tested and working
- [ ] Exercise file created with TODOs
- [ ] Cross-references to related tutorials added
- [ ] Added to main tutorials README with ✅

**EXECUTE:**

Create all 10 tutorials following the curriculum above. Work tutorial-by-tutorial, ensuring each is complete before moving to the next.
```

---

## 📝 Option B: Step-by-Step (Individual Prompts)

Use these individual prompts for fine-grained control. Each prompt generates one tutorial.

### Individual Tutorial Prompts

See the sub-prompts directory for detailed prompts:

- [Tutorial 1: Getting Started](sub-prompts/tutorial-01-getting-started.md)
- [Tutorial 2: Basics](sub-prompts/tutorial-02-basics.md)
- [Tutorial 3: Control Flow](sub-prompts/tutorial-03-control-flow.md)
- [Tutorial 4: Functions](sub-prompts/tutorial-04-functions.md)
- [Tutorial 5: Collections](sub-prompts/tutorial-05-collections.md)
- [Tutorial 6: OOP](sub-prompts/tutorial-06-oop.md)
- [Tutorial 7: Language-Specific Feature](sub-prompts/tutorial-07-language-feature.md)
- [Tutorial 8: Error Handling](sub-prompts/tutorial-08-error-handling.md)
- [Tutorial 9: File I/O or Async](sub-prompts/tutorial-09-io-async.md)
- [Tutorial 10: Advanced Topic](sub-prompts/tutorial-10-advanced.md)

---

## ✅ Validation Checklist (All Tutorials)

After generating tutorials, verify:

- [ ] All 10 tutorial directories created
- [ ] Each has README.md and exercises/ subdirectory
- [ ] All READMEs follow `.templates/tutorial_template.md` structure
- [ ] Python comparison tables in every tutorial
- [ ] Code examples all executable
- [ ] Tutorials index updated with ✅ for completed ones
- [ ] Cross-references between related tutorials
- [ ] Consistent emoji usage across all tutorials

### Validation Commands

```bash
# Check directory structure
ls -la {LANGUAGE}/tutorials/

# Verify each tutorial has README and exercises
for i in {1..10}; do
  ls -la {LANGUAGE}/tutorials/$i-*/README.md
  ls -la {LANGUAGE}/tutorials/$i-*/exercises/
done

# Test exercise files run
make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/exercises/basics_practice.{EXT}

# Validate with exercise checker (if available)
ruby scripts/validate_exercise.rb {LANGUAGE}/tutorials/2-{LANGUAGE_DISPLAY}-Basics/exercises/
```

---

## 📚 Essential References

Before generating tutorials, read these files for context and patterns:

**Templates:**
- `.templates/tutorial_template.md` - Structure to follow

**Ruby Examples:**
- `ruby/tutorials/1-Getting-Started/README.md`
- `ruby/tutorials/2-Ruby-Basics/README.md`
- `ruby/tutorials/3-Control-Flow/README.md`

**Dart Examples:**
- `dart/tutorials/1-Getting-Started/README.md`
- `dart/tutorials/2-Dart-Basics/README.md`

**Guidelines:**
- `CLAUDE.md` - Content creation patterns
- `docs/AI_WORKFLOW.md` - Tutorial creation workflow
- `.github/copilot-instructions.md` - Code conventions

---

## 🔜 Next Phase

After completing Phase 3, proceed to:
- **[Phase 4: Generate Intermediate Tutorials](../4-intermediate-tutorials/README.md)**
