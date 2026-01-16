# Phase 1.3: Update docker-compose.yml

**Objective:** Add {LANGUAGE_DISPLAY} service to docker-compose.yml for container orchestration.

---

## 📋 Context

The repository uses Docker Compose to manage multiple language containers, databases, and services. Each language gets its own service with:
- Dedicated container
- Volume mounts for live code editing
- Network connectivity for inter-service communication
- Resource limits for performance

---

## 🎯 Your Task

Add a service configuration for {LANGUAGE_DISPLAY} to the existing `docker-compose.yml`.

### Variables to Substitute

- `{LANGUAGE}` - Lowercase language name (e.g., `go`, `rust`, `javascript`)
- `{LANGUAGE_DISPLAY}` - Display name (e.g., `Go`, `Rust`, `JavaScript`)
- `{PORT_1}`, `{PORT_2}`, `{PORT_3}` - Unique port numbers for web services (avoid conflicts)

---

## 📝 Steps to Execute

### Step 1: Review Existing Services

Read the current `docker-compose.yml` to understand:
- Service naming conventions (`{LANGUAGE}-env`)
- Network configuration
- Volume mount patterns
- Resource limits

```bash
# Review existing docker-compose.yml
cat docker-compose.yml | grep -A 20 "ruby-env:"
cat docker-compose.yml | grep -A 20 "dart-env:"
```

### Step 2: Choose Unique Ports

Identify available ports for your language's web services:

**Currently Used Ports:**
- Ruby/Sinatra: 4567, 9292, 3000
- Dart/Flutter: 8080, 8081, 8082
- PostgreSQL: 5432
- Redis: 6379

**Available Port Ranges:**
- 3001-3999 (avoid 3000)
- 5000-5432 (avoid 5432)
- 8083-8999 (avoid 8080-8082)
- 9000-9291 (avoid 9292)

**Recommended Ports by Language:**
- Go: 8090, 8091, 8092
- Rust: 8100, 8101, 8102
- JavaScript/Node: 3001, 3002, 3003
- Python (Flask): 5000, 5001, 5002
- Java/Kotlin: 8180, 8181, 8182

### Step 3: Add Language Service

Add this service configuration to `docker-compose.yml`:

```yaml
  # ============================================================================
  # {LANGUAGE_DISPLAY} Development Environment
  # ============================================================================

  {LANGUAGE}-env:
    build:
      context: .
      dockerfile: Dockerfile.{LANGUAGE}
    container_name: {LANGUAGE}-env
    volumes:
      - .:/app
      - {LANGUAGE}-deps:/path/to/dependencies  # Persist dependencies
    working_dir: /app
    command: tail -f /dev/null
    stdin_open: true
    tty: true
    networks:
      - learning-network
    environment:
      # Language-specific environment variables
      - {LANGUAGE_ENV_VAR}={VALUE}
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 2G
    cap_add:
      - SYS_PTRACE  # For debugging/profiling
```

### Step 4: Add Volume Definition

Add a named volume for dependency persistence:

```yaml
volumes:
  ruby-bundle:
  dart-pub-cache:
  python-venv:
  # Add your language's volume
  {LANGUAGE}-deps:
```

**Volume Path Mapping by Language:**

- **Go**: `{LANGUAGE}-deps:/go/pkg`
- **Rust**: `{LANGUAGE}-cargo:/usr/local/cargo/registry`
- **Node.js**: `{LANGUAGE}-node-modules:/app/node_modules`
- **Python**: `{LANGUAGE}-venv:/app/.venv`
- **Java**: `{LANGUAGE}-gradle:/root/.gradle`
- **Kotlin**: `{LANGUAGE}-gradle:/root/.gradle`

### Step 5: Add Network (if needed)

Ensure the shared network exists:

```yaml
networks:
  learning-network:
    driver: bridge
```

