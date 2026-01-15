// Lab 3: Functions & Mixins - Complete Solution

import 'dart:math';

// ============================================================================
// MIXINS - Code reuse without inheritance
// ============================================================================

/// Statistical analysis mixin
/// Ruby equivalent: module Statistics
/// Python equivalent: class Statistics (with multiple inheritance)
mixin StatisticalMixin {
  /// Calculate mean (average) of numbers
  double mean(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }

  /// Calculate median (middle value)
  double median(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    
    final sorted = List<double>.from(numbers)..sort();
    final mid = sorted.length ~/ 2;
    
    return sorted.length.isOdd
        ? sorted[mid]
        : (sorted[mid - 1] + sorted[mid]) / 2.0;
  }

  /// Calculate variance (spread of data)
  double variance(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    
    final avg = mean(numbers);
    final sumOfSquares = numbers
        .map((n) => pow(n - avg, 2))
        .reduce((a, b) => a + b);
    
    return sumOfSquares / numbers.length;
  }

  /// Calculate standard deviation
  double standardDeviation(List<double> numbers) {
    return sqrt(variance(numbers));
  }

  /// Calculate mode (most frequent value)
  double? mode(List<double> numbers) {
    if (numbers.isEmpty) return null;
    
    final frequency = <double, int>{};
    for (final num in numbers) {
      frequency[num] = (frequency[num] ?? 0) + 1;
    }
    
    int maxFreq = 0;
    double? modeValue;
    
    frequency.forEach((value, count) {
      if (count > maxFreq) {
        maxFreq = count;
        modeValue = value;
      }
    });
    
    return modeValue;
  }
}

/// Scientific calculations mixin
mixin ScientificMixin {
  /// Calculate factorial recursively
  int factorial(int n) {
    if (n < 0) throw ArgumentError('Factorial requires non-negative integer');
    return n <= 1 ? 1 : n * factorial(n - 1);
  }

  /// Calculate combination: C(n, r) = n! / (r! * (n-r)!)
  int combination(int n, int r) {
    if (n < 0 || r < 0) throw ArgumentError('Values must be non-negative');
    if (r > n) throw ArgumentError('r cannot be greater than n');
    
    return factorial(n) ~/ (factorial(r) * factorial(n - r));
  }

  /// Calculate permutation: P(n, r) = n! / (n-r)!
  int permutation(int n, int r) {
    if (n < 0 || r < 0) throw ArgumentError('Values must be non-negative');
    if (r > n) throw ArgumentError('r cannot be greater than n');
    
    return factorial(n) ~/ factorial(n - r);
  }

  /// Generate Fibonacci sequence
  List<int> fibonacciSequence(int count) {
    if (count <= 0) return [];
    if (count == 1) return [0];
    
    final sequence = [0, 1];
    for (int i = 2; i < count; i++) {
      sequence.add(sequence[i - 1] + sequence[i - 2]);
    }
    
    return sequence;
  }

  /// Check if number is prime
  bool isPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    
    for (int i = 3; i <= sqrt(n); i += 2) {
      if (n % i == 0) return false;
    }
    
    return true;
  }

  /// Find nth prime number
  int nthPrime(int n) {
    if (n <= 0) throw ArgumentError('n must be positive');
    
    int count = 0;
    int num = 2;
    
    while (count < n) {
      if (isPrime(num)) count++;
      if (count < n) num++;
    }
    
    return num;
  }

  /// Calculate percentage change
  double percentageChange(double oldValue, double newValue) {
    if (oldValue == 0) return 0;
    return ((newValue - oldValue) / oldValue * 100);
  }
}

