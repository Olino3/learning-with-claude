# Tutorial 7: Null Safety - Dart's Killer Feature!

Welcome to Dart's null safety tutorial! This is one of Dart's most powerful features that prevents null reference errors at compile time - something Python can't do!

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand nullable vs non-nullable types
- Master null-aware operators (??,'??, ?., !)
- Use late variables effectively
- Apply the required keyword
- Understand flow analysis
- Write null-safe code

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Nullable variable | Any variable can be None | `String?` (explicit) |
| Non-nullable | No concept | `String` (default) |
| Default value | `x = value or default` | `x ?? default` |
| Safe navigation | N/A (or use walrus) | `x?.method()` |
| Force unwrap | Just use it (runtime error) | `x!` (assertion) |
| Null check | `if x is not None:` | `if (x != null) {` |
| Late initialization | Just assign later | `late` keyword |

## 📝 Why Null Safety Matters

```dart
// Without null safety (old Dart/Python style)
String name;
print(name.length);  // Runtime error! name is null!

// With null safety (modern Dart)
String name;  // Error at compile time! Must initialize
String? maybeName;  // OK, explicitly nullable
// print(maybeName.length);  // Compile error! Might be null

// Must check first
if (maybeName != null) {
  print(maybeName.length);  // OK, compiler knows it's not null
}
```

> **📘 Python Note:** This is HUGE! Python has no null safety. You find out about None errors at runtime. Dart catches them at compile time!

## 📝 Nullable vs Non-Nullable Types

### Non-Nullable by Default

```dart
// Non-nullable - must have a value
String name = "Alice";        // OK
int age = 30;                 // OK
bool isActive = true;         // OK

// String uninitialized;      // Error! Must initialize
// int? notInitialized;       // OK if nullable

// Can't assign null
// name = null;               // Error!
// age = null;                // Error!
```

### Nullable Types

```dart
// Add ? to make nullable
String? name;                 // OK, null by default
int? age;                     // OK, null by default
bool? isActive;               // OK, null by default

// Can assign null
name = null;                  // OK
age = null;                   // OK

// Can assign value
name = "Alice";               // OK
age = 30;                     // OK

// Must check before using
// print(name.length);        // Error! Might be null

if (name != null) {
  print(name.length);         // OK, checked
}
```

> **📘 Python Note:** In Python, any variable can be None. In Dart, you must explicitly mark types as nullable with `?`. This prevents accidental null errors!

## 📝 Null-Aware Operators

### ?? (Null Coalescing Operator)

```dart
// Return default if null
String? name;
var display = name ?? "Guest";
print(display);  // "Guest"

name = "Alice";
display = name ?? "Guest";
print(display);  // "Alice"

// Chain multiple
String? firstName;
String? lastName;
String? nickname;

var displayName = firstName ?? lastName ?? nickname ?? "Anonymous";
print(displayName);  // "Anonymous"

// In expressions
int? count;
var total = (count ?? 0) + 10;
print(total);  // 10
```

> **📘 Python Note:** Similar to `x or default` but safer! Python's `or` has issues with falsy values (0, "", []). Dart's `??` only checks null.

### ??= (Null-Aware Assignment)

```dart
// Assign only if null
String? name;
name ??= "Default";
print(name);  // "Default"

name ??= "Another";  // Won't assign, name is not null
print(name);  // Still "Default"

// Useful for lazy initialization
List<String>? items;
items ??= [];  // Initialize if null
items.add("first");

items ??= [];  // Won't reinitialize
items.add("second");
print(items);  // [first, second]
```

### ?. (Null-Aware Access)

```dart
// Safe navigation - returns null if receiver is null
String? name;
var length = name?.length;
print(length);  // null

name = "Alice";
length = name?.length;
print(length);  // 5

// Chain safely
String? text;
var upper = text?.toUpperCase()?.substring(0, 3);
print(upper);  // null (doesn't throw error!)

text = "hello";
upper = text?.toUpperCase()?.substring(0, 3);
print(upper);  // "HEL"

// With methods
List<String>? items;
items?.add("test");  // Does nothing, items is null
print(items);  // null

items = [];
items?.add("test");  // Adds to list
print(items);  // [test]
```

> **📘 Python Note:** Python doesn't have this! You'd need to check `if x is not None` before each access. Dart's `?.` is much cleaner.

### ! (Null Assertion Operator)

```dart
// Assert that value is not null
String? name = "Alice";

// I know it's not null, trust me!
var length = name!.length;  // OK, asserts non-null
print(length);  // 5

// But be careful!
String? nullName;
// var len = nullName!.length;  // Runtime error! null assertion failed

// Use when you're certain
String? getValue() => "value";

var result = getValue()!.toUpperCase();  // OK if you're sure
```

> **📘 Python Note:** Similar to just using the variable in Python, but explicit. Use sparingly - defeats the purpose of null safety!

## 📝 Flow Analysis

Dart's compiler is smart and tracks null checks:

```dart
// Smart flow analysis
String? name;

// After null check, compiler knows it's not null
if (name != null) {
  print(name.length);  // OK! No ? or ! needed
  print(name.toUpperCase());  // OK!
}

// Early return pattern
if (name == null) {
  return;
}
print(name.length);  // OK! Compiler knows it's not null here

// After assignment
name = "Alice";
print(name.length);  // OK! Definitely not null

// With local variables
void processName(String? input) {
  if (input == null || input.isEmpty) {
    print("No name provided");
    return;
  }

  // Compiler knows input is not null and not empty here
  print("Processing: ${input.toUpperCase()}");
  print("Length: ${input.length}");
}
```

> **📘 Python Note:** Python type checkers try to do this, but it's not built into the language. Dart's flow analysis is part of the compiler!

## 📝 Late Variables

For variables that will be initialized later:

```dart
// late - promise to initialize before use
late String name;

void initialize() {
  name = "Alice";
}

void printName() {
  print(name);  // OK if initialized
}

initialize();
printName();  // "Alice"

// late with initialization
late String heavyComputation = performExpensiveOperation();

String performExpensiveOperation() {
  print("Computing...");
  return "Result";
}

// Only computed when first accessed (lazy)
print("Before access");
print(heavyComputation);  // "Computing..." then "Result"
print(heavyComputation);  // "Result" (cached, not recomputed)
```

> **📘 Python Note:** Python doesn't need this - variables can be uninitialized. But Dart's `late` provides compile-time guarantees!

### Late Final

```dart
// Combine late with final
class Config {
  late final String apiKey;

  void initialize(String key) {
    apiKey = key;  // Can only set once
  }
}

var config = Config();
config.initialize("secret123");
// config.initialize("another");  // Error! Already set
```

## 📝 Required Named Parameters

```dart
// Without required
void createUser({String? name, int? age}) {
  // Must check for null
  if (name == null || age == null) {
    throw ArgumentError("name and age required");
  }
  print("User: $name, $age");
}

// With required - much better!
void createUserBetter({required String name, required int age}) {
  // No null checks needed! Compiler enforces
  print("User: $name, $age");
}

// Must provide all required parameters
createUserBetter(name: "Alice", age: 30);
// createUserBetter(name: "Bob");  // Error! age is required
```

> **📘 Python Note:** Python 3.8+ has similar with `/` and `*`, but Dart's `required` is clearer and enforced at compile time.

## 📝 Practical Patterns

### Safe List Access

```dart
// Python: list[0] if list else None
// Dart:
T? firstOrNull<T>(List<T> list) {
  return list.isEmpty ? null : list.first;
}

var numbers = [1, 2, 3];
print(firstOrNull(numbers));  // 1

var empty = <int>[];
print(firstOrNull(empty));    // null
```

### Safe Map Access

```dart
Map<String, int> scores = {"Alice": 95, "Bob": 87};

// With default
var aliceScore = scores["Alice"] ?? 0;     // 95
var charlieScore = scores["Charlie"] ?? 0; // 0

// Safe chain
Map<String, Map<String, int>>? nested = {
  "team1": {"Alice": 95, "Bob": 87}
};

var score = nested?["team1"]?["Alice"];
print(score);  // 95
```

### Validation Pattern

```dart
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Email is required";
  }
  if (!email.contains("@")) {
    return "Invalid email format";
  }
  return null;  // null means valid
}

// Usage
var error = validateEmail("test@example.com");
if (error != null) {
  print("Error: $error");
} else {
  print("Valid!");
}
```

## ✍️ Exercises

### Exercise 1: Nullable Types

👉 **[Start Exercise 1: Nullable Types](exercises/1-nullable-types.md)**

### Exercise 2: Null Operators

👉 **[Start Exercise 2: Null Operators](exercises/2-null-operators.md)**

### Exercise 3: Null Safety Challenges

👉 **[Start Exercise 3: Null Safety Challenges](exercises/3-null-safety-challenges.md)**

## 📚 What You Learned

✅ Nullable vs non-nullable types
✅ Null-aware operators (??,'??, ?., !)
✅ Flow analysis
✅ Late variables
✅ Required parameters
✅ Null-safe patterns

## 🔜 Next Steps

**Next tutorial: 8-Error-Handling**

## 💡 Key Takeaways for Python Developers

1. **Null Safety**: Dart catches null errors at compile time - HUGE advantage over Python!
2. **Explicit Nullable**: Must use `?` to allow null - safer than Python's implicit None
3. **Null Operators**: `??`, `??=`, `?.` make null handling elegant
4. **Flow Analysis**: Compiler tracks null checks automatically
5. **Required Keyword**: Better than Python's keyword-only args
6. **Late**: Safe delayed initialization with guarantees

## 🆘 Common Pitfalls

### Pitfall 1: Overusing !

```dart
// ❌ Wrong - defeats null safety
var value = nullable!.method();

// ✅ Better - handle null properly
var value = nullable?.method() ?? defaultValue;
```

### Pitfall 2: Forgetting ?

```dart
// ❌ Wrong - can't be null
String name;  // Must initialize!

// ✅ Correct
String? name;  // Can be null
```

### Pitfall 3: Not Using Flow Analysis

```dart
// ❌ Redundant
if (value != null) {
  print(value!.length);  // ! is unnecessary
}

// ✅ Cleaner
if (value != null) {
  print(value.length);  // Compiler knows it's not null
}
```

## 📖 Additional Resources

- [Dart Null Safety](https://dart.dev/null-safety)
- [Understanding Null Safety](https://dart.dev/null-safety/understanding-null-safety)

---

Ready? Start with **[Exercise 1: Nullable Types](exercises/1-nullable-types.md)**!
