// Lab 3: Functions & Mixins - Starter Template
// TODO: Complete this calculator implementation following the README steps

import 'dart:math';

// ============================================================================
// STEP 2: Statistical Mixin
// ============================================================================

// TODO: Create StatisticalMixin with the following methods:
// - mean(List<double> numbers) -> double
// - median(List<double> numbers) -> double
// - variance(List<double> numbers) -> double
// - standardDeviation(List<double> numbers) -> double
// - mode(List<double> numbers) -> double?

mixin StatisticalMixin {
  // TODO: Implement statistical methods here
  
  // Hint for mean:
  // double mean(List<double> numbers) {
  //   if (numbers.isEmpty) return 0;
  //   return numbers.reduce((a, b) => a + b) / numbers.length;
  // }
}

// ============================================================================
// STEP 3: Scientific Mixin
// ============================================================================

// TODO: Create ScientificMixin with the following methods:
// - factorial(int n) -> int
// - combination(int n, int r) -> int
// - permutation(int n, int r) -> int
// - fibonacciSequence(int count) -> List<int>
// - isPrime(int n) -> bool
// - percentageChange(double oldValue, double newValue) -> double

mixin ScientificMixin {
  // TODO: Implement scientific methods here
  
  // Hint for factorial:
  // int factorial(int n) {
  //   if (n < 0) throw ArgumentError('Factorial requires non-negative integer');
  //   return n <= 1 ? 1 : n * factorial(n - 1);
  // }
}

// ============================================================================
// STEP 4: Unit Converter Mixin
// ============================================================================

// TODO: Create UnitConverterMixin with temperature, distance, and weight conversions
// Use arrow functions (=>) for simple conversions

mixin UnitConverterMixin {
  // TODO: Temperature conversions
  // double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
  // double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;
  // Add more...

  // TODO: Distance conversions
  // double milesToKilometers(double miles) => miles * 1.60934;
  // Add more...

  // TODO: Weight conversions
  // double poundsToKilograms(double pounds) => pounds * 0.453592;
  // Add more...

  // TODO: Helper method
  // String formatConversion(String from, double value, String to, double result) {
  //   return '$value $from = ${result.toStringAsFixed(2)} $to';
  // }
}

// ============================================================================
// STEP 5: Extension Methods
// ============================================================================

// TODO: Create extension on List<double> for calculations
// Extension methods add functionality to existing types
// Ruby: Can use refinements or monkey patching
// Python: Cannot directly extend built-in types

// extension ListCalculations on List<double> {
//   double get sum => isEmpty ? 0 : reduce((a, b) => a + b);
//   double get average => isEmpty ? 0 : sum / length;
//   // Add max, min, transform, filterBy methods
// }

// ============================================================================
// STEP 6: Type Aliases for Function Signatures
// ============================================================================

// TODO: Define type aliases for function types
// typedef UnaryFunction = double Function(double);
// typedef BinaryFunction = double Function(double, double);
// typedef OperationCallback = void Function(String operation, dynamic result);

// ============================================================================
// STEP 1 & 5: Enhanced Calculator Class
// ============================================================================

// TODO: Add mixins after implementing them in steps 2-4
// Apply mixins using: class EnhancedCalculator with StatisticalMixin, ScientificMixin, UnitConverterMixin

class EnhancedCalculator {
  final String name;
  final List<Map<String, dynamic>> _history = [];
  bool loggingEnabled;

  // TODO: Add constructor with named parameters
  EnhancedCalculator({
    this.name = 'Calculator',
    this.loggingEnabled = true,
  });

  // TODO: Add getter for history
  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  // TODO: Implement _log method to record operations
  void _log(String operation, dynamic result) {
    // if (loggingEnabled) {
    //   _history.add({
    //     'operation': operation,
    //     'result': result,
    //     'timestamp': DateTime.now(),
    //   });
    // }
  }

  // ============================================================================
  // STEP 1: Basic Operations with Named Parameters
  // ============================================================================

  // TODO: Implement add with named parameter 'log'
  double add(double a, double b, {bool log = true}) {
    // final result = a + b;
    // if (log) _log('$a + $b', result);
    // return result;
    return 0; // Replace with actual implementation
  }

  // TODO: Implement subtract (use arrow function if you want)
  double subtract(double a, double b, {bool log = true}) {
    return 0; // Replace with actual implementation
  }

  // TODO: Implement multiply
  double multiply(double a, double b, {bool log = true}) {
    return 0; // Replace with actual implementation
  }

  // TODO: Implement divide with error handling for division by zero
  double divide(double a, double b, {bool log = true, int precision = 2}) {
    // Hint: Check if b == 0, throw ArgumentError
    // Round result to precision using toStringAsFixed
    return 0; // Replace with actual implementation
  }

  // TODO: Implement power with optional parameter (default exponent = 2)
  double power(double base, [double exponent = 2, bool log = true]) {
    // Hint: Use pow(base, exponent) from dart:math
    return 0; // Replace with actual implementation
  }

  // ============================================================================
  // STEP 6: Higher-Order Functions
  // ============================================================================

