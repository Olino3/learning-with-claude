# Lab 3: Functions & Mixins

Build a calculator with utility mixins to learn function design and code reusability in Dart.

## 🎯 Learning Objectives

- Function types: named parameters, optional parameters, default values
- Arrow functions and expression bodies
- First-class functions and closures
- Higher-order functions and function composition
- Creating and using mixins with `with`
- Extension methods for adding functionality
- Mixins vs Ruby modules vs Python multiple inheritance
- Function parameters and return types

## 🏃 Running the Lab

### Step-by-Step Learning (Recommended)

Follow the progressive steps in this README to build the calculator with mixins incrementally.

**Estimated Time**: 2-3 hours

### Quick Start

Run the complete solution:
```bash
dart run dart/labs/beginner/lab3-functions-mixins/solution.dart
```

### How to Practice

1. **Start with the starter template**:
   ```bash
   cp dart/labs/beginner/lab3-functions-mixins/starter.dart dart/labs/beginner/lab3-functions-mixins/my_calculator.dart
   ```
2. **Follow each step** to build the calculator and mixins
3. **Test your code** with:
   ```bash
   dart run dart/labs/beginner/lab3-functions-mixins/my_calculator.dart
   ```
4. **Compare with** `solution.dart` for reference

---

## 📋 What You'll Build

A calculator system with:
- `Calculator` class with basic operations
- `ScientificMixin` for scientific functions
- `StatisticalMixin` for statistical analysis
- `UnitConverterMixin` for unit conversions
- Extension methods for convenience
- Higher-order functions and function composition
- Operation history tracking

## 🚀 Progressive Steps

### Step 1: Basic Calculator with Function Parameters

**Dart Functions vs Ruby Methods vs Python Functions**:
- Dart uses strong typing with explicit parameter types
- Named parameters use `{Type name}` syntax (required with `required` keyword)
- Optional positional parameters use `[Type name]`
- Arrow functions `=>` for single expressions

```dart
class Calculator {
  final String name;

  // Named parameter with default value
  Calculator({this.name = 'Calculator'});

  // Simple positional parameters
  // Ruby: def add(a, b)
  // Python: def add(a, b):
  double add(double a, double b) {
    return a + b;
  }

  // Arrow function for single expression
  // Ruby: def subtract(a, b); a - b; end
  double subtract(double a, double b) => a - b;

  // Variable-length arguments using List
  // Ruby: def sum(*numbers)
  // Python: def sum(*numbers):
  double sum(List<double> numbers) {
    return numbers.isEmpty ? 0 : numbers.reduce((a, b) => a + b);
  }

  // Optional parameter with default value
  // Ruby: def power(base, exponent = 2)
  // Python: def power(base, exponent=2):
  double power(double base, [double exponent = 2]) {
    return pow(base, exponent).toDouble();
  }

  // Named parameters (required and optional)
  // Ruby: def divide(dividend:, divisor:, round_to: 2)
  // Python: def divide(*, dividend, divisor, round_to=2):
  double divide({
    required double dividend,
    required double divisor,
    int precision = 2,
  }) {
    if (divisor == 0) throw ArgumentError('Cannot divide by zero');
    final result = dividend / divisor;
    return double.parse(result.toStringAsFixed(precision));
  }
}
```

**Test it**:
```dart
import 'dart:math';

void main() {
  final calc = Calculator(name: 'MyCalc');
  print(calc.add(5, 3));              // => 8.0
  print(calc.sum([1, 2, 3, 4, 5]));   // => 15.0
  print(calc.power(2, 3));            // => 8.0
  print(calc.power(5));               // => 25.0 (uses default exponent=2)
  print(calc.divide(dividend: 10, divisor: 3));  // => 3.33
}
```

---

### Step 2: Create the Statistical Mixin

**Mixins in Dart vs Ruby Modules vs Python Multiple Inheritance**:

| Dart Mixins | Ruby Modules | Python Multiple Inheritance |
|-------------|--------------|----------------------------|
| `mixin Name` | `module Name` | `class Name:` |
| `with Name` | `include Name` | `class Child(Parent1, Parent2)` |
| No state in pure mixins | Can have state | Full multiple inheritance |
| Use `on Class` for constraints | No constraints | MRO (Method Resolution Order) |

