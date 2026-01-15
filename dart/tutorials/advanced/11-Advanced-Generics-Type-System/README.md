# Tutorial 11: Advanced Generics and Type System

Welcome to advanced Dart! This tutorial explores Dart's sophisticated type system, covering bounded generics, covariance/contravariance, type inference, and advanced generic patterns.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master bounded type parameters with `extends`
- Understand covariance and contravariance in Dart
- Use generic constraints effectively
- Implement generic factory patterns
- Understand type promotion and flow analysis
- Work with generic type aliases
- Use `dynamic`, `Object`, and `Object?` appropriately

## 🐍➡️🎯 Coming from Python

Python has generics through typing hints, but Dart's type system is enforced at compile time:

| Concept | Python | Dart |
|---------|--------|------|
| Generic class | `class Stack[T]:` | `class Stack<T> {` |
| Type bounds | `TypeVar('T', bound=Number)` | `<T extends Number>` |
| Runtime type check | `isinstance(x, List)` | `x is List<int>` |
| Type variance | Implicit (duck typing) | Explicit (generics) |
| Type aliases | `type Point = tuple[int, int]` | `typedef Point = (int, int);` |
| Type erasure | No (runtime types preserved) | Yes (generics erased at runtime) |

> **📘 Python Note:** Unlike Python's gradual typing, Dart's generics are checked at compile time and mostly erased at runtime (except for reified generics). Type safety is much stronger in Dart.

## 📝 Generic Type Constraints

### Bounded Type Parameters

Constrain generic types to specific supertypes:

```dart
// Generic with upper bound
class Repository<T extends Entity> {
  final List<T> _items = [];
  
  void add(T item) {
    // Can call methods from Entity because T extends Entity
    print('Adding entity with ID: ${item.id}');
    _items.add(item);
  }
  
  T? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

abstract class Entity {
  String get id;
}

class User extends Entity {
  @override
  final String id;
  final String name;
  
  User(this.id, this.name);
}

class Product extends Entity {
  @override
  final String id;
  final String name;
  final double price;
  
  Product(this.id, this.name, this.price);
}

void main() {
  var userRepo = Repository<User>();
  userRepo.add(User('1', 'Alice'));
  
  var productRepo = Repository<Product>();
  productRepo.add(Product('p1', 'Widget', 9.99));
  
  // Compile error: String doesn't extend Entity
  // var stringRepo = Repository<String>();
}
```

> **📘 Python Note:** This is like Python's `TypeVar('T', bound=Entity)`, but enforced at compile time. You can't instantiate `Repository<String>` - it won't compile!

### Multiple Type Parameters with Constraints

```dart
// Multiple bounded type parameters
class Pair<K extends Comparable, V> {
  final K key;
  final V value;
  
  Pair(this.key, this.value);
  
  // Can use compareTo because K extends Comparable
  int compareKeyTo(K other) {
    return key.compareTo(other);
  }
}

void main() {
  var pair1 = Pair<int, String>(1, 'one');
  var pair2 = Pair<int, String>(2, 'two');
  
  print(pair1.compareKeyTo(2)); // -1 (less than)
  
  // This works - DateTime implements Comparable
  var datePair = Pair<DateTime, String>(DateTime.now(), 'today');
}
```

## 📝 Covariance and Contravariance

### Understanding Variance

Dart's generics are **covariant** for some operations and **invariant** for others:

```dart
// Covariance: Can read as supertype
void processAnimals(List<Animal> animals) {
  for (var animal in animals) {
    animal.speak();
  }
}

class Animal {
  void speak() => print('Some sound');
}

class Dog extends Animal {
  @override
  void speak() => print('Woof!');
}

void main() {
  List<Dog> dogs = [Dog(), Dog()];
  
  // Can't do this! List<Dog> is NOT a List<Animal>
  // This would be unsafe - we could add a Cat to the list!
  // processAnimals(dogs); // Compile error
  
  // Instead, use proper typing:
  processAnimals(dogs.cast<Animal>()); // Explicit cast
  
  // Or make the function generic:
  processAnimalsList(dogs); // Works!
}

void processAnimalsList<T extends Animal>(List<T> animals) {
  for (var animal in animals) {
    animal.speak();
  }
}
```

