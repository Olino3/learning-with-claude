# Tutorial 13: Advanced Async Patterns

Welcome to advanced asynchronous programming in Dart! This tutorial builds on Tutorial 9's async/await fundamentals and explores advanced patterns like custom streams, isolates for parallel processing, and sophisticated stream transformations.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Create custom streams with StreamController
- Transform streams using operators (map, where, expand, etc.)
- Build async generators with `async*` and `yield`
- Control Future completion with Completer
- Use Isolates for true parallel processing
- Manage stream subscriptions and backpressure
- Understand broadcast vs single-subscription streams
- Combine multiple streams effectively

## 🐍➡️🎯 Coming from Python

Python has asyncio for async/await, but Dart's stream system and isolates offer different capabilities:

| Concept | Python | Dart |
|---------|--------|------|
| Custom stream | `async def generator():` with `yield` | `Stream<T>` with `StreamController` |
| Stream transform | Manual iteration or libraries | Built-in `map`, `where`, `expand` |
| Async generator | `async def` with `yield` | `Stream<T>` with `async*` and `yield` |
| Future control | `asyncio.Future.set_result()` | `Completer<T>` |
| Parallel processing | `multiprocessing` module | `Isolate` |
| Backpressure | Manual with queues | Built-in pause/resume |
| Multiple streams | `asyncio.gather()` | `Stream.merge()`, `StreamZip` |
| Broadcast | Manual pub/sub | `StreamController.broadcast()` |

> **📘 Python Note:** Dart's streams are more powerful than Python's async generators. Isolates provide true parallelism unlike asyncio's single-threaded concurrency!

## 📝 StreamController - Creating Custom Streams

### Basic StreamController

```dart
import 'dart:async';

void main() async {
  // Create a StreamController
  final controller = StreamController<int>();
  
  // Listen to the stream
  controller.stream.listen(
    (data) => print('Received: $data'),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Stream closed'),
  );
  
  // Add data to stream
  controller.add(1);
  controller.add(2);
  controller.add(3);
  
  // Add error
  controller.addError('Something went wrong!');
  
  // Close stream
  await Future.delayed(Duration(milliseconds: 100));
  controller.close();
}
```

> **📘 Python Note:** Like creating a custom async generator, but with more control over when data is emitted.

### StreamController with Callbacks

```dart
class TemperatureSensor {
  final StreamController<double> _controller = StreamController<double>();
  Timer? _timer;
  
  // Expose stream publicly
  Stream<double> get temperatureStream => _controller.stream;
  
  void start() {
    // Simulate sensor readings every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final temp = 20 + (timer.tick % 10) * 0.5; // Fake data
      _controller.add(temp);
    });
  }
  
  void stop() {
    _timer?.cancel();
    _controller.close();
  }
}

void main() async {
  final sensor = TemperatureSensor();
  
  // Subscribe to temperature updates
  sensor.temperatureStream.listen(
    (temp) => print('Temperature: ${temp.toStringAsFixed(1)}°C'),
  );
  
  sensor.start();
  
  // Run for 5 seconds
  await Future.delayed(Duration(seconds: 5));
  sensor.stop();
}
```

### StreamController with Backpressure

```dart
class DataProcessor {
  final StreamController<String> _controller = StreamController<String>(
    // Handle backpressure with callbacks
    onListen: () => print('Listener attached'),
    onPause: () => print('Processing paused'),
    onResume: () => print('Processing resumed'),
    onCancel: () => print('Listener cancelled'),
  );
  
  Stream<String> get stream => _controller.stream;
  
  void addData(String data) {
    if (!_controller.isClosed) {
      _controller.add(data);
    }
  }
  
  void close() => _controller.close();
}

void main() async {
  final processor = DataProcessor();
  
  // Listener with manual pause/resume
  final subscription = processor.stream.listen((data) {
    print('Processing: $data');
  });
  
  processor.addData('Item 1');
  processor.addData('Item 2');
  
  // Pause processing
  subscription.pause();
  processor.addData('Item 3'); // Buffered
  
  await Future.delayed(Duration(seconds: 1));
  
  // Resume processing
  subscription.resume();
  
  await Future.delayed(Duration(milliseconds: 100));
  processor.close();
}
```

