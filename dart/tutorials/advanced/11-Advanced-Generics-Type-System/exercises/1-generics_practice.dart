#!/usr/bin/env dart
// Tutorial 11: Advanced Generics Practice

void main() {
  print("=" * 70);
  print("ADVANCED GENERICS PRACTICE");
  print("=" * 70);

  // Example 1: Generic Stack Implementation
  print("\nExample 1: Generic Stack");
  var intStack = Stack<int>();
  intStack.push(1);
  intStack.push(2);
  intStack.push(3);
  print("Stack size: ${intStack.size}");
  print("Pop: ${intStack.pop()}"); // 3
  print("Peek: ${intStack.peek()}"); // 2
  
  var stringStack = Stack<String>();
  stringStack.push("hello");
  stringStack.push("world");
  print("String stack: ${stringStack.pop()}"); // world

  // Example 2: Generic Repository with Constraints
  print("\nExample 2: Repository with Entity Constraint");
  var userRepo = Repository<User>();
  userRepo.add(User('1', 'Alice', 'alice@example.com'));
  userRepo.add(User('2', 'Bob', 'bob@example.com'));
  
  var user = userRepo.findById('1');
  print("Found user: ${user?.name}");
  
  print("All users:");
  for (var u in userRepo.getAll()) {
    print("  - ${u.name} (${u.email})");
  }

  // Example 3: Generic Pair with Comparable
  print("\nExample 3: Comparable Pairs");
  var pair1 = ComparablePair<int, String>(10, 'ten');
  var pair2 = ComparablePair<int, String>(20, 'twenty');
  
  print("pair1 < pair2: ${pair1 < pair2}");
  print("Max pair: ${maxPair(pair1, pair2).value}");

  // Example 4: Type Inference
  print("\nExample 4: Type Inference");
  var box1 = Box.of(42); // Inferred as Box<int>
  var box2 = Box.of('hello'); // Inferred as Box<String>
  
  print("box1 type: ${box1.value.runtimeType}");
  print("box2 type: ${box2.value.runtimeType}");

  // Example 5: Generic Method Pattern
  print("\nExample 5: Generic Methods");
  var numbers = [1, 2, 3, 4, 5];
  var doubled = transform<int, int>(numbers, (x) => x * 2);
  print("Doubled: $doubled");
  
  var strings = ['a', 'b', 'c'];
  var lengths = transform<String, int>(strings, (s) => s.length);
  print("Lengths: $lengths");

  // Checkpoint: Test Your Understanding
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  // TODO: Challenge 1 - Implement a generic Queue (FIFO)
  // Expected behavior:
  // var queue = Queue<int>();
  // queue.enqueue(1);
  // queue.enqueue(2);
  // queue.dequeue(); // returns 1 (first in)
  
  // TODO: Challenge 2 - Create a generic Cache with size limit
  // Should remove oldest item when full
  // var cache = LRUCache<String, int>(maxSize: 3);
  
  // TODO: Challenge 3 - Generic filter and map combination
  // filterMap<int, String>([1,2,3,4,5], (x) => x > 2, (x) => x.toString())
  // Should return ['3', '4', '5']
}

// Generic Stack implementation
class Stack<T> {
  final List<T> _items = [];
  
  void push(T item) {
    _items.add(item);
  }
  
  T pop() {
    if (_items.isEmpty) {
      throw StateError('Stack is empty');
    }
    return _items.removeLast();
  }
  
  T peek() {
    if (_items.isEmpty) {
      throw StateError('Stack is empty');
    }
    return _items.last;
  }
  
  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
}

// Entity base class for repository pattern
abstract class Entity {
  String get id;
}

class User extends Entity {
  @override
  final String id;
  final String name;
  final String email;
  
  User(this.id, this.name, this.email);
}

// Generic repository with bounded type
class Repository<T extends Entity> {
  final List<T> _items = [];
  
  void add(T item) {
    _items.add(item);
  }
  
  T? findById(String id) {
    for (var item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
  
  List<T> getAll() => List.unmodifiable(_items);
  
  bool remove(String id) {
    var index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items.removeAt(index);
      return true;
    }
    return false;
  }
}

// Comparable pair
class ComparablePair<K extends Comparable<K>, V> {
  final K key;
  final V value;
  
  ComparablePair(this.key, this.value);
  
  bool operator <(ComparablePair<K, V> other) {
    return key.compareTo(other.key) < 0;
  }
  
  bool operator >(ComparablePair<K, V> other) {
    return key.compareTo(other.key) > 0;
  }
}

ComparablePair<K, V> maxPair<K extends Comparable<K>, V>(
  ComparablePair<K, V> a,
  ComparablePair<K, V> b,
) {
  return a > b ? a : b;
}

// Generic box with factory
class Box<T> {
  final T value;
  
  Box(this.value);
  
  // Factory constructor for type inference
  factory Box.of(T value) {
    return Box(value);
  }
}

// Generic transformation function
List<R> transform<T, R>(List<T> items, R Function(T) mapper) {
  return items.map(mapper).toList();
}
