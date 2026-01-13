# Tutorial 2: Dart Basics - Variables, Types, and Operators

Welcome to your second Dart tutorial! This guide introduces Dart's fundamental syntax and type system, with special attention to how they differ from Python.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Dart's type system and type inference
- Work with Dart's basic data types
- Master variable declaration with `var`, `final`, and `const`
- Use type annotations effectively
- Understand string interpolation
- Recognize key syntax differences from Python

## 🐍➡️🎯 Coming from Python

If you're a Python developer, you'll notice several differences:

| Concept | Python | Dart |
|---------|--------|------|
| Variable declaration | `name = "Alice"` | `var name = "Alice"` or `String name = "Alice"` |
| Type system | Dynamic typing | Static typing with inference |
| Constants | `UPPER_CASE` (convention) | `final` (runtime) or `const` (compile-time) |
| String interpolation | `f"{var}"` | `"${var}"` or `"$var"` |
| Null value | `None` | `null` |
| Boolean | `True`/`False` | `true`/`false` |
| Comments | `# comment` | `// comment` or `/* */` |
| Multi-line comments | `"""..."""` | `/* ... */` |
| Type checking | `type()` or `isinstance()` | `is` operator |
| Integer division | `//` | `~/` |

## 📝 Dart Type System

### Understanding Static Typing

Dart is **statically typed**, which means types are checked at compile time. This is different from Python's dynamic typing:

```dart
// Dart - type is known at compile time
String name = "Alice";  // This MUST be a String
name = 42;  // ❌ Compile error!

// In Python, this would be allowed:
// name = "Alice"
// name = 42  # ✅ Works fine in Python
```

> **📘 Python Note:** Dart's static typing catches type errors before your code runs, preventing many runtime bugs. It's like having Python's type hints enforced at compile time!

### Type Inference

Dart has powerful type inference - you don't always need to write types:

```dart
// Explicit type
String name = "Alice";
int age = 30;

// Type inference with var
var name = "Alice";  // Dart infers String
var age = 30;        // Dart infers int

// Both are equivalent!
```

> **📘 Python Note:** Similar to Python's type inference, but Dart's types are enforced. Once a variable's type is determined, it cannot change.

## 📝 Variables and Constants

### var, final, and const

Dart has three ways to declare variables:

```dart
// var - type is inferred, value can change
var name = "Alice";
name = "Bob";  // ✅ OK

// final - runtime constant, assigned once
final birthDate = DateTime.now();
// birthDate = DateTime.now();  // ❌ Error! Can't reassign

// const - compile-time constant
const pi = 3.14159;
const apiUrl = "https://api.example.com";
// const now = DateTime.now();  // ❌ Error! DateTime.now() is not a compile-time constant
```

> **📘 Python Note:**
> - `var` is like regular Python variables
> - `final` is like Python's variables that you never reassign (but not enforced)
> - `const` is like Python constants but actually enforced at compile time
> - In Python, you might use `Final` from typing for hints, but it's not enforced

### When to Use Each

```dart
// Use var when the type is obvious
var count = 0;
var items = <String>[];

// Use explicit types for clarity or when assigned later
String result;
if (condition) {
  result = "success";
} else {
  result = "failure";
}

// Use final for values that won't change
final userId = getUserId();
final config = loadConfig();

// Use const for compile-time constants
const maxRetries = 3;
const defaultTimeout = Duration(seconds: 30);
```

## 📝 Data Types

### Numbers

```dart
// Integers - 64-bit (or arbitrary precision on web)
int age = 30;
int bigNumber = 9223372036854775807;
int hex = 0xDEADBEEF;

// Doubles - 64-bit floating point
double pi = 3.14159;
double scientific = 1.5e10;

// Type conversion
int.parse("42")          // => 42
double.parse("3.14")     // => 3.14
42.toString()            // => "42"
3.14.toString()          // => "3.14"

// Operations
10 + 5    // => 15
10 - 5    // => 5
10 * 5    // => 50
10 / 5    // => 2.0 (always returns double!)
10 ~/ 3   // => 3 (integer division)
10 % 3    // => 1 (remainder)
2.pow(3)  // => 8 (must use method, not **)
```

