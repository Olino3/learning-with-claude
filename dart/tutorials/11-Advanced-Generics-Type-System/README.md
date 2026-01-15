# Tutorial 11: Advanced Generics and Type System

Welcome to your first intermediate Dart tutorial! This guide dives deep into Dart's powerful type system and generics. Understanding advanced generics is essential for writing flexible, reusable code and understanding how Dart's collections and frameworks work.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master generic classes and methods with type parameters
- Understand type bounds and constraints
- Use covariance and contravariance effectively
- Work with generic type inference
- Apply runtime type checking and casting
- Create type-safe APIs and libraries
- Understand when and how to use dynamic types

## 🐍➡️🎯 Coming from Python

Python has type hints and generics (via typing module), but Dart's type system is more powerful and enforced:

| Concept | Python | Dart |
|---------|--------|------|
| Generic class | `class Box[T]:` (3.12+) or `Generic[T]` | `class Box<T>` |
| Type bounds | `TypeVar('T', bound=Animal)` | `class Box<T extends Animal>` |
| Generic method | `def func[T](x: T) -> T:` | `T func<T>(T x)` |
| Type checking | Runtime with `isinstance()` | Compile-time + runtime |
| Variance | Manual annotations | Covariant `out`, contravariant `in` |
| Type erasure | No (types kept at runtime) | Yes (like Java) |

> **📘 Python Note:** Unlike Python's optional type hints, Dart's type system is enforced at compile time. Generics in Dart are more than documentation—they prevent bugs!

## 📝 Generic Classes

### Basic Generic Class

```dart
// Generic Box that can hold any type
class Box<T> {
  T value;
  
  Box(this.value);
  
  T getValue() => value;
  
  void setValue(T newValue) {
    value = newValue;
  }
}

void main() {
  // Type is inferred
  var intBox = Box(42);
  print(intBox.getValue());  // 42
  
  // Explicit type parameter
  var stringBox = Box<String>('Hello');
  print(stringBox.getValue());  // Hello
  
  // Type safety enforced
  // intBox.setValue('text');  // Compile error!
  intBox.setValue(100);  // OK
}
```

> **📘 Python Note:** Similar to Python's `Generic[T]`, but Dart enforces type safety at compile time. No runtime type errors!

### Multiple Type Parameters

```dart
class Pair<K, V> {
  final K key;
  final V value;
  
  Pair(this.key, this.value);
  
  @override
  String toString() => 'Pair($key, $value)';
}

void main() {
  var entry = Pair<String, int>('age', 30);
  print(entry);  // Pair(age, 30)
  
  var coordinate = Pair(10.5, 20.3);  // Type inferred: Pair<double, double>
  print(coordinate);
}
```

## 📝 Type Bounds and Constraints

### Extending a Type

```dart
// Type parameter must extend Comparable
class SortedList<T extends Comparable<T>> {
  final List<T> _items = [];
  
  void add(T item) {
    _items.add(item);
    _items.sort();
  }
  
  List<T> get items => List.unmodifiable(_items);
}

void main() {
  var numbers = SortedList<int>();
  numbers.add(5);
  numbers.add(2);
  numbers.add(8);
  print(numbers.items);  // [2, 5, 8]
  
  var strings = SortedList<String>();
  strings.add('banana');
  strings.add('apple');
  strings.add('cherry');
  print(strings.items);  // [apple, banana, cherry]
  
  // This won't compile - List doesn't implement Comparable
  // var lists = SortedList<List<int>>();  // Error!
}
```

> **📘 Python Note:** Like `TypeVar('T', bound=Comparable)` but enforced at compile time.

### Using Constraints

