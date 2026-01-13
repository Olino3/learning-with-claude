# Exercise 2: Inheritance and Mixins

Master inheritance, abstract classes, and mixins.

## 🚀 REPL Practice

```bash
make dart-repl
```

```dart
// Abstract class
abstract class Animal {
  String name;
  Animal(this.name);

  void makeSound();  // Abstract method

  void sleep() {
    print("$name is sleeping");
  }
}

class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void makeSound() {
    print("$name: Woof!");
  }
}

var dog = Dog("Rex");
dog.makeSound();
dog.sleep();

// Mixins
mixin Flyable {
  void fly() => print("Flying!");
}

mixin Swimmable {
  void swim() => print("Swimming!");
}

class Duck extends Animal with Flyable, Swimmable {
  Duck(String name) : super(name);

  @override
  void makeSound() => print("$name: Quack!");
}

var duck = Duck("Donald");
duck.makeSound();
duck.fly();
duck.swim();
```

## 📝 Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/6-Object-Oriented-Programming/exercises/shapes.dart`

```dart
void main() {
  List<Shape> shapes = [
    Circle(5),
    Rectangle(4, 6),
    Triangle(3, 4, 5),
  ];

  for (var shape in shapes) {
    shape.display();
    print("");
  }
}

abstract class Shape {
  double calculateArea();
  double calculatePerimeter();

  void display() {
    print("${runtimeType}:");
    print("  Area: ${calculateArea().toStringAsFixed(2)}");
    print("  Perimeter: ${calculatePerimeter().toStringAsFixed(2)}");
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

class Rectangle extends Shape {
  double width, height;

  Rectangle(this.width, this.height);

  @override
  double calculateArea() => width * height;

  @override
  double calculatePerimeter() => 2 * (width + height);
}

class Triangle extends Shape {
  double a, b, c;

  Triangle(this.a, this.b, this.c);

  @override
  double calculateArea() {
    var s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  @override
  double calculatePerimeter() => a + b + c;
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/6-Object-Oriented-Programming/exercises/shapes.dart`

## ✅ Success Criteria

- [ ] Understand abstract classes
- [ ] Can use inheritance
- [ ] Can use mixins
- [ ] Completed shapes challenge
