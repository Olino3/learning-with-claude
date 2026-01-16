# Phase 2.3: Add Framework Commands (Optional)

**Objective:** Add Makefile commands for {FRAMEWORK} web framework development (if your language includes a web framework track).

---

## 📋 Context

Some languages include dedicated framework tutorials and labs (e.g., Ruby/Sinatra, Dart/Flutter). If your language has a popular web framework, add commands for it.

---

## 🎯 Your Task

Add framework-specific commands to the `Makefile` (optional—skip if no framework track).

### Variables to Substitute

- `{LANGUAGE}` - Lowercase language name
- `{FRAMEWORK}` - Framework name (lowercase, e.g., `gin`, `axum`, `express`, `spring`)
- `{FRAMEWORK_DISPLAY}` - Framework display name
- `{START_COMMAND}` - Command to start framework server
- `{PORT}` - Primary framework port

---

## 📝 Steps to Execute

### Step 1: Add Framework Section Header

```makefile
# ============================================================================
# {FRAMEWORK_DISPLAY} Development
# ============================================================================
```

### Step 2: Add Framework Shell Command

```makefile
# Open {FRAMEWORK_DISPLAY} shell
{FRAMEWORK}-shell:
	@echo "Opening {FRAMEWORK_DISPLAY} development shell..."
	docker compose exec {FRAMEWORK}-web bash
```

### Step 3: Add Start Command

```makefile
# Start {FRAMEWORK_DISPLAY} application
# Usage: make {FRAMEWORK}-start APP=path/to/app.{EXT}
{FRAMEWORK}-start:
	@if [ -z "$(APP)" ]; then \
		echo "❌ Error: APP variable is required"; \
		echo "Usage: make {FRAMEWORK}-start APP={LANGUAGE}/tutorials/{FRAMEWORK}/1-hello-world/app.{EXT}"; \
		exit 1; \
	fi
	@echo "🚀 Starting {FRAMEWORK_DISPLAY} application..."
	@echo "📂 App: $(APP)"
	@echo "🌐 Access at: http://localhost:{PORT}"
	@echo "💡 Press Ctrl+C to stop"
	@echo ""
	docker compose exec {FRAMEWORK}-web {START_COMMAND} $(APP)
```

### Step 4: Add Stop Command

```makefile
# Stop {FRAMEWORK_DISPLAY} application
{FRAMEWORK}-stop:
	@echo "🛑 Stopping {FRAMEWORK_DISPLAY} application..."
	docker compose stop {FRAMEWORK}-web
```

### Step 5: Add Logs Command

```makefile
# View {FRAMEWORK_DISPLAY} logs
{FRAMEWORK}-logs:
	@echo "📋 {FRAMEWORK_DISPLAY} logs (Ctrl+C to exit)..."
	docker compose logs -f {FRAMEWORK}-web
```

### Step 6: Add Tutorial Command

```makefile
# Run {FRAMEWORK_DISPLAY} tutorial by number (1-8)
# Usage: make {FRAMEWORK}-tutorial NUM=1
{FRAMEWORK}-tutorial:
	@if [ -z "$(NUM)" ]; then \
		echo "❌ Error: NUM variable is required"; \
		echo "Usage: make {FRAMEWORK}-tutorial NUM=1"; \
		echo "Available tutorials: 1-8"; \
		exit 1; \
	fi
	@TUTORIAL_DIR="{LANGUAGE}/tutorials/{FRAMEWORK}/$(NUM)-*"; \
	echo "🚀 Running {FRAMEWORK_DISPLAY} Tutorial $(NUM)"; \
	echo "📂 Location: $$TUTORIAL_DIR"; \
	echo "📖 Read the guide: $$TUTORIAL_DIR/README.md"; \
	echo "🌐 Server will start at: http://localhost:{PORT}"; \
	echo "💡 Press Ctrl+C to stop"; \
	echo ""; \
	docker compose up -d {FRAMEWORK}-web && \
	docker compose logs -f {FRAMEWORK}-web
```

### Step 7: Add Lab Command