```dart
abstract class Animal {
  String get name;
  void makeSound();
}

class Dog extends Animal {
  @override
  String name;
  
  Dog(this.name);
  
  @override
  void makeSound() => print('$name: Woof!');
}

class Cat extends Animal {
  @override
  String name;
  
  Cat(this.name);
  
  @override
  void makeSound() => print('$name: Meow!');
}

// Only accepts Animal subtypes
class AnimalShelter<T extends Animal> {
  final List<T> animals = [];
  
  void add(T animal) {
    animals.add(animal);
    print('Added ${animal.name} to shelter');
  }
  
  void makeAllSounds() {
    for (var animal in animals) {
      animal.makeSound();  // Safe because T extends Animal
    }
  }
}

void main() {
  var dogShelter = AnimalShelter<Dog>();
  dogShelter.add(Dog('Buddy'));
  dogShelter.add(Dog('Max'));
  dogShelter.makeAllSounds();
  
  // Can't mix types
  // dogShelter.add(Cat('Whiskers'));  // Compile error!
  
  // Generic shelter can hold any Animal
  var mixedShelter = AnimalShelter<Animal>();
  mixedShelter.add(Dog('Rex'));
  mixedShelter.add(Cat('Mittens'));
  mixedShelter.makeAllSounds();
}
```

## 📝 Generic Methods

### Method-Level Generics

```dart
// Generic function that works with any type
T getFirst<T>(List<T> list) {
  if (list.isEmpty) {
    throw StateError('List is empty');
  }
  return list[0];
}

// Generic method with constraints
T findMax<T extends Comparable<T>>(List<T> items) {
  if (items.isEmpty) {
    throw StateError('List is empty');
  }
  
  T max = items[0];
  for (var item in items) {
    if (item.compareTo(max) > 0) {
      max = item;
    }
  }
  return max;
}

void main() {
  // Type inference
  print(getFirst([1, 2, 3]));        // 1
  print(getFirst(['a', 'b', 'c']));  // a
  
  // Explicit type
  print(getFirst<String>(['hello', 'world']));  // hello
  
  // With constraints
  print(findMax([3, 7, 2, 9, 1]));           // 9
  print(findMax(['banana', 'apple', 'cherry'])); // cherry
}
```

### Generic Methods in Classes

```dart
class Repository<T> {
  final List<T> _items = [];
  
  void add(T item) => _items.add(item);
  
  List<T> get all => List.unmodifiable(_items);
  
  // Generic method with different type parameter
  List<R> map<R>(R Function(T) transform) {
    return _items.map(transform).toList();
  }
  
  // Method with type constraint
  void addAll<S extends T>(List<S> items) {
    _items.addAll(items);
  }
}

void main() {
  var numberRepo = Repository<num>();
  numberRepo.add(42);
  numberRepo.add(3.14);
  
  // Transform to strings
  var strings = numberRepo.map<String>((n) => n.toString());
  print(strings);  // [42, 3.14]
  
  // Add integers (int extends num)
  numberRepo.addAll<int>([1, 2, 3]);
  print(numberRepo.all);  // [42, 3.14, 1, 2, 3]
}
```

## 📝 Variance and Type Safety

### Covariance with `out` (Read-only)

```dart
// Producer - only produces values of T
abstract class Producer<out T> {
  T produce();
  
  // Can't have T in contravariant position (parameter)
  // void consume(T value);  // Would be an error with 'out'
}

class NumberProducer implements Producer<num> {
  @override
  num produce() => 42;
}

void main() {
  // Covariant - can assign Producer<int> to Producer<num>
  Producer<num> producer = NumberProducer();
  print(producer.produce());
}
```

### Contravariance with `in` (Write-only)

```dart
// Consumer - only consumes values of T
abstract class Consumer<in T> {
  void consume(T value);
  
  // Can't have T in covariant position (return type)
  // T produce();  // Would be an error with 'in'
}

class NumberConsumer implements Consumer<num> {
  @override
  void consume(num value) {
    print('Consumed: $value');
  }
}

void main() {
  // Contravariant - can assign Consumer<num> to Consumer<int>
  Consumer<int> consumer = NumberConsumer();
  consumer.consume(42);
}
```

## 📝 Runtime Type Checking

