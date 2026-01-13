# Tutorial 3: Control Flow - Conditionals, Loops, and Pattern Matching

Welcome to your third Dart tutorial! This guide explores Dart's control flow constructs, including some powerful features like pattern matching in switch statements and collection operators that Python developers will find interesting.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Master if/else statements and ternary operators
- Understand Dart's enhanced switch/case with pattern matching
- Work with for, while, and do-while loops
- Use break and continue effectively
- Leverage collection if and for (Dart's unique feature!)
- Use spread operators for collections

## 🐍➡️🎯 Coming from Python

If you're a Python developer, you'll notice several differences:

| Concept | Python | Dart |
|---------|--------|------|
| If statement | `if condition:` | `if (condition) {` |
| Else if | `elif` | `else if` |
| Ternary | `a if condition else b` | `condition ? a : b` |
| Switch statement | No built-in switch (use match in 3.10+) | `switch/case` with pattern matching |
| For loop | `for item in items:` | `for (var item in items) {` |
| Range loop | `for i in range(10):` | `for (var i = 0; i < 10; i++)` |
| While loop | `while condition:` | `while (condition) {` |
| List comprehension | `[x*2 for x in items if x > 0]` | `[for (var x in items) if (x > 0) x*2]` |
| Spread operator | `*items` | `...items` |

## 📝 Conditional Statements

### Basic if/else

```dart
// Simple if statement
var age = 25;
if (age >= 18) {
  print("Adult");
}

// if/else
if (age >= 18) {
  print("Adult");
} else {
  print("Minor");
}

// if/else if/else
if (age >= 65) {
  print("Senior");
} else if (age >= 18) {
  print("Adult");
} else if (age >= 13) {
  print("Teenager");
} else {
  print("Child");
}
```

> **📘 Python Note:** Dart uses `else if` instead of Python's `elif`. Braces `{}` are required (not optional like in single-line Python statements), and parentheses around conditions are mandatory.

### No Implicit Truthiness

```dart
// ❌ Python-style truthiness doesn't work
var name = "";
// if (name) {  // Error! Must be a boolean
//   print("Has name");
// }

// ✅ Dart requires explicit boolean
if (name.isNotEmpty) {
  print("Has name");
}

// Common explicit checks
if (name != null && name.isNotEmpty) { }
if (list.isNotEmpty) { }
if (map.containsKey("key")) { }
if (value == 0) { }  // Explicit check for zero
```

> **📘 Python Note:** Unlike Python where empty strings, 0, None, [], {} are all "falsy", Dart requires explicit boolean expressions. This prevents subtle bugs!

### Ternary Operator

```dart
// Ternary operator: condition ? ifTrue : ifFalse
var age = 20;
var status = age >= 18 ? "Adult" : "Minor";

// Can be nested (but keep it readable)
var category = age >= 65 ? "Senior"
             : age >= 18 ? "Adult"
             : "Minor";

// Use in assignments
var discount = isPremium ? 0.20 : 0.10;
```

> **📘 Python Note:** Dart uses C-style ternary `condition ? a : b`, whereas Python uses `a if condition else b`. Dart's syntax is more common across languages.

### Null-Aware Operators (Preview)

```dart
// ?? - null coalescing operator
String? name;
var displayName = name ?? "Guest";  // Use "Guest" if name is null

// ??= - assign if null
name ??= "Default";  // Only assigns if name is null

// ?. - null-aware access
var length = name?.length;  // Returns null if name is null
```

> **📘 Python Note:** These operators are similar to Python's walrus operator `:=` and optional chaining, but more powerful. We'll cover these in detail in the Null Safety tutorial.

## 📝 Switch Statements with Pattern Matching

Dart's switch statements are much more powerful than traditional C-style switches and can do pattern matching similar to Python 3.10+'s match statement.

### Basic Switch

```dart
// Traditional switch
var command = "start";

switch (command) {
  case "start":
    print("Starting...");
    break;  // break is required!
  case "stop":
    print("Stopping...");
    break;
  case "pause":
    print("Pausing...");
    break;
  default:
    print("Unknown command");
}
```

> **📘 Python Note:** Unlike Python which didn't have switch until 3.10, Dart has always had it. The `break` statement is required (no fall-through by default like C).

### Multiple Cases

```dart
var grade = "B";

switch (grade) {
  case "A":
  case "A+":
  case "A-":
    print("Excellent!");
    break;
  case "B":
  case "B+":
  case "B-":
    print("Good!");
    break;
  case "C":
    print("Average");
    break;
  default:
    print("Needs improvement");
}
```

### Switch Expressions (Dart 3.0+)

```dart
// Switch as an expression - much cleaner!
var command = "start";

var message = switch (command) {
  "start" => "Starting...",
  "stop" => "Stopping...",
  "pause" => "Pausing...",
  _ => "Unknown command"  // _ is the default pattern
};

print(message);
```

### Pattern Matching

```dart
// Pattern matching with types
Object value = 42;

var description = switch (value) {
  int n when n > 0 => "Positive integer",
  int n when n < 0 => "Negative integer",
  int _ => "Zero",
  String s => "String: $s",
  List l => "List with ${l.length} items",
  _ => "Something else"
};

// Pattern matching with records (Dart 3.0+)
var point = (x: 10, y: 20);

var quadrant = switch (point) {
  (x: var x, y: var y) when x > 0 && y > 0 => "Q1",
  (x: var x, y: var y) when x < 0 && y > 0 => "Q2",
  (x: var x, y: var y) when x < 0 && y < 0 => "Q3",
  (x: var x, y: var y) when x > 0 && y < 0 => "Q4",
  _ => "Origin or axis"
};
```

> **📘 Python Note:** This is similar to Python 3.10+'s match/case, but Dart had switch statements much earlier. The pattern matching with guards (`when`) is very powerful!

## 📝 Loops

### For Loops - Traditional C-Style

```dart
// Classic for loop
for (var i = 0; i < 5; i++) {
  print(i);  // 0, 1, 2, 3, 4
}

// Count backwards
for (var i = 5; i > 0; i--) {
  print(i);  // 5, 4, 3, 2, 1
}

// Step by 2
for (var i = 0; i < 10; i += 2) {
  print(i);  // 0, 2, 4, 6, 8
}

// Multiple variables
for (var i = 0, j = 10; i < j; i++, j--) {
  print("$i, $j");
}
```

> **📘 Python Note:** This is like other C-style languages. Python's `for i in range(5)` is cleaner, but Dart's for-in loop (next section) is similar.

### For-In Loops

```dart
// Iterate over collections
var fruits = ["apple", "banana", "orange"];

for (var fruit in fruits) {
  print(fruit);
}

// With string
var text = "Hello";
for (var char in text.split('')) {
  print(char);
}

// With maps (iterate over entries)
var scores = {"Alice": 95, "Bob": 87, "Charlie": 92};

for (var entry in scores.entries) {
  print("${entry.key}: ${entry.value}");
}

// With index using indexed (similar to Python's enumerate)
for (var item in fruits.indexed) {
  print("${item.$1}: ${item.$2}");  // index: value
}
```

> **📘 Python Note:** Very similar to Python's `for item in items:`. The `indexed` getter is like Python's `enumerate()`.

### While Loops

```dart
// Basic while loop
var count = 0;
while (count < 5) {
  print(count);
  count++;
}

// While with condition
var input = "";
while (input != "quit") {
  print("Type 'quit' to exit");
  // input = stdin.readLineSync() ?? "";
  break;  // For example purposes
}

// Infinite loop (be careful!)
// while (true) {
//   // Do something
//   if (shouldBreak) break;
// }
```

### Do-While Loops

```dart
// Execute at least once, then check condition
var i = 0;
do {
  print(i);
  i++;
} while (i < 5);

// Useful for validation
var password = "";
do {
  print("Enter password:");
  // password = getInput();
  break;  // For example
} while (password.length < 8);
```

> **📘 Python Note:** Python doesn't have do-while loops. Use `while True` with a break condition instead.

### Break and Continue

```dart
// break - exit loop immediately
for (var i = 0; i < 10; i++) {
  if (i == 5) break;  // Stop at 5
  print(i);  // 0, 1, 2, 3, 4
}

// continue - skip to next iteration
for (var i = 0; i < 10; i++) {
  if (i % 2 == 0) continue;  // Skip even numbers
  print(i);  // 1, 3, 5, 7, 9
}

// break in nested loops
outer:
for (var i = 0; i < 3; i++) {
  for (var j = 0; j < 3; j++) {
    if (i == 1 && j == 1) break outer;  // Break outer loop
    print("$i, $j");
  }
}
```

## 📝 Collection If and For (Dart's Secret Weapon!)

One of Dart's coolest features - use if/for directly inside collections!

### Collection If

```dart
// Conditionally include items
var includeFruit = true;
var items = [
  "milk",
  "bread",
  if (includeFruit) "apple",  // Only added if true!
  if (includeFruit) "banana",
];

// With else
var isPremium = true;
var features = [
  "basic feature",
  if (isPremium) "advanced feature" else "trial feature",
];

// Multiple conditions
var age = 25;
var allowedItems = [
  "toy",
  if (age >= 13) "video game",
  if (age >= 18) "adult content",
  if (age >= 21) "alcohol",
];
```

> **📘 Python Note:** This is cleaner than Python's conditional expressions in lists: `["apple" if condition else None]`. No need for filtering afterwards!

### Collection For

```dart
// Generate items with for loops
var numbers = [1, 2, 3];
var doubled = [
  for (var n in numbers) n * 2  // [2, 4, 6]
];

// More complex transformations
var words = ["hello", "world"];
var shouting = [
  for (var word in words) word.toUpperCase()  // ["HELLO", "WORLD"]
];

// Nested collections
var matrix = [
  for (var i = 0; i < 3; i++)
    [for (var j = 0; j < 3; j++) i * 3 + j]
];
// [[0, 1, 2], [3, 4, 5], [6, 7, 8]]

// With conditions
var evenDoubled = [
  for (var n in numbers)
    if (n % 2 == 0) n * 2  // Only even numbers, doubled
];
```

> **📘 Python Note:** Similar to Python's list comprehensions `[x*2 for x in numbers if x % 2 == 0]`, but the syntax is slightly different. Dart uses collection literals directly!

### Collection If/For in Maps and Sets

```dart
// In Maps
var isPremium = true;
var config = {
  "version": "1.0",
  if (isPremium) "theme": "dark",
  if (isPremium) "ads": false,
};

// Generate map entries
var numbers = [1, 2, 3, 4, 5];
var numberMap = {
  for (var n in numbers) n: n * n  // {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
};

// In Sets
var activeFeatures = {
  "login",
  "profile",
  if (isPremium) "export",
  if (isPremium) "analytics",
};
```

## 📝 Spread Operator

The spread operator `...` unpacks collections into other collections.

### Basic Spread

```dart
// Spread lists
var fruits = ["apple", "banana"];
var vegetables = ["carrot", "broccoli"];

var food = [...fruits, ...vegetables];
// ["apple", "banana", "carrot", "broccoli"]

// Add items around spread
var menu = [
  "appetizer",
  ...fruits,
  "main course",
  ...vegetables,
  "dessert"
];
```

> **📘 Python Note:** Similar to Python's `*` unpacking: `food = [*fruits, *vegetables]`. Dart uses `...` instead.

### Null-Aware Spread

```dart
// Handle nullable lists
List<String>? optionalItems;

var items = [
  "always included",
  ...?optionalItems,  // Only spreads if not null
];
```

### Spread in Maps

```dart
// Spread maps
var defaults = {"theme": "light", "lang": "en"};
var userPrefs = {"theme": "dark"};

var config = {
  ...defaults,
  ...userPrefs,  // Overrides defaults
};
// {"theme": "dark", "lang": "en"}
```

### Combining Spread with Collection For/If

```dart
// Powerful combinations!
var numbers = [1, 2, 3];
var moreNumbers = [4, 5, 6];

var processed = [
  0,
  ...numbers,
  for (var n in moreNumbers) if (n % 2 == 0) n * 2,  // 8, 12
  100
];
// [0, 1, 2, 3, 8, 12, 100]
```

## ✍️ Exercises

Ready to practice? Let's solidify your understanding with hands-on exercises!

### Exercise 1: Conditionals

Learn Dart's conditional statements and pattern matching.

👉 **[Start Exercise 1: Conditionals](exercises/1-conditionals.md)**

In this exercise, you'll:
- Use if/else statements effectively
- Master the ternary operator
- Explore switch statements with pattern matching
- Compare with Python's control flow

### Exercise 2: Loops

Master Dart's various loop constructs.

👉 **[Start Exercise 2: Loops](exercises/2-loops.md)**

In this exercise, you'll:
- Use for, while, and do-while loops
- Understand break and continue
- Use collection if/for
- Apply spread operators

### Exercise 3: FizzBuzz Challenge

Put it all together with a classic programming challenge.

👉 **[Start Exercise 3: FizzBuzz Challenge](exercises/3-fizzbuzz-challenge.md)**

In this exercise, you'll:
- Implement FizzBuzz multiple ways
- Use advanced control flow patterns
- Optimize with collection expressions
- Compare different approaches

## 📚 What You Learned

After completing the exercises, you will know:

✅ How to use if/else and switch statements
✅ Pattern matching in switch expressions
✅ All loop types: for, for-in, while, do-while
✅ Break and continue statements
✅ Collection if and for (Dart's killer feature!)
✅ Spread operators for collections
✅ Differences from Python's control flow

## 🔜 Next Steps

Congratulations on completing the Control Flow tutorial! You now understand:
- All conditional and loop constructs in Dart
- Pattern matching with switch expressions
- Collection operators that make code cleaner
- Key differences from Python

You're ready to learn about functions!

**Next tutorial: 4-Functions**

## 💡 Key Takeaways for Python Developers

1. **Explicit Booleans:** No implicit truthiness - be explicit!
2. **Pattern Matching:** Switch expressions are powerful and clean
3. **Collection If/For:** Cleaner than list comprehensions in many cases
4. **Spread Operator:** Use `...` to unpack collections
5. **Break Required:** Switch cases need explicit break statements
6. **Multiple Loop Types:** More variety than Python (do-while, C-style for)

## 🆘 Common Pitfalls

### Pitfall 1: Implicit Truthiness

```dart
// ❌ Wrong - trying to use Python-style truthiness
var list = [];
// if (list) { }  // Error! Must be boolean

// ✅ Correct - explicit check
if (list.isNotEmpty) { }
if (list.isEmpty) { }
```

### Pitfall 2: Forgetting Break in Switch

```dart
// ❌ Wrong - missing break causes error
switch (value) {
  case 1:
    print("One");
    // Missing break - compile error!
  case 2:
    print("Two");
    break;
}

// ✅ Correct - include break
switch (value) {
  case 1:
    print("One");
    break;
  case 2:
    print("Two");
    break;
}
```

### Pitfall 3: Modifying Collection While Iterating

```dart
// ❌ Wrong - modifying while iterating
var numbers = [1, 2, 3, 4, 5];
for (var n in numbers) {
  if (n % 2 == 0) {
    // numbers.remove(n);  // Throws error!
  }
}

// ✅ Correct - use where to filter
var numbers = [1, 2, 3, 4, 5];
numbers = numbers.where((n) => n % 2 != 0).toList();

// Or use removeWhere
numbers.removeWhere((n) => n % 2 == 0);
```

### Pitfall 4: Not Using Collection If/For

```dart
// ❌ Less efficient - filter after creation
var numbers = [1, 2, 3, 4, 5];
var doubled = numbers.map((n) => n * 2).where((n) => n > 5).toList();

// ✅ Better - use collection for/if
var doubled = [
  for (var n in numbers)
    if (n * 2 > 5) n * 2
];
```

## 📖 Additional Resources

- [Dart Language Tour - Control Flow](https://dart.dev/language/loops)
- [Dart Language Tour - Branches](https://dart.dev/language/branches)
- [Dart Language Tour - Pattern Matching](https://dart.dev/language/patterns)
- [Dart 3.0 - Pattern Matching](https://dart.dev/language/pattern-types)

---

Ready to get started? Begin with **[Exercise 1: Conditionals](exercises/1-conditionals.md)**!
