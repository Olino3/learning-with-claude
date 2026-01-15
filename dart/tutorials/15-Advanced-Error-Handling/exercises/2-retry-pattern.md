# Exercise 2: Retry Pattern with Exponential Backoff

Implement a robust retry mechanism.

## 📝 Requirements

Create `retry<T>` function that:
1. Retries failed operations
2. Uses exponential backoff
3. Has configurable max attempts
4. Supports custom retry conditions

## 🎯 Example

```dart
void main() async {
  var result = await retry(
    () => fetchDataFromAPI(),
    maxAttempts: 3,
    backoff: Duration(seconds: 1),
    retryIf: (e) => e is NetworkException,
  );
}
```
