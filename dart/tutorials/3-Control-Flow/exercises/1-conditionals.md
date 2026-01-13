# Exercise 1: Conditionals

In this exercise, you'll explore Dart's conditional statements, including if/else, ternary operators, and the powerful switch expressions with pattern matching.

## 🎯 Objective

Master Dart's conditional control flow and understand the differences from Python.

## 📋 What You'll Learn

- If/else statements with explicit boolean checks
- Ternary operator usage
- Switch statements and switch expressions
- Pattern matching with guards
- Null-aware operators

## 🚀 Steps

### Step 1: Start Your REPL

Make sure your environment is running and start the Dart REPL:

```bash
make dart-repl
```

### Step 2: Basic If/Else Statements

**Experiment with if/else:**

```dart
// Simple if statement
var age = 25;
if (age >= 18) {
  print("You are an adult");
}

// if/else
var temperature = 75;
if (temperature > 80) {
  print("It's hot!");
} else {
  print("It's nice!");
}

// if/else if/else chain
var score = 85;
if (score >= 90) {
  print("Grade: A");
} else if (score >= 80) {
  print("Grade: B");
} else if (score >= 70) {
  print("Grade: C");
} else if (score >= 60) {
  print("Grade: D");
} else {
  print("Grade: F");
}
```

**Explicit Boolean Checks:**

```dart
// ❌ This won't work - no implicit truthiness
var name = "";
// if (name) {  // Error!
//   print("Has name");
// }

// ✅ Must be explicit
if (name.isNotEmpty) {
  print("Has name");
} else {
  print("No name");
}

// Other explicit checks
var items = <String>[];
if (items.isEmpty) {
  print("No items");
}

var count = 0;
if (count == 0) {
  print("Count is zero");
}

var value;
if (value == null) {
  print("Value is null");
}
```

> **📘 Python Note:** Unlike Python where `if ""` or `if []` work, Dart requires explicit boolean expressions. This prevents accidental bugs!

### Step 3: Ternary Operator

```dart
// Basic ternary: condition ? ifTrue : ifFalse
var age = 20;
var status = age >= 18 ? "Adult" : "Minor";
print(status);  // "Adult"

// Use in expressions
var temperature = 85;
var clothing = temperature > 75 ? "T-shirt" : "Jacket";
print("Wear a $clothing");

// Nested ternary (keep it readable!)
var score = 95;
var grade = score >= 90 ? "A"
          : score >= 80 ? "B"
          : score >= 70 ? "C"
          : "F";
print("Grade: $grade");

// With calculations
var isMember = true;
var price = 100;
var discount = isMember ? price * 0.20 : price * 0.10;
var finalPrice = price - discount;
print("Final price: \$${finalPrice}");
```

> **📘 Python Note:** Dart uses C-style `condition ? a : b` while Python uses `a if condition else b`. Both work, just different syntax!

### Step 4: Switch Statements (Traditional)

```dart
// Basic switch
var day = "Monday";

switch (day) {
  case "Monday":
    print("Start of the work week");
    break;
  case "Friday":
    print("Almost weekend!");
    break;
  case "Saturday":
  case "Sunday":
    print("Weekend!");
    break;
  default:
    print("Mid-week day");
}

// With numbers
var month = 3;

switch (month) {
  case 1:
  case 2:
  case 3:
    print("Q1");
    break;
  case 4:
  case 5:
  case 6:
    print("Q2");
    break;
  case 7:
  case 8:
  case 9:
    print("Q3");
    break;
  case 10:
  case 11:
  case 12:
    print("Q4");
    break;
  default:
    print("Invalid month");
}
```

> **📘 Python Note:** Python didn't have switch until 3.10's match/case. Dart's traditional switch is similar to other C-family languages.

### Step 5: Switch Expressions (Dart 3.0+)

Switch expressions are much cleaner - they return a value!

```dart
// Switch as an expression
var day = "Friday";

var mood = switch (day) {
  "Monday" => "😫",
  "Tuesday" || "Wednesday" || "Thursday" => "😐",
  "Friday" => "😊",
  "Saturday" || "Sunday" => "🎉",
  _ => "🤷"  // _ is the default/wildcard pattern
};

print("Mood: $mood");

// Use in assignments
var trafficLight = "yellow";

var action = switch (trafficLight) {
  "green" => "Go",
  "yellow" => "Slow down",
  "red" => "Stop",
  _ => "Invalid signal"
};

print("Action: $action");

// More complex example
var httpStatus = 404;

var message = switch (httpStatus) {
  200 => "OK",
  201 => "Created",
  400 => "Bad Request",
  401 => "Unauthorized",
  403 => "Forbidden",
  404 => "Not Found",
  500 => "Internal Server Error",
  _ => "Unknown status: $httpStatus"
};

print(message);
```

