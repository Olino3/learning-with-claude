# Tutorial 10: File I/O - Reading and Writing Files

Welcome to the final Dart tutorial! Learn how to read and write files, work with paths, and process text data using Dart's dart:io library.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Read and write files synchronously and asynchronously
- Work with the dart:io library
- Handle file paths properly
- Process text files line by line
- Handle file I/O errors
- Create and manipulate directories

## 🐍➡️🎯 Coming from Python

| Concept | Python | Dart |
|---------|--------|------|
| Import I/O | Built-in | `import 'dart:io';` |
| Read file | `open('file.txt').read()` | `File('file.txt').readAsStringSync()` |
| Write file | `with open() as f: f.write()` | `File('file.txt').writeAsStringSync()` |
| Read lines | `open().readlines()` | `File().readAsLinesSync()` |
| Async read | `aiofiles` library | `await File().readAsString()` |
| Path join | `os.path.join()` | `path.join()` (package) |
| Check exists | `os.path.exists()` | `File().existsSync()` |
| Delete file | `os.remove()` | `File().deleteSync()` |

## 📝 Reading Files

### Read Entire File

```dart
import 'dart:io';

void main() {
  // Synchronous - blocks until file is read
  var file = File('data.txt');

  if (file.existsSync()) {
    var contents = file.readAsStringSync();
    print(contents);
  } else {
    print("File doesn't exist");
  }

  // Asynchronous - non-blocking
  readAsync();
}

Future<void> readAsync() async {
  var file = File('data.txt');

  if (await file.exists()) {
    var contents = await file.readAsString();
    print(contents);
  }
}
```

> **📘 Python Note:** Similar to Python's `open().read()`. Dart has both sync and async versions explicitly.

### Read Lines

```dart
import 'dart:io';

void readLines() {
  var file = File('data.txt');

  // Read all lines at once
  var lines = file.readAsLinesSync();

  for (var i = 0; i < lines.length; i++) {
    print("Line ${i + 1}: ${lines[i]}");
  }
}

// Async version
Future<void> readLinesAsync() async {
  var file = File('data.txt');
  var lines = await file.readAsLines();

  for (var line in lines) {
    print(line);
  }
}

// Stream lines (memory efficient for large files)
Future<void> streamLines() async {
  var file = File('large_file.txt');

  await for (var line in file
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())) {
    print(line);
    // Process one line at a time
  }
}
```

> **📘 Python Note:** The streaming approach is like Python's reading line by line in a for loop.

### Read Bytes

```dart
import 'dart:io';

void readBytes() {
  var file = File('image.png');

  // Read as bytes
  var bytes = file.readAsBytesSync();
  print("File size: ${bytes.length} bytes");
}

Future<void> readBytesAsync() async {
  var file = File('image.png');
  var bytes = await file.readAsBytes();
  print("File size: ${bytes.length} bytes");
}
```

## 📝 Writing Files

### Write String

```dart
import 'dart:io';

void writeFile() {
  var file = File('output.txt');

  // Write (overwrites existing content)
  file.writeAsStringSync("Hello, Dart!\n");

  // Append
  file.writeAsStringSync("More text\n", mode: FileMode.append);
}

// Async version
Future<void> writeFileAsync() async {
  var file = File('output.txt');

  await file.writeAsString("Hello, Dart!\n");
  await file.writeAsString("More text\n", mode: FileMode.append);
}
```

> **📘 Python Note:** Similar to Python's `open('file', 'w').write()` and `open('file', 'a').write()`.

### Write Lines

```dart
import 'dart:io';

void writeLines() {
  var file = File('output.txt');

  var lines = [
    "Line 1",
    "Line 2",
    "Line 3"
  ];

  // Join with newlines
  file.writeAsStringSync(lines.join('\n'));
}

// Or write one at a time
Future<void> writeLineByLine() async {
  var file = File('output.txt');
  var sink = file.openWrite();

  sink.writeln("Line 1");
  sink.writeln("Line 2");
  sink.writeln("Line 3");

  await sink.flush();
  await sink.close();
}
```

### Write Bytes

```dart
import 'dart:io';

void writeBytes() {
  var file = File('binary.dat');

  var bytes = [0x48, 0x65, 0x6C, 0x6C, 0x6F];  // "Hello" in ASCII
  file.writeAsBytesSync(bytes);
}

Future<void> writeBytesAsync() async {
  var file = File('binary.dat');
  var bytes = [0x48, 0x65, 0x6C, 0x6C, 0x6F];
  await file.writeAsBytes(bytes);
}
```

## 📝 File Operations

### Check Existence

```dart
import 'dart:io';

void checkFile() {
  var file = File('data.txt');

  if (file.existsSync()) {
    print("File exists");

    var stat = file.statSync();
    print("Size: ${stat.size} bytes");
    print("Modified: ${stat.modified}");
    print("Type: ${stat.type}");
  } else {
    print("File doesn't exist");
  }
}
```

### Copy, Move, Delete

```dart
import 'dart:io';

Future<void> fileOperations() async {
  var source = File('source.txt');
  var destination = File('destination.txt');

  // Copy
  await source.copy(destination.path);

  // Rename/Move
  await source.rename('new_name.txt');

  // Delete
  if (await destination.exists()) {
    await destination.delete();
  }
}
```

### Create, List, Delete Directories

```dart
import 'dart:io';

Future<void> directoryOperations() async {
  // Create directory
  var dir = Directory('my_folder');
  if (!await dir.exists()) {
    await dir.create();
  }

  // Create nested directories
  var nested = Directory('path/to/nested/folder');
  await nested.create(recursive: true);

  // List contents
  var contents = dir.listSync();
  for (var item in contents) {
    if (item is File) {
      print("File: ${item.path}");
    } else if (item is Directory) {
      print("Directory: ${item.path}");
    }
  }

  // Delete directory
  await dir.delete(recursive: true);
}
```