  // TODO: Implement applyToAll - takes a list and a function, applies function to each element
  // List<double> applyToAll(List<double> numbers, UnaryFunction operation) {
  //   return numbers.map(operation).toList();
  // }

  // TODO: Implement compose - combines two functions
  // UnaryFunction compose(UnaryFunction f, UnaryFunction g) {
  //   return (x) => f(g(x));
  // }

  // TODO: Implement reduceWith - reduces list with custom operation
  // double reduceWith(List<double> numbers, BinaryFunction operation) {
  //   if (numbers.isEmpty) return 0;
  //   return numbers.reduce(operation);
  // }

  // TODO: Implement partial - partial application (fix first argument)
  // UnaryFunction partial(BinaryFunction f, double fixedArg) {
  //   return (x) => f(fixedArg, x);
  // }

  // TODO: Implement curry - convert binary function to nested unary functions
  // UnaryFunction Function(double) curry(BinaryFunction f) {
  //   return (a) => (b) => f(a, b);
  // }

  // ============================================================================
  // STEP 7: Closures
  // ============================================================================

  // TODO: Create a multiplier closure that captures factor
  // UnaryFunction createMultiplier(double factor) {
  //   return (x) {
  //     final result = x * factor;
  //     _log('$x × $factor (multiplier)', result);
  //     return result;
  //   };
  // }

  // TODO: Create running total closure
  // BinaryFunction createRunningTotal() {
  //   double total = 0;  // This variable is captured
  //   return (a, b) {
  //     total += a + b;
  //     _log('Running total', total);
  //     return total;
  //   };
  // }

  // TODO: Create counter closure
  // int Function() createCounter([int start = 0]) {
  //   int count = start;
  //   return () {
  //     count++;
  //     return count;
  //   };
  // }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  // TODO: Implement showHistory to display calculation history
  void showHistory({int limit = 10}) {
    // Print last 'limit' entries from _history
    // Format: "  1. [HH:MM:SS] operation = result"
  }

  // TODO: Implement clearHistory
  String clearHistory() {
    // Clear _history and return message with count
    return 'Cleared 0 history entries';
  }
}

// ============================================================================
// MAIN PROGRAM - Test Your Implementation
// ============================================================================

void main() {
  print('=' * 70);
  print(' ' * 20 + '🧮 CALCULATOR PRACTICE');
  print('=' * 70);

  // TODO: Create an EnhancedCalculator instance
  final calc = EnhancedCalculator(name: 'My Calculator');

  // ============================================================================
  // Test Basic Operations
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('➕ Basic Operations');
  print('─' * 70);
  
  // TODO: Test add, subtract, multiply, divide, power
  // print('5 + 3 = ${calc.add(5, 3)}');
  // print('10 - 4 = ${calc.subtract(10, 4)}');
  // Add more tests...

  // ============================================================================
  // Test Statistical Operations
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('📊 Statistical Operations');
  print('─' * 70);
  
  // TODO: Test mean, median, variance, standard deviation
  // final data = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0];
  // print('Data: $data');
  // print('Mean: ${calc.mean(data).toStringAsFixed(2)}');
  // Add more tests...

  // ============================================================================
  // Test Scientific Operations
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🔬 Scientific Operations');
  print('─' * 70);
  
  // TODO: Test factorial, combination, permutation, fibonacci, isPrime
  // print('5! = ${calc.factorial(5)}');
  // print('C(10, 3) = ${calc.combination(10, 3)}');
  // Add more tests...

  // ============================================================================
  // Test Unit Conversions
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🌡️  Unit Conversions');
  print('─' * 70);
  
  // TODO: Test temperature, distance, weight conversions
  // print(calc.formatConversion('°C', 25, '°F', calc.celsiusToFahrenheit(25)));
  // Add more tests...

  // ============================================================================
  // Test Extension Methods
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🔧 Extension Methods');
  print('─' * 70);
  
  // TODO: Test extension methods on List<double>
  // final numbers = [1.0, 2.0, 3.0, 4.0, 5.0];
  // print('Numbers: $numbers');
  // print('Sum: ${numbers.sum}');
  // Add more tests...

  // ============================================================================
  // Test Higher-Order Functions
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🎯 Higher-Order Functions');
  print('─' * 70);
  
  // TODO: Test applyToAll, compose, partial, curry, reduceWith
  // final doubled = calc.applyToAll([1, 2, 3, 4, 5], (x) => x * 2);
  // print('Doubled: $doubled');
  // Add more tests...

  // ============================================================================
  // Test Closures
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🔐 Closures');
  print('─' * 70);
  
  // TODO: Test createMultiplier, createRunningTotal, createCounter
  // final times5 = calc.createMultiplier(5);
  // print('Multiplier(5) of 7: ${times5(7)}');
  // Add more tests...

  // ============================================================================
  // Show History
  // ============================================================================
  
  print('\n${'=' * 70}');
  print(' ' * 28 + 'HISTORY');
  print('=' * 70);
  
  // TODO: Show calculation history
  // calc.showHistory(limit: 15);

  print('\n${'=' * 70}');
  print('\n✅ Testing complete! Compare with solution.dart\n');
}
