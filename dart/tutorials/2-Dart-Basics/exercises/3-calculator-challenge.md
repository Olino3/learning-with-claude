# Exercise 3: Calculator Challenge

In this exercise, you'll build a type-safe calculator that demonstrates all the concepts from Dart Basics.

## 🎯 Objective

Apply your knowledge of types, operators, and string interpolation to build a practical calculator program.

## 📋 What You'll Learn

- Combining types, operators, and string interpolation
- Handling user input safely
- Formatting output professionally
- Type-safe arithmetic operations

## 🚀 Challenge Tasks

### Task 1: Basic Calculator Script

Create a Dart script that performs calculations and displays results nicely.

**Create the file:** `dart/scripts/basic_calculator.dart`

```dart
void main() {
  // Your task: Create a calculator that:
  // 1. Defines two numbers (use var, final, or const appropriately)
  // 2. Performs all arithmetic operations
  // 3. Displays results with proper formatting
  // 4. Uses string interpolation for output

  // TODO: Define your numbers here

  // TODO: Perform calculations

  // TODO: Display results with nice formatting
}
```

**Expected output:**
```
========== CALCULATOR ==========
Number 1: 10
Number 2: 3
--------------------------------
Addition:       10 + 3 = 13
Subtraction:    10 - 3 = 7
Multiplication: 10 * 3 = 30
Division:       10 / 3 = 3.33
Int Division:   10 ~/ 3 = 3
Modulo:         10 % 3 = 1
================================
```

**Hints:**
- Use `toStringAsFixed(2)` for division to show 2 decimal places
- Use string interpolation with `${}` for calculations
- Use const for numbers that won't change

**Test your script:**
```bash
make dart-script SCRIPT=scripts/basic_calculator.dart
```

### Task 2: Temperature Converter

Create a temperature converter that converts between Celsius and Fahrenheit.

**Create the file:** `dart/scripts/temperature_converter.dart`

```dart
void main() {
  // Your task: Create a temperature converter
  // 1. Define a temperature in Celsius
  // 2. Convert to Fahrenheit: F = C * 9/5 + 32
  // 3. Convert back to verify: C = (F - 32) * 5/9
  // 4. Display all values with proper formatting

  // TODO: Implement the converter
}
```

**Expected output:**
```
===== TEMPERATURE CONVERTER =====
Celsius:    25.0°C
Fahrenheit: 77.0°F
Verified:   25.0°C
=================================
```

**Hints:**
- Use double for temperatures
- Use `toStringAsFixed(1)` for one decimal place
- Verify your conversion by converting back

**Test your script:**
```bash
make dart-script SCRIPT=scripts/temperature_converter.dart
```

### Task 3: Bill Calculator with Tip

Create a restaurant bill calculator that includes tax and tip.

**Create the file:** `dart/scripts/bill_calculator.dart`

```dart
void main() {
  // Your task: Create a bill calculator
  // 1. Define meal cost, tax rate (8%), and tip rate (15%)
  // 2. Calculate subtotal, tax, tip, and total
  // 3. Display itemized bill
  // 4. Use const for rates that don't change

  // TODO: Define your values

  // TODO: Perform calculations

  // TODO: Display formatted bill
}
```

**Expected output:**
```
============ BILL ============
Meal Cost:   $45.00
Tax (8%):    $3.60
Subtotal:    $48.60
Tip (15%):   $6.75
------------------------------
TOTAL:       $55.35
==============================
```

**Hints:**
- Use const for tax and tip rates
- Calculate tax on meal cost
- Calculate tip on subtotal (meal + tax)
- Use `toStringAsFixed(2)` for currency

**Test your script:**
```bash
make dart-script SCRIPT=scripts/bill_calculator.dart
```

### Task 4: Type-Safe Input Parser (Advanced)

Create a script that safely parses and validates numeric input.

**Create the file:** `dart/scripts/safe_parser.dart`

```dart
void main() {
  // Your task: Create a safe number parser
  // 1. Define a list of string inputs (mix of valid and invalid)
  // 2. Try to parse each one
  // 3. Handle invalid inputs gracefully
  // 4. Display which inputs were valid/invalid

  var inputs = ["42", "3.14", "hello", "100", "abc123", "0", "-5"];

  print("===== PARSING NUMBERS =====");

  // TODO: Loop through inputs and parse them safely
  // TODO: Use tryParse() to avoid exceptions
  // TODO: Display results for each input

  print("===========================");
}
```

**Expected output:**
```
===== PARSING NUMBERS =====
"42" -> Valid integer: 42
"3.14" -> Invalid integer (try double)
"hello" -> Invalid number
"100" -> Valid integer: 100
"abc123" -> Invalid number
"0" -> Valid integer: 0
"-5" -> Valid integer: -5
===========================
```

**Hints:**
- Use `int.tryParse()` which returns null on failure
- Check for null with `== null` or use null-aware operators
- Try parsing as double if int parsing fails
- Use string interpolation to display results

**Test your script:**
```bash
make dart-script SCRIPT=scripts/safe_parser.dart
```

