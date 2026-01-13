# Exercise 1: Classes Basics

Learn class creation, constructors, and properties.

## 🚀 REPL Practice

```bash
make dart-repl
```

```dart
// Basic class
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print("Hi, I'm $name, $age years old");
  }
}

var person = Person("Alice", 30);
person.introduce();

// With getters
class Rectangle {
  double width, height;

  Rectangle(this.width, this.height);

  double get area => width * height;
  double get perimeter => 2 * (width + height);
}

var rect = Rectangle(10, 5);
print("Area: ${rect.area}, Perimeter: ${rect.perimeter}");

// Named constructors
class Point {
  double x, y;

  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;

  double distanceFromOrigin() {
    return sqrt(x * x + y * y);
  }
}

var p1 = Point(3, 4);
var p2 = Point.origin();
```

## 📝 Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/6-Object-Oriented-Programming/exercises/bank_account.dart`

```dart
import 'dart:math';

void main() {
  var account = BankAccount("123456", "Alice", 1000);

  account.deposit(500);
  account.withdraw(200);
  account.displayBalance();

  var savings = SavingsAccount("789012", "Bob", 5000, 0.05);
  savings.addInterest();
  savings.displayBalance();
}

class BankAccount {
  String accountNumber;
  String ownerName;
  double _balance;

  BankAccount(this.accountNumber, this.ownerName, this._balance);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("Deposited: \$$amount");
    }
  }

  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print("Withdrew: \$$amount");
      return true;
    }
    print("Insufficient funds");
    return false;
  }

  void displayBalance() {
    print("Account $accountNumber ($ownerName): \$$_balance");
  }
}

class SavingsAccount extends BankAccount {
  double interestRate;

  SavingsAccount(String accountNumber, String ownerName, double balance, this.interestRate)
      : super(accountNumber, ownerName, balance);

  void addInterest() {
    var interest = _balance * interestRate;
    _balance += interest;
    print("Interest added: \$$interest");
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/6-Object-Oriented-Programming/exercises/bank_account.dart`

## ✅ Success Criteria

- [ ] Can create classes with properties
- [ ] Can use constructors effectively
- [ ] Understand getters and setters
- [ ] Completed bank account challenge

🎉 Move to **Exercise 2: Inheritance and Mixins**!
