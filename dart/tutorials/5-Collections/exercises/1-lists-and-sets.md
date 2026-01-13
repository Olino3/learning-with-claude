# Exercise 1: Lists and Sets

Master Dart's List and Set collections.

## 🚀 REPL Practice

```bash
make dart-repl
```

### Lists

```dart
// Create and manipulate lists
var numbers = [1, 2, 3, 4, 5];

numbers.add(6);
numbers.addAll([7, 8, 9]);
numbers.insert(0, 0);
print(numbers);

// Transform
var doubled = numbers.map((n) => n * 2).toList();
var evens = numbers.where((n) => n % 2 == 0).toList();
var sum = numbers.reduce((a, b) => a + b);

print("Doubled: $doubled");
print("Evens: $evens");
print("Sum: $sum");

// Slicing
var sub = numbers.sublist(2, 5);
print(sub);

// Collection for
var squares = [for (var n in numbers) n * n];
print(squares);
```

### Sets

```dart
// Create sets
var set1 = {1, 2, 3, 4, 5};
var set2 = {4, 5, 6, 7, 8};

// Set operations
print(set1.union(set2));
print(set1.intersection(set2));
print(set1.difference(set2));

// Remove duplicates
var withDuplicates = [1, 2, 2, 3, 3, 3, 4, 4, 5];
var unique = withDuplicates.toSet().toList();
print(unique);
```

## 📝 Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/5-Collections/exercises/list_utils.dart`

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  print("Original: $numbers");
  print("Evens: ${filterEvens(numbers)}");
  print("Sum: ${sum(numbers)}");
  print("Average: ${average(numbers)}");
  print("Max: ${findMax(numbers)}");
}

List<int> filterEvens(List<int> numbers) {
  return numbers.where((n) => n % 2 == 0).toList();
}

int sum(List<int> numbers) {
  return numbers.fold(0, (a, b) => a + b);
}

double average(List<int> numbers) {
  return sum(numbers) / numbers.length;
}

int findMax(List<int> numbers) {
  return numbers.reduce((a, b) => a > b ? a : b);
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/5-Collections/exercises/list_utils.dart`

## ✅ Success Criteria

- [ ] Can create and manipulate lists
- [ ] Can use set operations
- [ ] Understand list methods (map, where, reduce)
- [ ] Completed script challenge
