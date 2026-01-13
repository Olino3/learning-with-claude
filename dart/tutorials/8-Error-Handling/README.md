# Tutorial 8: Error Handling - Exceptions and Error Management

Welcome to Dart's error handling tutorial! Learn how to gracefully handle errors using try/catch, throw exceptions, and create custom exception classes.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Use try/catch/finally blocks
- Understand the on keyword for specific exceptions
- Throw and rethrow exceptions
- Create custom exception classes
- Handle errors gracefully
- Understand stack traces

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Try/catch | `try: ... except:` | `try { } catch (e) { }` |
| Specific exception | `except ValueError:` | `on FormatException catch (e)` |
| Finally | `finally:` | `finally { }` |
| Raise exception | `raise ValueError("msg")` | `throw FormatException("msg")` |
| Reraise | `raise` | `rethrow` |
| Custom exception | Class inheriting Exception | Class implementing Exception |
| Multiple exceptions | Multiple except blocks | Multiple on/catch blocks |

## 📝 Try/Catch Basics

### Basic Try/Catch

```dart
// Basic error handling
void parseNumber(String input) {
  try {
    var number = int.parse(input);
    print("Parsed: $number");
  } catch (e) {
    print("Error: $e");
  }
}

parseNumber("42");      // Parsed: 42
parseNumber("hello");   // Error: FormatException: Invalid radix-10 number

// With stack trace
void parseWithStack(String input) {
  try {
    var number = int.parse(input);
    print("Parsed: $number");
  } catch (e, stackTrace) {
    print("Error: $e");
    print("Stack trace: $stackTrace");
  }
}
```

> **📘 Python Note:** Very similar to Python! Use `catch` instead of `except`, and braces `{}` instead of indentation.

### Finally Block

```dart
void processFile(String filename) {
  print("Opening file: $filename");

  try {
    // Process file
    if (filename.isEmpty) {
      throw Exception("Invalid filename");
    }
    print("Processing: $filename");
  } catch (e) {
    print("Error: $e");
  } finally {
    // Always executes, even if error occurs
    print("Closing file: $filename");
  }
}

processFile("data.txt");
processFile("");
```

> **📘 Python Note:** Same as Python's `finally` block - always executes for cleanup.

## 📝 Specific Exception Handling

### Using On Keyword

```dart
void handleSpecificErrors(String input) {
  try {
    var number = int.parse(input);
    var result = 100 ~/ number;
    print("Result: $result");
  } on FormatException catch (e) {
    print("Invalid number format: ${e.message}");
  } on IntegerDivisionByZeroException {
    print("Cannot divide by zero!");
  } catch (e) {
    print("Unknown error: $e");
  }
}

handleSpecificErrors("10");     // Result: 10
handleSpecificErrors("abc");    // Invalid number format: Invalid radix-10 number
handleSpecificErrors("0");      // Cannot divide by zero!
```

> **📘 Python Note:** The `on` keyword is like Python's specific `except ValueError:`. The catch after `on` is optional.

### Multiple Exception Types

```dart
void processData(String data) {
  try {
    // Various operations that might fail
    var number = int.parse(data);
    var list = <int>[1, 2, 3];
    print(list[number]);
  } on FormatException catch (e) {
    print("Format error: ${e.message}");
  } on RangeError catch (e) {
    print("Index out of range: ${e.message}");
  } catch (e) {
    // Catch all other exceptions
    print("Unexpected error: $e");
  }
}

processData("1");       // 2
processData("abc");     // Format error: ...
processData("10");      // Index out of range: ...
```

## 📝 Throwing Exceptions

### Throw Keyword

```dart
void validateAge(int age) {
  if (age < 0) {
    throw ArgumentError("Age cannot be negative");
  }
  if (age > 120) {
    throw ArgumentError("Age seems unrealistic");
  }
  print("Valid age: $age");
}

// Usage
try {
  validateAge(25);    // Valid age: 25
  validateAge(-5);    // Throws ArgumentError
} catch (e) {
  print("Validation error: $e");
}
```

### Throw Any Object

```dart
// Can throw any object (but shouldn't)
void example() {
  // throw "Simple string error";  // Works but not recommended
  // throw 42;                       // Works but not recommended

  // Better - throw proper exceptions
  throw Exception("Proper exception");
  throw FormatException("Format error");
  throw StateError("Invalid state");
}
```

> **📘 Python Note:** Like Python's `raise`. Can throw any object, but should throw Exception types.

### Rethrow

```dart
void processRequest(String request) {
  try {
    validateRequest(request);
  } catch (e) {
    print("Logging error: $e");
    rethrow;  // Rethrow to caller
  }
}

void validateRequest(String request) {
  if (request.isEmpty) {
    throw ArgumentError("Request cannot be empty");
  }
}

// Usage
try {
  processRequest("");
} catch (e) {
  print("Caught rethrown error: $e");
}
```

> **📘 Python Note:** Like Python's bare `raise` statement. Preserves stack trace.

## 📝 Custom Exceptions

### Creating Custom Exception Classes

