# Phase 7: Generate Labs

**Objective:** Create hands-on lab projects for all difficulty levels (beginner, intermediate, advanced).

---

## 📋 Context

Labs are practical projects that reinforce tutorial concepts:

- **Beginner Labs (3)**: Small, focused projects (30-60 min each)
- **Intermediate Lab (1)**: Complex multi-feature application (3-5 hours)
- **Advanced Labs (4)**: Specialized, production-quality projects (2-4 hours each)

Each lab includes complete solutions, progressive steps (for intermediate/advanced), and clear learning objectives.

---

## 🎯 Lab Philosophy

**Good Labs:**
- Apply concepts from multiple tutorials
- Solve real-world problems
- Build confidence through completion
- Include challenges for extension
- Have clear success criteria

**Avoid:**
- Toy/trivial problems
- Overly complex solutions
- Vague instructions
- Missing validation criteria

---

## 📝 Master Prompt for All Labs

```
You are creating the complete lab series for {LANGUAGE_DISPLAY} in the learning-with-claude repository.

**PREREQUISITES:**

1. **Study Existing Labs:**
   - Read `ruby/labs/beginner/` - Note starter/solution pattern
   - Read `ruby/labs/intermediate-lab/` - Note STEPS.md usage
   - Read `ruby/labs/advanced/` - Note specialized topics
   - Study `.templates/lab_template.md`

2. **Understand Lab Structure:**
   - Beginner: starter code + solution
   - Intermediate: STEPS.md with 6-9 progressive steps
   - Advanced: solution/ with demo scripts, may include starter/

3. **Prerequisites Met:**
   - Core tutorials (1-10) completed
   - Students understand Docker workflow
   - Makefile commands created in Phase 2

**LAB CURRICULUM:**

---

## **BEGINNER LABS (3 Labs)**

### **Lab 1: Basics**
**Time:** 30-45 minutes
**Topics:** Variables, functions, basic I/O, conditionals
**Project:** Create a simple calculator or number guessing game

**Features:**
- User input handling
- Basic arithmetic operations
- Control flow (if/else, loops)
- Function decomposition
- Input validation

**Files:**
- `README.md` - Instructions and objectives
- `starter.{EXT}` - Template with TODO markers
- `solution.{EXT}` - Complete working solution

**Python Equivalent:** Basic Python script with input/functions

---

### **Lab 2: Collections**
**Time:** 45-60 minutes
**Topics:** Arrays/Lists, Maps/Hashes, iteration, data manipulation
**Project:** Contact book, inventory system, or data analyzer

**Features:**
- Collection operations (add, remove, search)
- Iteration and filtering
- Data transformation
- File I/O (save/load data)
- Menu-driven interface

**Files:**
- `README.md` - Instructions
- `starter.{EXT}` - Template with data structure outlines
- `solution.{EXT}` - Complete implementation
- `sample_data.txt` - Test data

**Python Equivalent:** Dict/list manipulation, JSON files

---

### **Lab 3: {TOPIC}**
**Time:** 45-60 minutes
**Topics:** Choose based on language strengths:
- OOP: Class hierarchy (Animal, Vehicle, Shape inheritance)
- Functions: Higher-order functions, closures
- Error Handling: Robust error handling patterns

**Project Ideas:**
- OOP: Library system (Books, Members, Loans)
- Functions: Data pipeline with transformations
- Error Handling: API client with retry logic

**Files:**
- `README.md`
- `starter.{EXT}`
- `solution.{EXT}`
- Supporting files as needed

---

## **INTERMEDIATE LAB (1 Project)**

### **Blog Management System / Task Manager / Library System**
**Time:** 3-5 hours
**Topics:** OOP, file I/O, data persistence, CLI interface, error handling

**Features:**
1. Multiple entity types (Posts/Tasks/Books, Users, Categories)
2. CRUD operations for all entities
3. Data persistence (file or database)
4. Search and filtering
5. User authentication (optional)
6. Data validation
7. Error handling
8. Menu-driven CLI

**Structure:**
```
intermediate-lab/
├── README.md           # Overview and quick start
├── STEPS.md           # 6-9 progressive build steps
├── main.{EXT}         # Complete solution
├── lib/               # Source code
│   ├── models/        # Data models
│   ├── services/      # Business logic
│   ├── storage/       # Persistence layer
│   └── cli/           # CLI interface
├── data/              # Sample data
└── spec/ or tests/    # Tests (if applicable)
```

**STEPS.md Guide (6-9 steps):**
1. Project setup and data models
2. Basic CRUD operations
3. Data persistence (file I/O)
4. Search and filtering
5. CLI interface
6. Error handling and validation
7. Additional features (categories, tags)
8. Polish and refactoring
9. Final testing and documentation

**Python Equivalent:** Flask mini-app or CLI with SQLite

---

## **ADVANCED LABS (4 Labs)**

### **Lab 1: DSL Builder**
**Time:** 2-3 hours
**Topics:** Metaprogramming, DSLs, code generation, reflection

**Project:** Create a domain-specific language for:
- HTML generation
- Query builder
- Configuration DSL
- Test framework DSL

**Example (Ruby-style):**
```ruby
# HTML DSL
html do
  head do
    title "My Page"
  end
  body do
    div class: "container" do
      h1 "Welcome"
      p "Hello, world!"
    end
  end