### Step 6: Pattern Matching with Guards

Pattern matching is extremely powerful!

```dart
// Pattern matching with type checking
Object value = 42;

var description = switch (value) {
  int n when n > 0 => "Positive integer: $n",
  int n when n < 0 => "Negative integer: $n",
  int _ => "Zero",
  double d => "Double: $d",
  String s => "String: $s",
  bool b => "Boolean: $b",
  _ => "Unknown type"
};

print(description);

// Try with different values
value = -5;
description = switch (value) {
  int n when n > 0 => "Positive integer: $n",
  int n when n < 0 => "Negative integer: $n",
  int _ => "Zero",
  _ => "Not an integer"
};
print(description);

value = "Hello";
description = switch (value) {
  String s when s.isEmpty => "Empty string",
  String s when s.length < 5 => "Short string: $s",
  String s => "String: $s",
  _ => "Not a string"
};
print(description);
```

> **📘 Python Note:** This is similar to Python 3.10+'s match/case with guards! The `when` clause adds conditions to patterns.

### Step 7: Null-Aware Operators

```dart
// ?? operator - null coalescing
String? username;
var display = username ?? "Guest";
print("Welcome, $display");  // "Welcome, Guest"

username = "Alice";
display = username ?? "Guest";
print("Welcome, $display");  // "Welcome, Alice"

// ??= operator - assign if null
String? name;
name ??= "Default";
print(name);  // "Default"

name ??= "Another";  // Won't assign, name is already non-null
print(name);  // Still "Default"

// ?. operator - safe navigation
String? text;
var length = text?.length;
print(length);  // null

text = "Hello";
length = text?.length;
print(length);  // 5

// Chaining null-aware operators
String? config;
var setting = config?.toUpperCase() ?? "DEFAULT";
print(setting);  // "DEFAULT"

config = "production";
setting = config?.toUpperCase() ?? "DEFAULT";
print(setting);  // "PRODUCTION"
```

> **📘 Python Note:** These are similar to Python's walrus operator and optional chaining, but more integrated into the language. Very useful for avoiding null checks!

### Step 8: Practice Exercise - Grade Calculator

Create a comprehensive grade calculator using all conditional techniques.

**Your Task:**

1. Create a function that takes a numeric score
2. Return the letter grade using switch expression
3. Add a message based on the grade using pattern matching
4. Handle edge cases (negative numbers, over 100)

**Try this yourself first!**

<details>
<summary>Click to see solution</summary>

```dart
// Grade calculator using switch expression
int calculateGrade(int score) {
  // Validate input
  if (score < 0 || score > 100) {
    print("Invalid score: $score");
    return -1;
  }

  // Determine grade using switch expression
  var grade = switch (score) {
    >= 90 && <= 100 => "A",
    >= 80 && < 90 => "B",
    >= 70 && < 80 => "C",
    >= 60 && < 70 => "D",
    _ => "F"
  };

  // Get message using pattern matching
  var message = switch (grade) {
    "A" => "Excellent work!",
    "B" => "Good job!",
    "C" => "Satisfactory",
    "D" => "Needs improvement",
    "F" => "Please see instructor",
    _ => "Unknown grade"
  };

  print("Score: $score => Grade: $grade ($message)");
  return score;
}

// Test it
calculateGrade(95);   // A - Excellent work!
calculateGrade(85);   // B - Good job!
calculateGrade(75);   // C - Satisfactory
calculateGrade(65);   // D - Needs improvement
calculateGrade(45);   // F - Please see instructor
calculateGrade(-10);  // Invalid
calculateGrade(150);  // Invalid
```

Alternative using traditional if/else:

```dart
void calculateGradeTraditional(int score) {
  if (score < 0 || score > 100) {
    print("Invalid score");
    return;
  }

  String grade;
  String message;

  if (score >= 90) {
    grade = "A";
    message = "Excellent work!";
  } else if (score >= 80) {
    grade = "B";
    message = "Good job!";
  } else if (score >= 70) {
    grade = "C";
    message = "Satisfactory";
  } else if (score >= 60) {
    grade = "D";
    message = "Needs improvement";
  } else {
    grade = "F";
    message = "Please see instructor";
  }

  print("Score: $score => Grade: $grade ($message)");
}
```

</details>

