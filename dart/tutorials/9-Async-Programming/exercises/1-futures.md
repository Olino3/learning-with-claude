# Exercise 1: Futures

Master async/await and Futures.

## 🚀 Practice

```bash
make dart-repl
```

```dart
// Basic async function
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return "Data loaded";
}

// Usage
void main() async {
  print("Start");
  var data = await fetchData();
  print(data);
  print("End");
}

// Multiple futures in parallel
Future<void> parallel() async {
  var results = await Future.wait([
    fetchData(),
    fetchData(),
    fetchData(),
  ]);
  print(results);
}
```

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/9-Async-Programming/exercises/async_demo.dart`

```dart
void main() async {
  print("=== Sequential ===");
  await sequential();

  print("\n=== Parallel ===");
  await parallel();

  print("\n=== With Error Handling ===");
  await withErrors();
}

Future<void> sequential() async {
  var start = DateTime.now();

  var user = await fetchUser("Alice");
  var posts = await fetchPosts(user);
  var comments = await fetchComments(posts);

  var duration = DateTime.now().difference(start);
  print("Took: ${duration.inMilliseconds}ms");
}

Future<void> parallel() async {
  var start = DateTime.now();

  var results = await Future.wait([
    fetchUser("Alice"),
    fetchPosts("Alice"),
    fetchComments("Alice's posts"),
  ]);

  var duration = DateTime.now().difference(start);
  print("Took: ${duration.inMilliseconds}ms");
  print("Results: $results");
}

Future<void> withErrors() async {
  try {
    var result = await riskyOperation();
    print("Success: $result");
  } catch (e) {
    print("Error: $e");
  }
}

Future<String> fetchUser(String name) async {
  await Future.delayed(Duration(milliseconds: 500));
  return "User: $name";
}

Future<String> fetchPosts(String user) async {
  await Future.delayed(Duration(milliseconds: 500));
  return "Posts for $user";
}

Future<String> fetchComments(String posts) async {
  await Future.delayed(Duration(milliseconds: 500));
  return "Comments on $posts";
}

Future<String> riskyOperation() async {
  await Future.delayed(Duration(milliseconds: 500));
  if (DateTime.now().millisecond % 2 == 0) {
    throw Exception("Random failure");
  }
  return "Success";
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/9-Async-Programming/exercises/async_demo.dart`

## ✅ Success Criteria

- [ ] Can use async/await
- [ ] Understand Future.wait()
- [ ] Can handle errors in async code
- [ ] Completed async demo
