# Tutorial 17: Performance Optimization

Welcome to Dart performance optimization! This tutorial covers profiling, benchmarking, memory management, and optimization techniques for high-performance Dart applications.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Profile Dart applications effectively
- Use the Dart DevTools for performance analysis
- Optimize memory usage and avoid leaks
- Benchmark code properly
- Understand JIT vs AOT compilation
- Apply lazy evaluation and caching
- Optimize async code performance
- Use const and final effectively

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Profiling | `cProfile`, `line_profiler` | Dart DevTools, Observatory |
| Benchmarking | `timeit` module | `Benchmark` class |
| Memory profiling | `memory_profiler` | DevTools memory profiler |
| JIT compilation | PyPy | Dart VM (JIT mode) |
| AOT compilation | Cython, Nuitka | Dart AOT compilation |
| Lazy evaluation | Generators | `Iterable.lazy`, streams |
| Memoization | `functools.lru_cache` | Manual caching |

> **📘 Python Note:** Dart has both JIT (development) and AOT (production) compilation, giving you fast development and optimized production code. Unlike Python, Dart's performance is much more predictable.

## 📝 Benchmarking Basics

```dart
import 'dart:math';

// Simple timing
void simpleTimer() {
  var stopwatch = Stopwatch()..start();
  
  // Code to measure
  var sum = 0;
  for (var i = 0; i < 1000000; i++) {
    sum += i;
  }
  
  stopwatch.stop();
  print('Elapsed: ${stopwatch.elapsedMilliseconds}ms');
}

// Better benchmarking with warmup
int benchmark(String name, int Function() operation, {int iterations = 1000}) {
  // Warmup phase
  for (var i = 0; i < 10; i++) {
    operation();
  }
  
  // Actual measurement
  var stopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    operation();
  }
  stopwatch.stop();
  
  var avgMicros = stopwatch.elapsedMicroseconds ~/ iterations;
  print('$name: ${avgMicros}μs average');
  return avgMicros;
}

void main() {
  // Compare approaches
  benchmark('List literal', () {
    var list = [1, 2, 3, 4, 5];
    return list.length;
  });
  
  benchmark('List.generate', () {
    var list = List.generate(5, (i) => i + 1);
    return list.length;
  });
}
```

## 📝 Memory Optimization

```dart
// BAD: Creating unnecessary objects
String badStringConcat(List<String> parts) {
  var result = '';
  for (var part in parts) {
    result += part; // Creates new string each time!
  }
  return result;
}

// GOOD: Use StringBuffer
String goodStringConcat(List<String> parts) {
  var buffer = StringBuffer();
  for (var part in parts) {
    buffer.write(part);
  }
  return buffer.toString();
}

// BAD: Creating list on every access
class BadCache {
  List<int> get data {
    return List.generate(1000, (i) => i); // New list every time!
  }
}

// GOOD: Cache the result
class GoodCache {
  List<int>? _cachedData;
  
  List<int> get data {
    return _cachedData ??= List.generate(1000, (i) => i);
  }
}

// Use const where possible
class Config {
  // BAD: New list each time
  static List<String> get badOptions => ['a', 'b', 'c'];
  
  // GOOD: Compile-time constant
  static const List<String> goodOptions = ['a', 'b', 'c'];
  
  // GOOD: Const constructor
  static const defaultConfig = Config._internal();
  const Config._internal();
}
```

## 📝 Lazy Evaluation

```dart
// Use lazy iterables
void lazyEvaluation() {
  // BAD: Processes entire list immediately
  var badResult = List.generate(1000000, (i) => i)
    .where((n) => n % 2 == 0)
    .map((n) => n * 2)
    .take(10)
    .toList();
  
  // GOOD: Lazy evaluation, only processes 10 items
  var goodResult = Iterable.generate(1000000, (i) => i)
    .where((n) => n % 2 == 0)
    .map((n) => n * 2)
    .take(10)
    .toList();
}

// Lazy streams for async data
Stream<int> generateLazy(int count) async* {
  for (var i = 0; i < count; i++) {
    // Expensive computation
    await Future.delayed(Duration(milliseconds: 1));
    yield i;
  }
}

void main() async {
  // Only generates 5 items
  await generateLazy(1000000).take(5).forEach(print);
}
```

## 📝 Caching Patterns

```dart
// Simple memoization
class Fibonacci {
  final Map<int, int> _cache = {};
  
  int calculate(int n) {
    if (n <= 1) return n;
    return _cache.putIfAbsent(
      n,
      () => calculate(n - 1) + calculate(n - 2),
    );
  }
}

// LRU Cache implementation
class LRUCache<K, V> {
  final int maxSize;
  final Map<K, V> _cache = {};
  final List<K> _accessOrder = [];
  
  LRUCache(this.maxSize);
  
  V? get(K key) {
    if (!_cache.containsKey(key)) return null;
    
    // Move to end (most recently used)
    _accessOrder.remove(key);
    _accessOrder.add(key);
    
    return _cache[key];
  }
  
  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _accessOrder.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove least recently used
      var oldest = _accessOrder.removeAt(0);
      _cache.remove(oldest);
    }
    
    _cache[key] = value;
    _accessOrder.add(key);
  }
}

void main() {
  var cache = LRUCache<String, int>(3);
  cache.put('a', 1);
  cache.put('b', 2);
  cache.put('c', 3);
  cache.put('d', 4); // 'a' is evicted
  
  print(cache.get('a')); // null
  print(cache.get('b')); // 2
}
```

