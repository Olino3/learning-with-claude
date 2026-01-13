# Exercise 2: Streams

Master Streams and async generators.

## 🚀 Practice

```bash
make dart-repl
```

```dart
// Stream generator
Stream<int> countStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i;
  }
}

// Consume stream
void main() async {
  await for (var value in countStream(5)) {
    print("Value: $value");
  }
  print("Done!");
}

// Transform stream
void transform() async {
  var stream = countStream(10);

  var evens = stream.where((n) => n % 2 == 0);
  var doubled = evens.map((n) => n * 2);

  await for (var value in doubled) {
    print(value);
  }
}
```

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/9-Async-Programming/exercises/stream_demo.dart`

```dart
import 'dart:async';

void main() async {
  print("=== Basic Stream ===");
  await basicStream();

  print("\n=== Transformed Stream ===");
  await transformedStream();

  print("\n=== Stream Controller ===");
  streamController();
}

Future<void> basicStream() async {
  var stream = numberStream(5);

  await for (var value in stream) {
    print("Received: $value");
  }
}

Future<void> transformedStream() async {
  var stream = numberStream(10)
      .where((n) => n % 2 == 0)
      .map((n) => n * n);

  await for (var value in stream) {
    print("Square of even: $value");
  }
}

void streamController() {
  var controller = StreamController<String>();

  controller.stream.listen(
    (data) => print("Data: $data"),
    onError: (error) => print("Error: $error"),
    onDone: () => print("Done!"),
  );

  controller.add("Hello");
  controller.add("World");
  controller.addError("Something went wrong");
  controller.add("After error");
  controller.close();
}

Stream<int> numberStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield i;
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/9-Async-Programming/exercises/stream_demo.dart`

## ✅ Success Criteria

- [ ] Can create streams with async*
- [ ] Can consume streams with await for
- [ ] Can transform streams
- [ ] Understand StreamController
