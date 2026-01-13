# Exercise 2: Loops

In this exercise, you'll explore Dart's various loop constructs and learn about Dart's unique collection operators - collection if/for and spread operators.

## 🎯 Objective

Master all of Dart's loop types and collection operators to write efficient, clean code.

## 📋 What You'll Learn

- Traditional for loops and for-in loops
- While and do-while loops
- Break and continue statements
- Collection if and for (Dart's secret weapon!)
- Spread operators

## 🚀 Steps

### Step 1: Start Your REPL

Make sure your environment is running and start the Dart REPL:

```bash
make dart-repl
```

### Step 2: Traditional For Loops

**Basic C-style for loops:**

```dart
// Count from 0 to 4
for (var i = 0; i < 5; i++) {
  print(i);
}

// Count backwards
for (var i = 5; i > 0; i--) {
  print(i);
}

// Step by 2
for (var i = 0; i < 10; i += 2) {
  print(i);  // 0, 2, 4, 6, 8
}

// Multiple variables
for (var i = 0, j = 10; i < j; i++, j--) {
  print("i=$i, j=$j");
}
```

> **📘 Python Note:** This is the traditional C-style for loop. Python's `for i in range(5):` is cleaner, but Dart's for-in loop (next section) is equivalent.

### Step 3: For-In Loops

**Iterating over collections:**

```dart
// Iterate over a list
var fruits = ["apple", "banana", "orange", "mango"];

for (var fruit in fruits) {
  print(fruit);
}

// Iterate over a set
var colors = {"red", "green", "blue"};

for (var color in colors) {
  print(color);
}

// Iterate over string characters
var word = "Dart";
for (var char in word.split('')) {
  print(char);
}

// Iterate over map entries
var scores = {
  "Alice": 95,
  "Bob": 87,
  "Charlie": 92
};

for (var entry in scores.entries) {
  print("${entry.key}: ${entry.value}");
}

// Just keys or values
for (var name in scores.keys) {
  print("Name: $name");
}

for (var score in scores.values) {
  print("Score: $score");
}
```

**With index (like Python's enumerate):**

```dart
// Using indexed (Dart 3.0+)
var items = ["first", "second", "third"];

for (var item in items.indexed) {
  print("Index ${item.$1}: ${item.$2}");
  // $1 is the index, $2 is the value
}

// Alternative: use asMap()
for (var entry in items.asMap().entries) {
  print("Index ${entry.key}: ${entry.value}");
}

// Traditional approach
for (var i = 0; i < items.length; i++) {
  print("Index $i: ${items[i]}");
}
```

> **📘 Python Note:** The `indexed` getter is like Python's `enumerate()`. Very handy when you need both index and value!

### Step 4: While and Do-While Loops

**While loops:**

```dart
// Basic while loop
var count = 0;
while (count < 5) {
  print("Count: $count");
  count++;
}

// While with more complex condition
var sum = 0;
var i = 1;
while (sum < 100) {
  sum += i;
  i++;
}
print("Sum: $sum, i: $i");

// Infinite loop (controlled with break)
var attempts = 0;
while (true) {
  attempts++;
  print("Attempt $attempts");
  if (attempts >= 3) {
    break;
  }
}
```

**Do-while loops:**

```dart
// Execute at least once
var n = 0;
do {
  print("n = $n");
  n++;
} while (n < 5);

// Even executes when condition is initially false
var x = 10;
do {
  print("x = $x");  // Prints once!
  x++;
} while (x < 5);  // Condition is false, but body executes once

// Useful for validation
var password = "short";
var valid = false;
do {
  print("Password length: ${password.length}");
  valid = password.length >= 8;
  if (!valid) {
    print("Password too short, need 8+ characters");
    break;  // Would normally get input and try again
  }
} while (!valid);
```

> **📘 Python Note:** Python doesn't have do-while loops. You typically use `while True` with a break condition.

### Step 5: Break and Continue

**Break - exit loop immediately:**

```dart
// Break out of loop
for (var i = 0; i < 10; i++) {
  if (i == 5) {
    break;  // Stop at 5
  }
  print(i);  // 0, 1, 2, 3, 4
}

// Find first match
var numbers = [1, 3, 5, 7, 8, 9, 10];
var firstEven = -1;
for (var n in numbers) {
  if (n % 2 == 0) {
    firstEven = n;
    break;  // Found it, stop searching
  }
}
print("First even number: $firstEven");
```

**Continue - skip to next iteration:**

```dart
// Skip certain values
for (var i = 0; i < 10; i++) {
  if (i % 2 == 0) {
    continue;  // Skip even numbers
  }
  print(i);  // 1, 3, 5, 7, 9
}

// Process only valid items
var items = ["apple", "", "banana", "", "orange"];
for (var item in items) {
  if (item.isEmpty) {
    continue;  // Skip empty strings
  }
  print("Processing: $item");
}
```

**Labeled loops (break outer loops):**

```dart
// Break out of nested loops
outer:
for (var i = 0; i < 3; i++) {
  for (var j = 0; j < 3; j++) {
    print("$i, $j");
    if (i == 1 && j == 1) {
      break outer;  // Break the outer loop
    }
  }
}

// Continue outer loop
outer:
for (var i = 0; i < 3; i++) {
  for (var j = 0; j < 3; j++) {
    if (j == 1) {
      continue outer;  // Skip to next i
    }
    print("$i, $j");
  }
}
```

> **📘 Python Note:** Python doesn't have labeled loops. You typically use flags or functions with return to achieve similar behavior.

### Step 6: Collection If (Dart's Secret Weapon!)

This is one of Dart's coolest features - conditional elements in collections!

```dart
// Basic collection if
var includeExtras = true;
var shoppingList = [
  "milk",
  "bread",
  if (includeExtras) "cookies",
  if (includeExtras) "ice cream",
];
print(shoppingList);  // ["milk", "bread", "cookies", "ice cream"]

includeExtras = false;
shoppingList = [
  "milk",
  "bread",
  if (includeExtras) "cookies",
  if (includeExtras) "ice cream",
];
print(shoppingList);  // ["milk", "bread"]

// With else
var isPremium = true;
var features = [
  "basic feature",
  if (isPremium)
    "advanced feature"
  else
    "trial feature",
];
print(features);

// Multiple conditions
var age = 25;
var hasLicense = true;
var allowedActivities = [
  "walking",
  if (age >= 16) "driving a car",
  if (age >= 16 && hasLicense) "driving alone",
  if (age >= 18) "voting",
  if (age >= 21) "drinking (in US)",
];
print(allowedActivities);

// In maps
var userConfig = {
  "theme": "light",
  "language": "en",
  if (isPremium) "adFree": true,
  if (isPremium) "exportData": true,
};
print(userConfig);

// In sets
var permissions = {
  "read",
  "write",
  if (isPremium) "delete",
  if (isPremium) "admin",
};
print(permissions);
```

> **📘 Python Note:** This is much cleaner than Python's approach! Compare:
> - Python: `items = ["a", "b"] + (["c"] if condition else [])`
> - Dart: `items = ["a", "b", if (condition) "c"]`

### Step 7: Collection For

Transform and generate collections inline!

```dart
// Basic collection for
var numbers = [1, 2, 3, 4, 5];
var doubled = [
  for (var n in numbers) n * 2
];
print(doubled);  // [2, 4, 6, 8, 10]

// With transformation
var words = ["hello", "world", "dart"];
var shouting = [
  for (var word in words) word.toUpperCase()
];
print(shouting);  // ["HELLO", "WORLD", "DART"]

// Generate sequences
var squares = [
  for (var i = 1; i <= 5; i++) i * i
];
print(squares);  // [1, 4, 9, 16, 25]

// With both for and if
var evenDoubled = [
  for (var n in numbers)
    if (n % 2 == 0) n * 2
];
print(evenDoubled);  // [4, 8]

// Nested collections
var matrix = [
  for (var i = 0; i < 3; i++)
    [for (var j = 0; j < 3; j++) i * 3 + j]
];
print(matrix);  // [[0, 1, 2], [3, 4, 5], [6, 7, 8]]

// Flatten a list
var nested = [[1, 2], [3, 4], [5, 6]];
var flattened = [
  for (var list in nested)
    for (var item in list) item
];
print(flattened);  // [1, 2, 3, 4, 5, 6]
```

**Collection for in maps:**

```dart
// Transform to map
var names = ["Alice", "Bob", "Charlie"];
var nameLengths = {
  for (var name in names) name: name.length
};
print(nameLengths);  // {Alice: 5, Bob: 3, Charlie: 7}

// Square map
var numberSquares = {
  for (var i = 1; i <= 5; i++) i: i * i
};
print(numberSquares);  // {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

// With filtering
var scores = {"Alice": 95, "Bob": 67, "Charlie": 88};
var passing = {
  for (var entry in scores.entries)
    if (entry.value >= 70) entry.key: entry.value
};
print(passing);  // {Alice: 95, Charlie: 88}
```

> **📘 Python Note:** Similar to Python's list/dict comprehensions, but the syntax is different:
> - Python: `[x*2 for x in numbers if x % 2 == 0]`
> - Dart: `[for (var x in numbers) if (x % 2 == 0) x*2]`

### Step 8: Spread Operator

Unpack collections into other collections!

```dart
// Basic spread
var fruits = ["apple", "banana"];
var vegetables = ["carrot", "broccoli"];

var food = [...fruits, ...vegetables];
print(food);  // ["apple", "banana", "carrot", "broccoli"]

// Mix with regular items
var menu = [
  "appetizer",
  ...fruits,
  "main course",
  ...vegetables,
  "dessert"
];
print(menu);

// Spread with transformation
var numbers = [1, 2, 3];
var moreNumbers = [4, 5, 6];

var combined = [
  0,
  ...numbers,
  ...moreNumbers.map((n) => n * 10),
  100
];
print(combined);  // [0, 1, 2, 3, 40, 50, 60, 100]

// Null-aware spread
List<String>? optionalItems;
var items = [
  "always here",
  ...?optionalItems,  // Only spreads if not null
  "also always here"
];
print(items);  // ["always here", "also always here"]

optionalItems = ["conditional1", "conditional2"];
items = [
  "always here",
  ...?optionalItems,
  "also always here"
];
print(items);  // ["always here", "conditional1", "conditional2", "also always here"]
```

**Spread in maps:**

```dart
// Merge maps
var defaults = {
  "theme": "light",
  "language": "en",
  "notifications": true
};

var userPrefs = {
  "theme": "dark",
  "fontSize": 14
};

var config = {
  ...defaults,
  ...userPrefs,  // Overrides theme
};
print(config);
// {theme: dark, language: en, notifications: true, fontSize: 14}

// Conditional spread
Map<String, dynamic>? extraConfig;
var finalConfig = {
  ...defaults,
  ...?extraConfig,  // Only if not null
};
```

> **📘 Python Note:** Similar to Python's `*` unpacking:
> - Python: `food = [*fruits, *vegetables]`
> - Dart: `food = [...fruits, ...vegetables]`

### Step 9: Combining Everything

Let's combine collection for, if, and spread!

```dart
// Complex example
var numbers = [1, 2, 3, 4, 5];
var bonusNumbers = [10, 20];

var processed = [
  0,  // Start
  ...numbers,  // Spread original
  for (var n in numbers) if (n % 2 == 0) n * 2,  // Even doubled
  ...bonusNumbers.map((n) => n ~/ 2),  // Bonus halved
  100  // End
];
print(processed);  // [0, 1, 2, 3, 4, 5, 4, 8, 5, 10, 100]

// Create a complex configuration
var isProduction = false;
var enableAnalytics = true;
var optionalFeatures = ["feature1", "feature2"];

var config = {
  "env": isProduction ? "prod" : "dev",
  "debug": !isProduction,
  if (enableAnalytics) "analytics": {
    "enabled": true,
    "provider": "google"
  },
  "features": [
    "core",
    if (isProduction) "optimization",
    if (!isProduction) "debug-tools",
    ...optionalFeatures,
  ]
};
print(config);
```

### Step 10: Practice Exercise - Number Processor

Create various transformations using loops and collection operators.

**Try this yourself:**

```dart
// Given this list of numbers
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// TODO 1: Create a list of only even numbers
var evens = [
  for (var n in numbers) if (n % 2 == 0) n
];
print("Evens: $evens");

// TODO 2: Create a list of squares of odd numbers
var oddSquares = [
  for (var n in numbers) if (n % 2 != 0) n * n
];
print("Odd squares: $oddSquares");

// TODO 3: Create a list with numbers < 5 doubled, >= 5 tripled
var transformed = [
  for (var n in numbers) n < 5 ? n * 2 : n * 3
];
print("Transformed: $transformed");

// TODO 4: Sum all numbers using a for loop
var sum = 0;
for (var n in numbers) {
  sum += n;
}
print("Sum: $sum");

// TODO 5: Find the first number > 7
var firstAboveSeven = -1;
for (var n in numbers) {
  if (n > 7) {
    firstAboveSeven = n;
    break;
  }
}
print("First > 7: $firstAboveSeven");
```

### Step 11: Script Challenge - Pattern Generator

Create a script that generates various patterns using loops.

**Create this file:** `/home/user/learning-with-claude/dart/tutorials/3-Control-Flow/exercises/pattern_generator.dart`

```dart
void main() {
  print("=== Right Triangle ===");
  printRightTriangle(5);

  print("\n=== Pyramid ===");
  printPyramid(5);

  print("\n=== Multiplication Table ===");
  printMultiplicationTable(10);

  print("\n=== Number Grid ===");
  printNumberGrid(5, 5);
}

void printRightTriangle(int height) {
  for (var i = 1; i <= height; i++) {
    var stars = [for (var j = 0; j < i; j++) "*"].join();
    print(stars);
  }
}

void printPyramid(int height) {
  for (var i = 1; i <= height; i++) {
    var spaces = " " * (height - i);
    var stars = [for (var j = 0; j < (2 * i - 1); j++) "*"].join();
    print("$spaces$stars");
  }
}

void printMultiplicationTable(int size) {
  for (var i = 1; i <= size; i++) {
    var row = [
      for (var j = 1; j <= size; j++)
        (i * j).toString().padLeft(4)
    ].join();
    print(row);
  }
}

void printNumberGrid(int rows, int cols) {
  var grid = [
    for (var i = 0; i < rows; i++)
      [for (var j = 0; j < cols; j++) i * cols + j]
  ];

  for (var row in grid) {
    print(row.map((n) => n.toString().padLeft(3)).join(" "));
  }
}
```

**Run it:**

```bash
make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/3-Control-Flow/exercises/pattern_generator.dart
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You understand all loop types (for, for-in, while, do-while)
- [ ] You can use break and continue effectively
- [ ] You master collection if for conditional elements
- [ ] You can use collection for for transformations
- [ ] You understand spread operators
- [ ] You can combine these features effectively
- [ ] You created and ran the pattern generator script

## 🎓 Key Takeaways

**Critical Differences from Python:**

1. **Multiple Loop Types:** Dart has more variety than Python
2. **Collection If/For:** More readable than many list comprehensions
3. **Spread Operator:** `...` instead of Python's `*`
4. **Labeled Loops:** Can break/continue outer loops
5. **Do-While:** Python doesn't have this construct

**Dart Idioms:**

```dart
// ✅ Good - use collection for/if for simple transformations
var evens = [for (var n in numbers) if (n % 2 == 0) n];

// ✅ Good - use spread to combine collections
var all = [...list1, ...list2];

// ✅ Good - use for-in for iteration
for (var item in items) { }

// ❌ Avoid - complex collection expressions
var x = [
  for (var a in list1)
    for (var b in list2)
      if (complex condition)
        complex transformation
]; // Too complex! Use regular loops

// ❌ Avoid - traditional for when for-in works
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  // ...
}
// Better: for (var item in items) { }
```

## 🎉 Congratulations!

You now understand all of Dart's loop constructs and powerful collection operators!

## 🔜 Next Steps

Move on to **Exercise 3: FizzBuzz Challenge** to put everything together!

## 💡 Pro Tips

- Use collection if/for for clean, readable transformations
- Prefer for-in over traditional for when you don't need the index
- Use spread operators to combine collections elegantly
- Break and continue can make code more readable
- Do-while is perfect for validation loops
