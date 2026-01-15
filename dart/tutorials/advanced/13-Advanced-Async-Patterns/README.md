# Tutorial 13: Advanced Async Patterns

Welcome to advanced asynchronous programming! This tutorial covers sophisticated async patterns, stream transformations, reactive programming, and advanced error handling in async code.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master Stream transformations and controllers
- Implement reactive programming patterns
- Use StreamTransformer for complex operations
- Handle backpressure in streams
- Combine multiple async operations
- Implement retry and timeout patterns
- Use Zone for async error handling and context

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Async stream | `async for x in stream:` | `await for (var x in stream)` |
| Stream creation | `async def generator():` | `Stream<T>.periodic()` or `async*` |
| Stream transformation | Generator expressions | `stream.map()`, `stream.where()` |
| Reactive programming | RxPY library | Built-in Stream API |
| Backpressure | `asyncio.Queue` with maxsize | `StreamController` with `onListen` |
| Timeout | `asyncio.wait_for()` | `.timeout()` method |
| Retry logic | Manual or libraries | Manual or `retry` package |

> **📘 Python Note:** Dart's Stream API is more powerful and integrated than Python's async generators. Think of Streams as a first-class citizen, not just a library feature.

## 📝 Stream Controllers

Create and control custom streams:

```dart
import 'dart:async';

void main() async {
  // Single-subscription stream controller
  var controller = StreamController<int>();
  
  // Listen to the stream
  controller.stream.listen(
    (data) => print('Received: $data'),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Stream closed'),
  );
  
  // Add data
  controller.add(1);
  controller.add(2);
  controller.add(3);
  
  // Add error
  controller.addError('Something went wrong');
  
  // Close stream
  await controller.close();
}
```

### Broadcast Streams

Multiple listeners on one stream:

```dart
void main() async {
  // Broadcast controller allows multiple listeners
  var controller = StreamController<String>.broadcast();
  
  // First listener
  controller.stream.listen((data) {
    print('Listener 1: $data');
  });
  
  // Second listener
  controller.stream.listen((data) {
    print('Listener 2: $data');
  });
  
  // Both listeners receive the data
  controller.add('Hello');
  controller.add('World');
  
  await controller.close();
}
```

## 📝 Stream Transformations

Transform streams with powerful operators:

```dart
import 'dart:async';

void main() async {
  // Create a stream
  var stream = Stream.periodic(
    Duration(milliseconds: 100),
    (count) => count,
  ).take(10);
  
  // Chain transformations
  await stream
    .where((n) => n % 2 == 0)        // Filter even numbers
    .map((n) => n * 2)                // Double them
    .map((n) => 'Value: $n')          // Convert to string
    .forEach(print);                   // Print each
}
```

### Common Stream Operators

```dart
Future<void> demonstrateOperators() async {
  var numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  
  // map - Transform each element
  await numbers.map((n) => n * 2).forEach(print);
  
  // where - Filter elements
  numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  await numbers.where((n) => n > 3).forEach(print);
  
  // expand - Flatten
  numbers = Stream.fromIterable([1, 2, 3]);
  await numbers.expand((n) => [n, n * 10]).forEach(print);
  
  // take - Limit elements
  var infinite = Stream.periodic(Duration(milliseconds: 10));
  await infinite.take(5).forEach(print);
  
  // skip - Skip elements
  numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  await numbers.skip(2).forEach(print);
  
  // distinct - Remove duplicates
  var dupes = Stream.fromIterable([1, 2, 2, 3, 3, 3, 4]);
  await dupes.distinct().forEach(print);
}
```

## 📝 Custom StreamTransformer

Create reusable stream transformations:

```dart
import 'dart:async';

// Custom transformer that debounces events
class DebounceTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;
  
  DebounceTransformer(this.duration);
  
  @override
  Stream<T> bind(Stream<T> stream) {
    Timer? timer;
    T? lastEvent;
    late StreamController<T> controller;
    
    controller = StreamController<T>(
      onListen: () {
        stream.listen(
          (event) {
            lastEvent = event;
            timer?.cancel();
            timer = Timer(duration, () {
              controller.add(lastEvent as T);
            });
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () => timer?.cancel(),
    );
    
    return controller.stream;
  }
}

// Extension method for convenience
extension StreamDebounce<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    return transform(DebounceTransformer(duration));
  }
}

void main() async {
  var controller = StreamController<String>();
  
  // Use custom transformer
  controller.stream
    .debounce(Duration(milliseconds: 300))
    .listen((value) => print('Debounced: $value'));
  
  // Rapid events - only last one emits
  controller.add('a');
  await Future.delayed(Duration(milliseconds: 100));
  controller.add('b');
  await Future.delayed(Duration(milliseconds: 100));
  controller.add('c');
  
  await Future.delayed(Duration(milliseconds: 500));
  controller.close();
}
```

## 📝 Combining Streams

Merge and combine multiple streams:

```dart
import 'dart:async';

void main() async {
  // Manual merge - Combine multiple streams
  var stream1 = Stream.periodic(Duration(milliseconds: 100), (i) => 'A$i').take(5);
  var stream2 = Stream.periodic(Duration(milliseconds: 150), (i) => 'B$i').take(5);
  
  // Events from both streams interleaved (manual implementation)
  await mergeStreams([stream1, stream2]).forEach(print);
  
  // Zip streams - pair corresponding elements
  await zipStreams();
  
  // Switch to latest stream
  await switchStream();
}

// Helper function to merge streams
Stream<T> mergeStreams<T>(List<Stream<T>> streams) {
  var controller = StreamController<T>();
  var remaining = streams.length;
  
  for (var stream in streams) {
    stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: () {
        remaining--;
        if (remaining == 0) {
          controller.close();
        }
      },
    );
  }
  
  return controller.stream;
}

Future<void> zipStreams() async {
  var numbers = Stream.fromIterable([1, 2, 3]);
  var letters = Stream.fromIterable(['a', 'b', 'c']);
  
  // Manually zip (Dart doesn't have built-in zip)
  var controller = StreamController<String>();
  var numList = await numbers.toList();
  var letterList = await letters.toList();
  
  for (var i = 0; i < numList.length && i < letterList.length; i++) {
    controller.add('${numList[i]}-${letterList[i]}');
  }
  controller.close();
  
  await controller.stream.forEach(print);
}

Future<void> switchStream() async {
  var controller = StreamController<int>();
  var switcher = StreamController<Stream<int>>();
  
  // Switch to the latest stream
  var switched = switcher.stream.asyncExpand((stream) => stream);
  
  switched.listen(print);
  
  // Emit first stream
  switcher.add(Stream.fromIterable([1, 2, 3]));
  await Future.delayed(Duration(milliseconds: 100));
  
  // Switch to second stream (first stream canceled)
  switcher.add(Stream.fromIterable([10, 20, 30]));
}
```

## 📝 Backpressure Handling

Handle fast producers with slow consumers:

```dart
import 'dart:async';

// Producer with backpressure
class BackpressureController<T> {
  final StreamController<T> _controller;
  final int _bufferSize;
  final List<T> _buffer = [];
  
  BackpressureController({int bufferSize = 10})
    : _bufferSize = bufferSize,
      _controller = StreamController<T>();
  
  Stream<T> get stream => _controller.stream;
  
  Future<void> add(T event) async {
    if (_buffer.length >= _bufferSize) {
      // Buffer full, wait for space
      await Future.delayed(Duration(milliseconds: 10));
    }
    
    _buffer.add(event);
    _controller.add(event);
    
    // Remove from buffer after adding
    Future.delayed(Duration(milliseconds: 1)).then((_) {
      _buffer.remove(event);
    });
  }
  
  Future<void> close() => _controller.close();
}

void main() async {
  var controller = BackpressureController<int>(bufferSize: 5);
  
  // Fast producer
  Future.delayed(Duration.zero, () async {
    for (var i = 0; i < 20; i++) {
      await controller.add(i);
      print('Produced: $i');
    }
    await controller.close();
  });
  
  // Slow consumer
  await controller.stream.asyncMap((value) async {
    await Future.delayed(Duration(milliseconds: 50));
    print('Consumed: $value');
    return value;
  }).drain();
}
```

## 📝 Retry and Timeout Patterns

Handle failures gracefully:

```dart
import 'dart:async';

// Retry with exponential backoff
Future<T> retryWithBackoff<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  var delay = initialDelay;
  
  for (var i = 0; i < maxRetries; i++) {
    try {
      return await operation();
    } catch (e) {
      if (i == maxRetries - 1) {
        rethrow;
      }
      
      print('Attempt ${i + 1} failed, retrying in ${delay.inSeconds}s...');
      await Future.delayed(delay);
      delay *= 2; // Exponential backoff
    }
  }
  
  throw StateError('Should not reach here');
}

// Timeout with fallback
Future<T> withTimeout<T>(
  Future<T> future,
  Duration timeout, {
  T? fallback,
}) async {
  try {
    return await future.timeout(timeout);
  } on TimeoutException {
    if (fallback != null) {
      return fallback;
    }
    rethrow;
  }
}

// Example usage
Future<void> main() async {
  // Retry example
  try {
    var result = await retryWithBackoff(() async {
      print('Attempting operation...');
      // Simulate random failure
      if (DateTime.now().millisecond % 3 != 0) {
        throw Exception('Random failure');
      }
      return 'Success!';
    });
    print('Result: $result');
  } catch (e) {
    print('Failed after retries: $e');
  }
  
  // Timeout example
  var result = await withTimeout(
    Future.delayed(Duration(seconds: 5), () => 'Done'),
    Duration(seconds: 2),
    fallback: 'Timed out, using fallback',
  );
  print('Result: $result');
}
```

## 📝 Zone for Async Context

Use Zone to handle async errors and maintain context:

```dart
import 'dart:async';

void main() {
  // Zone with custom error handling
  runZonedGuarded(() async {
    // All async errors in this zone are caught
    Future.delayed(Duration(milliseconds: 100), () {
      throw Exception('Async error!');
    });
    
    // Normal async code
    await Future.delayed(Duration(milliseconds: 50));
    print('This still runs');
    
  }, (error, stack) {
    print('Caught async error: $error');
  });
  
  // Zone with custom values
  var zone = Zone.current.fork(
    zoneValues: {
      #userId: '12345',
      #requestId: 'abc-def-ghi',
    },
  );
  
  zone.run(() {
    // Access zone values
    var userId = Zone.current[#userId];
    print('User ID: $userId');
  });
}
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **stream_transformers.dart** - Custom stream transformations
2. **reactive_patterns.dart** - Reactive programming patterns
3. **advanced_async.dart** - Complex async scenarios

## 📚 Key Takeaways

1. **StreamController:** Create custom streams with fine control
2. **Broadcast Streams:** Multiple listeners with `.broadcast()`
3. **Transformations:** Chain `.map()`, `.where()`, `.expand()`, etc.
4. **Custom Transformers:** Extend `StreamTransformerBase` for reusable logic
5. **Backpressure:** Handle fast producers with buffer limits
6. **Retry/Timeout:** Implement resilient async operations
7. **Zone:** Manage async context and errors globally

## 🔗 Next Steps

After mastering advanced async patterns, move on to:
- **Tutorial 14:** Extension Methods and Mixins
- **Tutorial 15:** Code Generation and Annotations

---

**Practice these patterns to build robust async applications!** 🎯✨
