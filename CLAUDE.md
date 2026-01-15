# Claude AI Instructions for learning-with-claude Repository

This is a **multi-language learning repository** designed to teach Ruby and Dart to developers (especially those coming from Python). Your role is to help create high-quality educational content and assist learners in their journey.

## 🎯 Repository Purpose

**Primary Goal:** Provide progressive, hands-on learning experiences for Ruby and Dart programming, with explicit comparisons for Python developers.

**Target Audience:** Developers transitioning from Python to Ruby/Dart, or learning these languages from scratch with programming experience.

**Learning Philosophy:**
- Progressive complexity (Beginner → Intermediate → Advanced)
- Two-track approach: Complete overview (README) + Incremental building (STEPS.md)
- Git-based milestones (commits represent learning checkpoints)
- Container-first development (no local language installations needed)
- Testing emphasis (run frequently, check after each step)
- Python comparison throughout (mental models, syntax differences, equivalent patterns)

## 📁 Directory Structure

```
learning-with-claude/
├── ruby/                          # PRIMARY FOCUS - extensive content
│   ├── tutorials/                # 23 progressive tutorials
│   │   ├── 1-Getting-Started/   # Basics (1-10)
│   │   ├── ...
│   │   ├── 11-16.../            # Intermediate
│   │   ├── advanced/            # Advanced (17-23)
│   │   └── sinatra/             # Web framework track
│   ├── labs/                    # Hands-on projects
│   │   ├── beginner/            # 3 beginner labs
│   │   ├── intermediate-lab/   # Blog system
│   │   ├── advanced/            # 4 advanced labs
│   │   └── sinatra/             # 4 web app labs
│   └── reading/                 # Reference materials
├── dart/                         # SECONDARY - less content currently
│   ├── tutorials/               # 10 tutorials
│   ├── labs/                    # Minimal content (expansion opportunity)
│   └── reading/
├── scripts/                     # Quick test scripts
├── docs/                        # Documentation
├── .templates/                  # Content creation templates
└── Infrastructure files         # Docker, Makefile, etc.
```

## 🎓 Learning Methodology

### Tutorial Structure

Every tutorial follows this pattern:

1. **Title & Introduction** - Clear topic statement
2. **📋 Learning Objectives** - Bulleted list (6-8 items)
3. **🎯 Prerequisites** - What to complete first (if applicable)
4. **🐍➡️🔴 Coming from Python** - Comparison table (Python vs Ruby/Dart)
5. **📝 Deep Dive Sections** (4-6 major topics)
   - Concept explanation
   - Code examples with output
   - "📘 Python Note:" callouts throughout
   - Practical use cases
6. **🎯 Challenges** - Practice exercises
7. **📚 Further Reading** - Links to resources

**Exercise Format:**
- Single `.rb` or `.dart` file in `exercises/` directory
- 300-500 lines typically
- Multiple numbered examples (Example 1, 2, 3...)
- Executable demonstrations
- Progressive difficulty

### Lab Structure

Labs provide hands-on projects with two approaches:

**Approach 1: README.md (Complete Overview)**
- Full project description
- Learning objectives
- Complete solution code
- Testing instructions
- Challenges/extensions

**Approach 2: STEPS.md (Incremental Building)**
- 6-9 progressive steps
- Each step builds on previous
- Git commit after each step
- Checkpoints for validation
- Gradual complexity increase

**Directory Structure:**
```
lab-name/
├── README.md           # Complete overview
├── STEPS.md           # Step-by-step guide
├── solution/          # Complete working code
├── steps/             # Progressive implementations
│   ├── step1/
│   ├── step2/
│   └── ...
└── challenges/        # Optional extensions with TODOs
```

## 🛠️ Development Environment

**Containerized Setup:**
- Ruby 3.4.7 container (`ruby-dev`)
- Dart SDK container (`dart-env`)
- Sinatra web container (`sinatra-web`)
- PostgreSQL database (`postgres`)
- Redis cache (`redis`)

**Key Makefile Commands:**
- `make up` - Start with Tilt (recommended)
- `make shell` - Ruby container shell
- `make repl` - Ruby IRB REPL
- `make run-script SCRIPT=path/to/script.rb` - Run Ruby script
- `make test` - Run tests
- `make sinatra-tutorial NUM=1` - Run Sinatra tutorial
- See Makefile for 40+ additional commands

**Important:** All code runs in containers. Never suggest local Ruby/Dart installations.

## 📝 Content Creation Patterns

### When Creating Tutorials

1. **Use plan mode first** to outline structure
2. **Research similar tutorials** in the repository for consistency
3. **Follow the template** in `.templates/tutorial_template.md`
4. **Include Python comparisons** in every major section
5. **Create executable examples** - all code must run
6. **Progressive complexity** - simple → intermediate → advanced
7. **Add to main README** - Update `ruby/tutorials/README.md` or `dart/tutorials/README.md`