end
```

**Files:**
- `solution/README.md` - DSL documentation
- `solution/demo.{EXT}` - Demonstration script
- `solution/lib/dsl.{EXT}` - DSL implementation
- `solution/examples/` - Usage examples

**Python Equivalent:** Context managers, decorators for DSL

---

### **Lab 2: Concurrent Processor**
**Time:** 2-4 hours
**Topics:** Concurrency, parallelism, thread safety, synchronization

**Project:** Parallel data processor:
- File processing pipeline
- Web scraper with concurrent requests
- Data transformation with worker pool
- Message queue system

**Features:**
- Thread/goroutine/async workers
- Task queue management
- Progress tracking
- Error handling in concurrent context
- Resource pooling
- Graceful shutdown

**Files:**
- `solution/README.md`
- `solution/demo.{EXT}` - Benchmarks and examples
- `solution/lib/processor.{EXT}` - Core implementation
- `sample_data/` - Test datasets

**Python Equivalent:** asyncio or multiprocessing

---

### **Lab 3: Performance Optimizer**
**Time:** 2-3 hours
**Topics:** Profiling, benchmarking, optimization, algorithms

**Project:** Optimize a slow application:
- Identify bottlenecks with profiling
- Apply optimization techniques
- Benchmark improvements
- Memory optimization

**Optimization Techniques:**
- Algorithm improvements (O(n²) → O(n log n))
- Caching and memoization
- Lazy evaluation
- Data structure selection
- Memory pooling

**Files:**
- `solution/README.md` - Optimization report
- `solution/slow_version.{EXT}` - Unoptimized code
- `solution/optimized_version.{EXT}` - Optimized code
- `solution/benchmark.{EXT}` - Performance comparison
- `solution/profiling_guide.md` - How to profile

**Python Equivalent:** cProfile, memory_profiler

---

### **Lab 4: Mini Framework**
**Time:** 3-4 hours
**Topics:** Architecture, design patterns, API design, plugin systems

**Project:** Build a mini framework:
- Web framework (routing, middleware)
- Testing framework (assertions, runners)
- ORM (query builder, migrations)
- CLI framework (commands, options)

**Features:**
- Plugin architecture
- Extensibility points
- Clean API design
- Documentation
- Example usage

**Files:**
- `solution/README.md` - Framework documentation
- `solution/demo.{EXT}` - Usage examples
- `solution/lib/framework/` - Framework code
- `solution/examples/` - Sample applications
- `solution/tests/` - Framework tests

**Python Equivalent:** Flask-like mini-framework

---

**VALIDATION FOR EACH LAB:**

**Beginner Labs:**
- [ ] Clear, achievable objectives
- [ ] Starter code with helpful TODOs
- [ ] Complete solution tested
- [ ] README with step-by-step guidance
- [ ] Estimated time provided
- [ ] Python comparisons noted

**Intermediate Lab:**
- [ ] STEPS.md with 6-9 progressive steps
- [ ] Each step has checkpoint criteria
- [ ] Complete solution in proper structure (lib/, models/, etc.)
- [ ] README explains full feature set
- [ ] Tested and working
- [ ] Optional challenges provided

**Advanced Labs:**
- [ ] Specialized, production-quality code
- [ ] README with technical documentation
- [ ] Demo script showing key features
- [ ] Clean architecture and patterns
- [ ] Performance considerations noted
- [ ] Extension ideas provided

**EXECUTION STRATEGY:**

1. **Beginner Labs:**
   - Start with Lab 1 (simplest)
   - Create starter with clear TODOs
   - Implement solution fully
   - Test with `make {LANGUAGE}-beginner-lab NUM=1`
   - Repeat for Labs 2-3

2. **Intermediate Lab:**
   - Design the full project architecture
   - Implement complete solution first
   - Break into 6-9 logical steps
   - Write STEPS.md with checkpoints
   - Test each step builds correctly

3. **Advanced Labs:**
   - Choose topics showcasing {LANGUAGE} strengths
   - Implement sophisticated, well-architected solutions
   - Create demo scripts that highlight features
   - Document technical decisions
   - Provide extension challenges

4. **Final Steps:**
   - Update `{LANGUAGE}/labs/README.md` with all labs
   - Test all Makefile commands
   - Verify Docker integration
   - Add cross-references to related tutorials

Create labs that inspire learners and demonstrate real-world {LANGUAGE} capabilities.
```

