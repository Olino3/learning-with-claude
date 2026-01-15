# Tutorial 14: Extension Methods and Advanced Mixins

Welcome to advanced Dart code organization! This tutorial covers extension methods for adding functionality to existing types, and advanced mixin patterns for powerful code reuse.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Create extension methods on existing types
- Use generic extensions effectively
- Master advanced mixin patterns
- Understand mixin linearization
- Implement trait-like behavior
- Use on-clause for mixin constraints
- Combine extensions and mixins creatively

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Add methods to types | Monkey patching | Extension methods |
| Multiple inheritance | Multiple inheritance | Mixins with `with` |
| Method resolution | MRO (Method Resolution Order) | Mixin linearization |
| Protocol/interface | Duck typing, Protocol | Abstract class, mixin |
| Trait-like behavior | Manual composition | Mixins with `on` clause |

> **📘 Python Note:** Dart's extension methods are safer than Python's monkey patching - they don't modify the original class, just add methods at compile time. Mixins are more constrained than Python's multiple inheritance, avoiding the diamond problem.

## 📝 Extension Methods Basics

Add methods to existing types without modifying them:

```dart
// Extension on String
extension StringExtensions on String {
  // Check if string is email
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  // Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
  
  // Reverse string
  String get reversed {
    return split('').reversed.join('');
  }
  
  // Remove whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }
}

void main() {
  var email = 'user@example.com';
  print(email.isEmail); // true
  
  var name = 'alice';
  print(name.capitalize()); // Alice
  
  var text = 'hello';
  print(text.reversed); // olleh
}
```

## 📝 Generic Extensions

Create extensions that work with any type:

```dart
// Extension on List<T>
extension ListExtensions<T> on List<T> {
  // Get second element safely
  T? get secondOrNull {
    return length >= 2 ? this[1] : null;
  }
  
  // Chunk list into sublists
  List<List<T>> chunk(int size) {
    var chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }
  
  // Get random element
  T random() {
    if (isEmpty) throw StateError('List is empty');
    return this[DateTime.now().millisecond % length];
  }
}

// Extension on Iterable<T>
extension IterableExtensions<T> on Iterable<T> {
  // Group by key
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    var map = <K, List<T>>{};
    for (var element in this) {
      var key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
  
  // Sum with selector
  num sumBy(num Function(T) selector) {
    return fold(0, (sum, element) => sum + selector(element));
  }
}

void main() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8];
  print(numbers.secondOrNull); // 2
  print(numbers.chunk(3)); // [[1, 2, 3], [4, 5, 6], [7, 8]]
  
  var people = [
    {'name': 'Alice', 'age': 30},
    {'name': 'Bob', 'age': 25},
    {'name': 'Charlie', 'age': 30},
  ];
  
  var grouped = people.groupBy((p) => p['age']);
  print(grouped); // {30: [{...}, {...}], 25: [{...}]}
}
```

## 📝 Extension Methods on Nullable Types

Handle nullable types elegantly:

```dart
extension NullableStringExtensions on String? {
  // Safe length
  int get safeLength => this?.length ?? 0;
  
  // Check if null or empty
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  
  // Provide default value
  String orDefault(String defaultValue) => this ?? defaultValue;
}

extension NullableIterableExtensions<T> on Iterable<T>? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  
  Iterable<T> orEmpty() => this ?? [];
}

void main() {
  String? nullString;
  print(nullString.safeLength); // 0
  print(nullString.isNullOrEmpty); // true
  print(nullString.orDefault('default')); // default
  
  List<int>? numbers;
  print(numbers.isNullOrEmpty); // true
  print(numbers.orEmpty()); // []
}
```

## 📝 Advanced Mixin Patterns

### Mixins with Constraints

```dart
// Base class
abstract class Animal {
  String get name;
  void move();
}

// Mixin that requires Animal
mixin Swimmer on Animal {
  void swim() {
    print('$name is swimming');
    move();
  }
  
  double swimSpeed = 5.0;
}

mixin Flyer on Animal {
  void fly() {
    print('$name is flying');
    move();
  }
  
  double flySpeed = 10.0;
}

// Class using mixins
class Duck extends Animal with Swimmer, Flyer {
  @override
  final String name;
  
  Duck(this.name);
  
  @override
  void move() {
    print('$name waddles');
  }
}

void main() {
  var duck = Duck('Donald');
  duck.swim(); // Donald is swimming
  duck.fly();  // Donald is flying
  duck.move(); // Donald waddles
}
```

## 📝 Mixin Linearization

Understanding the order of mixin application:

```dart
mixin A {
  void method() => print('A');
}

mixin B {
  void method() => print('B');
}

mixin C {
  void method() => print('C');
}

// Linearization: MyClass -> C -> B -> A -> Object
class MyClass with A, B, C {
  // Method resolution order: MyClass, C, B, A
}

void main() {
  MyClass().method(); // Prints: C (last mixin wins)
}
```

### Complex Linearization

```dart
mixin Logger {
  void log(String message) {
    print('[LOG] $message');
  }
}

mixin Validator {
  bool validate(String input) {
    log('Validating: $input');
    return input.isNotEmpty;
  }
  
  void log(String message); // Requires log method
}

mixin Serializer {
  String serialize() {
    log('Serializing object');
    return 'serialized';
  }
  
  void log(String message);
}

class DataProcessor with Logger, Validator, Serializer {
  void process(String data) {
    if (validate(data)) {
      var result = serialize();
      log('Processed: $result');
    }
  }
}

void main() {
  var processor = DataProcessor();
  processor.process('test data');
}
```

## 📝 State Machine Mixin Pattern

```dart
abstract class StateMachine<T> {
  T get currentState;
  void transitionTo(T state);
}

mixin StateValidator<T> on StateMachine<T> {
  final Set<T> _validStates = {};
  
  void registerValidState(T state) {
    _validStates.add(state);
  }
  
  bool isValidState(T state) {
    return _validStates.contains(state);
  }
  
  void validateTransition(T state) {
    if (!isValidState(state)) {
      throw StateError('Invalid state: $state');
    }
  }
}

mixin StateLogger<T> on StateMachine<T> {
  final List<T> _history = [];
  
  void logTransition(T from, T to) {
    _history.add(to);
    print('State transition: $from -> $to');
  }
  
  List<T> get history => List.unmodifiable(_history);
}

enum OrderState { pending, processing, shipped, delivered }

class OrderStateMachine extends StateMachine<OrderState> 
    with StateValidator<OrderState>, StateLogger<OrderState> {
  OrderState _state = OrderState.pending;
  
  OrderStateMachine() {
    // Register valid states
    for (var state in OrderState.values) {
      registerValidState(state);
    }
  }
  
  @override
  OrderState get currentState => _state;
  
  @override
  void transitionTo(OrderState state) {
    validateTransition(state);
    var oldState = _state;
    _state = state;
    logTransition(oldState, state);
  }
}

void main() {
  var order = OrderStateMachine();
  order.transitionTo(OrderState.processing);
  order.transitionTo(OrderState.shipped);
  order.transitionTo(OrderState.delivered);
  print('History: ${order.history}');
}
```

## 📝 Builder Pattern with Extensions

```dart
class User {
  final String name;
  final String email;
  final int age;
  final String? phone;
  
  User({
    required this.name,
    required this.email,
    required this.age,
    this.phone,
  });
}

class UserBuilder {
  String? _name;
  String? _email;
  int? _age;
  String? _phone;
  
  UserBuilder setName(String name) {
    _name = name;
    return this;
  }
  
  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }
  
  UserBuilder setAge(int age) {
    _age = age;
    return this;
  }
  
  UserBuilder setPhone(String phone) {
    _phone = phone;
    return this;
  }
  
  User build() {
    if (_name == null || _email == null || _age == null) {
      throw StateError('Missing required fields');
    }
    return User(
      name: _name!,
      email: _email!,
      age: _age!,
      phone: _phone,
    );
  }
}

// Extension to create builder
extension UserExtensions on User {
  static UserBuilder builder() => UserBuilder();
  
  UserBuilder toBuilder() {
    return UserBuilder()
      ..setName(name)
      ..setEmail(email)
      ..setAge(age)
      ..setPhone(phone ?? '');
  }
}

void main() {
  var user = User.builder()
    .setName('Alice')
    .setEmail('alice@example.com')
    .setAge(30)
    .setPhone('555-1234')
    .build();
  
  print('User: ${user.name}, ${user.email}');
}
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **extension_methods.dart** - Create useful extensions
2. **mixin_patterns.dart** - Advanced mixin compositions
3. **extension_challenges.dart** - Complex extension scenarios

## 📚 Key Takeaways

1. **Extensions:** Add methods without modifying original types
2. **Generic Extensions:** Work with any type parameter
3. **Nullable Extensions:** Handle null safely with extensions
4. **Mixin Constraints:** Use `on` clause to require base types
5. **Linearization:** Last mixin in chain wins for conflicts
6. **State Patterns:** Combine mixins for complex behaviors
7. **Builder Pattern:** Extensions make fluent APIs easier

## 🔗 Next Steps

After mastering extensions and mixins, move on to:
- **Tutorial 15:** Code Generation and Annotations
- **Tutorial 16:** Advanced Patterns (Dart 3.0+)

---

**Practice with extensions and mixins to create elegant, reusable code!** 🎯✨
