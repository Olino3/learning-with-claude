# Contributing to learning-with-claude

Thank you for your interest in contributing to **learning-with-claude**! This repository helps developers learn new programming languages through progressive tutorials, hands-on labs, and Docker-based development environments.

We welcome contributions of all kinds: new language modules, tutorial improvements, bug fixes, documentation enhancements, and more.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Adding a New Language Module](#adding-a-new-language-module)
- [Improving Existing Content](#improving-existing-content)
- [Development Workflow](#development-workflow)
- [Quality Standards](#quality-standards)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Getting Help](#getting-help)

---

## 🤝 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. We expect all contributors to:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or discriminatory comments
- Publishing others' private information without permission
- Any conduct that could reasonably be considered inappropriate in a professional setting

### Enforcement

Violations can be reported to the project maintainers. All complaints will be reviewed and investigated promptly and fairly.

---

## 🎯 How Can I Contribute?

### 1. Adding a New Language Module

**Best for:** Contributors wanting to add Go, Rust, TypeScript, Kotlin, or other languages.

See the dedicated section: [Adding a New Language Module](#adding-a-new-language-module)

### 2. Improving Existing Content

**Examples:**
- Fix typos or grammar in tutorials
- Improve code examples for clarity
- Add more Python comparison notes
- Enhance exercise challenges
- Update documentation

**Process:**
1. Fork the repository
2. Create a feature branch: `git checkout -b fix/improve-ruby-tutorial-3`
3. Make your changes
4. Test in Docker: `make up-docker && make ruby-shell`
5. Submit a pull request

### 3. Reporting Bugs

**Found an issue?** Please open a GitHub issue with:
- Clear title and description
- Steps to reproduce
- Expected vs. actual behavior
- Environment details (OS, Docker version)
- Screenshots if applicable

### 4. Suggesting Enhancements

**Have an idea?** Open an issue tagged `enhancement` with:
- Clear use case
- Detailed description
- Examples or mockups if applicable
- Benefits to learners

### 5. Improving Documentation

**Help others learn better:**
- Clarify confusing sections
- Add troubleshooting guides
- Create video walkthroughs
- Write blog posts about your learning journey

---

## 🚀 Adding a New Language Module

We've created a comprehensive set of **prompt templates** to guide AI-assisted language module creation. This is the recommended approach for adding new languages.

### Prerequisites

Before starting:
- [ ] Docker and Docker Compose installed
- [ ] Familiarity with the target language
- [ ] Read [.prompts/README.md](.prompts/README.md)
- [ ] Review [.prompts/EXAMPLE_WORKFLOW.md](.prompts/EXAMPLE_WORKFLOW.md)

### Quick Start

1. **Review the Example Workflow**

   ```bash
   # Read the complete Go language example
   cat .prompts/EXAMPLE_WORKFLOW.md
   ```

2. **Define Your Variables**

   Create a variable substitution table (see `.prompts/README.md`):

   ```
   {LANGUAGE} = rust
   {LANGUAGE_DISPLAY} = Rust
   {VERSION} = 1.75
   {EXT} = rs
   {BASE_IMAGE} = rust:1.75-slim
   # ... etc.
   ```

3. **Follow the 7 Phases**

   | Phase                      | Prompts          | Time Est.         |
   | -------------------------- | ---------------- | ----------------- |
   | 1: Environment Setup       | 4 atomic prompts | 4-6 hours         |
   | 2: Makefile Integration    | 3 atomic prompts | 2-3 hours         |
   | 3: Beginner Tutorials      | 1 master prompt  | 30-40 hours       |
   | 4-5: Intermediate/Advanced | 1 master prompt  | 35-45 hours       |
   | 6: Framework Tutorials     | 1 master prompt  | 20-25 hours       |
   | 7: Labs                    | 1 master prompt  | 20-30 hours       |
   | **Total**                  | -                | **111-149 hours** |

4. **Execute Each Phase Sequentially**

   ```bash
   # Phase 1.1: Create folder structure
   # Use .prompts/1-environment-setup/01-create-language-folder.md

   # Phase 1.2: Create Dockerfile
   # Use .prompts/1-environment-setup/02-create-dockerfile.md

   # ... continue through all phases
   ```

5. **Validate After Each Phase**

   Each prompt includes validation checklists. Example:

   ```bash
   # After Phase 1.2 (Dockerfile)
   docker build -f Dockerfile.rust -t learning-rust:test .
   docker run --rm learning-rust:test rustc --version
   ```

6. **Test the Complete Module**

   ```bash
   make down
   make build
   make up-docker
   make rust-shell  # Test shell access
   make run-rust SCRIPT=rust/tutorials/1-Getting-Started/hello.rs
   make rust-beginner-lab NUM=1
   ```

### What to Include

Your language module should contain:

**Minimum Requirements:**
- ✅ Docker environment (Dockerfile, docker-compose service)
- ✅ Makefile commands (shell, repl, run-script, labs)
- ✅ 10 beginner tutorials
- ✅ 3 beginner labs
- ✅ README.md with overview
- ✅ All code tested and working

**Highly Recommended:**
- ✅ 13 intermediate/advanced tutorials (11-23)
- ✅ 1 intermediate lab
- ✅ 4 advanced labs
- ✅ Python comparison notes throughout
- ✅ Framework tutorials (8 tutorials + 4 labs)

**Optional but Valuable:**
- Reading materials and resources
- Video tutorial links
- Community discussion links
- Cheat sheets

### Quality Checklist

Before submitting your language module PR:

- [ ] All code runs successfully in Docker
- [ ] Makefile commands work as expected
- [ ] README files are complete and well-formatted
- [ ] Python comparisons are accurate (if included)
- [ ] Tutorial progression is logical (beginner → advanced)
- [ ] Lab STEPS.md files guide progressive building
- [ ] No hardcoded paths (all use Makefile/Docker)
- [ ] Security best practices demonstrated
- [ ] No sensitive data in examples
- [ ] Documentation follows existing style
- [ ] All links are valid
- [ ] Code examples are idiomatic for the language

---

## 🔧 Improving Existing Content

### Tutorial Improvements

**When editing tutorials:**

1. **Preserve Learning Structure**
   - Keep numbered progression (1-10 beginner, 11-23+ advanced)
   - Maintain difficulty levels
   - Don't remove TODO markers in exercise files

2. **Enhance Python Comparisons**
   ```markdown
   # ✅ Good
   > **📘 Python Note:** Python uses `list.append()`, Ruby uses `array.push` or `<<`

   # ❌ Avoid
   > Similar to Python
   ```

3. **Test Your Changes**
   ```bash
   # Always test in Docker
   make ruby-shell
   ruby ruby/tutorials/3-Control-Flow/exercises/flow_practice.rb
   ```

4. **Update Related Files**
   - If changing code, update STEPS.md (for labs)
   - Update README.md if adding new concepts
   - Keep solution files in sync with starter files

### Lab Improvements

**When editing labs:**

1. **Maintain Progressive Structure**
   - STEPS.md should have 6-9 steps
   - Each step is a working checkpoint
   - Include validation criteria

2. **Keep Starter/Solution Separation**
   - `starter.rb` has TODOs for students
   - `solution.rb` is complete implementation
   - Both should be well-commented

3. **Test Progressive Build**
   ```bash
   # Verify each step in STEPS.md works
   # Students should be able to follow step-by-step
   ```

### Documentation Improvements

**When updating docs:**

1. **Keep Consistent Style**
   - Use emoji section headers (📋, 🎯, 🚀, etc.)
   - Follow markdown conventions
   - Include code examples where helpful

2. **Maintain Links**
   - Use relative paths for internal links
   - Verify all external links work
   - Update table of contents if needed

3. **Be Clear and Concise**
   - Target audience: developers learning new languages
   - Assume Python knowledge for comparisons
   - Explain "why" not just "how"

---

## 💻 Development Workflow

### 1. Fork and Clone

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/learning-with-claude.git
cd learning-with-claude
```

### 2. Create a Branch

Use descriptive branch names:

```bash
# For new language modules
git checkout -b feature/add-go-language

# For tutorial fixes
git checkout -b fix/ruby-tutorial-5-typo

# For enhancements
git checkout -b enhance/add-rust-async-tutorial

# For documentation
git checkout -b docs/improve-contributing-guide
```

### 3. Set Up Environment

```bash
# Start Docker environment
make up-docker

# Verify services
make status

# Test specific language
make ruby-shell  # or dart-shell, python-shell
```

### 4. Make Your Changes

- Edit files using your preferred editor
- Follow existing code style and conventions
- Add comments where helpful
- Update relevant documentation

### 5. Test Thoroughly

```bash
# For Ruby changes
make ruby-shell
ruby path/to/changed/file.rb
rspec spec/  # If tests exist

# For Dart changes
make dart-shell
dart run path/to/changed/file.dart

# For Docker changes
make down
make build
make up-docker
```

### 6. Commit Your Changes

Write clear, descriptive commit messages:

```bash
# Good commit messages
git commit -m "Add Tutorial 14: Rust Macros and Metaprogramming"
git commit -m "Fix typo in Ruby Tutorial 3 exercises"
git commit -m "Improve Python comparison notes in Dart collections"

# Less helpful
git commit -m "Update files"
git commit -m "Fix stuff"
```

### 7. Push and Create Pull Request

```bash
git push origin feature/add-go-language
```

Then create a PR on GitHub with:
- Clear title describing the change
- Description of what and why
- Screenshots/examples if applicable
- Checklist of what was tested

---

## ✅ Quality Standards

### Code Quality

**All code should:**
- Run successfully in Docker environment
- Follow language idioms (not direct Python translations)
- Include helpful comments
- Handle errors gracefully
- Demonstrate security best practices
- Use meaningful variable/function names

**Example - Good Go Code:**

```go
// calculateAverage computes the mean of a slice of numbers.
// Returns 0.0 for empty slices to avoid division by zero.
//
// 📘 Python Note: Similar to sum(numbers) / len(numbers)
func calculateAverage(numbers []float64) float64 {
    if len(numbers) == 0 {
        return 0.0
    }

    total := 0.0
    for _, num := range numbers {
        total += num
    }

    return total / float64(len(numbers))
}
```

### Documentation Quality

**All documentation should:**
- Use proper markdown formatting
- Include working code examples
- Have clear learning objectives
- Provide Python comparisons (where applicable)
- Link to official language docs
- Be tested and verified

### Test Coverage

**For new tutorials:**
- Include exercises with expected output
- Provide starter templates with TODOs
- Include solution files
- Add validation checkpoints

**For labs:**
- Include STEPS.md for progressive building
- Provide both starter and solution code
- Include README with clear instructions
- Test all steps independently

---

## 📝 Pull Request Guidelines

### Before Submitting

- [ ] Branch is up to date with main
- [ ] All tests pass locally
- [ ] Code runs in Docker environment
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] No merge conflicts

### PR Description Template

```markdown
## Description
Brief summary of changes

## Type of Change
- [ ] New language module
- [ ] Tutorial improvement
- [ ] Lab addition/improvement
- [ ] Bug fix
- [ ] Documentation update
- [ ] Infrastructure change

## Testing
Describe how you tested the changes:
- [ ] Tested in Docker
- [ ] Ran relevant make commands
- [ ] Verified all links work
- [ ] Checked code examples

## Checklist
- [ ] Code follows repository conventions
- [ ] Documentation is updated
- [ ] Python comparisons are accurate (if applicable)
- [ ] All files tested
- [ ] No sensitive data included

## Screenshots (if applicable)
Add screenshots showing the changes
```

### Review Process

1. **Automated Checks** - CI/CD runs basic validation
2. **Maintainer Review** - Code quality, style, completeness
3. **Testing** - Maintainers test in Docker environment
4. **Feedback** - Requested changes or approval
5. **Merge** - Once approved, PR is merged to main

### After Merge

- Your contribution is live! 🎉
- You'll be added to contributors list
- Close any related issues
- Share your contribution with the community

---

## 🐛 Reporting Issues

### Bug Reports

**Use this template:**

```markdown
## Bug Description
Clear description of the issue

## Steps to Reproduce
1. Step one
2. Step two
3. ...

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- OS: [e.g., Ubuntu 22.04]
- Docker version: [e.g., 24.0.7]
- Docker Compose version: [e.g., 2.23.0]
- Language: [e.g., Ruby 3.4.7]

## Additional Context
Screenshots, logs, etc.
```

### Feature Requests

**Use this template:**

```markdown
## Feature Description
Clear description of the proposed feature

## Problem It Solves
What problem does this address?

## Proposed Solution
How should it work?

## Alternatives Considered
Other approaches you've thought about

## Additional Context
Examples, mockups, etc.
```

---

## 🆘 Getting Help

### Resources

- **Documentation**: Start with [README.md](README.md)
- **Prompt Templates**: See [.prompts/README.md](.prompts/README.md)
- **Example Workflow**: Review [.prompts/EXAMPLE_WORKFLOW.md](.prompts/EXAMPLE_WORKFLOW.md)
- **GitHub Issues**: Search existing issues for solutions

### Where to Ask Questions

- **GitHub Discussions** - General questions, ideas, show & tell
- **GitHub Issues** - Bug reports, feature requests
- **Pull Request Comments** - Specific code feedback

### Response Times

We're a community-driven project:
- **Bug reports**: Usually within 1-3 days
- **Feature requests**: Within a week
- **Pull requests**: Within 3-5 days

---

## 🎓 Learning Resources

### For Contributors

**Understanding the Repository:**
- Read [docs/AI_WORKFLOW.md](docs/AI_WORKFLOW.md) for AI-assisted development patterns
- Study existing language modules (Ruby, Dart) as references
- Review [.github/copilot-instructions.md](.github/copilot-instructions.md) for guidelines

**Docker Basics:**
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- Repository Makefile has helpful commands (`make help`)

**Using AI Assistance:**
- The `.prompts/` directory contains structured prompts for AI
- Follow the progressive approach in EXAMPLE_WORKFLOW.md
- Validate AI-generated content thoroughly

### For Learners

If you're here to **learn languages** rather than contribute code:

1. Start with [README.md](README.md)
2. Choose your language (Ruby or Dart currently)
3. Follow tutorials sequentially
4. Complete labs for hands-on practice
5. Share feedback via issues or discussions

---

## 🏆 Recognition

### Contributors

All contributors are recognized in:
- GitHub contributors page
- Repository README.md (for significant contributions)
- Release notes

### Types of Contributions Valued

- 🌟 New language modules
- 📚 Tutorial improvements
- 🔧 Bug fixes
- 📖 Documentation enhancements
- 🎨 UI/UX improvements
- 🧪 Test coverage
- 🌍 Translations (future)
- 💡 Feature ideas

---

## 📜 License

By contributing to learning-with-claude, you agree that your contributions will be licensed under the [MIT License](LICENSE).

---

## 🙏 Thank You!

Your contributions make this repository better for everyone learning new programming languages. Whether you're:

- Adding a complete language module
- Fixing a typo
- Improving documentation
- Sharing feedback

**Every contribution matters.** Thank you for being part of this community! 🚀

---

**Questions?** Open an issue or discussion. We're here to help!