---

## ✅ Validation Checklist

After creating all labs:

- [ ] 3 beginner labs in `{LANGUAGE}/labs/beginner/`
- [ ] 1 intermediate lab in `{LANGUAGE}/labs/intermediate-lab/`
- [ ] 4 advanced labs in `{LANGUAGE}/labs/advanced/`
- [ ] All beginner labs have starter + solution
- [ ] Intermediate lab has STEPS.md with 6-9 steps
- [ ] All advanced labs have solution/ with demo scripts
- [ ] Labs README updated with all labs
- [ ] Makefile commands tested for all labs
- [ ] All lab code tested and working

### Validation Commands

```bash
# Test beginner labs
make {LANGUAGE}-beginner-lab NUM=1
make {LANGUAGE}-beginner-lab NUM=2
make {LANGUAGE}-beginner-lab NUM=3

# Test intermediate lab
make {LANGUAGE}-intermediate-lab

# Test advanced labs
for i in {1..4}; do
  make {LANGUAGE}-advanced-lab NUM=$i
done

# Verify structure
tree {LANGUAGE}/labs/ -L 3

# Check README files
find {LANGUAGE}/labs/ -name "README.md" | wc -l
# Should be 9 (3 beginner + 1 intermediate + 4 advanced + 1 main)
```

---

## 🎉 All Phases Complete!

You've successfully created a complete learning module for {LANGUAGE_DISPLAY}:

✅ **Phase 1:** Environment setup (Docker, docker-compose, Tilt)
✅ **Phase 2:** Makefile integration (commands for all features)
✅ **Phase 3:** Beginner tutorials (1-10)
✅ **Phase 4-5:** Intermediate/advanced tutorials (11-23)
✅ **Phase 6:** Framework tutorials (8 tutorials + 4 labs) [if applicable]
✅ **Phase 7:** Labs (3 beginner + 1 intermediate + 4 advanced)

---

## 📚 Final Steps

1. Update main repository README with {LANGUAGE} section
2. Add {LANGUAGE} to learning paths documentation
3. Test complete workflow end-to-end
4. Create showcase example for repository front page
5. Document any language-specific quirks or tips

**Celebrate!** You've built a comprehensive, world-class learning resource for {LANGUAGE_DISPLAY}! 🚀
