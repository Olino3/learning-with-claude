# Exercise 1: Generic Stack Implementation

Build a generic Stack data structure that works with any type.

## 📝 Requirements

Create a `Stack<T>` class with the following methods:

1. `push(T item)` - Add an item to the top of the stack
2. `T? pop()` - Remove and return the top item (null if empty)
3. `T? peek()` - Return the top item without removing it (null if empty)
4. `bool get isEmpty` - Check if stack is empty
5. `int get size` - Get the number of items in the stack
6. `void clear()` - Remove all items from the stack

## 🎯 Example Usage

```dart
void main() {
  // Integer stack
  var intStack = Stack<int>();
  intStack.push(1);
  intStack.push(2);
  intStack.push(3);
  
  print(intStack.peek());  // 3
  print(intStack.pop());   // 3
  print(intStack.size);    // 2
  
  // String stack
  var stringStack = Stack<String>();
  stringStack.push('hello');
  stringStack.push('world');
  
  print(stringStack.pop());  // world
  print(stringStack.pop());  // hello
  print(stringStack.isEmpty);  // true
}
```

## 💡 Hints

- Use a `List<T>` internally to store the stack items
- Remember LIFO (Last In, First Out) order
- Return `null` when trying to pop/peek from an empty stack

## ✅ Solution

<details>
<summary>Click to reveal solution</summary>

```dart
class Stack<T> {
  final List<T> _items = [];
  
  void push(T item) {
    _items.add(item);
  }
  
  T? pop() {
    if (isEmpty) return null;
    return _items.removeLast();
  }
  
  T? peek() {
    if (isEmpty) return null;
    return _items.last;
  }
  
  bool get isEmpty => _items.isEmpty;
  
  int get size => _items.length;
  
  void clear() {
    _items.clear();
  }
  
  @override
  String toString() => 'Stack($_items)';
}

void main() {
  var stack = Stack<int>();
  stack.push(1);
  stack.push(2);
  stack.push(3);
  
  print(stack);           // Stack([1, 2, 3])
  print(stack.peek());    // 3
  print(stack.pop());     // 3
  print(stack.size);      // 2
  print(stack.isEmpty);   // false
  
  stack.clear();
  print(stack.isEmpty);   // true
  print(stack.pop());     // null
}
```

</details>

## 🚀 Bonus Challenges

1. Add a `List<T> toList()` method that returns a copy of the stack as a list
2. Make the stack iterable by implementing `Iterable<T>`
3. Add a `contains(T item)` method to check if an item exists
4. Create a `map<R>(R Function(T) transform)` method that returns a new stack with transformed values
