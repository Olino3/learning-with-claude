# Tutorial 9: Async Programming - Futures, Async/Await, and Streams

Welcome to asynchronous programming in Dart! Learn how to handle asynchronous operations with Futures, async/await, and Streams.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand Futures and async/await
- Handle asynchronous operations
- Work with Streams
- Use await for loops
- Create async generators
- Handle errors in async code
- Use Future.wait() for parallel operations

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Async function | `async def func():` | `Future<T> func() async {` |
| Await | `await coroutine()` | `await future` |
| Promise/Future | `asyncio.Future` | `Future<T>` |
| Generator | `yield` | `yield` with `async*` |
| Stream | `async for x in stream:` | `await for (var x in stream)` |
| Run async | `asyncio.run(main())` | `await main()` or auto in main() |
| Gather/wait | `asyncio.gather(*tasks)` | `Future.wait([futures])` |

## 📝 Futures Basics

### What is a Future?

A Future represents a value that will be available at some point in the future.

```dart
// Synchronous - blocks
int fetchDataSync() {
  // Simulate work
  return 42;
}

// Asynchronous - returns immediately with Future
Future<int> fetchDataAsync() async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));
  return 42;
}

// Using async function
void main() async {
  print("Start");

  var result = await fetchDataAsync();
  print("Result: $result");

  print("End");
}
```

> **📘 Python Note:** Very similar to Python's async/await! Futures are like asyncio futures/tasks.

### Creating Futures

```dart
// Future that completes immediately
var immediate = Future.value(42);

// Future with delay
var delayed = Future.delayed(
  Duration(seconds: 2),
  () => "Hello after 2 seconds"
);

// Future with error
var error = Future.error(Exception("Something went wrong"));

// From async function
Future<String> fetchUser() async {
  await Future.delayed(Duration(seconds: 1));
  return "Alice";
}
```

## 📝 Async/Await

### Basic Async/Await

```dart
Future<void> example() async {
  // Await pauses execution until Future completes
  var result = await fetchData();
  print(result);

  // Can use normal control flow
  if (result > 10) {
    var more = await fetchMoreData();
    print(more);
  }
}

Future<int> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return 42;
}

Future<String> fetchMoreData() async {
  await Future.delayed(Duration(milliseconds: 500));
  return "More data";
}
```

> **📘 Python Note:** Identical to Python's async/await! Function marked `async` returns Future automatically.

### Chaining Futures

```dart
// With then/catchError (old style)
Future<void> oldStyle() {
  return fetchData()
      .then((value) => print("Got: $value"))
      .catchError((error) => print("Error: $error"));
}

// With async/await (modern, preferred)
Future<void> modernStyle() async {
  try {
    var value = await fetchData();
    print("Got: $value");
  } catch (error) {
    print("Error: $error");
  }
}
```

### Error Handling

```dart
Future<void> handleErrors() async {
  try {
    var result = await riskyOperation();
    print("Success: $result");
  } on NetworkException catch (e) {
    print("Network error: ${e.message}");
  } catch (e) {
    print("Unknown error: $e");
  }
}

Future<String> riskyOperation() async {
  await Future.delayed(Duration(seconds: 1));

  if (DateTime.now().second % 2 == 0) {
    throw NetworkException("Connection failed");
  }

  return "Success";
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
```

## 📝 Multiple Futures

### Future.wait() - Parallel Execution

```dart
Future<void> parallelExample() async {
  print("Starting parallel operations...");

  var results = await Future.wait([
    fetchUser(1),
    fetchUser(2),
    fetchUser(3),
  ]);

  print("All users: $results");
}

Future<String> fetchUser(int id) async {
  await Future.delayed(Duration(seconds: 1));
  return "User $id";
}

// With error handling
Future<void> parallelWithErrors() async {
  try {
    var results = await Future.wait([
      fetchData(1),
      fetchData(2),
      fetchData(3),
    ], eagerError: true);  // Fails fast on first error

    print("Results: $results");
  } catch (e) {
    print("One of the futures failed: $e");
  }
}
```

> **📘 Python Note:** Like Python's `asyncio.gather()`. Runs futures in parallel and waits for all.

### Sequential vs Parallel

```dart
// Sequential - one after another (slower)
Future<void> sequential() async {
  var start = DateTime.now();

  var user = await fetchUser(1);    // Wait 1 second
  var posts = await fetchPosts(1);  // Wait 1 second
  var comments = await fetchComments(1);  // Wait 1 second

  var duration = DateTime.now().difference(start);
  print("Sequential took: ${duration.inSeconds}s");  // ~3 seconds
}

// Parallel - all at once (faster)
Future<void> parallel() async {
  var start = DateTime.now();

  var results = await Future.wait([
    fetchUser(1),
    fetchPosts(1),
    fetchComments(1),
  ]);

  var duration = DateTime.now().difference(start);
  print("Parallel took: ${duration.inSeconds}s");  // ~1 second
}
```

