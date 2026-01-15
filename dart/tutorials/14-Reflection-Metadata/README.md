# Tutorial 14: Reflection and Metadata

Welcome to an advanced tutorial on Dart's reflection capabilities and metadata system! Learn how to work with annotations, understand the limitations of reflection in Dart, and discover modern alternatives using code generation.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use built-in annotations like @override and @deprecated
- Create custom annotations for metadata
- Understand dart:mirrors and its limitations
- Work with runtime type information (runtimeType)
- Use the Reflectable package as a modern alternative
- Master code generation with build_runner and source_gen
- Know when to use reflection vs code generation
- Apply metadata for validation, routing, and dependency injection

## 🐍➡️🎯 Coming from Python

Python has powerful reflection with inspect, getattr, and decorators, but Dart takes a different approach:

| Concept | Python | Dart |
|---------|--------|------|
| Decorators | `@decorator` above function | Metadata annotations like `@override` |
| Custom decorators | `def decorator(func):` | Custom annotation classes |
| Reflection | `getattr()`, `hasattr()` | `dart:mirrors` (limited) |
| Type info | `type()`, `isinstance()` | `runtimeType`, `is` operator |
| Runtime inspection | `inspect` module | Mirrors API (tree-shaking issues) |
| Metaprogramming | Metaclasses, decorators | Code generation |
| Method introspection | `inspect.signature()` | Mirrors (or codegen) |

> **📘 Python Note:** Unlike Python's powerful runtime reflection, Dart prioritizes compile-time safety and performance. Use code generation instead of runtime reflection!

## ⚠️ Important: Reflection Limitations in Dart

Before diving in, understand these critical limitations:

1. **dart:mirrors** doesn't work in Flutter or web apps (tree-shaking conflict)
2. **Performance**: Reflection is slower than direct calls
3. **Code size**: Mirrors prevent tree-shaking, bloating app size
4. **Modern approach**: Prefer code generation with build_runner

> **📘 Python Note:** Python's reflection is available everywhere. Dart's reflection is limited by design for performance and size optimization!

## 📝 Built-in Annotations

### Common Annotations

```dart
class Animal {
  String name;
  
  Animal(this.name);
  
  void makeSound() {
    print('Some generic sound');
  }
}

class Dog extends Animal {
  Dog(String name) : super(name);
  
  // Indicates this method overrides parent method
  @override
  void makeSound() {
    print('$name: Woof!');
  }
  
  // Mark method as deprecated
  @deprecated
  void oldBark() {
    print('Use makeSound() instead');
  }
}

void main() {
  var dog = Dog('Max');
  dog.makeSound();  // Max: Woof!
  
  // IDE will show warning
  dog.oldBark();  // Deprecated warning
}
```

> **📘 Python Note:** Similar to Python's `@override` in typing.override (3.12+), but enforced by Dart's analyzer!

### More Built-in Annotations

```dart
class Example {
  // Prevent overriding in subclasses
  @sealed
  void finalMethod() {
    print('Cannot be overridden');
  }
  
  // Must be overridden in subclass
  @mustBeOverridden
  void abstractMethod() {
    throw UnimplementedError();
  }
  
  // Mark as experimental API
  @experimental
  void newFeature() {
    print('This API may change');
  }
  
  // Indicate immutability
  @immutable
  final String value = 'constant';
  
  // Mark as protected (convention, not enforced)
  @protected
  void internalMethod() {
    print('For use by subclasses only');
  }
}
```

## 📝 Creating Custom Annotations

### Basic Custom Annotation

```dart
// Define a custom annotation class
class Route {
  final String path;
  final String method;
  
  const Route(this.path, {this.method = 'GET'});
}

// Apply custom annotation
class UserController {
  @Route('/users')
  void listUsers() {
    print('GET /users - List all users');
  }
  
  @Route('/users/:id', method: 'GET')
  void getUser(String id) {
    print('GET /users/$id - Get user $id');
  }
  
  @Route('/users', method: 'POST')
  void createUser(Map<String, dynamic> data) {
    print('POST /users - Create user');
  }
}
```

