# Exercise 1: Custom Exception Hierarchy

Create a hierarchy of custom exceptions for a banking application.

## 📝 Requirements

Create exceptions:
1. `BankingException` (base class)
2. `InsufficientFundsException`
3. `AccountNotFoundException`
4. `InvalidTransactionException`

Each should include helpful error messages and context.

## 🎯 Example

```dart
class BankAccount {
  void withdraw(double amount) {
    if (balance < amount) {
      throw InsufficientFundsException(
        accountId: id,
        requested: amount,
        available: balance,
      );
    }
  }
}
```
