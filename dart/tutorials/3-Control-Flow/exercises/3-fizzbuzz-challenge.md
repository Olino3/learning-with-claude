# Exercise 3: FizzBuzz Challenge

The classic FizzBuzz problem - but we'll solve it multiple ways using different Dart control flow features!

## 🎯 Objective

Implement FizzBuzz using various control flow techniques and understand the tradeoffs of different approaches.

## 📋 What You'll Learn

- Apply all control flow concepts
- Compare different solution approaches
- Understand when to use each technique
- Write clean, idiomatic Dart code

## 🎮 The Challenge

**FizzBuzz Rules:**
- Print numbers from 1 to 100
- For multiples of 3, print "Fizz" instead of the number
- For multiples of 5, print "Buzz" instead of the number
- For multiples of both 3 and 5, print "FizzBuzz"
- Otherwise, print the number

**Example output:**
```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
...
```

## 🚀 Steps

### Step 1: Start Your REPL

```bash
make dart-repl
```

### Step 2: Classic If/Else Solution

The traditional approach using if/else statements:

```dart
void fizzBuzzClassic() {
  for (var i = 1; i <= 100; i++) {
    if (i % 15 == 0) {
      print("FizzBuzz");
    } else if (i % 3 == 0) {
      print("Fizz");
    } else if (i % 5 == 0) {
      print("Buzz");
    } else {
      print(i);
    }
  }
}

// Test it (first 15 numbers)
for (var i = 1; i <= 15; i++) {
  if (i % 15 == 0) {
    print("FizzBuzz");
  } else if (i % 3 == 0) {
    print("Fizz");
  } else if (i % 5 == 0) {
    print("Buzz");
  } else {
    print(i);
  }
}
```

> **📘 Python Note:** This is the standard approach in both Python and Dart. Order matters - check 15 first, then 3, then 5!

### Step 3: Switch Expression Solution

Use Dart's modern switch expression:

```dart
String fizzBuzz(int n) {
  return switch (n) {
    _ when n % 15 == 0 => "FizzBuzz",
    _ when n % 3 == 0 => "Fizz",
    _ when n % 5 == 0 => "Buzz",
    _ => n.toString()
  };
}

// Test it
for (var i = 1; i <= 15; i++) {
  print(fizzBuzz(i));
}
```

> **📘 Python Note:** This uses Dart's pattern matching, similar to Python 3.10+'s match/case. Very clean!

### Step 4: String Building Solution

Build the string incrementally - a clever alternative approach:

```dart
String fizzBuzzStringBuild(int n) {
  var result = "";
  if (n % 3 == 0) result += "Fizz";
  if (n % 5 == 0) result += "Buzz";
  return result.isEmpty ? n.toString() : result;
}

// Test it
for (var i = 1; i <= 15; i++) {
  print(fizzBuzzStringBuild(i));
}
```

> **📘 Python Note:** This approach is elegant and avoids checking for 15 explicitly. The logic is: if divisible by 3 add "Fizz", if divisible by 5 add "Buzz", and you automatically get "FizzBuzz" for both!

### Step 5: Collection For Solution

Generate the entire sequence using collection for:

```dart
// Generate list of FizzBuzz values
var fizzBuzzList = [
  for (var i = 1; i <= 100; i++)
    switch (i) {
      _ when i % 15 == 0 => "FizzBuzz",
      _ when i % 3 == 0 => "Fizz",
      _ when i % 5 == 0 => "Buzz",
      _ => i.toString()
    }
];

// Print first 15
for (var i = 0; i < 15; i++) {
  print(fizzBuzzList[i]);
}

// Or print all
// fizzBuzzList.forEach(print);
```

### Step 6: Ternary Operator Solution

Using nested ternary operators (not recommended, but educational):

