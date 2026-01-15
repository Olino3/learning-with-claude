# Tutorial 16: Advanced Patterns and Features (Dart 3.0+)

Welcome to modern Dart! This tutorial covers Dart 3.0+'s advanced features including pattern matching, records, sealed classes, and class modifiers.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master pattern matching in Dart 3.0+
- Use records for lightweight data grouping
- Implement sealed classes for exhaustive checking
- Understand class modifiers (base, final, interface, mixin)
- Use destructuring patterns
- Apply switch expressions effectively
- Combine patterns for complex matching

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart 3.0+ |
|---------|--------|-----------|
| Pattern matching | `match/case` (3.10+) | `switch` with patterns |
| Tuples | `(a, b, c)` | Records `(a, b, c)` |
| Named tuples | `namedtuple` | Named records `(name: a, age: b)` |
| Union types | `Union[A, B]` | Sealed classes |
| Dataclasses | `@dataclass` | Records or freezed |
| Destructuring | `a, b, c = tuple` | `var (a, b, c) = record` |

> **📘 Python Note:** Dart 3.0's pattern matching is similar to Python 3.10+ but more powerful and integrated. Records are like tuples but with better type safety and named fields.

## 📝 Records

Lightweight, immutable data grouping:

```dart
// Positional records
void recordBasics() {
  // Create record
  var record = (1, 'hello', true);
  
  // Access fields
  print(record.$1); // 1
  print(record.$2); // hello
  print(record.$3); // true
  
  // Type annotation
  (int, String, bool) typedRecord = (42, 'world', false);
  
  // Destructuring
  var (number, text, flag) = record;
  print('$number, $text, $flag');
}

// Named records
void namedRecords() {
  // Create named record
  var person = (name: 'Alice', age: 30, email: 'alice@example.com');
  
  // Access by name
  print(person.name);  // Alice
  print(person.age);   // 30
  print(person.email); // alice@example.com
  
  // Type annotation
  ({String name, int age, String email}) typedPerson = person;
  
  // Mixed positional and named
  var mixed = (42, name: 'Bob', 3.14);
  print(mixed.$1);    // 42
  print(mixed.name);  // Bob
  print(mixed.$2);    // 3.14
}

// Records as return values
({int min, int max}) findMinMax(List<int> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError('List cannot be empty');
  }
  return (
    min: numbers.reduce((a, b) => a < b ? a : b),
    max: numbers.reduce((a, b) => a > b ? a : b),
  );
}

void main() {
  var result = findMinMax([3, 1, 4, 1, 5, 9]);
  print('Min: ${result.min}, Max: ${result.max}');
  
  // Destructure return value
  var (min: minimum, max: maximum) = findMinMax([2, 7, 1, 8]);
  print('Min: $minimum, Max: $maximum');
}
```

## 📝 Pattern Matching

Powerful pattern matching in switch and if-case:

```dart
// Switch expressions
String describeNumber(int n) {
  return switch (n) {
    0 => 'zero',
    1 => 'one',
    < 0 => 'negative',
    > 0 && < 10 => 'small positive',
    >= 10 && < 100 => 'medium positive',
    _ => 'large number',
  };
}

// Destructuring patterns
void destructuringPatterns() {
  var point = (x: 10, y: 20);
  
  switch (point) {
    case (x: 0, y: 0):
      print('Origin');
    case (x: 0, y: var y):
      print('On Y axis at $y');
    case (x: var x, y: 0):
      print('On X axis at $x');
    case (x: var x, y: var y) when x == y:
      print('Diagonal at $x');
    case (x: var x, y: var y):
      print('Point at ($x, $y)');
  }
}

// List patterns
void listPatterns() {
  var list = [1, 2, 3, 4, 5];
  
  switch (list) {
    case []:
      print('Empty list');
    case [var single]:
      print('Single element: $single');
    case [var first, var second]:
      print('Two elements: $first, $second');
    case [var first, ...var rest]:
      print('First: $first, Rest: $rest');
    case [var first, ..., var last]:
      print('First: $first, Last: $last');
  }
}

// Map patterns
void mapPatterns() {
  var user = {'name': 'Alice', 'age': 30, 'role': 'admin'};
  
  switch (user) {
    case {'role': 'admin', 'name': var name}:
      print('Admin: $name');
    case {'role': 'user', 'name': var name}:
      print('User: $name');
    case {'name': var name}:
      print('Unknown role for $name');
  }
}

void main() {
  print(describeNumber(5));  // small positive
  print(describeNumber(-3)); // negative
  
  destructuringPatterns();
  listPatterns();
  mapPatterns();
}
```

## 📝 Sealed Classes

Exhaustive type checking for finite subtypes:

```dart
// Sealed class - can only be extended in same library
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}

class Loading<T> extends Result<T> {
  const Loading();
}

// Exhaustive pattern matching
String handleResult<T>(Result<T> result) {
  // Compiler ensures all cases are covered
  return switch (result) {
    Success(data: var d) => 'Success: $d',
    Error(message: var m) => 'Error: $m',
    Loading() => 'Loading...',
    // If you forget a case, compiler error!
  };
}

// Sealed class for state machine
sealed class AuthState {}

class Authenticated extends AuthState {
  final String userId;
  final String token;
  Authenticated(this.userId, this.token);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}

void handleAuth(AuthState state) {
  switch (state) {
    case Authenticated(userId: var id, token: var token):
      print('User $id authenticated');
    case Unauthenticated():
      print('Please log in');
    case AuthError(error: var err):
      print('Auth error: $err');
  }
}
```

