# Tutorial 6: Object-Oriented Programming

Welcome to Dart's OOP tutorial! Dart is a fully object-oriented language with classes, inheritance, interfaces, mixins, and more.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Create classes with constructors and properties
- Use named and factory constructors
- Implement getters and setters
- Understand inheritance and method overriding
- Work with abstract classes and interfaces
- Use mixins for code reuse
- Apply OOP principles in Dart

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Class definition | `class MyClass:` | `class MyClass {` |
| Constructor | `def __init__(self, x):` | `MyClass(this.x);` |
| Instance variable | `self.x = x` | `this.x` or just `x` |
| Method | `def method(self):` | `void method() {` |
| Inheritance | `class Child(Parent):` | `class Child extends Parent {` |
| Interface | Abstract base class | `implements Interface` |
| Multiple inheritance | Multiple parents | Mixins with `with` |
| Private | `_name` (convention) | `_name` (enforced) |
| Property decorator | `@property` | `get name => ...` |
| Static method | `@staticmethod` | `static method()` |

## 📝 Classes and Constructors

### Basic Class

```dart
class Person {
  // Properties
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Method
  void introduce() {
    print("Hi, I'm $name and I'm $age years old.");
  }
}

// Create instance
var person = Person("Alice", 30);
person.introduce();  // Hi, I'm Alice and I'm 30 years old.
```

> **📘 Python Note:** Dart's `this.name` in constructor is shorthand for `this.name = name`. Much cleaner than Python's `self.name = name`!

### Named Constructors

```dart
class Point {
  double x, y;

  // Default constructor
  Point(this.x, this.y);

  // Named constructor
  Point.origin()
      : x = 0,
        y = 0;

  // Named constructor with logic
  Point.fromList(List<double> coords)
      : x = coords[0],
        y = coords[1] {
    print("Point created from list");
  }

  // Named constructor - polar coordinates
  Point.polar(double radius, double angle)
      : x = radius * cos(angle),
        y = radius * sin(angle);
}

// Usage
var p1 = Point(3, 4);
var p2 = Point.origin();
var p3 = Point.fromList([5, 6]);
```

> **📘 Python Note:** Python doesn't have built-in named constructors. You'd use `@classmethod` or factory functions.

### Factory Constructors

```dart
class Logger {
  final String name;
  static final Map<String, Logger> _cache = {};

  // Private constructor
  Logger._internal(this.name);

  // Factory constructor - can return cached instance
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  void log(String message) {
    print("[$name] $message");
  }
}

// Both return same instance!
var logger1 = Logger("App");
var logger2 = Logger("App");
print(identical(logger1, logger2));  // true
```

## 📝 Properties and Methods

### Getters and Setters

```dart
class Rectangle {
  double width, height;

  Rectangle(this.width, this.height);

  // Getter
  double get area => width * height;

  // Getter with logic
  double get perimeter => 2 * (width + height);

  // Setter
  set dimensions(List<double> dims) {
    width = dims[0];
    height = dims[1];
  }
}

var rect = Rectangle(10, 5);
print(rect.area);       // 50.0
print(rect.perimeter);  // 30.0

rect.dimensions = [20, 10];
print(rect.area);       // 200.0
```

> **📘 Python Note:** Similar to `@property` decorator but simpler syntax. Use `get` and `set` keywords.

### Private Members

```dart
class BankAccount {
  String accountNumber;
  double _balance;  // Private (starts with _)

  BankAccount(this.accountNumber, this._balance);

  // Public getter
  double get balance => _balance;

  // Public methods to modify private field
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      return true;
    }
    return false;
  }
}

var account = BankAccount("123456", 1000);
print(account.balance);  // 1000
account.deposit(500);
// account._balance = 10000;  // Error in another library!
```

> **📘 Python Note:** Unlike Python's `_name` convention, Dart's `_` is enforced at the library level. Truly private within the library!

## 📝 Inheritance

```dart
class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  void makeSound() {
    print("Some generic sound");
  }

  void describe() {
    print("$name is $age years old");
  }
}

class Dog extends Animal {
  String breed;

  // Call parent constructor
  Dog(String name, int age, this.breed) : super(name, age);

  // Override method
  @override
  void makeSound() {
    print("Woof! Woof!");
  }

  // New method
  void fetch() {
    print("$name is fetching the ball!");
  }
}

class Cat extends Animal {
  Cat(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print("Meow!");
  }
}

// Usage
var dog = Dog("Rex", 5, "Labrador");
dog.describe();    // Rex is 5 years old
dog.makeSound();   // Woof! Woof!
dog.fetch();       // Rex is fetching the ball!

var cat = Cat("Whiskers", 3);
cat.makeSound();   // Meow!
```

> **📘 Python Note:** Very similar to Python inheritance! Use `extends` instead of parentheses, and `@override` annotation is optional but recommended.

## 📝 Abstract Classes

