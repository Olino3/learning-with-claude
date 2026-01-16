# Phase 1.1: Create Language Folder Structure

**Objective:** Create the foundational directory structure for a new programming language learning module.

---

## 📋 Context

This repository follows a consistent three-tier structure for all language learning modules:
- **tutorials/** - Progressive learning tutorials (numbered 1-16+)
- **labs/** - Hands-on projects organized by difficulty (beginner, intermediate, advanced)
- **reading/** - Reference materials and additional resources

---

## 🎯 Your Task

Create a complete directory structure for **{LANGUAGE}** following the established pattern.

### Variables to Substitute

Before executing this prompt, replace these variables:
- `{LANGUAGE}` - Lowercase language name (e.g., `go`, `rust`, `javascript`, `kotlin`)
- `{LANGUAGE_DISPLAY}` - Display name with proper capitalization (e.g., `Go`, `Rust`, `JavaScript`, `Kotlin`)

---

## 📝 Steps to Execute

### Step 1: Create Main Language Directory

Create the following directory structure:

```
{LANGUAGE}/
├── tutorials/
│   ├── 1-Getting-Started/
│   │   └── exercises/
│   ├── 2-{LANGUAGE_DISPLAY}-Basics/
│   │   └── exercises/
│   ├── 3-Control-Flow/
│   │   └── exercises/
│   ├── 4-Functions/
│   │   └── exercises/
│   ├── 5-Collections/
│   │   └── exercises/
│   ├── 6-Object-Oriented-Programming/
│   │   └── exercises/
│   ├── 7-{LANGUAGE_SPECIFIC_FEATURE}/
│   │   └── exercises/
│   ├── 8-Error-Handling/
│   │   └── exercises/
│   ├── 9-File-IO/
│   │   └── exercises/
│   └── 10-{ADVANCED_TOPIC}/
│       └── exercises/
├── labs/
│   ├── beginner/
│   │   ├── lab1-basics/
│   │   ├── lab2-collections/
│   │   └── lab3-{TOPIC}/
│   ├── intermediate-lab/
│   └── advanced/
└── reading/
```

**Commands:**
```bash
mkdir -p {LANGUAGE}/tutorials/{1-Getting-Started,2-{LANGUAGE_DISPLAY}-Basics,3-Control-Flow,4-Functions,5-Collections,6-Object-Oriented-Programming,7-{LANGUAGE_SPECIFIC_FEATURE},8-Error-Handling,9-File-IO,10-{ADVANCED_TOPIC}}/exercises
mkdir -p {LANGUAGE}/labs/beginner/{lab1-basics,lab2-collections,lab3-{TOPIC}}
mkdir -p {LANGUAGE}/labs/intermediate-lab
mkdir -p {LANGUAGE}/labs/advanced
mkdir -p {LANGUAGE}/reading
```

### Step 2: Create Main Language README

Create `{LANGUAGE}/README.md` with this template:

```markdown
# {LANGUAGE_DISPLAY} Learning Path

Welcome to the {LANGUAGE_DISPLAY} learning module! This comprehensive guide helps you master {LANGUAGE_DISPLAY} through progressive tutorials and hands-on labs.

## 🎯 Who This Is For

- **Python developers** transitioning to {LANGUAGE_DISPLAY}
- Developers learning {LANGUAGE_DISPLAY} from scratch
- Anyone wanting structured, hands-on {LANGUAGE_DISPLAY} practice

## 📚 Learning Structure

### Tutorials (Progressive Learning)

**Beginner (Tutorials 1-10)**
- Start here if you're new to {LANGUAGE_DISPLAY}
- Covers fundamentals, syntax, and core concepts
- Includes Python comparisons throughout

**Intermediate (Tutorials 11-16)**
- Advanced language features
- Best practices and patterns
- Real-world applications

**Advanced (Tutorials 17+)**
- Language-specific advanced topics
- Performance optimization
- Metaprogramming (if applicable)

### Labs (Hands-On Projects)

**Beginner Labs (3 labs)**
- Small, focused projects
- Reinforce tutorial concepts
- 30-60 minutes each

**Intermediate Lab (1 project)**
- Complex multi-feature application
- Progressive building with STEPS.md
- 3-5 hours

**Advanced Labs (4 projects)**
- Specialized, production-quality projects
- Deep dives into specific topics
- 2-4 hours each

## 🚀 Quick Start

### Using Docker (Recommended)

All {LANGUAGE_DISPLAY} code runs in Docker containers—no local installation required!

```bash
# Start the environment
make up-docker

# Open {LANGUAGE_DISPLAY} shell
make {LANGUAGE}-shell

# Run a script
make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/hello.{EXT}

# Start interactive REPL
make {LANGUAGE}-repl
```

### Running Tutorials

Tutorials are self-contained learning modules:

```bash
# Read the tutorial first
cat {LANGUAGE}/tutorials/1-Getting-Started/README.md

# Run example code
make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/my_first_script.{EXT}

# Complete exercises
make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/exercises/basics_practice.{EXT}
```

### Running Labs

Labs are hands-on projects with progressive steps:

```bash
# Run beginner lab 1
make {LANGUAGE}-beginner-lab NUM=1

# Run intermediate lab
make {LANGUAGE}-intermediate-lab

# Run advanced lab 1
make {LANGUAGE}-advanced-lab NUM=1
```

## 📖 Recommended Learning Path

### Path 1: Core Language Mastery

1. **Tutorials 1-10** (Beginner)
2. **Beginner Labs 1-3** (Practice)
3. **Tutorials 11-16** (Intermediate)
4. **Intermediate Lab** (Apply knowledge)
5. **Tutorials 17+** (Advanced)
6. **Advanced Labs 1-4** (Master-level)

### Path 2: Fast Track (Experienced Developers)

If you're already proficient in Python or similar languages:

1. **Tutorial 1** (Setup)
2. **Tutorial 2** (Syntax overview)
3. **Beginner Labs 1-3** (Hands-on practice)
4. **Tutorials 7-10** (Language-specific features)
5. **Intermediate Lab** (Real-world application)
6. **Advanced Labs** (Deep specialization)

## 🐍➡️ For Python Developers

Every tutorial includes:
- Side-by-side syntax comparisons
- Python equivalent code examples
- "Coming from Python" sections
- Common pitfall warnings

## 📋 Tutorial Index

See [tutorials/README.md](tutorials/README.md) for the complete tutorial catalog.

## 🏗️ Lab Index

See [labs/README.md](labs/README.md) for all hands-on projects.

## 📚 Additional Resources

See [reading/README.md](reading/README.md) for curated external resources.

## 🆘 Getting Help

- Check troubleshooting sections in each tutorial
- Review [main README](../README.md) for Docker setup
- Consult [CLAUDE.md](../CLAUDE.md) for AI assistance patterns

## 🎓 Learning Tips

1. **Hands-on practice**: Type every example yourself
2. **Experiment**: Modify examples to see what breaks
3. **Complete exercises**: Don't skip the practice problems
4. **Build projects**: Apply concepts in the labs
5. **Compare with Python**: Use comparisons to accelerate learning

Happy learning! 🚀
```

### Step 3: Create Tutorials README

Create `{LANGUAGE}/tutorials/README.md`:

```markdown
# {LANGUAGE_DISPLAY} Tutorials

Progressive learning path for mastering {LANGUAGE_DISPLAY}.

## 📋 Tutorial Catalog

### Beginner (Tutorials 1-10)

| #   | Tutorial                    | Status | Topics                            |
| --- | --------------------------- | ------ | --------------------------------- |
| 1   | Getting Started             | ⬜      | Setup, first program, environment |
| 2   | {LANGUAGE_DISPLAY} Basics   | ⬜      | Variables, types, operators       |
| 3   | Control Flow                | ⬜      | Conditionals, loops, branching    |
| 4   | Functions                   | ⬜      | Definition, parameters, returns   |
| 5   | Collections                 | ⬜      | Arrays, maps, iteration           |
| 6   | Object-Oriented Programming | ⬜      | Classes, objects, inheritance     |
| 7   | {LANGUAGE_SPECIFIC_FEATURE} | ⬜      | [Language-specific core feature]  |
| 8   | Error Handling              | ⬜      | Exceptions, error patterns        |
| 9   | File IO                     | ⬜      | Reading, writing, file operations |
| 10  | {ADVANCED_TOPIC}            | ⬜      | [First advanced topic]            |

### Intermediate (Tutorials 11-16)

| #   | Tutorial | Status | Topics        |
| --- | -------- | ------ | ------------- |
| 11  | [Topic]  | ⬜      | [Description] |
| 12  | [Topic]  | ⬜      | [Description] |
| 13  | [Topic]  | ⬜      | [Description] |
| 14  | [Topic]  | ⬜      | [Description] |
| 15  | [Topic]  | ⬜      | [Description] |
| 16  | [Topic]  | ⬜      | [Description] |

### Advanced (Tutorials 17+)

| #   | Tutorial | Status | Topics        |
| --- | -------- | ------ | ------------- |
| 17  | [Topic]  | ⬜      | [Description] |
| 18  | [Topic]  | ⬜      | [Description] |

**Legend:**
- ✅ Complete
- 🚧 In Progress
- ⬜ Planned

## 🎯 How to Use

1. Start with Tutorial 1
2. Read the README in each tutorial directory
3. Complete the exercises
4. Move sequentially through the tutorials
5. Apply concepts in corresponding labs

## 📖 Tutorial Structure

Each tutorial includes:
- **README.md** - Complete guide with examples
- **exercises/** - Practice problems and challenges
- **Python comparisons** - Side-by-side syntax examples
- **Code examples** - Runnable demonstrations

## 🐍 Python Comparison

Every tutorial includes "Coming from Python" sections with comparison tables and notes highlighting key differences.
```

### Step 4: Create Labs README

Create `{LANGUAGE}/labs/README.md`:

```markdown
# {LANGUAGE_DISPLAY} Labs

Hands-on projects to reinforce {LANGUAGE_DISPLAY} concepts through practical application.

## 🏗️ Lab Structure

### Beginner Labs (3 labs)

Small, focused projects reinforcing core concepts. Each takes 30-60 minutes.

| #   | Lab         | Topics                  | Command                              |
| --- | ----------- | ----------------------- | ------------------------------------ |
| 1   | Basics      | Variables, functions    | `make {LANGUAGE}-beginner-lab NUM=1` |
| 2   | Collections | Arrays, maps, iteration | `make {LANGUAGE}-beginner-lab NUM=2` |
| 3   | [Topic]     | [Topics]                | `make {LANGUAGE}-beginner-lab NUM=3` |

### Intermediate Lab (1 project)

Complex multi-feature application built progressively. Takes 3-5 hours.

| Project   | Topics   | Command                            |
| --------- | -------- | ---------------------------------- |
| [Project] | [Topics] | `make {LANGUAGE}-intermediate-lab` |

### Advanced Labs (4 projects)

Specialized, production-quality projects. Each takes 2-4 hours.

| #   | Lab     | Topics   | Command                              |
| --- | ------- | -------- | ------------------------------------ |
| 1   | [Topic] | [Topics] | `make {LANGUAGE}-advanced-lab NUM=1` |
| 2   | [Topic] | [Topics] | `make {LANGUAGE}-advanced-lab NUM=2` |
| 3   | [Topic] | [Topics] | `make {LANGUAGE}-advanced-lab NUM=3` |
| 4   | [Topic] | [Topics] | `make {LANGUAGE}-advanced-lab NUM=4` |

## 🎯 How to Use Labs

Each lab includes:
- **README.md** - Overview, objectives, instructions
- **STEPS.md** - Progressive building guide (intermediate/advanced)
- **starter/** - Template code (beginner)
- **solution/** - Complete implementation

## 📚 Prerequisites

- Complete corresponding tutorials before labs
- Understand Docker development workflow
- Familiarity with terminal/command line

## 🚀 Quick Start

```bash
# Start environment
make up-docker

# Run a lab
make {LANGUAGE}-beginner-lab NUM=1

# Or open shell and explore
make {LANGUAGE}-shell
cd {LANGUAGE}/labs/beginner/lab1-basics
```
```

### Step 5: Create Reading README

Create `{LANGUAGE}/reading/README.md`:

```markdown
# {LANGUAGE_DISPLAY} Reading Materials

Curated resources for deepening your {LANGUAGE_DISPLAY} knowledge.

## 📚 Official Documentation

- [{LANGUAGE_DISPLAY} Official Documentation]({OFFICIAL_DOCS_URL})
- [{LANGUAGE_DISPLAY} Language Specification]({SPEC_URL})
- [{LANGUAGE_DISPLAY} Standard Library]({STDLIB_URL})

## 🎓 Recommended Books

*To be added*

## 🎥 Video Resources

*To be added*

## 🔗 Community Resources

- [{LANGUAGE_DISPLAY} Community]({COMMUNITY_URL})
- [{LANGUAGE_DISPLAY} Forum]({FORUM_URL})
- [{LANGUAGE_DISPLAY} Slack/Discord]({CHAT_URL})

## 📝 Blog Posts and Articles

*To be added*

## 🛠️ Tools and Libraries

*To be added*

## 🐍 For Python Developers

- [Python to {LANGUAGE_DISPLAY} Guide]({GUIDE_URL})
- [Syntax Comparison Cheat Sheet]({CHEATSHEET_URL})

---

**Note:** This is a living document. Resources will be added as the learning module expands.
```

---

## ✅ Validation Checklist

After completing these steps, verify:

- [ ] Directory structure created under `{LANGUAGE}/`
- [ ] All tutorial directories (1-10) have `exercises/` subdirectories
- [ ] All lab directories created (beginner, intermediate, advanced)
- [ ] `{LANGUAGE}/README.md` exists and follows template
- [ ] `{LANGUAGE}/tutorials/README.md` exists with tutorial catalog
- [ ] `{LANGUAGE}/labs/README.md` exists with lab listing
- [ ] `{LANGUAGE}/reading/README.md` exists
- [ ] All README files use proper {LANGUAGE_DISPLAY} capitalization
- [ ] Markdown formatting is correct (no broken headers)
- [ ] File paths are workspace-relative (e.g., `{LANGUAGE}/tutorials/1-Getting-Started/`)

### Validation Commands

```bash
# Check directory structure
tree {LANGUAGE}/ -L 3

# Verify README files exist
ls -la {LANGUAGE}/*.md
ls -la {LANGUAGE}/tutorials/README.md
ls -la {LANGUAGE}/labs/README.md
ls -la {LANGUAGE}/reading/README.md

# Check markdown syntax (if available)
# markdownlint {LANGUAGE}/**/*.md
```

---

## 📝 Notes

### Language-Specific Customization

Replace these placeholders based on your language:

- `{LANGUAGE_SPECIFIC_FEATURE}` - Core unique feature
  - Ruby: "Modules-and-Mixins"
  - Dart: "Null-Safety"
  - Go: "Concurrency-Goroutines"
  - Rust: "Ownership-and-Borrowing"

- `{ADVANCED_TOPIC}` - First advanced topic
  - Ruby: "Ruby-Idioms"
  - Dart: "Async-Programming"
  - Go: "Interfaces-and-Reflection"
  - Rust: "Lifetimes-and-Traits"

- `{EXT}` - File extension
  - Ruby: `rb`
  - Dart: `dart`
  - Go: `go`
  - Rust: `rs`
  - JavaScript: `js`

### References

- Study existing structure: `ruby/` and `dart/` directories
- Follow patterns in [.templates/tutorial_template.md](../../.templates/tutorial_template.md)
- See [CLAUDE.md](../../CLAUDE.md) for content creation guidelines

---

## 🔜 Next Steps

After completing this prompt, proceed to:
- **[Phase 1.2: Create Dockerfile](02-create-dockerfile.md)**
