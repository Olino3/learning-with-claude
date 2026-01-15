#!/usr/bin/env dart
// Tutorial 14: Extension Methods Practice

void main() {
  print("=" * 70);
  print("EXTENSION METHODS PRACTICE");
  print("=" * 70);

  // Example 1: String Extensions
  print("\nExample 1: String Extensions");
  var email = "user@example.com";
  print("Is email: ${email.isEmail}");
  
  var name = "alice";
  print("Capitalized: ${name.capitalize()}");

  // Example 2: List Extensions
  print("\nExample 2: List Extensions");
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8];
  print("Second: ${numbers.secondOrNull}");
  print("Chunks: ${numbers.chunk(3)}");

  // Example 3: Nullable Extensions
  print("\nExample 3: Nullable Extensions");
  String? nullString;
  print("Safe length: ${nullString.safeLength}");
  print("Or default: ${nullString.orDefault('default')}");

  // Checkpoint
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  // TODO: Challenge 1 - Create extension for reversing strings
  // TODO: Challenge 2 - Create extension for finding median of numbers
  // TODO: Challenge 3 - Create extension for grouping list items
}

extension StringExtensions on String {
  bool get isEmail {
    // Simple email validation pattern
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }
  
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension ListExtensions<T> on List<T> {
  T? get secondOrNull {
    return length >= 2 ? this[1] : null;
  }
  
  List<List<T>> chunk(int size) {
    var chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }
}

extension NullableStringExtensions on String? {
  int get safeLength => this?.length ?? 0;
  String orDefault(String defaultValue) => this ?? defaultValue;
}