> **📘 Python Note:** Python's asyncio doesn't have built-in backpressure - you'd implement this manually with queues.

## 📝 Stream Transformations

### Map, Where, and Expand

```dart
import 'dart:async';

void main() async {
  final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  
  // map - Transform each element
  // Python: [x * 2 for x in numbers]
  final doubled = numbers.map((n) => n * 2);
  print('Doubled: ${await doubled.toList()}'); // [2, 4, 6, 8, 10]
  
  // where - Filter elements
  // Python: [x for x in numbers if x % 2 == 0]
  final evens = Stream.fromIterable([1, 2, 3, 4, 5])
      .where((n) => n % 2 == 0);
  print('Evens: ${await evens.toList()}'); // [2, 4]
  
  // expand - Flatten results
  // Python: [y for x in data for y in transform(x)]
  final expanded = Stream.fromIterable([1, 2, 3])
      .expand((n) => [n, n * 10, n * 100]);
  print('Expanded: ${await expanded.toList()}');
  // [1, 10, 100, 2, 20, 200, 3, 30, 300]
}
```

### Chaining Transformations

```dart
Stream<String> processUserInput(Stream<String> input) {
  return input
      .map((s) => s.trim())           // Remove whitespace
      .where((s) => s.isNotEmpty)     // Filter empty strings
      .map((s) => s.toLowerCase())    // Convert to lowercase
      .distinct();                    // Remove duplicates
}

void main() async {
  final controller = StreamController<String>();
  
  // Subscribe to processed stream
  processUserInput(controller.stream).listen(
    (data) => print('Processed: $data'),
  );
  
  // Add test data
  controller.add('  Hello  ');
  controller.add('WORLD');
  controller.add('  ');
  controller.add('hello');  // Duplicate
  controller.add('Dart');
  
  await Future.delayed(Duration(milliseconds: 100));
  controller.close();
}
```

### AsyncMap for Async Transformations

```dart
// Simulate API call
Future<String> fetchUserName(int id) async {
  await Future.delayed(Duration(milliseconds: 100));
  return 'User$id';
}

void main() async {
  final userIds = Stream.fromIterable([1, 2, 3, 4, 5]);
  
  // asyncMap - async transformation of each element
  final userNames = userIds.asyncMap((id) => fetchUserName(id));
  
  await for (var name in userNames) {
    print(name);
  }
}
```

### Reduce and Fold

```dart
void main() async {
  final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  
  // reduce - Combine all elements (same type)
  // Python: functools.reduce(lambda a, b: a + b, numbers)
  final sum = await numbers.reduce((a, b) => a + b);
  print('Sum: $sum'); // 15
  
  // fold - Combine with initial value (can change type)
  // Python: functools.reduce(lambda a, b: a + str(b), numbers, '')
  final concatenated = await Stream.fromIterable([1, 2, 3])
      .fold<String>('', (prev, n) => prev + n.toString());
  print('Concatenated: $concatenated'); // '123'
}
```

## 📝 Async Generators with async* and yield

### Basic Async Generator

```dart
// async* creates a Stream
Stream<int> countStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i; // Emit value to stream
  }
}

void main() async {
  // Consume stream with await for
  // Python: async for x in count_stream(5):
  await for (var number in countStream(5)) {
    print('Count: $number');
  }
}
```

> **📘 Python Note:** Very similar to Python's `async def` with `yield`, but creates a Stream<T> instead of an async generator.

### yield* for Nested Streams

```dart
Stream<int> numbers() async* {
  yield 1;
  yield 2;
  yield 3;
}

Stream<int> moreNumbers() async* {
  yield 0;
  yield* numbers(); // Yield all values from another stream
  yield 4;
}

void main() async {
  final list = await moreNumbers().toList();
  print(list); // [0, 1, 2, 3, 4]
}
```

