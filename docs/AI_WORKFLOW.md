# AI-Assisted Workflows for learning-with-claude

This document describes standardized agentic workflows for creating, updating, and managing learning content in this repository using Claude and other AI tools.

## Table of Contents

- [Creating a New Tutorial](#creating-a-new-tutorial)
- [Building a Progressive Lab](#building-a-progressive-lab)
- [Reviewing Student Code](#reviewing-student-code)
- [Updating Existing Content](#updating-existing-content)
- [Customizing Learning Paths](#customizing-learning-paths)
- [Validating Exercises](#validating-exercises)
- [Managing Cross-References](#managing-cross-references)
- [Best Practices](#best-practices)

---

## Creating a New Tutorial

Use this workflow when adding a new tutorial to the repository.

### Phase 1: Planning (Plan Mode)

**Goal:** Outline the tutorial structure before implementation.

**Steps:**

1. **Activate Plan Mode** (default in this workspace)

2. **Define Scope:**
   ```
   I want to create a tutorial on [TOPIC] for [Ruby/Dart].
   Target audience: [beginner/intermediate/advanced]
   Prerequisites: [list tutorials that should be completed first]
   ```

3. **Research Similar Tutorials:**
   - Read 2-3 similar difficulty tutorials in the same language
   - Note their structure, length, and teaching approach
   - Identify patterns to follow

4. **Plan Learning Objectives:**
   - What will students be able to do after this tutorial?
   - List 6-8 specific, measurable objectives
   - Ensure progressive complexity

5. **Plan Python Comparisons:**
   - What Python concepts map to this topic?
   - What are the key differences Python developers will struggle with?
   - What mental models will help the transition?

6. **Plan Code Examples:**
   - List 4-6 major sections with examples
   - Ensure examples build on each other
   - Plan executable, realistic examples (not toy code)

7. **Plan Challenges:**
   - Design 3-5 practice challenges
   - Range from reinforcement to extension
   - Include hints

**Output:** A detailed outline including:
- Learning objectives
- Section structure
- Python comparison topics
- Example topics
- Challenge descriptions

### Phase 2: Implementation

**Goal:** Create the tutorial files following the template.

**Steps:**

1. **Load Template:**
   ```bash
   # Reference the tutorial template
   cat .templates/tutorial_template.md
   ```

2. **Create Tutorial Directory:**
   ```bash
   # For Ruby
   mkdir -p ruby/tutorials/[NUMBER]-[Topic-Name]
   mkdir -p ruby/tutorials/[NUMBER]-[Topic-Name]/exercises

   # For Dart
   mkdir -p dart/tutorials/[NUMBER]-[Topic-Name]
   mkdir -p dart/tutorials/[NUMBER]-[Topic-Name]/exercises
   ```

3. **Create README.md:**
   - Follow template structure exactly
   - Write clear, concise explanations
   - Include code examples with output comments
   - Add Python Note callouts throughout
   - Include comparison tables

4. **Create Exercise File:**
   ```ruby
   # exercises/[topic]_practice.rb
   #!/usr/bin/env ruby
   # [Topic] Practice

   puts "=" * 70
   puts "[TOPIC] PRACTICE"
   puts "=" * 70

   # Example 1: [Basic concept]
   # ... executable code with comments

   # Example 2: [Intermediate pattern]
   # ... progressive complexity
   ```

5. **Test All Code:**
   ```bash
   # Run the exercise file
   make run-script SCRIPT=ruby/tutorials/[NUMBER]-[Topic]/exercises/[topic]_practice.rb

   # Verify output matches expectations
   # Fix any errors
   ```

6. **Validate Exercise:**
   ```bash
   ruby scripts/validate_exercise.rb ruby/tutorials/[NUMBER]-[Topic]/exercises/
   ```

### Phase 3: Integration

**Goal:** Connect the new tutorial to the repository structure.

**Steps:**

1. **Update Main README:**
   - Add entry to `ruby/tutorials/README.md` or `dart/tutorials/README.md`
   - Include tutorial number, title, and learning objectives
   - Mark status as ✅ Complete
   - Add to the tutorial table

2. **Update Prerequisites:**
   - If other tutorials should list this as a follow-up, update them
   - If this tutorial has prerequisites, clearly state them

3. **Check Cross-References:**
   - Search for mentions of related topics
   - Add references to this tutorial where appropriate

4. **Commit:**
   ```bash
   git add ruby/tutorials/[NUMBER]-[Topic]/
   git add ruby/tutorials/README.md
   git commit -m "Add Tutorial [NUMBER]: [Topic Name]

   - [Learning objective 1]
   - [Learning objective 2]
   - [Learning objective 3]
   - Includes [X] examples and [Y] challenges
   - Python comparisons throughout"
   ```

**Checklist:**
- [ ] README.md follows template structure
- [ ] Learning objectives clearly stated (6-8 items)
- [ ] Prerequisites listed (if any)
- [ ] Python comparison table included
- [ ] 4-6 deep dive sections
- [ ] Code examples tested and working
- [ ] Python Note callouts throughout
- [ ] Challenges section with 3-5 exercises
- [ ] Further reading links
- [ ] Exercise file created and validated
- [ ] Added to main tutorials README with ✅
- [ ] Cross-references updated
- [ ] Committed with descriptive message

---

## Building a Progressive Lab

Use this workflow when creating a hands-on lab project.

### Phase 1: Planning (Plan Mode)

**Goal:** Design the complete lab before implementing.

**Steps:**

1. **Define Lab Scope:**
   ```
   Lab topic: [PROJECT NAME]
   Difficulty: [beginner/intermediate/advanced]
   Estimated time: [X hours]
   Concepts covered: [list]
   ```

2. **Design the Complete Solution:**
   - What is the final working application?
   - What features does it have?
   - What technologies does it use?
   - What files/directories are needed?

3. **Break Into Steps:**
   - Divide the project into 6-9 logical steps
   - Each step should be independently testable
   - Steps should build naturally on each other
   - Estimate time for each step

4. **Plan Checkpoints:**
   - What should work after each step?
   - How can students verify they're on track?
   - What common mistakes should we warn about?

5. **Design Challenges:**
   - What extensions can students add?
   - What variations can they try?
   - What advanced features can they implement?

**Output:** A detailed plan including:
- Complete solution architecture
- 6-9 step breakdown
- Checkpoint criteria for each step
- Challenge ideas
- File structure

### Phase 2: Implementation - Solution First

**Goal:** Build the complete working solution.

**Steps:**

1. **Load Template:**
   ```bash
   cat .templates/lab_template.md
   ```

2. **Create Lab Directory:**
   ```bash
   mkdir -p ruby/labs/[category]/[lab-name]
   mkdir -p ruby/labs/[category]/[lab-name]/solution
   mkdir -p ruby/labs/[category]/[lab-name]/steps
   mkdir -p ruby/labs/[category]/[lab-name]/challenges
   ```

3. **Implement Complete Solution:**
   - Build in `solution/` directory
   - Follow best practices
   - Include tests
   - Add comprehensive comments
   - Create README for solution

4. **Test Solution Thoroughly:**
   ```bash
   # Run the complete application
   # Test all features
   # Verify edge cases
   # Fix any bugs
   ```

5. **Document Solution:**
   - How to run it
   - How it works
   - Key design decisions
   - Technologies used

### Phase 3: Implementation - Progressive Steps

**Goal:** Break the solution into incremental builds.

**Steps:**

1. **Create Step Directories:**
   ```bash
   for i in {1..7}; do
     mkdir -p ruby/labs/[category]/[lab-name]/steps/step$i
   done
   ```

2. **Implement Each Step:**
   - Copy relevant files from solution
   - Remove features not yet introduced
   - Add TODO markers where students should work
   - Include tests for that step

3. **Create Step README:**
   - What to implement in this step
   - Learning objectives for this step
   - Hints and guidance
   - Checkpoint validation
   - Common pitfalls

4. **Test Each Step:**
   - Verify step code runs
   - Checkpoint criteria met
   - Smooth transition to next step

### Phase 4: Documentation

**Goal:** Create comprehensive lab documentation.

**Steps:**

1. **Create Main README.md:**
   - Follow lab template
   - Learning objectives
   - Project structure overview
   - Running instructions
   - Link to STEPS.md

2. **Create STEPS.md:**
   ```markdown
   # [Lab Name] - Step-by-Step Guide

   Build [project] incrementally in [X] steps.

   ## Step 1: [Title] (Estimated: [Y] minutes)

   [Description]

   ### What You'll Build
   - [Feature 1]
   - [Feature 2]

   ### Instructions
   1. [Detailed step]
   2. [Detailed step]

   ### Checkpoint
   - [ ] [Verification criteria]
   - [ ] [Verification criteria]

   ### Test
   ```bash
   [Test command]
   ```

   ### Common Issues
   - [Issue 1]: [Solution]

   ---

   ## Step 2: ...
   ```

3. **Create Challenges:**
   - Challenge files with TODO markers
   - Extension ideas
   - Advanced features to implement

### Phase 5: Integration

**Goal:** Connect lab to repository structure.

**Steps:**

1. **Update Labs README:**
   - Add to `ruby/labs/README.md`
   - Include description, time estimate, learning objectives
   - Link to lab directory

2. **Create Git Example Commits:**
   ```bash
   # Optional: Create a demo branch showing commits per step
   git checkout -b lab-[name]-demo
   git add steps/step1/
   git commit -m "Step 1: [Description]"
   # ... repeat for each step
   ```

3. **Final Commit:**
   ```bash
   git checkout main
   git add ruby/labs/[category]/[lab-name]/
   git add ruby/labs/README.md
   git commit -m "Add [Category] Lab: [Lab Name]

   - [Learning objective 1]
   - [Learning objective 2]
   - [X] steps, estimated [Y] hours
   - Includes complete solution and incremental steps
   - [Z] extension challenges"
   ```

**Checklist:**
- [ ] Complete solution implemented and tested
- [ ] 6-9 progressive steps created
- [ ] Each step is independently testable
- [ ] STEPS.md with detailed instructions
- [ ] Checkpoint criteria for each step
- [ ] Challenge files with TODOs
- [ ] Main README with overview
- [ ] Added to labs README
- [ ] Optional: Demo branch with example commits
- [ ] All code tested and working
- [ ] Committed with descriptive message

---

## Reviewing Student Code

Use this workflow when helping students debug or improve their solutions.

### Phase 1: Context Gathering

**Goal:** Understand what the student is trying to accomplish.

**Steps:**

1. **Read the Exercise/Lab:**
   - Load the relevant tutorial or lab README
   - Understand the learning objectives
   - Review the expected solution (if available)

2. **Review Student Code:**
   - Read the student's implementation
   - Identify what they're trying to do
   - Note what's working vs. not working

3. **Check Prerequisites:**
   - Have they completed prerequisite tutorials?
   - Do they understand foundational concepts?

### Phase 2: Analysis

**Goal:** Identify learning gaps and issues.

**Steps:**

1. **Categorize Issues:**
   - **Syntax errors:** Basic Ruby/Dart syntax mistakes
   - **Logic errors:** Misunderstanding of the algorithm
   - **Idiom issues:** Python patterns instead of Ruby/Dart idioms
   - **Concept gaps:** Missing understanding of key concepts

2. **Identify Root Cause:**
   - Is this a simple typo or fundamental misunderstanding?
   - Are they using Python patterns incorrectly?
   - Do they understand the Ruby/Dart way?

3. **Find Teaching Opportunity:**
   - What concept needs reinforcement?
   - Which tutorial section should they review?
   - What example would clarify this?

### Phase 3: Feedback

**Goal:** Help the student learn, not just fix the code.

**Steps:**

1. **Explain the Issue:**
   - Point out what's not working
   - Explain why it doesn't work
   - Reference relevant concepts

2. **Show the Idiomatic Way:**
   ```ruby
   # Your approach (Python style):
   for item in items:
     puts item
   end

   # Ruby idiomatic way:
   items.each { |item| puts item }

   # Why: Ruby uses blocks and iterators instead of for loops
   # See: Tutorial 4 - Methods and Blocks
   ```

3. **Provide Resources:**
   - Link to relevant tutorial sections
   - Suggest exercises to practice
   - Point to documentation

4. **Encourage Next Steps:**
   - Suggest what to try next
   - Build confidence
   - Celebrate progress

**Feedback Template:**
```markdown
## Review of [Exercise/Lab Name]

### What's Working Well ✅
- [Positive observation 1]
- [Positive observation 2]

### Issues to Address 🔍

#### Issue 1: [Category]
**Current code:**
```ruby
[Their code]
```

**Problem:** [Explanation]

**Ruby/Dart idiomatic way:**
```ruby
[Better code]
```

**Why:** [Conceptual explanation]

**Reference:** [Tutorial X: Section Y]

### Recommended Next Steps
1. [Specific action]
2. [Tutorial to review]
3. [Exercise to practice]

Keep going! [Encouraging note]
```

---

## Updating Existing Content

Use this workflow when modernizing or fixing existing tutorials/labs.

### Phase 1: Assessment

**Goal:** Understand what needs updating and why.

**Steps:**

1. **Identify Update Trigger:**
   - Ruby/Dart version change
   - New language features available
   - Better teaching approach discovered
   - Broken examples
   - Outdated comparisons

2. **Check Dependencies:**
   - What other tutorials reference this?
   - What labs use these patterns?
   - Will changes break anything?

3. **Search for Cross-References:**
   ```bash
   # Find all references to this tutorial
   grep -r "Tutorial [NUMBER]" ruby/
   grep -r "[Topic Name]" ruby/
   ```

### Phase 2: Updates

**Goal:** Make changes while maintaining consistency.

**Steps:**

1. **Update Content:**
   - Fix issues identified
   - Add new patterns if relevant
   - Update code examples
   - Refresh Python comparisons if needed

2. **Test All Code:**
   ```bash
   # Re-run all examples
   make run-script SCRIPT=ruby/tutorials/[NUMBER]-[Topic]/exercises/[topic]_practice.rb

   # Validate
   ruby scripts/validate_exercise.rb ruby/tutorials/[NUMBER]-[Topic]/
   ```

3. **Update Cross-References:**
   - Fix links in other tutorials
   - Update references in labs
   - Update main README if structure changed

4. **Update Dates/Versions:**
   - Note when last updated
   - Mention Ruby/Dart version tested with
   - Update copyright if needed

### Phase 3: Validation

**Goal:** Ensure changes improve without breaking.

**Steps:**

1. **Review Changes:**
   - Does it still teach the same concepts?
   - Is it clearer than before?
   - Are examples still progressive?

2. **Check Consistency:**
   - Matches other tutorial styles?
   - Follows template structure?
   - Naming conventions consistent?

3. **Test Thoroughly:**
   - All code runs
   - Examples produce expected output
   - Links work
   - No broken references

4. **Commit:**
   ```bash
   git add [files]
   git commit -m "Update Tutorial [NUMBER]: [Summary]

   - [Change 1]
   - [Change 2]
   - Updated for Ruby [version]
   - Refreshed Python comparisons"
   ```

---

## Customizing Learning Paths

Use this workflow when recommending personalized learning sequences.

### Phase 1: Assessment

**Goal:** Understand the learner's background and goals.

**Questions to Ask:**

1. **Programming Experience:**
   - Complete beginner to programming?
   - Experienced in Python?
   - Other languages known?

2. **Goals:**
   - Build web applications?
   - Learn systems programming?
   - Data processing?
   - Just exploring/having fun?

3. **Time Available:**
   - Weekend intensive?
   - Daily 1-hour over weeks?
   - Casual exploration?

4. **Learning Style:**
   - Prefer reading then doing?
   - Learn by building projects?
   - Need lots of examples?

### Phase 2: Path Design

**Goal:** Create a customized tutorial sequence.

**Common Paths:**

**Path 1: Python Developer → Ruby Web Development**
```
Recommended sequence:
1. Tutorial 2-5 (skip 1, you know programming basics)
   - Focus on Ruby-specific features
   - Note syntax differences
2. Tutorial 6-7 (OOP, Modules)
   - Ruby's OOP is different
3. Tutorial 9 (File I/O) - quick
4. Sinatra Tutorials 1-8
   - Build web apps
5. Sinatra Labs 1-4
   - Real projects
6. Advanced as interested

Estimated time: 20-30 hours
```

**Path 2: Complete Beginner → Ruby Fundamentals**
```
Recommended sequence:
1. Tutorials 1-10 in order
   - Take your time
   - Complete all exercises
2. Beginner Labs 1-3
   - Hands-on practice
3. Tutorial 11-16 when ready
   - More advanced concepts
4. Intermediate Lab
   - Big project
5. Advanced tutorials as interested

Estimated time: 40-60 hours
```

**Path 3: Experienced Developer → Advanced Ruby**
```
Recommended sequence:
1. Tutorials 1-10 (skim quickly)
   - Just note syntax differences
2. Tutorials 11-16 (study carefully)
   - Ruby-specific patterns
3. Advanced Tutorials 17-23
   - Deep Ruby knowledge
4. Advanced Labs
   - Complex projects

Estimated time: 30-40 hours
```

### Phase 3: Personalization

**Goal:** Adjust path based on specific needs.

**Customizations:**

- **Skip redundant content:** If experienced, skip basics
- **Deep dive specifics:** Extra time on challenging topics
- **Project-focused:** Emphasize labs over tutorials
- **Concept-focused:** Emphasize tutorials over labs

**Output Format:**
```markdown
## Your Personalized Ruby Learning Path

Based on your [background] and goal to [goal], here's your recommended path:

### Phase 1: Foundations ([X] hours)
- [ ] Tutorial [N]: [Topic] - [Why relevant]
- [ ] Tutorial [N]: [Topic] - [Why relevant]
- [ ] Lab [N]: [Project] - [Why relevant]

**Focus:** [What to emphasize]

### Phase 2: Intermediate ([Y] hours)
- [ ] Tutorial [N]: [Topic]
- ...

### Phase 3: Advanced ([Z] hours)
- ...

### Tips for Your Learning Style
- [Specific advice]
- [Specific advice]

### Checkpoints
After Phase 1, you should be able to [capability].
After Phase 2, you should be able to [capability].
```

---

## Validating Exercises

Use this workflow to automatically check exercise solutions.

### Manual Validation

**Steps:**

1. **Run Exercise:**
   ```bash
   make run-script SCRIPT=path/to/exercise.rb
   ```

2. **Check Output:**
   - Does it run without errors?
   - Is output as expected?
   - Are all examples demonstrated?

3. **Review Code Quality:**
   - Idiomatic Ruby/Dart?
   - Good naming?
   - Clear comments?
   - Proper style?

### Automated Validation

**Using validate_exercise.rb:**

```bash
# Validate single file
ruby scripts/validate_exercise.rb ruby/tutorials/5-Collections/exercises/collections_practice.rb

# Validate all exercises in a tutorial
ruby scripts/validate_exercise.rb ruby/tutorials/5-Collections/

# Validate all Ruby exercises
ruby scripts/validate_exercise.rb ruby/tutorials/
```

**What It Checks:**
- ✅ Syntax correctness (Ruby parser)
- ✅ Code executes without errors
- ✅ Expected patterns present (basic checks)
- ✅ File structure correct

**Limitations:**
- Cannot verify logic correctness
- Cannot check if it teaches well
- Cannot validate output content
- Basic idiom checking only

---

## Managing Cross-References

Use this workflow to maintain consistent references across tutorials and labs.

### Finding References

**Search Commands:**

```bash
# Find all mentions of a tutorial
grep -r "Tutorial 5" ruby/
grep -r "Collections" ruby/tutorials/

# Find all mentions of a concept
grep -r "blocks" ruby/tutorials/
grep -r "iterators" ruby/

# Find all TODO items
grep -r "TODO" ruby/ --include="*.md"
grep -r "TODO" ruby/ --include="*.rb"
```

### Updating References

**When to Update:**

1. **Tutorial number changes** - Update all links
2. **Tutorial renamed** - Update all references
3. **New tutorial added** - Add references where relevant
4. **Content restructured** - Fix broken links

**How to Update:**

1. **Find all references:**
   ```bash
   grep -r "Tutorial 5: Collections" ruby/
   ```

2. **Update systematically:**
   - Check each occurrence
   - Update link if needed
   - Verify link works

3. **Validate:**
   - Click all links to verify
   - Check formatting
   - Ensure consistency

### Link Formats

**Standard link formats:**

```markdown
# Within same directory
[Exercise File](exercises/collections_practice.rb)

# To another tutorial
[Tutorial 4: Methods and Blocks](../4-Methods-and-Blocks/README.md)

# To a lab
[Beginner Lab 2](../../labs/beginner/lab2-collections/README.md)

# To main README
[Main README](../../../README.md)
```

---

## Best Practices

### General Guidelines

1. **Always use plan mode first** for complex tasks
2. **Test all code** before committing
3. **Follow templates** for consistency
4. **Include Python comparisons** (for Ruby/Dart content)
5. **Use descriptive commit messages**
6. **Update cross-references** when changing structure
7. **Validate exercises** before marking complete
8. **Document decisions** in comments/commits

### Quality Checklist

Before considering any content complete:

- [ ] All code examples run successfully
- [ ] Python comparisons included (where relevant)
- [ ] Follows repository patterns and conventions
- [ ] Cross-references updated
- [ ] Exercise file created and validated
- [ ] Main README updated
- [ ] Markdown properly formatted
- [ ] No broken links
- [ ] Appropriate emoji usage
- [ ] Estimated time provided (for labs)
- [ ] Descriptive commit message
- [ ] Tested in container environment

### Common Pitfalls to Avoid

1. **Don't skip testing** - Always run code before committing
2. **Don't forget cross-references** - Update related content
3. **Don't use absolute paths** - Use relative links
4. **Don't ignore Python comparisons** - They're essential
5. **Don't make tutorials too long** - Break into multiple if needed
6. **Don't skip checkpoints** - Labs need validation points
7. **Don't use local environments** - Everything runs in containers
8. **Don't forget to validate** - Use validation scripts

---

## Quick Reference

### Starting a New Tutorial
```bash
# 1. Plan structure
# 2. Create directory: ruby/tutorials/[N]-[Topic]/exercises/
# 3. Create README.md from template
# 4. Create exercise file
# 5. Test: make run-script SCRIPT=path/to/exercise.rb
# 6. Validate: ruby scripts/validate_exercise.rb path/to/tutorial/
# 7. Update ruby/tutorials/README.md
# 8. Commit
```

### Starting a New Lab
```bash
# 1. Plan complete solution
# 2. Create directories: solution/, steps/, challenges/
# 3. Implement solution first
# 4. Break into 6-9 steps
# 5. Create README.md and STEPS.md
# 6. Test each step
# 7. Update ruby/labs/README.md
# 8. Commit
```

### Reviewing Student Code
```bash
# 1. Load exercise/lab context
# 2. Review student's code
# 3. Identify issues (syntax/logic/idioms/concepts)
# 4. Provide feedback with examples
# 5. Reference tutorials for learning
# 6. Encourage next steps
```

### Updating Content
```bash
# 1. Identify what needs updating
# 2. Search for cross-references: grep -r "[term]" ruby/
# 3. Make updates
# 4. Test all code
# 5. Update cross-references
# 6. Validate
# 7. Commit with summary
```

---

**Remember:** These workflows are guidelines, not rigid rules. Adapt them to the specific situation while maintaining the core principles of quality, consistency, and educational value.