## 📝 Working with Paths

```dart
import 'dart:io';

void pathOperations() {
  var file = File('data.txt');

  // Get absolute path
  print("Absolute path: ${file.absolute.path}");

  // Get directory
  print("Parent directory: ${file.parent.path}");

  // Path manipulation (use path package for better support)
  var path = file.path;
  print("Path: $path");

  // Create path from parts
  var newPath = "${Directory.current.path}/subdir/file.txt";
  print("New path: $newPath");
}
```

> **📘 Python Note:** Dart's path handling is more basic. Use the `path` package for advanced path operations like Python's `os.path`.

## 📝 Error Handling

```dart
import 'dart:io';

Future<void> safeFileRead(String filename) async {
  try {
    var file = File(filename);
    var contents = await file.readAsString();
    print(contents);
  } on FileSystemException catch (e) {
    print("File error: ${e.message}");
    print("Path: ${e.path}");
  } on PathNotFoundException catch (e) {
    print("Path not found: ${e.path}");
  } catch (e) {
    print("Unknown error: $e");
  }
}
```

## 📝 Practical Examples

### CSV Processing

```dart
import 'dart:io';

Future<void> processCsv(String filename) async {
  var file = File(filename);

  var lines = await file.readAsLines();

  // Skip header
  var dataLines = lines.skip(1);

  for (var line in dataLines) {
    var fields = line.split(',');
    print("Name: ${fields[0]}, Age: ${fields[1]}, Email: ${fields[2]}");
  }
}
```

### Log File

```dart
import 'dart:io';

class Logger {
  final File file;

  Logger(String filename) : file = File(filename);

  Future<void> log(String message) async {
    var timestamp = DateTime.now().toIso8601String();
    var entry = "[$timestamp] $message\n";

    await file.writeAsString(entry, mode: FileMode.append);
  }

  Future<List<String>> readLogs() async {
    if (!await file.exists()) return [];
    return await file.readAsLines();
  }
}

// Usage
void main() async {
  var logger = Logger('app.log');

  await logger.log("Application started");
  await logger.log("Processing data");
  await logger.log("Application finished");

  var logs = await logger.readLogs();
  print("Logs:");
  for (var entry in logs) {
    print(entry);
  }
}
```

### Configuration File

```dart
import 'dart:io';
import 'dart:convert';

class ConfigManager {
  final File file;

  ConfigManager(String filename) : file = File(filename);

  Future<Map<String, dynamic>> load() async {
    if (!await file.exists()) {
      return {};
    }

    var contents = await file.readAsString();
    return json.decode(contents);
  }

  Future<void> save(Map<String, dynamic> config) async {
    var contents = JsonEncoder.withIndent('  ').convert(config);
    await file.writeAsString(contents);
  }
}

// Usage
void main() async {
  var config = ConfigManager('config.json');

  // Save
  await config.save({
    'theme': 'dark',
    'fontSize': 14,
    'autoSave': true
  });

  // Load
  var settings = await config.load();
  print(settings);
}
```

## ✍️ Exercises

### Exercise 1: Reading Files

👉 **[Start Exercise 1: Reading Files](exercises/1-reading-files.md)**

### Exercise 2: Writing Files

👉 **[Start Exercise 2: Writing Files](exercises/2-writing-files.md)**

### Exercise 3: File I/O Challenges

👉 **[Start Exercise 3: File I/O Challenges](exercises/3-file-io-challenges.md)**

## 📚 What You Learned

✅ Reading and writing files
✅ Synchronous and asynchronous file operations
✅ Working with directories
✅ Path manipulation
✅ Error handling for file operations
✅ Practical file processing patterns

## 🎉 Congratulations!

You've completed all Dart tutorials! You now have a comprehensive understanding of:
- Dart basics and syntax
- Control flow and functions
- Collections and OOP
- Null safety (Dart's killer feature!)
- Error handling
- Async programming
- File I/O

## 💡 Key Takeaways for Python Developers

1. **Explicit Sync/Async**: Dart has separate sync and async methods
2. **Import Required**: Must import dart:io for file operations
3. **FileSystemException**: Specific exception for file errors
4. **Streams**: Can stream large files efficiently
5. **Path Package**: Use for advanced path operations
6. **Null Safety**: File operations return nullable types

## 🆘 Common Pitfalls

### Pitfall 1: Forgetting import

```dart
// ❌ Wrong - forgot import
var file = File('data.txt');  // Error!

// ✅ Correct
import 'dart:io';
var file = File('data.txt');  // OK
```

### Pitfall 2: Not checking existence

```dart
// ❌ Wrong - might throw
var contents = File('data.txt').readAsStringSync();

// ✅ Better
var file = File('data.txt');
if (file.existsSync()) {
  var contents = file.readAsStringSync();
}
```

### Pitfall 3: Blocking with sync methods

```dart
// ❌ Wrong - blocks in async function
Future<void> process() async {
  var contents = File('huge.txt').readAsStringSync();  // Blocks!
}

// ✅ Correct - use async version
Future<void> process() async {
  var contents = await File('huge.txt').readAsString();
}
```

## 📖 Additional Resources

- [Dart dart:io Library](https://api.dart.dev/stable/dart-io/dart-io-library.html)
- [Dart File Class](https://api.dart.dev/stable/dart-io/File-class.html)
- [Path Package](https://pub.dev/packages/path)

---

Ready? Start with **[Exercise 1: Reading Files](exercises/1-reading-files.md)**!
