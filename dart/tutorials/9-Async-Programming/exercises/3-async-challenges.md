# Exercise 3: Async Challenges

Apply all async concepts.

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/9-Async-Programming/exercises/api_client.dart`

```dart
import 'dart:async';

void main() async {
  var client = ApiClient();

  print("=== Fetch User ===");
  await client.fetchUser(1);

  print("\n=== Fetch Multiple ===");
  await client.fetchMultiple();

  print("\n=== With Timeout ===");
  await client.fetchWithTimeout();

  print("\n=== Retry ===");
  await client.retryExample();
}

class ApiClient {
  Future<Map<String, dynamic>> fetchUser(int id) async {
    print("Fetching user $id...");
    await Future.delayed(Duration(seconds: 1));

    return {
      "id": id,
      "name": "User $id",
      "email": "user$id@example.com"
    };
  }

  Future<void> fetchMultiple() async {
    var start = DateTime.now();

    var users = await Future.wait([
      fetchUser(1),
      fetchUser(2),
      fetchUser(3),
    ]);

    var duration = DateTime.now().difference(start);
    print("Fetched ${users.length} users in ${duration.inSeconds}s");

    for (var user in users) {
      print("  - ${user['name']}");
    }
  }

  Future<void> fetchWithTimeout() async {
    try {
      var user = await fetchUser(1).timeout(
        Duration(milliseconds: 500),
        onTimeout: () => throw TimeoutException("Request timed out"),
      );
      print("Got user: ${user['name']}");
    } on TimeoutException catch (e) {
      print("Timeout: ${e.message}");
    }
  }

  Future<void> retryExample() async {
    var result = await retry(
      () => unreliableOperation(),
      attempts: 3,
    );
    print("Final result: $result");
  }

  Future<String> unreliableOperation() async {
    print("Attempting operation...");
    await Future.delayed(Duration(milliseconds: 500));

    if (DateTime.now().millisecond % 3 != 0) {
      throw Exception("Random failure");
    }

    return "Success!";
  }

  Future<T> retry<T>(
    Future<T> Function() operation,
    {int attempts = 3}
  ) async {
    for (var i = 0; i < attempts; i++) {
      try {
        return await operation();
      } catch (e) {
        if (i == attempts - 1) {
          print("Failed after $attempts attempts");
          rethrow;
        }
        print("Attempt ${i + 1} failed, retrying...");
        await Future.delayed(Duration(seconds: 1));
      }
    }
    throw StateError("Unreachable");
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/9-Async-Programming/exercises/api_client.dart`

## ✅ Success Criteria

- [ ] Can handle multiple async operations
- [ ] Can use timeouts
- [ ] Can implement retry logic
- [ ] Completed API client

🎉 Congratulations! Ready for **Tutorial 10: File I/O**!
