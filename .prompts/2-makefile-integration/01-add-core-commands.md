# Phase 2.1: Add Core Makefile Commands

**Objective:** Add essential Makefile commands for {LANGUAGE_DISPLAY} development workflow.

---

## 📋 Context

The repository uses Make as a unified interface for all development tasks. Each language gets a consistent set of commands:
- Shell access to development container
- REPL/interactive environment
- Script execution
- Help documentation

---

## 🎯 Your Task

Add core {LANGUAGE_DISPLAY} commands to the `Makefile`.

### Variables to Substitute

- `{LANGUAGE}` - Lowercase language name (e.g., `go`, `rust`, `javascript`)
- `{LANGUAGE_DISPLAY}` - Display name (e.g., `Go`, `Rust`, `JavaScript`)
- `{REPL_COMMAND}` - REPL/interactive shell command (e.g., `irb`, `dart`, `node`, `python`)
- `{RUN_COMMAND}` - Command to execute scripts (e.g., `ruby`, `dart`, `node`, `python`, `go run`)
- `{EXT}` - File extension (e.g., `rb`, `dart`, `js`, `py`, `go`)

---

## 📝 Steps to Execute

### Step 1: Locate Core Commands Section

Find the appropriate section in `Makefile` for your language:

```bash
# View existing structure
grep "# ====" Makefile

# Typical sections:
# - Ruby Commands
# - Dart Commands
# - Python Commands
# - {LANGUAGE} Commands  <-- Add here
```

### Step 2: Add Commands Section Header

Add a clear section header for {LANGUAGE_DISPLAY} commands:

```makefile
# ============================================================================
# {LANGUAGE_DISPLAY} Commands
# ============================================================================
```

### Step 3: Add Shell Command

Create a command to open a bash shell in the {LANGUAGE} container:

```makefile
# Open {LANGUAGE_DISPLAY} development shell
{LANGUAGE}-shell:
	@echo "Opening {LANGUAGE_DISPLAY} development shell..."
	@echo "📂 Working directory: /app"
	@echo "💡 Tip: Use '{LANGUAGE} --version' to verify installation"
	@echo ""
	docker compose exec {LANGUAGE}-env bash
```

**Alternative for containers without bash:**

```makefile
{LANGUAGE}-shell:
	@echo "Opening {LANGUAGE_DISPLAY} development shell..."
	docker compose exec {LANGUAGE}-env sh
```

### Step 4: Add REPL Command

Create a command to start the language's interactive REPL:

```makefile
# Start {LANGUAGE_DISPLAY} REPL/interactive shell
{LANGUAGE}-repl:
	@echo "Starting {LANGUAGE_DISPLAY} REPL..."
	@echo "💡 Tip: Type 'exit' or Ctrl+D to quit"
	@echo ""
	docker compose exec {LANGUAGE}-env {REPL_COMMAND}
```

### Step 5: Add Run Script Command

Create a command to execute {LANGUAGE} scripts:

```makefile
# Run a {LANGUAGE_DISPLAY} script
# Usage: make run-{LANGUAGE} SCRIPT=path/to/script.{EXT}
run-{LANGUAGE}:
	@if [ -z "$(SCRIPT)" ]; then \
		echo "❌ Error: SCRIPT variable is required"; \
		echo "Usage: make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/hello.{EXT}"; \
		exit 1; \
	fi
	@echo "🚀 Running {LANGUAGE_DISPLAY} script: $(SCRIPT)"
	@echo ""
	docker compose exec {LANGUAGE}-env {RUN_COMMAND} $(SCRIPT)
```

### Step 6: Update Help Menu

Add {LANGUAGE_DISPLAY} commands to the main help output:

Find the help target and add a new section:

```makefile
help:
	@echo "learning-with-claude - Development Commands"
	@echo "=========================================="
	@echo ""
	# ... existing sections ...
	@echo "📦 {LANGUAGE_DISPLAY} Commands:"
	@echo "  make {LANGUAGE}-shell                    Open {LANGUAGE_DISPLAY} development shell"
	@echo "  make {LANGUAGE}-repl                     Start {LANGUAGE_DISPLAY} REPL"
	@echo "  make run-{LANGUAGE} SCRIPT=<path>        Run a {LANGUAGE_DISPLAY} script"
	@echo ""
```

---

## ✅ Validation Checklist

After adding commands, verify:

- [ ] Section header added with proper formatting
- [ ] `{LANGUAGE}-shell` command opens bash/sh in container
- [ ] `{LANGUAGE}-repl` starts interactive REPL
- [ ] `run-{LANGUAGE}` executes scripts with error handling
- [ ] SCRIPT variable validation included
- [ ] Help menu updated with {LANGUAGE} section
- [ ] Command descriptions are clear and helpful
- [ ] Echo statements provide user guidance
- [ ] Makefile syntax is valid (tabs for indentation)

### Validation Commands

