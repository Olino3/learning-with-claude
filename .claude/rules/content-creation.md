# Content Creation Patterns

## Tutorial Structure

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

See `.templates/tutorial_template.md` for the complete template.

## Lab Structure

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

See `.templates/lab_template.md` for the complete template.

## Creating Tutorials

**Workflow:**
1. Use plan mode first to outline structure
2. Research similar tutorials in the repository for consistency
3. Follow the template in `.templates/tutorial_template.md`
4. Include Python comparisons in every major section
5. Create executable examples - all code must run
6. Progressive complexity - simple → intermediate → advanced
7. Add to main README - Update `ruby/tutorials/README.md` or `dart/tutorials/README.md`

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

## Creating Labs

**Workflow:**
1. Plan the complete solution first
2. Break into 6-9 logical steps
3. Follow the template in `.templates/lab_template.md`
4. Create both README.md and STEPS.md
5. Implement solution/ directory fully
6. Create incremental steps/ directories
7. Add checkpoints after each step
8. Include challenges with TODO markers

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

## Reviewing Student Code

1. **Load exercise context** - Read the relevant tutorial/lab README
2. **Compare to solution** - Check against solution/ directory (if exists)
3. **Identify learning gaps** - What concepts are misunderstood?
4. **Suggest next steps** - Point to relevant tutorials
5. **Encourage Ruby/Dart idioms** - Not Python patterns translated literally
6. **Provide examples** - Show the idiomatic way
7. **Be encouraging** - Learning new languages is hard!

## Exercise Validation

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
