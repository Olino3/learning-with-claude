# Tutorial 5: Collections - Lists, Sets, Maps, and Generics

Welcome to your fifth Dart tutorial! This guide explores Dart's powerful collection types and their methods, including Lists, Sets, Maps, generics, and functional collection operations.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master Lists, Sets, and Maps
- Understand generics and type safety
- Use collection methods effectively (.map, .where, .reduce, etc.)
- Apply spread operators and collection if/for
- Work with immutable and mutable collections
- Understand collection performance characteristics

## 🐍➡️🎯 Coming from Python

If you're a Python developer, you'll notice several differences:

| Concept | Python | Dart |
|---------|--------|------|
| List | `[1, 2, 3]` | `[1, 2, 3]` or `<int>[1, 2, 3]` |
| Set | `{1, 2, 3}` | `{1, 2, 3}` or `<int>{1, 2, 3}` |
| Dict | `{"key": "value"}` | `{"key": "value"}` or `<String, String>{}` |
| List comprehension | `[x*2 for x in items]` | `[for (var x in items) x*2]` |
| Generics | `List[int]` (type hints) | `List<int>` (enforced) |
| Tuple | `(1, 2, 3)` | Records `(1, 2, 3)` (Dart 3.0+) |
| Spread | `[*items]` | `[...items]` |
| Get with default | `dict.get(key, default)` | `map[key] ?? default` |

## 📝 Lists

Lists are ordered collections of items (like Python lists).

### Creating Lists

```dart
// Type-inferred list
var numbers = [1, 2, 3, 4, 5];

// Explicitly typed list
List<String> fruits = ["apple", "banana", "orange"];

// Empty list with type
var emptyList = <int>[];
List<String> names = [];

// Create with constructor
var list1 = List<int>.filled(5, 0);  // [0, 0, 0, 0, 0]
var list2 = List<int>.generate(5, (i) => i * i);  // [0, 1, 4, 9, 16]

// Unmodifiable list
var immutable = List.unmodifiable([1, 2, 3]);
// immutable.add(4);  // Error! Cannot modify
```

> **📘 Python Note:** Dart lists are like Python lists but with type safety. The generic type `<T>` ensures all elements are the same type.

### List Operations

```dart
var numbers = [1, 2, 3, 4, 5];

// Access elements
print(numbers[0]);         // 1 (first)
print(numbers[numbers.length - 1]);  // 5 (last)
print(numbers.first);      // 1
print(numbers.last);       // 5

// Modify
numbers[0] = 10;           // Change element
numbers.add(6);            // Add to end
numbers.addAll([7, 8]);    // Add multiple
numbers.insert(0, 0);      // Insert at index
numbers.remove(10);        // Remove value
numbers.removeAt(0);       // Remove at index
numbers.removeLast();      // Remove last
numbers.clear();           // Remove all

// Slicing
var list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
var sub = list.sublist(2, 5);  // [2, 3, 4] (start inclusive, end exclusive)
var start = list.sublist(5);   // [5, 6, 7, 8, 9] (from index to end)

// Contains and index
print(list.contains(5));   // true
print(list.indexOf(5));    // 5
print(list.indexOf(99));   // -1 (not found)
```

> **📘 Python Note:** Similar to Python but slicing uses `.sublist()` method instead of `[start:end]` syntax.

### List Methods

```dart
var numbers = [1, 2, 3, 4, 5];

// map - transform each element
var doubled = numbers.map((n) => n * 2).toList();
print(doubled);  // [2, 4, 6, 8, 10]

// where - filter elements
var evens = numbers.where((n) => n % 2 == 0).toList();
print(evens);  // [2, 4]

// reduce - combine to single value
var sum = numbers.reduce((a, b) => a + b);
print(sum);  // 15

// fold - reduce with initial value
var product = numbers.fold(1, (a, b) => a * b);
print(product);  // 120

// any/every
print(numbers.any((n) => n > 3));    // true
print(numbers.every((n) => n > 0));  // true

// forEach
numbers.forEach((n) => print(n));

// sort
var unsorted = [3, 1, 4, 1, 5, 9, 2, 6];
unsorted.sort();  // Sorts in place
print(unsorted);  // [1, 1, 2, 3, 4, 5, 6, 9]

// Custom sort
unsorted.sort((a, b) => b.compareTo(a));  // Descending
```

