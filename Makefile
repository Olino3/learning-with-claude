.PHONY: help up down restart logs build clean shell repl run-script \
        sinatra-shell sinatra-start sinatra-stop sinatra-logs sinatra-tutorial sinatra-lab \
        beginner-lab intermediate-lab advanced-lab \
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
	@echo "  make shell           - Open a bash shell in ruby-env container"
	@echo "  make repl            - Start an interactive Ruby REPL (IRB)"
	@echo "  make run-script      - Run a Ruby script"
	@echo "                         Usage: make run-script SCRIPT=scripts/hello.rb"
	@echo "  make beginner-lab    - Run a beginner lab (1-3)"
	@echo "                         Usage: make beginner-lab NUM=1"
	@echo "  make intermediate-lab - Run the intermediate lab (Blog System)"
	@echo "  make advanced-lab    - Run an advanced lab (1-4)"
	@echo "                         Usage: make advanced-lab NUM=1"
	@echo ""
	@echo "🎯 Dart Commands:"
	@echo "  make dart-shell      - Open a bash shell in dart-env container"
	@echo "  make dart-repl       - Open interactive Dart shell"
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
	@echo "  make websocket-server - Start WebSocket server (for lab 4)"
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
	@echo "  Ruby Basics:       Start with ruby/tutorials/1-Getting-Started/"
	@echo "  Beginner Labs:     Practice with ruby/labs/beginner/lab1-basics/"
	@echo "                     Run with: make beginner-lab NUM=1"
	@echo "  Intermediate Lab:  Build a blog system → make intermediate-lab"
	@echo "  Advanced Labs:     Master advanced concepts with ruby/labs/advanced/"
	@echo "                     Run with: make advanced-lab NUM=1"
	@echo "  Sinatra Web:       Start with ruby/tutorials/sinatra/1-hello-sinatra/"
	@echo "  Sinatra Labs:      Practice with ruby/labs/sinatra/1-todo-app/"
	@echo "                     Run with: make sinatra-lab NUM=1"
	@echo "  Dart Basics:       Start with dart/tutorials/1-Getting-Started/"
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

# Open bash shell in ruby-env container
shell:
	@echo "Opening bash shell in ruby-env container..."
	docker compose exec ruby-env bash

# Start interactive Ruby REPL
repl:
	@echo "Starting Ruby REPL (IRB)..."
	@echo "Type 'exit' to quit the REPL"
	docker compose exec ruby-env irb

# Run a specific Ruby script
# Usage: make run-script SCRIPT=scripts/hello.rb
run-script:
ifndef SCRIPT
	@echo "Error: Please specify a script to run"
	@echo "Usage: make run-script SCRIPT=scripts/hello.rb"
	@exit 1
endif
	@echo "Running $(SCRIPT)..."
	docker compose exec ruby-env ruby $(SCRIPT)

# ============================================================================
# Dart Commands
# ============================================================================

# Open bash shell in dart-env container
dart-shell:
	@echo "Opening bash shell in dart-env container..."
	docker compose exec dart-env bash

# Start interactive Dart shell
# Note: Dart doesn't have a built-in REPL like Ruby's IRB
# This opens a bash shell where you can run Dart scripts interactively
dart-repl:
	@echo "Opening an interactive bash shell in the dart-env container..."
	@echo ""
	@echo "💡 Try these commands:"
	@echo "   dart run <script.dart>    - Run a Dart script"
	@echo "   dart create <project>     - Create a new Dart project"
	@echo "   dart --version            - Check Dart version"
	@echo ""
	@echo "Type 'exit' to quit the shell"
	@echo ""
	docker compose exec dart-env bash

# Run a specific Dart script
# Usage: make run-dart SCRIPT=scripts/hello.dart
run-dart:
ifndef SCRIPT
	@echo "Error: Please specify a script to run"
	@echo "Usage: make run-dart SCRIPT=scripts/hello.dart"
	@exit 1
endif
	@echo "Running $(SCRIPT)..."
	docker compose exec dart-env dart run $(SCRIPT)

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