> **📘 Python Note:** Like Python decorators, but Dart annotations are just metadata. They don't modify behavior unless processed by code generation or reflection.

### Validation Annotations

```dart
class Required {
  final String message;
  const Required([this.message = 'This field is required']);
}

class MinLength {
  final int length;
  final String message;
  const MinLength(this.length, [this.message = '']);
}

class Email {
  final String message;
  const Email([this.message = 'Invalid email format']);
}

class User {
  @Required('Username is required')
  @MinLength(3, 'Username must be at least 3 characters')
  String username;
  
  @Required()
  @Email('Please enter a valid email')
  String email;
  
  int? age;
  
  User({required this.username, required this.email, this.age});
}

void main() {
  var user = User(
    username: 'ab',  // Too short!
    email: 'invalid-email',  // Invalid format!
  );
  
  // Annotations are metadata - need validation framework to use them
  print('User created (but not validated yet)');
}
```

## 📝 Runtime Type Information

### Using runtimeType

```dart
void main() {
  var number = 42;
  var text = 'Hello';
  var items = [1, 2, 3];
  
  // Get runtime type
  print(number.runtimeType);  // int
  print(text.runtimeType);    // String
  print(items.runtimeType);   // List<int>
  
  // Type checking
  print(number is int);      // true
  print(text is String);     // true
  print(items is List);      // true
  print(items is List<int>); // true
}
```

> **📘 Python Note:** Like `type(obj)` in Python, but with compile-time type checking too!

### Type Objects and Comparison

```dart
void processValue<T>(T value) {
  print('Type parameter: $T');
  print('Runtime type: ${value.runtimeType}');
  
  // Compare types
  if (T == int) {
    print('Processing integer: $value');
  } else if (T == String) {
    print('Processing string: $value');
  } else {
    print('Processing other type: $value');
  }
}

void main() {
  processValue<int>(42);
  processValue<String>('hello');
  processValue<List<int>>([1, 2, 3]);
}
```

### Generic Type Information

```dart
class Box<T> {
  final T value;
  
  Box(this.value);
  
  Type get valueType => T;
  
  void describe() {
    print('Box contains a $T');
    print('Actual value type: ${value.runtimeType}');
    print('Types match: ${T == value.runtimeType}');
  }
}

void main() {
  var intBox = Box<int>(42);
  intBox.describe();
  // Box contains a int
  // Actual value type: int
  // Types match: true
  
  var stringBox = Box<String>('hello');
  stringBox.describe();
  // Box contains a String
  // Actual value type: String
  // Types match: true
}
```

## 📝 dart:mirrors (With Caveats!)

### Basic Reflection Example

```dart
import 'dart:mirrors';

class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void greet() {
    print('Hello, I am $name, $age years old');
  }
  
  void celebrate() {
    age++;
    print('Happy birthday! Now $age years old');
  }
}

void main() {
  var person = Person('Alice', 30);
  
  // Get mirror of instance
  InstanceMirror mirror = reflect(person);
  
  // Get class mirror
  ClassMirror classMirror = mirror.type;
  
  // Print class name
  print('Class: ${MirrorSystem.getName(classMirror.simpleName)}');
  
  // List all methods
  print('\nMethods:');
  classMirror.instanceMembers.forEach((symbol, method) {
    if (method is MethodMirror && !method.isGetter && !method.isSetter) {
      print('  ${MirrorSystem.getName(symbol)}');
    }
  });
  
  // List all fields
  print('\nFields:');
  classMirror.declarations.forEach((symbol, declaration) {
    if (declaration is VariableMirror) {
      var value = mirror.getField(symbol).reflectee;
      print('  ${MirrorSystem.getName(symbol)}: $value');
    }
  });
  
  // Invoke method by name
  print('\nInvoking methods:');
  mirror.invoke(Symbol('greet'), []);
  mirror.invoke(Symbol('celebrate'), []);
}
```

> **📘 Python Note:** Similar to `getattr(obj, 'method')()` but much more verbose. Also, this won't work in Flutter!