```dart
// Dart mixin - can only be used with 'with' keyword
// Ruby equivalent: module Statistics
// Python equivalent: class Statistics (then use multiple inheritance)
mixin StatisticalMixin {
  // Calculate mean (average)
  double mean(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }

  // Calculate median
  double median(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    
    final sorted = List<double>.from(numbers)..sort();
    final mid = sorted.length ~/ 2;  // ~/ is integer division
    
    return sorted.length.isOdd
        ? sorted[mid]
        : (sorted[mid - 1] + sorted[mid]) / 2.0;
  }

  // Calculate variance
  double variance(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    
    final avg = mean(numbers);
    final sumOfSquares = numbers
        .map((n) => pow(n - avg, 2))
        .reduce((a, b) => a + b);
    
    return sumOfSquares / numbers.length;
  }

  // Calculate standard deviation
  double standardDeviation(List<double> numbers) {
    return sqrt(variance(numbers));
  }
}
```

**Use the mixin**:
```dart
// Apply mixin with 'with' keyword
// Ruby: class Calculator; include Statistics; end
// Python: class Calculator(BaseCalculator, Statistics):
class Calculator with StatisticalMixin {
  final String name;
  Calculator({this.name = 'Calculator'});
  
  // ... previous methods ...
}

void main() {
  final calc = Calculator();
  print(calc.mean([1, 2, 3, 4, 5]));        // => 3.0
  print(calc.median([1, 2, 3, 4, 5]));      // => 3.0
  print(calc.standardDeviation([2, 4, 4, 4, 5, 5, 7, 9]));  // => 2.0
}
```

---

### Step 3: Add Scientific Mixin

```dart
import 'dart:math';

mixin ScientificMixin {
  // Factorial using recursion
  int factorial(int n) {
    if (n < 0) throw ArgumentError('Factorial requires non-negative integer');
    return n <= 1 ? 1 : n * factorial(n - 1);
  }

  // Combination: C(n, r) = n! / (r! * (n-r)!)
  int combination(int n, int r) {
    if (n < 0 || r < 0) throw ArgumentError('Values must be non-negative');
    if (r > n) throw ArgumentError('r cannot be greater than n');
    
    return factorial(n) ~/ (factorial(r) * factorial(n - r));
  }

  // Permutation: P(n, r) = n! / (n-r)!
  int permutation(int n, int r) {
    if (n < 0 || r < 0) throw ArgumentError('Values must be non-negative');
    if (r > n) throw ArgumentError('r cannot be greater than n');
    
    return factorial(n) ~/ factorial(n - r);
  }

  // Generate Fibonacci sequence
  List<int> fibonacciSequence(int count) {
    if (count <= 0) return [];
    if (count == 1) return [0];
    
    final sequence = [0, 1];
    for (int i = 2; i < count; i++) {
      sequence.add(sequence[i - 1] + sequence[i - 2]);
    }
    
    return sequence;
  }

  // Check if number is prime
  bool isPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    
    for (int i = 3; i <= sqrt(n); i += 2) {
      if (n % i == 0) return false;
    }
    
    return true;
  }
}
```

---

### Step 4: Add Unit Converter Mixin

```dart
mixin UnitConverterMixin {
  // Temperature conversions
  double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
  double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;
  double celsiusToKelvin(double celsius) => celsius + 273.15;
  double kelvinToCelsius(double kelvin) => kelvin - 273.15;

  // Distance conversions
  double milesToKilometers(double miles) => miles * 1.60934;
  double kilometersToMiles(double km) => km / 1.60934;
  double feetToMeters(double feet) => feet * 0.3048;
  double metersToFeet(double meters) => meters / 0.3048;

  // Weight conversions
  double poundsToKilograms(double pounds) => pounds * 0.453592;
  double kilogramsToPounds(double kg) => kg / 0.453592;

  // Helper method for formatting conversion results
  String formatConversion(String from, double value, String to, double result) {
    return '$value $from = ${result.toStringAsFixed(2)} $to';
  }
}
```

---

### Step 5: Enhanced Calculator with All Mixins

