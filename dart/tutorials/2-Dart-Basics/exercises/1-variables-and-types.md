# Exercise 1: Variables and Types

In this exercise, you'll explore Dart's type system, type inference, and variable declarations, with special attention to differences from Python.

## 🎯 Objective

Understand Dart's static type system, type inference, and the difference between var, final, and const.

## 📋 What You'll Learn

- How to declare variables in Dart
- Type inference with `var`
- Runtime vs compile-time constants
- Type checking and conversion

## 🚀 Steps

### Step 1: Start Your REPL

Make sure your environment is running and start the Dart REPL:

```bash
make dart-repl
```

### Step 2: Experiment with Type Inference

Try these commands in the REPL to see how Dart infers types:

**Basic Type Inference:**

```dart
// Dart infers the type
var name = "Alice";
var age = 30;
var height = 5.6;
var isActive = true;

// Check the values
name
age
height
isActive

// Check the types
name is String    // => true
age is int        // => true
height is double  // => true
```

**Type Can't Change:**

```dart
// Once a type is inferred, it's fixed
var count = 0;
count = 5;        // ✅ OK - still an int
// count = "five"  // ❌ Error! Can't change from int to String

// Try it and see the error
var value = 42;
// value = "hello"  // Uncomment to see the error
```

> **📘 Python Note:** Unlike Python where `value = 42; value = "hello"` would work fine, Dart's type is fixed once inferred. This catches type errors early!

### Step 3: Explicit Type Annotations

```dart
// Explicit type annotations
String username = "Alice";
int score = 100;
double rating = 4.5;
bool isPremium = true;

// Explicit types can help with clarity
String result;
if (score > 50) {
  result = "Pass";
} else {
  result = "Fail";
}
result
```

**When to Use Explicit Types:**

```dart
// Use explicit types when:
// 1. Type isn't obvious
List<String> names = [];
Map<String, int> scores = {};

// 2. Variable declared before assignment
String message;
message = "Hello";

// 3. For clarity in complex code
Future<List<User>> fetchUsers() {
  // ...
}
```

### Step 4: Understanding final vs const

```dart
// var - can be reassigned
var mutable = 10;
mutable = 20;  // ✅ OK

// final - cannot be reassigned, set at runtime
final immutable = DateTime.now();
// immutable = DateTime.now();  // ❌ Error!

// const - compile-time constant
const pi = 3.14159;
const apiUrl = "https://api.example.com";
// const now = DateTime.now();  // ❌ Error! Not a compile-time constant

// final can be set once at runtime
final timestamp = DateTime.now().millisecondsSinceEpoch;
timestamp

// const must be known at compile time
const maxRetries = 3;
const timeout = 30;
```

> **📘 Python Note:**
> - `var` is like regular Python variables
> - `final` is like Python variables you promise not to change (but not enforced)
> - `const` is truly compile-time constant (Python doesn't have this concept)
> - In Python, all "constants" are just conventions (UPPER_CASE)

### Step 5: Collections with const and final

```dart
// final list - can modify contents
final finalList = [1, 2, 3];
finalList.add(4);  // ✅ OK - can modify contents
// finalList = [5, 6];  // ❌ Error! Can't reassign

// const list - completely immutable
const constList = [1, 2, 3];
// constList.add(4);  // ❌ Error! Can't modify
// constList = [5, 6];  // ❌ Error! Can't reassign

// Try it
final myList = [1, 2, 3];
myList.add(4);
myList  // => [1, 2, 3, 4]
```

### Step 6: Type Checking

```dart
// Check types with 'is' operator
42 is int           // => true
"hello" is String   // => true
3.14 is double      // => true
true is bool        // => true

// Negative check with 'is!'
42 is! String       // => true
"hello" is! int     // => true

// Type hierarchy
42 is num           // => true (int is a subtype of num)
3.14 is num         // => true (double is a subtype of num)

// Get the runtime type
42.runtimeType      // => int
"hello".runtimeType // => String
```

> **📘 Python Note:** Dart's `is` operator is for type checking (like Python's `isinstance()`). Python's `is` operator (identity check) is `identical()` in Dart.

### Step 7: Type Conversion

