# Exercise 2: Null Operators

Master null-aware operators.

## 🚀 REPL Practice

```bash
make dart-repl
```

```dart
// ?? - null coalescing
String? name;
print(name ?? "Guest");  // "Guest"

name = "Alice";
print(name ?? "Guest");  // "Alice"

// ??= - assign if null
String? title;
title ??= "Default";
print(title);  // "Default"

title ??= "Another";
print(title);  // Still "Default"

// ?. - safe navigation
String? text;
print(text?.length);  // null

text = "Hello";
print(text?.length);  // 5

// Chain operators
var result = text?.toUpperCase()?.substring(0, 3);
print(result);  // "HEL"

// ! - assertion (use sparingly!)
String? certain = "Definitely not null";
print(certain!.length);  // 20
```

## 📝 Script Challenge

**Create:** `/home/user/learning-with-claude/dart/tutorials/7-Null-Safety/exercises/config_manager.dart`

```dart
void main() {
  var config = ConfigManager();

  print("Theme: ${config.getTheme()}");
  print("Font size: ${config.getFontSize()}");

  config.setTheme("dark");
  print("Theme: ${config.getTheme()}");

  config.setFontSize(16);
  print("Font size: ${config.getFontSize()}");

  config.reset();
  print("After reset - Theme: ${config.getTheme()}");
}

class ConfigManager {
  String? _theme;
  int? _fontSize;
  bool? _notifications;

  String getTheme() => _theme ?? "light";

  int getFontSize() => _fontSize ?? 14;

  bool getNotifications() => _notifications ?? true;

  void setTheme(String theme) {
    _theme = theme;
  }

  void setFontSize(int size) {
    _fontSize = size;
  }

  void setNotifications(bool enabled) {
    _notifications = enabled;
  }

  void reset() {
    _theme = null;
    _fontSize = null;
    _notifications = null;
  }

  Map<String, dynamic> toMap() {
    return {
      "theme": _theme ?? "light",
      "fontSize": _fontSize ?? 14,
      "notifications": _notifications ?? true,
    };
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/7-Null-Safety/exercises/config_manager.dart`

## ✅ Success Criteria

- [ ] Can use ?? for defaults
- [ ] Can use ??= for conditional assignment
- [ ] Can use ?. for safe navigation
- [ ] Understand when to use !
- [ ] Completed config manager
