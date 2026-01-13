# Exercise 3: Collection Challenges

Apply all collection concepts.

## 🎯 Challenge 1: Data Processing

**Create:** `/home/user/learning-with-claude/dart/tutorials/5-Collections/exercises/data_processor.dart`

```dart
void main() {
  var students = [
    {"name": "Alice", "age": 20, "scores": [95, 87, 92]},
    {"name": "Bob", "age": 22, "scores": [78, 85, 80]},
    {"name": "Charlie", "age": 21, "scores": [92, 94, 89]},
  ];

  // Process data
  for (var student in students) {
    var scores = student["scores"] as List<int>;
    var avg = scores.reduce((a, b) => a + b) / scores.length;
    print("${student["name"]}: avg = ${avg.toStringAsFixed(1)}");
  }

  // Top students (avg >= 90)
  var topStudents = students.where((s) {
    var scores = s["scores"] as List<int>;
    var avg = scores.reduce((a, b) => a + b) / scores.length;
    return avg >= 90;
  }).toList();

  print("\nTop students:");
  for (var s in topStudents) {
    print(s["name"]);
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/5-Collections/exercises/data_processor.dart`

## 🎯 Challenge 2: Group By

Create a groupBy function:

```dart
Map<K, List<T>> groupBy<T, K>(List<T> items, K Function(T) keyFn) {
  var groups = <K, List<T>>{};
  for (var item in items) {
    var key = keyFn(item);
    groups.putIfAbsent(key, () => []).add(item);
  }
  return groups;
}

// Test
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
var grouped = groupBy(numbers, (n) => n % 2 == 0 ? "even" : "odd");
print(grouped);  // {odd: [1, 3, 5, 7, 9], even: [2, 4, 6, 8, 10]}
```

## ✅ Success Criteria

- [ ] Completed data processing challenge
- [ ] Implemented groupBy function
- [ ] Can chain collection operations

🎉 Congratulations! Ready for **Tutorial 6: Object-Oriented Programming**.
