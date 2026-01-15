# Tutorial 12: Mixins and Extension Methods

Welcome to Tutorial 12! Learn how to compose behavior with mixins and add functionality to existing classes with extension methods - two of Dart's most powerful features for code reuse.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master mixin composition and the `with` keyword
- Understand mixin constraints with `on`
- Create extension methods to add functionality to existing types
- Use generic extensions
- Apply the mixin pattern for code reuse
- Combine mixins in the right order
- Understand extension member resolution

## 🐍➡️🎯 Coming from Python

Python has multiple inheritance, but Dart's mixins are cleaner and more predictable:

| Concept | Python | Dart |
|---------|--------|------|
| Multiple "inheritance" | Multiple base classes | Mixins with `with` |
| Method resolution | MRO (complex) | Right-to-left, predictable |
| Adding methods | Monkey patching | Extension methods |
| Composition | Mix of inheritance/composition | Mixins + interfaces |
| Constraints | No built-in support | `on` keyword |
| Name conflicts | MRO determines winner | Rightmost mixin wins |

> **📘 Python Note:** Dart mixins are like Python's multiple inheritance but more restricted and predictable. Extension methods are safer than monkey patching!

## 📝 Basic Mixins

### Creating and Using Mixins

```dart
// Define a mixin
mixin Flyable {
  void fly() {
    print('Flying through the air!');
  }
  
  int get altitude => 1000;
}

mixin Swimmable {
  void swim() {
    print('Swimming in the water!');
  }
  
  int get depth => 50;
}

// Use mixins with 'with' keyword
class Duck with Flyable, Swimmable {
  String name;
  
  Duck(this.name);
  
  void quack() {
    print('$name says: Quack!');
  }
}

void main() {
  var duck = Duck('Donald');
  duck.quack();    // Duck method
  duck.fly();      // From Flyable
  duck.swim();     // From Swimmable
  
  print('Altitude: ${duck.altitude}');
  print('Depth: ${duck.depth}');
}
```

> **📘 Python Note:** This is cleaner than Python's multiple inheritance. No confusing MRO to worry about!

### Mixin Order Matters

```dart
mixin A {
  String getMessage() => 'A';
}

mixin B {
  String getMessage() => 'B';
}

// Rightmost mixin wins
class MyClass1 with A, B {}
class MyClass2 with B, A {}

void main() {
  print(MyClass1().getMessage());  // B (rightmost)
  print(MyClass2().getMessage());  // A (rightmost)
}
```

## 📝 Mixin Constraints

### Using `on` to Require a Superclass

```dart
class Animal {
  String name;
  int energy = 100;
  
  Animal(this.name);
  
  void consume(int amount) {
    energy -= amount;
    if (energy < 0) energy = 0;
  }
}

// Mixin that requires Animal as base
mixin Runner on Animal {
  void run() {
    print('$name is running');
    consume(10);
    print('Energy remaining: $energy');
  }
  
  double get speed => energy / 10.0;
}

mixin Jumper on Animal {
  void jump() {
    print('$name jumps!');
    consume(15);
    print('Energy remaining: $energy');
  }
  
  int get jumpHeight => energy ~/ 20;
}

class Dog extends Animal with Runner, Jumper {
  Dog(super.name);
  
  void bark() {
    print('$name: Woof!');
  }
}

void main() {
  var dog = Dog('Max');
  dog.bark();
  dog.run();    // From Runner mixin
  dog.jump();   // From Jumper mixin
  
  print('Speed: ${dog.speed}');
  print('Jump height: ${dog.jumpHeight}');
}
```

> **📘 Python Note:** The `on` keyword ensures the mixin can only be used with specific base classes - Python doesn't have this guarantee!

### Multiple Constraints

```dart
abstract class Drawable {
  void draw();
}

abstract class Clickable {
  void onClick();
}

// Mixin with multiple constraints
mixin Hoverable on Drawable, Clickable {
  bool _isHovered = false;
  
  void onHover() {
    _isHovered = true;
    print('Hovered!');
    draw();  // Can call Drawable methods
  }
  
  void onLeave() {
    _isHovered = false;
    print('Left');
  }
  
  bool get isHovered => _isHovered;
}

class Button extends Drawable with Clickable, Hoverable {
  String label;
  
  Button(this.label);
  
  @override
  void draw() {
    print('Drawing button: $label');
  }
  
  @override
  void onClick() {
    print('Button $label clicked');
  }
}

void main() {
  var button = Button('Submit');
  button.draw();
  button.onHover();
  button.onClick();
  button.onLeave();
}
```

## 📝 Extension Methods

### Basic Extensions