```dart
// Custom exception class
class ValidationException implements Exception {
  final String message;
  final String field;

  ValidationException(this.message, this.field);

  @override
  String toString() => "ValidationException: $field - $message";
}

class InsufficientFundsException implements Exception {
  final double required;
  final double available;

  InsufficientFundsException(this.required, this.available);

  @override
  String toString() {
    return "InsufficientFundsException: Required \$$required, but only \$$available available";
  }
}

// Usage
class BankAccount {
  double balance;

  BankAccount(this.balance);

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ValidationException("Amount must be positive", "amount");
    }
    if (amount > balance) {
      throw InsufficientFundsException(amount, balance);
    }
    balance -= amount;
    print("Withdrew: \$$amount, Balance: \$$balance");
  }
}

// Test
void test() {
  var account = BankAccount(100);

  try {
    account.withdraw(50);   // OK
    account.withdraw(100);  // InsufficientFundsException
  } on ValidationException catch (e) {
    print("Validation error: ${e.message} in ${e.field}");
  } on InsufficientFundsException catch (e) {
    print("Insufficient funds: ${e.toString()}");
  }
}
```

> **📘 Python Note:** Similar to creating custom exception classes in Python by inheriting from Exception.

## 📝 Error vs Exception

```dart
// Exceptions - can be caught and handled
void throwException() {
  throw Exception("This is an exception");
}

// Errors - programming errors, usually shouldn't catch
void throwError() {
  throw Error();  // Don't catch these!
  // throw ArgumentError();
  // throw StateError();
}

// Generally, catch Exceptions, not Errors
try {
  throwException();
} on Exception catch (e) {
  print("Caught exception: $e");
}

// Errors indicate bugs in your code
// Let them crash and fix the bug!
```

> **📘 Python Note:** Dart distinguishes between Error (programming bugs) and Exception (runtime conditions). In Python, both are exceptions.

## 📝 Practical Patterns

### Safe Parsing

```dart
int? safeParseInt(String input) {
  try {
    return int.parse(input);
  } on FormatException {
    return null;
  }
}

// Better - use built-in tryParse
var number = int.tryParse("123");  // Returns int or null
print(number);  // 123

number = int.tryParse("abc");
print(number);  // null
```

### Retry Logic

```dart
T retry<T>(T Function() operation, {int attempts = 3}) {
  var lastError;

  for (var i = 0; i < attempts; i++) {
    try {
      return operation();
    } catch (e) {
      lastError = e;
      if (i < attempts - 1) {
        print("Attempt ${i + 1} failed, retrying...");
      }
    }
  }

  throw Exception("Failed after $attempts attempts: $lastError");
}

// Usage
var result = retry(() {
  // Simulated flaky operation
  if (DateTime.now().millisecond % 2 == 0) {
    throw Exception("Random failure");
  }
  return "Success";
}, attempts: 5);
```

### Resource Management

```dart
class Resource {
  bool _isOpen = false;

  void open() {
    print("Opening resource");
    _isOpen = true;
  }

  void use() {
    if (!_isOpen) {
      throw StateError("Resource not opened");
    }
    print("Using resource");
  }

  void close() {
    print("Closing resource");
    _isOpen = false;
  }
}

void useResource() {
  var resource = Resource();

  try {
    resource.open();
    resource.use();
  } catch (e) {
    print("Error: $e");
  } finally {
    resource.close();  // Always close
  }
}
```

## ✍️ Exercises

### Exercise 1: Basic Exceptions

👉 **[Start Exercise 1: Basic Exceptions](exercises/1-basic-exceptions.md)**

### Exercise 2: Custom Exceptions

👉 **[Start Exercise 2: Custom Exceptions](exercises/2-custom-exceptions.md)**

### Exercise 3: Error Handling Challenges

👉 **[Start Exercise 3: Error Handling Challenges](exercises/3-error-handling-challenges.md)**

## 📚 What You Learned

✅ Try/catch/finally blocks
✅ Specific exception handling with on
✅ Throwing and rethrowing exceptions
✅ Custom exception classes
✅ Error vs Exception
✅ Practical error handling patterns

## 🔜 Next Steps

**Next tutorial: 9-Async-Programming**

## 💡 Key Takeaways for Python Developers

1. **Syntax**: Use `catch` not `except`, braces not indentation
2. **On Keyword**: Cleaner than Python's except for specific types
3. **Rethrow**: Use `rethrow` not bare `raise`
4. **Error vs Exception**: Errors are bugs, Exceptions are runtime conditions
5. **Stack Traces**: Second parameter in catch block
6. **Try-Parse**: Built-in tryParse methods return null on error

## 🆘 Common Pitfalls

### Pitfall 1: Catching Error

```dart
// ❌ Wrong - don't catch Error
try {
  // code
} catch (e) {  // Catches everything including Errors
  // ...
}

// ✅ Better - catch Exception
try {
  // code
} on Exception catch (e) {
  // Only catches exceptions
}
```

### Pitfall 2: Swallowing Exceptions

```dart
// ❌ Wrong - silent failure
try {
  riskyOperation();
} catch (e) {
  // Nothing - error is lost!
}

// ✅ Better - at least log it
try {
  riskyOperation();
} catch (e) {
  print("Error occurred: $e");
  // Or rethrow if can't handle
  rethrow;
}
```

## 📖 Additional Resources

- [Dart Language Tour - Exceptions](https://dart.dev/language/error-handling)
- [Effective Dart - Error Handling](https://dart.dev/effective-dart/error-handling)

---

Ready? Start with **[Exercise 1: Basic Exceptions](exercises/1-basic-exceptions.md)**!
