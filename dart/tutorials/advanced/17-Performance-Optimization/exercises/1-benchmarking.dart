#!/usr/bin/env dart
// Tutorial 17: Performance Optimization Practice

void main() {
  print("=" * 70);
  print("PERFORMANCE OPTIMIZATION PRACTICE");
  print("=" * 70);

  // Example 1: Simple Benchmarking
  print("\nExample 1: Benchmarking");
  simpleTimer();

  // Example 2: String Concatenation
  print("\nExample 2: String Concatenation Comparison");
  benchmarkStringConcat();

  // Example 3: Lazy Evaluation
  print("\nExample 3: Lazy Evaluation");
  lazyEvaluationExample();

  // Example 4: Caching
  print("\nExample 4: Caching");
  cachingExample();

  // Checkpoint
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  // TODO: Challenge 1 - Implement LRU cache
  // TODO: Challenge 2 - Benchmark list vs set for lookups
  // TODO: Challenge 3 - Optimize a slow function
}

void simpleTimer() {
  var stopwatch = Stopwatch()..start();
  
  var sum = 0;
  for (var i = 0; i < 1000000; i++) {
    sum += i;
  }
  
  stopwatch.stop();
  print('Sum calculated in ${stopwatch.elapsedMilliseconds}ms');
}

void benchmarkStringConcat() {
  var parts = List.generate(1000, (i) => 'part$i');
  
  // Bad approach
  var sw1 = Stopwatch()..start();
  var result1 = '';
  for (var part in parts) {
    result1 += part;
  }
  sw1.stop();
  print('String concat: ${sw1.elapsedMicroseconds}μs');
  
  // Good approach
  var sw2 = Stopwatch()..start();
  var buffer = StringBuffer();
  for (var part in parts) {
    buffer.write(part);
  }
  var result2 = buffer.toString();
  sw2.stop();
  print('StringBuffer: ${sw2.elapsedMicroseconds}μs');
}

void lazyEvaluationExample() {
  // Lazy evaluation
  var result = Iterable.generate(1000000)
    .where((n) => n % 2 == 0)
    .take(5)
    .toList();
  
  print('First 5 even numbers: $result');
}

void cachingExample() {
  var fib = Fibonacci();
  
  var sw = Stopwatch()..start();
  print('fib(30) = ${fib.calculate(30)}');
  sw.stop();
  print('First call: ${sw.elapsedMicroseconds}μs');
  
  sw.reset();
  sw.start();
  print('fib(30) = ${fib.calculate(30)}');
  sw.stop();
  print('Cached call: ${sw.elapsedMicroseconds}μs');
}

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
