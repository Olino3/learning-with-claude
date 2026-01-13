# Exercise 2: Maps

Master Dart's Map collection.

## 🚀 REPL Practice

```bash
make dart-repl
```

### Basic Map Operations

```dart
// Create map
var scores = {
  "Alice": 95,
  "Bob": 87,
  "Charlie": 92
};

// Access
print(scores["Alice"]);
print(scores["David"] ?? 0);  // Default value

// Add/update
scores["David"] = 88;
scores["Alice"] = 98;

// Iterate
scores.forEach((name, score) {
  print("$name: $score");
});

// Transform
var doubled = scores.map((k, v) => MapEntry(k, v * 2));
print(doubled);

// Filter
var passing = Map.fromEntries(
  scores.entries.where((e) => e.value >= 90)
);
print("Passing: $passing");
```

## 📝 Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/5-Collections/exercises/word_counter.dart`

```dart
void main() {
  var text = "hello world hello dart dart is awesome dart";
  var words = text.split(" ");

  var wordCount = countWords(words);
  print(wordCount);

  var sorted = sortByValue(wordCount);
  print("Sorted: $sorted");
}

Map<String, int> countWords(List<String> words) {
  var counts = <String, int>{};
  for (var word in words) {
    counts[word] = (counts[word] ?? 0) + 1;
  }
  return counts;
}

List<MapEntry<String, int>> sortByValue(Map<String, int> map) {
  var entries = map.entries.toList();
  entries.sort((a, b) => b.value.compareTo(a.value));
  return entries;
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/5-Collections/exercises/word_counter.dart`

## ✅ Success Criteria

- [ ] Can create and manipulate maps
- [ ] Can iterate over maps
- [ ] Can transform and filter maps
- [ ] Completed word counter
