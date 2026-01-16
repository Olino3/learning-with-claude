# Phase 2.2: Add Lab Commands

**Objective:** Add Makefile commands for running {LANGUAGE_DISPLAY} labs at all difficulty levels.

---

## 📋 Context

Labs are organized by difficulty: beginner (3 labs), intermediate (1 project), and advanced (4 labs). Make commands provide convenient shortcuts to run these labs.

---

## 🎯 Your Task

Add lab execution commands to the `Makefile`.

### Variables to Substitute

- `{LANGUAGE}` - Lowercase language name
- `{LANGUAGE_DISPLAY}` - Display name
- `{RUN_COMMAND}` - Script execution command
- `{EXT}` - File extension

---

## 📝 Steps to Execute

### Step 1: Add Beginner Lab Command

```makefile
# Run beginner lab by number (1-3)
# Usage: make {LANGUAGE}-beginner-lab NUM=1
{LANGUAGE}-beginner-lab:
	@if [ -z "$(NUM)" ]; then \
		echo "❌ Error: NUM variable is required"; \
		echo "Usage: make {LANGUAGE}-beginner-lab NUM=1"; \
		echo "Available labs: 1-3"; \
		exit 1; \
	fi
	@if [ "$(NUM)" = "1" ]; then \
		LAB_DIR="{LANGUAGE}/labs/beginner/lab1-basics"; \
		LAB_NAME="Basics"; \
		LAB_FILE="solution.{EXT}"; \
	elif [ "$(NUM)" = "2" ]; then \
		LAB_DIR="{LANGUAGE}/labs/beginner/lab2-collections"; \
		LAB_NAME="Collections"; \
		LAB_FILE="solution.{EXT}"; \
	elif [ "$(NUM)" = "3" ]; then \
		LAB_DIR="{LANGUAGE}/labs/beginner/lab3-{TOPIC}"; \
		LAB_NAME="{Topic}"; \
		LAB_FILE="solution.{EXT}"; \
	else \
		echo "❌ Error: Lab $(NUM) not found"; \
		echo "Available labs: 1-3"; \
		exit 1; \
	fi; \
	echo "🚀 Running Beginner Lab $(NUM): $$LAB_NAME"; \
	echo "📂 Location: $$LAB_DIR"; \
	echo "📖 Read the lab guide: $${LAB_DIR}/README.md"; \
	echo ""; \
	docker compose exec {LANGUAGE}-env {RUN_COMMAND} $$LAB_DIR/$$LAB_FILE
```

### Step 2: Add Intermediate Lab Command

```makefile
# Run intermediate lab (single complex project)
# Usage: make {LANGUAGE}-intermediate-lab
{LANGUAGE}-intermediate-lab:
	@LAB_DIR="{LANGUAGE}/labs/intermediate-lab"; \
	LAB_NAME="Intermediate Project"; \
	LAB_FILE="main.{EXT}"; \
	echo "🚀 Running Intermediate Lab: $$LAB_NAME"; \
	echo "📂 Location: $$LAB_DIR"; \
	echo "📖 Read the lab guide: $${LAB_DIR}/README.md"; \
	echo "📝 Follow progressive steps: $${LAB_DIR}/STEPS.md"; \
	echo ""; \
	docker compose exec {LANGUAGE}-env {RUN_COMMAND} $$LAB_DIR/$$LAB_FILE
```

### Step 3: Add Advanced Lab Command