### Practical Example: File Reader

```dart
import 'dart:io';

// Stream file lines asynchronously
Stream<String> readFileLines(String path) async* {
  final file = File(path);
  
  // Read file line by line
  await for (var line in file.openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())) {
    yield line;
  }
}

// Process log file
Stream<String> parseLogErrors(String logPath) async* {
  await for (var line in readFileLines(logPath)) {
    if (line.contains('ERROR')) {
      yield line;
    }
  }
}

void main() async {
  try {
    await for (var error in parseLogErrors('app.log')) {
      print('Found error: $error');
    }
  } catch (e) {
    print('Error reading file: $e');
  }
}
```

### Fibonacci Stream Generator

```dart
Stream<int> fibonacci() async* {
  int a = 0, b = 1;
  
  while (true) {
    yield a;
    final next = a + b;
    a = b;
    b = next;
    
    // Add delay to prevent infinite loop overwhelming system
    await Future.delayed(Duration(milliseconds: 100));
  }
}

void main() async {
  // Take first 10 Fibonacci numbers
  final firstTen = await fibonacci().take(10).toList();
  print('First 10 Fibonacci: $firstTen');
  // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
}
```

## 📝 Completer - Custom Future Control

### Basic Completer Usage

```dart
import 'dart:async';

// Completer gives you manual control over Future completion
Future<String> fetchDataWithTimeout(Duration timeout) {
  final completer = Completer<String>();
  
  // Simulate async operation
  Future.delayed(Duration(seconds: 2), () {
    completer.complete('Data loaded');
  });
  
  // Set timeout
  Future.delayed(timeout, () {
    if (!completer.isCompleted) {
      completer.completeError('Timeout!');
    }
  });
  
  return completer.future;
}

void main() async {
  try {
    final data = await fetchDataWithTimeout(Duration(seconds: 3));
    print(data); // Data loaded
  } catch (e) {
    print('Error: $e');
  }
  
  try {
    final data = await fetchDataWithTimeout(Duration(seconds: 1));
    print(data);
  } catch (e) {
    print('Error: $e'); // Timeout!
  }
}
```

> **📘 Python Note:** Like `asyncio.Future.set_result()` and `set_exception()` for manual control.

### Completer with Callbacks

```dart
class AsyncButton {
  final Completer<void> _completer = Completer<void>();
  
  Future<void> get clicked => _completer.future;
  
  void onClick() {
    if (!_completer.isCompleted) {
      _completer.complete();
      print('Button clicked!');
    }
  }
}

void main() async {
  final button = AsyncButton();
  
  // Wait for button click
  Future.delayed(Duration(seconds: 2), () {
    button.onClick();
  });
  
  print('Waiting for button click...');
  await button.clicked;
  print('Button was clicked!');
}
```

### Completer for Coordination

```dart
class DataCache<T> {
  T? _data;
  Completer<T>? _loading;
  
  Future<T> get(Future<T> Function() loader) async {
    // Return cached data if available
    if (_data != null) {
      return _data!;
    }
    
    // If already loading, wait for that operation
    if (_loading != null) {
      return _loading!.future;
    }
    
    // Start loading
    _loading = Completer<T>();
    
    try {
      _data = await loader();
      _loading!.complete(_data as T);
      return _data!;
    } catch (e) {
      _loading!.completeError(e);
      rethrow;
    } finally {
      _loading = null;
    }
  }
}

void main() async {
  final cache = DataCache<String>();
  
  // Multiple calls - only one actual load
  final futures = [
    cache.get(() => Future.delayed(Duration(seconds: 1), () => 'Data')),
    cache.get(() => Future.delayed(Duration(seconds: 1), () => 'Data')),
    cache.get(() => Future.delayed(Duration(seconds: 1), () => 'Data')),
  ];
  
  final results = await Future.wait(futures);
  print(results); // All return same cached data
}
```

## 📝 Isolates - True Parallel Processing

### Basic Isolate