> **📘 Python Note:** Python's type system allows `List[Dog]` as `List[Animal]` (covariant), but Dart is more strict to prevent runtime errors. This is because Dart's lists are mutable.

### Covariance with Read-Only Collections

```dart
// Iterable is covariant (read-only)
void printAnimals(Iterable<Animal> animals) {
  for (var animal in animals) {
    print(animal);
  }
}

void main() {
  List<Dog> dogs = [Dog(), Dog()];
  
  // This works! Iterable is covariant
  printAnimals(dogs);
  
  // Why? Because Iterable is read-only
  // You can't add to an Iterable, so it's safe
}
```

## 📝 Generic Type Inference

Dart's type inference is powerful and usually gets it right:

```dart
// Inference from constructor arguments
class Box<T> {
  final T value;
  Box(this.value);
}

void main() {
  // Type inferred as Box<int>
  var intBox = Box(42);
  
  // Type inferred as Box<String>
  var stringBox = Box('hello');
  
  // Explicit type still works
  Box<double> doubleBox = Box(3.14);
  
  // Inference from context
  Box<num> numBox = Box(42); // int is assignable to num
}
```

### Generic Method Inference

```dart
T firstElement<T>(List<T> list) {
  if (list.isEmpty) {
    throw StateError('List is empty');
  }
  return list.first;
}

void main() {
  // Type inferred from argument
  var first = firstElement([1, 2, 3]); // int
  print(first.runtimeType); // int
  
  // Explicit type parameter
  var firstString = firstElement<String>(['a', 'b', 'c']);
  
  // Type inferred from context
  int number = firstElement([10, 20, 30]);
}
```

## 📝 Advanced Generic Patterns

### Generic Factory Pattern

```dart
abstract class Serializable<T> {
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
}

class User implements Serializable<User> {
  final String id;
  final String name;
  
  User(this.id, this.name);
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
  
  @override
  User fromJson(Map<String, dynamic> json) {
    return User(json['id'] as String, json['name'] as String);
  }
}

// Generic repository with factory
class ApiRepository<T extends Serializable<T>> {
  final T Function(Map<String, dynamic>) factory;
  
  ApiRepository(this.factory);
  
  T fetchOne(String id) {
    // Simulate API call
    var json = {'id': id, 'name': 'Sample'};
    return factory(json);
  }
  
  List<T> fetchAll() {
    // Simulate API call
    var jsonList = [
      {'id': '1', 'name': 'Alice'},
      {'id': '2', 'name': 'Bob'},
    ];
    return jsonList.map(factory).toList();
  }
}

void main() {
  var userRepo = ApiRepository<User>((json) => User('', '').fromJson(json));
  var user = userRepo.fetchOne('123');
  print('Fetched user: ${user.name}');
}
```

### Generic Builder Pattern

```dart
class QueryBuilder<T> {
  final String _table;
  final List<String> _conditions = [];
  final Map<String, dynamic> _parameters = {};
  final T Function(Map<String, dynamic>) _mapper;
  
  QueryBuilder(this._table, this._mapper);
  
  QueryBuilder<T> where(String condition, dynamic value) {
    _conditions.add(condition);
    _parameters[condition] = value;
    return this;
  }
  
  QueryBuilder<T> and(String condition, dynamic value) {
    return where(condition, value);
  }
  
  List<T> execute() {
    // Simulate database query
    print('SELECT * FROM $_table WHERE ${_conditions.join(' AND ')}');
    // Mock result
    return [
      _mapper({'id': '1', 'name': 'Alice'}),
      _mapper({'id': '2', 'name': 'Bob'}),
    ];
  }
}

void main() {
  var users = QueryBuilder<User>(
    'users',
    (data) => User(data['id'] as String, data['name'] as String),
  )
    .where('age > ?', 18)
    .and('status = ?', 'active')
    .execute();
    
  print('Found ${users.length} users');
}
```

