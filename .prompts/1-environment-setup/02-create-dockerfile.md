# Phase 1.2: Create Dockerfile for Language Environment

**Objective:** Create a Docker container configuration for {LANGUAGE_DISPLAY} development with all necessary tools and dependencies.

---

## 📋 Context

This repository uses Docker for all language environments, ensuring:
- Consistent development environment across machines
- No local installation required
- Reproducible builds with cache optimization
- Isolated dependencies per language

---

## 🎯 Your Task

Create `Dockerfile.{LANGUAGE}` following established patterns from existing language Dockerfiles.

### Variables to Substitute

- `{LANGUAGE}` - Lowercase language name (e.g., `go`, `rust`, `javascript`)
- `{LANGUAGE_DISPLAY}` - Display name (e.g., `Go`, `Rust`, `JavaScript`)
- `{BASE_IMAGE}` - Official base image (e.g., `golang:1.21-slim`, `rust:1.75-slim`, `node:20-slim`)
- `{VERSION}` - Language version (e.g., `1.21`, `1.75`, `20`)
- `{PACKAGE_MANAGER}` - Package manager command (e.g., `go get`, `cargo install`, `npm install`)
- `{DEPENDENCY_FILE}` - Dependency manifest (e.g., `go.mod`, `Cargo.toml`, `package.json`)
- `{CACHE_PATH}` - Package cache location (e.g., `/go/pkg`, `~/.cargo`, `/root/.npm`)

---

## 📝 Steps to Execute

### Step 1: Research Base Image

Before creating the Dockerfile, research the official base image:

```bash
# Search Docker Hub for official images
# https://hub.docker.com/_/{LANGUAGE}

# Recommended base images:
# Go: golang:1.21-slim (or latest stable)
# Rust: rust:1.75-slim
# JavaScript/Node: node:20-slim
# Python: python:3.12-slim
# Java: openjdk:17-slim
# Kotlin: gradle:8-jdk17 or eclipse-temurin:17
```

**Selection Criteria:**
- Use `-slim` variants to reduce image size
- Choose latest stable LTS version
- Verify official image (maintained by language organization)

### Step 2: Identify Language-Specific Tools

Research essential development tools for {LANGUAGE_DISPLAY}:

```
Core Tools:
- Language compiler/interpreter
- Package manager
- REPL/interactive shell
- Debugger (if applicable)

Testing Tools:
- Unit testing framework
- Integration testing tools
- Code coverage tools

Quality Tools:
- Linter
- Formatter
- Static analyzer

Build Tools:
- Build system
- Task runner
```

### Step 3: Create Dockerfile

Create `Dockerfile.{LANGUAGE}` with this template:

```dockerfile
# {LANGUAGE_DISPLAY} Development Environment
FROM {BASE_IMAGE}

# Set working directory
WORKDIR /app

# Install essential build tools and utilities
# Use cache mount for faster builds
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    nano \
    less \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install language-specific tools (if not in base image)
# Example for additional tools:
# RUN curl -sSL {TOOL_INSTALL_URL} | sh
# RUN {PACKAGE_MANAGER} install {TOOL}

# Set environment variables
ENV {LANGUAGE_ENV_VAR}={VALUE}
ENV PATH="${PATH}:{CUSTOM_PATHS}"

# Copy dependency manifest first (for layer caching)
COPY {DEPENDENCY_FILE} ./

# Install dependencies with cache mount
RUN --mount=type=cache,target={CACHE_PATH},sharing=locked \
    {PACKAGE_MANAGER} install

# Create directory structure
RUN mkdir -p /app/{LANGUAGE}/tutorials \
             /app/{LANGUAGE}/labs \
             /app/{LANGUAGE}/reading \
             /app/scripts

# Copy application code
COPY . /app/

# Set default command (keep container running)
CMD ["tail", "-f", "/dev/null"]
```

### Step 4: Curated Starter Dependencies

Create or update the language's dependency file with essential packages.

#### For Go (`go.mod`):

```go
module github.com/learning-with-claude/{LANGUAGE}

go 1.21

require (
    // Testing
    github.com/stretchr/testify v1.8.4

    // Web Framework (optional)
    github.com/gin-gonic/gin v1.9.1

    // Database (optional)
    github.com/lib/pq v1.10.9
    gorm.io/gorm v1.25.5
)
```

#### For Rust (`Cargo.toml`):

```toml
[package]
name = "learning-{LANGUAGE}"
version = "0.1.0"
edition = "2021"

[dependencies]
# Core utilities
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"

# Async runtime
tokio = { version = "1", features = ["full"] }

# Web framework (optional)
axum = "0.7"

# Database (optional)
sqlx = { version = "0.7", features = ["postgres", "runtime-tokio-native-tls"] }

[dev-dependencies]
# Testing
criterion = "0.5"
```

#### For JavaScript/Node (`package.json`):

```json
{
  "name": "learning-{LANGUAGE}",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "test": "jest",
    "lint": "eslint .",
    "format": "prettier --write ."
  },
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.3"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "eslint": "^8.54.0",
    "prettier": "^3.1.0",
    "@types/node": "^20.10.0"
  }
}
```