```dart
import 'dart:isolate';

// Function to run in separate isolate
void heavyComputation(SendPort sendPort) {
  // Simulate CPU-intensive work
  int sum = 0;
  for (var i = 0; i < 1000000000; i++) {
    sum += i;
  }
  
  // Send result back to main isolate
  sendPort.send(sum);
}

void main() async {
  print('Starting computation...');
  
  // Create receive port for results
  final receivePort = ReceivePort();
  
  // Spawn isolate
  await Isolate.spawn(heavyComputation, receivePort.sendPort);
  
  // Wait for result
  final result = await receivePort.first;
  print('Result: $result');
  
  print('Main isolate was not blocked!');
}
```

> **📘 Python Note:** Unlike Python's asyncio (single-threaded), isolates provide true parallelism like multiprocessing!

### Isolate with Two-Way Communication

```dart
class IsolateWorker {
  late Isolate _isolate;
  late SendPort _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  
  Future<void> start() async {
    _isolate = await Isolate.spawn(_workerFunction, _receivePort.sendPort);
    _sendPort = await _receivePort.first;
  }
  
  Future<int> compute(int n) async {
    final responsePort = ReceivePort();
    _sendPort.send([n, responsePort.sendPort]);
    return await responsePort.first;
  }
  
  void stop() {
    _isolate.kill();
    _receivePort.close();
  }
  
  static void _workerFunction(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) {
      final n = message[0] as int;
      final replyPort = message[1] as SendPort;
      
      // Compute factorial
      int result = 1;
      for (var i = 1; i <= n; i++) {
        result *= i;
      }
      
      replyPort.send(result);
    });
  }
}

void main() async {
  final worker = IsolateWorker();
  await worker.start();
  
  print('Factorial of 5: ${await worker.compute(5)}');   // 120
  print('Factorial of 10: ${await worker.compute(10)}'); // 3628800
  
  worker.stop();
}
```

### Compute Helper (Simplified Isolates)

```dart
import 'dart:isolate';

// Helper function for simple one-off computations
Future<R> compute<Q, R>(R Function(Q) callback, Q message) async {
  final receivePort = ReceivePort();
  
  await Isolate.spawn((message) {
    final args = message as List;
    final callback = args[0] as R Function(Q);
    final input = args[1] as Q;
    final sendPort = args[2] as SendPort;
    
    final result = callback(input);
    sendPort.send(result);
  }, [callback, message, receivePort.sendPort]);
  
  return await receivePort.first;
}

// CPU-intensive function
int calculatePrimes(int max) {
  int count = 0;
  
  for (var i = 2; i <= max; i++) {
    bool isPrime = true;
    for (var j = 2; j * j <= i; j++) {
      if (i % j == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) count++;
  }
  
  return count;
}

void main() async {
  print('Calculating primes...');
  
  // Run in separate isolate - won't block main
  final count = await compute(calculatePrimes, 100000);
  
  print('Primes under 100,000: $count');
}
```

## 📝 Broadcast vs Single-Subscription Streams

### Single-Subscription Streams

```dart
void main() async {
  final controller = StreamController<int>();
  
  // Only one listener allowed
  controller.stream.listen((data) {
    print('Listener 1: $data');
  });
  
  // This would throw an error!
  // controller.stream.listen((data) {
  //   print('Listener 2: $data');
  // });
  
  controller.add(1);
  controller.add(2);
  
  await Future.delayed(Duration(milliseconds: 100));
  controller.close();
}
```

### Broadcast Streams

```dart
void main() async {
  // Broadcast allows multiple listeners
  final controller = StreamController<String>.broadcast();
  
  // First listener
  controller.stream.listen(
    (data) => print('Listener 1: $data'),
  );
  
  // Second listener
  controller.stream.listen(
    (data) => print('Listener 2: $data'),
  );
  
  // Third listener
  controller.stream.listen(
    (data) => print('Listener 3: $data'),
  );
  
  controller.add('Hello');
  controller.add('World');
  
  await Future.delayed(Duration(milliseconds: 100));
  controller.close();
}
```

### Converting to Broadcast

