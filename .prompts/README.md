# Progressive Prompt Templates for Language Learning Modules

This directory contains **AI agent prompt templates** for systematically building complete language learning modules for the `learning-with-claude` repository.

---

## 🎯 Purpose

These prompts enable:
- **Consistent structure** across all language modules
- **AI-assisted content generation** with clear guidelines
- **Reproducible workflows** for adding new languages
- **Quality control** through validation checklists
- **Educational best practices** embedded in templates

---

## 📋 How to Use These Prompts

### Step 1: Choose Your Language

Decide which programming language you're adding:
- Go, Rust, JavaScript, Kotlin, TypeScript, etc.
- Ensure it's a general-purpose language suitable for tutorials

### Step 2: Follow the Phases Sequentially

Work through phases **1 → 7 in order**. Each phase builds on previous work:

| Phase | Description                           | Time Estimate | Files Created        |
| ----- | ------------------------------------- | ------------- | -------------------- |
| **1** | Environment Setup                     | 2-4 hours     | 4 Docker/config      |
| **2** | Makefile Integration                  | 1-2 hours     | 3 command groups     |
| **3** | Beginner Tutorials (1-10)             | 20-40 hours   | 10 tutorials         |
| **4** | Intermediate Tutorials (11-16)        | 15-30 hours   | 6 tutorials          |
| **5** | Advanced Tutorials (17-23)            | 20-40 hours   | 7 tutorials          |
| **6** | Framework Tutorials (optional)        | 15-25 hours   | 8 tutorials + 4 labs |
| **7** | Labs (Beginner/Intermediate/Advanced) | 15-30 hours   | 8 labs               |

**Total Estimate:** 88-171 hours for complete module

### Step 3: Use Variable Substitution

All prompts use `{VARIABLE}` placeholders. Replace before using:

#### Required Variables

- `{LANGUAGE}` - Lowercase name: `go`, `rust`, `javascript`, `kotlin`
- `{LANGUAGE_DISPLAY}` - Proper case: `Go`, `Rust`, `JavaScript`, `Kotlin`
- `{VERSION}` - Language version: `1.21`, `1.75`, `20`, `1.9`
- `{EXT}` - File extension: `go`, `rs`, `js`, `kt`

#### Environment Variables

- `{BASE_IMAGE}` - Docker base image: `golang:1.21-slim`, `rust:1.75-slim`
- `{PACKAGE_MANAGER}` - Package manager: `go get`, `cargo install`, `npm install`
- `{DEPENDENCY_FILE}` - Manifest file: `go.mod`, `Cargo.toml`, `package.json`
- `{CACHE_PATH}` - Package cache: `/go/pkg`, `~/.cargo`, `/root/.npm`
- `{RUN_COMMAND}` - Execution command: `go run`, `cargo run`, `node`
- `{REPL_COMMAND}` - Interactive REPL: `node`, `python`, `evcxr`

#### Framework Variables (Phase 6 only)

- `{FRAMEWORK}` - Framework name (lowercase): `gin`, `axum`, `express`, `flask`
- `{FRAMEWORK_DISPLAY}` - Display name: `Gin`, `Axum`, `Express`, `Flask`
- `{PORT}` - Primary port: `8090`, `8100`, `3001`, `5000`

#### Documentation Variables

- `{DOCS_URL}` - Official docs: `https://go.dev/doc/`
- `{API_URL}` - API reference: `https://pkg.go.dev/std`
- `{COMMUNITY_URL}` - Community site: `https://go.dev/`

#### Language-Specific Variables

- `{LANGUAGE_SPECIFIC_FEATURE}` - Tutorial 7 topic:
  - Ruby: `Modules-and-Mixins`
  - Dart: `Null-Safety`
  - Go: `Concurrency-Goroutines`
  - Rust: `Ownership-and-Borrowing`

- `{ADVANCED_TOPIC}` - Tutorial 10 topic:
  - Ruby: `Ruby-Idioms`
  - Dart: `Async-Programming`
  - Go: `Interfaces-and-Reflection`
  - Rust: `Lifetimes-and-Traits`

### Step 4: Execute with AI Agent or Manually

**Option A: Use with AI Agent (Recommended)**

