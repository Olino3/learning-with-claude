# Recommended MCP Servers for learning-with-claude

This document lists recommended Model Context Protocol (MCP) servers that enhance the AI-assisted learning workflow in this repository.

## Overview

MCP servers provide specialized capabilities to Claude and other AI tools. For this learning repository, we recommend servers that support:

- Reading and writing tutorial/exercise files
- Tracking learning progress via Git
- Breaking complex concepts into progressive steps
- Database operations for Sinatra labs
- Finding relevant documentation

## Installation

All MCP servers are installed via `npx` (Node.js package runner). You don't need to install them manually—Claude will invoke them as needed when configured in `.claude/claude_desktop_config.json`.

## Core Servers (High Priority)

### 1. Filesystem Server

**Purpose:** Read and write tutorial, exercise, and lab files.

**Use Cases:**
- Creating new tutorial README files
- Writing exercise code files
- Reading existing tutorials for context
- Updating lab step files
- Managing challenge files with TODO markers

**Configuration:**
```json
{
  "filesystem": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-filesystem",
      "~git/learning-with-claude"
    ]
  }
}
```

**Capabilities:**
- `read_file` - Read tutorial/exercise files
- `write_file` - Create new exercises
- `list_directory` - Browse tutorial structure
- `create_directory` - Set up new tutorial folders
- `move_file` - Reorganize content
- `search_files` - Find tutorials by content

**Example Usage:**
```
"Create a new Ruby tutorial on WebSockets in the advanced folder"
→ Filesystem server creates directory structure and files

"Show me all beginner labs"
→ Filesystem server lists ruby/labs/beginner/ contents

"Read the Collections tutorial to understand the format"
→ Filesystem server reads ruby/tutorials/5-Collections/README.md
```

---

### 2. Git Server

**Purpose:** Track learning progress, manage commits, review changes.

**Use Cases:**
- Creating commits after completing each lab step
- Reviewing changes made during a learning session
- Managing branches for different learning paths
- Creating example commit history for step-by-step labs
- Viewing tutorial evolution over time

**Configuration:**
```json
{
  "git": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-git",
      "--repository",
      "~git/learning-with-claude"
    ]
  }
}
```

**Capabilities:**
- `git_status` - See uncommitted changes
- `git_diff` - Review specific changes
- `git_commit` - Create learning milestone commits
- `git_log` - Review learning progress
- `git_branch` - Manage learning branches
- `git_show` - Inspect specific commits

**Example Usage:**
```
"Commit my solution to Lab 2 Step 3"
→ Git server creates commit with descriptive message

"Show me what changed in the last tutorial update"
→ Git server shows diff

"Create a demo branch showing incremental commits for this lab"
→ Git server creates branch and structured commits
```

**Best Practices:**
- Commit after each lab step completion
- Use descriptive messages: "Complete Step 3: Add user authentication"
- Create checkpoint commits for validation
- Use branches for different learning experiments

---

### 3. Sequential Thinking Server

**Purpose:** Break complex concepts into progressive, digestible steps.

**Use Cases:**
- Designing step-by-step lab guides (STEPS.md)
- Breaking advanced topics into learnable chunks
- Creating progressive tutorial sections
- Planning tutorial sequences
- Structuring complex code examples

**Configuration:**
```json
{
  "sequential-thinking": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-sequential-thinking"
    ]
  }
}
```

**Capabilities:**
- `create_sequence` - Plan step-by-step progressions
- `analyze_complexity` - Identify difficult concepts
- `suggest_breakdown` - Recommend step divisions
- `validate_progression` - Ensure logical flow

**Example Usage:**
```
"Break down the concept of Ruby metaprogramming into 7 progressive steps"
→ Sequential thinking creates logical progression from basic to advanced

"Design a lab that teaches Sinatra RESTful APIs in 6 steps"
→ Sequential thinking plans incremental feature additions

"This tutorial section feels too complex. How should I break it down?"
→ Sequential thinking suggests multiple smaller sections
```

**Best Practices:**
- Use for all step-by-step lab creation
- Ensure each step is independently testable
- Include validation checkpoints
- Build complexity gradually

---

### 4. PostgreSQL Server

**Purpose:** Database operations for Sinatra labs and advanced tutorials.

**Use Cases:**
- Creating database schemas for Sinatra labs
- Testing SQL queries for tutorial examples
- Managing migrations in lab steps
- Validating database-backed exercises
- Demonstrating ActiveRecord/Sequel patterns

**Configuration:**
```json
{
  "postgres": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-postgres",
      "postgresql://learning:password@localhost:5432/learning_dev"
    ]
  }
}
```

**Capabilities:**
- `execute_query` - Run SQL queries
- `list_tables` - Show database schema
- `describe_table` - Get table structure
- `create_migration` - Generate migration files

**Example Usage:**
```
"Create a users table schema for the blog lab"
→ PostgreSQL server generates CREATE TABLE statement

"Show me the current database schema"
→ PostgreSQL server lists all tables and columns

"Test this SQL query for correctness"
→ PostgreSQL server executes and validates query
```

**Best Practices:**
- Use for Sinatra lab database design
- Test queries before including in tutorials
- Create migrations for each step in database labs
- Document schema changes in STEPS.md

---

## Optional Servers (Medium Priority)

### 5. Memory Server

**Purpose:** Track learner progress across sessions.

**Use Cases:**
- Remembering completed tutorials
- Tracking difficult concepts for the learner
- Personalizing learning path recommendations
- Noting learner preferences and goals
- Building on previous conversations

**Installation:**
```bash
npm install -g @modelcontextprotocol/server-memory
```

**Configuration:**
```json
{
  "memory": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-memory"
    ]
  }
}
```