### Dynamic Property Access

```dart
import 'dart:mirrors';

class Config {
  String apiUrl = 'https://api.example.com';
  int timeout = 30;
  bool debugMode = false;
}

T? getProperty<T>(Object obj, String propertyName) {
  try {
    var mirror = reflect(obj);
    var value = mirror.getField(Symbol(propertyName)).reflectee;
    return value as T?;
  } catch (e) {
    print('Error accessing property $propertyName: $e');
    return null;
  }
}

void setProperty(Object obj, String propertyName, dynamic value) {
  try {
    var mirror = reflect(obj);
    mirror.setField(Symbol(propertyName), value);
  } catch (e) {
    print('Error setting property $propertyName: $e');
  }
}

void main() {
  var config = Config();
  
  // Dynamic property access
  print(getProperty<String>(config, 'apiUrl'));  // https://api.example.com
  print(getProperty<int>(config, 'timeout'));    // 30
  
  // Dynamic property modification
  setProperty(config, 'debugMode', true);
  print(config.debugMode);  // true
}
```

### Why NOT to Use dart:mirrors

```dart
// ❌ DON'T DO THIS in production!

import 'dart:mirrors';

// This works in Dart VM but:
// - Won't work in Flutter
// - Won't work in dart2js (Dart-to-JavaScript compiler for web)
// - Prevents tree-shaking (huge app size)
// - Slower than direct calls
// - No compile-time safety

void badExample() {
  var obj = SomeClass();
  var mirror = reflect(obj);
  
  // Typo in method name? Runtime error!
  mirror.invoke(Symbol('methodNam'), []);  // Oops!
}

// ✅ DO THIS instead:
// Use code generation (see next section)
```

## 📝 Modern Alternative: Code Generation

### Using build_runner and json_serializable

First, add dependencies to `pubspec.yaml`:

```yaml
dependencies:
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

Create a model with annotations:

```dart
import 'package:json_annotation/json_annotation.dart';

// This tells the generator to create a _user.g.dart file
part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;
  final int age;
  
  User({required this.name, required this.email, required this.age});
  
  // Generated method for JSON deserialization
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  // Generated method for JSON serialization
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

Run code generation:

```bash
dart run build_runner build
# Or watch for changes:
dart run build_runner watch
```

Use the generated code:

```dart
void main() {
  // Serialize to JSON
  var user = User(name: 'Alice', email: 'alice@example.com', age: 30);
  var json = user.toJson();
  print(json);  // {name: Alice, email: alice@example.com, age: 30}
  
  // Deserialize from JSON
  var userData = {'name': 'Bob', 'email': 'bob@example.com', 'age': 25};
  var bob = User.fromJson(userData);
  print('${bob.name}, ${bob.age}');  // Bob, 25
}
```

> **📘 Python Note:** Like Python's dataclasses or Pydantic, but code is generated at build time instead of runtime magic!

### Creating Custom Annotations for Code Generation

```dart
// Define annotation
class AutoService {
  final bool singleton;
  const AutoService({this.singleton = false});
}

// Use annotation
@AutoService(singleton: true)
class UserService {
  void getUsers() {
    print('Fetching users...');
  }
}

@AutoService()
class ProductService {
  void getProducts() {
    print('Fetching products...');
  }
}

// A code generator would process these annotations
// to generate dependency injection code
```

## 📝 Reflectable Package

### Installing Reflectable

```yaml
dependencies:
  reflectable: ^4.0.0

dev_dependencies:
  build_runner: ^2.4.6
```

### Using Reflectable

