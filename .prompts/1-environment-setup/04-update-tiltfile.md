# Phase 1.4: Update Tiltfile

**Objective:** Integrate {LANGUAGE_DISPLAY} service into Tilt for improved local development workflow.

---

## 📋 Context

Tilt is an optional development tool that provides:
- Automatic container rebuilds on file changes
- Real-time log streaming
- Resource grouping and organization
- Quick links to documentation

While Docker Compose is sufficient, Tilt enhances the developer experience with live-reload capabilities.

---

## 🎯 Your Task

Add {LANGUAGE_DISPLAY} resources to `Tiltfile` for enhanced development workflow.

### Variables to Substitute

- `{LANGUAGE}` - Lowercase language name (e.g., `go`, `rust`, `javascript`)
- `{LANGUAGE_DISPLAY}` - Display name (e.g., `Go`, `Rust`, `JavaScript`)
- `{DOCS_URL}` - Official documentation URL
- `{API_URL}` - API reference/standard library URL
- `{PORT}` - Primary web service port (if applicable)

---

## 📝 Steps to Execute

### Step 1: Review Existing Tiltfile

Read the current `Tiltfile` to understand the pattern:

```bash
cat Tiltfile
```

Look for:
- `docker_compose()` configuration
- `watch_file()` patterns
- `dc_resource()` definitions
- `link()` documentation references

### Step 2: Add Watch Patterns

Add file watchers for {LANGUAGE} directory:

```python
# Watch {LANGUAGE_DISPLAY} files
watch_file('./{LANGUAGE}/')
```

Place this after existing `watch_file()` declarations.

### Step 3: Add Development Resource

Add resource configuration for the main language environment:

```python
# {LANGUAGE_DISPLAY} Development Environment
dc_resource('{LANGUAGE}-env',
    labels=['{LANGUAGE}-dev'],
    links=[
        link('{DOCS_URL}', '{LANGUAGE_DISPLAY} Documentation'),
        link('{API_URL}', '{LANGUAGE_DISPLAY} API Reference'),
        link('{COMMUNITY_URL}', '{LANGUAGE_DISPLAY} Community'),
    ]
)
```

### Step 4: Add Framework Resource (Optional)

If your language has a web framework service, add its resource:

```python
# {FRAMEWORK} Web Framework
dc_resource('{FRAMEWORK}-web',
    labels=['web'],
    resource_deps=['{LANGUAGE}-env'],
    links=[
        link('http://localhost:{PORT}', '{FRAMEWORK} App'),
        link('{FRAMEWORK_DOCS}', '{FRAMEWORK} Documentation'),
    ]
)
```

### Step 5: Add Resource Labels

Organize resources into logical groups using labels:

- **Development environments**: `{LANGUAGE}-dev`
- **Web services**: `web`
- **Databases**: `database`
- **Background services**: `services`

---

## ✅ Validation Checklist

After updating Tiltfile, verify:

- [ ] `watch_file('./{LANGUAGE}/')` added
- [ ] `dc_resource()` defined for `{LANGUAGE}-env`
- [ ] Labels assigned appropriately
- [ ] Documentation links included (minimum 2)
- [ ] Resource dependencies set correctly (if framework service exists)
- [ ] Python syntax is valid
- [ ] Indentation is consistent (4 spaces)

### Validation Commands

```bash
# Validate Tiltfile syntax
tilt config

# Or start Tilt to test (if available)
tilt up

# Check Tilt UI (if running)
# Open browser to http://localhost:10350
```

**Note:** Tilt is optional. If not installed, skip validation but ensure syntax is correct.

---

## 📝 Complete Example

Here's a complete example for **Go**:

