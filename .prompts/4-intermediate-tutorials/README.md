# Phase 4-5: Generate Intermediate & Advanced Tutorials (11-23)

**Objective:** Create intermediate (11-16) and advanced (17-23) tutorials for {LANGUAGE_DISPLAY}.

---

## 📋 Context

After mastering fundamentals (Tutorials 1-10), learners progress to:

- **Intermediate (11-16)**: Advanced language features, best practices, real-world patterns
- **Advanced (17-23)**: Deep specialization, metaprogramming, performance, architecture

These tutorials assume comfort with basics and dive deeper into language-specific power features.

---

## 🎯 Hybrid Approach

**Option A:** Generate all intermediate/advanced tutorials in one session (fast, requires strong AI)

**Option B:** Use individual prompts for each tutorial topic (recommended for quality)

---

## 📝 Option A: Generate All Tutorials (Master Prompt)

### Master Prompt for Tutorials 11-23

```
You are creating the intermediate and advanced tutorial series (Tutorials 11-23) for {LANGUAGE_DISPLAY} in the learning-with-claude repository.

**PREREQUISITES:**

Before starting, confirm that Tutorials 1-10 (beginner series) are complete.

**RESEARCH REQUIREMENTS:**

1. **Study Language-Specific Advanced Features:**
   - Read official {LANGUAGE} documentation: {DOCS_URL}
   - Research best practices from community
   - Study language-specific design patterns
   - Review popular libraries/frameworks

2. **Python Comparison Research:**
   - For each topic, find Python equivalents (if they exist)
   - Note where {LANGUAGE} offers unique capabilities Python lacks
   - Research how Python developers solve same problems differently

3. **Pattern References:**
   - Study existing advanced tutorials:
     - `ruby/tutorials/14-Metaprogramming/README.md`
     - `ruby/tutorials/12-Ruby-Object-Model/README.md`
     - `dart/tutorials/11-Advanced-Generics-Type-System/README.md`

**TUTORIAL CURRICULUM:**

**Intermediate Tutorials (11-16):**

**Tutorial 11: {TOPIC}**
- Choose based on language strengths:
  - Advanced blocks/closures (Ruby)
  - Advanced generics (Dart, Java, Rust)
  - Advanced async patterns (JavaScript, Dart, Rust)
  - Interfaces and reflection (Go)

**Tutorial 12: {TOPIC}**
- Object model deep dive (Ruby)
- Type system advanced features (TypeScript, Dart)
- Memory management (Rust, C++)
- Concurrency patterns (Go)

**Tutorial 13: {TOPIC}**
- Advanced mixins/traits (Ruby, Rust, Scala)
- Extension methods (Dart, C#, Kotlin)
- Middleware patterns (Node.js, Go)

**Tutorial 14: {TOPIC}**
- Metaprogramming (Ruby, Python, Lisp)
- Code generation (Dart, Rust)
- Reflection (Java, Go, C#)
- Macros (Rust, Scala)

**Tutorial 15: {TOPIC}**
- Advanced error handling patterns
- Custom error types and hierarchies
- Error recovery strategies
- Result types (Rust, Scala)

**Tutorial 16: {TOPIC}**
- Idiomatic language patterns
- Style guide deep dive
- Community best practices
- Code review standards

**Advanced Tutorials (17-23):**

**Tutorial 17-23:**
- Choose 7 topics from:
  - Performance optimization & profiling
  - Concurrency & parallelism
  - Testing strategies (unit, integration, property-based)
  - Package creation & distribution
  - FFI / C interop
  - Security best practices
  - Design patterns specific to language
  - Functional programming patterns
  - Reactive programming
  - Build systems & tooling

**STRUCTURE FOR EACH TUTORIAL:**

1. **README.md following template:**
   - Advanced learning objectives (6-8 items)
   - Prerequisites (reference previous tutorials)
   - Deep technical sections (5-8 sections)
   - Real-world examples (not toy code)
   - Python comparisons where applicable
   - 4-6 challenging exercises

2. **Exercise file:**
   - Advanced practice scenarios
   - Mini-projects requiring integration of concepts
   - Open-ended challenges

3. **Additional files as needed:**
   - Multiple example files for complex topics
   - Sample libraries or modules
   - Benchmark scripts

**VALIDATION FOR EACH TUTORIAL:**

- [ ] README.md follows advanced tutorial patterns
- [ ] Learning objectives are sophisticated
- [ ] Code examples demonstrate real-world usage
- [ ] Exercises are challenging and open-ended
- [ ] Python comparisons included (where applicable)
- [ ] Cross-references to previous tutorials
- [ ] Performance considerations discussed (where relevant)
- [ ] Best practices emphasized throughout
- [ ] Security implications noted (where relevant)

**EXECUTION STRATEGY:**

1. Research the language ecosystem deeply
2. Identify 13 topics that represent true advanced mastery
3. Create tutorials 11-16 first (intermediate)
4. Then create tutorials 17-23 (advanced)
5. Ensure progressive difficulty
6. Update tutorials README with all additions

Create tutorials that challenge experienced developers and showcase {LANGUAGE}'s unique strengths.
```

