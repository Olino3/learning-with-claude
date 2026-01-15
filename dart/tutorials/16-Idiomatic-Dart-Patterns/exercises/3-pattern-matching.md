# Exercise 3: Pattern Matching with Sealed Classes

Use Dart 3.0 pattern matching for type-safe state handling.

## 📝 Requirements

1. Create sealed class hierarchy for API responses
2. Use switch expressions for pattern matching
3. Exhaustive case handling
4. Destructuring for data extraction

## 🎯 Example

```dart
sealed class ApiResponse<T> {}
class Success<T> extends ApiResponse<T> {
  final T data;
  Success(this.data);
}
class Error<T> extends ApiResponse<T> {
  final String message;
  Error(this.message);
}
class Loading<T> extends ApiResponse<T> {}

void main() {
  var response = Success('data');
  var result = switch (response) {
    Success(data: var d) => 'Got: $d',
    Error(message: var m) => 'Error: $m',
    Loading() => 'Loading...',
  };
}
```
