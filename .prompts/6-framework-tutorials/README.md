# Phase 6: Generate Framework Tutorials

**Objective:** Create framework-specific tutorials (8 tutorials + 4 labs) for {FRAMEWORK} web framework.

---

## 📋 Context

Framework tutorials teach web development using a popular {LANGUAGE} framework. They follow the Sinatra pattern from Ruby:

- **8 progressive tutorials**: Hello World → RESTful APIs
- **4 hands-on labs**: Todo App → Real-time Chat
- Each tutorial builds on previous concepts
- Labs are complete applications with STEPS.md guides

---

## 🎯 When to Create Framework Tutorials

Create framework tutorials if:
- Your language has a popular web framework (Go/Gin, Rust/Axum, Node/Express, Python/Flask)
- Framework is widely adopted in the community
- Framework has good documentation and learning resources

**Skip this phase if:**
- Language doesn't focus on web development
- No clear "winner" framework in ecosystem
- Time/resources limited (frameworks can be added later)

---

## 📝 Framework Selection Guide

### Popular Frameworks by Language

**Go:**
- Gin (lightweight, fast) - **Recommended**
- Echo (similar to Gin)
- Fiber (Express-like)
- Chi (composable)

**Rust:**
- Axum (modern, Tower-based) - **Recommended**
- Actix (fast, mature)
- Rocket (easy to learn)

**JavaScript/Node:**
- Express (ubiquitous) - **Recommended**
- Fastify (modern, fast)
- Koa (minimalist)

**Python:**
- Flask (lightweight) - **Recommended for tutorials**
- FastAPI (modern, async)
- Django (full-featured, but heavy for tutorials)

**Java:**
- Spring Boot - **Recommended**

**Kotlin:**
- Ktor - **Recommended**

---

## 📝 Master Prompt for Framework Tutorials

