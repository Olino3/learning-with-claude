# Tutorial 15: Code Generation and Annotations

Welcome to meta-programming in Dart! This tutorial covers annotations, code generation, build_runner, and creating your own code generators.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Dart's annotation system
- Use built-in annotations effectively
- Work with code generation tools (build_runner)
- Create custom annotations
- Understand common generators (json_serializable, freezed)
- Build simple code generators

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Decorators | `@decorator` | Annotations `@annotation` |
| Metaclasses | `class Meta(type):` | Annotations + generators |
| Runtime reflection | `inspect` module | dart:mirrors (limited) |
| Code generation | AST manipulation | build_runner + source_gen |
| Dataclasses | `@dataclass` | json_serializable, freezed |

> **📘 Python Note:** Unlike Python decorators which run at runtime, Dart annotations are metadata that code generators use at build time. This makes Dart code generation more explicit but also more powerful for performance.

## 📝 Built-in Annotations

```dart
// @override - Mark overridden members
class Animal {
  void makeSound() => print('Some sound');
}

class Dog extends Animal {
  @override
  void makeSound() => print('Woof!');
  
  // Compiler warns if this doesn't override anything
  @override
  void bark() => print('Bark!'); // Warning!
}

// @deprecated - Mark deprecated code
class OldAPI {
  @deprecated
  void oldMethod() {
    print('This method is deprecated');
  }
  
  @Deprecated('Use newMethod() instead')
  void legacyMethod() {
    print('Legacy method');
  }
}

// @pragma - Compiler hints
class PerformanceCritical {
  @pragma('vm:prefer-inline')
  int add(int a, int b) => a + b;
  
  @pragma('vm:never-inline')
  void complexMethod() {
    // Complex logic
  }
}
```

## 📝 JSON Serialization with json_serializable

```dart
import 'package:json_annotation/json_annotation.dart';

// This generates the .g.dart file
part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(defaultValue: false)
  final bool isActive;
  
  @JsonKey(ignore: true)
  String? password;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.isActive = true,
  });
  
  // Generated methods
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Usage
void main() {
  var json = {
    'id': '123',
    'name': 'Alice',
    'email': 'alice@example.com',
    'created_at': '2024-01-01T00:00:00.000Z',
  };
  
  var user = User.fromJson(json);
  print(user.name); // Alice
  
  var backToJson = user.toJson();
  print(backToJson); // {...}
}
```

## 📝 Freezed for Immutable Classes

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';
part 'result.g.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.error(String message) = Error<T>;
  const factory Result.loading() = Loading<T>;
  
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}

// Usage with pattern matching
void handleResult(Result<String> result) {
  result.when(
    success: (data) => print('Success: $data'),
    error: (message) => print('Error: $message'),
    loading: () => print('Loading...'),
  );
  
  // Or use map
  var value = result.map(
    success: (s) => s.data,
    error: (_) => 'Error occurred',
    loading: (_) => 'Loading...',
  );
}
```

## 📝 Custom Annotations

```dart
// Define custom annotation
class Validate {
  final String pattern;
  const Validate(this.pattern);
}

class Required {
  const Required();
}

class MaxLength {
  final int length;
  const MaxLength(this.length);
}

// Use custom annotations
class UserInput {
  @Required()
  @MaxLength(100)
  final String name;
  
  @Required()
  @Validate(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
  final String email;
  
  @MaxLength(20)
  final String? phone;
  
  UserInput({
    required this.name,
    required this.email,
    this.phone,
  });
}

// Note: You'd need a code generator to actually use these
// This is just the annotation definition
```

## 📝 Build Runner Basics

```yaml
# pubspec.yaml
dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  freezed: ^2.4.0
  freezed_annotation: ^2.4.0
```

```bash
# Run code generation
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean generated files
dart run build_runner clean
```

## 📝 Simple Custom Generator

```dart
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

// Custom annotation
class GenerateToString {
  const GenerateToString();
}

// Generator
class ToStringGenerator extends GeneratorForAnnotation<GenerateToString> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'GenerateToString can only be applied to classes',
        element: element,
      );
    }
    
    var className = element.name;
    var fields = element.fields.where((f) => !f.isStatic);
    
    var fieldStrings = fields.map((f) {
      return '${f.name}: \${${f.name}}';
    }).join(', ');
    
    return '''
extension ${className}Extension on $className {
  String toStringGenerated() {
    return '$className($fieldStrings)';
  }
}
''';
  }
}

// Usage
@GenerateToString()
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
}

// Generated code would create:
// extension PersonExtension on Person {
//   String toStringGenerated() {
//     return 'Person(name: $name, age: $age)';
//   }
// }
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **annotations_practice.dart** - Using built-in annotations
2. **json_serialization.dart** - Working with json_serializable
3. **custom_annotations.dart** - Creating custom annotations

## 📚 Key Takeaways

1. **Annotations:** Metadata for code generation, not runtime decoration
2. **Built-in:** `@override`, `@deprecated`, `@pragma` for compiler hints
3. **json_serializable:** Generate JSON serialization code
4. **freezed:** Immutable classes with unions and pattern matching
5. **build_runner:** Tool for running code generators
6. **Custom Generators:** Extend source_gen for custom code generation
7. **Performance:** Generated code is optimized at compile time

## 🔗 Next Steps

After mastering code generation, move on to:
- **Tutorial 16:** Advanced Patterns (Dart 3.0+)
- **Tutorial 17:** Performance Optimization

---

**Use code generation to eliminate boilerplate and improve productivity!** 🎯✨