---

## 📝 Option B: Topic-Specific Prompts

For more control, use these focused prompts:

### Intermediate Topics (Choose 6)

See sub-prompts for detailed guidance:

- [Advanced Functions/Closures](sub-prompts/intermediate-01-advanced-functions.md)
- [Type System Deep Dive](sub-prompts/intermediate-02-type-system.md)
- [Advanced Patterns](sub-prompts/intermediate-03-patterns.md)
- [Metaprogramming](sub-prompts/intermediate-04-metaprogramming.md)
- [Error Handling Patterns](sub-prompts/intermediate-05-error-patterns.md)
- [Idiomatic Code](sub-prompts/intermediate-06-idioms.md)

### Advanced Topics (Choose 7)

- [Performance Optimization](sub-prompts/advanced-01-performance.md)
- [Concurrency & Parallelism](sub-prompts/advanced-02-concurrency.md)
- [Testing Strategies](sub-prompts/advanced-03-testing.md)
- [Package Development](sub-prompts/advanced-04-packages.md)
- [Security Best Practices](sub-prompts/advanced-05-security.md)
- [Design Patterns](sub-prompts/advanced-06-patterns.md)
- [Build Systems](sub-prompts/advanced-07-build-systems.md)

---

## 📚 Recommended Topics by Language

### Go

**Intermediate:**
11. Advanced Interfaces
12. Context and Cancellation
13. Advanced Concurrency Patterns
14. Reflection and Code Generation
15. Advanced Error Handling
16. Go Idioms and Best Practices

**Advanced:**
17. Performance Profiling
18. Testing Strategies
19. Creating Go Modules
20. CGO and C Interop
21. Build Constraints and Tags
22. Security Best Practices
23. Microservices Patterns

### Rust

**Intermediate:**
11. Advanced Lifetimes
12. Trait Bounds and Associated Types
13. Smart Pointers
14. Macros
15. Error Handling Patterns
16. Idiomatic Rust

**Advanced:**
17. Unsafe Rust
18. Performance Optimization
19. Concurrency Patterns
20. FFI and C Interop
21. Procedural Macros
22. Embedded Rust
23. Cargo and Build Systems

### JavaScript/Node

**Intermediate:**
11. Advanced Promises and Async
12. Closures and Scope
13. Prototypal Inheritance
14. Symbols and Reflection
15. Error Handling Patterns
16. Modern JavaScript Idioms

**Advanced:**
17. Performance Optimization
18. Event Loop Deep Dive
19. Testing Strategies
20. NPM Package Development
21. Security Best Practices
22. Design Patterns
23. Build Tools and Bundlers

---

## ✅ Validation Checklist

After generating all intermediate/advanced tutorials:

- [ ] Tutorials 11-16 cover intermediate topics
- [ ] Tutorials 17-23 cover advanced topics
- [ ] All follow `.templates/tutorial_template.md` structure
- [ ] Real-world code examples (not toy code)
- [ ] Challenging exercises included
- [ ] Python comparisons where applicable
- [ ] Cross-references between related tutorials
- [ ] Performance considerations noted
- [ ] Security implications discussed
- [ ] Tutorials README updated with all new tutorials

### Validation Commands

```bash
# Check all tutorials exist
for i in {11..23}; do
  ls -la {LANGUAGE}/tutorials/$i-*/README.md
done

# Test code examples
find {LANGUAGE}/tutorials/ -name "*.{EXT}" -type f | while read f; do
  echo "Testing: $f"
  make run-{LANGUAGE} SCRIPT="$f"
done

# Verify README format
grep -l "📋 Learning Objectives" {LANGUAGE}/tutorials/*/README.md | wc -l
# Should show 23 (all tutorials)
```

---

## 🔜 Next Phase

After completing intermediate/advanced tutorials, proceed to:
- **[Phase 6: Framework Tutorials](../6-framework-tutorials/README.md)** (if applicable)
