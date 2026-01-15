#!/usr/bin/env dart
// Tutorial 12: Isolates and Concurrency Practice

import 'dart:isolate';
import 'dart:async';

void main() async {
  print("=" * 70);
  print("ISOLATES AND CONCURRENCY PRACTICE");
  print("=" * 70);

  // Example 1: Manual isolate (compute() requires Flutter)
  print("\nExample 1: Manual Isolate for Factorial");
  print("Computing factorial in separate isolate...");
  var result = await runInIsolate(factorial, 20);
  print("Factorial(20) = $result");

  // Example 2: Basic isolate communication
  print("\nExample 2: Basic Isolate Communication");
  await basicIsolateExample();

  // Example 3: Bidirectional communication
  print("\nExample 3: Bidirectional Communication");
  await bidirectionalExample();

  // Example 4: Parallel processing multiple tasks
  print("\nExample 4: Parallel Processing");
  await parallelProcessingExample();

  // Checkpoint: Test Your Understanding
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  // TODO: Challenge 1 - Create an isolate that computes prime numbers
  // Should send back primes as they're found
  
  // TODO: Challenge 2 - Implement a simple worker pool
  // Pool should distribute work across multiple isolates
  
  // TODO: Challenge 3 - Image processing simulation
  // Process multiple "images" in parallel using isolates
}

// Helper to run function in isolate (pure Dart alternative to Flutter's compute)
Future<R> runInIsolate<T, R>(R Function(T) function, T argument) async {
  var receivePort = ReceivePort();
  await Isolate.spawn(_isolateRunner<T, R>, [receivePort.sendPort, function, argument]);
  return await receivePort.first as R;
}

void _isolateRunner<T, R>(List<dynamic> args) {
  var sendPort = args[0] as SendPort;
  var function = args[1] as R Function(T);
  var argument = args[2] as T;
  
  var result = function(argument);
  sendPort.send(result);
}

// Top-level function for factorial
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

// Example 1: Basic isolate
Future<void> basicIsolateExample() async {
  var receivePort = ReceivePort();
  
  await Isolate.spawn(simpleWorker, receivePort.sendPort);
  
  var message = await receivePort.first;
  print("Received from isolate: $message");
}

void simpleWorker(SendPort sendPort) {
  // Simulate some work
  var result = "Work completed in isolate!";
  sendPort.send(result);
}

// Example 2: Bidirectional communication
Future<void> bidirectionalExample() async {
  var receivePort = ReceivePort();
  
  await Isolate.spawn(echoWorker, receivePort.sendPort);
  
  // Get worker's SendPort
  var sendToWorker = await receivePort.first as SendPort;
  
  // Create response port
  var responsePort = ReceivePort();
  
  // Send message with response port
  sendToWorker.send({
    'message': 'Hello, isolate!',
    'replyTo': responsePort.sendPort,
  });
  
  // Wait for response
  var response = await responsePort.first;
  print("Echo response: $response");
  
  // Cleanup
  responsePort.close();
  receivePort.close();
}

void echoWorker(SendPort mainSendPort) {
  var receivePort = ReceivePort();
  
  // Send our SendPort to main
  mainSendPort.send(receivePort.sendPort);
  
  receivePort.listen((message) {
    if (message is Map) {
      var text = message['message'];
      var replyTo = message['replyTo'] as SendPort;
      
      // Echo back
      replyTo.send("Echo: $text");
    }
  });
}

// Example 3: Parallel processing
Future<void> parallelProcessingExample() async {
  var numbers = [10, 15, 20, 25, 30];
  
  print("Computing factorials in parallel...");
  
  var start = DateTime.now();
  
  // Process all in parallel using compute
  var futures = numbers.map((n) => compute(factorial, n)).toList();
  var results = await Future.wait(futures);
  
  var duration = DateTime.now().difference(start);
  
  print("Results: $results");
  print("Time taken: ${duration.inMilliseconds}ms");
}

// Helper function for compute
int computeSquare(int n) {
  // Simulate expensive computation
  var sum = 0;
  for (var i = 0; i < n * 1000000; i++) {
    sum += i % 100;
  }
  return n * n;
}