```dart
import 'package:reflectable/reflectable.dart';

// Define a reflector
class MyReflector extends Reflectable {
  const MyReflector()
      : super(invokingCapability, declarationsCapability);
}

const myReflector = MyReflector();

// Annotate classes you want to reflect on
@myReflector
class Calculator {
  int add(int a, int b) => a + b;
  int multiply(int a, int b) => a * b;
}

@myReflector
class StringUtils {
  String reverse(String s) => s.split('').reversed.join('');
  String uppercase(String s) => s.toUpperCase();
}

void main() {
  // Initialize reflectable (after running build_runner)
  // initializeReflectable();
  
  var calc = Calculator();
  
  // Get reflector for instance
  InstanceMirror mirror = myReflector.reflect(calc);
  
  // Invoke methods dynamically
  var result = mirror.invoke('add', [5, 3]);
  print('5 + 3 = $result');  // 5 + 3 = 8
  
  var product = mirror.invoke('multiply', [4, 7]);
  print('4 × 7 = $product');  // 4 × 7 = 28
}
```

> **📘 Python Note:** Reflectable is like a restricted, opt-in version of Python's reflection - you explicitly mark what can be reflected!

## 📝 Practical Applications

### Dependency Injection with Annotations

```dart
class Injectable {
  final bool singleton;
  const Injectable({this.singleton = false});
}

class Inject {
  const Inject();
}

@Injectable(singleton: true)
class DatabaseService {
  void connect() => print('Connected to database');
  void query(String sql) => print('Executing: $sql');
}

@Injectable()
class UserRepository {
  @Inject()
  late DatabaseService db;
  
  void findAll() {
    db.connect();
    db.query('SELECT * FROM users');
  }
}

// A code generator would create:
// - Service registry
// - Factory methods
// - Dependency resolution
// - Singleton management

void main() {
  // Generated dependency injection container would handle this:
  // var container = DependencyContainer();
  // var userRepo = container.get<UserRepository>();
  // userRepo.findAll();
  
  print('This would be generated by build_runner!');
}
```

### Validation Framework with Metadata

```dart
class Validator {
  const Validator();
}

class MinLength extends Validator {
  final int min;
  const MinLength(this.min);
}

class MaxLength extends Validator {
  final int max;
  const MaxLength(this.max);
}

class Email extends Validator {
  const Email();
}

class Range extends Validator {
  final num min;
  final num max;
  const Range(this.min, this.max);
}

class RegistrationForm {
  @MinLength(3)
  @MaxLength(20)
  String username;
  
  @Email()
  String email;
  
  @MinLength(8)
  String password;
  
  @Range(18, 120)
  int age;
  
  RegistrationForm({
    required this.username,
    required this.email,
    required this.password,
    required this.age,
  });
}

// Code generation would create:
class RegistrationFormValidator {
  static List<String> validate(RegistrationForm form) {
    var errors = <String>[];
    
    if (form.username.length < 3) {
      errors.add('Username must be at least 3 characters');
    }
    if (form.username.length > 20) {
      errors.add('Username must be at most 20 characters');
    }
    
    if (!_isValidEmail(form.email)) {
      errors.add('Invalid email format');
    }
    
    if (form.password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }
    
    if (form.age < 18 || form.age > 120) {
      errors.add('Age must be between 18 and 120');
    }
    
    return errors;
  }
  
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

void main() {
  var form = RegistrationForm(
    username: 'ab',  // Too short
    email: 'invalid',  // Invalid
    password: 'short',  // Too short
    age: 15,  // Too young
  );
  
  var errors = RegistrationFormValidator.validate(form);
  
  if (errors.isEmpty) {
    print('Form is valid!');
  } else {
    print('Validation errors:');
    errors.forEach(print);
  }
}
```

### Routing with Annotations

```dart
class Get {
  final String path;
  const Get(this.path);
}

class Post {
  final String path;
  const Post(this.path);
}

class Put {
  final String path;
  const Put(this.path);
}

class Delete {
  final String path;
  const Delete(this.path);
}

class ApiController {
  @Get('/api/users')
  Future<List<Map<String, dynamic>>> getUsers() async {
    return [
      {'id': 1, 'name': 'Alice'},
      {'id': 2, 'name': 'Bob'},
    ];
  }
  
  @Get('/api/users/:id')
  Future<Map<String, dynamic>> getUser(String id) async {
    return {'id': id, 'name': 'User $id'};
  }
  
  @Post('/api/users')
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    return {'id': 3, ...data};
  }
  
  @Put('/api/users/:id')
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) async {
    return {'id': id, ...data};
  }
  
  @Delete('/api/users/:id')
  Future<void> deleteUser(String id) async {
    print('User $id deleted');
  }
}

// Code generation would create router configuration
void main() {
  print('Routes would be auto-generated from annotations:');
  print('GET    /api/users');
  print('GET    /api/users/:id');
  print('POST   /api/users');
  print('PUT    /api/users/:id');
  print('DELETE /api/users/:id');
}
```

