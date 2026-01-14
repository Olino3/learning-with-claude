.PHONY: help up down restart logs build clean shell repl run-script \
        sinatra-shell sinatra-start sinatra-stop sinatra-logs sinatra-tutorial sinatra-lab \
        db-console redis-cli status \
        dart-shell dart-repl run-dart

# Default target
help:
	@echo "╔══════════════════════════════════════════════════════════════════════════════╗"
	@echo "║          Ruby & Dart Learning Environment - Available Commands               ║"
	@echo "╚══════════════════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "🚀 Getting Started:"
	@echo "  make up              - Start the development environment with Tilt"
	@echo "  make up-docker       - Start with Docker Compose (no Tilt required)"
	@echo "  make down            - Stop all containers"
	@echo "  make status          - Show status of all containers"
	@echo ""
	@echo "📦 Ruby Commands:"
	@echo "  make shell           - Open a bash shell in ruby-scripts container"
	@echo "  make repl            - Start an interactive Ruby REPL (IRB)"
	@echo "  make run-script      - Run a Ruby script"
	@echo "                         Usage: make run-script SCRIPT=scripts/hello.rb"
	@echo ""
	@echo "🎯 Dart Commands:"
	@echo "  make dart-shell      - Open a bash shell in dart-scripts container"
	@echo "  make dart-repl       - Start an interactive Dart REPL"
	@echo "  make run-dart        - Run a Dart script"
	@echo "                         Usage: make run-dart SCRIPT=scripts/hello.dart"
	@echo ""
	@echo "🌐 Sinatra Web Development:"
	@echo "  make sinatra-shell   - Open a bash shell in sinatra-web container"
	@echo "  make sinatra-start   - Start a Sinatra app (default: hello.rb)"
	@echo "                         Usage: make sinatra-start APP=ruby/tutorials/sinatra/1-hello-sinatra/hello.rb"
	@echo "  make sinatra-stop    - Stop the running Sinatra app"
	@echo "  make sinatra-logs    - View logs from the sinatra-web container"
	@echo "  make sinatra-tutorial - Run a Sinatra tutorial by number"
	@echo "                         Usage: make sinatra-tutorial NUM=1"
	@echo "  make sinatra-lab     - Run a Sinatra lab by number"
	@echo "                         Usage: make sinatra-lab NUM=1"
	@echo ""
	@echo "🗄️  Database Commands:"
	@echo "  make db-console      - Open PostgreSQL interactive console"
	@echo "  make redis-cli       - Open Redis CLI"
	@echo ""
	@echo "🔧 Maintenance Commands:"
	@echo "  make restart         - Restart all containers"
	@echo "  make logs            - View all container logs"
	@echo "  make build           - Build/rebuild containers"
	@echo "  make clean           - Remove containers and volumes"
	@echo ""
	@echo "📖 Quick Start Guides:"
	@echo "  Ruby Basics:    Start with ruby/tutorials/1-Getting-Started/"
	@echo "  Sinatra Web:    Start with ruby/tutorials/sinatra/1-hello-sinatra/"
	@echo "  Sinatra Labs:   Practice with ruby/labs/sinatra/1-todo-app/"
	@echo "  Dart Basics:    Start with dart/tutorials/1-Getting-Started/"
	@echo ""
	@echo "🌐 Web Application Ports (when running Sinatra):"
	@echo "  http://localhost:4567  - Default Sinatra port"
	@echo "  http://localhost:9292  - Rack applications"
	@echo "  http://localhost:3000  - Alternative web port"

# Start development environment with Tilt
up:
	@echo "Starting multi-language development environment with Tilt..."
	@echo "Note: This requires Tilt to be installed (https://tilt.dev)"
	@echo "If you don't have Tilt, use: make up-docker"
	tilt up

# Alternative: Start without Tilt
up-docker:
	@echo "Starting multi-language development environment with Docker Compose..."
	@echo "💡 Using BuildKit for optimized builds..."
	DOCKER_BUILDKIT=1 docker compose up -d
	@echo ""
	@echo "✅ Environment started!"
	@echo ""
	@echo "📦 Available containers:"
	@docker compose ps --format "   • {{.Name}} - {{.Status}}"
	@echo ""
	@echo "🚀 Next steps:"
	@echo "   Ruby: Run 'make shell' or 'make repl'"
	@echo "   Dart: Run 'make dart-shell' or 'make dart-repl'"
	@echo "   Sinatra: Run 'make sinatra-tutorial NUM=1'"
	@echo ""
	@echo "🌐 Web ports available:"
	@echo "   http://localhost:4567 - Sinatra default"
	@echo "   http://localhost:9292 - Rack apps"
	@echo "   http://localhost:3000 - Alternative"

# Show status of all containers
status:
	@echo "📦 Container Status:"
	@docker compose ps
	@echo ""
	@echo "🌐 Port Mappings:"
	@docker compose ps --format "table {{.Name}}\t{{.Ports}}" | grep -E "NAME|sinatra|postgres|redis" || true