> **📘 Python Note:** Very similar to Python's map, filter, reduce, any, all! Main difference: must call `.toList()` to convert Iterable to List.

## 📝 Sets

Sets are unordered collections of unique items (like Python sets).

### Creating Sets

```dart
// Type-inferred set
var numbers = {1, 2, 3, 4, 5};

// Explicitly typed set
Set<String> fruits = {"apple", "banana", "orange"};

// Empty set (must specify type!)
var emptySet = <int>{};  // Empty set
var notEmptyMap = {};     // Empty MAP, not set!

// From list (removes duplicates)
var uniqueNumbers = {1, 2, 2, 3, 3, 3}.toList();  // [1, 2, 3]
var set = Set<int>.from([1, 2, 2, 3, 3]);  // {1, 2, 3}
```

> **📘 Python Note:** Like Python sets, but empty set requires type annotation `<int>{}` because `{}` means empty map in Dart!

### Set Operations

```dart
var set1 = {1, 2, 3, 4, 5};
var set2 = {4, 5, 6, 7, 8};

// Add/remove
set1.add(6);
set1.addAll([7, 8, 9]);
set1.remove(1);

// Contains
print(set1.contains(3));  // true

// Set operations
var union = set1.union(set2);          // {1, 2, 3, 4, 5, 6, 7, 8}
var intersection = set1.intersection(set2);  // {4, 5}
var difference = set1.difference(set2);      // {1, 2, 3}

// Subset/superset
var small = {1, 2};
var big = {1, 2, 3, 4, 5};
print(small.difference(big).isEmpty);  // true (small is subset)
```

> **📘 Python Note:** Identical operations to Python! Union, intersection, difference all work the same way.

## 📝 Maps

Maps are key-value pairs (like Python dictionaries).

### Creating Maps

```dart
// Type-inferred map
var ages = {"Alice": 30, "Bob": 25, "Charlie": 35};

// Explicitly typed map
Map<String, int> scores = {"Alice": 95, "Bob": 87};

// Empty map
var emptyMap = <String, String>{};
Map<int, String> idToName = {};

// From entries
var map = Map.fromEntries([
  MapEntry("a", 1),
  MapEntry("b", 2),
]);
```

### Map Operations

```dart
var scores = {"Alice": 95, "Bob": 87, "Charlie": 92};

// Access
print(scores["Alice"]);    // 95
print(scores["David"]);    // null (key doesn't exist)

// Safe access with default
print(scores["David"] ?? 0);  // 0

// Add/update
scores["David"] = 88;      // Add new
scores["Alice"] = 98;      // Update existing

// Remove
scores.remove("Bob");

// Contains
print(scores.containsKey("Alice"));      // true
print(scores.containsValue(95));         // true

// Keys and values
print(scores.keys);        // (Alice, Charlie, David)
print(scores.values);      // (98, 92, 88)
print(scores.entries);     // MapEntry objects

// Iterate
scores.forEach((key, value) {
  print("$key: $value");
});

for (var entry in scores.entries) {
  print("${entry.key}: ${entry.value}");
}

for (var key in scores.keys) {
  print("$key: ${scores[key]}");
}
```

> **📘 Python Note:** Similar to Python dicts. Use `??` for get-with-default instead of `.get(key, default)`.

### Map Methods

```dart
var numbers = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5};

// map - transform values
var doubled = numbers.map((k, v) => MapEntry(k, v * 2));
print(doubled);  // {one: 2, two: 4, three: 6, four: 8, five: 10}

// where on entries
var filtered = Map.fromEntries(
  numbers.entries.where((e) => e.value > 2)
);
print(filtered);  // {three: 3, four: 4, five: 5}

// Update value if exists
numbers.update("one", (v) => v * 10, ifAbsent: () => 0);
print(numbers["one"]);  // 10

// putIfAbsent - add only if key doesn't exist
numbers.putIfAbsent("six", () => 6);
numbers.putIfAbsent("one", () => 100);  // Won't update, key exists
```

## 📝 Generics

Generics provide type safety for collections.

### Why Generics Matter

