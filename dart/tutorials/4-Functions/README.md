# Tutorial 4: Functions - Parameters, Closures, and Higher-Order Functions

Welcome to your fourth Dart tutorial! This guide explores Dart's powerful function system, including named parameters, optional parameters, arrow functions, closures, and higher-order functions.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master function declarations and parameters
- Understand positional vs named parameters
- Use optional and required parameters effectively
- Write arrow functions for concise code
- Work with anonymous functions and closures
- Create and use higher-order functions
- Understand function types and signatures

## 🐍➡️🎯 Coming from Python

If you're a Python developer, you'll notice several differences:

| Concept | Python | Dart |
|---------|--------|------|
| Function definition | `def name(param):` | `returnType name(Type param) {` |
| Return type | No type annotation (optional) | Explicit or inferred |
| Named parameters | `func(name=value)` | `func(name: value)` with `{required}` |
| Optional parameters | `def func(param=default):` | `func([Type? param])` or `{Type param = default}` |
| Lambda | `lambda x: x * 2` | `(x) => x * 2` |
| First-class functions | Yes | Yes |
| Closures | Yes | Yes |
| Decorators | `@decorator` | No direct equivalent (use wrappers) |

## 📝 Function Basics

### Basic Function Declaration

```dart
// Function with return type
int add(int a, int b) {
  return a + b;
}

var result = add(5, 3);  // 8

// Function with no return value (void)
void greet(String name) {
  print("Hello, $name!");
}

greet("Alice");  // Hello, Alice!

// Type inference for return type
// Dart can infer the return type
sum(int a, int b) {
  return a + b;  // Inferred as int
}

// But explicit is often better for clarity
String formatName(String first, String last) {
  return "$first $last";
}
```

> **📘 Python Note:** Unlike Python where type hints are optional, Dart encourages explicit types. However, type inference works great for simple cases.

### Arrow Functions (Expression Bodies)

For single-expression functions, use arrow syntax:

```dart
// Traditional function
int square(int x) {
  return x * x;
}

// Arrow function - much cleaner!
int square(int x) => x * x;

// More examples
String shout(String text) => text.toUpperCase();
bool isEven(int n) => n % 2 == 0;
void log(String msg) => print("[LOG] $msg");

// Use in expressions
var numbers = [1, 2, 3, 4, 5];
var squares = numbers.map((n) => n * n).toList();
print(squares);  // [1, 4, 9, 16, 25]
```

> **📘 Python Note:** Similar to Python's lambda, but more powerful since it can be multi-line and have statements. Arrow functions are the idiomatic way to write short functions in Dart.

## 📝 Parameters

### Positional Parameters

```dart
// Required positional parameters
String describe(String name, int age) {
  return "$name is $age years old";
}

print(describe("Alice", 30));  // Must provide both in order

// Optional positional parameters
// Use square brackets []
String greet(String name, [String? title]) {
  if (title != null) {
    return "Hello, $title $name";
  }
  return "Hello, $name";
}

print(greet("Alice"));              // Hello, Alice
print(greet("Alice", "Dr."));       // Hello, Dr. Alice

// Optional positional with defaults
String makeURL(String domain, [String protocol = "https", int port = 443]) {
  return "$protocol://$domain:$port";
}

print(makeURL("example.com"));                    // https://example.com:443
print(makeURL("example.com", "http"));            // http://example.com:443
print(makeURL("example.com", "http", 80));        // http://example.com:80
```

> **📘 Python Note:** Python uses `def func(param=default)` for all optional parameters. Dart distinguishes between positional and named optional parameters.

### Named Parameters

Named parameters make code much more readable!

```dart
// Named parameters use curly braces {}
void createUser({String? name, int? age, String? email}) {
  print("Creating user: $name, $age, $email");
}

// Call with any order, by name
createUser(name: "Alice", age: 30, email: "alice@example.com");
createUser(email: "bob@example.com", name: "Bob");
createUser(name: "Charlie");  // Others are null

// Required named parameters
void registerUser({
  required String username,
  required String password,
  String? email
}) {
  print("Registering $username");
}

// Must provide required parameters
registerUser(username: "alice", password: "secret123");
// registerUser(username: "bob");  // Error! password is required

// Named parameters with defaults
void configure({
  String theme = "light",
  int fontSize = 14,
  bool enableNotifications = true
}) {
  print("Theme: $theme, Font: $fontSize, Notifications: $enableNotifications");
}

configure();  // Uses all defaults
configure(theme: "dark");
configure(theme: "dark", fontSize: 16, enableNotifications: false);
```