```dart
// Extend existing types
extension StringExtensions on String {
  // Add custom methods
  String get reversed => split('').reversed.join('');
  
  bool get isEmail => contains('@') && contains('.');
  
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

void main() {
  var text = 'hello world';
  print(text.reversed);       // dlrow olleh
  print(text.capitalize());   // Hello world
  print(text.truncate(5));    // hello...
  
  var email = 'test@example.com';
  print(email.isEmail);       // true
}
```

> **📘 Python Note:** This is safer than monkey patching in Python. Extensions don't actually modify the original class!

### Extensions on Collections

```dart
extension IterableExtensions<T> on Iterable<T> {
  // Find duplicates
  List<T> get duplicates {
    var seen = <T>{};
    var dups = <T>{};
    
    for (var item in this) {
      if (seen.contains(item)) {
        dups.add(item);
      } else {
        seen.add(item);
      }
    }
    
    return dups.toList();
  }
  
  // Group by a key
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    var map = <K, List<T>>{};
    
    for (var item in this) {
      var key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    
    return map;
  }
  
  // Safe first and last
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
}

void main() {
  var numbers = [1, 2, 3, 2, 4, 3];
  print(numbers.duplicates);  // [2, 3]
  
  var words = ['apple', 'banana', 'avocado', 'berry'];
  var grouped = words.groupBy((w) => w[0]);
  print(grouped);  // {a: [apple, avocado], b: [banana, berry]}
  
  var empty = <int>[];
  print(empty.firstOrNull);  // null
}
```

### Named Extensions

```dart
// Named extension for specificity
extension NumberParsing on String {
  int? toIntOrNull() => int.tryParse(this);
  double? toDoubleOrNull() => double.tryParse(this);
}

extension MathOperations on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;
  
  int get factorial {
    if (this < 0) throw ArgumentError('Negative numbers not allowed');
    if (this == 0 || this == 1) return 1;
    return this * (this - 1).factorial;
  }
  
  List<int> get digits {
    return toString().split('').map((d) => int.parse(d)).toList();
  }
}

void main() {
  // String parsing
  print('42'.toIntOrNull());      // 42
  print('3.14'.toDoubleOrNull()); // 3.14
  print('abc'.toIntOrNull());     // null
  
  // Number operations
  print(5.factorial);   // 120
  print(6.isEven);      // true
  print(123.digits);    // [1, 2, 3]
}
```

## 📝 Generic Extensions

```dart
extension ListExtensions<T> on List<T> {
  // Safely get element at index
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
  
  // Swap two elements
  void swap(int i, int j) {
    if (i < 0 || i >= length || j < 0 || j >= length) {
      throw RangeError('Index out of bounds');
    }
    var temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }
  
  // Split into chunks
  List<List<T>> chunk(int size) {
    var chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      var end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  // Invert map (value becomes key)
  Map<V, K> get inverted {
    return map((k, v) => MapEntry(v, k));
  }
  
  // Filter map
  Map<K, V> where(bool Function(K key, V value) test) {
    return Map.fromEntries(
      entries.where((e) => test(e.key, e.value))
    );
  }
}

void main() {
  // List extensions
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  print(numbers.elementAtOrNull(10));  // null
  print(numbers.chunk(3));  // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  
  var mutable = [1, 2, 3];
  mutable.swap(0, 2);
  print(mutable);  // [3, 2, 1]
  
  // Map extensions
  var map = {'a': 1, 'b': 2, 'c': 3};
  print(map.inverted);  // {1: a, 2: b, 3: c}
  
  var filtered = map.where((k, v) => v > 1);
  print(filtered);  // {b: 2, c: 3}
}
```

## 📝 Practical Applications

### 1. Timestamp Mixin

```dart
mixin Timestamps {
  DateTime? createdAt;
  DateTime? updatedAt;
  
  void markCreated() {
    createdAt = DateTime.now();
    updatedAt = createdAt;
  }
  
  void markUpdated() {
    updatedAt = DateTime.now();
  }
  
  Duration? get age {
    if (createdAt == null) return null;
    return DateTime.now().difference(createdAt!);
  }
}

class User with Timestamps {
  String name;
  String email;
  
  User(this.name, this.email) {
    markCreated();
  }
  
  void updateEmail(String newEmail) {
    email = newEmail;
    markUpdated();
  }
}

void main() async {
  var user = User('Alice', 'alice@example.com');
  print('Created at: ${user.createdAt}');
  
  await Future.delayed(Duration(seconds: 2));
  user.updateEmail('newalice@example.com');
  
  print('Updated at: ${user.updatedAt}');
  print('Age: ${user.age?.inSeconds} seconds');
}
```

### 2. Validation Extensions

```dart
extension EmailValidation on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(this);
  }
}

extension PhoneValidation on String {
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(this);
  }
  
  String get formattedPhone {
    var digits = replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return this;
  }
}

void main() {
  print('alice@test.com'.isValidEmail);    // true
  print('invalid-email'.isValidEmail);     // false
  
  print('1234567890'.isValidPhone);        // true
  print('1234567890'.formattedPhone);      // (123) 456-7890
}
```