Copy the entire prompt from a phase file and provide it to an AI coding agent (like Claude, GPT-4, or GitHub Copilot). The agent will:
- Research the language
- Generate all required files
- Follow validation checklists
- Create consistent, high-quality content

**Option B: Manual Implementation**

Use prompts as structured guidelines for manual content creation. Follow steps methodically, referring to existing Ruby/Dart examples.

---

## 📁 Directory Structure

```
.prompts/
├── README.md                       # This file
├── EXAMPLE_WORKFLOW.md             # Complete Go example
│
├── 1-environment-setup/
│   ├── 01-create-language-folder.md
│   ├── 02-create-dockerfile.md
│   ├── 03-update-docker-compose.md
│   └── 04-update-tiltfile.md
│
├── 2-makefile-integration/
│   ├── 01-add-core-commands.md
│   ├── 02-add-lab-commands.md
│   └── 03-add-framework-commands.md
│
├── 3-beginner-tutorials/
│   └── README.md                   # Master prompt for tutorials 1-10
│
├── 4-intermediate-tutorials/
│   └── README.md                   # Master prompt for tutorials 11-16
│
├── 5-advanced-tutorials/
│   └── README.md                   # (Covered in 4-intermediate-tutorials)
│
├── 6-framework-tutorials/
│   └── README.md                   # Master prompt for framework track
│
└── 7-labs/
    └── README.md                   # Master prompt for all labs
```

---

## 🔄 Workflow Patterns

### Atomic Prompts (Phases 1-2)

Phases 1 and 2 use **atomic prompts**—each prompt creates/modifies a single file:

```
Phase 1.1 → Create language folder structure
Phase 1.2 → Create Dockerfile.{LANGUAGE}
Phase 1.3 → Update docker-compose.yml
Phase 1.4 → Update Tiltfile
```

**Benefit:** Precise control, easy to debug, incremental progress.

### Multi-Step Prompts (Phases 3-7)

Phases 3-7 use **master prompts** that generate multiple files:

```
Phase 3 → Generate all 10 beginner tutorials
Phase 4-5 → Generate 13 intermediate/advanced tutorials
Phase 6 → Generate 8 framework tutorials + 4 labs
Phase 7 → Generate 8 labs (all levels)
```

**Benefit:** Faster completion, consistent style, comprehensive planning.

### Hybrid Approach

You can mix approaches:
- Use **master prompts** for speed
- Use **atomic prompts** for problematic sections
- Regenerate individual tutorials if needed

---

## ✅ Validation Strategy

Every prompt includes a **Validation Checklist** at the end. Use it to ensure quality:

### Phase 1-2 Validation (Technical)

- [ ] Docker builds successfully
- [ ] Container starts and runs
- [ ] Commands execute without errors
- [ ] Ports don't conflict
- [ ] YAML/Makefile syntax valid

```bash
# Example validation
docker compose build {LANGUAGE}-env
docker compose up -d {LANGUAGE}-env
docker compose ps | grep {LANGUAGE}
make {LANGUAGE}-shell
```

### Phase 3-7 Validation (Content)

- [ ] Files follow templates exactly
- [ ] Python comparisons included
- [ ] Code examples tested and working
- [ ] Markdown properly formatted
- [ ] Cross-references accurate
- [ ] Estimated times provided
- [ ] Learning objectives clear

```bash
# Example validation
make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/hello.{EXT}
grep -l "📋 Learning Objectives" {LANGUAGE}/tutorials/*/README.md | wc -l
```

---

## 📚 Essential References

Before using these prompts, familiarize yourself with:

### Repository Documentation

- [README.md](../README.md) - Repository overview
- [CLAUDE.md](../CLAUDE.md) - Content creation guidelines
- [docs/AI_WORKFLOW.md](../docs/AI_WORKFLOW.md) - Detailed AI workflows
- [.github/copilot-instructions.md](../.github/copilot-instructions.md) - Coding conventions

### Templates

- [.templates/tutorial_template.md](../.templates/tutorial_template.md) - Tutorial structure
- [.templates/lab_template.md](../.templates/lab_template.md) - Lab structure

### Existing Examples

