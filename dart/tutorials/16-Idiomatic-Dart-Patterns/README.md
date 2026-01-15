# Tutorial 16: Idiomatic Dart Patterns and Best Practices

Welcome to the capstone tutorial for intermediate Dart! This guide explores the patterns, idioms, and best practices that make Dart code elegant, maintainable, and truly idiomatic. Master these patterns to write production-ready Dart that feels natural to the language.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master factory patterns and named constructors
- Build fluent APIs with method chaining and cascades
- Apply advanced cascade notation (..) techniques
- Use functional programming patterns effectively
- Implement immutability with final, const, and copyWith
- Follow null safety best practices
- Leverage collection patterns (spread, collection if/for)
- Use pattern matching with switch expressions (Dart 3.0+)
- Apply Effective Dart style guide principles
- Recognize and avoid common anti-patterns

## 🐍➡️🎯 Coming from Python

Python has PEP 8 and idioms, but Dart's patterns are more structured with compile-time enforcement:

| Concept | Python | Dart |
|---------|--------|------|
| Factory method | `@classmethod` decorator | Named constructors |
| Immutability | `@dataclass(frozen=True)` | `final` fields + `const` |
| Fluent API | Return `self` | Return `this` with cascades |
| Comprehensions | `[x*2 for x in items]` | `items.map((x) => x*2)` |
| Pattern matching | `match/case` (3.10+) | `switch` expressions (3.0+) |
| Null handling | `if x is not None:` | `x?.method()` or `x ?? default` |
| Spread | `[*list1, *list2]` | `[...list1, ...list2]` |
| Collection if | `[x for x in items if pred]` | `[for (var x in items) if (pred) x]` |
| Style guide | PEP 8 | Effective Dart |
| Type hints | Optional annotations | Required types (sound null safety) |

> **📘 Python Note:** Dart's patterns are enforced at compile time, catching errors before runtime. Embrace the type system—it's your friend!

## 📝 Factory Patterns and Named Constructors

### Named Constructors

Named constructors are Dart's idiomatic way to provide multiple construction patterns.

```dart
class User {
  final String name;
  final String email;
  final DateTime createdAt;
  final bool isActive;
  
  // Primary constructor
  User(this.name, this.email)
      : createdAt = DateTime.now(),
        isActive = true;
  
  // Named constructor for inactive users
  User.inactive(this.name, this.email)
      : createdAt = DateTime.now(),
        isActive = false;
  
  // Named constructor from JSON
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        createdAt = DateTime.parse(json['createdAt']),
        isActive = json['isActive'] ?? true;
  
  // Named constructor for guest users
  User.guest()
      : name = 'Guest',
        email = 'guest@example.com',
        createdAt = DateTime.now(),
        isActive = true;
  
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
      };
}

void main() {
  var user1 = User('Alice', 'alice@example.com');
  var user2 = User.guest();
  var user3 = User.fromJson({
    'name': 'Bob',
    'email': 'bob@example.com',
    'createdAt': '2024-01-15T10:00:00.000Z'
  });
  
  print('${user1.name} - Active: ${user1.isActive}');
  print('${user2.name} - Active: ${user2.isActive}');
  print('${user3.name} - Created: ${user3.createdAt}');
}
```

> **📘 Python Note:** Unlike Python's `@classmethod`, named constructors are first-class language features. Use them instead of multiple `__init__` methods!

### Factory Constructors

Factory constructors can return cached instances or subclasses.

```dart
// Singleton pattern using factory
class Logger {
  static final Logger _instance = Logger._internal();
  
  // Private constructor
  Logger._internal();
  
  // Factory constructor returns singleton
  factory Logger() {
    return _instance;
  }
  
  void log(String message) {
    print('[LOG] $message');
  }
}

// Factory for subclass selection
abstract class Shape {
  factory Shape(String type) {
    switch (type) {
      case 'circle':
        return Circle();
      case 'square':
        return Square();
      default:
        throw ArgumentError('Unknown shape: $type');
    }
  }
  
  void draw();
}

class Circle implements Shape {
  @override
  void draw() => print('Drawing circle');
}

class Square implements Shape {
  @override
  void draw() => print('Drawing square');
}

void main() {
  // Logger is singleton
  var logger1 = Logger();
  var logger2 = Logger();
  print(identical(logger1, logger2));  // true
  
  // Factory returns correct subclass
  var shape1 = Shape('circle');
  var shape2 = Shape('square');
  shape1.draw();  // Drawing circle
  shape2.draw();  // Drawing square
}
```

### Factory with Cache

```dart
class ExpensiveResource {
  final String id;
  final DateTime _createdAt = DateTime.now();
  
  static final Map<String, ExpensiveResource> _cache = {};
  
  ExpensiveResource._internal(this.id);
  
  // Factory with caching
  factory ExpensiveResource(String id) {
    if (_cache.containsKey(id)) {
      print('Returning cached resource: $id');
      return _cache[id]!;
    }
    
    print('Creating new resource: $id');
    var resource = ExpensiveResource._internal(id);
    _cache[id] = resource;
    return resource;
  }
  
  DateTime get createdAt => _createdAt;
}

void main() {
  var resource1 = ExpensiveResource('db-connection');
  var resource2 = ExpensiveResource('db-connection');
  var resource3 = ExpensiveResource('api-client');
  
  print(identical(resource1, resource2));  // true - same instance
  print(identical(resource1, resource3));  // false - different instance
}
```

