# Exercise 2: Numbers and Strings

In this exercise, you'll master Dart's number operations and powerful string features, especially string interpolation.

## 🎯 Objective

Learn Dart's number types, arithmetic operations, and string manipulation techniques.

## 📋 What You'll Learn

- Working with int and double types
- Arithmetic operations and integer division
- String interpolation with $ and ${}
- String methods and operations
- Type conversion between numbers and strings

## 🚀 Steps

### Step 1: Start Your REPL

Ensure the Dart REPL is running:

```bash
make dart-repl
```

### Step 2: Number Types and Operations

**Basic Number Types:**

```dart
// Integers
var age = 30;
var maxValue = 9223372036854775807;
var hex = 0xDEADBEEF;
var binary = 0b11010110;

age.runtimeType      // => int

// Doubles
var pi = 3.14159;
var scientific = 1.5e10;

pi.runtimeType       // => double
```

**Arithmetic Operations:**

```dart
// Basic operations
10 + 5     // => 15
10 - 5     // => 5
10 * 5     // => 50
10 / 5     // => 2.0 (ALWAYS returns double!)
10 / 3     // => 3.3333333333333335

// Integer division
10 ~/ 3    // => 3 (integer division)
10 % 3     // => 1 (remainder/modulo)

// Increment/decrement
var count = 5;
count++    // => 5 (returns 5, then increments to 6)
count      // => 6
++count    // => 7 (increments to 7, then returns 7)
```