```dart
class EnhancedCalculator with StatisticalMixin, ScientificMixin, UnitConverterMixin {
  final String name;
  final List<Map<String, dynamic>> _history = [];
  bool loggingEnabled;

  EnhancedCalculator({
    this.name = 'Calculator',
    this.loggingEnabled = true,
  });

  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  // Log operation to history
  void _log(String operation, dynamic result) {
    if (loggingEnabled) {
      _history.add({
        'operation': operation,
        'result': result,
        'timestamp': DateTime.now(),
      });
    }
  }

  // Basic operations with logging
  double add(double a, double b, {bool log = true}) {
    final result = a + b;
    if (log) _log('$a + $b', result);
    return result;
  }

  double subtract(double a, double b, {bool log = true}) {
    final result = a - b;
    if (log) _log('$a - $b', result);
    return result;
  }

  double multiply(double a, double b, {bool log = true}) {
    final result = a * b;
    if (log) _log('$a × $b', result);
    return result;
  }

  double divide(double a, double b, {bool log = true}) {
    if (b == 0) throw ArgumentError('Cannot divide by zero');
    final result = a / b;
    if (log) _log('$a ÷ $b', result);
    return result;
  }

  // Show calculation history
  void showHistory({int limit = 10}) {
    print('\nCalculation History (last $limit):');
    final entries = _history.length > limit 
        ? _history.sublist(_history.length - limit)
        : _history;
    
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final time = (entry['timestamp'] as DateTime).toIso8601String().substring(11, 19);
      print('  ${i + 1}. [$time] ${entry['operation']} = ${entry['result']}');
    }
  }

  // Clear history
  String clearHistory() {
    final count = _history.length;
    _history.clear();
    return 'Cleared $count history entries';
  }
}
```

---

### Step 6: Higher-Order Functions and Function Composition

**First-Class Functions in Dart**:
Dart treats functions as first-class objects - they can be assigned to variables, passed as arguments, and returned from other functions.

```dart
// Type aliases for function signatures
typedef UnaryFunction = double Function(double);
typedef BinaryFunction = double Function(double, double);

// Extension methods add functionality to existing types
// Ruby: Can use refinements or monkey patching
// Python: Cannot directly add methods to built-in types
extension ListCalculations on List<double> {
  double get sum => isEmpty ? 0 : reduce((a, b) => a + b);
  double get average => isEmpty ? 0 : sum / length;
  double get max => isEmpty ? 0 : reduce((a, b) => a > b ? a : b);
  double get min => isEmpty ? 0 : reduce((a, b) => a < b ? a : b);
}

class FunctionalCalculator extends EnhancedCalculator {
  FunctionalCalculator({String name = 'Functional Calculator'}) 
      : super(name: name);

  // Higher-order function: applies operation to list
  // Ruby: numbers.map { |n| operation.call(n) }
  // Python: [operation(n) for n in numbers]
  List<double> applyToAll(List<double> numbers, UnaryFunction operation) {
    return numbers.map(operation).toList();
  }

  // Function composition: combine two functions
  // Returns a new function that applies f then g
  UnaryFunction compose(UnaryFunction f, UnaryFunction g) {
    return (x) => g(f(x));
  }

  // Reduce with custom operation
  // Ruby: numbers.reduce { |acc, n| operation.call(acc, n) }
  // Python: reduce(operation, numbers)
  double reduceWith(List<double> numbers, BinaryFunction operation) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce(operation);
  }

  // Partial application: fix first argument
  UnaryFunction partial(BinaryFunction f, double fixedArg) {
    return (x) => f(fixedArg, x);
  }

  // Curry: convert binary function to unary functions
  UnaryFunction Function(double) curry(BinaryFunction f) {
    return (a) => (b) => f(a, b);
  }
}
```

**Test it**:
```dart
void main() {
  final calc = FunctionalCalculator();
  
  // Higher-order functions
  final numbers = [1.0, 2.0, 3.0, 4.0, 5.0];
  final squared = calc.applyToAll(numbers, (x) => x * x);
  print('Squared: $squared');  // => [1.0, 4.0, 9.0, 16.0, 25.0]
  
  // Function composition
  final double10 = (double x) => x * 2;
  final add5 = (double x) => x + 5;
  final doubleAndAdd5 = calc.compose(double10, add5);
  print(doubleAndAdd5(3));  // => 11.0 (3*2 + 5)
  
  // Partial application
  final add10 = calc.partial((a, b) => a + b, 10);
  print(add10(5));  // => 15.0
  
  // Extension methods
  print('Sum: ${numbers.sum}');      // => 15.0
  print('Average: ${numbers.average}');  // => 3.0
  print('Max: ${numbers.max}');      // => 5.0
}
```

