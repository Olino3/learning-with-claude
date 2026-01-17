# CLAUDE.md Migration Guide

## What Changed?

The original monolithic `CLAUDE.md` (425 lines) has been refactored into a modular structure with focused rule files.

## New Structure

```
Before:
CLAUDE.md (425 lines) - Everything in one file

After:
CLAUDE.md (250 lines) - Essential overview and quick reference
.claude/rules/
  ├── README.md - Explains the structure
  ├── content-creation.md (133 lines) - Tutorial/lab patterns
  ├── code-style.md (140 lines) - Ruby/Dart conventions
  ├── python-comparisons.md (181 lines) - Python bridge guidelines
  ├── workflows.md (135 lines) - AI workflow guidance
  └── quality-standards.md (253 lines) - Quality & writing style
```

## Benefits

### 1. Better Context Management
- Each file focuses on one domain
- Easier to find relevant information
- Less context loaded per query
- More efficient token usage

### 2. Easier Maintenance
- Update specific areas without touching others
- Clearer version control diffs
- No monolithic file to navigate
- Single source of truth per topic

### 3. Improved Navigation
- Clear file names indicate contents
- Main CLAUDE.md provides roadmap
- Quick reference in main file
- Deep dives in focused files

### 4. Scalability
- Can add new rule files as needed
- Easy to deprecate outdated rules
- Simple to customize per project
- Maintains under-300-line guideline

## How to Use

### For AI Assistants (Claude)

The main `CLAUDE.md` automatically references all rule files. When you need specific information:

1. **Overview & quick reference** → Read `CLAUDE.md`
2. **Creating content** → Read `.claude/rules/content-creation.md`
3. **Code conventions** → Read `.claude/rules/code-style.md`
4. **Python comparisons** → Read `.claude/rules/python-comparisons.md`
5. **Workflows** → Read `.claude/rules/workflows.md`
6. **Quality standards** → Read `.claude/rules/quality-standards.md`

### For Humans

Browse the structure to understand how the AI is instructed:

1. Start with `CLAUDE.md` for the big picture
2. Dive into specific `.claude/rules/*.md` files for details
3. Reference `.templates/` for content creation templates
4. Check `docs/` for additional documentation

## Content Mapping

**Where did the original content go?**

| Original Section | New Location |
|------------------|--------------|
| Repository Purpose | `CLAUDE.md` (kept in main) |
| Directory Structure | `CLAUDE.md` (kept in main) |
| Learning Methodology | `.claude/rules/content-creation.md` |
| Development Environment | `CLAUDE.md` (kept in main) |
| Content Creation Patterns | `.claude/rules/content-creation.md` |
| Workflow Guidance | `.claude/rules/workflows.md` |
| Code Style and Conventions | `.claude/rules/code-style.md` |
| Python Comparison Guidelines | `.claude/rules/python-comparisons.md` |
| Exercise Validation | `.claude/rules/content-creation.md` |
| Common AI Workflows | `.claude/rules/workflows.md` |
| Key Files for Context | `.claude/rules/workflows.md` |
| MCP Server Integration | `.claude/rules/workflows.md` |
| Quality Standards | `.claude/rules/quality-standards.md` |
| Writing Style | `.claude/rules/quality-standards.md` |
| Continuous Improvement | `.claude/rules/workflows.md` |

## File Size Comparison

| File | Lines | Status |
|------|-------|--------|
| **Old CLAUDE.md** | 425 | ⚠️ Too large |
| **New CLAUDE.md** | 250 | ✅ Streamlined |
| content-creation.md | 133 | ✅ Focused |
| code-style.md | 140 | ✅ Focused |
| python-comparisons.md | 181 | ✅ Focused |
| workflows.md | 135 | ✅ Focused |
| quality-standards.md | 253 | ✅ Focused |
| **Total** | 1,092 | ✅ Well-distributed |

## Best Practices

### When to Update Main CLAUDE.md

- Adding/removing rule files
- Changing repository structure
- Updating essential quick reference
- Modifying core principles
- Changing development environment

### When to Update Rule Files

- Updating specific workflows
- Refining code conventions
- Adding comparison patterns
- Updating quality standards
- Improving writing guidelines

### Maintaining Under 300 Lines

If a rule file grows beyond 300 lines:

1. **Identify subtopics** - Can it be split?
2. **Remove duplication** - Is information repeated?
3. **Extract examples** - Move to separate docs?
4. **Create new rule file** - For distinct subdomain?
5. **Update main CLAUDE.md** - To reference new file

## Migration Checklist

- [x] Created `.claude/rules/` directory
- [x] Split content into focused files
- [x] All files under 300 lines
- [x] Main CLAUDE.md references rule files
- [x] No content duplication
- [x] Clear navigation structure
- [x] README.md in rules directory
- [x] Migration guide created
- [x] All original content preserved

## Future Improvements

Possible additions to this structure:

- **language-specific/** - Separate Ruby and Dart rules
- **advanced-topics/** - Meta-programming, performance
- **testing-guidelines/** - Test creation patterns
- **deployment/** - Container and infrastructure rules

Each can be added as a new focused file under 300 lines.

## Questions?

For questions about this structure:

1. Read `.claude/rules/README.md` - Explains organization
2. Check main `CLAUDE.md` - Shows what references what
3. Review individual rule files - See focused content
4. Open an issue - If something is unclear

---

**Last Updated:** 2025-01-17
**Migration Version:** 1.0
**Total Files:** 6 rule files + 1 main file
**Total Lines:** 1,092 (was 425 in monolith)