## 📝 Builder Pattern with Fluent API

### Basic Builder

```dart
class QueryBuilder {
  String? _table;
  final List<String> _where = [];
  final List<String> _orderBy = [];
  int? _limit;
  int? _offset;
  
  // Fluent methods return 'this'
  QueryBuilder from(String table) {
    _table = table;
    return this;
  }
  
  QueryBuilder where(String condition) {
    _where.add(condition);
    return this;
  }
  
  QueryBuilder orderBy(String field, {bool descending = false}) {
    _orderBy.add(descending ? '$field DESC' : '$field ASC');
    return this;
  }
  
  QueryBuilder limit(int count) {
    _limit = count;
    return this;
  }
  
  QueryBuilder offset(int count) {
    _offset = count;
    return this;
  }
  
  String build() {
    if (_table == null) {
      throw StateError('Table not specified');
    }
    
    var sql = 'SELECT * FROM $_table';
    
    if (_where.isNotEmpty) {
      sql += ' WHERE ${_where.join(' AND ')}';
    }
    
    if (_orderBy.isNotEmpty) {
      sql += ' ORDER BY ${_orderBy.join(', ')}';
    }
    
    if (_limit != null) {
      sql += ' LIMIT $_limit';
    }
    
    if (_offset != null) {
      sql += ' OFFSET $_offset';
    }
    
    return sql;
  }
}

void main() {
  // Fluent API with method chaining
  var query = QueryBuilder()
      .from('users')
      .where('age > 18')
      .where('active = true')
      .orderBy('created_at', descending: true)
      .limit(10)
      .offset(20)
      .build();
  
  print(query);
  // SELECT * FROM users WHERE age > 18 AND active = true 
  // ORDER BY created_at DESC LIMIT 10 OFFSET 20
}
```

> **📘 Python Note:** Similar to method chaining in libraries like pandas, but Dart's type system ensures compile-time safety.

### Type-Safe Builder

```dart
class UserBuilder {
  String? _name;
  String? _email;
  int? _age;
  String? _role;
  
  UserBuilder name(String name) {
    _name = name;
    return this;
  }
  
  UserBuilder email(String email) {
    _email = email;
    return this;
  }
  
  UserBuilder age(int age) {
    _age = age;
    return this;
  }
  
  UserBuilder role(String role) {
    _role = role;
    return this;
  }
  
  User build() {
    if (_name == null || _email == null) {
      throw StateError('Name and email are required');
    }
    return User._builder(
      name: _name!,
      email: _email!,
      age: _age,
      role: _role,
    );
  }
}

class User {
  final String name;
  final String email;
  final int? age;
  final String? role;
  
  User._builder({
    required this.name,
    required this.email,
    this.age,
    this.role,
  });
  
  static UserBuilder builder() => UserBuilder();
  
  @override
  String toString() => 
      'User(name: $name, email: $email, age: $age, role: $role)';
}

void main() {
  var user = User.builder()
      .name('Alice')
      .email('alice@example.com')
      .age(30)
      .role('admin')
      .build();
  
  print(user);
}
```

## 📝 Cascade Notation Advanced Usage

Cascades (`..`) allow chaining operations on the same object without returning `this`.

### Basic Cascades

```dart
class StringBuilder {
  final StringBuffer _buffer = StringBuffer();
  
  void write(String text) => _buffer.write(text);
  void writeln(String text) => _buffer.writeln(text);
  void clear() => _buffer.clear();
  
  @override
  String toString() => _buffer.toString();
}

void main() {
  // Without cascades (verbose)
  var builder1 = StringBuilder();
  builder1.write('Hello');
  builder1.write(' ');
  builder1.writeln('World');
  print(builder1);
  
  // With cascades (idiomatic)
  var builder2 = StringBuilder()
    ..write('Hello')
    ..write(' ')
    ..writeln('World');
  print(builder2);
}
```

### Cascades with Collections

```dart
void main() {
  // List cascade
  var numbers = <int>[]
    ..add(1)
    ..add(2)
    ..addAll([3, 4, 5])
    ..remove(2);
  print(numbers);  // [1, 3, 4, 5]
  
  // Map cascade
  var config = <String, dynamic>{}
    ..['host'] = 'localhost'
    ..['port'] = 8080
    ..['debug'] = true;
  print(config);  // {host: localhost, port: 8080, debug: true}
  
  // Null-aware cascade (?..)
  StringBuilder? nullableBuilder;
  nullableBuilder
    ?..write('This')
    ..write(' won\'t')
    ..write(' execute');  // Nothing happens - nullableBuilder is null
  
  nullableBuilder = StringBuilder()
    ?..write('This')
    ..write(' will')
    ..write(' execute');
  print(nullableBuilder);  // This will execute
}
```

### Nested Cascades

