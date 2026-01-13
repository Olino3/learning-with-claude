# Exercise 2: Writing Files

Master file writing operations.

## 🚀 Practice

```bash
make dart-repl
```

```dart
import 'dart:io';

// Write string
void writeFile() {
  var file = File('/tmp/output.txt');
  file.writeAsStringSync("Hello, Dart!");
  print("File written");
}

// Append to file
void appendFile() {
  var file = File('/tmp/output.txt');
  file.writeAsStringSync("\nMore text", mode: FileMode.append);
  print("Text appended");
}

// Write lines
void writeLines() {
  var file = File('/tmp/lines.txt');
  var lines = ["Line 1", "Line 2", "Line 3"];
  file.writeAsStringSync(lines.join('\n'));
}

// Async version
Future<void> writeAsync() async {
  var file = File('/tmp/async_output.txt');
  await file.writeAsString("Async write\n");
}

writeFile();
appendFile();
writeLines();
await writeAsync();
```

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/10-File-IO/exercises/file_writer.dart`

```dart
import 'dart:io';

void main() async {
  print("=== Write Text ===");
  await writeText();

  print("\n=== Append Text ===");
  await appendText();

  print("\n=== Write List ===");
  await writeList();

  print("\n=== Logger Example ===");
  await loggerExample();
}

Future<void> writeText() async {
  var file = File('/tmp/output.txt');
  await file.writeAsString("Hello, Dart!\n");
  print("Written to ${file.path}");
}

Future<void> appendText() async {
  var file = File('/tmp/output.txt');
  await file.writeAsString("Appended line\n", mode: FileMode.append);
  print("Appended to ${file.path}");

  // Read back
  var contents = await file.readAsString();
  print("Contents:\n$contents");
}

Future<void> writeList() async {
  var file = File('/tmp/list.txt');

  var items = [
    "Apple",
    "Banana",
    "Orange",
    "Mango",
    "Grape"
  ];

  await file.writeAsString(items.join('\n'));
  print("Written ${items.length} items");

  var readBack = await file.readAsLines();
  print("Items: $readBack");
}

Future<void> loggerExample() async {
  var logger = SimpleLogger('/tmp/app.log');

  await logger.log("info", "Application started");
  await logger.log("warning", "Low memory");
  await logger.log("error", "Connection failed");
  await logger.log("info", "Application stopped");

  print("\nLog file contents:");
  var logs = await File('/tmp/app.log').readAsLines();
  for (var entry in logs) {
    print(entry);
  }
}

class SimpleLogger {
  final File file;

  SimpleLogger(String path) : file = File(path);

  Future<void> log(String level, String message) async {
    var timestamp = DateTime.now().toIso8601String();
    var entry = "[$timestamp] [$level] $message\n";

    await file.writeAsString(entry, mode: FileMode.append);
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/10-File-IO/exercises/file_writer.dart`

## ✅ Success Criteria

- [ ] Can write to files
- [ ] Can append to files
- [ ] Can write structured data
- [ ] Completed file writer