### Task 5: Complete Calculator (Expert Challenge)

Combine everything into a complete calculator with multiple operations.

**Create the file:** `dart/scripts/complete_calculator.dart`

```dart
import 'dart:math';

void main() {
  // Your task: Create a complete calculator
  // 1. Define two numbers
  // 2. Perform basic operations (+, -, *, /, ~/, %)
  // 3. Perform advanced operations (pow, sqrt, abs)
  // 4. Calculate statistics (min, max, average)
  // 5. Display everything in a professional format

  // TODO: Implement complete calculator
}
```

**Expected output:**
```
========== COMPLETE CALCULATOR ==========
Numbers: 10, 3

--- Basic Operations ---
10 + 3 = 13
10 - 3 = 7
10 * 3 = 30
10 / 3 = 3.33
10 ~/ 3 = 3
10 % 3 = 1

--- Advanced Operations ---
10 ^ 3 = 1000.0
sqrt(10) = 3.16
sqrt(3) = 1.73
|10| = 10
|3| = 3

--- Statistics ---
Min: 3
Max: 10
Average: 6.5
=========================================
```

**Hints:**
- Import dart:math for pow, sqrt, min, max
- Use const for numbers
- Use different decimal precision for different operations
- Organize output into sections

**Test your script:**
```bash
make dart-script SCRIPT=scripts/complete_calculator.dart
```

## ✅ Success Criteria

You've completed this challenge when:

- [ ] All 5 scripts run without errors
- [ ] Output is properly formatted and readable
- [ ] You use appropriate types (var, final, const)
- [ ] String interpolation is used throughout
- [ ] Numbers are formatted with appropriate precision
- [ ] Invalid input is handled gracefully (Task 4)

## 🎓 Key Concepts Applied

This challenge demonstrates:

1. **Type System:** Using int, double, and String appropriately
2. **Immutability:** Using const for values that don't change
3. **Operators:** All arithmetic operations including `~/`
4. **String Interpolation:** Clean, readable output
5. **Formatting:** `toStringAsFixed()` for precision
6. **Error Handling:** `tryParse()` for safe parsing
7. **Type Safety:** Catching errors at compile time

## 🐛 Troubleshooting

### Script won't run

Make sure you're in the repository root:
```bash
pwd  # Should show .../learning-with-claude
make dart-script SCRIPT=scripts/basic_calculator.dart
```

### Import errors

For dart:math, add at the top of your file:
```dart
import 'dart:math';
```

### Type errors

Make sure division results are handled correctly:
```dart
var result = 10 / 3;  // Type is double
var rounded = result.toStringAsFixed(2);  // Convert to string with precision
```

## 💡 Pro Tips

**Tip 1: Use const for fixed values**
```dart
const taxRate = 0.08;  // Won't change
const tipRate = 0.15;  // Won't change
var mealCost = 45.00;  // Might change
```

**Tip 2: Format currency consistently**
```dart
var amount = 45.5;
print("\$${amount.toStringAsFixed(2)}");  // => "$45.50"
```

**Tip 3: Create reusable format functions**
```dart
String formatCurrency(double amount) {
  return "\$${amount.toStringAsFixed(2)}";
}

print("Total: ${formatCurrency(55.35)}");  // => "Total: $55.35"
```

**Tip 4: Use descriptive variable names**
```dart
// ❌ Unclear
var a = 45.00;
var b = 0.08;
var c = a * b;

// ✅ Clear
var mealCost = 45.00;
var taxRate = 0.08;
var tax = mealCost * taxRate;
```

## 🎉 Congratulations!

You've completed the Dart Basics exercises! You now understand:
- Dart's type system and type inference
- Variable declarations (var, final, const)
- Number operations and formatting
- String interpolation and methods
- Safe type conversions

You're ready to move on to Tutorial 3: Control Flow!

## 🔜 Next Steps

Continue to **[Tutorial 3: Control Flow](../../3-Control-Flow/README.md)** to learn about conditionals, loops, and Dart's unique control flow features!

## 📖 Solutions

If you get stuck, here's a solution for Task 1:

<details>
<summary>Click to see Task 1 solution</summary>

```dart
import 'dart:math';

void main() {
  // Define numbers (const since they won't change)
  const num1 = 10;
  const num2 = 3;

  print("========== CALCULATOR ==========");
  print("Number 1: $num1");
  print("Number 2: $num2");
  print("--------------------------------");
  print("Addition:       $num1 + $num2 = ${num1 + num2}");
  print("Subtraction:    $num1 - $num2 = ${num1 - num2}");
  print("Multiplication: $num1 * $num2 = ${num1 * num2}");
  print("Division:       $num1 / $num2 = ${(num1 / num2).toStringAsFixed(2)}");
  print("Int Division:   $num1 ~/ $num2 = ${num1 ~/ num2}");
  print("Modulo:         $num1 % $num2 = ${num1 % num2}");
  print("================================");
}
```
</details>

Try to complete the others yourself first! The practice is valuable.