```dart
class Address {
  String? street;
  String? city;
  String? zipCode;
  
  @override
  String toString() => '$street, $city $zipCode';
}

class Person {
  String? name;
  int? age;
  Address? address;
  
  @override
  String toString() => 'Person(name: $name, age: $age, address: $address)';
}

void main() {
  // Nested cascades
  var person = Person()
    ..name = 'Alice'
    ..age = 30
    ..address = (Address()
      ..street = '123 Main St'
      ..city = 'Springfield'
      ..zipCode = '12345');
  
  print(person);
}
```

> **📘 Python Note:** Cascades eliminate the need to return `self` from methods. The `..` operator automatically operates on the original object!

## 📝 Functional Programming Patterns

### Map, Where, Fold

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5];
  
  // Map - transform each element
  // Python: [x * 2 for x in numbers]
  var doubled = numbers.map((x) => x * 2).toList();
  print(doubled);  // [2, 4, 6, 8, 10]
  
  // Where - filter elements
  // Python: [x for x in numbers if x % 2 == 0]
  var evens = numbers.where((x) => x % 2 == 0).toList();
  print(evens);  // [2, 4]
  
  // Fold - reduce to single value
  // Python: functools.reduce(lambda acc, x: acc + x, numbers, 0)
  var sum = numbers.fold(0, (acc, x) => acc + x);
  print(sum);  // 15
  
  // Reduce - like fold but uses first element as initial value
  var product = numbers.reduce((acc, x) => acc * x);
  print(product);  // 120
  
  // Method chaining
  var result = numbers
      .where((x) => x > 2)
      .map((x) => x * x)
      .fold(0, (acc, x) => acc + x);
  print(result);  // 50 (3² + 4² + 5² = 9 + 16 + 25)
}
```

### Every, Any, Expand

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5];
  
  // Every - all elements satisfy predicate
  // Python: all(x > 0 for x in numbers)
  print(numbers.every((x) => x > 0));  // true
  print(numbers.every((x) => x > 3));  // false
  
  // Any - at least one element satisfies predicate
  // Python: any(x > 3 for x in numbers)
  print(numbers.any((x) => x > 3));  // true
  print(numbers.any((x) => x > 10));  // false
  
  // Expand - flatten nested collections
  // Python: [item for sublist in lists for item in sublist]
  var lists = [[1, 2], [3, 4], [5]];
  var flattened = lists.expand((list) => list).toList();
  print(flattened);  // [1, 2, 3, 4, 5]
  
  // Expand with transformation
  var words = ['hello', 'world'];
  var chars = words.expand((word) => word.split('')).toList();
  print(chars);  // [h, e, l, l, o, w, o, r, l, d]
}
```

### Higher-Order Functions

```dart
// Function that returns a function
Function makeMultiplier(int factor) {
  return (int x) => x * factor;
}

// Function that takes a function
List<T> mapList<T>(List<T> items, T Function(T) transform) {
  return items.map(transform).toList();
}

// Compose functions
T Function(T) compose<T>(T Function(T) f, T Function(T) g) {
  return (T x) => f(g(x));
}

void main() {
  var double = makeMultiplier(2);
  var triple = makeMultiplier(3);
  
  print(double(5));  // 10
  print(triple(5));  // 15
  
  var numbers = [1, 2, 3];
  print(mapList(numbers, double));  // [2, 4, 6]
  
  // Composition
  int addOne(int x) => x + 1;
  int square(int x) => x * x;
  
  var addThenSquare = compose(square, addOne);
  print(addThenSquare(3));  // 16 (3 + 1 = 4, 4² = 16)
}
```

> **📘 Python Note:** Dart's functional methods are similar to Python's `map()`, `filter()`, and `functools.reduce()`, but more integrated into the language!

## 📝 Immutability Patterns

### Final vs Const

```dart
void main() {
  // final - runtime constant (can't reassign)
  final time = DateTime.now();
  // time = DateTime.now();  // Error: can't reassign
  
  // const - compile-time constant
  const pi = 3.14159;
  const maxRetries = 3;
  // const time2 = DateTime.now();  // Error: not compile-time constant
  
  // const collections are deeply immutable
  const constList = [1, 2, 3];
  // constList.add(4);  // Error: can't modify
  
  // final collections can be modified
  final finalList = [1, 2, 3];
  finalList.add(4);  // OK
  print(finalList);  // [1, 2, 3, 4]
  
  // Use const for literals when possible
  const config = {
    'host': 'localhost',
    'port': 8080,
  };
}
```

> **📘 Python Note:** Unlike Python's immutable tuples, `const` in Dart guarantees compile-time constants for better performance and memory usage!

### Immutable Classes

```dart
class Point {
  final double x;
  final double y;
  
  const Point(this.x, this.y);
  
  @override
  String toString() => 'Point($x, $y)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && x == other.x && y == other.y;
  
  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  const p1 = Point(1, 2);
  const p2 = Point(1, 2);
  
  print(identical(p1, p2));  // true - same compile-time constant
  print(p1 == p2);           // true - equal values
}
```

### CopyWith Pattern