# Stop all containers
down:
	@echo "Stopping development environment..."
	docker compose down

# Restart containers
restart:
	@echo "Restarting development environment..."
	docker compose restart

# View logs
logs:
	docker compose logs -f

# Build or rebuild containers
build:
	@echo "Building containers with BuildKit optimizations..."
	@echo "💡 Tip: This will use cached layers for faster builds"
	DOCKER_BUILDKIT=1 docker compose build

# Clean up containers and volumes
clean:
	@echo "Cleaning up containers and volumes..."
	docker compose down -v
	@echo "✅ Cleanup complete!"

# ============================================================================
# Ruby Commands
# ============================================================================

# Open bash shell in ruby-scripts container
shell:
	@echo "Opening bash shell in ruby-scripts container..."
	docker compose exec ruby-scripts bash

# Start interactive Ruby REPL
repl:
	@echo "Starting Ruby REPL (IRB)..."
	@echo "Type 'exit' to quit the REPL"
	docker compose exec ruby-scripts irb

# Run a specific Ruby script
# Usage: make run-script SCRIPT=scripts/hello.rb
run-script:
ifndef SCRIPT
	@echo "Error: Please specify a script to run"
	@echo "Usage: make run-script SCRIPT=scripts/hello.rb"
	@exit 1
endif
	@echo "Running $(SCRIPT)..."
	docker compose exec ruby-scripts ruby $(SCRIPT)

# ============================================================================
# Dart Commands
# ============================================================================

# Open bash shell in dart-scripts container
dart-shell:
	@echo "Opening bash shell in dart-scripts container..."
	docker compose exec dart-scripts bash

# Start interactive Dart REPL
dart-repl:
	@echo "Starting Dart REPL..."
	@echo "Type ':quit' or press Ctrl+D to quit the REPL"
	docker compose exec dart-scripts dart repl

# Run a specific Dart script
# Usage: make run-dart SCRIPT=scripts/hello.dart
run-dart:
ifndef SCRIPT
	@echo "Error: Please specify a script to run"
	@echo "Usage: make run-dart SCRIPT=scripts/hello.dart"
	@exit 1
endif
	@echo "Running $(SCRIPT)..."
	docker compose exec dart-scripts dart run $(SCRIPT)

# ============================================================================
# Sinatra Web Development Commands
# ============================================================================

# Open bash shell in sinatra-web container
sinatra-shell:
	@echo "Opening bash shell in sinatra-web container..."
	@echo "💡 Tip: You can run Sinatra apps with: ruby -r sinatra/reloader <app.rb>"
	docker compose exec sinatra-web bash

# Start a Sinatra application
# Usage: make sinatra-start APP=ruby/tutorials/sinatra/1-hello-sinatra/hello.rb
# Default: starts the hello world tutorial
sinatra-start:
	@echo "Starting Sinatra application..."
	@APP_PATH=$${APP:-ruby/tutorials/sinatra/1-hello-sinatra/hello.rb}; \
	if [ ! -f "$$APP_PATH" ]; then \
		echo "❌ Error: File not found: $$APP_PATH"; \
		echo ""; \
		echo "Available tutorials:"; \
		ls -1 ruby/tutorials/sinatra/*/app.rb ruby/tutorials/sinatra/*/*.rb 2>/dev/null | head -10; \
		exit 1; \
	fi; \
	echo "📂 Running: $$APP_PATH"; \
	echo "🌐 Access at: http://localhost:4567"; \
	echo "💡 Press Ctrl+C to stop the server"; \
	echo ""; \
	docker compose exec sinatra-web ruby $$APP_PATH -o 0.0.0.0

# Start a Sinatra app in the background
sinatra-start-bg:
	@echo "Starting Sinatra application in background..."
	@APP_PATH=$${APP:-ruby/tutorials/sinatra/1-hello-sinatra/hello.rb}; \
	docker compose exec -d -e SINATRA_BIND=0.0.0.0 sinatra-web ruby $$APP_PATH
	@echo "✅ App started in background"
	@echo "🌐 Access at: http://localhost:4567"
	@echo "💡 Use 'make sinatra-stop' to stop the server"
	@echo "💡 Use 'make sinatra-logs' to view logs"

# Stop running Sinatra applications (restarts the container)
sinatra-stop:
	@echo "Stopping Sinatra applications (restarting container)..."
	@docker compose restart sinatra-web > /dev/null 2>&1
	@echo "✅ Sinatra applications stopped"

# View sinatra-web container logs
sinatra-logs:
	@echo "Viewing sinatra-web logs (Ctrl+C to exit)..."
	docker compose logs -f sinatra-web

