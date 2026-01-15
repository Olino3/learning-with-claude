# Exercise 1: Custom Event Stream

Build a custom event emitter using StreamController.

## 📝 Requirements

Create an `EventEmitter<T>` class that:
1. Allows subscribing to events
2. Emits events to all subscribers
3. Supports event filtering
4. Properly closes the stream

## 🎯 Example Usage

```dart
void main() async {
  var emitter = EventEmitter<String>();
  
  emitter.stream.listen((event) {
    print('Subscriber 1: $event');
  });
  
  emitter.emit('Hello');
  emitter.emit('World');
  
  await emitter.close();
}
```
