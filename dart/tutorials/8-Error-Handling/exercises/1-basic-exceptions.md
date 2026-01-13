# Exercise 1: Basic Exceptions

Master try/catch/finally and exception handling.

## 🚀 REPL & Script Practice

```bash
make dart-repl
```

```dart
// Basic try/catch
try {
  var number = int.parse("hello");
} catch (e) {
  print("Error: $e");
}

// With finally
try {
  print("Start");
  throw Exception("Test error");
} catch (e) {
  print("Caught: $e");
} finally {
  print("Cleanup");
}

// Specific exceptions
try {
  var result = 10 ~/ 0;
} on IntegerDivisionByZeroException {
  print("Cannot divide by zero");
} catch (e) {
  print("Other error: $e");
}
```

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/8-Error-Handling/exercises/calculator.dart`

```dart
void main() {
  calculate("10", "5", "+");
  calculate("10", "0", "/");
  calculate("abc", "5", "+");
}

void calculate(String a, String b, String op) {
  try {
    var num1 = int.parse(a);
    var num2 = int.parse(b);

    var result = switch (op) {
      "+" => num1 + num2,
      "-" => num1 - num2,
      "*" => num1 * num2,
      "/" => num1 ~/ num2,
      _ => throw ArgumentError("Invalid operator")
    };

    print("$a $op $b = $result");
  } on FormatException {
    print("Error: Invalid number format");
  } on IntegerDivisionByZeroException {
    print("Error: Cannot divide by zero");
  } on ArgumentError catch (e) {
    print("Error: ${e.message}");
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/8-Error-Handling/exercises/calculator.dart`

## ✅ Success Criteria

- [ ] Can use try/catch/finally
- [ ] Can handle specific exceptions
- [ ] Completed calculator challenge