```dart
// Abstract class - cannot instantiate
abstract class Shape {
  // Abstract method - must be implemented
  double calculateArea();
  double calculatePerimeter();

  // Concrete method
  void display() {
    print("Area: ${calculateArea()}");
    print("Perimeter: ${calculatePerimeter()}");
  }
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double calculateArea() => 3.14159 * radius * radius;

  @override
  double calculatePerimeter() => 2 * 3.14159 * radius;
}

class Square extends Shape {
  double side;

  Square(this.side);

  @override
  double calculateArea() => side * side;

  @override
  double calculatePerimeter() => 4 * side;
}

// Usage
Shape circle = Circle(5);
Shape square = Square(4);

circle.display();
square.display();

// var shape = Shape();  // Error! Cannot instantiate abstract class
```

> **📘 Python Note:** Like Python's ABC (Abstract Base Class). Use `abstract` keyword instead of `@abstractmethod`.

## 📝 Interfaces

```dart
// Any class can be used as an interface
class Printable {
  void printInfo() {
    print("Printing info...");
  }
}

class Saveable {
  void save() {
    print("Saving...");
  }
}

// Implement multiple interfaces
class Document implements Printable, Saveable {
  String title;

  Document(this.title);

  // Must implement all interface methods
  @override
  void printInfo() {
    print("Document: $title");
  }

  @override
  void save() {
    print("Saving document: $title");
  }
}

var doc = Document("Report");
doc.printInfo();
doc.save();
```

> **📘 Python Note:** Dart doesn't have separate interface keyword. Any class can be an interface using `implements`.

## 📝 Mixins

Mixins allow code reuse across multiple class hierarchies.

```dart
// Mixin definition
mixin Flyable {
  void fly() {
    print("Flying through the air!");
  }
}

mixin Swimmable {
  void swim() {
    print("Swimming in water!");
  }
}

// Use mixins
class Duck extends Animal with Flyable, Swimmable {
  Duck(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print("Quack!");
  }
}

class Fish extends Animal with Swimmable {
  Fish(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print("Blub blub!");
  }
}

// Usage
var duck = Duck("Donald", 2);
duck.makeSound();  // Quack!
duck.fly();        // Flying through the air!
duck.swim();       // Swimming in water!

var fish = Fish("Nemo", 1);
fish.swim();       // Swimming in water!
// fish.fly();     // Error! Fish doesn't have Flyable
```

> **📘 Python Note:** Mixins are cleaner than Python's multiple inheritance! Use `with` keyword. No diamond problem!

### Mixin Constraints

```dart
// Mixin that requires a specific superclass
mixin Musical on Animal {
  void playMusic() {
    print("$name is playing music!");
  }
}

class Dog extends Animal with Musical {
  Dog(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print("Woof!");
  }
}

var dog = Dog("Buddy", 3);
dog.playMusic();  // Buddy is playing music!
```

## 📝 Static Members

```dart
class MathUtils {
  // Static property
  static const double pi = 3.14159;

  // Static method
  static double circleArea(double radius) {
    return pi * radius * radius;
  }

  static int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  }
}

// Use without instance
print(MathUtils.pi);
print(MathUtils.circleArea(5));
print(MathUtils.factorial(5));
```

## ✍️ Exercises

### Exercise 1: Classes Basics

👉 **[Start Exercise 1: Classes Basics](exercises/1-classes-basics.md)**

### Exercise 2: Inheritance and Mixins

👉 **[Start Exercise 2: Inheritance and Mixins](exercises/2-inheritance-mixins.md)**

### Exercise 3: OOP Challenges

👉 **[Start Exercise 3: OOP Challenges](exercises/3-oop-challenges.md)**

## 📚 What You Learned

✅ Classes and constructors
✅ Named and factory constructors
✅ Getters and setters
✅ Inheritance and method overriding
✅ Abstract classes
✅ Interfaces
✅ Mixins for code reuse
✅ Static members

## 🔜 Next Steps

**Next tutorial: 7-Null-Safety**

## 💡 Key Takeaways for Python Developers

1. **Constructor Shorthand**: `this.name` is cleaner than `self.name = name`
2. **Named Constructors**: Better than classmethod factories
3. **Mixins**: Cleaner than multiple inheritance
4. **Private**: `_` is enforced at library level
5. **Getters/Setters**: Simpler than `@property`
6. **Abstract**: Built-in with `abstract` keyword

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting super()

```dart
class Child extends Parent {
  Child(String name) : super(name);  // Must call super!
}
```

### Pitfall 2: Using implements vs extends

```dart
// extends - inherit implementation
class Child extends Parent { }

// implements - must implement all methods
class Child implements Parent { }
```

## 📖 Additional Resources

- [Dart Language Tour - Classes](https://dart.dev/language/classes)
- [Dart Language Tour - Mixins](https://dart.dev/language/mixins)

---

Ready? Start with **[Exercise 1: Classes Basics](exercises/1-classes-basics.md)**!