/// Unit conversion mixin
mixin UnitConverterMixin {
  // Temperature conversions (using arrow functions)
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

// ============================================================================
// EXTENSION METHODS - Add functionality to existing types
// ============================================================================

/// Extension methods on List<double> for calculations
/// Ruby: Can use refinements or monkey patching
/// Python: Cannot directly extend built-in types
extension ListCalculations on List<double> {
  double get sum => isEmpty ? 0 : reduce((a, b) => a + b);
  double get average => isEmpty ? 0 : sum / length;
  double get max => isEmpty ? 0 : reduce((a, b) => a > b ? a : b);
  double get min => isEmpty ? 0 : reduce((a, b) => a < b ? a : b);
  
  /// Transform all values with a function
  List<double> transform(double Function(double) fn) => map(fn).toList();
  
  /// Filter values matching predicate
  List<double> filterBy(bool Function(double) predicate) => where(predicate).toList();
}

// ============================================================================
// TYPE ALIASES - Define function signatures
// ============================================================================

typedef UnaryFunction = double Function(double);
typedef BinaryFunction = double Function(double, double);
typedef OperationCallback = void Function(String operation, dynamic result);

// ============================================================================
// MAIN CALCULATOR CLASS - Combines all mixins
// ============================================================================

/// Enhanced calculator with statistical, scientific, and conversion capabilities
/// Demonstrates mixin composition, higher-order functions, and closures
class EnhancedCalculator with StatisticalMixin, ScientificMixin, UnitConverterMixin {
  final String name;
  final List<Map<String, dynamic>> _history = [];
  bool loggingEnabled;
  OperationCallback? _callback;

  EnhancedCalculator({
    this.name = 'Calculator',
    this.loggingEnabled = true,
  });

  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  /// Set callback for operation notifications
  void onOperation(OperationCallback callback) {
    _callback = callback;
  }

  /// Log operation to history
  void _log(String operation, dynamic result) {
    if (loggingEnabled) {
      _history.add({
        'operation': operation,
        'result': result,
        'timestamp': DateTime.now(),
      });
      _callback?.call(operation, result);
    }
  }

  // ============================================================================
  // BASIC OPERATIONS - Named parameters, default values
  // ============================================================================

  /// Add two numbers
  /// Ruby: def add(a, b, log: true)
  /// Python: def add(a, b, log=True):
  double add(double a, double b, {bool log = true}) {
    final result = a + b;
    if (log) _log('$a + $b', result);
    return result;
  }

  /// Subtract using arrow function
  double subtract(double a, double b, {bool log = true}) {
    final result = a - b;
    if (log) _log('$a - $b', result);
    return result;
  }

  /// Multiply two numbers
  double multiply(double a, double b, {bool log = true}) {
    final result = a * b;
    if (log) _log('$a × $b', result);
    return result;
  }

  /// Divide with error handling
  double divide(double a, double b, {bool log = true, int precision = 2}) {
    if (b == 0) throw ArgumentError('Cannot divide by zero');
    final result = a / b;
    final rounded = double.parse(result.toStringAsFixed(precision));
    if (log) _log('$a ÷ $b', rounded);
    return rounded;
  }

  /// Power function with optional exponent
  double power(double base, [double exponent = 2, bool log = true]) {
    final result = pow(base, exponent).toDouble();
    if (log) _log('$base^$exponent', result);
    return result;
  }

  /// Sum a list of numbers
  double sumList(List<double> numbers, {bool log = true}) {
    final result = numbers.sum;  // Using extension method
    if (log) _log('sum([${numbers.join(', ')}])', result);
    return result;
  }

  // ============================================================================
  // HIGHER-ORDER FUNCTIONS - Functions as parameters and return values
  // ============================================================================

  /// Apply a function to all elements in a list
  /// Ruby: numbers.map { |n| operation.call(n) }
  /// Python: [operation(n) for n in numbers]
  List<double> applyToAll(List<double> numbers, UnaryFunction operation) {
    return numbers.map(operation).toList();
  }

  /// Compose two functions: (f ∘ g)(x) = f(g(x))
  UnaryFunction compose(UnaryFunction f, UnaryFunction g) {
    return (x) => f(g(x));
  }

  /// Reduce list with custom binary operation
  /// Ruby: numbers.reduce { |acc, n| operation.call(acc, n) }
  /// Python: reduce(operation, numbers)
  double reduceWith(List<double> numbers, BinaryFunction operation) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce(operation);
  }

  /// Partial application: fix first argument of binary function
  UnaryFunction partial(BinaryFunction f, double fixedArg) {
    return (x) => f(fixedArg, x);
  }

  /// Curry: convert binary function to unary functions
  /// Returns a function that returns a function
  UnaryFunction Function(double) curry(BinaryFunction f) {
    return (a) => (b) => f(a, b);
  }

  // ============================================================================
  // CLOSURES - Functions that capture outer scope
  // ============================================================================

  /// Create a multiplier function that captures the factor
  UnaryFunction createMultiplier(double factor) {
    // This closure captures 'factor' from the outer scope
    return (x) {
      final result = x * factor;
      _log('$x × $factor (multiplier)', result);
      return result;
    };
  }

  /// Create a running total calculator
  BinaryFunction createRunningTotal() {
    double total = 0;  // Captured variable - persists between calls
    
    return (a, b) {
      total += a + b;
      _log('Running total', total);
      return total;
    };
  }

  /// Create a counter function
  int Function() createCounter([int start = 0]) {
    int count = start;
    
    return () {
      count++;
      return count;
    };
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Show calculation history
  void showHistory({int limit = 10}) {
    if (_history.isEmpty) {
      print('\n📝 No history yet');
      return;
    }

    print('\n📝 Calculation History (last $limit):');
    final entries = _history.length > limit 
        ? _history.sublist(_history.length - limit)
        : _history;
    
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final time = (entry['timestamp'] as DateTime)
          .toIso8601String()
          .substring(11, 19);
      print('   ${i + 1}. [$time] ${entry['operation']} = ${entry['result']}');
    }
  }

  /// Clear history and return count
  String clearHistory() {
    final count = _history.length;
    _history.clear();
    return 'Cleared $count history entries';
  }
}