```dart
Stream<int> singleSubscriptionStream() async* {
  yield 1;
  yield 2;
  yield 3;
}

void main() async {
  // Convert single-subscription to broadcast
  final broadcast = singleSubscriptionStream().asBroadcastStream();
  
  // Now multiple listeners work
  broadcast.listen((data) => print('A: $data'));
  broadcast.listen((data) => print('B: $data'));
  
  await Future.delayed(Duration(seconds: 1));
}
```

> **📘 Python Note:** Python doesn't have this distinction - you'd implement pub/sub manually.

## 📝 Combining Multiple Streams

### Stream.merge() - Combine Streams

```dart
import 'dart:async';

Stream<int> stream1() async* {
  yield 1;
  await Future.delayed(Duration(milliseconds: 100));
  yield 2;
}

Stream<int> stream2() async* {
  await Future.delayed(Duration(milliseconds: 50));
  yield 10;
  await Future.delayed(Duration(milliseconds: 100));
  yield 20;
}

void main() async {
  // Note: Stream.merge is from package:async
  // For this example, we'll use a manual approach
  final controller = StreamController<int>();
  
  stream1().listen(controller.add);
  stream2().listen(controller.add,
    onDone: () => controller.close());
  
  await for (var value in controller.stream) {
    print('Merged: $value');
  }
  // Output order depends on timing
}
```

### StreamZip - Combine Pairwise

```dart
void main() async {
  final stream1 = Stream.fromIterable([1, 2, 3]);
  final stream2 = Stream.fromIterable(['a', 'b', 'c']);
  
  // Zip combines corresponding elements
  // Note: Requires import 'package:async/async.dart';
  // Manual implementation:
  final zipped = stream1.asyncExpand((num) async* {
    await for (var letter in stream2) {
      yield '$num$letter';
      break;
    }
  });
  
  // Better approach using Future.wait with toList
  final list1 = await Stream.fromIterable([1, 2, 3]).toList();
  final list2 = await Stream.fromIterable(['a', 'b', 'c']).toList();
  
  for (var i = 0; i < list1.length; i++) {
    print('${list1[i]}${list2[i]}');
  }
  // 1a, 2b, 3c
}
```

### Custom Stream Combiner

```dart
class StreamCombiner<T> {
  final List<Stream<T>> _streams;
  final StreamController<T> _controller = StreamController<T>();
  
  StreamCombiner(this._streams);
  
  Stream<T> get combined {
    var activeStreams = _streams.length;
    
    for (var stream in _streams) {
      stream.listen(
        (data) => _controller.add(data),
        onError: (error) => _controller.addError(error),
        onDone: () {
          activeStreams--;
          if (activeStreams == 0) {
            _controller.close();
          }
        },
      );
    }
    
    return _controller.stream;
  }
}

void main() async {
  final combiner = StreamCombiner<int>([
    Stream.fromIterable([1, 2, 3]),
    Stream.fromIterable([10, 20, 30]),
    Stream.fromIterable([100, 200, 300]),
  ]);
  
  await for (var value in combiner.combined) {
    print(value);
  }
}
```

## 📝 Practical Applications

### 1. Real-Time Data Pipeline

```dart
class DataPipeline<T> {
  final StreamController<T> _input = StreamController<T>();
  late final Stream<T> _output;
  
  DataPipeline({
    required T Function(T) transform,
    required bool Function(T) filter,
    int bufferSize = 10,
  }) {
    _output = _input.stream
        .where(filter)
        .map(transform)
        .asBroadcastStream();
  }
  
  void add(T data) => _input.add(data);
  
  Stream<T> get stream => _output;
  
  void close() => _input.close();
}

void main() async {
  final pipeline = DataPipeline<int>(
    transform: (n) => n * 2,
    filter: (n) => n > 5,
  );
  
  // Multiple consumers
  pipeline.stream.listen((n) => print('Consumer 1: $n'));
  pipeline.stream.listen((n) => print('Consumer 2: $n'));
  
  // Add data
  for (var i = 1; i <= 10; i++) {
    pipeline.add(i);
  }
  
  await Future.delayed(Duration(milliseconds: 100));
  pipeline.close();
}
```