# Run a Sinatra tutorial by number
# Usage: make sinatra-tutorial NUM=1
sinatra-tutorial:
ifndef NUM
	@echo "❌ Error: Please specify a tutorial number"
	@echo "Usage: make sinatra-tutorial NUM=1"
	@echo ""
	@echo "Available tutorials:"
	@echo "  1 - Hello Sinatra (basics)"
	@echo "  2 - Routes and Parameters"
	@echo "  3 - Templates and Views"
	@echo "  4 - Forms and Input"
	@echo "  5 - Working with Databases"
	@echo "  6 - Sessions and Cookies"
	@echo "  7 - Middleware and Filters"
	@echo "  8 - RESTful APIs"
	@exit 1
endif
	@echo "🧹 Stopping any running Sinatra servers..."
	@docker compose exec -T sinatra-web sh -c 'kill $$(pgrep -f "ruby|rackup|puma" 2>/dev/null) 2>/dev/null' || true
	@sleep 1
	@TUTORIAL_DIR=$$(ls -d ruby/tutorials/sinatra/$(NUM)-* 2>/dev/null | head -1); \
	if [ -z "$$TUTORIAL_DIR" ]; then \
		echo "❌ Error: Tutorial $(NUM) not found"; \
		echo "Available tutorials:"; \
		ls -d ruby/tutorials/sinatra/*/ | sed 's/ruby\/tutorials\/sinatra\//  /g'; \
		exit 1; \
	fi; \
	MAIN_FILE=$$(ls $$TUTORIAL_DIR/app.rb $$TUTORIAL_DIR/hello.rb $$TUTORIAL_DIR/*_demo.rb 2>/dev/null | head -1); \
	if [ -z "$$MAIN_FILE" ]; then \
		echo "❌ No runnable file found in $$TUTORIAL_DIR"; \
		echo "Available files:"; \
		ls $$TUTORIAL_DIR/*.rb 2>/dev/null; \
		exit 1; \
	fi; \
	echo "📚 Starting Tutorial $(NUM): $$TUTORIAL_DIR"; \
	echo "📂 Running: $$MAIN_FILE"; \
	echo "🌐 Access at: http://localhost:4567"; \
	echo "💡 Press Ctrl+C to stop the server"; \
	echo "📖 Read the tutorial: $$TUTORIAL_DIR/README.md"; \
	echo ""; \
	docker compose exec -e SINATRA_BIND=0.0.0.0 sinatra-web ruby $$MAIN_FILE

# Run a Sinatra lab by number
# Usage: make sinatra-lab NUM=1
sinatra-lab:
ifndef NUM
	@echo "❌ Error: Please specify a lab number"
	@echo "Usage: make sinatra-lab NUM=1"
	@echo ""
	@echo "Available labs:"
	@echo "  1 - Todo Application"
	@echo "  2 - Blog API"
	@echo "  3 - Authentication App"
	@echo "  4 - Real-time Chat"
	@exit 1
endif
	@echo "🧹 Stopping any running Sinatra servers..."
	@docker compose exec -T sinatra-web sh -c 'kill $$(pgrep -f "ruby|rackup|puma" 2>/dev/null) 2>/dev/null' || true
	@sleep 1
	@LAB_DIR=$$(ls -d ruby/labs/sinatra/$(NUM)-* 2>/dev/null | head -1); \
	if [ -z "$$LAB_DIR" ]; then \
		echo "❌ Error: Lab $(NUM) not found"; \
		echo "Available labs:"; \
		ls -d ruby/labs/sinatra/*/ | sed 's/ruby\/labs\/sinatra\//  /g'; \
		exit 1; \
	fi; \
	MAIN_FILE=$$(ls $$LAB_DIR/app.rb 2>/dev/null | head -1); \
	if [ -z "$$MAIN_FILE" ]; then \
		echo "❌ No app.rb found in $$LAB_DIR"; \
		echo "Available files:"; \
		ls $$LAB_DIR/*.rb 2>/dev/null; \
		exit 1; \
	fi; \
	echo "🧪 Starting Lab $(NUM): $$LAB_DIR"; \
	echo "📂 Running: $$MAIN_FILE"; \
	echo "🌐 Access at: http://localhost:4567"; \
	echo "💡 Press Ctrl+C to stop the server"; \
	echo "📖 Read the lab guide: $$LAB_DIR/README.md"; \
	echo "📝 Follow the steps: $$LAB_DIR/STEPS.md"; \
	echo ""; \
	docker compose exec -w /app/$$LAB_DIR sinatra-web rackup -o 0.0.0.0 -p 4567

# ============================================================================
# Database Commands
# ============================================================================

# Open PostgreSQL console
db-console:
	@echo "Opening PostgreSQL console..."
	@echo "💡 Database: sinatra_dev | User: postgres"
	docker compose exec postgres psql -U postgres -d sinatra_dev

# Open Redis CLI
redis-cli:
	@echo "Opening Redis CLI..."
	docker compose exec redis redis-cli
