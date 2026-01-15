# Tutorial 12: Isolates and Concurrency

Welcome to Dart's concurrency model! This tutorial covers Isolates for true parallel execution, how they differ from threads, and patterns for concurrent programming in Dart.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Dart's single-threaded event loop model
- Master Isolates for true parallel execution
- Send and receive messages between isolates
- Use compute() for simple parallel tasks
- Implement worker pool patterns
- Handle errors in concurrent code
- Choose between async/await and isolates

## 🐍➡️🎯 Coming from Python

Dart's isolates are different from Python's threads or multiprocessing:

| Concept | Python | Dart |
|---------|--------|------|
| Main execution | Main thread | Main isolate |
| Parallel execution | `multiprocessing.Process` | `Isolate.spawn()` |
| Shared memory | Yes (with GIL) | No (message passing only) |
| Threading | `threading.Thread` | Not available (use async/await) |
| Message passing | `Queue`, `Pipe` | `SendPort`/`ReceivePort` |
| Worker pool | `ProcessPoolExecutor` | Custom isolate pool |
| Simple parallel task | `concurrent.futures` | `compute()` function |

> **📘 Python Note:** Unlike Python's threads (which share memory but are limited by GIL), Dart's isolates have separate memory and achieve true parallelism. Think of them as Python's multiprocessing processes, but lighter weight.

## 📝 Understanding the Event Loop

Dart's main isolate runs a single-threaded event loop:

```dart
import 'dart:async';

void main() {
  print('1. Start');
  
  // Synchronous code
  print('2. Synchronous execution');
  
  // Microtask queue (highest priority)
  scheduleMicrotask(() {
    print('4. Microtask');
  });
  
  // Event queue (lower priority)
  Future(() {
    print('5. Future event');
  });
  
  // Another microtask
  Future.microtask(() {
    print('3. Another microtask');
  });
  
  print('6. End of main');
  
  // Output order: 1, 2, 6, 4, 3, 5
  // Synchronous first, then microtasks, then events
}
```

> **📘 Python Note:** This is similar to Python's asyncio event loop, but Dart's is built into the language runtime itself, not a library.

## 📝 When to Use Isolates vs Async

### Use async/await for:
- I/O operations (network, files, database)
- Waiting for user input
- Coordinating multiple asynchronous operations
- Any operation that doesn't block the CPU

### Use Isolates for:
- CPU-intensive computations
- Image processing
- Parsing large files
- Heavy data transformations
- Any operation that would block the event loop

```dart
import 'dart:async';
import 'dart:math';

// BAD: CPU-intensive work blocking the event loop
void badExample() {
  print('Start');
  
  // This blocks everything!
  var result = computeFibonacci(45);
  print('Fibonacci: $result');
  
  print('End');
}

// GOOD: Use async/await for I/O
Future<void> goodAsyncExample() async {
  print('Start');
  
  // Non-blocking I/O
  var data = await fetchDataFromNetwork();
  print('Data: $data');
  
  print('End');
}

// GOOD: Use isolate for CPU-intensive work
Future<void> goodIsolateExample() async {
  print('Start');
  
  // Run in separate isolate (non-blocking)
  var result = await compute(computeFibonacci, 45);
  print('Fibonacci: $result');
  
  print('End');
}

int computeFibonacci(int n) {
  if (n <= 1) return n;
  return computeFibonacci(n - 1) + computeFibonacci(n - 2);
}

Future<String> fetchDataFromNetwork() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Network data';
}
```

## 📝 Using compute() for Simple Parallel Tasks