### 2. Async Queue with Rate Limiting

```dart
class RateLimitedQueue<T> {
  final Duration _delay;
  final StreamController<T> _controller = StreamController<T>();
  
  RateLimitedQueue({required Duration delay}) : _delay = delay;
  
  Stream<T> get stream async* {
    await for (var item in _controller.stream) {
      yield item;
      await Future.delayed(_delay);
    }
  }
  
  void add(T item) => _controller.add(item);
  void close() => _controller.close();
}

void main() async {
  final queue = RateLimitedQueue<String>(
    delay: Duration(milliseconds: 500),
  );
  
  queue.stream.listen((item) {
    print('${DateTime.now().second}s: Processing $item');
  });
  
  queue.add('Task 1');
  queue.add('Task 2');
  queue.add('Task 3');
  
  await Future.delayed(Duration(seconds: 3));
  queue.close();
}
```

### 3. WebSocket-like Event System

```dart
class EventBus {
  final Map<String, StreamController> _controllers = {};
  
  Stream<T> on<T>(String eventName) {
    _controllers[eventName] ??= StreamController<T>.broadcast();
    return (_controllers[eventName] as StreamController<T>).stream;
  }
  
  void emit<T>(String eventName, T data) {
    if (_controllers.containsKey(eventName)) {
      (_controllers[eventName] as StreamController<T>).add(data);
    }
  }
  
  void dispose() {
    for (var controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}

void main() async {
  final eventBus = EventBus();
  
  // Subscribe to events
  eventBus.on<String>('message').listen((msg) {
    print('Message received: $msg');
  });
  
  eventBus.on<int>('count').listen((count) {
    print('Count: $count');
  });
  
  // Emit events
  eventBus.emit('message', 'Hello!');
  eventBus.emit('count', 42);
  eventBus.emit('message', 'World!');
  
  await Future.delayed(Duration(milliseconds: 100));
  eventBus.dispose();
}
```

### 4. Async Resource Pool

```dart
class ResourcePool<T> {
  final List<T> _available;
  final StreamController<T> _controller = StreamController<T>();
  
  ResourcePool(List<T> resources) : _available = List.from(resources);
  
  Future<T> acquire() async {
    if (_available.isNotEmpty) {
      return _available.removeLast();
    }
    
    // Wait for a resource to be released
    return await _controller.stream.first;
  }
  
  void release(T resource) {
    if (_available.length < 10) {
      _available.add(resource);
    }
    _controller.add(resource);
  }
}

void main() async {
  final pool = ResourcePool<int>([1, 2, 3]);
  
  // Acquire resources
  final r1 = await pool.acquire();
  print('Acquired: $r1');
  
  final r2 = await pool.acquire();
  print('Acquired: $r2');
  
  final r3 = await pool.acquire();
  print('Acquired: $r3');
  
  // Release and re-acquire
  Future.delayed(Duration(seconds: 1), () {
    print('Releasing: $r1');
    pool.release(r1);
  });
  
  final r4 = await pool.acquire();
  print('Acquired: $r4');
}
```

## ✍️ Practice Exercises

See the exercises directory for hands-on practice:

1. `exercises/1-stream-controller.md` - Build a stock ticker with StreamController
2. `exercises/2-async-generators.md` - Create async generators for data processing
3. `exercises/3-isolate-computation.md` - Use isolates for parallel processing
4. `exercises/4-stream-combiner.md` - Combine multiple streams effectively

## 📚 What You Learned

✅ Creating custom streams with StreamController
✅ Stream transformations (map, where, expand, asyncMap)
✅ Async generators with `async*` and `yield`
✅ Controlling futures with Completer
✅ True parallelism with Isolates
✅ Managing backpressure in streams
✅ Broadcast vs single-subscription streams
✅ Combining multiple streams
✅ Real-world async patterns

## 🔜 Next Steps