(This likely already exists; verify don't duplicate)

### Step 6: Add Framework Service (Optional)

If your language has a web framework, add a dedicated service:

```yaml
  {FRAMEWORK}-web:
    build:
      context: .
      dockerfile: Dockerfile.{LANGUAGE}
    container_name: {FRAMEWORK}-web
    volumes:
      - .:/app
    working_dir: /app/{LANGUAGE}/tutorials/{FRAMEWORK}
    command: {COMMAND_TO_START_SERVER}
    ports:
      - "{PORT_1}:{PORT_1}"
      - "{PORT_2}:{PORT_2}"
      - "{PORT_3}:{PORT_3}"
    networks:
      - learning-network
    depends_on:
      - {LANGUAGE}-env
      - postgres
      - redis
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/learning_db
      - REDIS_URL=redis://redis:6379
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 1G
```

**Framework Commands by Language:**

- **Go (Gin)**: `go run main.go`
- **Rust (Axum)**: `cargo run --release`
- **Node (Express)**: `npm start` or `node server.js`
- **Python (Flask)**: `flask run --host=0.0.0.0 --port=5000`
- **Java (Spring Boot)**: `./gradlew bootRun`

---

## ✅ Validation Checklist

After updating docker-compose.yml, verify:

- [ ] Service name follows pattern: `{LANGUAGE}-env`
- [ ] Container name matches service name
- [ ] Dockerfile path is correct: `Dockerfile.{LANGUAGE}`
- [ ] Volume mounts include `.:/app` for live editing
- [ ] Named volume created for dependencies
- [ ] Working directory is `/app`
- [ ] Command keeps container running (`tail -f /dev/null`)
- [ ] `stdin_open: true` and `tty: true` set for interactive shell
- [ ] Connected to `learning-network`
- [ ] Resource limits set (4 CPUs, 2GB RAM)
- [ ] SYS_PTRACE capability added for debugging
- [ ] Ports don't conflict with existing services
- [ ] YAML syntax is valid (proper indentation)

### Validation Commands

```bash
# Validate YAML syntax
docker compose config

# Check for syntax errors (should show parsed config)
docker compose config | grep "{LANGUAGE}-env" -A 20

# Build and start the service
docker compose build {LANGUAGE}-env
docker compose up -d {LANGUAGE}-env

# Verify service is running
docker compose ps | grep {LANGUAGE}

# Test shell access
docker compose exec {LANGUAGE}-env bash
# Inside container:
{LANGUAGE} --version
exit

# Check logs
docker compose logs {LANGUAGE}-env

# Stop service
docker compose down
```

---

## 📝 Complete Example

Here's a complete example for **Go**:

```yaml
  # ============================================================================
  # Go Development Environment
  # ============================================================================

  go-env:
    build:
      context: .
      dockerfile: Dockerfile.go
    container_name: go-env
    volumes:
      - .:/app
      - go-pkg:/go/pkg
      - go-build-cache:/root/.cache/go-build
    working_dir: /app
    command: tail -f /dev/null
    stdin_open: true
    tty: true
    networks:
      - learning-network
    environment:
      - GO111MODULE=on
      - GOPROXY=https://proxy.golang.org,direct
      - CGO_ENABLED=1
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 2G
    cap_add:
      - SYS_PTRACE

  # Optional: Gin web framework service
  gin-web:
    build:
      context: .
      dockerfile: Dockerfile.go
    container_name: gin-web
    volumes:
      - .:/app
    working_dir: /app/go/tutorials/gin
    command: go run main.go
    ports:
      - "8090:8090"
      - "8091:8091"
      - "8092:8092"
    networks:
      - learning-network
    depends_on:
      - go-env
      - postgres
      - redis
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/learning_db
      - REDIS_URL=redis://redis:6379
      - GIN_MODE=debug
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 1G

volumes:
  ruby-bundle:
  dart-pub-cache:
  python-venv:
  go-pkg:
  go-build-cache:
  postgres-data:
  redis-data:

networks:
  learning-network:
    driver: bridge
```

---

## 🔧 Troubleshooting

### "Service '{LANGUAGE}-env' refers to undefined volume"

Ensure volume is defined in `volumes:` section at bottom of file.

### "Port {PORT} is already allocated"

Choose different ports—check `docker ps` for in-use ports.

### "network learning-network declared as external, but not found"

Remove `external: true` from network definition or create network:

```bash
docker network create learning-network
```

### "YAML indentation error"

Use 2 spaces for indentation (not tabs). Validate:

```bash
docker compose config
```

---

## 📚 References

- Existing docker-compose.yml structure
- Docker Compose documentation: https://docs.docker.com/compose/
- Volume mounts: https://docs.docker.com/storage/volumes/
- Resource limits: https://docs.docker.com/compose/compose-file/#resources

---

## 🔜 Next Steps

After completing this prompt, proceed to:
- **[Phase 1.4: Update Tiltfile](04-update-tiltfile.md)**
