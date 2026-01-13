# Exercise 3: Function Challenges

Apply all function concepts to solve real-world problems.

## 🎯 Challenges

### Challenge 1: Memoization

Create a memoization wrapper for expensive functions.

```dart
Function memoize<T, R>(R Function(T) fn) {
  var cache = <T, R>{};
  return (T arg) {
    if (!cache.containsKey(arg)) {
      print("Computing for $arg...");
      cache[arg] = fn(arg);
    }
    return cache[arg];
  };
}

// Test it
var fibonacci = memoize((int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
});

print(fibonacci(10));  // Computes once
print(fibonacci(10));  // Cached
```

### Challenge 2: Retry Logic

```dart
T retry<T>(T Function() fn, {int attempts = 3, Duration delay = const Duration(seconds: 1)}) {
  for (var i = 0; i < attempts; i++) {
    try {
      return fn();
    } catch (e) {
      if (i == attempts - 1) rethrow;
      print("Attempt ${i + 1} failed, retrying...");
    }
  }
  throw StateError("Unreachable");
}
```

### Challenge 3: Pipeline

Create a data processing pipeline.

**Create:** `/home/user/learning-with-claude/dart/tutorials/4-Functions/exercises/pipeline.dart`

```dart
void main() {
  var data = [
    {"name": "Alice", "age": 30, "score": 95},
    {"name": "Bob", "age": 25, "score": 67},
    {"name": "Charlie", "age": 35, "score": 88},
    {"name": "David", "age": 28, "score": 72},
  ];

  var result = data
      .where((p) => (p["score"] as int) >= 70)
      .map((p) => p["name"])
      .toList();

  print("Passing students: $result");
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/4-Functions/exercises/pipeline.dart`

## 🎉 Congratulations!

You've mastered Dart functions! Ready for **Tutorial 5: Collections**.