> **📘 Python Note:**
> - `/` ALWAYS returns double in Dart (like Python 3)
> - Use `~/` for integer division (Python's `//`)
> - Dart doesn't have `**` for exponentiation (use `.pow()` method)
> - `++` and `--` operators exist in Dart (not in Python)

**Number Methods:**

```dart
import 'dart:math';

// Absolute value
(-5).abs()           // => 5

// Rounding
3.7.ceil()           // => 4
3.7.floor()          // => 3
3.5.round()          // => 4
3.4.round()          // => 3

// Truncation
3.7.truncate()       // => 3 (removes decimal part)

// Power
pow(2, 3)            // => 8.0 (requires import dart:math)

// Square root
sqrt(16)             // => 4.0

// Min/Max
max(10, 20)          // => 20
min(10, 20)          // => 10

// Random numbers
Random().nextInt(100)      // Random int from 0 to 99
Random().nextDouble()      // Random double from 0.0 to 1.0
```

### Step 3: Number Conversions

```dart
// String to number
int.parse("42")          // => 42
double.parse("3.14")     // => 3.14

// With error handling
int.tryParse("hello")    // => null (instead of throwing)
int.tryParse("42")       // => 42

// Number to string
42.toString()            // => "42"
3.14.toString()          // => "3.14"

// Format with precision
3.14159.toStringAsFixed(2)        // => "3.14"
3.14159.toStringAsPrecision(4)    // => "3.142"

// Convert between int and double
var intNum = 42;
intNum.toDouble()        // => 42.0

var doubleNum = 3.14;
doubleNum.toInt()        // => 3 (truncates)
doubleNum.round()        // => 3 (rounds to nearest)
```

> **📘 Python Note:**
> - `tryParse()` returns null on failure (unlike Python's int() which raises ValueError)
> - This is safer for user input validation
> - Use `toStringAsFixed()` for decimal places (like Python's f"{x:.2f}")

### Step 4: String Basics

```dart
// Single and double quotes are equivalent
var s1 = 'Single quotes';
var s2 = "Double quotes";
var s3 = 'Can use "double" quotes inside single';
var s4 = "Can use 'single' quotes inside double";

// Escape sequences
var escaped = "Line 1\nLine 2\tTabbed";
var quote = "She said, \"Hello!\"";

// Raw strings (no escaping)
var rawString = r"C:\Users\Alice\Documents";
var regex = r"\d+\.\d+";  // Raw strings great for regex

// Multi-line strings
var multiline = '''
This is a
multi-line
string.
''';

var alsoMultiline = """
Double quotes
work too!
""";
```

### Step 5: String Interpolation (Important!)

```dart
// Simple variable interpolation
var name = "Alice";
var greeting = "Hello, $name!";
print(greeting);  // => "Hello, Alice!"

// Expression interpolation
var age = 30;
var message = "Next year you'll be ${age + 1}";
print(message);  // => "Next year you'll be 31"

// When to use ${}
var price = 29.99;
print("Price: \$$price");        // => "Price: $29.99"
print("Total: \$${price * 2}");  // => "Total: $59.98"

// Method calls require {}
var text = "hello";
print("Upper: ${text.toUpperCase()}");  // => "Upper: HELLO"

// Complex expressions
var items = [1, 2, 3];
print("Count: ${items.length}");        // => "Count: 3"
print("First: ${items.first}");         // => "First: 1"
print("Sum: ${items.reduce((a, b) => a + b)}");  // => "Sum: 6"
```

> **📘 Python Note:**
> - Use `$var` for simple variables (cleaner than f"{var}")
> - Use `${expression}` for expressions (like f"{expression}")
> - Much cleaner than Python's `%` formatting or `.format()`
> - Use `\$` to escape dollar sign

### Step 6: String Methods

```dart
// Case conversion
"hello".toUpperCase()        // => "HELLO"
"WORLD".toLowerCase()        // => "world"

// Length
"hello".length               // => 5

// Character access
"hello"[0]                   // => "h"
"hello"[4]                   // => "o"

// Contains and search
"hello world".contains("world")     // => true
"hello world".startsWith("hello")   // => true
"hello world".endsWith("world")     // => true
"hello world".indexOf("o")          // => 4
"hello world".lastIndexOf("o")      // => 7

// Substring
"hello world".substring(0, 5)       // => "hello"
"hello world".substring(6)          // => "world"

// Trim whitespace
"  hello  ".trim()           // => "hello"
"  hello  ".trimLeft()       // => "hello  "
"  hello  ".trimRight()      // => "  hello"

// Replace
"hello world".replaceAll("o", "0")  // => "hell0 w0rld"
"hello world".replaceFirst("o", "0") // => "hell0 world"

// Split and join
"a,b,c".split(",")           // => ["a", "b", "c"]
["a", "b", "c"].join("-")    // => "a-b-c"

// Padding
"5".padLeft(3, "0")          // => "005"
"5".padRight(3, "0")         // => "500"

// Check empty
"".isEmpty                   // => true
"".isNotEmpty               // => false
"hello".isEmpty              // => false
```

> **📘 Python Note:**
> - Similar methods to Python strings
> - `isEmpty`/`isNotEmpty` are properties, not methods
> - `padLeft`/`padRight` instead of Python's `ljust`/`rjust`
> - String methods return new strings (strings are immutable)

### Step 7: String Concatenation

```dart
// Using + operator
var full = "Hello" + " " + "World";  // => "Hello World"

// Using interpolation (preferred)
var first = "Hello";
var second = "World";
var full = "$first $second";         // => "Hello World"

// For many strings, use StringBuffer
var buffer = StringBuffer();
buffer.write("Hello");
buffer.write(" ");
buffer.write("World");
var result = buffer.toString();      // => "Hello World"

// StringBuffer is efficient for loops
var buffer2 = StringBuffer();
for (var i = 0; i < 5; i++) {
  buffer2.write("$i ");
}
buffer2.toString();  // => "0 1 2 3 4 "
```

> **📘 Python Note:**
> - String concatenation with `+` is less efficient than interpolation
> - StringBuffer is like Python's `io.StringIO` or joining a list
> - Use interpolation for simple cases, StringBuffer for loops

### Step 8: Practice Exercise

Create a simple program that:

1. Defines two numbers
2. Performs all arithmetic operations
3. Formats the results with string interpolation
4. Includes labels and proper formatting

**Solution (try yourself first!):**

```dart
// 1. Define numbers
var a = 10;
var b = 3;

// 2 & 3. Perform operations and format
print("--- Calculator ---");
print("a = $a, b = $b");
print("");
print("Addition:       $a + $b = ${a + b}");
print("Subtraction:    $a - $b = ${a - b}");
print("Multiplication: $a * $b = ${a * b}");
print("Division:       $a / $b = ${(a / b).toStringAsFixed(2)}");
print("Int Division:   $a ~/ $b = ${a ~/ b}");
print("Modulo:         $a % $b = ${a % b}");
print("Power:          $a ^ $b = ${pow(a, b)}");
```

### Step 9: Advanced Challenge

Create a formatted receipt printer:

```dart
var itemName = "Coffee";
var quantity = 2;
var pricePerItem = 4.50;
var taxRate = 0.08;

var subtotal = quantity * pricePerItem;
var tax = subtotal * taxRate;
var total = subtotal + tax;

print("========== RECEIPT ==========");
print("Item: $itemName");
print("Quantity: $quantity");
print("Price: \$${pricePerItem.toStringAsFixed(2)}");
print("----------------------------");
print("Subtotal: \$${subtotal.toStringAsFixed(2)}");
print("Tax (8%): \$${tax.toStringAsFixed(2)}");
print("----------------------------");
print("Total:    \$${total.toStringAsFixed(2)}");
print("============================");
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You understand int and double types
- [ ] You can use `~/` for integer division
- [ ] You master string interpolation with $ and ${}
- [ ] You can use common string methods
- [ ] You can convert between numbers and strings
- [ ] You can format numbers with precision

## 🎓 Key Takeaways

**Number Operations:**
- `/` always returns double
- Use `~/` for integer division
- Use methods for power, sqrt, etc. (no `**` operator)
- `tryParse()` is safer than `parse()` for user input

**String Interpolation:**
- Use `$var` for simple variables
- Use `${expression}` for expressions
- Much cleaner than concatenation
- Escape `$` with `\$`

**Performance Tips:**
- Use interpolation over concatenation
- Use StringBuffer for building strings in loops
- Strings are immutable (like Python 3)

## 🐛 Common Mistakes

**Mistake 1: Expecting int from division**
```dart
// ❌ Wrong assumption
var half = 10 / 5;  // Type is double, not int!

// ✅ Correct
var half = 10 ~/ 5;  // int division
```

**Mistake 2: Forgetting {} for expressions**
```dart
var age = 30;

// ❌ Wrong - only interpolates 'age' variable
print("Age: $age + 1");  // => "Age: 30 + 1"

// ✅ Correct
print("Age: ${age + 1}");  // => "Age: 31"
```

**Mistake 3: Not handling parse errors**
```dart
// ❌ Risky
var num = int.parse(userInput);  // Could throw!

// ✅ Better
var num = int.tryParse(userInput) ?? 0;  // Returns 0 if invalid

// ✅ Best
var num = int.tryParse(userInput);
if (num == null) {
  print("Invalid number!");
}
```

## 🎉 Congratulations!

You now understand Dart's number operations and powerful string interpolation! These skills are fundamental to writing clean, readable Dart code.

## 🔜 Next Steps

Move on to **Exercise 3: Calculator Challenge** to combine everything you've learned!

## 💡 Pro Tips

- Always use string interpolation over concatenation
- Use `toStringAsFixed()` for displaying money values
- Use `tryParse()` for user input validation
- Remember: `/` always returns double!
- String interpolation makes code much more readable