**Example Usage:**
```
"Remember that I'm a Python developer learning Ruby for web development"
→ Memory server stores this context for future sessions

"What topics have I struggled with?"
→ Memory server recalls past difficulties

"Continue from where we left off last time"
→ Memory server retrieves session context
```

---

### 6. Brave Search Server

**Purpose:** Find Ruby/Dart documentation and best practices online.

**Use Cases:**
- Finding official Ruby/Dart documentation
- Searching for gem/package information
- Looking up best practices
- Finding recent blog posts about topics
- Verifying current language syntax

**Installation:**
Requires Brave Search API key (free tier available)

**Configuration:**
```json
{
  "brave-search": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-brave-search"
    ],
    "env": {
      "BRAVE_API_KEY": "your-api-key-here"
    }
  }
}
```

**Example Usage:**
```
"Find the latest documentation for Ruby 3.4 Ractors"
→ Brave search finds official Ruby docs

"What are current best practices for Dart null safety?"
→ Brave search finds recent articles and guides

"Search for examples of async/await in Dart"
→ Brave search finds code examples
```

---

## Specialized Servers (Lower Priority)

### 7. GitHub Server

**Purpose:** Manage repository issues, PRs, and collaboration.

**Use Cases:**
- Creating issues for tutorial improvements
- Managing pull requests for new content
- Tracking content suggestions from learners
- Collaborative learning projects

**Note:** Only useful if using GitHub's collaborative features. Not needed for solo learning.

---

### 8. Slack/Discord Servers

**Purpose:** Integrate with learning communities.

**Use Cases:**
- Posting progress updates to learning communities
- Getting help from other learners
- Sharing completed labs

**Note:** Optional, depends on whether you're part of a learning community.

---

## Setup Instructions

### Quick Setup (Recommended)

The repository includes a pre-configured `.claude/claude_desktop_config.json` with the core servers:

1. **Filesystem** - Already configured
2. **Git** - Already configured
3. **Sequential Thinking** - Already configured
4. **PostgreSQL** - Already configured

No additional setup needed! Claude will use these automatically.

### Adding Optional Servers

To add optional servers like Memory or Brave Search:

1. **Edit configuration:**
   ```bash
   nano .claude/claude_desktop_config.json
   ```

2. **Add server to `mcpServers` section:**
   ```json
   {
     "mcpServers": {
       "postgres": { ... },
       "filesystem": { ... },
       "git": { ... },
       "sequential-thinking": { ... },
       "memory": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-memory"]
       }
     }
   }
   ```

3. **Restart Claude Desktop** (if using desktop app)

### Verifying Installation

Ask Claude:
```
"What MCP servers are available?"
```

Claude will list all configured servers and their capabilities.

---

## Usage Tips

### For Creating Tutorials

**Combine Filesystem + Sequential Thinking:**
```
"Use sequential thinking to plan a tutorial on Ruby blocks,
then create the tutorial file with filesystem server"
```

**Result:**
1. Sequential thinking plans progressive sections
2. Filesystem creates the tutorial file
3. You get a well-structured tutorial

### For Building Labs

**Combine Git + Filesystem + Sequential Thinking:**
```
"Design a lab with 7 steps using sequential thinking,
implement it with filesystem server,
and create example commits with git server"
```

**Result:**
1. Sequential thinking designs logical progression
2. Filesystem creates all step files
3. Git creates example commit history

### For Tracking Progress

**Combine Memory + Git:**
```
"Remember my progress (I completed tutorials 1-5),
show my recent commits with git server"
```

**Result:**
- Memory stores completion status
- Git shows learning milestones
- Personalized next steps suggested

### For Research

**Combine Brave Search + Filesystem:**
```
"Search for Ruby 3.4 features, then update the
Ruby Basics tutorial with new syntax examples"
```

**Result:**
1. Brave search finds latest features
2. Filesystem updates tutorial
3. Current, accurate content

---

## Troubleshooting

### Server Not Found

**Error:** `MCP server 'filesystem' not found`

**Solution:**
1. Check `.claude/claude_desktop_config.json` exists
2. Verify server is listed in `mcpServers`
3. Restart Claude Desktop
4. Ensure Node.js is installed (`node --version`)

### Permission Errors

**Error:** `Permission denied accessing /home/olino3/git/learning-with-claude`

**Solution:**
1. Check file permissions
2. Verify path in configuration is correct
3. Ensure Claude has access to the directory

### Server Timeout

**Error:** `Server 'git' timed out`

**Solution:**
1. Large repositories may take time
2. Increase timeout if possible
3. Use more specific git commands (diff specific files)

### PostgreSQL Connection Failed

**Error:** `Cannot connect to PostgreSQL`

**Solution:**
1. Ensure Docker containers are running: `make status`
2. Start database: `make up`
3. Verify connection string in configuration
4. Check PostgreSQL is accessible: `docker exec -it postgres psql -U learning`

---

## Best Practices

1. **Start with core servers** - Filesystem, Git, Sequential Thinking are essential
2. **Add servers as needed** - Don't enable everything at once
3. **Understand capabilities** - Know what each server can do
4. **Combine servers** - Use multiple servers together for complex tasks
5. **Verify setup** - Test servers work before relying on them
6. **Keep updated** - MCP servers improve over time

---

## Resources

- [MCP Documentation](https://modelcontextprotocol.io/)
- [Available MCP Servers](https://github.com/modelcontextprotocol/servers)
- [Creating Custom MCP Servers](https://modelcontextprotocol.io/docs/creating-servers)

---

**Need Help?**

Ask Claude: "Explain how to use [server name] for [task]" and it will provide specific guidance based on this repository's needs.
