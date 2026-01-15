# Exercise 2: Collection Extensions

Build useful extension methods for Dart collections.

## 📝 Requirements

Create extensions for:
1. `List<int>` - sum, average, median
2. `List<T>` - partition based on predicate
3. `Map<K, V>` - merge with another map

## 🎯 Example

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5];
  print(numbers.sum);      // 15
  print(numbers.average);  // 3.0
  
  var (evens, odds) = numbers.partition((n) => n.isEven);
  print(evens);  // [2, 4]
  print(odds);   // [1, 3, 5]
}
```