```dart
class User {
  final String name;
  final String email;
  final int age;
  final bool isActive;
  
  const User({
    required this.name,
    required this.email,
    required this.age,
    this.isActive = true,
  });
  
  // copyWith for immutable updates
  User copyWith({
    String? name,
    String? email,
    int? age,
    bool? isActive,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      isActive: isActive ?? this.isActive,
    );
  }
  
  @override
  String toString() => 
      'User(name: $name, email: $email, age: $age, active: $isActive)';
}

void main() {
  const original = User(
    name: 'Alice',
    email: 'alice@example.com',
    age: 30,
  );
  
  // Create modified copies
  var withNewEmail = original.copyWith(email: 'newalice@example.com');
  var olderUser = original.copyWith(age: 31);
  var inactive = original.copyWith(isActive: false);
  
  print(original);      // original values
  print(withNewEmail);  // only email changed
  print(olderUser);     // only age changed
  print(inactive);      // only isActive changed
}
```

> **📘 Python Note:** Similar to Python's `@dataclass(frozen=True)` with `replace()`, but more flexible with null-aware defaults!

## 📝 Null Safety Best Practices

### Prefer Non-Nullable by Default

```dart
// Good - non-nullable by default
class Good {
  final String name;          // Required, never null
  final String? nickname;     // Optional, can be null
  
  Good(this.name, {this.nickname});
}

// Avoid - everything nullable
class Bad {
  String? name;    // Could be null - requires constant null checks
  String? email;
  
  Bad({this.name, this.email});
}

void main() {
  var good = Good('Alice', nickname: 'Al');
  print(good.name.length);  // No null check needed!
  print(good.nickname?.length);  // Null-aware operator
  
  var bad = Bad(name: 'Bob');
  print(bad.name?.length);  // Always need null checks
}
```

### Null-Aware Operators

```dart
void main() {
  String? nullable;
  
  // ?? - null coalescing
  // Python: x if x is not None else 'default'
  var value1 = nullable ?? 'default';
  print(value1);  // 'default'
  
  // ??= - assign if null
  nullable ??= 'assigned';
  print(nullable);  // 'assigned'
  
  // ?. - null-aware access
  // Python: x.method() if x is not None else None
  print(nullable?.toUpperCase());  // 'ASSIGNED'
  nullable = null;
  print(nullable?.toUpperCase());  // null
  
  // ?.. - null-aware cascade
  StringBuffer? buffer;
  buffer
    ?..write('This')
    ..writeln(' works');  // Nothing happens - buffer is null
  
  // ! - assert non-null (use sparingly!)
  String? dangerous = 'value';
  print(dangerous!.length);  // OK
  dangerous = null;
  // print(dangerous!.length);  // Runtime error!
}
```

### Late Initialization

```dart
class DataService {
  // Late for non-nullable field initialized after construction
  late final String apiKey;
  late final HttpClient client;
  
  DataService() {
    apiKey = _loadApiKey();
    client = HttpClient(apiKey);
  }
  
  String _loadApiKey() => 'sk-1234567890';
}

class HttpClient {
  final String apiKey;
  HttpClient(this.apiKey);
}

// Late with lazy initialization
class ExpensiveService {
  late final ExpensiveObject resource = _createResource();
  
  ExpensiveObject _createResource() {
    print('Creating expensive resource...');
    return ExpensiveObject();
  }
}

class ExpensiveObject {}

void main() {
  print('Creating service...');
  var service = ExpensiveService();
  print('Service created');
  
  print('Accessing resource...');
  var res = service.resource;  // Only now is _createResource called
  print('Resource accessed');
}
```

> **📘 Python Note:** `late` is similar to Python's `@property` with lazy initialization, but enforced by the type system!

## 📝 Collection Patterns

### Spread Operator

```dart
void main() {
  var list1 = [1, 2, 3];
  var list2 = [4, 5, 6];
  
  // Spread operator (...)
  // Python: [*list1, *list2]
  var combined = [...list1, ...list2];
  print(combined);  // [1, 2, 3, 4, 5, 6]
  
  // Insert in middle
  var inserted = [0, ...list1, 99, ...list2];
  print(inserted);  // [0, 1, 2, 3, 99, 4, 5, 6]
  
  // Null-aware spread (...?)
  List<int>? nullableList;
  var safe = [...list1, ...?nullableList, ...list2];
  print(safe);  // [1, 2, 3, 4, 5, 6] - nullableList ignored
  
  // Map spread
  var map1 = {'a': 1, 'b': 2};
  var map2 = {'c': 3, 'd': 4};
  var combinedMap = {...map1, ...map2, 'e': 5};
  print(combinedMap);  // {a: 1, b: 2, c: 3, d: 4, e: 5}
  
  // Set spread
  var set1 = {1, 2, 3};
  var set2 = {3, 4, 5};
  var combinedSet = {...set1, ...set2};
  print(combinedSet);  // {1, 2, 3, 4, 5} - duplicates removed
}
```

### Collection If

```dart
void main() {
  var includeExtras = true;
  
  // Collection if
  var list = [
    1,
    2,
    if (includeExtras) 3,
    if (includeExtras) 4,
  ];
  print(list);  // [1, 2, 3, 4]
  
  includeExtras = false;
  var list2 = [
    1,
    2,
    if (includeExtras) 3,
    if (includeExtras) 4,
  ];
  print(list2);  // [1, 2]
  
  // Collection if-else
  var isPremium = true;
  var features = [
    'basic',
    if (isPremium) 'advanced' else 'trial',
    if (isPremium) 'support',
  ];
  print(features);  // [basic, advanced, support]
}
```