```bash
# Verify Makefile syntax
make -n {LANGUAGE}-shell

# Test help output
make help | grep -A 5 "{LANGUAGE_DISPLAY}"

# Test shell command
make {LANGUAGE}-shell
# Inside container:
{LANGUAGE} --version
exit

# Test REPL
make {LANGUAGE}-repl
# Type: print("Hello from {LANGUAGE}") or equivalent
# Exit REPL

# Test run command with error
make run-{LANGUAGE}
# Should show error message about missing SCRIPT

# Test run command with script
make run-{LANGUAGE} SCRIPT={LANGUAGE}/tutorials/1-Getting-Started/hello.{EXT}
# Should execute and show output
```

---

## 📝 Language-Specific Examples

### Go

```makefile
# ============================================================================
# Go Commands
# ============================================================================

# Open Go development shell
go-shell:
	@echo "Opening Go development shell..."
	@echo "📂 Working directory: /app"
	@echo "💡 Tip: Use 'go version' to verify installation"
	@echo ""
	docker compose exec go-env bash

# Start Go REPL (using gore or direct compilation)
go-repl:
	@echo "Starting Go interactive environment..."
	@echo "💡 Note: Go doesn't have a built-in REPL"
	@echo "💡 Opening shell for go run experiments"
	@echo ""
	docker compose exec go-env bash

# Run a Go script
# Usage: make run-go SCRIPT=path/to/main.go
run-go:
	@if [ -z "$(SCRIPT)" ]; then \
		echo "❌ Error: SCRIPT variable is required"; \
		echo "Usage: make run-go SCRIPT=go/tutorials/1-Getting-Started/hello.go"; \
		exit 1; \
	fi
	@echo "🚀 Running Go script: $(SCRIPT)"
	@echo ""
	docker compose exec go-env go run $(SCRIPT)
```

### Rust

```makefile
# ============================================================================
# Rust Commands
# ============================================================================

# Open Rust development shell
rust-shell:
	@echo "Opening Rust development shell..."
	@echo "📂 Working directory: /app"
	@echo "💡 Tip: Use 'rustc --version' to verify installation"
	@echo ""
	docker compose exec rust-env bash

# Start Rust REPL
rust-repl:
	@echo "Starting Rust REPL (evcxr)..."
	@echo "💡 Tip: Type ':quit' to exit"
	@echo ""
	docker compose exec rust-env evcxr

# Run a Rust script
# Usage: make run-rust SCRIPT=path/to/main.rs
run-rust:
	@if [ -z "$(SCRIPT)" ]; then \
		echo "❌ Error: SCRIPT variable is required"; \
		echo "Usage: make run-rust SCRIPT=rust/tutorials/1-Getting-Started/hello.rs"; \
		exit 1; \
	fi
	@echo "🚀 Running Rust script: $(SCRIPT)"
	@echo ""
	docker compose exec rust-env bash -c "rustc $(SCRIPT) -o /tmp/rust_temp && /tmp/rust_temp"
```

### JavaScript/Node

```makefile
# ============================================================================
# JavaScript/Node Commands
# ============================================================================

# Open Node development shell
node-shell:
	@echo "Opening Node.js development shell..."
	@echo "📂 Working directory: /app"
	@echo "💡 Tip: Use 'node --version' to verify installation"
	@echo ""
	docker compose exec node-env bash

# Start Node REPL
node-repl:
	@echo "Starting Node.js REPL..."
	@echo "💡 Tip: Use '.exit' or Ctrl+D to quit"
	@echo ""
	docker compose exec node-env node

# Run a JavaScript script
# Usage: make run-node SCRIPT=path/to/script.js
run-node:
	@if [ -z "$(SCRIPT)" ]; then \
		echo "❌ Error: SCRIPT variable is required"; \
		echo "Usage: make run-node SCRIPT=javascript/tutorials/1-Getting-Started/hello.js"; \
		exit 1; \
	fi
	@echo "🚀 Running Node.js script: $(SCRIPT)"
	@echo ""
	docker compose exec node-env node $(SCRIPT)
```

---

## 🔧 Troubleshooting

### "make: *** missing separator"

Ensure you're using TABS (not spaces) for command indentation:

```makefile
target:
→   @echo "Use TAB here, not spaces"
```

### "docker compose exec: no such service"

Verify service name matches docker-compose.yml:

```bash
docker compose config --services | grep {LANGUAGE}
```

### REPL command not found

Install REPL tool in Dockerfile or use alternative:

```dockerfile
# For Go (gore REPL)
RUN go install github.com/x-motemen/gore/cmd/gore@latest

# For Rust (evcxr REPL)
RUN cargo install evcxr_repl
```

### Script execution fails

Check file path and permissions:

```bash
make {LANGUAGE}-shell
# Inside container:
ls -la $(SCRIPT)
{LANGUAGE} $(SCRIPT)
```

---

## 📚 References

- Existing Makefile commands (Ruby, Dart, Python sections)
- Make documentation: https://www.gnu.org/software/make/manual/
- Docker Compose exec: https://docs.docker.com/compose/reference/exec/

---

## 🔜 Next Steps

After completing this prompt, proceed to:
- **[Phase 2.2: Add Lab Commands](02-add-lab-commands.md)**
