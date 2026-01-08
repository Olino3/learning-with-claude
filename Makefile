.PHONY: help up down restart logs build clean shell repl run-script

# Default target
help:
	@echo "Ruby Learning Environment - Available Commands:"
	@echo ""
	@echo "  make up          - Start the development environment with Tilt"
	@echo "  make down        - Stop all containers"
	@echo "  make restart     - Restart all containers"
	@echo "  make logs        - View container logs"
	@echo "  make build       - Build/rebuild containers"
	@echo "  make clean       - Remove containers and volumes"
	@echo "  make shell       - Open a bash shell in ruby-scripts container"
	@echo "  make repl        - Start an interactive Ruby REPL (IRB)"
	@echo "  make run-script  - Run a Ruby script (usage: make run-script SCRIPT=scripts/hello.rb)"
	@echo ""
	@echo "Example workflows:"
	@echo "  1. Start environment:  make up"
	@echo "  2. Run a script:       make run-script SCRIPT=scripts/hello.rb"
	@echo "  3. Open Ruby REPL:     make repl"
	@echo "  4. Stop environment:   make down"

# Start development environment with Tilt
up:
	@echo "Starting Ruby development environment with Tilt..."
	@echo "Note: This requires Tilt to be installed (https://tilt.dev)"
	@echo "If you don't have Tilt, use: docker-compose up -d"
	tilt up

# Alternative: Start without Tilt
up-docker:
	@echo "Starting Ruby development environment with Docker Compose..."
	docker-compose up -d
	@echo ""
	@echo "✅ Environment started!"
	@echo "   Run 'make shell' to open a shell"
	@echo "   Run 'make repl' to start Ruby REPL"

# Stop all containers
down:
	@echo "Stopping development environment..."
	docker-compose down

# Restart containers
restart:
	@echo "Restarting development environment..."
	docker-compose restart

# View logs
logs:
	docker-compose logs -f

# Build or rebuild containers
build:
	@echo "Building containers..."
	docker-compose build

# Clean up containers and volumes
clean:
	@echo "Cleaning up containers and volumes..."
	docker-compose down -v
	@echo "✅ Cleanup complete!"

# Open bash shell in ruby-scripts container
shell:
	@echo "Opening bash shell in ruby-scripts container..."
	docker-compose exec ruby-scripts bash

# Start interactive Ruby REPL
repl:
	@echo "Starting Ruby REPL (IRB)..."
	@echo "Type 'exit' to quit the REPL"
	docker-compose exec ruby-scripts irb

# Run a specific Ruby script
# Usage: make run-script SCRIPT=scripts/hello.rb
run-script:
ifndef SCRIPT
	@echo "Error: Please specify a script to run"
	@echo "Usage: make run-script SCRIPT=scripts/hello.rb"
	@exit 1
endif
	@echo "Running $(SCRIPT)..."
	docker-compose exec ruby-scripts ruby $(SCRIPT)