```python
# Import Tilt Docker Compose support
docker_compose('./docker-compose.yml')

# Watch for changes in language directories
watch_file('./ruby/')
watch_file('./dart/')
watch_file('./python/')
watch_file('./go/')  # <-- New addition
watch_file('./scripts/')

# Ruby Development
dc_resource('ruby-env',
    labels=['ruby-dev'],
    links=[
        link('https://www.ruby-lang.org/en/documentation/', 'Ruby Documentation'),
        link('https://ruby-doc.org/', 'Ruby API Reference'),
    ]
)

dc_resource('sinatra-web',
    labels=['web'],
    links=[
        link('http://localhost:4567', 'Sinatra App'),
        link('https://sinatrarb.com/', 'Sinatra Documentation'),
    ]
)

# Dart Development
dc_resource('dart-env',
    labels=['dart-dev'],
    links=[
        link('https://dart.dev/guides', 'Dart Documentation'),
        link('https://api.dart.dev/', 'Dart API Reference'),
    ]
)

# Python Development
dc_resource('python-env',
    labels=['python-dev'],
    links=[
        link('https://docs.python.org/3/', 'Python Documentation'),
        link('https://docs.python.org/3/library/', 'Python Standard Library'),
    ]
)

# Go Development <-- New addition
dc_resource('go-env',
    labels=['go-dev'],
    links=[
        link('https://go.dev/doc/', 'Go Documentation'),
        link('https://pkg.go.dev/std', 'Go Standard Library'),
        link('https://go.dev/tour/', 'Go Tour'),
    ]
)

# Go Gin Framework <-- New addition (optional)
dc_resource('gin-web',
    labels=['web'],
    resource_deps=['go-env'],
    links=[
        link('http://localhost:8090', 'Gin App'),
        link('https://gin-gonic.com/docs/', 'Gin Documentation'),
    ]
)

# Database Resources
dc_resource('postgres',
    labels=['database'],
    links=[
        link('http://localhost:5432', 'PostgreSQL'),
    ]
)

dc_resource('redis',
    labels=['database'],
    links=[
        link('http://localhost:6379', 'Redis'),
    ]
)
```

---

## 📚 Language-Specific Links

### Go

```python
dc_resource('go-env',
    labels=['go-dev'],
    links=[
        link('https://go.dev/doc/', 'Go Documentation'),
        link('https://pkg.go.dev/std', 'Go Standard Library'),
        link('https://go.dev/tour/', 'A Tour of Go'),
        link('https://gobyexample.com/', 'Go by Example'),
    ]
)
```

### Rust

```python
dc_resource('rust-env',
    labels=['rust-dev'],
    links=[
        link('https://doc.rust-lang.org/', 'Rust Documentation'),
        link('https://doc.rust-lang.org/std/', 'Rust Standard Library'),
        link('https://doc.rust-lang.org/book/', 'The Rust Book'),
    ]
)
```

### JavaScript/Node

```python
dc_resource('node-env',
    labels=['node-dev'],
    links=[
        link('https://nodejs.org/docs/', 'Node.js Documentation'),
        link('https://developer.mozilla.org/en-US/docs/Web/JavaScript', 'MDN JavaScript'),
        link('https://nodejs.org/api/', 'Node.js API'),
    ]
)
```

### Java

```python
dc_resource('java-env',
    labels=['java-dev'],
    links=[
        link('https://docs.oracle.com/en/java/', 'Java Documentation'),
        link('https://docs.oracle.com/en/java/javase/17/docs/api/', 'Java API'),
    ]
)
```

### Kotlin

```python
dc_resource('kotlin-env',
    labels=['kotlin-dev'],
    links=[
        link('https://kotlinlang.org/docs/', 'Kotlin Documentation'),
        link('https://kotlinlang.org/api/latest/jvm/stdlib/', 'Kotlin Standard Library'),
    ]
)
```

---

## 🔧 Troubleshooting

### "SyntaxError: invalid syntax"

Check Python indentation—use 4 spaces consistently:

```python
dc_resource('go-env',  # 0 spaces
    labels=['go-dev'],  # 4 spaces
    links=[  # 4 spaces
        link('url', 'text'),  # 8 spaces
    ]  # 4 spaces
)  # 0 spaces
```

### "Resource '{LANGUAGE}-env' not found"

Ensure the service name matches exactly what's in `docker-compose.yml`:

```bash
grep "{LANGUAGE}-env:" docker-compose.yml
```

### Tilt not detecting changes

Verify `watch_file()` path is correct:

```bash
ls -la ./{LANGUAGE}/
```

---

## 📚 References

- Existing Tiltfile configuration
- Tilt documentation: https://docs.tilt.dev/
- Docker Compose integration: https://docs.tilt.dev/docker_compose.html

---

## 🎉 Phase 1 Complete!

You've successfully set up the development environment for {LANGUAGE_DISPLAY}:

✅ Created language folder structure
✅ Built Dockerfile with dependencies
✅ Added docker-compose service
✅ Integrated with Tilt

### Verify Everything Works

```bash
# Build and start environment
make build
make up-docker

# Verify service is running
docker compose ps | grep {LANGUAGE}

# Test shell access
make {LANGUAGE}-shell

# Inside container:
{LANGUAGE} --version
exit
```

---

## 🔜 Next Phase

Proceed to **Phase 2: Makefile Integration** to add convenient commands for working with {LANGUAGE_DISPLAY}:

- **[Phase 2.1: Add Core Commands](../2-makefile-integration/01-add-core-commands.md)**