```dart
String fizzBuzzTernary(int n) {
  return n % 15 == 0 ? "FizzBuzz"
       : n % 3 == 0 ? "Fizz"
       : n % 5 == 0 ? "Buzz"
       : n.toString();
}

// Test it
for (var i = 1; i <= 15; i++) {
  print(fizzBuzzTernary(i));
}
```

> **📘 Python Note:** This works but is less readable. Prefer if/else or switch for multiple conditions.

### Step 7: Map-Based Solution

Use a map for configuration - extensible approach:

```dart
String fizzBuzzMap(int n, Map<int, String> rules) {
  var result = "";
  for (var entry in rules.entries) {
    if (n % entry.key == 0) {
      result += entry.value;
    }
  }
  return result.isEmpty ? n.toString() : result;
}

// Define rules
var rules = {
  3: "Fizz",
  5: "Buzz",
};

// Test it
for (var i = 1; i <= 15; i++) {
  print(fizzBuzzMap(i, rules));
}

// Easy to extend!
var extendedRules = {
  3: "Fizz",
  5: "Buzz",
  7: "Bazz",
};
```

> **📘 Python Note:** This is a more advanced, extensible solution. Easy to add new rules without changing the function!

### Step 8: Compare Approaches

Let's analyze the different approaches:

```dart
// 1. Classic - Most readable for beginners
void classic(int n) {
  if (n % 15 == 0) print("FizzBuzz");
  else if (n % 3 == 0) print("Fizz");
  else if (n % 5 == 0) print("Buzz");
  else print(n);
}

// 2. Switch Expression - Clean, modern Dart
String switchExpr(int n) => switch (n) {
  _ when n % 15 == 0 => "FizzBuzz",
  _ when n % 3 == 0 => "Fizz",
  _ when n % 5 == 0 => "Buzz",
  _ => n.toString()
};

// 3. String Building - Elegant, no explicit 15 check
String stringBuild(int n) {
  var result = "";
  if (n % 3 == 0) result += "Fizz";
  if (n % 5 == 0) result += "Buzz";
  return result.isEmpty ? n.toString() : result;
}

// 4. Collection For - Generate entire sequence
var collectionFor = [
  for (var i = 1; i <= 100; i++) stringBuild(i)
];

// 5. Map-Based - Most extensible
String mapBased(int n, Map<int, String> rules) {
  var result = "";
  for (var entry in rules.entries) {
    if (n % entry.key == 0) result += entry.value;
  }
  return result.isEmpty ? n.toString() : result;
}

print("Which approach is best depends on your needs:");
print("- Clarity: Classic if/else");
print("- Modernity: Switch expression");
print("- Cleverness: String building");
print("- Extensibility: Map-based");
```

### Step 9: Full Script Challenge

Create a complete FizzBuzz implementation with all variations.

**Create this file:** `/home/user/learning-with-claude/dart/tutorials/3-Control-Flow/exercises/fizzbuzz.dart`