```dart
// Without generics - can add any type (dangerous!)
var list = [];
list.add(1);
list.add("hello");
list.add(true);
// var sum = list.reduce((a, b) => a + b);  // Runtime error!

// With generics - type safe!
var numbers = <int>[];
numbers.add(1);
numbers.add(2);
// numbers.add("hello");  // Compile error! Type safe!
var sum = numbers.reduce((a, b) => a + b);  // Safe!
```

> **📘 Python Note:** Python has type hints but they're not enforced. Dart's generics are enforced at compile time, catching errors early!

### Generic Functions

```dart
// Generic function
T getFirst<T>(List<T> items) {
  if (items.isEmpty) throw StateError("List is empty");
  return items[0];
}

print(getFirst([1, 2, 3]));        // 1 (int)
print(getFirst(["a", "b"]));       // "a" (String)

// Generic class
class Box<T> {
  T value;
  Box(this.value);

  T getValue() => value;
  void setValue(T newValue) => value = newValue;
}

var intBox = Box<int>(42);
var stringBox = Box<String>("hello");

print(intBox.getValue());     // 42
// intBox.setValue("hello");  // Error! Type mismatch
```

## 📝 Advanced Collection Operations

### Chaining Operations

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Complex pipeline
var result = numbers
    .where((n) => n % 2 == 0)        // Filter evens: [2, 4, 6, 8, 10]
    .map((n) => n * n)                // Square: [4, 16, 36, 64, 100]
    .where((n) => n > 20)             // > 20: [36, 64, 100]
    .toList();

print(result);  // [36, 64, 100]

// String processing
var words = ["hello", "world", "dart", "is", "awesome"];

var processed = words
    .where((w) => w.length > 3)
    .map((w) => w.toUpperCase())
    .map((w) => "$w!")
    .join(", ");

print(processed);  // HELLO!, WORLD!, DART!, AWESOME!
```

### Collection If/For (Review)

```dart
// Collection if
var isPremium = true;
var features = [
  "basic",
  if (isPremium) "advanced",
  if (isPremium) "priority support",
];

// Collection for
var numbers = [1, 2, 3, 4, 5];
var doubled = [for (var n in numbers) n * 2];

// Combined
var processed = [
  for (var n in numbers)
    if (n % 2 == 0) n * 2
];

// In maps
var config = {
  "version": "1.0",
  if (isPremium) "theme": "premium",
  for (var i = 1; i <= 3; i++) "level$i": i * 10,
};
```

## ✍️ Exercises

### Exercise 1: Lists and Sets

Master list and set operations.

👉 **[Start Exercise 1: Lists and Sets](exercises/1-lists-and-sets.md)**

### Exercise 2: Maps

Work with maps and key-value pairs.

👉 **[Start Exercise 2: Maps](exercises/2-maps.md)**

### Exercise 3: Collection Challenges

Apply all collection concepts.

👉 **[Start Exercise 3: Collection Challenges](exercises/3-collection-challenges.md)**

## 📚 What You Learned

✅ Lists, Sets, and Maps
✅ Generics for type safety
✅ Collection methods (.map, .where, .reduce)
✅ Collection if/for
✅ Chaining operations
✅ Performance characteristics

## 🔜 Next Steps

**Next tutorial: 6-Object-Oriented-Programming**

## 💡 Key Takeaways for Python Developers

1. **Type Safety**: Generics are enforced at compile time
2. **Empty Set**: `<int>{}` not `{}` (that's a map!)
3. **toList()**: Must convert Iterable to List explicitly
4. **Null Safety**: Maps return null for missing keys
5. **Collection If/For**: Cleaner than Python in some cases

## 🆘 Common Pitfalls

### Pitfall 1: Empty Set vs Map

```dart
// ❌ Wrong - this is a map!
var set = {};

// ✅ Correct - specify type for empty set
var set = <int>{};
```

### Pitfall 2: Forgetting toList()

```dart
// ❌ Wrong - map returns Iterable
var doubled = numbers.map((n) => n * 2);  // Iterable, not List

// ✅ Correct
var doubled = numbers.map((n) => n * 2).toList();
```

## 📖 Additional Resources

- [Dart Language Tour - Collections](https://dart.dev/language/collections)
- [Dart Language Tour - Generics](https://dart.dev/language/generics)

---

Ready to get started? Begin with **[Exercise 1: Lists and Sets](exercises/1-lists-and-sets.md)**!
