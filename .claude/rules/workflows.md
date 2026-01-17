# AI Workflow Guidance

## Default Mode: Plan Mode

**Always start with planning** when creating new content:
- Outline structure before implementation
- Research similar content in the repository
- Identify prerequisites and dependencies
- Plan Python comparisons
- Break complex tasks into steps

## Implementation Mode

After planning, implement systematically:
- Create files in logical order
- Test code examples as you write them
- Update cross-references
- Run validation scripts
- Commit logical chunks

## Sequential Thinking for Step-by-Step Guides

When creating STEPS.md or progressive tutorials:
- Use the Sequential Thinking MCP server
- Break complex concepts into digestible chunks
- Each step should be independently testable
- Include checkpoints for validation
- Ensure each step builds naturally on previous

## Common Workflows

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

**1. Assess background:**
- Programming experience level (beginner/intermediate/advanced)
- Python experience (none/some/expert)
- Goals (web dev/systems programming/data processing/learning for fun)
- Time available (weekend learner/intensive/casual)

**2. Recommend path:**
- **Ruby beginner:** Tutorials 1-10 → Beginner labs → Continue
- **Python expert:** Tutorials 2-5 (skip 1) → Focus on Ruby-specific (6-7, 11-14)
- **Web development:** Tutorials 1-9 → Sinatra tutorials → Sinatra labs
- **Advanced topics:** Tutorials 1-10 (quick review) → Advanced tutorials 17-23 → Advanced labs
- **Dart beginner:** Dart tutorials 1-10
- **Dart + Flutter:** Dart tutorials 1-10 → (Future: Flutter content)

**3. Personalize:**
- Skip redundant content if experienced
- Suggest skimming vs deep study
- Point to specific sections relevant to goals
- Recommend labs that match interests

## Key Files for Context

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

## MCP Server Integration

This repository works best with these MCP servers enabled:

- **Filesystem** - Reading/writing tutorial and exercise files
- **Git** - Tracking learning milestones, managing branches
- **Sequential Thinking** - Breaking complex concepts into steps
- **PostgreSQL** - For Sinatra lab database work
- **Memory** (optional) - Tracking learner progress across sessions
- **Brave Search** (optional) - Finding Ruby/Dart documentation

See `.mcp/recommended_servers.md` for setup instructions (if exists).

## Continuous Improvement

This repository is living content. When you notice:

- **Outdated patterns** - Update to modern Ruby/Dart idioms
- **Missing comparisons** - Add Python bridges
- **Gaps in progression** - Suggest intermediate tutorials
- **Better explanations** - Improve clarity
- **New features** - Add tutorials for new language features

Always maintain consistency with existing content while improving quality.