```dart
// Parsing strings to numbers
int.parse("42")          // => 42
double.parse("3.14")     // => 3.14
// int.parse("hello")    // ❌ Throws FormatException!

// Safe parsing with try/catch
try {
  var num = int.parse("hello");
} catch (e) {
  print("Invalid number!");
}

// Convert numbers to strings
42.toString()            // => "42"
3.14.toString()          // => "3.14"

// Convert between number types
var intValue = 42;
var doubleValue = intValue.toDouble();  // => 42.0

var doubleValue2 = 3.14;
var intValue2 = doubleValue2.toInt();   // => 3 (truncates)
var intValue3 = doubleValue2.round();   // => 3 (rounds)
var intValue4 = doubleValue2.ceil();    // => 4 (rounds up)
var intValue5 = doubleValue2.floor();   // => 3 (rounds down)
```

### Step 8: The dynamic Type

```dart
// dynamic - opt out of type checking
dynamic anything = "Hello";
anything = 42;        // ✅ OK
anything = true;      // ✅ OK
anything = [1, 2, 3]; // ✅ OK

// But you lose type safety!
dynamic value = "hello";
// value.length;       // ✅ Works, but no compile-time check
// value.invalidMethod;  // ❌ Runtime error!

// Avoid dynamic when possible
// Use var with inference instead
var typed = "hello";
typed.length;         // ✅ Type-safe!
// typed = 42;        // ❌ Compile-time error!
```

> **📘 Python Note:** `dynamic` is like normal Python - type can change and errors happen at runtime. This is why Python developers should embrace Dart's type system!

### Step 9: Practice Exercise

Create variables to represent a user profile:

1. Create a const for the app version: "1.0.0"
2. Create a final variable for the current timestamp
3. Create variables for username, age, and email with appropriate types
4. Try to reassign const and final variables to see the errors
5. Convert the age to a string and concatenate it with "years old"

**Solution (try yourself first!):**

```dart
// 1. Const for app version
const appVersion = "1.0.0";

// 2. Final for current timestamp
final timestamp = DateTime.now().millisecondsSinceEpoch;

// 3. User variables
var username = "Alice";
var age = 30;
var email = "alice@example.com";

// Or with explicit types
String username2 = "Bob";
int age2 = 25;
String email2 = "bob@example.com";

// 4. Try reassigning (uncomment to see errors)
// appVersion = "2.0.0";  // ❌ Error!
// timestamp = DateTime.now().millisecondsSinceEpoch;  // ❌ Error!

// 5. Convert and concatenate
var ageText = "$age years old";
print(ageText);  // => "30 years old"
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You understand the difference between var, final, and const
- [ ] You can use type inference appropriately
- [ ] You know when to use explicit type annotations
- [ ] You understand that types can't change after inference
- [ ] You can check types with `is` operator
- [ ] You can convert between types safely

## 🎓 Key Takeaways

**Critical Differences from Python:**

1. **Static Typing:** Once a type is inferred or declared, it cannot change
2. **final vs const:** Two levels of immutability (runtime vs compile-time)
3. **Type Safety:** Catch type errors at compile time, not runtime
4. **Explicit is Optional:** Type inference works great, use explicit types for clarity

**Dart Idioms:**

```dart
// ✅ Good - type is obvious
var count = 0;
var name = "Alice";
var items = <String>[];

// ✅ Good - type for clarity
final DateTime createdAt = DateTime.now();
Map<String, dynamic> json = parseJson(data);

// ❌ Avoid - don't specify obvious types
String name = "Alice";  // var is clearer
int count = 42;         // var is clearer

// ❌ Avoid dynamic unless necessary
dynamic data = fetchData();  // Lose type safety
```

## 🐛 Common Mistakes

**Mistake 1: Trying to change type**
```dart
// ❌ Wrong
var value = 42;
value = "hello";  // Error!

// ✅ Correct - use dynamic (but avoid)
dynamic value = 42;
value = "hello";  // OK but not recommended
```

**Mistake 2: Using const for runtime values**
```dart
// ❌ Wrong
const now = DateTime.now();  // Error!

// ✅ Correct
final now = DateTime.now();  // OK
```

**Mistake 3: Not catching parse errors**
```dart
// ❌ Risky
var age = int.parse(userInput);  // Could throw!

// ✅ Safe
try {
  var age = int.parse(userInput);
} catch (e) {
  print("Invalid input");
}
```

## 🎉 Congratulations!

You now understand Dart's type system and the advantages of static typing! This foundation will help you write safer, more maintainable code.

## 🔜 Next Steps

Move on to **Exercise 2: Numbers and Strings** to learn about Dart's string interpolation and number operations!

## 💡 Pro Tips

- Use `var` when the type is obvious from the assignment
- Use `final` by default, only use `var` when you need to reassign
- Use `const` for true constants that never change
- Embrace static typing - it catches bugs early!
- The Dart analyzer will help you - pay attention to warnings
