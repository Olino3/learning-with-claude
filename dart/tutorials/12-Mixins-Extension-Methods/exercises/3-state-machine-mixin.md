# Exercise 3: State Machine Mixin

Implement a state machine pattern using mixins.

## 📝 Requirements

Create a `StateMachine` mixin that:
1. Tracks current state
2. Validates state transitions
3. Triggers callbacks on state changes

## 🎯 Example

```dart
enum OrderState { pending, processing, shipped, delivered }

class Order with StateMachine<OrderState> {
  Order() {
    setState(OrderState.pending);
  }
  
  void process() => transition(OrderState.processing);
  void ship() => transition(OrderState.shipped);
  void deliver() => transition(OrderState.delivered);
}
```
