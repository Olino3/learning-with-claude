# Claude AI Instructions for learning-with-claude

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

## 📁 Repository Structure

```
learning-with-claude/
├── ruby/                          # PRIMARY FOCUS - extensive content
│   ├── tutorials/                # 23 progressive tutorials
│   │   ├── 1-Getting-Started/   # Basics (1-10)
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
├── .claude/                     # Claude configuration
│   ├── rules/                   # Focused instruction files
│   └── settings.json
└── Infrastructure files         # Docker, Makefile, etc.
```

## 🛠️ Development Environment

**Containerized Setup:**
- Ruby 3.4.7 container (`ruby-dev`)
- Dart SDK container (`dart-env`)
- Sinatra web container (`sinatra-web`)
- PostgreSQL database (`postgres`)
- Redis cache (`redis`)

**Key Makefile Commands:**
```bash
make up              # Start with Tilt (recommended)
make shell           # Ruby container shell
make repl            # Ruby IRB REPL
make run-script SCRIPT=path/to/script.rb
make test            # Run tests
make sinatra-tutorial NUM=1
```

See `Makefile` for 40+ additional commands.

**Important:** All code runs in containers. Never suggest local Ruby/Dart installations.

## 📚 Essential Templates

**Tutorial Structure:** `.templates/tutorial_template.md`
- Title & Introduction
- Learning Objectives (6-8 items)
- Prerequisites
- Python Comparison Table
- Deep Dive Sections (4-6)
- Challenges
- Further Reading
- Exercise file (300-500 lines)

**Lab Structure:** `.templates/lab_template.md`
- README.md (Complete overview)
- STEPS.md (6-9 incremental steps)
- solution/ directory (complete code)
- steps/ directory (progressive implementations)
- challenges/ directory (extension exercises)

## 🎓 Core Principles

### Content Creation

1. **Use plan mode first** - Outline before implementing
2. **Research similar content** - Maintain consistency
3. **Follow templates** - Use `.templates/` as guides
4. **Include Python comparisons** - Every major section
5. **Create executable examples** - All code must run
6. **Progressive complexity** - Simple → Intermediate → Advanced
7. **Update cross-references** - Keep navigation current

### Code Quality

- All code runs successfully in containers
- Follows language idioms (Ruby/Dart, not translated Python)
- Includes working examples with expected output
- Properly formatted (2 spaces, consistent style)
- Practical, real-world usage (not toy examples)

### Python Comparisons

Every tutorial helps Python developers by including:
- Comparison tables (Python vs Ruby/Dart)
- "📘 Python Note:" callouts (minimum 3-4 per tutorial)
- Mental model bridges (translate concepts, not just syntax)
- Common pitfall warnings (false friends, truthiness, etc.)

## 📋 Quick Reference Checklists

### Tutorial Checklist
- [ ] Learning objectives clearly stated
- [ ] Prerequisites listed (if any)
- [ ] Python comparison table included
- [ ] 4-6 deep dive sections
- [ ] Python Note callouts throughout
- [ ] Challenges section
- [ ] Exercise file created and validated
- [ ] Added to main tutorials README

### Lab Checklist
- [ ] Clear learning objectives
- [ ] Estimated time to complete
- [ ] Complete solution implemented and tested
- [ ] STEPS.md with 6-9 incremental steps
- [ ] Checkpoint validation for each step
- [ ] Challenges with TODO markers
- [ ] Added to main labs README

### Quality Standards
- [ ] All code examples run successfully
- [ ] Python comparisons included
- [ ] Follows repository patterns
- [ ] Cross-references updated
- [ ] Markdown properly formatted
- [ ] No broken links
- [ ] Appropriate emoji usage

## 🤖 Detailed Instructions

**This CLAUDE.md provides essential context and quick reference. For detailed workflows and patterns, see:**

### Content Creation Patterns
→ `.claude/rules/content-creation.md`
- Tutorial structure and creation workflow
- Lab structure and building progressive labs
- Student code review guidelines
- Exercise validation

### Code Style & Conventions
→ `.claude/rules/code-style.md`
- Ruby idiomatic patterns and anti-patterns
- Dart idiomatic patterns and anti-patterns
- Container-first development
- Language-specific examples

### Python Comparison Guidelines
→ `.claude/rules/python-comparisons.md`
- Comparison table patterns
- Python Note callout usage
- Mental model bridges
- Common pitfalls to highlight
- Key differences (truthiness, blocks, methods)

### AI Workflow Guidance
→ `.claude/rules/workflows.md`
- Plan mode and implementation mode
- Common workflows (tutorials, labs, updates)
- Customizing learning paths
- Key files for context
- MCP server integration
- Continuous improvement

### Quality Standards & Writing Style
→ `.claude/rules/quality-standards.md`
- Quality checklists
- Writing tone and style
- Code example standards
- Emoji usage guidelines
- Markdown standards
- Testing requirements
- Cross-reference patterns

## 🚀 Common Tasks

### Creating a Tutorial

1. Use plan mode to outline structure
2. Read `.claude/rules/content-creation.md`
3. Use `.templates/tutorial_template.md` as base
4. Follow `.claude/rules/python-comparisons.md` for comparisons
5. Apply `.claude/rules/code-style.md` conventions
6. Validate with `scripts/validate_exercise.rb`
7. Check `.claude/rules/quality-standards.md` before completion

### Building a Lab

1. Plan complete solution architecture
2. Implement solution/ directory fully
3. Break into 6-9 logical steps (see `.claude/rules/content-creation.md`)
4. Create STEPS.md with checkpoints
5. Follow `.claude/rules/quality-standards.md` for testing
6. Add challenges with TODO markers

### Helping a Learner

1. Assess background (see `.claude/rules/workflows.md` → Customizing Learning Paths)
2. Review student code against solution/ directory
3. Encourage language idioms (see `.claude/rules/code-style.md`)
4. Point to relevant tutorials
5. Be encouraging - learning new languages is hard!

## 📍 Navigation Quick Links

**Essential Files:**
- `README.md` - Project overview
- `ruby/tutorials/README.md` - Ruby learning path
- `ruby/labs/README.md` - Lab overview
- `Makefile` - All available commands
- `docker-compose.yml` - Environment architecture

**Templates:**
- `.templates/tutorial_template.md` - Tutorial structure (225 lines)
- `.templates/lab_template.md` - Lab structure (363 lines)

**Rules (Detailed Instructions):**
- `.claude/rules/content-creation.md` - Content patterns
- `.claude/rules/code-style.md` - Language conventions
- `.claude/rules/python-comparisons.md` - Comparison guidelines
- `.claude/rules/workflows.md` - AI workflows
- `.claude/rules/quality-standards.md` - Quality & style

**Other:**
- `docs/AI_WORKFLOW.md` - Detailed agentic workflows
- `scripts/validate_exercise.rb` - Exercise checker

---

**Remember:** Your goal is to help developers become confident Ruby and Dart programmers by providing clear, progressive, practical learning experiences with explicit bridges from Python where relevant.

**Context Management:** This CLAUDE.md provides the essential overview. Refer to `.claude/rules/*` files for detailed instructions on specific topics. This keeps context focused and files under 300 lines.