## 📝 Streams

Streams are sequences of asynchronous events.

### Creating Streams

```dart
// Stream from list
var stream = Stream.fromIterable([1, 2, 3, 4, 5]);

// Stream with delay
var delayedStream = Stream.periodic(
  Duration(seconds: 1),
  (count) => count
).take(5);  // Only take 5 items

// Async generator
Stream<int> countStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i;
  }
}
```

### Consuming Streams

```dart
// await for loop
Future<void> consumeStream() async {
  var stream = countStream(5);

  await for (var value in stream) {
    print("Received: $value");
  }

  print("Stream complete!");
}

// Listen method
void listenToStream() {
  var stream = countStream(5);

  stream.listen(
    (value) {
      print("Received: $value");
    },
    onError: (error) {
      print("Error: $error");
    },
    onDone: () {
      print("Stream complete!");
    },
  );
}
```

> **📘 Python Note:** Similar to Python's async iterators! Use `await for` just like Python.

### Stream Transformations

```dart
Future<void> transformStream() async {
  var stream = Stream.fromIterable([1, 2, 3, 4, 5]);

  // Map
  var doubled = stream.map((n) => n * 2);

  // Where (filter)
  var evens = stream.where((n) => n % 2 == 0);

  // Chaining
  var result = stream
      .where((n) => n % 2 == 0)
      .map((n) => n * n)
      .map((n) => "Square: $n");

  await for (var value in result) {
    print(value);
  }
}
```

### Broadcast Streams

```dart
void broadcastExample() {
  var controller = StreamController<int>.broadcast();

  // Multiple listeners
  controller.stream.listen((value) {
    print("Listener 1: $value");
  });

  controller.stream.listen((value) {
    print("Listener 2: $value");
  });

  // Add events
  controller.add(1);
  controller.add(2);
  controller.add(3);

  controller.close();
}
```

## 📝 Practical Patterns

### Timeout

```dart
Future<String> fetchWithTimeout() async {
  try {
    var result = await fetchData().timeout(
      Duration(seconds: 5),
      onTimeout: () => throw TimeoutException("Request took too long"),
    );
    return result;
  } on TimeoutException catch (e) {
    print("Timeout: ${e.message}");
    return "Default value";
  }
}
```

### Retry Logic

```dart
Future<T> retry<T>(
  Future<T> Function() operation,
  {int attempts = 3}
) async {
  for (var i = 0; i < attempts; i++) {
    try {
      return await operation();
    } catch (e) {
      if (i == attempts - 1) rethrow;
      print("Attempt ${i + 1} failed, retrying...");
      await Future.delayed(Duration(seconds: 1));
    }
  }
  throw StateError("Unreachable");
}

// Usage
var result = await retry(() => fetchData(), attempts: 3);
```

### Debounce

```dart
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}

// Usage
var debouncer = Debouncer(delay: Duration(milliseconds: 500));
debouncer(() => print("Debounced action"));
```

## ✍️ Exercises

### Exercise 1: Futures

👉 **[Start Exercise 1: Futures](exercises/1-futures.md)**

### Exercise 2: Streams

👉 **[Start Exercise 2: Streams](exercises/2-streams.md)**

### Exercise 3: Async Challenges

👉 **[Start Exercise 3: Async Challenges](exercises/3-async-challenges.md)**

## 📚 What You Learned

✅ Futures and async/await
✅ Error handling in async code
✅ Future.wait() for parallel operations
✅ Streams and async generators
✅ Stream transformations
✅ Practical async patterns

## 🔜 Next Steps

**Next tutorial: 10-File-IO**

## 💡 Key Takeaways for Python Developers

1. **Similar Syntax**: async/await works just like Python
2. **Futures**: Like asyncio futures/tasks
3. **Future.wait()**: Like asyncio.gather()
4. **Streams**: Like async iterators in Python
5. **async***: Generator syntax with yield
6. **Main**: Can be async automatically

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting await

```dart
// ❌ Wrong - returns Future, doesn't wait
var result = fetchData();  // Future<int>, not int!

// ✅ Correct - await the Future
var result = await fetchData();  // int
```

### Pitfall 2: Not marking function async

```dart
// ❌ Wrong - can't use await
Future<void> example() {
  var result = await fetchData();  // Error!
}

// ✅ Correct - mark as async
Future<void> example() async {
  var result = await fetchData();  // OK
}
```

## 📖 Additional Resources

- [Dart Async Programming](https://dart.dev/codelabs/async-await)
- [Dart Streams](https://dart.dev/tutorials/language/streams)

---

Ready? Start with **[Exercise 1: Futures](exercises/1-futures.md)**!
