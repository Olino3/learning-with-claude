# Exercise 2: Custom Exceptions

Create and use custom exception classes.

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/8-Error-Handling/exercises/validation.dart`

```dart
void main() {
  var validator = UserValidator();

  try {
    validator.validateUser("", 25, "test@example.com");
  } on ValidationException catch (e) {
    print("Validation failed: ${e.message} (field: ${e.field})");
  }

  try {
    validator.validateUser("Alice", -5, "test@example.com");
  } on ValidationException catch (e) {
    print("Validation failed: ${e.message} (field: ${e.field})");
  }

  validator.validateUser("Bob", 30, "bob@example.com");
}

class ValidationException implements Exception {
  final String message;
  final String field;

  ValidationException(this.message, this.field);

  @override
  String toString() => "ValidationException: $field - $message";
}

class UserValidator {
  void validateUser(String name, int age, String email) {
    if (name.isEmpty) {
      throw ValidationException("Name cannot be empty", "name");
    }
    if (age < 0 || age > 120) {
      throw ValidationException("Age must be between 0 and 120", "age");
    }
    if (!email.contains("@")) {
      throw ValidationException("Invalid email format", "email");
    }

    print("User validated: $name, $age, $email");
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/8-Error-Handling/exercises/validation.dart`

## ✅ Success Criteria

- [ ] Can create custom exceptions
- [ ] Can throw custom exceptions
- [ ] Can catch and handle custom exceptions