# Start WebSocket server (for real-time chat lab)
websocket-server:
	@echo "🔌 Starting WebSocket server for real-time chat lab..."
	@echo "📡 Server will run on ws://localhost:9292"
	@echo "💡 Press Ctrl+C to stop"
	@echo ""
	docker compose exec -w /app/ruby/labs/sinatra/4-realtime-chat/solution sinatra-web ruby chat_server.rb

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
	SOLUTION_DIR="$$LAB_DIR/solution"; \
	if [ -d "$$SOLUTION_DIR" ]; then \
		WORK_DIR="$$SOLUTION_DIR"; \
	else \
		WORK_DIR="$$LAB_DIR"; \
	fi; \
	MAIN_FILE=$$(ls $$WORK_DIR/app.rb 2>/dev/null | head -1); \
	if [ -z "$$MAIN_FILE" ]; then \
		echo "❌ No app.rb found in $$WORK_DIR"; \
		echo "Available files:"; \
		ls $$WORK_DIR/*.rb 2>/dev/null; \
		exit 1; \
	fi; \
	echo "🧪 Starting Lab $(NUM): $$LAB_DIR"; \
	echo "📂 Running: $$MAIN_FILE"; \
	echo "🌐 Access at: http://localhost:4567"; \
	echo "💡 Press Ctrl+C to stop the server"; \
	echo "📖 Read the lab guide: $$LAB_DIR/README.md"; \
	echo "📝 Follow step-by-step: $$LAB_DIR/steps/1/README.md"; \
	echo ""; \
	if [ "$(NUM)" = "4" ]; then \
		echo "🔌 Starting WebSocket server (chat_server.rb) on port 9292..."; \
		docker compose exec -w /app/$$WORK_DIR -d sinatra-web ruby chat_server.rb; \
		sleep 2; \
		echo "🌐 Starting web server (app.rb) on port 4567..."; \
		echo ""; \
		docker compose exec -w /app/$$WORK_DIR sinatra-web ruby app.rb -o 0.0.0.0; \
	else \
		docker compose exec -w /app/$$WORK_DIR sinatra-web ruby app.rb -o 0.0.0.0; \
	fi

# Run a beginner lab by number
# Usage: make beginner-lab NUM=1
beginner-lab:
ifndef NUM
	@echo "❌ Error: Please specify a lab number"
	@echo "Usage: make beginner-lab NUM=1"
	@echo ""
	@echo "Available labs:"
	@echo "  1 - Ruby Basics & OOP (Book Library)"
	@echo "  2 - Collections & Iteration (Contact Manager)"
	@echo "  3 - Methods & Modules (Calculator)"
	@exit 1
endif
	@LAB_DIR=$$(ls -d ruby/labs/beginner/lab$(NUM)-* 2>/dev/null | head -1); \
	if [ -z "$$LAB_DIR" ]; then \
		echo "❌ Error: Lab $(NUM) not found"; \
		echo "Available labs:"; \
		ls -d ruby/labs/beginner/*/ | sed 's/ruby\/labs\/beginner\///g'; \
		exit 1; \
	fi; \
	SOLUTION_FILE="$$LAB_DIR/solution.rb"; \
	STARTER_FILE="$$LAB_DIR/starter.rb"; \
	if [ -f "$$SOLUTION_FILE" ]; then \
		MAIN_FILE="$$SOLUTION_FILE"; \
		FILE_TYPE="solution"; \
	elif [ -f "$$STARTER_FILE" ]; then \
		MAIN_FILE="$$STARTER_FILE"; \
		FILE_TYPE="starter"; \
	else \
		echo "❌ No solution.rb or starter.rb found in $$LAB_DIR"; \
		exit 1; \
	fi; \
	echo "🧪 Running Beginner Lab $(NUM): $$LAB_DIR"; \
	echo "📂 Running: $$FILE_TYPE.rb"; \
	echo "📖 Read the lab guide: $$LAB_DIR/README.md"; \
	echo "💡 Tip: Edit the $$FILE_TYPE.rb file and run again to test your changes"; \
	echo ""; \
	docker compose exec ruby-env ruby $$MAIN_FILE
# Run the intermediate lab (Blog System)
# Usage: make intermediate-lab
intermediate-lab:
	@echo "🏛️ Running Intermediate Lab: Blog Management System";
	@echo "📚 Concepts: Closures, Object Model, Mixins, Metaprogramming";
	@echo "📂 Location: ruby/labs/intermediate-lab";
	@echo "📖 Read the lab guide: ruby/labs/intermediate-lab/README.md";
	@echo "📝 Progressive steps: ruby/labs/intermediate-lab/STEPS.md";
	@echo "";
	docker compose exec ruby-env ruby ruby/labs/intermediate-lab/blog_system.rb

# Run an advanced lab by number
# Usage: make advanced-lab NUM=1
advanced-lab:
ifndef NUM
	@echo "❌ Error: Please specify a lab number"
	@echo "Usage: make advanced-lab NUM=1"
	@echo ""
	@echo "Available labs:"
	@echo "  1 - DSL Builder (Metaprogramming & DSLs)"
	@echo "  2 - Concurrent Task Processor (Threads, Ractors, Fibers)"
	@echo "  3 - Performance Optimizer (Profiling & Benchmarking)"
	@echo "  4 - Mini Framework (Design Patterns & Architecture)"
	@exit 1
endif
	@if [ "$(NUM)" = "1" ]; then \
		LAB_DIR="ruby/labs/advanced/dsl-builder-lab/solution"; \
		LAB_NAME="DSL Builder"; \
		LAB_FILE="dsl_demo.rb"; \
	elif [ "$(NUM)" = "2" ]; then \
		LAB_DIR="ruby/labs/advanced/concurrent-processor-lab/solution"; \
		LAB_NAME="Concurrent Task Processor"; \
		LAB_FILE="concurrent_demo.rb"; \
	elif [ "$(NUM)" = "3" ]; then \
		LAB_DIR="ruby/labs/advanced/performance-optimizer-lab/solution"; \
		LAB_NAME="Performance Optimizer"; \
		LAB_FILE="performance_demo.rb"; \
	elif [ "$(NUM)" = "4" ]; then \
		LAB_DIR="ruby/labs/advanced/mini-framework-lab/solution"; \
		LAB_NAME="Mini Framework"; \
		LAB_FILE="framework_demo.rb"; \
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
	docker compose exec ruby-env ruby $$LAB_DIR/$$LAB_FILE

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