### 3. Logging Mixin

```dart
mixin Logger {
  String get loggerName => runtimeType.toString();
  
  void log(String message, {String level = 'INFO'}) {
    print('[$level] [$loggerName] $message');
  }
  
  void debug(String message) => log(message, level: 'DEBUG');
  void info(String message) => log(message, level: 'INFO');
  void warning(String message) => log(message, level: 'WARNING');
  void error(String message) => log(message, level: 'ERROR');
}

class DatabaseService with Logger {
  void connect() {
    info('Connecting to database...');
    // Connection logic
    info('Connected successfully');
  }
  
  void query(String sql) {
    debug('Executing query: $sql');
    // Query logic
  }
  
  void handleError(Exception e) {
    error('Database error: $e');
  }
}

void main() {
  var db = DatabaseService();
  db.connect();
  db.query('SELECT * FROM users');
  db.handleError(Exception('Connection lost'));
}
```

## 📝 Advanced Patterns

### Extension with Type Bounds

```dart
extension ComparableExtensions<T extends Comparable<T>> on T {
  bool isBetween(T lower, T upper) {
    return compareTo(lower) >= 0 && compareTo(upper) <= 0;
  }
  
  T clamp(T lower, T upper) {
    if (compareTo(lower) < 0) return lower;
    if (compareTo(upper) > 0) return upper;
    return this;
  }
}

void main() {
  print(5.isBetween(1, 10));        // true
  print(15.clamp(0, 10));           // 10
  print('m'.isBetween('a', 'z'));   // true
}
```

### Chaining Mixins

```dart
mixin Serializable {
  Map<String, dynamic> toJson();
  
  String toJsonString() {
    return toJson().toString();
  }
}

mixin Identifiable {
  String get id;
}

mixin Auditable {
  DateTime get createdAt;
  DateTime get modifiedAt;
}

class Product with Serializable, Identifiable, Auditable {
  @override
  String id;
  
  String name;
  double price;
  
  @override
  DateTime createdAt;
  
  @override
  DateTime modifiedAt;
  
  Product(this.id, this.name, this.price)
      : createdAt = DateTime.now(),
        modifiedAt = DateTime.now();
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }
}

void main() {
  var product = Product('p1', 'Laptop', 999.99);
  print(product.id);
  print(product.toJsonString());
}
```

## ✍️ Practice Exercises

See the exercises directory for hands-on practice:

1. `exercises/1-json-mixin.md` - Create a JSON serialization mixin
2. `exercises/2-collection-extensions.md` - Build useful collection extensions
3. `exercises/3-state-machine-mixin.md` - Implement a state machine with mixins

## 📚 What You Learned

✅ Creating and using mixins with `with`
✅ Mixin constraints with `on`
✅ Extension methods for adding functionality
✅ Generic extensions
✅ Mixin ordering and resolution
✅ Practical patterns with mixins and extensions

## 🔜 Next Steps

**Next tutorial: 13-Advanced-Async-Patterns** - Master advanced asynchronous programming with StreamControllers, custom streams, and Isolates.

## 💡 Key Takeaways for Python Developers

1. **Mixins over multiple inheritance**: Cleaner and more predictable than Python's MRO
2. **Extension methods**: Safer than monkey patching - doesn't modify original class
3. **Type-safe composition**: Mixins work perfectly with Dart's type system
4. **Order matters**: Rightmost mixin wins in conflicts
5. **Constraints**: `on` keyword ensures mixins used correctly

## 🆘 Common Pitfalls

### Pitfall 1: Wrong mixin order
```dart
mixin A { void method() => print('A'); }
mixin B { void method() => print('B'); }

// Wrong - B's method is used, not A's
class MyClass with A, B {}  // Calls B.method()

// Right - be explicit about order
class MyClass with B, A {}  // Calls A.method()
```

### Pitfall 2: Forgetting mixin constraints
```dart
// Wrong - Runner requires Animal
// class Cat with Runner {}  // Error!

// Right - extend Animal first
class Cat extends Animal with Runner {}
```

### Pitfall 3: Extension method conflicts
```dart
// If two extensions define same method, must be explicit
extension Ext1 on String { int get value => 1; }
extension Ext2 on String { int get value => 2; }

// Use explicit extension syntax
print(Ext1('test').value);  // 1
print(Ext2('test').value);  // 2
```

## 📖 Additional Resources

- [Dart Language Tour: Mixins](https://dart.dev/language/mixins)
- [Dart Language Tour: Extension Methods](https://dart.dev/language/extension-methods)
- [Effective Dart: Using Mixins](https://dart.dev/effective-dart/design#prefer-mixins-to-express-that-a-class-adds-a-capability)

---

Ready to practice? Complete the exercises and master mixins and extensions!
