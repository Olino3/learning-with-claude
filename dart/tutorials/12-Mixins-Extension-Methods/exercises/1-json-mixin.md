# Exercise 1: JSON Serialization Mixin

Create a mixin system for JSON serialization and deserialization.

## 📝 Requirements

1. Create a `JsonSerializable` mixin with:
   - `Map<String, dynamic> toJson()` abstract method
   - `String toJsonString()` that converts to JSON string
   
2. Create a `JsonValidatable` mixin that validates JSON data

## 🎯 Example Usage

```dart
class User with JsonSerializable {
  String name;
  int age;
  String email;
  
  User(this.name, this.age, this.email);
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }
}

void main() {
  var user = User('Alice', 30, 'alice@example.com');
  print(user.toJson());
  print(user.toJsonString());
}
```

## 🚀 Bonus: Add fromJson factory pattern