> **📘 Python Note:**
> - Dart has two number types: `int` and `double` (Python has `int`, `float`, `complex`)
> - `/` always returns double in Dart (Python 3 behavior)
> - Use `~/` for integer division (Python's `//`)
> - Exponentiation uses `.pow()` method, not `**` operator
> - `int.parse()` throws an exception on invalid input (unlike Ruby's `.to_i`)

### Strings

```dart
// Single vs double quotes - no difference in Dart!
var s1 = 'Single quotes';
var s2 = "Double quotes";

// String interpolation
var name = "Alice";
var age = 30;

// Simple variable - just use $
print("Name: $name");  // => "Name: Alice"

// Expression - use ${}
print("Next year: ${age + 1}");  // => "Next year: 31"

// Multi-line strings
var multiline = '''
This is a
multi-line
string.
''';

var alsoMultiline = """
Double quotes
work too!
""";

// Raw strings (no escaping or interpolation)
var rawString = r"C:\Users\Alice\Documents";  // Backslashes not escaped
var rawWithInterp = r"Value: $value";  // Prints literally: Value: $value

// Common string methods
"hello".toUpperCase()        // => "HELLO"
"WORLD".toLowerCase()        // => "world"
"hello".length               // => 5
"hello"[0]                   // => "h"
"  trim  ".trim()            // => "trim"
"hello".replaceAll("l", "L") // => "heLLo"
"a,b,c".split(",")           // => ["a", "b", "c"]
```

> **📘 Python Note:**
> - Unlike Python, single and double quotes are identical in Dart
> - String interpolation uses `$var` or `${expression}` instead of f-strings
> - Triple quotes work like Python for multi-line strings
> - Raw strings use `r"..."` prefix (like Python's `r"..."`)
> - Strings are immutable (like Python 3)

### Booleans

```dart
// Boolean values (lowercase!)
bool isActive = true;
bool isDeleted = false;

// Comparison operators
5 == 5    // => true
5 != 3    // => true
5 > 3     // => true
5 >= 5    // => true
5 < 10    // => true
5 <= 5    // => true

// Logical operators
true && false   // => false (and)
true || false   // => true (or)
!true           // => false (not)

// Type checking
"hello" is String     // => true
42 is int             // => true
42 is! String         // => true (is not)
```

> **📘 Python Note:**
> - Use lowercase `true`/`false` (not `True`/`False`)
> - Dart uses `&&`, `||`, `!` (Python uses `and`, `or`, `not`)
> - Type checking uses `is` operator (like Python's `isinstance()`)
> - Dart has no implicit truthiness - must use actual booleans in conditions!

### Dynamic and Object Types

```dart
// dynamic - opt out of type checking (like Python)
dynamic anything = "Hello";
anything = 42;        // ✅ OK
anything = true;      // ✅ OK

// Object - root of type hierarchy
Object obj = "Hello";
obj = 42;             // ✅ OK
// obj.length;        // ❌ Error! Object doesn't have length

// Use var with inference instead
var value = "Hello";
// value = 42;        // ❌ Error! Type is inferred as String
```

> **📘 Python Note:**
> - `dynamic` is like normal Python variables - type can change
> - Avoid `dynamic` when possible - you lose type safety
> - Use `var` with type inference for the best of both worlds

## 📝 Operators

### Arithmetic Operators

```dart
// Basic arithmetic
10 + 5     // => 15
10 - 5     // => 5
10 * 5     // => 50
10 / 5     // => 2.0 (double)
10 ~/ 3    // => 3 (integer division)
10 % 3     // => 1 (modulo)

// Unary operators
var a = 5;
-a         // => -5 (negate)
a++        // => 5 (then increments to 6)
++a        // => 7 (increments then returns 7)
a--        // => 7 (then decrements to 6)
--a        // => 5 (decrements then returns 5)

// Assignment operators
a += 5     // a = a + 5
a -= 3     // a = a - 3
a *= 2     // a = a * 2
a ~/= 2    // a = a ~/ 2
```

### String Operators

```dart
// Concatenation
"Hello" + " " + "World"   // => "Hello World"

// Repetition (no * operator for strings in Dart)
"ha" * 3                  // ❌ Error! Use a loop or list.filled

// Use join instead
List.filled(3, "ha").join()  // => "hahaha"
```

> **📘 Python Note:**
> - Dart doesn't have `*` for string repetition (unlike Python's `"ha" * 3`)
> - Use `List.filled(n, str).join()` instead

### Comparison and Equality

```dart
// Value equality
5 == 5             // => true
"hello" == "hello" // => true

// Identity equality (same object in memory)
var a = [1, 2, 3];
var b = [1, 2, 3];
a == b             // => false (different list objects)
identical(a, b)    // => false

var c = a;
identical(a, c)    // => true (same object)
```

> **📘 Python Note:**
> - `==` compares values (like Python)
> - `identical()` is like Python's `is` operator
> - Dart doesn't have `is` for identity (it's used for type checking)

## ✍️ Exercises

Ready to practice? Let's solidify your understanding with hands-on exercises!

### Exercise 1: Variables and Types

Learn Dart's type system and variable declarations.

👉 **[Start Exercise 1: Variables and Types](exercises/1-variables-and-types.md)**

In this exercise, you'll:
- Declare variables with different approaches
- Practice type inference
- Use final and const appropriately
- Understand compile-time vs runtime constants

### Exercise 2: Working with Numbers and Strings

Master Dart's number and string operations.

👉 **[Start Exercise 2: Numbers and Strings](exercises/2-numbers-and-strings.md)**

In this exercise, you'll:
- Perform arithmetic operations
- Practice string interpolation
- Use string methods
- Convert between types

### Exercise 3: Type Safety and Conversions

Build a type-safe calculator.

👉 **[Start Exercise 3: Calculator Challenge](exercises/3-calculator-challenge.md)**

In this exercise, you'll:
- Combine multiple concepts
- Handle type conversions safely
- Format output nicely
- Apply Dart's type system

## 📚 What You Learned

After completing the exercises, you will know:

✅ Dart's static type system and type inference
✅ How to use var, final, and const
✅ Working with numbers, strings, and booleans
✅ String interpolation with `${}` or `$`
✅ Type conversion and checking
✅ Key differences between Dart and Python

## 🔜 Next Steps

Congratulations on completing the Dart Basics tutorial! You now understand:
- Dart's type system and its advantages
- Variable declarations and immutability
- Basic data types and their operations
- Critical differences from Python

You're ready to learn about control flow!

**Next tutorial: 3-Control-Flow**

## 💡 Key Takeaways for Python Developers

1. **Static Typing:** Types are checked at compile time - catches bugs early!
2. **Type Inference:** Use `var` when type is obvious
3. **Immutability:** Use `final` for runtime constants, `const` for compile-time constants
4. **String Interpolation:** `$var` or `${expression}` is cleaner than f-strings
5. **No Implicit Truthiness:** Must use actual boolean expressions
6. **Integer Division:** Use `~/` not `//`

## 🆘 Common Pitfalls

### Pitfall 1: Type Changes

```dart
// ❌ Wrong - type can't change
var value = "Hello";
value = 42;  // Error!

// ✅ Correct - use dynamic if you really need this (avoid)
dynamic value = "Hello";
value = 42;  // OK but not recommended
```

### Pitfall 2: Division Always Returns Double

```dart
// ❌ Unexpected result
var half = 5 / 2;  // => 2.5 (double!)

// ✅ Use integer division
var half = 5 ~/ 2;  // => 2 (int)
```

### Pitfall 3: Const vs Final

```dart
// ❌ Wrong - DateTime.now() is not compile-time constant
const now = DateTime.now();  // Error!

// ✅ Use final for runtime constants
final now = DateTime.now();  // OK
```

### Pitfall 4: String Concatenation in Loops

```dart
// ❌ Inefficient - creates many string objects
var result = "";
for (var i = 0; i < 1000; i++) {
  result += i.toString();
}

// ✅ Use StringBuffer for efficient concatenation
var buffer = StringBuffer();
for (var i = 0; i < 1000; i++) {
  buffer.write(i);
}
var result = buffer.toString();
```

## 📖 Additional Resources

- [Dart Language Tour - Variables](https://dart.dev/language/variables)
- [Dart Language Tour - Built-in Types](https://dart.dev/language/built-in-types)
- [Effective Dart - Usage](https://dart.dev/effective-dart/usage)
- [Dart Type System](https://dart.dev/language/type-system)

---

Ready to get started? Begin with **[Exercise 1: Variables and Types](exercises/1-variables-and-types.md)**!