```makefile
# Run advanced lab by number (1-4)
# Usage: make {LANGUAGE}-advanced-lab NUM=1
{LANGUAGE}-advanced-lab:
	@if [ -z "$(NUM)" ]; then \
		echo "❌ Error: NUM variable is required"; \
		echo "Usage: make {LANGUAGE}-advanced-lab NUM=1"; \
		echo "Available labs: 1-4"; \
		exit 1; \
	fi
	@if [ "$(NUM)" = "1" ]; then \
		LAB_DIR="{LANGUAGE}/labs/advanced/dsl-builder-lab/solution"; \
		LAB_NAME="DSL Builder"; \
		LAB_FILE="demo.{EXT}"; \
	elif [ "$(NUM)" = "2" ]; then \
		LAB_DIR="{LANGUAGE}/labs/advanced/concurrent-processor-lab/solution"; \
		LAB_NAME="Concurrent Processor"; \
		LAB_FILE="demo.{EXT}"; \
	elif [ "$(NUM)" = "3" ]; then \
		LAB_DIR="{LANGUAGE}/labs/advanced/performance-optimizer-lab/solution"; \
		LAB_NAME="Performance Optimizer"; \
		LAB_FILE="demo.{EXT}"; \
	elif [ "$(NUM)" = "4" ]; then \
		LAB_DIR="{LANGUAGE}/labs/advanced/mini-framework-lab/solution"; \
		LAB_NAME="Mini Framework"; \
		LAB_FILE="demo.{EXT}"; \
	else \
		echo "❌ Error: Lab $(NUM) not found"; \
		echo "Available labs: 1-4"; \
		exit 1; \
	fi; \
	echo "🚀 Running Advanced Lab $(NUM): $$LAB_NAME"; \
	echo "📂 Location: $$LAB_DIR"; \
	echo "📖 Read the lab guide: $${LAB_DIR%/solution}/README.md"; \
	echo "📝 Solution guide: $$LAB_DIR/README.md"; \
	echo ""; \
	docker compose exec {LANGUAGE}-env {RUN_COMMAND} $$LAB_DIR/$$LAB_FILE
```

### Step 4: Update Help Menu

Add lab commands to help output:

```makefile
help:
	# ... existing content ...
	@echo "  make {LANGUAGE}-beginner-lab NUM=<1-3>   Run beginner lab by number"
	@echo "  make {LANGUAGE}-intermediate-lab         Run intermediate lab"
	@echo "  make {LANGUAGE}-advanced-lab NUM=<1-4>   Run advanced lab by number"
	@echo ""
```

---

## ✅ Validation Checklist

- [ ] Beginner lab command added with NUM validation
- [ ] All 3 beginner labs mapped correctly
- [ ] Intermediate lab command added
- [ ] Advanced lab command added with NUM validation
- [ ] All 4 advanced labs mapped correctly
- [ ] Error messages provide helpful guidance
- [ ] Lab directory paths are correct
- [ ] File names match actual solution files
- [ ] Help menu updated

### Validation Commands

```bash
# Test beginner labs
make {LANGUAGE}-beginner-lab NUM=1
make {LANGUAGE}-beginner-lab NUM=2
make {LANGUAGE}-beginner-lab NUM=3

# Test error handling
make {LANGUAGE}-beginner-lab          # Should error (no NUM)
make {LANGUAGE}-beginner-lab NUM=5    # Should error (invalid NUM)

# Test intermediate lab
make {LANGUAGE}-intermediate-lab

# Test advanced labs
make {LANGUAGE}-advanced-lab NUM=1
make {LANGUAGE}-advanced-lab NUM=2
make {LANGUAGE}-advanced-lab NUM=3
make {LANGUAGE}-advanced-lab NUM=4

# Check help output
make help | grep -A 6 "{LANGUAGE_DISPLAY}"
```

---

## 📝 Notes

### Customizing Lab Names

Update lab names based on your actual lab content:

```makefile
# Lab 3 examples:
lab3-functions     # For function-focused lab
lab3-oop           # For OOP concepts lab
lab3-patterns      # For design patterns lab
```

### Advanced Lab Topics

Standard advanced lab topics (customize as needed):

1. **DSL Builder** - Domain-Specific Language creation
2. **Concurrent Processor** - Parallelism/threading
3. **Performance Optimizer** - Benchmarking/profiling
4. **Mini Framework** - Design patterns/architecture

---

## 🔜 Next Steps

After completing this prompt, proceed to:
- **[Phase 2.3: Add Framework Commands](03-add-framework-commands.md)** (if applicable)
