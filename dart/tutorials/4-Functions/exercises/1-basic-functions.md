# Exercise 1: Basic Functions

In this exercise, you'll explore Dart's function declarations, parameters, and arrow functions.

## 🎯 Objective

Master function basics including parameter types, defaults, and arrow syntax.

## 📋 What You'll Learn

- Function declarations with return types
- Positional and named parameters
- Optional parameters and defaults
- Arrow functions
- Function overloading patterns

## 🚀 Steps

### Step 1: Start Your REPL

```bash
make dart-repl
```

### Step 2: Basic Function Declarations

```dart
// Simple function with return type
int add(int a, int b) {
  return a + b;
}

print(add(5, 3));  // 8

// Function with String return
String greet(String name) {
  return "Hello, $name!";
}

print(greet("Alice"));  // Hello, Alice!

// Void function (no return value)
void printSum(int a, int b) {
  print("Sum: ${a + b}");
}

printSum(10, 20);  // Sum: 30

// Function with type inference
calculateArea(double width, double height) {
  return width * height;  // Return type inferred as double
}

print(calculateArea(5.0, 3.0));  // 15.0
```

> **📘 Python Note:** Unlike Python where return types are optional hints, Dart's types are enforced. Use explicit types for clarity.

### Step 3: Arrow Functions

Arrow functions are perfect for single expressions:

```dart
// Traditional
int square(int x) {
  return x * x;
}

// Arrow function - much cleaner!
int squareArrow(int x) => x * x;

print(squareArrow(5));  // 25

// More examples
String shout(String text) => text.toUpperCase();
bool isEven(int n) => n % 2 == 0;
bool isOdd(int n) => n % 2 != 0;
double half(double n) => n / 2;

print(shout("hello"));  // HELLO
print(isEven(4));       // true
print(isOdd(4));        // false
print(half(10));        // 5.0

// Arrow functions in collections
var numbers = [1, 2, 3, 4, 5];
var doubled = numbers.map((n) => n * 2).toList();
print(doubled);  // [2, 4, 6, 8, 10]
```

> **📘 Python Note:** Similar to lambda, but more powerful. Can access multiple lines in body using block syntax.

### Step 4: Optional Positional Parameters

Use square brackets for optional positional parameters:

```dart
// Optional parameters with []
String describe(String name, [int? age, String? city]) {
  var parts = [name];
  if (age != null) parts.add("$age years old");
  if (city != null) parts.add("from $city");
  return parts.join(", ");
}

print(describe("Alice"));                    // Alice
print(describe("Bob", 30));                  // Bob, 30 years old
print(describe("Charlie", 25, "New York"));  // Charlie, 25 years old, from New York

// With defaults
String makeURL(String host, [String protocol = "https", int port = 443]) {
  return "$protocol://$host:$port";
}

print(makeURL("example.com"));              // https://example.com:443
print(makeURL("example.com", "http"));      // http://example.com:443
print(makeURL("example.com", "http", 80));  // http://example.com:80
```

### Step 5: Named Parameters

Named parameters make code more readable:

```dart
// Named parameters with {}
void printPerson({String? name, int? age, String? email}) {
  print("Name: ${name ?? 'N/A'}");
  print("Age: ${age ?? 'N/A'}");
  print("Email: ${email ?? 'N/A'}");
}

// Call in any order
printPerson(name: "Alice", age: 30);
printPerson(email: "bob@example.com", name: "Bob");
printPerson(age: 25);

// Required named parameters
void createUser({
  required String username,
  required String password,
  String email = "no-email@example.com"
}) {
  print("Creating user: $username");
  print("Email: $email");
}

createUser(username: "alice", password: "secret123");
createUser(
  username: "bob",
  password: "password",
  email: "bob@example.com"
);
// createUser(username: "charlie");  // Error! password required
```

> **📘 Python Note:** Similar to Python's keyword arguments. The `required` keyword is like Python's required keyword-only args.

### Step 6: Mixing Parameters

```dart
// Positional required + named optional
void sendEmail(
  String to,
  String subject,
  {String? cc,
   String? bcc,
   bool urgent = false}
) {
  print("To: $to");
  print("Subject: $subject");
  if (cc != null) print("CC: $cc");
  if (bcc != null) print("BCC: $bcc");
  if (urgent) print("[URGENT]");
}

sendEmail("alice@example.com", "Meeting");
sendEmail(
  "bob@example.com",
  "Project Update",
  cc: "team@example.com",
  urgent: true
);

// Common pattern
List<String> split(String text, String delimiter, {bool trim = false}) {
  var parts = text.split(delimiter);
  if (trim) {
    parts = parts.map((s) => s.trim()).toList();
  }
  return parts;
}

print(split("a,b,c", ","));              // [a, b, c]
print(split("a , b , c", ",", trim: true));  // [a, b, c]
```

### Step 7: Practice - Create Utility Functions

Create these utility functions using appropriate parameter types:

```dart
// 1. Calculator function
double calculate(double a, double b, String operation) {
  return switch (operation) {
    "+" => a + b,
    "-" => a - b,
    "*" => a * b,
    "/" => b != 0 ? a / b : double.nan,
    _ => double.nan
  };
}

print(calculate(10, 5, "+"));  // 15.0
print(calculate(10, 5, "*"));  // 50.0

// 2. Format name (with optional title and suffix)
String formatName(String firstName, String lastName,
    {String? title, String? suffix}) {
  var parts = <String>[];
  if (title != null) parts.add(title);
  parts.add(firstName);
  parts.add(lastName);
  if (suffix != null) parts.add(suffix);
  return parts.join(" ");
}

print(formatName("John", "Doe"));                          // John Doe
print(formatName("Jane", "Smith", title: "Dr."));          // Dr. Jane Smith
print(formatName("Bob", "Jones", suffix: "Jr."));          // Bob Jones Jr.
print(formatName("Alice", "Brown", title: "Prof.", suffix: "PhD"));
// Prof. Alice Brown PhD

// 3. Range checker
bool inRange(num value, num min, num max, {bool inclusive = true}) {
  if (inclusive) {
    return value >= min && value <= max;
  } else {
    return value > min && value < max;
  }
}

print(inRange(5, 1, 10));                    // true
print(inRange(10, 1, 10));                   // true
print(inRange(10, 1, 10, inclusive: false)); // false
```

### Step 8: Script Challenge - Math Library

Create a script with various math utility functions.

**Create this file:** `/home/user/learning-with-claude/dart/tutorials/4-Functions/exercises/math_utils.dart`

```dart
void main() {
  // Test basic operations
  print("=== Basic Operations ===");
  print("Add: ${add(5, 3)}");
  print("Multiply: ${multiply(4, 7)}");
  print("Power: ${power(2, 8)}");

  // Test circle functions
  print("\n=== Circle (radius 5) ===");
  print("Area: ${circleArea(5)}");
  print("Circumference: ${circleCircumference(5)}");

  // Test temperature conversion
  print("\n=== Temperature ===");
  print("100°C = ${celsiusToFahrenheit(100)}°F");
  print("32°F = ${fahrenheitToCelsius(32)}°C");

  // Test statistics
  print("\n=== Statistics ===");
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  print("Average: ${average(numbers)}");
  print("Sum: ${sum(numbers)}");
  print("Max: ${findMax(numbers)}");
  print("Min: ${findMin(numbers)}");
}

// Basic arithmetic
int add(int a, int b) => a + b;
int subtract(int a, int b) => a - b;
int multiply(int a, int b) => a * b;
double divide(int a, int b) => a / b;

// Power function
int power(int base, int exponent) {
  var result = 1;
  for (var i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}

// Circle functions
double circleArea(double radius) => 3.14159 * radius * radius;
double circleCircumference(double radius) => 2 * 3.14159 * radius;

// Temperature conversion
double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;

// Statistics
double average(List<num> numbers) {
  if (numbers.isEmpty) return 0;
  return sum(numbers) / numbers.length;
}

num sum(List<num> numbers) {
  return numbers.fold(0, (a, b) => a + b);
}

num findMax(List<num> numbers) {
  if (numbers.isEmpty) throw ArgumentError("List cannot be empty");
  return numbers.reduce((a, b) => a > b ? a : b);
}

num findMin(List<num> numbers) {
  if (numbers.isEmpty) throw ArgumentError("List cannot be empty");
  return numbers.reduce((a, b) => a < b ? a : b);
}
```

**Run it:**

```bash
make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/4-Functions/exercises/math_utils.dart
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can write functions with proper return types
- [ ] You understand positional vs named parameters
- [ ] You can use optional parameters with defaults
- [ ] You write arrow functions for single expressions
- [ ] You created and ran the math utils script

## 🎓 Key Takeaways

**Parameter Types:**
1. **Required Positional**: `func(Type param)`
2. **Optional Positional**: `func([Type? param])` or `func([Type param = default])`
3. **Required Named**: `func({required Type param})`
4. **Optional Named**: `func({Type? param})` or `func({Type param = default})`

**Best Practices:**
- Use named parameters for optional settings
- Use required keyword for mandatory named params
- Use arrow functions for single expressions
- Provide explicit return types for clarity

## 🐛 Common Mistakes

**Mistake 1: Wrong parameter order**
```dart
// ❌ Wrong - named before positional
void func({String name}, int age) { }  // Error!

// ✅ Correct
void func(int age, {String? name}) { }
```

**Mistake 2: Forgetting required**
```dart
// ❌ Wrong - assumes required but isn't
void func({String name}) { }  // Error! Must be nullable or have default

// ✅ Correct
void func({required String name}) { }
void func({String? name}) { }
void func({String name = "default"}) { }
```

## 🎉 Congratulations!

You understand Dart's function basics! Move on to **Exercise 2: Advanced Functions**.

## 💡 Pro Tips

- Prefer named parameters for options/config
- Use arrow functions when body is a single expression
- Always provide return types (except for very obvious cases)
- Use required keyword liberally for API clarity