## 📝 Type Aliases and Typedefs

Create reusable type definitions:

```dart
// Function type alias
typedef JsonParser<T> = T Function(Map<String, dynamic> json);
typedef Predicate<T> = bool Function(T value);
typedef Mapper<S, T> = T Function(S source);

// Use type aliases
class DataService<T> {
  final JsonParser<T> parser;
  final Predicate<T>? validator;
  
  DataService(this.parser, {this.validator});
  
  T? parse(Map<String, dynamic> json) {
    var result = parser(json);
    if (validator != null && !validator!(result)) {
      return null;
    }
    return result;
  }
}

// Generic type alias (Dart 2.13+)
typedef Json = Map<String, dynamic>;
typedef StringMap<V> = Map<String, V>;
typedef IntList = List<int>;

void main() {
  Json data = {'name': 'Alice', 'age': 30};
  StringMap<int> scores = {'Alice': 100, 'Bob': 95};
  IntList numbers = [1, 2, 3, 4, 5];
}
```

## 📝 Dynamic vs Object vs Object?

Understanding when to use each:

```dart
void demonstrateTypes() {
  // dynamic: Disables type checking
  dynamic d = 'hello';
  d = 42; // OK
  d = [1, 2, 3]; // OK
  d.anyMethod(); // No compile error, will fail at runtime
  
  // Object: Non-nullable supertype of all types
  Object o = 'hello';
  o = 42; // OK
  // o = null; // Compile error
  // o.toString(); // OK (defined on Object)
  // o.length; // Compile error (not defined on Object)
  
  // Object?: Nullable supertype
  Object? o2 = 'hello';
  o2 = null; // OK
  // o2.toString(); // Compile error (might be null)
  o2?.toString(); // OK
  
  // Best practice: Use specific types when possible
  String s = 'hello'; // Best
  Object o3 = 'hello'; // OK if you need any type
  dynamic d2 = 'hello'; // Avoid unless necessary
}
```

## 📝 Generic Constraints in Practice

### Comparable Pattern

```dart
T max<T extends Comparable<T>>(T a, T b) {
  return a.compareTo(b) > 0 ? a : b;
}

void main() {
  print(max(5, 10)); // 10
  print(max('apple', 'banana')); // banana
  print(max(DateTime(2024, 1, 1), DateTime(2024, 12, 31))); // 2024-12-31
  
  // Compile error: User doesn't implement Comparable
  // print(max(User('1', 'Alice'), User('2', 'Bob')));
}
```

### Numeric Constraint Pattern

```dart
T add<T extends num>(T a, T b) {
  // This won't compile because + returns num, not T
  // return a + b;
  
  // Need to cast or be more specific
  if (T == int) {
    return (a as int) + (b as int) as T;
  } else {
    return (a as double) + (b as double) as T;
  }
}

// Better approach: Don't constrain return type
num addNumbers<T extends num>(T a, T b) {
  return a + b;
}

void main() {
  print(addNumbers(5, 10)); // 15
  print(addNumbers(3.14, 2.86)); // 6.0
}
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **generics_practice.dart** - Generic container classes
2. **type_constraints.dart** - Bounded type parameters
3. **advanced_patterns.dart** - Generic design patterns

## 📚 Key Takeaways

1. **Bounded Generics:** Use `<T extends Type>` to constrain type parameters
2. **Variance:** Lists are invariant (strict), Iterables are covariant (flexible)
3. **Type Inference:** Dart usually infers correctly, but be explicit when needed
4. **Type Aliases:** Use `typedef` for readable, reusable type definitions
5. **dynamic vs Object:** Prefer specific types, use Object over dynamic
6. **Compile-Time Safety:** Generics prevent runtime type errors
7. **Factory Patterns:** Combine generics with factories for flexible APIs

## 🔗 Next Steps

After mastering advanced generics, move on to:
- **Tutorial 12:** Isolates and Concurrency
- **Tutorial 13:** Advanced Async Patterns

---

**Practice with the exercises and experiments with different generic patterns to solidify your understanding!** 🎯✨
