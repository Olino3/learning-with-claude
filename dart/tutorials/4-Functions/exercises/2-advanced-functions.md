# Exercise 2: Advanced Functions

Master closures, higher-order functions, and functional programming patterns.

## 🎯 Objective

Understand closures, higher-order functions, and functional composition.

## 🚀 Steps

### Step 1: Start Your REPL

```bash
make dart-repl
```

### Step 2: Anonymous Functions

```dart
// Anonymous function in variable
var multiply = (int a, int b) => a * b;
print(multiply(5, 3));  // 15

// Multi-line anonymous function
var greet = (String name) {
  var time = DateTime.now().hour;
  var greeting = time < 12 ? "Good morning" : "Good afternoon";
  return "$greeting, $name!";
};

print(greet("Alice"));

// Used inline with collections
var numbers = [1, 2, 3, 4, 5];

numbers.forEach((n) {
  print("Number: $n, Square: ${n * n}");
});
```

### Step 3: Closures

```dart
// Closure captures outer variable
Function makeMultiplier(int factor) {
  return (int value) => value * factor;
}

var times2 = makeMultiplier(2);
var times10 = makeMultiplier(10);

print(times2(5));   // 10
print(times10(5));  // 50

// Counter with state
Function makeCounter({int start = 0, int step = 1}) {
  var count = start;
  return () {
    var current = count;
    count += step;
    return current;
  };
}

var counter = makeCounter();
print(counter());  // 0
print(counter());  // 1
print(counter());  // 2

var counter2 = makeCounter(start: 10, step: 5);
print(counter2());  // 10
print(counter2());  // 15
```

> **📘 Python Note:** Identical to Python closures! Variables from outer scope are captured.

### Step 4: Higher-Order Functions - Map, Filter, Reduce

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// map - transform
var squared = numbers.map((n) => n * n).toList();
print(squared);

// where - filter
var evens = numbers.where((n) => n % 2 == 0).toList();
print(evens);

// reduce - combine
var sum = numbers.reduce((a, b) => a + b);
print("Sum: $sum");

// fold - reduce with initial value
var product = numbers.fold(1, (a, b) => a * b);
print("Product: $product");

// Chain operations
var result = numbers
    .where((n) => n > 5)
    .map((n) => n * 2)
    .toList();
print(result);  // [12, 14, 16, 18, 20]
```

### Step 5: Creating Higher-Order Functions

```dart
// Function that takes a function
List<T> filter<T>(List<T> items, bool Function(T) predicate) {
  var result = <T>[];
  for (var item in items) {
    if (predicate(item)) {
      result.add(item);
    }
  }
  return result;
}

var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
var evens = filter(numbers, (n) => n % 2 == 0);
print(evens);  // [2, 4, 6, 8, 10]

// Generic map function
List<R> transform<T, R>(List<T> items, R Function(T) mapper) {
  return items.map(mapper).toList();
}

var doubled = transform(numbers, (n) => n * 2);
var strings = transform(numbers, (n) => "Number: $n");
```

### Step 6: Function Composition

```dart
// Compose functions together
Function compose<A, B, C>(B Function(A) f, C Function(B) g) {
  return (A x) => g(f(x));
}

var addOne = (int x) => x + 1;
var double = (int x) => x * 2;

var addOneThenDouble = compose(addOne, double);
print(addOneThenDouble(5));  // (5 + 1) * 2 = 12
```

### Step 7: Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/4-Functions/exercises/functional.dart`

```dart
void main() {
  // Test functional utilities
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  print("=== Map ===");
  print(map(numbers, (n) => n * n));

  print("\n=== Filter ===");
  print(filter(numbers, (n) => n % 2 == 0));

  print("\n=== Pipeline ===");
  var result = pipeline(
    numbers,
    [
      (list) => filter(list as List<int>, (n) => n > 3),
      (list) => map(list as List<int>, (n) => n * 2),
    ]
  );
  print(result);
}

List<R> map<T, R>(List<T> items, R Function(T) fn) {
  return items.map(fn).toList();
}

List<T> filter<T>(List<T> items, bool Function(T) fn) {
  return items.where(fn).toList();
}

dynamic pipeline(dynamic input, List<Function> functions) {
  var result = input;
  for (var fn in functions) {
    result = fn(result);
  }
  return result;
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/4-Functions/exercises/functional.dart`

## ✅ Success Criteria

- [ ] Understand closures and captured variables
- [ ] Can create higher-order functions
- [ ] Can chain functional operations
- [ ] Completed the script challenge

## 🎉 Congratulations!

Move on to **Exercise 3: Function Challenges**!