#### For Python (`requirements.txt`):

```
# Core
requests==2.31.0

# Web Framework
flask==3.0.0
fastapi==0.104.1
uvicorn==0.24.0

# Database
sqlalchemy==2.0.23
psycopg2-binary==2.9.9

# Testing
pytest==7.4.3
pytest-cov==4.1.0

# Quality
black==23.11.0
flake8==6.1.0
mypy==1.7.1
```

**Dependency Categories to Include:**

1. **Core Language Tools**
   - Standard library (if separate)
   - Package manager
   - REPL/shell

2. **Testing Frameworks** (minimum 2)
   - Unit testing
   - Integration testing
   - Mocking library (if applicable)

3. **Quality Tools** (minimum 3)
   - Linter
   - Formatter
   - Static analyzer/type checker

4. **Web Framework** (1 popular option)
   - Lightweight framework for web labs

5. **Database Drivers** (2)
   - PostgreSQL driver
   - SQLite/in-memory option

6. **Common Utilities** (3-5)
   - JSON parsing
   - HTTP client
   - Date/time handling
   - Logging

### Step 5: Optimize Dockerfile

Add optimization patterns:

```dockerfile
# Multi-stage build (if applicable)
FROM {BASE_IMAGE} AS builder
WORKDIR /build
COPY {DEPENDENCY_FILE} .
RUN {PACKAGE_MANAGER} build --release

FROM {BASE_IMAGE}-slim AS runtime
COPY --from=builder /build/target/release /app
WORKDIR /app
CMD ["tail", "-f", "/dev/null"]
```

**Optimization Checklist:**
- [ ] Use cache mounts for package managers
- [ ] Copy dependency files before source code
- [ ] Layer commands logically (least → most frequent changes)
- [ ] Use `.dockerignore` to exclude unnecessary files
- [ ] Consider multi-stage builds for compiled languages

---

## ✅ Validation Checklist

After creating the Dockerfile, verify:

- [ ] `Dockerfile.{LANGUAGE}` exists in repository root
- [ ] Base image is official and uses `-slim` variant
- [ ] Essential build tools installed (git, curl, vim, etc.)
- [ ] Language-specific tools installed
- [ ] Dependency file ({DEPENDENCY_FILE}) copied before source
- [ ] Cache mounts used for package manager
- [ ] Directory structure created (`/app/{LANGUAGE}/...`)
- [ ] Container stays running (`CMD ["tail", "-f", "/dev/null"]`)
- [ ] Environment variables set appropriately

### Validation Commands

```bash
# Build the Docker image
docker build -f Dockerfile.{LANGUAGE} -t learning-{LANGUAGE}:test .

# Verify build succeeded
docker images | grep learning-{LANGUAGE}

# Test container runs
docker run --rm -it learning-{LANGUAGE}:test {LANGUAGE} --version

# Check installed tools
docker run --rm -it learning-{LANGUAGE}:test which {LANGUAGE}
docker run --rm -it learning-{LANGUAGE}:test {PACKAGE_MANAGER} --version

# Verify directory structure
docker run --rm learning-{LANGUAGE}:test ls -la /app/{LANGUAGE}
```

---

## 📝 Language-Specific Notes

### Go Specifics

```dockerfile
ENV GO111MODULE=on
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin
```

### Rust Specifics

```dockerfile
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH
```

### Node.js Specifics

```dockerfile
ENV NODE_ENV=development
ENV NPM_CONFIG_PREFIX=/usr/local
```

### Python Specifics

```dockerfile
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
```

### Java/Kotlin Specifics

```dockerfile
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$PATH:$GRADLE_HOME/bin
```

---

## 🔧 Troubleshooting

### Build fails with "network timeout"

Add retry logic or use mirrors:

```dockerfile
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    for i in 1 2 3; do apt-get update && break || sleep 5; done
```

### Packages not found

Check package manager syntax and availability:

```bash
# For Go
go get -u {PACKAGE}

# For Rust
cargo search {PACKAGE}

# For Node
npm search {PACKAGE}
```

### Cache not working

Ensure cache mounts use correct paths:

```dockerfile
# Go
RUN --mount=type=cache,target=/go/pkg

# Rust
RUN --mount=type=cache,target=/usr/local/cargo/registry

# Node
RUN --mount=type=cache,target=/root/.npm
```

---

## 📚 References

- Study existing Dockerfiles:
  - [Dockerfile.ruby](../../Dockerfile.ruby)
  - [Dockerfile.dart](../../Dockerfile.dart)
  - [Dockerfile.python](../../Dockerfile.python)
- Docker best practices: https://docs.docker.com/develop/dev-best-practices/
- Docker cache mounts: https://docs.docker.com/build/cache/

---

## 🔜 Next Steps

After completing this prompt, proceed to:
- **[Phase 1.3: Update docker-compose.yml](03-update-docker-compose.md)**
