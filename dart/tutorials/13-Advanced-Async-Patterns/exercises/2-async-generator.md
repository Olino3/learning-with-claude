# Exercise 2: Async Data Generator

Create async generators for streaming data.

## 📝 Requirements

Implement:
1. `Stream<int> countUp(int max)` - Count from 0 to max with delays
2. `Stream<String> readLinesAsync(String filename)` - Read file line by line
3. `Stream<int> fibonacci()` - Generate infinite Fibonacci sequence

## 🎯 Example

```dart
void main() async {
  await for (var n in countUp(5)) {
    print(n);  // 0, 1, 2, 3, 4, 5 (with delays)
  }
}
```