The easiest way to run parallel computations (note: `compute()` is from Flutter's foundation library; for pure Dart, use manual isolate spawning):

```dart
import 'dart:isolate';

// For Flutter applications:
// import 'package:flutter/foundation.dart';

// Top-level or static function required for compute()
int expensiveComputation(int n) {
  var sum = 0;
  for (var i = 0; i < n; i++) {
    sum += i * i;
  }
  return sum;
}

// Pure Dart alternative without Flutter's compute():
Future<int> runInIsolate(int n) async {
  var receivePort = ReceivePort();
  await Isolate.spawn(_isolateComputation, receivePort.sendPort);
  
  var sendPort = await receivePort.first as SendPort;
  var responsePort = ReceivePort();
  
  sendPort.send([n, responsePort.sendPort]);
  return await responsePort.first as int;
}

void _isolateComputation(SendPort sendPort) {
  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  receivePort.listen((message) {
    var n = message[0] as int;
    var replyPort = message[1] as SendPort;
    replyPort.send(expensiveComputation(n));
  });
}

Future<void> main() async {
  print('Starting computation...');
  
  // Using manual isolate (works in pure Dart)
  var result = await runInIsolate(1000000);
  
  print('Result: $result');
  
  // Can run multiple in parallel
  var results = await Future.wait([
    runInIsolate(1000000),
    runInIsolate(2000000),
    runInIsolate(3000000),
  ]);
  
  print('Multiple results: $results');
}
```

> **📘 Python Note:** `compute()` is like Python's `ProcessPoolExecutor.submit()` - it handles all the isolate setup and teardown for you.

## 📝 Manual Isolate Creation

For more control, create isolates manually:

```dart
import 'dart:isolate';

// Entry point function for isolate
void isolateEntryPoint(SendPort sendPort) {
  // This runs in a separate isolate
  print('Isolate started!');
  
  // Send message back to main isolate
  sendPort.send('Hello from isolate!');
}

Future<void> main() async {
  // Create receive port for messages from isolate
  var receivePort = ReceivePort();
  
  // Spawn new isolate
  await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
  
  // Listen for messages
  receivePort.listen((message) {
    print('Received: $message');
    receivePort.close(); // Close port when done
  });
}
```

## 📝 Bidirectional Communication

Send messages back and forth:

```dart
import 'dart:isolate';
import 'dart:async';

// Worker isolate that processes requests
void workerIsolate(SendPort sendToMain) {
  // Create port to receive messages
  var receivePort = ReceivePort();
  
  // Send our SendPort to main
  sendToMain.send(receivePort.sendPort);
  
  // Listen for work
  receivePort.listen((message) {
    if (message is Map) {
      var command = message['command'];
      var data = message['data'];
      
      if (command == 'compute') {
        // Do expensive computation
        var result = data * data;
        sendToMain.send({'result': result});
      } else if (command == 'stop') {
        receivePort.close();
      }
    }
  });
}

Future<void> main() async {
  // Create receive port
  var receivePort = ReceivePort();
  
  // Spawn worker
  await Isolate.spawn(workerIsolate, receivePort.sendPort);
  
  // Get worker's SendPort
  var sendToWorker = await receivePort.first as SendPort;
  
  // Create port for responses
  var responsePort = ReceivePort();
  
  // Send work to worker
  sendToWorker.send({
    'command': 'compute',
    'data': 42,
    'replyTo': responsePort.sendPort,
  });
  
  // Wait for response
  var result = await responsePort.first;
  print('Result: $result');
  
  // Cleanup
  sendToWorker.send({'command': 'stop'});
  responsePort.close();
}
```

## 📝 Worker Pool Pattern

Create a pool of worker isolates:

```dart
import 'dart:isolate';
import 'dart:async';

class WorkerPool {
  final int size;
  final List<SendPort> _workers = [];
  final Queue<Completer> _taskQueue = Queue();
  int _nextWorker = 0;
  
  WorkerPool(this.size);
  
  Future<void> init() async {
    for (var i = 0; i < size; i++) {
      var worker = await _createWorker();
      _workers.add(worker);
    }
  }
  
  Future<SendPort> _createWorker() async {
    var receivePort = ReceivePort();
    await Isolate.spawn(_workerEntryPoint, receivePort.sendPort);
    return await receivePort.first as SendPort;
  }
  
  static void _workerEntryPoint(SendPort sendPort) {
    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) {
      var replyPort = message['replyPort'] as SendPort;
      var data = message['data'];
      
      // Process work
      var result = _doWork(data);
      replyPort.send(result);
    });
  }
  
  static dynamic _doWork(dynamic data) {
    // Simulate expensive computation
    if (data is int) {
      return data * data;
    }
    return null;
  }
  
  Future<dynamic> execute(dynamic data) async {
    var completer = Completer();
    var replyPort = ReceivePort();
    
    replyPort.listen((result) {
      completer.complete(result);
      replyPort.close();
    });
    
    // Round-robin worker selection
    var worker = _workers[_nextWorker];
    _nextWorker = (_nextWorker + 1) % _workers.length;
    
    worker.send({
      'data': data,
      'replyPort': replyPort.sendPort,
    });
    
    return completer.future;
  }
}

Future<void> main() async {
  var pool = WorkerPool(4); // 4 worker isolates
  await pool.init();
  
  // Execute multiple tasks in parallel
  var tasks = List.generate(10, (i) => pool.execute(i));
  var results = await Future.wait(tasks);
  
  print('Results: $results');
}
```

## 📝 Error Handling in Isolates

Handle errors from isolates:

```dart
import 'dart:isolate';

void faultyIsolate(SendPort sendPort) {
  // This will throw an error
  throw Exception('Something went wrong!');
}

Future<void> main() async {
  var receivePort = ReceivePort();
  var errorPort = ReceivePort();
  
  await Isolate.spawn(
    faultyIsolate,
    receivePort.sendPort,
    onError: errorPort.sendPort,
  );
  
  errorPort.listen((error) {
    print('Error from isolate: $error');
    errorPort.close();
  });
  
  // Can also catch errors in spawn
  try {
    await Isolate.spawn(
      faultyIsolate,
      receivePort.sendPort,
    );
  } catch (e) {
    print('Failed to spawn isolate: $e');
  }
}
```

## 📝 Isolate Limitations

Important constraints to be aware of:

```dart
// 1. No shared memory
var sharedData = [1, 2, 3]; // Can't directly access from isolate

// 2. Can only send certain types
// ✅ Primitive types: int, double, String, bool, null
// ✅ Lists, Maps, Sets of sendable types
// ✅ SendPort, Capability
// ❌ Cannot send: Functions, closures, most objects

// 3. Data is copied (or transferred)
void isolateFunction(Map<String, dynamic> data) {
  // 'data' is a copy, not a reference
  data['key'] = 'modified';
  // This doesn't affect the original map
}

// 4. Top-level or static functions only
class MyClass {
  // ❌ Can't use instance methods as isolate entry points
  void instanceMethod(SendPort sendPort) { }
  
  // ✅ Can use static methods
  static void staticMethod(SendPort sendPort) { }
}

// ✅ Top-level functions work
void topLevelFunction(SendPort sendPort) { }
```

## 🎯 Practice Exercises

See the `exercises/` directory for hands-on practice:

1. **isolate_basics.dart** - Basic isolate creation and communication
2. **parallel_computation.dart** - CPU-intensive parallel processing
3. **worker_pool.dart** - Implement a worker pool

## 📚 Key Takeaways

1. **Event Loop:** Dart's main isolate runs a single-threaded event loop
2. **Async vs Isolates:** Use async for I/O, isolates for CPU-intensive work
3. **compute():** Easiest way to run simple parallel tasks
4. **Message Passing:** Isolates communicate via SendPort/ReceivePort
5. **No Shared Memory:** Data is copied between isolates
6. **True Parallelism:** Unlike async/await, isolates run in parallel
7. **Error Handling:** Use onError port or try/catch on spawn

## 🔗 Next Steps

After mastering isolates, move on to:
- **Tutorial 13:** Advanced Async Patterns
- **Tutorial 14:** Extension Methods and Mixins

---

**Practice with isolates to understand when and how to use parallel execution!** 🎯✨
