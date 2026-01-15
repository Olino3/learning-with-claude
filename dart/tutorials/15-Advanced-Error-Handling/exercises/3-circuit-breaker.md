# Exercise 3: Circuit Breaker Pattern

Implement a circuit breaker to prevent cascading failures.

## 📝 Requirements

Create `CircuitBreaker` class with:
1. Closed, Open, Half-Open states
2. Failure threshold before opening
3. Timeout before trying half-open
4. Success threshold to close again

## 🎯 Example

```dart
void main() async {
  var breaker = CircuitBreaker(
    failureThreshold: 3,
    timeout: Duration(seconds: 30),
  );
  
  var result = await breaker.execute(() => callService());
}
```