## 📝 When to Use What

### Reflection vs Code Generation Decision Matrix

```dart
// ❌ Use dart:mirrors when:
// - NEVER in production code!
// - Only for Dart VM-only tools
// - Only for development/testing utilities

// ✅ Use code generation when:
class CodeGenUseCase {
  // - JSON serialization/deserialization
  void jsonExample() {
    // Use json_serializable
  }
  
  // - Dependency injection
  void diExample() {
    // Use injectable, get_it generator
  }
  
  // - Routing
  void routingExample() {
    // Use shelf_router_generator, auto_route
  }
  
  // - Validation
  void validationExample() {
    // Custom validator generator
  }
  
  // - Data classes/models
  void modelExample() {
    // Use freezed, built_value
  }
}

// ✅ Use annotations (metadata only) when:
class MetadataOnlyUseCase {
  // - Documentation (@deprecated, @experimental)
  @deprecated
  void oldMethod() {}
  
  // - Lint hints (@override, @protected)
  @override
  String toString() => 'example';
  
  // - Configuration markers
  @immutable
  final String constant = 'value';
}

// ✅ Use runtime type checking when:
class RuntimeTypeUseCase {
  void dynamicBehavior(Object value) {
    // Type-based dispatch
    if (value is String) {
      print('String: $value');
    } else if (value is int) {
      print('Integer: $value');
    }
  }
  
  // Generic type checking
  bool isList<T>(Object value) => value is List<T>;
}
```

## 📝 Complete Example: Mini Validation Framework

```dart
// validation_annotations.dart
class Validate {
  const Validate();
}

class Required extends Validate {
  final String message;
  const Required([this.message = 'This field is required']);
}

class MinLength extends Validate {
  final int length;
  final String message;
  const MinLength(this.length, [this.message = '']);
}

class Email extends Validate {
  const Email();
}

// user_model.dart
class User {
  @Required()
  @MinLength(3, 'Username too short')
  String username;
  
  @Required()
  @Email()
  String email;
  
  int? age;
  
  User(this.username, this.email, [this.age]);
}

// Simple validation (without code generation)
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  
  ValidationResult(this.isValid, this.errors);
}

ValidationResult validateUser(User user) {
  var errors = <String>[];
  
  // Username validation
  if (user.username.isEmpty) {
    errors.add('Username is required');
  } else if (user.username.length < 3) {
    errors.add('Username too short');
  }
  
  // Email validation
  if (user.email.isEmpty) {
    errors.add('Email is required');
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(user.email)) {
    errors.add('Invalid email format');
  }
  
  return ValidationResult(errors.isEmpty, errors);
}

void main() {
  print('=== Valid User ===');
  var validUser = User('alice', 'alice@example.com', 30);
  var result1 = validateUser(validUser);
  
  if (result1.isValid) {
    print('✓ User is valid');
  } else {
    print('✗ Validation errors:');
    result1.errors.forEach((e) => print('  - $e'));
  }
  
  print('\n=== Invalid User ===');
  var invalidUser = User('ab', 'invalid-email');
  var result2 = validateUser(invalidUser);
  
  if (result2.isValid) {
    print('✓ User is valid');
  } else {
    print('✗ Validation errors:');
    result2.errors.forEach((e) => print('  - $e'));
  }
}
```

## ✍️ Practice Exercises

See the exercises directory for hands-on practice:

1. `exercises/1-custom-annotations.md` - Create a custom logging annotation system
2. `exercises/2-type-registry.md` - Build a type registry without mirrors
3. `exercises/3-simple-di-container.md` - Implement a simple dependency injection container