**Tutorial Checklist:**
- [ ] Learning objectives clearly stated
- [ ] Prerequisites listed (if any)
- [ ] Python comparison table included
- [ ] 4-6 deep dive sections
- [ ] Code examples with output comments
- [ ] Python Note callouts throughout
- [ ] Challenges section
- [ ] Further reading links
- [ ] Exercise file created in exercises/ directory
- [ ] Added to main tutorials README with ✅ status

### When Creating Labs

1. **Plan the complete solution first**
2. **Break into 6-9 logical steps**
3. **Follow the template** in `.templates/lab_template.md`
4. **Create both README.md and STEPS.md**
5. **Implement solution/ directory fully**
6. **Create incremental steps/** directories
7. **Add checkpoints** after each step
8. **Include challenges** with TODO markers

**Lab Checklist:**
- [ ] Clear learning objectives
- [ ] Estimated time to complete
- [ ] Complete solution implemented and tested
- [ ] STEPS.md with 6-9 incremental steps
- [ ] Each step has checkpoint validation
- [ ] Challenges section with extension ideas
- [ ] Python comparisons (if applicable)
- [ ] Added to main labs README
- [ ] Docker/database setup documented (if needed)

### When Reviewing Student Code

1. **Load exercise context** - Read the relevant tutorial/lab README
2. **Compare to solution** - Check against solution/ directory (if exists)
3. **Identify learning gaps** - What concepts are misunderstood?
4. **Suggest next steps** - Point to relevant tutorials
5. **Encourage Ruby/Dart idioms** - Not Python patterns translated literally
6. **Provide examples** - Show the idiomatic way
7. **Be encouraging** - Learning new languages is hard!

## 🤖 Workflow Guidance

### Default Mode: Plan Mode

**Always start with planning** when creating new content:
- Outline structure before implementation
- Research similar content in the repository
- Identify prerequisites and dependencies
- Plan Python comparisons
- Break complex tasks into steps

### Implementation Mode

After planning, implement systematically:
- Create files in logical order
- Test code examples as you write them
- Update cross-references
- Run validation scripts
- Commit logical chunks

### Sequential Thinking for Step-by-Step Guides

When creating STEPS.md or progressive tutorials:
- Use the Sequential Thinking MCP server
- Break complex concepts into digestible chunks
- Each step should be independently testable
- Include checkpoints for validation
- Ensure each step builds naturally on previous

## 🔍 Code Style and Conventions

### Ruby Conventions

**Idiomatic Ruby:**
- Use iterators (`.each`, `.map`, `.select`) not `for` loops
- Prefer symbols over strings for identifiers
- Use implicit returns
- Statement modifiers for simple conditions: `do_something if condition`
- Use blocks extensively
- Follow Ruby style guide (2 space indentation, snake_case)

**Anti-patterns to avoid:**
- Python-style `for` loops
- Explicit `return` everywhere (use implicit)
- Verbose conditionals when modifiers suffice
- String keys where symbols are better
- Missing blocks when Ruby APIs expect them

### Dart Conventions

**Idiomatic Dart:**
- Use null safety features (`?`, `!`, `??`)
- Prefer `final` over `var` when appropriate
- Use named parameters for clarity
- Cascade notation (`..`) for method chaining
- Async/await for asynchronous code
- Follow Dart style guide (2 space indentation, camelCase)

**Anti-patterns to avoid:**
- Ignoring null safety
- Python-style naming conventions
- Missing `async`/`await` keywords
- Not using Dart's built-in collection methods

## 📘 Python Comparison Guidelines

Every tutorial should help Python developers by:

1. **Comparison Tables** - At the start of each major section
   ```markdown
   | Python | Ruby | Notes |
   |--------|------|-------|
   | `for item in list:` | `list.each do \|item\|` | Ruby uses blocks |
   ```

2. **Python Note Callouts** - Throughout the content
   ```markdown
   📘 **Python Note:** Ruby's `elsif` is like Python's `elif`, but
   note the spelling difference. Also, Ruby uses `end` instead of
   indentation to close blocks.
   ```

3. **Mental Model Bridges** - Help translate concepts
   ```markdown
   If you're used to Python's list comprehensions `[x*2 for x in nums]`,
   Ruby's equivalent is `nums.map { |x| x * 2 }`.
   ```

4. **Common Pitfalls** - Warn about differences
   ```markdown
   ⚠️ **Python developers beware:** In Ruby, only `false` and `nil`
   are falsy. Unlike Python, `0`, `""`, and `[]` are all truthy!
   ```

## 🧪 Exercise Validation

Use `scripts/validate_exercise.rb` to check student solutions:

```bash
# Validate a specific exercise
ruby scripts/validate_exercise.rb ruby/tutorials/5-Collections/exercises/collections_practice.rb

# Validate all exercises in a tutorial
ruby scripts/validate_exercise.rb ruby/tutorials/5-Collections/
```

The validator checks:
- ✅ Syntax correctness
- ✅ Code runs without errors
- ✅ Expected output matches (if test cases defined)
- ✅ Ruby/Dart idioms followed (basic checks)

## 🎯 Common AI Workflows

### Creating a New Tutorial

1. Use plan mode to outline
2. Read similar tutorials for pattern consistency
3. Use `.templates/tutorial_template.md` as base
4. Implement progressive sections
5. Create exercise file with examples
6. Test all code examples
7. Add Python comparisons
8. Update main tutorials README
9. Validate with `scripts/validate_exercise.rb`

### Building a Progressive Lab

1. Plan complete solution architecture
2. Implement solution/ directory fully
3. Test the complete solution
4. Break into 6-9 logical steps
5. Create incremental steps/ directories
6. Write STEPS.md with checkpoints
7. Add challenges with TODOs
8. Update main labs README
9. Create git commits for each step (as examples)

### Updating Existing Content

1. Check related tutorials for consistency
2. Search for cross-references that need updating
3. Update with new patterns
4. Test all code examples still work
5. Update version numbers (if Ruby/Dart version changed)
6. Update Python comparisons (if Python syntax changed)
7. Validate exercises still run
8. Update documentation dates

### Customizing Learning Paths

When a learner asks "Where should I start?" or "What should I learn?":

1. **Assess background:**
   - Programming experience level (beginner/intermediate/advanced)
   - Python experience (none/some/expert)
   - Goals (web dev/systems programming/data processing/learning for fun)
   - Time available (weekend learner/intensive/casual)

2. **Recommend path:**
   - **Ruby beginner:** Tutorials 1-10 → Beginner labs → Continue
   - **Python expert:** Tutorials 2-5 (skip 1) → Focus on Ruby-specific (6-7, 11-14)
   - **Web development:** Tutorials 1-9 → Sinatra tutorials → Sinatra labs
   - **Advanced topics:** Tutorials 1-10 (quick review) → Advanced tutorials 17-23 → Advanced labs
   - **Dart beginner:** Dart tutorials 1-10
   - **Dart + Flutter:** Dart tutorials 1-10 → (Future: Flutter content)

3. **Personalize:**
   - Skip redundant content if experienced
   - Suggest skimming vs deep study
   - Point to specific sections relevant to goals
   - Recommend labs that match interests

## 📚 Key Files for Context

When working on content, reference these:

**Essential:**
- `README.md` - Project overview
- `ruby/tutorials/README.md` - Ruby learning path
- `ruby/labs/README.md` - Lab overview
- `Makefile` - All available commands
- `docker-compose.yml` - Environment architecture

**Templates:**
- `.templates/tutorial_template.md` - Tutorial structure
- `.templates/lab_template.md` - Lab structure

**Workflows:**
- `docs/AI_WORKFLOW.md` - Detailed agentic workflows

**Validation:**
- `scripts/validate_exercise.rb` - Exercise checker

## 🚀 MCP Server Integration

This repository works best with these MCP servers enabled:

- **Filesystem** - Reading/writing tutorial and exercise files
- **Git** - Tracking learning milestones, managing branches
- **Sequential Thinking** - Breaking complex concepts into steps
- **PostgreSQL** - For Sinatra lab database work
- **Memory** (optional) - Tracking learner progress across sessions
- **Brave Search** (optional) - Finding Ruby/Dart documentation

See `.mcp/recommended_servers.md` for setup instructions.

## ✅ Quality Standards

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

## 🎨 Writing Style

- **Clear and concise** - Respect learner's time
- **Encouraging** - Learning is a journey
- **Practical** - Real examples, not toy code
- **Progressive** - Build on previous knowledge
- **Comparative** - Always bridge to Python when relevant
- **Visual** - Use emoji, tables, code blocks effectively
- **Tested** - Every code example must work

## 🔄 Continuous Improvement

This repository is living content. When you notice:

- **Outdated patterns** - Update to modern Ruby/Dart idioms
- **Missing comparisons** - Add Python bridges
- **Gaps in progression** - Suggest intermediate tutorials
- **Better explanations** - Improve clarity
- **New features** - Add tutorials for new language features

Always maintain consistency with existing content while improving quality.

---

**Remember:** Your goal is to help developers become confident Ruby and Dart programmers by providing clear, progressive, practical learning experiences with explicit bridges from Python where relevant.
