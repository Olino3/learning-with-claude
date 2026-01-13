# Exercise 1: Nullable Types

Master nullable and non-nullable types.

## 🚀 REPL Practice

```bash
make dart-repl
```

```dart
// Non-nullable - must initialize
String name = "Alice";
int age = 30;
print("$name is $age");

// Nullable - can be null
String? nickname;
print(nickname);  // null

nickname = "Ally";
print(nickname);  // "Ally"

// Must check before use
if (nickname != null) {
  print(nickname.length);  // Safe!
}

// Or use ?.
print(nickname?.length);  // Safe, returns null if nickname is null

// Or provide default with ??
print(nickname ?? "No nickname");
```

> **📘 Python Note:** Unlike Python where any variable can be None, Dart requires explicit `?` for nullable types. This catches errors at compile time!

## 📝 Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/7-Null-Safety/exercises/user_profile.dart`

```dart
void main() {
  var user1 = UserProfile("Alice", age: 30, email: "alice@example.com");
  user1.display();

  var user2 = UserProfile("Bob");
  user2.display();

  user2.updateEmail("bob@example.com");
  user2.display();
}

class UserProfile {
  String name;
  int? age;
  String? email;
  String? phone;

  UserProfile(this.name, {this.age, this.email, this.phone});

  void display() {
    print("\nUser Profile:");
    print("Name: $name");
    print("Age: ${age ?? 'Not specified'}");
    print("Email: ${email ?? 'Not specified'}");
    print("Phone: ${phone ?? 'Not specified'}");
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    print("Email updated for $name");
  }

  bool hasContact() {
    return email != null || phone != null;
  }

  String getContactMethod() {
    if (email != null) return "Email: $email";
    if (phone != null) return "Phone: $phone";
    return "No contact information";
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/7-Null-Safety/exercises/user_profile.dart`

## ✅ Success Criteria

- [ ] Understand nullable vs non-nullable
- [ ] Can use `?` for nullable types
- [ ] Can check for null before use
- [ ] Completed user profile challenge
