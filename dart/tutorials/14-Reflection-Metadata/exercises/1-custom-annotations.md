# Exercise 1: Custom Validation Annotations

Create custom annotations for data validation.

## 📝 Requirements

Create annotations:
1. `@Required()` - Field must not be null
2. `@MinLength(int length)` - String minimum length
3. `@Email()` - Valid email format
4. Validator that checks these annotations

## 🎯 Example

```dart
class User {
  @Required()
  @MinLength(3)
  String name;
  
  @Required()
  @Email()
  String email;
  
  User(this.name, this.email);
}

void main() {
  var user = User('Al', 'invalid-email');
  var errors = validate(user);
  print(errors);  // [MinLength failed, Email failed]
}
```