**Ruby (Most Complete):**
- [ruby/tutorials/1-Getting-Started/](../ruby/tutorials/1-Getting-Started/)
- [ruby/tutorials/2-Ruby-Basics/](../ruby/tutorials/2-Ruby-Basics/)
- [ruby/labs/beginner/lab1-basics/](../ruby/labs/beginner/lab1-basics/)
- [ruby/labs/intermediate-lab/](../ruby/labs/intermediate-lab/)
- [ruby/tutorials/sinatra/](../ruby/tutorials/sinatra/)

**Dart (Good Alternative Patterns):**
- [dart/tutorials/2-Dart-Basics/](../dart/tutorials/2-Dart-Basics/)
- [dart/tutorials/7-Null-Safety/](../dart/tutorials/7-Null-Safety/)

---

## 🎯 Quality Guidelines

### Content Quality

1. **Accuracy:** All code must be tested and working
2. **Clarity:** Explanations should be beginner-friendly
3. **Completeness:** Follow templates without shortcuts
4. **Consistency:** Match existing Ruby/Dart patterns
5. **Python Focus:** Always include Python comparisons

### Code Quality

1. **Idiomatic:** Use language best practices
2. **Commented:** Explain non-obvious code
3. **Runnable:** All examples must execute without errors
4. **Modern:** Use current language features/versions
5. **Secure:** Follow security best practices

### Educational Quality

1. **Progressive:** Build concepts sequentially
2. **Hands-On:** Emphasize practice over theory
3. **Realistic:** Use real-world examples
4. **Challenging:** Include exercises that stretch learners
5. **Supportive:** Provide hints and troubleshooting

---

## 🚀 Quick Start Guide

### For AI Agents

```
1. Read this README completely
2. Start with Phase 1.1
3. Substitute all {VARIABLES} with actual values
4. Execute the prompt
5. Run validation commands
6. Proceed to next prompt only after validation passes
7. Repeat through all phases
```

### For Human Developers

```
1. Study existing Ruby/Dart modules thoroughly
2. Prepare language-specific documentation links
3. Set up local Docker environment
4. Work through phases 1-2 to establish infrastructure
5. Use AI agents for phases 3-7 content generation
6. Review and test all generated content
7. Iterate on quality issues
```

---

## 🔧 Troubleshooting

### "Docker build fails"

- Check base image availability: `docker pull {BASE_IMAGE}`
- Verify Dockerfile syntax
- Review cache mount paths
- Check network connectivity

### "Generated content doesn't follow template"

- Re-read the template file explicitly in prompt
- Provide specific examples from Ruby/Dart
- Break into smaller prompts
- Manually correct and use as example

### "Python comparisons are inaccurate"

- Instruct agent to research official Python docs
- Provide correct comparison examples
- Review and correct manually
- Document language-specific quirks

### "Code examples don't run"

- Test in Docker container (not local environment)
- Check language version matches
- Verify all dependencies installed
- Review error messages for missing packages

---

## 📊 Success Metrics

A successful language module should have:

- [ ] All 7 phases complete
- [ ] 100% of tutorials/labs tested and working
- [ ] Docker environment builds without errors
- [ ] All Makefile commands functional
- [ ] Python comparisons in every tutorial
- [ ] No broken links or references
- [ ] Consistent formatting throughout
- [ ] Clear learning progression
- [ ] Comprehensive validation completed

---

## 🤝 Contributing

When adding new languages using these prompts:

1. **Test thoroughly** before submitting
2. **Follow all validation checklists**
3. **Maintain consistency** with existing modules
4. **Document any language-specific quirks**
5. **Update this README** if you improve prompts

---

## 📝 Version History

- **v1.0** (2026-01-15): Initial prompt template system created
  - 7 phases covering environment setup through labs
  - Hybrid approach (atomic + multi-step prompts)
  - Comprehensive validation checklists
  - Variable substitution system
  - Example workflow (Go)

---

## 🔗 Related Documentation

- [EXAMPLE_WORKFLOW.md](EXAMPLE_WORKFLOW.md) - Complete walkthrough for adding Go
- [../docs/AI_WORKFLOW.md](../docs/AI_WORKFLOW.md) - General AI workflows
- [../CLAUDE.md](../CLAUDE.md) - AI assistant instructions
- [../README.md](../README.md) - Main repository README

---

**Happy learning module creation! 🚀**

For questions or improvements, consult the repository maintainers or refer to existing Ruby/Dart modules as canonical examples.