**Next tutorial: 14-Reflection-Metadata** - Explore Dart's reflection capabilities and metadata annotations for building flexible, introspective applications.

## 💡 Key Takeaways for Python Developers

1. **StreamController**: More powerful than Python's async generators - full control over emission
2. **Isolates != asyncio**: Dart isolates provide true parallelism, unlike Python's single-threaded asyncio
3. **Backpressure**: Built into Dart streams with pause/resume - manual in Python
4. **Broadcast streams**: Native pub/sub pattern - cleaner than Python's manual implementation
5. **Stream transformations**: Rich operator set built-in (map, where, expand, etc.)
6. **Completer**: Like `asyncio.Future` with manual completion control
7. **Type safety**: All async operations are fully type-safe at compile time

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting to Close StreamControllers

```dart
// Wrong - memory leak!
void badExample() {
  final controller = StreamController<int>();
  controller.stream.listen((data) => print(data));
  controller.add(1);
  // Forgot to close!
}

// Right - always close
void goodExample() async {
  final controller = StreamController<int>();
  controller.stream.listen((data) => print(data));
  controller.add(1);
  await Future.delayed(Duration(milliseconds: 100));
  controller.close(); // Clean up
}
```

### Pitfall 2: Multiple Listeners on Single-Subscription Stream

```dart
// Wrong - throws error
void badExample() async {
  final stream = Stream.fromIterable([1, 2, 3]);
  stream.listen((n) => print('A: $n'));
  stream.listen((n) => print('B: $n')); // Error!
}

// Right - use broadcast stream
void goodExample() async {
  final stream = Stream.fromIterable([1, 2, 3]).asBroadcastStream();
  stream.listen((n) => print('A: $n'));
  stream.listen((n) => print('B: $n')); // OK
}
```

### Pitfall 3: Not Handling Isolate Errors

```dart
// Wrong - isolate errors crash silently
void badExample() async {
  await Isolate.spawn((message) {
    throw Exception('Oops!'); // Silent crash!
  }, null);
}

// Right - handle errors
void goodExample() async {
  final receivePort = ReceivePort();
  final errorPort = ReceivePort();
  
  await Isolate.spawn(
    (message) {
      throw Exception('Oops!');
    },
    null,
    onError: errorPort.sendPort,
  );
  
  errorPort.listen((error) {
    print('Isolate error: $error');
  });
}
```

### Pitfall 4: Blocking the Event Loop

```dart
// Wrong - blocks event loop (use isolate for CPU-heavy work)
Future<int> badExample() async {
  int sum = 0;
  for (var i = 0; i < 1000000000; i++) { // Blocks!
    sum += i;
  }
  return sum;
}

// Right - use isolate for CPU-intensive work
Future<int> goodExample() async {
  return await compute((int max) {
    int sum = 0;
    for (var i = 0; i < max; i++) {
      sum += i;
    }
    return sum;
  }, 1000000000);
}
```

### Pitfall 5: Not Awaiting Stream Operations

```dart
// Wrong - stream not fully consumed
void badExample() async {
  Stream.fromIterable([1, 2, 3])
      .map((n) => n * 2)
      .forEach(print); // Not awaited! May not complete
  
  print('Done'); // Prints before stream completes
}

// Right - await stream completion
void goodExample() async {
  await Stream.fromIterable([1, 2, 3])
      .map((n) => n * 2)
      .forEach(print);
  
  print('Done'); // Prints after stream completes
}
```

## 📖 Additional Resources

- [Dart Asynchronous Programming](https://dart.dev/codelabs/async-await)
- [Dart Streams Tutorial](https://dart.dev/tutorials/language/streams)
- [Dart Isolates and Concurrency](https://dart.dev/guides/language/concurrency)
- [Stream API Reference](https://api.dart.dev/stable/dart-async/Stream-class.html)
- [Isolate API Reference](https://api.dart.dev/stable/dart-isolate/Isolate-class.html)

---

Ready to master advanced async patterns? Complete the exercises and build production-ready async applications! 🚀