```
You are creating a complete web framework tutorial track for {FRAMEWORK} in the learning-with-claude repository.

**PREREQUISITES:**

1. **Study the Sinatra Pattern:**
   - Read all files in `ruby/tutorials/sinatra/`
   - Study the progression from hello world to real-time chat
   - Note the tutorial structure and lab organization

2. **Research {FRAMEWORK}:**
   - Read official documentation: {FRAMEWORK_DOCS_URL}
   - Review getting started guides
   - Study example applications
   - Understand framework philosophy

3. **Understand Prerequisites:**
   - Students have completed core {LANGUAGE} tutorials (1-10)
   - Basic understanding of HTTP and web concepts
   - Familiarity with Docker and containerization

**TUTORIAL CURRICULUM (8 Tutorials):**

**Tutorial 1: Hello {FRAMEWORK}**
- Topics: Installation, basic routing, "Hello World"
- Create: Minimal app, route handlers, response rendering
- Python/Flask equivalent: `@app.route('/')`
- Exercise: Multiple routes, URL parameters

**Tutorial 2: Routing and Parameters**
- Topics: Dynamic routes, query params, path params, HTTP methods
- Create: RESTful routes, parameter validation
- Python/Flask equivalent: `<int:id>` route parameters
- Exercise: Blog-style URL structure

**Tutorial 3: Templates and Views**
- Topics: Template engine, layouts, partials, helpers
- Create: HTML rendering, template inheritance, data passing
- Python/Flask equivalent: Jinja2 templates
- Exercise: Multi-page website with shared layout

**Tutorial 4: Request and Response**
- Topics: Request parsing, headers, cookies, sessions
- Create: Form handling, file uploads, JSON responses
- Python/Flask equivalent: `request.form`, `session`
- Exercise: Form processing with validation

**Tutorial 5: Database Integration**
- Topics: ORM setup, models, queries, migrations
- Create: PostgreSQL connection, CRUD operations
- Python/Flask equivalent: SQLAlchemy
- Exercise: User management system

**Tutorial 6: Sessions and Cookies**
- Topics: Session management, authentication, authorization
- Create: Login/logout, session storage, user tracking
- Python/Flask equivalent: Flask sessions
- Exercise: Protected routes, user authentication

**Tutorial 7: Middleware and Filters**
- Topics: Request/response middleware, logging, error handling
- Create: Custom middleware, request modification, global handlers
- Python/Flask equivalent: `@app.before_request`
- Exercise: Authentication middleware, request logging

**Tutorial 8: RESTful APIs**
- Topics: JSON APIs, REST principles, API versioning
- Create: CRUD API, error responses, status codes
- Python/Flask equivalent: Flask-RESTful
- Exercise: Complete REST API for resource

**LAB CURRICULUM (4 Labs):**

**Lab 1: Todo App**
- Topics: CRUD operations, templates, database
- Features: Create, read, update, delete tasks
- STEPS.md: 6-8 progressive build steps
- Time: 2-3 hours

**Lab 2: Blog API**
- Topics: RESTful API, authentication, pagination
- Features: Posts, comments, user auth, JSON responses
- STEPS.md: 7-9 progressive build steps
- Time: 3-4 hours

**Lab 3: Authentication App**
- Topics: User registration, login, sessions, password hashing
- Features: Signup, signin, protected routes, profile
- STEPS.md: 6-8 progressive build steps
- Time: 2-3 hours

**Lab 4: Real-time Chat**
- Topics: WebSockets, real-time updates, message broadcasting
- Features: Chat rooms, messages, online users
- STEPS.md: 8-10 progressive build steps
- Time: 4-5 hours

**STRUCTURE FOR EACH TUTORIAL:**

Create in `{LANGUAGE}/tutorials/{FRAMEWORK}/`:

1. **{N}-{topic}/README.md** - Tutorial guide following template
2. **{N}-{topic}/hello.{EXT}** - Simple example
3. **{N}-{topic}/{topic}_demo.{EXT}** - Comprehensive demo
4. **{N}-{topic}/{topic}_exercise.{EXT}** - Practice file with TODOs
5. **{N}-{topic}/api_exercise.{EXT}** - API-focused exercise (if applicable)

**STRUCTURE FOR EACH LAB:**

Create in `{LANGUAGE}/labs/{FRAMEWORK}/`:

1. **{N}-{project}/README.md** - Lab overview and instructions
2. **{N}-{project}/STEPS.md** - Progressive building guide
3. **{N}-{project}/app.{EXT}** - Main application
4. **{N}-{project}/lib/** - Models, helpers, services
5. **{N}-{project}/views/** - Templates (if applicable)
6. **{N}-{project}/public/** - Static assets
7. **{N}-{project}/config.ru** - Rack config (Ruby) or equivalent
8. **{N}-{project}/solution/** - Complete working solution
9. **{N}-{project}/steps/** - Incremental step directories

**DOCKER INTEGRATION:**

Ensure framework service in docker-compose.yml:
- Service name: `{FRAMEWORK}-web`
- Ports mapped correctly
- Dependencies on postgres/redis configured
- Environment variables set

Update Makefile commands (should be done in Phase 2):
- `{FRAMEWORK}-start`, `{FRAMEWORK}-stop`, `{FRAMEWORK}-logs`
- `{FRAMEWORK}-tutorial NUM=X`, `{FRAMEWORK}-lab NUM=X`

**VALIDATION FOR EACH TUTORIAL:**

- [ ] README follows tutorial template
- [ ] Multiple code examples (hello, demo, exercise)
- [ ] Python/Flask comparisons included
- [ ] Exercises have TODO markers
- [ ] All code tested and working
- [ ] Clear explanations of framework concepts
- [ ] Build on previous tutorial concepts

**VALIDATION FOR EACH LAB:**

- [ ] README with clear instructions
- [ ] STEPS.md with 6-10 progressive steps
- [ ] Complete solution implemented and tested
- [ ] Each step has checkpoint criteria
- [ ] Docker integration documented
- [ ] Database schema included (if applicable)
- [ ] README describes features and learning outcomes

**EXECUTION STRATEGY:**

1. Create framework directory structure
2. Generate Tutorial 1 (Hello World) - test thoroughly
3. Generate Tutorials 2-8 progressively
4. Create Lab 1 (Todo App) as foundation
5. Generate Labs 2-4 building on Lab 1 patterns
6. Test all labs run successfully
7. Update main README and labs README
8. Document port access and commands

Create a cohesive framework learning path that takes students from "Hello World" to production-ready applications.
```

---

## ✅ Validation Checklist

After completing framework tutorials:

- [ ] 8 tutorials created in `{LANGUAGE}/tutorials/{FRAMEWORK}/`
- [ ] 4 labs created in `{LANGUAGE}/labs/{FRAMEWORK}/`
- [ ] All tutorials follow established pattern
- [ ] All labs have STEPS.md guides
- [ ] Docker service configured and tested
- [ ] Makefile commands work correctly
- [ ] All code examples tested and working
- [ ] Framework README created with overview
- [ ] Labs README created with lab listing
- [ ] Port access documented

### Validation Commands

```bash
# Check tutorial structure
ls -la {LANGUAGE}/tutorials/{FRAMEWORK}/

# Check lab structure
ls -la {LANGUAGE}/labs/{FRAMEWORK}/

# Test tutorial commands
make {FRAMEWORK}-tutorial NUM=1
# Should start server on {PORT}

# Test lab commands
make {FRAMEWORK}-lab NUM=1
# Should start todo app

# Verify all tutorials run
for i in {1..8}; do
  echo "Testing tutorial $i..."
  make {FRAMEWORK}-tutorial NUM=$i
  sleep 2
  make {FRAMEWORK}-stop
done

# Check framework service
docker compose ps | grep {FRAMEWORK}
```

---

## 📚 References

**Study These Examples:**
- `ruby/tutorials/sinatra/` - Complete Sinatra tutorial track
- `ruby/labs/sinatra/` - Sinatra labs with STEPS.md
- `.templates/tutorial_template.md` - Tutorial structure
- `.templates/lab_template.md` - Lab structure

---

## 🔜 Next Phase

After completing framework tutorials, proceed to:
- **[Phase 7: Generate Labs](../7-labs/README.md)**