### Collection For

```dart
void main() {
  // Collection for
  var numbers = [1, 2, 3];
  var doubled = [
    for (var n in numbers) n * 2
  ];
  print(doubled);  // [2, 4, 6]
  
  // Python equivalent: [n * 2 for n in numbers]
  
  // Collection for with if
  var evensDoubled = [
    for (var n in numbers)
      if (n % 2 == 0) n * 2
  ];
  print(evensDoubled);  // [4]
  
  // Nested collection for
  var matrix = [
    [1, 2],
    [3, 4],
    [5, 6],
  ];
  
  var flattened = [
    for (var row in matrix)
      for (var item in row)
        item
  ];
  print(flattened);  // [1, 2, 3, 4, 5, 6]
  
  // Map with collection for
  var squares = {
    for (var n in numbers) n: n * n
  };
  print(squares);  // {1: 1, 2: 4, 3: 9}
}
```

> **📘 Python Note:** Dart's collection if/for are similar to Python's comprehensions but can include multiple expressions and conditions!

## 📝 Pattern Matching with Switch Expressions

Dart 3.0+ introduces powerful pattern matching with switch expressions.

### Basic Switch Expressions

```dart
String describeNumber(int n) {
  // Switch expression returns a value
  return switch (n) {
    0 => 'zero',
    1 => 'one',
    2 => 'two',
    _ => 'many',  // _ is the default case
  };
}

String categorizeAge(int age) {
  return switch (age) {
    < 13 => 'child',
    >= 13 && < 20 => 'teenager',
    >= 20 && < 65 => 'adult',
    _ => 'senior',
  };
}

void main() {
  print(describeNumber(0));   // zero
  print(describeNumber(5));   // many
  print(categorizeAge(10));   // child
  print(categorizeAge(16));   // teenager
  print(categorizeAge(30));   // adult
  print(categorizeAge(70));   // senior
}
```

> **📘 Python Note:** Similar to Python 3.10+ `match/case` but more powerful with guard clauses and type patterns!

### Destructuring Patterns

```dart
class Point {
  final double x;
  final double y;
  
  const Point(this.x, this.y);
}

String describePoint(Point p) {
  return switch (p) {
    Point(x: 0, y: 0) => 'origin',
    Point(x: 0, y: _) => 'on y-axis',
    Point(x: _, y: 0) => 'on x-axis',
    Point(x: var x, y: var y) when x == y => 'on diagonal',
    _ => 'somewhere else',
  };
}

// List patterns
String describeList(List<int> list) {
  return switch (list) {
    [] => 'empty',
    [_] => 'one element',
    [var first, var second] => 'two elements: $first and $second',
    [var first, ..., var last] => 'starts with $first, ends with $last',
    _ => 'many elements',
  };
}

void main() {
  print(describePoint(Point(0, 0)));     // origin
  print(describePoint(Point(0, 5)));     // on y-axis
  print(describePoint(Point(3, 3)));     // on diagonal
  print(describePoint(Point(3, 5)));     // somewhere else
  
  print(describeList([]));               // empty
  print(describeList([1]));              // one element
  print(describeList([1, 2]));           // two elements: 1 and 2
  print(describeList([1, 2, 3, 4, 5]));  // starts with 1, ends with 5
}
```

### Sealed Classes with Pattern Matching

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}

String handleResult<T>(Result<T> result) {
  // Compiler ensures all cases are covered
  return switch (result) {
    Success(value: var v) => 'Success: $v',
    Error(message: var m) => 'Error: $m',
  };
}

void main() {
  var success = Success(42);
  var error = Error('Something went wrong');
  
  print(handleResult(success));  // Success: 42
  print(handleResult(error));    // Error: Something went wrong
}
```

## 📝 Effective Dart Style Guide Highlights

### Naming Conventions

```dart
// GOOD
class UserAccount {}              // UpperCamelCase for types
const maxRetries = 3;            // lowerCamelCase for constants
var userName = 'Alice';          // lowerCamelCase for variables
void fetchUserData() {}          // lowerCamelCase for functions
final apiKey = 'secret';         // lowerCamelCase for locals

// Private members start with _
class _InternalHelper {}
void _privateMethod() {}
int _privateField = 0;

// BAD
class user_account {}            // Wrong: use UpperCamelCase
const MAX_RETRIES = 3;           // Wrong: not Python/Java style
var UserName = 'Alice';          // Wrong: use lowerCamelCase
```

### Documentation

```dart
/// Fetches user data from the API.
///
/// Returns a [User] object if successful, throws [NetworkException]
/// if the request fails.
///
/// Example:
/// ```dart
/// var user = await fetchUser(123);
/// print(user.name);
/// ```
Future<User> fetchUser(int id) async {
  throw UnimplementedError();
}

/// A user in the system.
///
/// Users have a [name] and [email] address.
class User {
  /// The user's full name.
  final String name;
  