```makefile
# Run {FRAMEWORK_DISPLAY} lab by number (1-4)
# Usage: make {FRAMEWORK}-lab NUM=1
{FRAMEWORK}-lab:
	@if [ -z "$(NUM)" ]; then \
		echo "❌ Error: NUM variable is required"; \
		echo "Usage: make {FRAMEWORK}-lab NUM=1"; \
		echo "Available labs: 1-4"; \
		exit 1; \
	fi
	@if [ "$(NUM)" = "1" ]; then \
		LAB_NAME="Todo App"; \
	elif [ "$(NUM)" = "2" ]; then \
		LAB_NAME="Blog API"; \
	elif [ "$(NUM)" = "3" ]; then \
		LAB_NAME="Authentication"; \
	elif [ "$(NUM)" = "4" ]; then \
		LAB_NAME="Real-time Chat"; \
	else \
		echo "❌ Error: Lab $(NUM) not found"; \
		echo "Available labs: 1-4"; \
		exit 1; \
	fi; \
	echo "🚀 Running {FRAMEWORK_DISPLAY} Lab $(NUM): $$LAB_NAME"; \
	echo "📂 Location: {LANGUAGE}/labs/{FRAMEWORK}/$(NUM)-*"; \
	echo "🌐 Server will start at: http://localhost:{PORT}"; \
	echo "💡 Press Ctrl+C to stop"; \
	echo ""; \
	docker compose up -d {FRAMEWORK}-web && \
	docker compose logs -f {FRAMEWORK}-web
```

### Step 8: Update Help Menu

```makefile
help:
	# ... existing content ...
	@echo "🌐 {FRAMEWORK_DISPLAY} Development:"
	@echo "  make {FRAMEWORK}-shell                   Open {FRAMEWORK_DISPLAY} shell"
	@echo "  make {FRAMEWORK}-start APP=<path>        Start {FRAMEWORK_DISPLAY} app"
	@echo "  make {FRAMEWORK}-stop                    Stop {FRAMEWORK_DISPLAY} app"
	@echo "  make {FRAMEWORK}-logs                    View {FRAMEWORK_DISPLAY} logs"
	@echo "  make {FRAMEWORK}-tutorial NUM=<1-8>      Run tutorial by number"
	@echo "  make {FRAMEWORK}-lab NUM=<1-4>           Run lab by number"
	@echo ""
	@echo "🌐 Web Application Ports:"
	@echo "  {FRAMEWORK_DISPLAY}: http://localhost:{PORT}"
	@echo ""
```

---

## ✅ Validation Checklist

- [ ] Framework section header added
- [ ] Shell command opens framework container
- [ ] Start command with APP variable validation
- [ ] Stop command stops framework service
- [ ] Logs command streams framework logs
- [ ] Tutorial command (1-8) added
- [ ] Lab command (1-4) added
- [ ] Help menu updated with framework section
- [ ] Port documented in help output

### Validation Commands

```bash
# Test shell
make {FRAMEWORK}-shell
exit

# Test tutorial (will start server)
make {FRAMEWORK}-tutorial NUM=1
# Ctrl+C to stop

# Test lab
make {FRAMEWORK}-lab NUM=1
# Ctrl+C to stop

# Test stop
make {FRAMEWORK}-stop

# Test logs
make {FRAMEWORK}-logs
# Ctrl+C to exit

# Check help
make help | grep -A 10 "{FRAMEWORK_DISPLAY}"
```

---

## 📝 Framework-Specific Examples

### Go (Gin)

```makefile
gin-start:
	@echo "🚀 Starting Gin application..."
	docker compose exec gin-web go run $(APP)

gin-tutorial:
	# Use port 8090
	docker compose up -d gin-web
```

### Rust (Axum)

```makefile
axum-start:
	@echo "🚀 Starting Axum application..."
	docker compose exec axum-web cargo run --release

axum-tutorial:
	# Use port 8100
	docker compose up -d axum-web
```

### Node (Express)

```makefile
express-start:
	@echo "🚀 Starting Express application..."
	docker compose exec express-web node $(APP)

express-tutorial:
	# Use port 3001
	docker compose up -d express-web
```

### Python (Flask)

```makefile
flask-start:
	@echo "🚀 Starting Flask application..."
	docker compose exec flask-web flask run --host=0.0.0.0

flask-tutorial:
	# Use port 5000
	docker compose up -d flask-web
```

---

## 🔧 Troubleshooting

### "Service '{FRAMEWORK}-web' not found"

Ensure service exists in docker-compose.yml:

```bash
docker compose config --services | grep {FRAMEWORK}
```

### Server doesn't start

Check framework service logs:

```bash
make {FRAMEWORK}-logs
```

### Port already in use

Change port in docker-compose.yml and update Makefile help.

---

## 🎉 Phase 2 Complete!

You've added all Makefile commands for {LANGUAGE_DISPLAY}:

✅ Core commands (shell, REPL, run-script)
✅ Lab commands (beginner, intermediate, advanced)
✅ Framework commands (if applicable)

---

## 🔜 Next Phase

Proceed to **Phase 3: Beginner Tutorials** to create the first 10 tutorials:

- **[Phase 3: Generate Beginner Tutorials](../3-beginner-tutorials/README.md)**