### Type Testing

```dart
void processValue<T>(T value) {
  print('Value: $value');
  print('Type: ${value.runtimeType}');
  
  // Runtime type checks
  if (value is String) {
    print('Length: ${value.length}');
  } else if (value is num) {
    print('Doubled: ${value * 2}');
  } else if (value is List) {
    print('List length: ${value.length}');
  }
}

void main() {
  processValue('Hello');    // String operations
  processValue(42);         // Number operations
  processValue([1, 2, 3]);  // List operations
}
```

### Type Casting

```dart
class Shape {
  void draw() => print('Drawing shape');
}

class Circle extends Shape {
  double radius;
  
  Circle(this.radius);
  
  @override
  void draw() => print('Drawing circle with radius $radius');
  
  double get area => 3.14 * radius * radius;
}

void processShape(Shape shape) {
  shape.draw();
  
  // Safe cast with is check
  if (shape is Circle) {
    print('Area: ${shape.area}');  // Type promoted to Circle
  }
  
  // Unsafe cast with as (throws if wrong type)
  try {
    var circle = shape as Circle;
    print('Radius: ${circle.radius}');
  } catch (e) {
    print('Not a circle: $e');
  }
}

void main() {
  processShape(Circle(5.0));
  processShape(Shape());
}
```

## 📝 Generic Type Aliases

```dart
// Type alias for complex generic types
typedef StringMap<T> = Map<String, T>;
typedef Predicate<T> = bool Function(T);
typedef Transformer<T, R> = R Function(T);

void main() {
  // Using type aliases
  StringMap<int> ages = {'Alice': 30, 'Bob': 25};
  print(ages);
  
  Predicate<int> isEven = (n) => n % 2 == 0;
  print(isEven(4));  // true
  print(isEven(5));  // false
  
  Transformer<int, String> intToString = (n) => n.toString();
  print(intToString(42));  // "42"
}
```

## 📝 Practical Applications

### 1. Generic Repository Pattern

```dart
abstract class Entity {
  int get id;
}

class User implements Entity {
  @override
  final int id;
  final String name;
  
  User(this.id, this.name);
}

class GenericRepository<T extends Entity> {
  final Map<int, T> _storage = {};
  
  void save(T entity) {
    _storage[entity.id] = entity;
  }
  
  T? findById(int id) => _storage[id];
  
  List<T> findAll() => _storage.values.toList();
  
  void delete(int id) {
    _storage.remove(id);
  }
  
  List<T> where(bool Function(T) predicate) {
    return _storage.values.where(predicate).toList();
  }
}

void main() {
  var userRepo = GenericRepository<User>();
  
  userRepo.save(User(1, 'Alice'));
  userRepo.save(User(2, 'Bob'));
  
  print(userRepo.findById(1)?.name);  // Alice
  print(userRepo.findAll().length);    // 2
  
  var filtered = userRepo.where((u) => u.name.startsWith('A'));
  print(filtered[0].name);  // Alice
}
```

### 2. Result Type for Error Handling

```dart
// Generic Result type (like Rust's Result<T, E>)
sealed class Result<T, E> {
  const Result();
}

class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}

// Extension methods for Result
extension ResultExtension<T, E> on Result<T, E> {
  R match<R>({
    required R Function(T) onSuccess,
    required R Function(E) onFailure,
  }) {
    return switch (this) {
      Success(value: final v) => onSuccess(v),
      Failure(error: final e) => onFailure(e),
    };
  }
  
  Result<R, E> map<R>(R Function(T) transform) {
    return match(
      onSuccess: (value) => Success(transform(value)),
      onFailure: (error) => Failure(error),
    );
  }
}

// Example usage
Result<int, String> divide(int a, int b) {
  if (b == 0) {
    return Failure('Division by zero');
  }
  return Success(a ~/ b);
}

void main() {
  var result1 = divide(10, 2);
  result1.match(
    onSuccess: (value) => print('Result: $value'),
    onFailure: (error) => print('Error: $error'),
  );  // Result: 5
  
  var result2 = divide(10, 0);
  result2.match(
    onSuccess: (value) => print('Result: $value'),
    onFailure: (error) => print('Error: $error'),
  );  // Error: Division by zero
  
  // Chain operations
  var doubled = divide(10, 2).map((n) => n * 2);
  print(doubled);  // Success(10)
}
```