## 📝 Async Performance

```dart
import 'dart:async';
import 'dart:isolate';

// BAD: Sequential async operations
Future<void> badAsync() async {
  var result1 = await fetchData(1);
  var result2 = await fetchData(2);
  var result3 = await fetchData(3);
  // Takes 3 seconds total
}

// GOOD: Parallel async operations
Future<void> goodAsync() async {
  var results = await Future.wait([
    fetchData(1),
    fetchData(2),
    fetchData(3),
  ]);
  // Takes 1 second total (if they run in parallel)
}

Future<String> fetchData(int id) async {
  await Future.delayed(Duration(seconds: 1));
  return 'Data $id';
}

// Use compute for CPU-intensive work
Future<void> cpuIntensiveExample() async {
  // BAD: Blocks event loop
  var badResult = expensiveComputation(1000000);
  
  // GOOD: Runs in isolate
  var goodResult = await compute(expensiveComputation, 1000000);
}

int expensiveComputation(int n) {
  var sum = 0;
  for (var i = 0; i < n; i++) {
    sum += i * i;
  }
  return sum;
}
```

## 📝 Collection Optimization

```dart
// Choose the right collection type
void collectionOptimization() {
  // List: Fast indexed access, slow contains
  var list = <int>[1, 2, 3, 4, 5];
  list[2]; // O(1)
  list.contains(3); // O(n)
  
  // Set: Fast membership test
  var set = <int>{1, 2, 3, 4, 5};
  set.contains(3); // O(1)
  
  // Map: Fast key lookup
  var map = <String, int>{'a': 1, 'b': 2};
  map['a']; // O(1)
}

// Preallocate when size is known
void preallocation() {
  // BAD: List grows dynamically
  var badList = <int>[];
  for (var i = 0; i < 1000; i++) {
    badList.add(i);
  }
  
  // GOOD: Preallocate
  var goodList = List<int>.filled(1000, 0);
  for (var i = 0; i < 1000; i++) {
    goodList[i] = i;
  }
  
  // BETTER: Use List.generate
  var betterList = List.generate(1000, (i) => i);
}

// Use views instead of copies
void useViews() {
  var bigList = List.generate(1000000, (i) => i);
  
  // BAD: Creates copy
  var badSublist = bigList.sublist(100, 200);
  
  // GOOD: Creates view (when possible)
  var goodView = bigList.skip(100).take(100);
}
```

## 📝 JIT vs AOT Compilation

```bash
# Development (JIT - fast startup, adaptive optimization)
dart run my_app.dart

# Production (AOT - slower startup, faster execution, smaller size)
dart compile exe my_app.dart -o my_app

# Benchmark difference
dart run benchmark.dart              # JIT
dart compile exe benchmark.dart && ./benchmark  # AOT
```

## 📝 DevTools Profiling

```dart
// Add timing marks for DevTools
import 'dart:developer' as developer;

void profiledFunction() {
  developer.Timeline.startSync('MyOperation');
  
  // Your code here
  expensiveOperation();
  
  developer.Timeline.finishSync();
}

void expensiveOperation() {
  developer.Timeline.startSync('SubOperation');
  
  // Do work
  for (var i = 0; i < 1000000; i++) {
    // ...
  }
  
  developer.Timeline.finishSync();
}

// View in DevTools: dart devtools
```

## 📝 Best Practices

```dart
// 1. Use const constructors
class Point {
  final int x, y;
  const Point(this.x, this.y);
}

const origin = Point(0, 0); // Compile-time constant

// 2. Use final for immutable data
class User {
  final String id;
  final String name;
  
  User(this.id, this.name);
}

// 3. Avoid string concatenation in loops
void buildString(List<String> parts) {
  var buffer = StringBuffer();
  for (var part in parts) {
    buffer.write(part);
  }
  return buffer.toString();
}

// 4. Use sync generators for large sequences
Iterable<int> countTo(int n) sync* {
  for (var i = 0; i <= n; i++) {
    yield i;
  }
}

// 5. Cache expensive computations
class ExpensiveCalculator {
  final Map<String, int> _cache = {};
  
  int calculate(String input) {
    return _cache.putIfAbsent(input, () {
      // Expensive calculation
      return input.length * 42;
    });
  }
}
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **benchmarking.dart** - Benchmark different approaches
2. **memory_optimization.dart** - Optimize memory usage
3. **profiling_practice.dart** - Profile and optimize code

## 📚 Key Takeaways

1. **Benchmark:** Always measure before optimizing
2. **DevTools:** Use profiling tools to find bottlenecks
3. **Memory:** Avoid creating unnecessary objects
4. **Const/Final:** Use for immutable data
5. **Lazy Evaluation:** Process only what you need
6. **Caching:** Memoize expensive computations
7. **Async:** Parallelize independent operations
8. **Collections:** Choose the right data structure
9. **JIT vs AOT:** Understand compilation modes
10. **Profile First:** Don't optimize prematurely

## 🔗 Resources

- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Performance Best Practices](https://dart.dev/guides/language/performance)
- [Effective Dart](https://dart.dev/effective-dart)

---

**Measure, optimize, and profile for maximum performance!** 🎯✨