## 📚 What You Learned

✅ Built-in annotations (@override, @deprecated, etc.)
✅ Creating custom annotations
✅ Runtime type information with runtimeType
✅ Limitations of dart:mirrors
✅ Code generation with build_runner
✅ Reflectable package for selective reflection
✅ When to use reflection vs code generation
✅ Practical applications: validation, routing, DI

## 🔜 Next Steps

**Next tutorial: 15-Advanced-Error-Handling** - Master advanced error handling patterns including Result types, Railway Oriented Programming, and custom error hierarchies.

## 💡 Key Takeaways for Python Developers

1. **Limited reflection**: Dart's reflection is intentionally limited for performance and tree-shaking
2. **Code generation over runtime magic**: Prefer build-time code generation to runtime reflection
3. **Annotations are metadata**: Unlike Python decorators, Dart annotations don't modify behavior directly
4. **Flutter compatibility**: dart:mirrors doesn't work in Flutter - use code generation instead
5. **Type safety**: Dart's compile-time type checking reduces the need for runtime reflection

## 🆘 Common Pitfalls

### Pitfall 1: Using dart:mirrors in Flutter
```dart
// ❌ DON'T - Won't compile in Flutter!
import 'dart:mirrors';

class MyWidget extends StatelessWidget {
  void reflectionBasedMethod() {
    var mirror = reflect(this);  // ERROR in Flutter!
  }
}

// ✅ DO - Use code generation
import 'package:json_annotation/json_annotation.dart';
part 'widget.g.dart';

@JsonSerializable()
class MyData {
  // Generated code instead of reflection
}
```

### Pitfall 2: Forgetting const constructors for annotations
```dart
// ❌ DON'T - Non-const annotation
class MyAnnotation {
  final String value;
  MyAnnotation(this.value);  // Missing const
}

// ✅ DO - Const constructor
class MyAnnotation {
  final String value;
  const MyAnnotation(this.value);  // const constructor
}
```

### Pitfall 3: Expecting annotations to do something automatically
```dart
@Deprecated('Use newMethod instead')
void oldMethod() {
  print('This still works!');
}

void main() {
  // Annotations are just metadata - they don't prevent execution
  oldMethod();  // ⚠️ Warning, but still runs!
  
  // You need tools (linters, code generators) to act on annotations
}
```

### Pitfall 4: Reflection for simple type checks
```dart
import 'dart:mirrors';

// ❌ DON'T - Overkill for simple type check
void processValue(Object value) {
  var mirror = reflect(value);
  if (mirror.type.simpleName == Symbol('String')) {
    // ...
  }
}

// ✅ DO - Use is operator
void processValue(Object value) {
  if (value is String) {
    // Much simpler and faster!
  }
}
```

## 📖 Additional Resources

- [Dart Language Tour: Metadata](https://dart.dev/language/metadata)
- [Code Generation with build_runner](https://dart.dev/tools/build_runner)
- [json_serializable Package](https://pub.dev/packages/json_serializable)
- [Reflectable Package](https://pub.dev/packages/reflectable)
- [Writing a Builder](https://github.com/dart-lang/build/blob/master/docs/writing_a_builder.md)
- [Effective Dart: Design - Metadata](https://dart.dev/effective-dart/design#prefer-using-a-function-type-alias-to-de-duplicate-function-types)

## 🎯 Summary

Dart takes a pragmatic approach to reflection and metadata:

- **Annotations** provide metadata but don't modify behavior directly
- **dart:mirrors** exists but has severe limitations (no Flutter, no web, bloats code size)
- **Code generation** is the modern, recommended approach for metaprogramming
- **Runtime type info** is available but use sparingly
- **Build-time over runtime**: Dart philosophy favors compile-time safety and performance

Remember: If you're coming from Python and reaching for reflection, ask yourself: "Can I use code generation instead?" The answer is usually yes, and your app will be faster and smaller for it!

---

Ready to practice? Complete the exercises and master Dart's metadata system!
