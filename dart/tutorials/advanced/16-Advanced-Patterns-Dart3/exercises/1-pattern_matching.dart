#!/usr/bin/env dart
// Tutorial 16: Pattern Matching Practice

void main() {
  print("=" * 70);
  print("PATTERN MATCHING PRACTICE");
  print("=" * 70);

  // Example 1: Records
  print("\nExample 1: Records");
  var person = (name: 'Alice', age: 30);
  print("Name: ${person.name}, Age: ${person.age}");
  
  var (name, age) = ('Bob', 25);
  print("Destructured: $name is $age years old");

  // Example 2: Pattern Matching
  print("\nExample 2: Pattern Matching");
  print(describeNumber(5));
  print(describeNumber(-3));
  print(describeNumber(150));

  // Example 3: List Patterns
  print("\nExample 3: List Patterns");
  matchList([1, 2, 3, 4, 5]);
  matchList([42]);
  matchList([]);

  // Example 4: Sealed Classes
  print("\nExample 4: Sealed Classes");
  handleResult(Success('Data loaded'));
  handleResult(Error('Network error'));
  handleResult(Loading());

  // Checkpoint
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  // TODO: Challenge 1 - Create sealed class for payment methods
  // TODO: Challenge 2 - Use pattern matching with maps
  // TODO: Challenge 3 - Implement state machine with sealed classes
}

String describeNumber(int n) {
  return switch (n) {
    0 => 'zero',
    1 => 'one',
    < 0 => 'negative',
    > 0 && < 10 => 'small positive',
    >= 10 && < 100 => 'medium positive',
    _ => 'large number',
  };
}

void matchList(List<int> list) {
  switch (list) {
    case []:
      print('Empty list');
    case [var single]:
      print('Single element: $single');
    case [var first, ...var rest]:
      print('First: $first, Rest: $rest');
  }
}

sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  Error(this.message);
}

class Loading<T> extends Result<T> {}

void handleResult<T>(Result<T> result) {
  switch (result) {
    case Success(data: var d):
      print('Success: $d');
    case Error(message: var m):
      print('Error: $m');
    case Loading():
      print('Loading...');
  }
}