### Step 9: Script Challenge - Traffic Light Simulator

Create a script that simulates traffic light logic.

**Create this file:** `/home/user/learning-with-claude/dart/tutorials/3-Control-Flow/exercises/traffic_light.dart`

```dart
void main() {
  // Simulate traffic light changes
  simulateTrafficLight("green");
  simulateTrafficLight("yellow");
  simulateTrafficLight("red");
  simulateTrafficLight("broken");

  // Time-based logic
  simulateTrafficWithTime("green", 30);
  simulateTrafficWithTime("yellow", 5);
  simulateTrafficWithTime("red", 45);
}

void simulateTrafficLight(String light) {
  var action = switch (light) {
    "green" => "Go - proceed with caution",
    "yellow" => "Slow down - prepare to stop",
    "red" => "Stop - do not enter intersection",
    _ => "Caution - signal malfunction"
  };

  print("$light light: $action");
}

void simulateTrafficWithTime(String light, int secondsRemaining) {
  var status = switch ((light, secondsRemaining)) {
    ("green", var s) when s > 10 => "Safe to go",
    ("green", _) => "Light changing soon",
    ("yellow", _) => "Stop if safe",
    ("red", var s) when s > 30 => "Long wait",
    ("red", _) => "Will change soon",
    _ => "Unknown"
  };

  print("$light light ($secondsRemaining seconds): $status");
}
```

**Run it:**

```bash
make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/3-Control-Flow/exercises/traffic_light.dart
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You understand if/else statements with explicit booleans
- [ ] You can use the ternary operator effectively
- [ ] You know when to use traditional switch vs switch expressions
- [ ] You can use pattern matching with guards
- [ ] You understand null-aware operators
- [ ] You completed the grade calculator
- [ ] You created and ran the traffic light simulator

## 🎓 Key Takeaways

**Critical Differences from Python:**

1. **No Implicit Truthiness:** Must use explicit boolean expressions
2. **Ternary Syntax:** `condition ? a : b` vs Python's `a if condition else b`
3. **Switch Expressions:** Cleaner than traditional switch, similar to Python 3.10+ match
4. **Pattern Matching:** Very powerful with type checking and guards
5. **Null Safety:** Built-in operators for handling null values

**Dart Idioms:**

```dart
// ✅ Good - use switch expression for clean code
var message = switch (status) {
  200 => "OK",
  404 => "Not Found",
  500 => "Error",
  _ => "Unknown"
};

// ✅ Good - explicit boolean checks
if (list.isNotEmpty) { }
if (value != null) { }

// ✅ Good - use null-aware operators
var result = value ?? defaultValue;

// ❌ Avoid - trying to use truthiness
// if (value) { }  // Error!

// ❌ Avoid - nested ternaries that are hard to read
var x = a ? b ? c : d : e ? f : g;  // Too complex!
```

## 🐛 Common Mistakes

**Mistake 1: Forgetting explicit boolean**
```dart
// ❌ Wrong
var items = [];
// if (items) { }  // Error!

// ✅ Correct
if (items.isNotEmpty) { }
```

**Mistake 2: Missing break in switch**
```dart
// ❌ Wrong - missing break
switch (value) {
  case 1:
    print("One");
    // Missing break!
  case 2:
    print("Two");
}

// ✅ Correct
switch (value) {
  case 1:
    print("One");
    break;
  case 2:
    print("Two");
    break;
}

// ✅ Better - use switch expression
var result = switch (value) {
  1 => "One",
  2 => "Two",
  _ => "Other"
};
```

**Mistake 3: Using switch for range checks**
```dart
// ❌ Wrong - can't use ranges in traditional switch
// switch (score) {
//   case 90...100:  // Not valid!
//     print("A");
// }

// ✅ Correct - use if/else or switch expression
if (score >= 90) {
  print("A");
}

// ✅ Or use modern switch expression (Dart 3.0+)
var grade = switch (score) {
  >= 90 => "A",
  >= 80 => "B",
  _ => "Other"
};
```

## 🎉 Congratulations!

You now understand Dart's conditional control flow! You've learned how to use if/else, ternary operators, switch statements, and powerful pattern matching.

## 🔜 Next Steps

Move on to **Exercise 2: Loops** to learn about Dart's iteration constructs!

## 💡 Pro Tips

- Prefer switch expressions over traditional switch for cleaner code
- Use explicit boolean checks - it prevents bugs
- Pattern matching with guards is very powerful
- Null-aware operators make code more concise
- Keep ternary operators simple - use if/else for complex logic