> **📘 Python Note:** Very similar to Python's keyword arguments! The `required` keyword is like Python's required keyword-only parameters (after `*`).

### Mixing Positional and Named Parameters

```dart
// Positional required, then named optional
void sendMessage(
  String recipient,
  String message,
  {bool urgent = false, String? cc}
) {
  var prefix = urgent ? "[URGENT] " : "";
  print("To: $recipient${cc != null ? ', CC: $cc' : ''}");
  print("$prefix$message");
}

sendMessage("Alice", "Hello!");
sendMessage("Bob", "Meeting at 3pm", urgent: true);
sendMessage("Charlie", "FYI", cc: "Dave");

// Common pattern: some positional, rest named
List<T> sample<T>(
  List<T> items,
  int count,
  {bool shuffle = false}
) {
  var result = shuffle ? (items.toList()..shuffle()) : items;
  return result.take(count).toList();
}
```

> **📘 Python Note:** Python allows mixing positional and keyword args similarly. The main difference is Dart's explicit `required` keyword and type annotations.

## 📝 Anonymous Functions and Closures

### Anonymous Functions (Lambdas)

```dart
// Anonymous function assigned to variable
var multiply = (int a, int b) => a * b;
print(multiply(5, 3));  // 15

// Multi-line anonymous function
var greet = (String name) {
  var message = "Hello, $name!";
  print(message);
  return message;
};

// Used inline
var numbers = [1, 2, 3, 4, 5];

// Traditional
numbers.forEach((n) {
  print(n * 2);
});

// Arrow style
numbers.forEach((n) => print(n * 2));

// With type annotations
var filtered = numbers.where((int n) => n > 2).toList();
print(filtered);  // [3, 4, 5]
```