## 📝 Class Modifiers

Control how classes can be extended and implemented:

```dart
// base - Can be extended but not implemented
base class Vehicle {
  void move() => print('Moving');
}

class Car extends Vehicle {} // OK
// class Bike implements Vehicle {} // Error!

// interface - Can be implemented but not extended
interface class Drawable {
  void draw() => print('Drawing');
}

class Circle implements Drawable {
  @override
  void draw() => print('Drawing circle');
}
// class Shape extends Drawable {} // Error!

// final - Cannot be extended or implemented
final class Configuration {
  final String apiKey;
  Configuration(this.apiKey);
}

// class MyConfig extends Configuration {} // Error!
// class MyConfig implements Configuration {} // Error!

// sealed - Only extendable in same library
sealed class PaymentMethod {}

class CreditCard extends PaymentMethod {
  final String cardNumber;
  CreditCard(this.cardNumber);
}

class PayPal extends PaymentMethod {
  final String email;
  PayPal(this.email);
}

// mixin class - Can be used as mixin or class
mixin class Logger {
  void log(String message) => print('[LOG] $message');
}

class Service with Logger {} // Use as mixin
class CustomLogger extends Logger {} // Use as class

// abstract - Cannot be instantiated (same as before)
abstract class Shape {
  double area();
}

// abstract final - Abstract and cannot be extended
abstract final class Plugin {
  void initialize();
}
```

## 📝 Advanced Pattern Combinations

```dart
// Combined patterns
void advancedPatterns() {
  var data = {'type': 'user', 'payload': {'name': 'Alice', 'age': 30}};
  
  switch (data) {
    case {
      'type': 'user',
      'payload': {'name': var name, 'age': var age}
    } when age >= 18:
      print('Adult user: $name');
      
    case {
      'type': 'user',
      'payload': {'name': var name, 'age': var age}
    }:
      print('Minor user: $name');
      
    default:
      print('Unknown data type');
  }
}

// Null-check pattern
void nullCheckPattern(String? value) {
  if (value case var v?) {
    print('Has value: $v');
  } else {
    print('Is null');
  }
}

// Type test pattern
void typeTestPattern(Object obj) {
  switch (obj) {
    case int n when n > 0:
      print('Positive integer: $n');
    case String s:
      print('String: $s');
    case List<int> numbers:
      print('List of integers: $numbers');
    default:
      print('Unknown type');
  }
}

// Logical patterns (AND, OR)
void logicalPatterns(int value) {
  switch (value) {
    case < 0 || > 100:
      print('Out of range');
    case >= 0 && <= 100:
      print('In range');
  }
}
```

## 📝 Practical Example: JSON Parsing

```dart
sealed class JsonValue {}

class JsonObject extends JsonValue {
  final Map<String, JsonValue> fields;
  JsonObject(this.fields);
}

class JsonArray extends JsonValue {
  final List<JsonValue> items;
  JsonArray(this.items);
}

class JsonString extends JsonValue {
  final String value;
  JsonString(this.value);
}

class JsonNumber extends JsonValue {
  final num value;
  JsonNumber(this.value);
}

class JsonBool extends JsonValue {
  final bool value;
  JsonBool(this.value);
}

class JsonNull extends JsonValue {}

// Parse with pattern matching
String formatJson(JsonValue value, {int indent = 0}) {
  var spaces = '  ' * indent;
  
  return switch (value) {
    JsonObject(fields: var f) => '{\n${f.entries.map((e) => 
      '$spaces  "${e.key}": ${formatJson(e.value, indent: indent + 1)}'
    ).join(',\n')}\n$spaces}',
    
    JsonArray(items: var items) => '[\n${items.map((item) => 
      '$spaces  ${formatJson(item, indent: indent + 1)}'
    ).join(',\n')}\n$spaces]',
    
    JsonString(value: var s) => '"$s"',
    JsonNumber(value: var n) => '$n',
    JsonBool(value: var b) => '$b',
    JsonNull() => 'null',
  };
}
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **pattern_matching.dart** - Pattern matching exercises
2. **sealed_classes.dart** - Sealed class hierarchies
3. **records_practice.dart** - Working with records

## 📚 Key Takeaways

1. **Records:** Lightweight data grouping with positional and named fields
2. **Pattern Matching:** Powerful destructuring in switch and if-case
3. **Sealed Classes:** Exhaustive type checking for finite hierarchies
4. **Class Modifiers:** Control extension and implementation
5. **Destructuring:** Extract values from records and objects
6. **Switch Expressions:** Return values from switch
7. **Guards:** Add conditions with `when` clauses

## 🔗 Next Steps

After mastering Dart 3.0+ features, move on to:
- **Tutorial 17:** Performance Optimization

---

**Use modern Dart features for safer, more expressive code!** 🎯✨
