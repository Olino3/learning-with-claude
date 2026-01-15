# Exercise 1: Type-Safe Builder Pattern

Create a type-safe builder for constructing complex objects.

## 📝 Requirements

Build a `QueryBuilder` that:
1. Uses method chaining
2. Validates required fields
3. Builds SQL-like query strings
4. Type-safe with generics

## 🎯 Example

```dart
void main() {
  var query = QueryBuilder<User>()
    ..table('users')
    ..where('age > ?', [18])
    ..orderBy('name')
    ..limit(10)
    ..build();
    
  print(query);  // SELECT * FROM users WHERE age > ? ORDER BY name LIMIT 10
}
```
