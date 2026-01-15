# Exercise 3: Simple Code Generator

Create a basic code generator using build_runner.

## 📝 Requirements

1. Create annotation for generating `toJson` methods
2. Use build_runner to generate code
3. Generate both `toJson` and `fromJson`

## 🎯 Example

```dart
@JsonSerializable()
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
}

// Generated code:
// Map<String, dynamic> _$PersonToJson(Person instance) => ...
```