## 📝 Advanced Patterns

### Type-Safe Builder Pattern

```dart
class QueryBuilder<T> {
  String? _table;
  List<String> _where = [];
  int? _limit;
  
  QueryBuilder<T> from(String table) {
    _table = table;
    return this;
  }
  
  QueryBuilder<T> where(String condition) {
    _where.add(condition);
    return this;
  }
  
  QueryBuilder<T> limit(int count) {
    _limit = count;
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
    
    if (_limit != null) {
      sql += ' LIMIT $_limit';
    }
    
    return sql;
  }
}

void main() {
  var query = QueryBuilder<User>()
      .from('users')
      .where('age > 18')
      .where('active = true')
      .limit(10)
      .build();
  
  print(query);
  // SELECT * FROM users WHERE age > 18 AND active = true LIMIT 10
}
```

## ✍️ Practice Exercises

See the exercises directory for hands-on practice:

1. `exercises/1-generic-stack.md` - Implement a generic Stack data structure
2. `exercises/2-type-safe-cache.md` - Build a type-safe caching system
3. `exercises/3-generic-validator.md` - Create a generic validation framework

## 📚 What You Learned

✅ Generic classes with type parameters
✅ Type bounds and constraints
✅ Generic methods and functions
✅ Covariance and contravariance
✅ Runtime type checking and casting
✅ Type aliases for complex types
✅ Practical patterns: Repository, Result type, Builder

## 🔜 Next Steps

**Next tutorial: 12-Mixins-Extension-Methods** - Master Dart's powerful mixin system and learn how to add functionality to existing classes with extension methods.

## 💡 Key Takeaways for Python Developers

1. **Compile-time enforcement**: Unlike Python's type hints, Dart enforces types at compile time
2. **Type bounds**: `<T extends Type>` is more powerful than Python's `TypeVar` bounds
3. **Type inference**: Dart infers generic types automatically in most cases
4. **Runtime types**: Use `is` and `as` for runtime type checking
5. **No type erasure worries**: Dart keeps type information at runtime (unlike Java)

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting type bounds
```dart
// Wrong - can't call compareTo without constraint
class Sorter<T> {
  // T max(T a, T b) => a.compareTo(b) > 0 ? a : b;  // Error!
}

// Right - add constraint
class Sorter<T extends Comparable<T>> {
  T max(T a, T b) => a.compareTo(b) > 0 ? a : b;  // OK
}
```

### Pitfall 2: Using dynamic when generics would work
```dart
// Wrong - loses type safety
class Box {
  dynamic value;
  Box(this.value);
}

// Right - use generics
class Box<T> {
  T value;
  Box(this.value);
}
```

### Pitfall 3: Incorrect variance
```dart
// Wrong - trying to use List<Dog> as List<Animal>
void processAnimals(List<Animal> animals) { }

List<Dog> dogs = [Dog('Buddy')];
// processAnimals(dogs);  // Compile error! List is invariant

// Right - use covariant collections or explicit typing
void processAnimals(List<Animal> animals) { }
List<Animal> animals = <Animal>[Dog('Buddy')];
processAnimals(animals);  // OK
```

## 📖 Additional Resources

- [Dart Language Tour: Generics](https://dart.dev/language/generics)
- [Effective Dart: Design](https://dart.dev/effective-dart/design#prefer-using-a-function-type-alias-to-de-duplicate-function-types)
- [Understanding Generic Type Variance](https://dart.dev/language/class-modifiers)

---

Ready to practice? Complete the exercises and master Dart's type system!
