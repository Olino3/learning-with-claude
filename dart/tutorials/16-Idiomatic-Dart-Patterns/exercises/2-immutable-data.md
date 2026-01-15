# Exercise 2: Immutable Data Structures

Create immutable data classes with `copyWith` pattern.

## 📝 Requirements

1. Create immutable `Person` class
2. Implement `copyWith` method
3. Support freezing collections
4. Compare with regular mutable classes

## 🎯 Example

```dart
class Person {
  final String name;
  final int age;
  
  const Person({required this.name, required this.age});
  
  Person copyWith({String? name, int? age}) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}

void main() {
  var person = Person(name: 'Alice', age: 30);
  var older = person.copyWith(age: 31);
}
```