---

### Step 7: Closures and Callbacks

**Closures in Dart**:
A closure is a function that captures variables from its surrounding scope.

```dart
class CalculatorWithCallbacks extends EnhancedCalculator {
  // Callback function type
  typedef OperationCallback = void Function(String operation, double result);
  
  OperationCallback? _callback;

  CalculatorWithCallbacks({String name = 'Calculator'}) : super(name: name);

  // Set callback for operation notifications
  void onOperation(OperationCallback callback) {
    _callback = callback;
  }

  // Override add to use callback
  @override
  double add(double a, double b, {bool log = true}) {
    final result = super.add(a, b, log: log);
    _callback?.call('$a + $b', result);
    return result;
  }

  // Create a custom calculator with closure
  UnaryFunction createMultiplier(double factor) {
    // This closure captures 'factor' from the outer scope
    return (x) {
      final result = x * factor;
      _log('$x × $factor', result);
      return result;
    };
  }

  // Create a running total calculator
  BinaryFunction createRunningTotal() {
    double total = 0;  // Captured variable
    
    return (a, b) {
      total += a + b;
      _log('Running total', total);
      return total;
    };
  }
}
```

---

## 🎯 Final Challenge

Create a complete calculator system with:
1. All three mixins applied
2. Extension methods for convenience
3. Higher-order functions for transformations
4. Operation history with logging
5. Callbacks for notifications
6. Function composition examples
7. Demonstrate closures

**Solution**: See `solution.dart`

---

## ✅ Checklist

- [ ] Function parameters: positional, named, optional, default values
- [ ] Arrow functions with `=>`
- [ ] Creating mixins with `mixin` keyword
- [ ] Applying mixins with `with` keyword
- [ ] Extension methods with `extension`
- [ ] First-class functions and function types
- [ ] Higher-order functions (functions as parameters/return values)
- [ ] Function composition and partial application
- [ ] Closures capturing outer scope
- [ ] Type aliases with `typedef`
- [ ] Null safety with `?` and `!`

---

## 🔄 Comparison Table

### Function Parameters

| Feature | Dart | Ruby | Python |
|---------|------|------|--------|
| Named params | `{required Type name}` | `name:` | `*, name` |
| Optional positional | `[Type name = default]` | `name = default` | `name=default` |
| Default values | `{Type name = value}` | `name = value` | `name=value` |
| Variable args | `List<Type>` | `*args` | `*args` |
| Arrow functions | `=> expr` | `-> { }` (stabby lambda) | `lambda:` |

### Code Reusability

| Dart | Ruby | Python |
|------|------|--------|
| `mixin Name` | `module Name` | `class Name:` |
| `class C with M` | `include M` | `class C(A, M):` |
| `extension Name on Type` | Refinements/monkey patch | Cannot extend built-ins |
| Constraints: `on BaseClass` | No constraints | MRO determines order |

### Function Types

| Dart | Ruby | Python |
|------|------|--------|
| `typedef F = Type Function(...)` | `Proc`, `Lambda` | `Callable`, `typing.Callable` |
| `Function(Type) => Type` | `->() { }` | `lambda:` |
| Functions are objects | Procs/Lambdas | Functions are objects |
| Strong typing | Duck typing | Duck typing (with hints) |

---

## 🔑 Key Takeaways

1. **Mixins** provide code reuse without inheritance complexity
2. **Named parameters** make code self-documenting
3. **Arrow functions** simplify single-expression functions
4. **Extension methods** add functionality without modifying classes
5. **First-class functions** enable functional programming patterns
6. **Closures** capture state for powerful abstractions
7. **Type safety** catches errors at compile time

---

## 🎓 Going Further

**Next Steps**:
- Explore async functions with `Future` and `async/await`
- Learn about generators with `sync*` and `async*`
- Study more advanced mixin patterns
- Investigate functional programming libraries

**Resources**:
- [Dart Language Tour - Functions](https://dart.dev/guides/language/language-tour#functions)
- [Dart Language Tour - Mixins](https://dart.dev/guides/language/language-tour#adding-features-to-a-class-mixins)
- [Dart Language Tour - Extension Methods](https://dart.dev/guides/language/extension-methods)

---

**Excellent work!** You've mastered Dart functions and mixins! 🚀