  /// The user's email address.
  final String email;
  
  User(this.name, this.email);
}
```

### Formatting

```dart
// PREFER trailing commas for better diffs
var list = [
  1,
  2,
  3,  // Trailing comma
];

var user = User(
  'Alice',
  'alice@example.com',  // Trailing comma
);

// PREFER const where possible
const list1 = [1, 2, 3];              // GOOD
final list2 = const [1, 2, 3];        // OK but redundant
final list3 = [1, 2, 3];              // AVOID if immutable

// PREFER => for simple one-line functions
int square(int x) => x * x;           // GOOD
int cube(int x) {                     // Use blocks for complex logic
  return x * x * x;
}

// AVOID unnecessary getters/setters
class Good {
  String name;  // Simple public field
  Good(this.name);
}

class Bad {
  String _name;
  String get name => _name;  // Unnecessary
  set name(String value) => _name = value;
  Bad(this._name);
}
```

### Prefer Expression Bodies

```dart
// GOOD - use => for simple getters
class User {
  final String firstName;
  final String lastName;
  
  User(this.firstName, this.lastName);
  
  String get fullName => '$firstName $lastName';
  bool get hasLongName => fullName.length > 20;
}

// AVOID - unnecessarily verbose
class Verbose {
  final String firstName;
  final String lastName;
  
  Verbose(this.firstName, this.lastName);
  
  String get fullName {
    return '$firstName $lastName';  // Unnecessary block
  }
}
```

### Type Annotations

```dart
// PREFER type annotations on public APIs
class Good {
  // Public members: always annotate
  int calculate(String input, {bool verbose = false}) {
    // Local variables: let inference work
    var result = int.parse(input);
    var doubled = result * 2;
    return doubled;
  }
}

// AVOID over-annotation
class TooVerbose {
  int calculate(String input) {
    int parsed = int.parse(input);     // Redundant type
    int doubled = parsed * 2;          // Redundant type
    return doubled;
  }
}

// GOOD - inference works well for locals
void example() {
  var numbers = [1, 2, 3];            // Inferred as List<int>
  var doubled = numbers.map((x) => x * 2);  // Inferred
}
```

> **📘 Python Note:** Unlike Python's optional type hints, Dart requires types on public APIs but allows inference for local variables!

## 📝 Common Anti-Patterns to Avoid

### Anti-Pattern 1: Overusing Dynamic

```dart
// BAD - loses type safety
dynamic processData(dynamic input) {
  return input.toString().toUpperCase();  // No compile-time checks!
}

// GOOD - use generics or specific types
String processData(Object input) {
  return input.toString().toUpperCase();
}

// Or with generics
T identity<T>(T value) => value;
```

### Anti-Pattern 2: Ignoring Null Safety

```dart
// BAD - using ! everywhere
class Bad {
  String? name;
  
  void greet() {
    print('Hello, ${name!}');  // Risky!
  }
}

// GOOD - handle null properly
class Good {
  String? name;
  
  void greet() {
    var n = name;
    if (n != null) {
      print('Hello, $n');
    } else {
      print('Hello, guest');
    }
    
    // Or use ??
    print('Hello, ${name ?? 'guest'}');
  }
}
```

### Anti-Pattern 3: Not Using Named Parameters

```dart
// BAD - unclear what parameters mean
class Bad {
  void createUser(String name, String email, bool active, int age, String role) {
    // Implementation
  }
}

void badExample() {
  var bad = Bad();
  bad.createUser('Alice', 'alice@example.com', true, 30, 'admin');  // Confusing!
}

// GOOD - named parameters for clarity
class Good {
  void createUser({
    required String name,
    required String email,
    bool active = true,
    required int age,
    String role = 'user',
  }) {
    // Implementation
  }
}

void goodExample() {
  var good = Good();
  good.createUser(
    name: 'Alice',
    email: 'alice@example.com',
    age: 30,
    role: 'admin',
  );  // Clear!
}
```

### Anti-Pattern 4: Mutable Global State

```dart
// BAD - mutable globals
String currentUser = 'Alice';
int requestCount = 0;

void badIncrement() {
  requestCount++;  // Hard to test, unpredictable
}

// GOOD - encapsulate state
class UserSession {
  String _currentUser = 'Alice';
  int _requestCount = 0;
  
  String get currentUser => _currentUser;
  int get requestCount => _requestCount;
  
  void incrementRequests() {
    _requestCount++;
  }
  
  void setUser(String user) {
    _currentUser = user;
  }
}
```

### Anti-Pattern 5: Catching and Ignoring Errors

```dart
// BAD - silent failures
Future<void> bad() async {
  try {
    await riskyOperation();
  } catch (e) {
    // Silent failure - error lost!
  }
}

Future<void> riskyOperation() async {}

// GOOD - handle or rethrow
Future<void> good() async {
  try {
    await riskyOperation();
  } on Exception catch (e) {
    // Handle specific errors
    print('Error: $e');
    rethrow;  // Or handle appropriately
  }
}
```

### Anti-Pattern 6: Not Using Collections Idiomatically

```dart
// BAD - manual iteration
List<int> bad(List<int> numbers) {
  var result = <int>[];
  for (var i = 0; i < numbers.length; i++) {
    if (numbers[i] % 2 == 0) {
      result.add(numbers[i] * 2);
    }
  }
  return result;
}