// ============================================================================
// MAIN PROGRAM - Demonstrate all features
// ============================================================================

void main() {
  print('=' * 70);
  print(' ' * 20 + '🧮 ENHANCED CALCULATOR DEMO');
  print('=' * 70);

  final calc = EnhancedCalculator(name: 'Scientific Calculator Pro');
  
  // Set up callback for operations
  calc.onOperation((operation, result) {
    // This closure is called after each logged operation
  });

  print('\n📱 Using: ${calc.name}');

  // ============================================================================
  // BASIC OPERATIONS
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('➕ Basic Operations');
  print('─' * 70);
  
  print('5 + 3 = ${calc.add(5, 3)}');
  print('10 - 4 = ${calc.subtract(10, 4)}');
  print('6 × 7 = ${calc.multiply(6, 7)}');
  print('15 ÷ 2 = ${calc.divide(15, 2)}');
  print('2^8 = ${calc.power(2, 8)}');
  print('5^2 (default) = ${calc.power(5)}');

  // ============================================================================
  // STATISTICAL OPERATIONS - From StatisticalMixin
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('📊 Statistical Operations');
  print('─' * 70);
  
  final data = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0];
  print('Data: $data');
  print('Mean: ${calc.mean(data).toStringAsFixed(2)}');
  print('Median: ${calc.median(data).toStringAsFixed(2)}');
  print('Mode: ${calc.mode(data)}');
  print('Variance: ${calc.variance(data).toStringAsFixed(2)}');
  print('Std Deviation: ${calc.standardDeviation(data).toStringAsFixed(2)}');

  // ============================================================================
  // SCIENTIFIC OPERATIONS - From ScientificMixin
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🔬 Scientific Operations');
  print('─' * 70);
  
  print('5! = ${calc.factorial(5)}');
  print('C(10, 3) = ${calc.combination(10, 3)}');
  print('P(10, 3) = ${calc.permutation(10, 3)}');
  print('10th prime: ${calc.nthPrime(10)}');
  print('Is 17 prime? ${calc.isPrime(17)}');
  print('Is 18 prime? ${calc.isPrime(18)}');
  
  final fibs = calc.fibonacciSequence(10);
  print('Fibonacci(10): ${fibs.join(', ')}');
  
  print('Change from 100 to 150: ${calc.percentageChange(100, 150).toStringAsFixed(2)}%');

  // ============================================================================
  // UNIT CONVERSIONS - From UnitConverterMixin
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🌡️  Unit Conversions');
  print('─' * 70);
  
  print(calc.formatConversion('°C', 25, '°F', calc.celsiusToFahrenheit(25)));
  print(calc.formatConversion('°F', 98.6, '°C', calc.fahrenheitToCelsius(98.6)));
  print(calc.formatConversion('mi', 10, 'km', calc.milesToKilometers(10)));
  print(calc.formatConversion('lb', 150, 'kg', calc.poundsToKilograms(150)));
  print(calc.formatConversion('ft', 6, 'm', calc.feetToMeters(6)));

  // ============================================================================
  // EXTENSION METHODS - On List<double>
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🔧 Extension Methods on List<double>');
  print('─' * 70);
  
  final numbers = [1.0, 2.0, 3.0, 4.0, 5.0];
  print('Numbers: $numbers');
  print('Sum: ${numbers.sum}');
  print('Average: ${numbers.average}');
  print('Max: ${numbers.max}');
  print('Min: ${numbers.min}');
  
  final squared = numbers.transform((x) => x * x);
  print('Squared: $squared');
  
  final evens = numbers.filterBy((x) => x % 2 == 0);
  print('Even numbers: $evens');

  // ============================================================================
  // HIGHER-ORDER FUNCTIONS
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🎯 Higher-Order Functions');
  print('─' * 70);
  
  // Apply function to all elements
  final doubled = calc.applyToAll([1, 2, 3, 4, 5], (x) => x * 2);
  print('Doubled: $doubled');
  
  // Function composition: double then add 5
  final doubleValue = (double x) => x * 2;
  final add5 = (double x) => x + 5;
  final doubleAndAdd5 = calc.compose(add5, doubleValue);  // Note: f(g(x))
  print('Compose(add5, double): ${doubleAndAdd5(3)}');  // (3*2)+5 = 11
  
  // Partial application
  final add10 = calc.partial((a, b) => a + b, 10);
  print('Partial(add, 10) with 5: ${add10(5)}');
  
  // Currying
  final curriedMultiply = calc.curry((a, b) => a * b);
  final multiplyBy3 = curriedMultiply(3);
  print('Curried multiply by 3 of 4: ${multiplyBy3(4)}');
  
  // Reduce with custom operation
  final product = calc.reduceWith([1, 2, 3, 4, 5], (a, b) => a * b);
  print('Product of [1,2,3,4,5]: $product');

  // ============================================================================
  // CLOSURES
  // ============================================================================
  
  print('\n${'─' * 70}');
  print('🔐 Closures (Capturing Outer Scope)');
  print('─' * 70);
  
  // Create multiplier closure
  final times5 = calc.createMultiplier(5);
  print('Multiplier(5) of 7: ${times5(7)}');
  print('Multiplier(5) of 10: ${times5(10)}');
  
  // Running total closure
  final runningTotal = calc.createRunningTotal();
  print('Running total(1, 2): ${runningTotal(1, 2)}');
  print('Running total(3, 4): ${runningTotal(3, 4)}');
  print('Running total(5, 6): ${runningTotal(5, 6)}');
  
  // Counter closure
  final counter = calc.createCounter(10);
  print('Counter: ${counter()}');  // 11
  print('Counter: ${counter()}');  // 12
  print('Counter: ${counter()}');  // 13

  // ============================================================================
  // HISTORY
  // ============================================================================
  
  print('\n${'=' * 70}');
  print(' ' * 28 + 'HISTORY');
  print('=' * 70);
  
  calc.showHistory(limit: 15);

  print('\n${'=' * 70}');
  print('\n✅ All features demonstrated successfully!\n');
}
