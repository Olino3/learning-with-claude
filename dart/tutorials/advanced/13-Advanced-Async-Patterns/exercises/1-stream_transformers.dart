#!/usr/bin/env dart
// Tutorial 13: Advanced Async Patterns Practice

import 'dart:async';

void main() async {
  print("=" * 70);
  print("ADVANCED ASYNC PATTERNS PRACTICE");
  print("=" * 70);

  // Example 1: Stream Controller
  print("\nExample 1: Stream Controller");
  await streamControllerExample();

  // Example 2: Stream Transformations
  print("\nExample 2: Stream Transformations");
  await streamTransformationsExample();

  // Example 3: Combining Streams
  print("\nExample 3: Combining Streams");
  await combiningStreamsExample();

  // Checkpoint
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  // TODO: Challenge 1 - Implement a debounce transformer
  // TODO: Challenge 2 - Create a throttle transformer
  // TODO: Challenge 3 - Implement retry with exponential backoff
}

Future<void> streamControllerExample() async {
  var controller = StreamController<int>();
  
  controller.stream.listen((data) {
    print("Received: $data");
  });
  
  controller.add(1);
  controller.add(2);
  controller.add(3);
  
  await controller.close();
}

Future<void> streamTransformationsExample() async {
  var stream = Stream.periodic(Duration(milliseconds: 100), (i) => i).take(10);
  
  await stream
    .where((n) => n % 2 == 0)
    .map((n) => n * 2)
    .forEach((n) => print("Transformed: $n"));
}

Future<void> combiningStreamsExample() async {
  var stream1 = Stream.fromIterable([1, 2, 3]);
  var stream2 = Stream.fromIterable([4, 5, 6]);
  
  // Simple merge with proper completion tracking
  var controller = StreamController<int>();
  var remaining = 2;
  
  void checkDone() {
    remaining--;
    if (remaining == 0) {
      controller.close();
    }
  }
  
  stream1.listen(controller.add, onDone: checkDone);
  stream2.listen(controller.add, onDone: checkDone);
  
  await controller.stream.forEach((n) => print("Merged: $n"));
}