// GOOD - functional approach
List<int> good(List<int> numbers) {
  return numbers
      .where((n) => n % 2 == 0)
      .map((n) => n * 2)
      .toList();
}
```

## 📝 Practical Applications

### API Client with Idiomatic Patterns

```dart
sealed class ApiResult<T> {}
class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  ApiSuccess(this.data);
}
class ApiError<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  ApiError(this.message, {this.statusCode});
}

class ApiRequest {
  final String method;
  final String path;
  final Map<String, String> headers;
  final Map<String, dynamic>? body;
  final Duration timeout;
  
  const ApiRequest({
    required this.method,
    required this.path,
    this.headers = const {},
    this.body,
    this.timeout = const Duration(seconds: 30),
  });
  
  ApiRequest copyWith({
    String? method,
    String? path,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration? timeout,
  }) {
    return ApiRequest(
      method: method ?? this.method,
      path: path ?? this.path,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      timeout: timeout ?? this.timeout,
    );
  }
}

class ApiClient {
  final String baseUrl;
  final Map<String, String> _defaultHeaders;
  
  ApiClient(this.baseUrl, {Map<String, String>? defaultHeaders})
      : _defaultHeaders = defaultHeaders ?? {};
  
  RequestBuilder get(String path) => RequestBuilder._(this, 'GET', path);
  RequestBuilder post(String path) => RequestBuilder._(this, 'POST', path);
  
  Future<ApiResult<Map<String, dynamic>>> _execute(ApiRequest request) async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      return ApiSuccess({'status': 'ok', 'path': request.path});
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}

class RequestBuilder {
  final ApiClient _client;
  final String _method;
  final String _path;
  final Map<String, String> _headers = {};
  Map<String, dynamic>? _body;
  Duration _timeout = Duration(seconds: 30);
  
  RequestBuilder._(this._client, this._method, this._path);
  
  RequestBuilder header(String key, String value) {
    _headers[key] = value;
    return this;
  }
  
  RequestBuilder body(Map<String, dynamic> body) {
    _body = body;
    return this;
  }
  
  RequestBuilder timeout(Duration duration) {
    _timeout = duration;
    return this;
  }
  
  Future<ApiResult<Map<String, dynamic>>> send() {
    var request = ApiRequest(
      method: _method,
      path: _path,
      headers: {..._client._defaultHeaders, ..._headers},
      body: _body,
      timeout: _timeout,
    );
    
    return _client._execute(request);
  }
}

void main() async {
  var client = ApiClient(
    'https://api.example.com',
    defaultHeaders: {'User-Agent': 'DartClient/1.0'},
  );
  
  var result = await client
      .post('/users')
      .header('Content-Type', 'application/json')
      .body({'name': 'Alice', 'email': 'alice@example.com'})
      .timeout(Duration(seconds: 10))
      .send();
  
  switch (result) {
    case ApiSuccess(data: var data):
      print('Success: $data');
    case ApiError(message: var msg, statusCode: var code):
      print('Error ($code): $msg');
  }
}
```

## ✍️ Practice Exercises

See the exercises directory for hands-on practice:

1. `exercises/1-factory-patterns.md` - Implement factory patterns and named constructors
2. `exercises/2-builder-pattern.md` - Build a fluent API for query construction
3. `exercises/3-immutability.md` - Create immutable data structures with copyWith
4. `exercises/4-functional-patterns.md` - Apply map, fold, and higher-order functions
5. `exercises/5-pattern-matching.md` - Use switch expressions and destructuring
6. `exercises/6-idiomatic-refactoring.md` - Refactor code to be more idiomatic

## 📚 What You Learned

✅ Factory patterns and named constructors for flexible object creation
✅ Builder pattern with fluent APIs for readable configuration
✅ Advanced cascade notation for concise object manipulation
✅ Functional programming with map, fold, reduce, and higher-order functions
✅ Immutability patterns with final, const, and copyWith
✅ Null safety best practices and operators
✅ Collection patterns including spread, collection if/for
✅ Pattern matching with switch expressions and destructuring
✅ Effective Dart style guide principles
✅ Common anti-patterns and how to avoid them
✅ Building production-ready, idiomatic Dart code

## 🔜 Next Steps

Congratulations on completing the intermediate Dart tutorials! You're now ready to:

1. **Build Complete Applications**: Apply these patterns in real projects
2. **Explore Advanced Topics**:
   - State management (BLoC, Riverpod, Provider)
   - Dependency injection patterns
   - Reactive programming with Streams
   - Performance optimization techniques
3. **Contribute to Open Source**: Read and contribute to Dart packages on pub.dev
4. **Flutter Development**: Apply Dart patterns in Flutter apps
5. **Backend Development**: Build APIs with Shelf, Dart Frog, or Serverpod
6. **Code Reviews**: Practice identifying patterns and anti-patterns

## 💡 Key Takeaways for Python Developers

1. **Named constructors**: More powerful than Python's `@classmethod` - use them liberally
2. **Factory pattern**: Idiomatic way to control object creation and implement singletons
3. **Cascades**: Eliminate repetition without needing `self` - embrace `..` notation
4. **Immutability**: `const` and `final` are enforced unlike Python's naming conventions
5. **Null safety**: Sound null safety catches errors at compile time vs Python's runtime
6. **Collections**: Similar to comprehensions but with spread, collection if/for syntax
7. **Pattern matching**: Like Python 3.10+ match/case but more powerful
8. **Type system**: Not optional like mypy - embrace it for safety and refactoring
9. **Effective Dart**: Follow the official style guide - consistency matters
10. **Functional patterns**: map/fold/reduce are idiomatic - use them instead of loops

## 🆘 Common Pitfalls

### Pitfall 1: Not Using Named Constructors

```dart
// Wrong - constructors with boolean flags
class User {
  final bool isGuest;
  final String? name;
  
