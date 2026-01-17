# Claude Rules Directory

This directory contains focused instruction files for the Claude AI assistant working on the learning-with-claude repository. These files are automatically imported when Claude reads the main `CLAUDE.md` file.

## File Organization

**Main Entry Point:**
- `/CLAUDE.md` (250 lines) - Essential context, quick reference, and imports

**Focused Rule Files:**
- `content-creation.md` (133 lines) - Tutorial/lab creation patterns
- `code-style.md` (140 lines) - Ruby/Dart conventions and anti-patterns
- `python-comparisons.md` (181 lines) - Guidelines for Python developer bridges
- `workflows.md` (135 lines) - AI workflow patterns and guidance
- `quality-standards.md` (253 lines) - Quality checklists and writing style

## Design Principles

1. **Under 300 lines per file** - Keeps context focused and manageable
2. **Single responsibility** - Each file covers one clear domain
3. **Easy navigation** - Clear file names and structure
4. **Referenced from main** - CLAUDE.md points to these for details
5. **No duplication** - Information lives in one place

## How Claude Uses These Files

When Claude needs information about:

- **Creating tutorials or labs** → `content-creation.md`
- **Code conventions** → `code-style.md`
- **Python comparisons** → `python-comparisons.md`
- **AI workflows** → `workflows.md`
- **Quality standards** → `quality-standards.md`

The main `CLAUDE.md` provides the overview and directs to these focused files.

## Maintenance

When updating instructions:

1. Keep files under 300 lines
2. Update only the relevant focused file
3. Avoid duplicating information across files
4. Update main `CLAUDE.md` only for structural changes
5. Test that all code examples still work

## Benefits of This Structure

**For Claude:**
- Focused context for specific tasks
- Easier to find relevant information
- Less token usage per query
- Clear separation of concerns

**For Maintainers:**
- Easier to update specific areas
- Clear file organization
- No monolithic files
- Better version control diffs

**For Users:**
- Transparent instruction structure
- Easy to customize for their needs
- Can add/remove rules as needed
- Clear documentation of AI behavior

## Total Context Budget

**Combined:** ~1,092 lines (well-distributed)
**Per file:** 133-253 lines (all under 300)
**Main file:** 250 lines (focused overview)

This structure maintains comprehensive instructions while keeping individual files digestible and focused.