> **📘 Python Note:** Similar to Python's lambda, but Dart's anonymous functions can be multi-line and have statements (Python's lambda is expression-only).

### Closures

Functions can capture variables from their enclosing scope:

```dart
// Closure captures 'multiplier'
Function makeMultiplier(int multiplier) {
  return (int value) => value * multiplier;
}

var times2 = makeMultiplier(2);
var times10 = makeMultiplier(10);

print(times2(5));   // 10
print(times10(5));  // 50

// More complex closure
Function makeCounter() {
  var count = 0;  // Captured by closure
  return () {
    count++;
    return count;
  };
}

var counter1 = makeCounter();
var counter2 = makeCounter();

print(counter1());  // 1
print(counter1());  // 2
print(counter2());  // 1  (separate closure)
print(counter1());  // 3
```

> **📘 Python Note:** Identical concept to Python's closures! Variables from outer scope are captured and maintained.

### Practical Closure Example

```dart
// Create a validator factory
Function makeValidator(int min, int max) {
  return (int value) {
    if (value < min) return "Too small (min: $min)";
    if (value > max) return "Too large (max: $max)";
    return "Valid";
  };
}

var ageValidator = makeValidator(0, 120);
var scoreValidator = makeValidator(0, 100);

print(ageValidator(25));    // Valid
print(ageValidator(150));   // Too large (max: 120)
print(scoreValidator(95));  // Valid
print(scoreValidator(-5));  // Too small (min: 0)
```

## 📝 Higher-Order Functions

Functions that take functions as parameters or return functions.

### Functions as Parameters

```dart
// Function that takes a function parameter
void repeat(int times, void Function() action) {
  for (var i = 0; i < times; i++) {
    action();
  }
}

repeat(3, () => print("Hello!"));
// Hello!
// Hello!
// Hello!

// With parameters
void forEach(List<int> items, void Function(int) action) {
  for (var item in items) {
    action(item);
  }
}

forEach([1, 2, 3], (n) => print(n * 2));
// 2
// 4
// 6

// Generic higher-order function
List<R> map<T, R>(List<T> items, R Function(T) transform) {
  var result = <R>[];
  for (var item in items) {
    result.add(transform(item));
  }
  return result;
}

var numbers = [1, 2, 3, 4, 5];
var doubled = map(numbers, (n) => n * 2);
print(doubled);  // [2, 4, 6, 8, 10]
```

### Common Higher-Order Functions

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// map - transform each element
var squares = numbers.map((n) => n * n).toList();
print(squares);  // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

// where - filter elements
var evens = numbers.where((n) => n % 2 == 0).toList();
print(evens);  // [2, 4, 6, 8, 10]

// reduce - combine to single value
var sum = numbers.reduce((a, b) => a + b);
print(sum);  // 55

// fold - reduce with initial value
var product = numbers.fold(1, (a, b) => a * b);
print(product);  // 3628800

// any - check if any element matches
var hasEven = numbers.any((n) => n % 2 == 0);
print(hasEven);  // true

// every - check if all elements match
var allPositive = numbers.every((n) => n > 0);
print(allPositive);  // true

// forEach - perform action on each
numbers.forEach((n) => print("Number: $n"));
```

> **📘 Python Note:** Very similar to Python's map, filter, reduce, any, all! Dart's syntax is just slightly different.

### Chaining Higher-Order Functions

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Chain multiple operations
var result = numbers
    .where((n) => n % 2 == 0)     // Filter evens
    .map((n) => n * n)             // Square them
    .where((n) => n > 20)          // Only > 20
    .toList();

print(result);  // [36, 64, 100]

// Complex processing pipeline
var words = ["hello", "world", "dart", "is", "awesome"];

var processed = words
    .where((w) => w.length > 3)    // Longer than 3 chars
    .map((w) => w.toUpperCase())   // Uppercase
    .map((w) => "$w!")             // Add exclamation
    .toList();

print(processed);  // [HELLO!, WORLD!, DART!, AWESOME!]
```

### Custom Higher-Order Functions

```dart
// Create a timing wrapper
R timeIt<R>(String name, R Function() fn) {
  var stopwatch = Stopwatch()..start();
  var result = fn();
  stopwatch.stop();
  print("$name took ${stopwatch.elapsedMicroseconds}μs");
  return result;
}

// Use it
var result = timeIt("calculation", () {
  var sum = 0;
  for (var i = 0; i < 1000000; i++) {
    sum += i;
  }
  return sum;
});

// Create a retry wrapper
T retry<T>(T Function() fn, {int attempts = 3}) {
  for (var i = 0; i < attempts; i++) {
    try {
      return fn();
    } catch (e) {
      if (i == attempts - 1) rethrow;
      print("Attempt ${i + 1} failed, retrying...");
    }
  }
  throw StateError("Should not reach here");
}

// Create a memoization wrapper
Function memoize(Function fn) {
  var cache = <String, dynamic>{};
  return (arg) {
    var key = arg.toString();
    if (!cache.containsKey(key)) {
      cache[key] = fn(arg);
    }
    return cache[key];
  };
}

var expensiveCalc = (int n) {
  print("Computing for $n...");
  return n * n;
};

var memoized = memoize(expensiveCalc);
print(memoized(5));  // Computing for 5... 25
print(memoized(5));  // 25 (cached, no "Computing" message)
```

## 📝 Function Types

Functions have types too!

```dart
// Declare function type
typedef IntOperation = int Function(int, int);

// Use it
int calculate(int a, int b, IntOperation operation) {
  return operation(a, b);
}

var result1 = calculate(10, 5, (a, b) => a + b);  // 15
var result2 = calculate(10, 5, (a, b) => a * b);  // 50

// Function type variables
IntOperation add = (a, b) => a + b;
IntOperation multiply = (a, b) => a * b;

print(add(3, 4));       // 7
print(multiply(3, 4));  // 12

// Generic function types
typedef Mapper<T, R> = R Function(T);
typedef Predicate<T> = bool Function(T);

List<R> transform<T, R>(List<T> items, Mapper<T, R> mapper) {
  return items.map(mapper).toList();
}

List<T> filter<T>(List<T> items, Predicate<T> predicate) {
  return items.where(predicate).toList();
}

var numbers = [1, 2, 3, 4, 5];
var doubled = transform(numbers, (n) => n * 2);
var evens = filter(numbers, (n) => n % 2 == 0);
```

> **📘 Python Note:** Similar to Python's typing.Callable, but more integrated into the language. Typedefs make function signatures reusable.

## ✍️ Exercises

Ready to practice? Let's solidify your understanding with hands-on exercises!

### Exercise 1: Basic Functions

Learn function declarations, parameters, and arrow functions.

👉 **[Start Exercise 1: Basic Functions](exercises/1-basic-functions.md)**

In this exercise, you'll:
- Create functions with various parameter types
- Use positional and named parameters
- Write arrow functions
- Practice parameter defaults

### Exercise 2: Advanced Functions

Master closures and higher-order functions.

👉 **[Start Exercise 2: Advanced Functions](exercises/2-advanced-functions.md)**

In this exercise, you'll:
- Create and use closures
- Write higher-order functions
- Chain functional operations
- Use function types

### Exercise 3: Function Challenges

Apply everything you've learned to solve real-world problems.

👉 **[Start Exercise 3: Function Challenges](exercises/3-function-challenges.md)**

In this exercise, you'll:
- Build a function pipeline
- Create utility functions
- Implement functional patterns
- Compare with Python approaches

## 📚 What You Learned

After completing the exercises, you will know:

✅ Function declarations and return types
✅ Positional vs named parameters
✅ Optional and required parameters
✅ Arrow functions for concise code
✅ Anonymous functions and closures
✅ Higher-order functions
✅ Function types and typedefs
✅ Functional programming patterns

## 🔜 Next Steps

Congratulations on completing the Functions tutorial! You now understand:
- All parameter types and how to use them
- Closures and their power
- Higher-order functions for clean code
- How Dart's function system compares to Python

You're ready to learn about collections!

**Next tutorial: 5-Collections**

## 💡 Key Takeaways for Python Developers

1. **Named Parameters**: Use `{required}` for mandatory named params
2. **Arrow Functions**: `=>` is more powerful than Python's lambda
3. **Type Safety**: Function signatures are checked at compile time
4. **Closures**: Same concept as Python, syntax slightly different
5. **Higher-Order**: Very similar to Python's functional style
6. **Required Keyword**: Explicit required named parameters

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting Required Keyword

```dart
// ❌ Wrong - named params are optional by default
void createUser({String name, int age}) {  // Error!
  // ...
}

// ✅ Correct - mark as required or nullable
void createUser({required String name, required int age}) {
  // ...
}

// Or make nullable with default
void createUser({String? name, int? age}) {
  // ...
}
```

### Pitfall 2: Mixing Parameter Types Wrong

```dart
// ❌ Wrong - named before positional
void func({String name}, int age) {  // Error!
  // ...
}

// ✅ Correct - positional then named
void func(int age, {String? name}) {
  // ...
}
```

### Pitfall 3: Not Using Arrow Functions

```dart
// ❌ Verbose - single expression doesn't need {}
int square(int x) {
  return x * x;
}

// ✅ Concise - use arrow function
int square(int x) => x * x;
```

### Pitfall 4: Forgetting toList()

```dart
// ❌ Wrong - map/where return Iterable, not List
var numbers = [1, 2, 3, 4, 5];
var evens = numbers.where((n) => n % 2 == 0);  // Iterable, not List!
// evens[0];  // Error! No subscript operator

// ✅ Correct - convert to List
var evens = numbers.where((n) => n % 2 == 0).toList();
evens[0];  // Works!
```

## 📖 Additional Resources

- [Dart Language Tour - Functions](https://dart.dev/language/functions)
- [Effective Dart - Usage (Functions)](https://dart.dev/effective-dart/usage#functions)
- [Dart Language - Function Types](https://dart.dev/language/functions#function-types)

---

Ready to get started? Begin with **[Exercise 1: Basic Functions](exercises/1-basic-functions.md)**!