```dart
void main() {
  print("=== Classic FizzBuzz (1-30) ===");
  fizzBuzzClassic(30);

  print("\n=== Switch Expression (1-30) ===");
  fizzBuzzSwitch(30);

  print("\n=== String Building (1-30) ===");
  fizzBuzzStringBuild(30);

  print("\n=== Extended FizzBuzz with 7 (1-50) ===");
  fizzBuzzExtended(50, {3: "Fizz", 5: "Buzz", 7: "Bazz"});

  print("\n=== Collection Generation (1-20) ===");
  var results = generateFizzBuzz(20);
  results.forEach(print);
}

// Classic if/else approach
void fizzBuzzClassic(int limit) {
  for (var i = 1; i <= limit; i++) {
    if (i % 15 == 0) {
      print("FizzBuzz");
    } else if (i % 3 == 0) {
      print("Fizz");
    } else if (i % 5 == 0) {
      print("Buzz");
    } else {
      print(i);
    }
  }
}

// Switch expression approach
void fizzBuzzSwitch(int limit) {
  for (var i = 1; i <= limit; i++) {
    var result = switch (i) {
      _ when i % 15 == 0 => "FizzBuzz",
      _ when i % 3 == 0 => "Fizz",
      _ when i % 5 == 0 => "Buzz",
      _ => i.toString()
    };
    print(result);
  }
}

// String building approach
void fizzBuzzStringBuild(int limit) {
  for (var i = 1; i <= limit; i++) {
    var result = "";
    if (i % 3 == 0) result += "Fizz";
    if (i % 5 == 0) result += "Buzz";
    print(result.isEmpty ? i : result);
  }
}

// Extended version with custom rules
void fizzBuzzExtended(int limit, Map<int, String> rules) {
  for (var i = 1; i <= limit; i++) {
    var result = "";
    // Sort keys to ensure consistent order
    var sortedKeys = rules.keys.toList()..sort();
    for (var divisor in sortedKeys) {
      if (i % divisor == 0) {
        result += rules[divisor]!;
      }
    }
    print(result.isEmpty ? i : result);
  }
}

// Collection generation approach
List<String> generateFizzBuzz(int limit) {
  return [
    for (var i = 1; i <= limit; i++)
      () {
        var result = "";
        if (i % 3 == 0) result += "Fizz";
        if (i % 5 == 0) result += "Buzz";
        return result.isEmpty ? i.toString() : result;
      }()
  ];
}
```

**Run it:**

```bash
make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/3-Control-Flow/exercises/fizzbuzz.dart
```

### Step 10: Advanced Challenge - FizzBuzzBazz

Extend FizzBuzz to include 7 (Bazz):
- Multiples of 3: "Fizz"
- Multiples of 5: "Buzz"
- Multiples of 7: "Bazz"
- Combinations: "FizzBuzz", "FizzBazz", "BuzzBazz", "FizzBuzzBazz"

**Try implementing this yourself first!**

<details>
<summary>Click to see solution</summary>

```dart
void fizzBuzzBazz() {
  for (var i = 1; i <= 105; i++) {
    var result = "";
    if (i % 3 == 0) result += "Fizz";
    if (i % 5 == 0) result += "Buzz";
    if (i % 7 == 0) result += "Bazz";
    print(result.isEmpty ? i : result);
  }
}

// Test the special cases:
// 3 -> "Fizz"
// 5 -> "Buzz"
// 7 -> "Bazz"
// 15 -> "FizzBuzz"
// 21 -> "FizzBazz"
// 35 -> "BuzzBazz"
// 105 -> "FizzBuzzBazz"

fizzBuzzBazz();
```

Using switch expression:

```dart
String fizzBuzzBazzSwitch(int n) {
  var result = "";
  if (n % 3 == 0) result += "Fizz";
  if (n % 5 == 0) result += "Buzz";
  if (n % 7 == 0) result += "Bazz";
  return result.isEmpty ? n.toString() : result;
}

// Print special cases
var testCases = [3, 5, 7, 15, 21, 35, 105];
for (var n in testCases) {
  print("$n -> ${fizzBuzzBazzSwitch(n)}");
}
```

</details>

### Step 11: Performance Comparison

Let's compare the performance of different approaches (educational):

