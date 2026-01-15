# Exercise 2: Route Annotation System

Build a simple routing system using annotations.

## 📝 Requirements

1. Create `@Route(String path)` annotation
2. Create router that scans classes for routes
3. Support path parameters like `/user/:id`

## 🎯 Example

```dart
class ApiController {
  @Route('/users')
  List<User> getUsers() { }
  
  @Route('/user/:id')
  User getUser(int id) { }
}
```