  User(this.isGuest, [this.name]);
}

void bad() {
  var user1 = User(false, 'Alice');
  var user2 = User(true);  // Confusing
}

// Right - named constructors
class BetterUser {
  final String name;
  
  BetterUser(this.name);
  BetterUser.guest() : name = 'Guest';
}

void good() {
  var user1 = BetterUser('Alice');
  var user2 = BetterUser.guest();  // Clear intent
}
```

### Pitfall 2: Overusing Cascades

```dart
// Wrong - cascades obscuring logic
void bad() {
  var list = <int>[]
    ..add(1)
    ..add(2)
    ..sort()
    ..removeAt(0)
    ..add(3);  // Hard to follow
}

// Right - clear steps
void good() {
  var list = <int>[];
  list.addAll([1, 2]);
  list.sort();
  list.removeAt(0);
  list.add(3);
}
```

### Pitfall 3: Not Leveraging Type Inference

```dart
// Wrong - over-annotated
void bad() {
  List<int> numbers = <int>[1, 2, 3];
  Map<String, dynamic> data = <String, dynamic>{'key': 'value'};
  String name = 'Alice';
}

// Right - let inference work
void good() {
  var numbers = [1, 2, 3];  // Inferred as List<int>
  var data = {'key': 'value'};  // Inferred as Map<String, String>
  var name = 'Alice';  // Inferred as String
}
```

### Pitfall 4: Using Null Instead of Optional Pattern

```dart
// Wrong - null for missing values
class Bad {
  String? findUser(int id) {
    return null;  // Ambiguous - not found or error?
  }
}

// Right - explicit Result type
sealed class Result<T> {}
class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}
class Error<T> extends Result<T> {
  final String message;
  Error(this.message);
}

class Good {
  Result<String> findUser(int id) {
    return Error('User not found');  // Clear meaning
  }
}
```

### Pitfall 5: Not Using Collection Literals

```dart
// Wrong - verbose constructors
void bad() {
  var list = List<int>.empty(growable: true);
  list.add(1);
  
  var map = Map<String, int>();
  map['key'] = 1;
}

// Right - collection literals
void good() {
  var list = [1];
  var map = {'key': 1};
}
```

### Pitfall 6: Returning Null from Getters

```dart
// Wrong - nullable getter that could fail
class Bad {
  int? _value;
  
  int? get value => _value;  // Could be null
}

// Right - non-null with default or throw
class Good {
  int? _value;
  
  int get value => _value ?? 0;  // Provide default
  
  // Or throw if truly required
  int get requiredValue {
    if (_value == null) {
      throw StateError('Value not initialized');
    }
    return _value!;
  }
}
```

### Pitfall 7: Not Using Extension Methods

```dart
// Wrong - utility functions everywhere
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

void bad() {
  print(capitalize('hello'));
}

// Right - extension methods
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

void good() {
  print('hello'.capitalize());  // More intuitive
}
```

### Pitfall 8: Ignoring Const Constructors

```dart
// Wrong - runtime allocation for constants
class Bad {
  final int x;
  final int y;
  
  Bad(this.x, this.y);  // Non-const
}

void bad() {
  var p1 = Bad(1, 2);  // New allocation
  var p2 = Bad(1, 2);  // Another allocation
}

// Right - const constructor when possible
class Good {
  final int x;
  final int y;
  
  const Good(this.x, this.y);  // Const constructor
}

void good() {
  const p1 = Good(1, 2);  // Compile-time constant
  const p2 = Good(1, 2);  // Same object as p1
  print(identical(p1, p2));  // true
}
```

## 📖 Additional Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Dart API Design](https://dart.dev/guides/language/effective-dart/design)
- [Dart Patterns](https://dart.dev/language/patterns)
- [Null Safety](https://dart.dev/null-safety)
- [Collections](https://dart.dev/guides/libraries/library-tour#collections)
- [pub.dev](https://pub.dev) - Explore idiomatic Dart packages
- [Dart Language Specification](https://dart.dev/guides/language/spec)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets) - See patterns in practice

---

Congratulations! You've mastered idiomatic Dart patterns and best practices. You're now equipped to write production-ready, maintainable Dart code that feels natural to the language. Go build amazing things! 🎯🚀