```dart
// This is just for learning - in real code, readability matters more!
import 'dart:io';

void benchmark() {
  var sw = Stopwatch()..start();

  // Method 1: Classic
  sw.reset();
  for (var n = 0; n < 1000000; n++) {
    for (var i = 1; i <= 100; i++) {
      if (i % 15 == 0) {
        var x = "FizzBuzz";
      } else if (i % 3 == 0) {
        var x = "Fizz";
      } else if (i % 5 == 0) {
        var x = "Buzz";
      } else {
        var x = i.toString();
      }
    }
  }
  print("Classic: ${sw.elapsedMilliseconds}ms");

  // Method 2: String building
  sw.reset();
  for (var n = 0; n < 1000000; n++) {
    for (var i = 1; i <= 100; i++) {
      var result = "";
      if (i % 3 == 0) result += "Fizz";
      if (i % 5 == 0) result += "Buzz";
      var x = result.isEmpty ? i.toString() : result;
    }
  }
  print("String building: ${sw.elapsedMilliseconds}ms");
}

// Note: Results will be similar - choose based on readability!
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You've implemented FizzBuzz at least 3 different ways
- [ ] You understand the tradeoffs of each approach
- [ ] You can extend FizzBuzz with new rules
- [ ] You created and ran the complete script
- [ ] You implemented FizzBuzzBazz successfully

## 🎓 Key Takeaways

**Solution Approaches:**

1. **Classic If/Else**: Most readable, explicit
2. **Switch Expression**: Modern, clean Dart 3.0 style
3. **String Building**: Elegant, automatically handles combinations
4. **Collection For**: Generates entire sequence at once
5. **Map-Based**: Most extensible and configurable

**When to Use Each:**

- **Learning/Interviews**: Classic if/else (clearest)
- **Modern Dart**: Switch expression (idiomatic)
- **Extensibility**: Map-based (easy to add rules)
- **Cleverness**: String building (elegant)
- **Batch Processing**: Collection for (generate all at once)

**Dart Advantages:**

```dart
// ✅ Dart's switch expression is cleaner than traditional switch
var result = switch (n) {
  _ when n % 15 == 0 => "FizzBuzz",
  _ when n % 3 == 0 => "Fizz",
  _ when n % 5 == 0 => "Buzz",
  _ => n.toString()
};

// ✅ Collection for generates sequences elegantly
var sequence = [
  for (var i = 1; i <= 100; i++) fizzBuzz(i)
];

// ✅ String building avoids checking 15
var result = "";
if (n % 3 == 0) result += "Fizz";
if (n % 5 == 0) result += "Buzz";
return result.isEmpty ? n.toString() : result;
```

## 🐛 Common Mistakes

**Mistake 1: Wrong order in if/else**
```dart
// ❌ Wrong - checks 3 before 15
if (n % 3 == 0) print("Fizz");  // 15 would print "Fizz" not "FizzBuzz"!
else if (n % 5 == 0) print("Buzz");
else if (n % 15 == 0) print("FizzBuzz");  // Never reached!

// ✅ Correct - check 15 first
if (n % 15 == 0) print("FizzBuzz");
else if (n % 3 == 0) print("Fizz");
else if (n % 5 == 0) print("Buzz");
```

**Mistake 2: String building with wrong logic**
```dart
// ❌ Wrong - checks 15 unnecessarily
var result = "";
if (n % 15 == 0) result = "FizzBuzz";  // Not needed!
else if (n % 3 == 0) result = "Fizz";
else if (n % 5 == 0) result = "Buzz";

// ✅ Correct - let it build naturally
var result = "";
if (n % 3 == 0) result += "Fizz";
if (n % 5 == 0) result += "Buzz";
```

**Mistake 3: Off-by-one errors**
```dart
// ❌ Wrong - starts at 0
for (var i = 0; i <= 100; i++) { }  // Should be 1 to 100

// ✅ Correct
for (var i = 1; i <= 100; i++) { }
```

## 🎉 Congratulations!

You've completed the Control Flow tutorial! You've learned:
- All conditional statements
- All loop types
- Collection if/for and spread operators
- Multiple ways to solve problems
- How to choose the best approach

## 🔜 Next Steps

You're now ready for **Tutorial 4: Functions**!

## 💡 Pro Tips

- Prefer readability over cleverness (unless it's actually clearer)
- Switch expressions are idiomatic in Dart 3.0+
- String building approach is elegant for combinatorial problems
- Map-based solutions are great for configurable logic
- Collection for is perfect for generating sequences
- Always test edge cases (0, 1, 15, 30, etc.)
