# Exercise 1: Reading Files

Master file reading operations.

## 📝 Preparation

First, create a test file:

```bash
echo -e "Line 1\nLine 2\nLine 3\nLine 4\nLine 5" > /tmp/test_data.txt
```

## 🚀 Practice

```bash
make dart-repl
```

```dart
import 'dart:io';

// Read entire file
void readFile() {
  var file = File('/tmp/test_data.txt');

  if (file.existsSync()) {
    var contents = file.readAsStringSync();
    print(contents);
  }
}

// Read lines
void readLines() {
  var file = File('/tmp/test_data.txt');
  var lines = file.readAsLinesSync();

  for (var i = 0; i < lines.length; i++) {
    print("Line ${i + 1}: ${lines[i]}");
  }
}

// Async version
Future<void> readAsync() async {
  var file = File('/tmp/test_data.txt');
  var contents = await file.readAsString();
  print(contents);
}

readFile();
readLines();
await readAsync();
```

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/10-File-IO/exercises/file_reader.dart`

```dart
import 'dart:io';

void main() async {
  // Create test file
  var testFile = File('/tmp/sample.txt');
  await testFile.writeAsString("Hello\nWorld\nFrom\nDart\n");

  print("=== Read Entire File ===");
  await readEntireFile('/tmp/sample.txt');

  print("\n=== Read Lines ===");
  await readLines('/tmp/sample.txt');

  print("\n=== Count Lines and Words ===");
  await countLinesAndWords('/tmp/sample.txt');

  print("\n=== Search in File ===");
  await searchInFile('/tmp/sample.txt', 'World');
}

Future<void> readEntireFile(String path) async {
  var file = File(path);

  if (await file.exists()) {
    var contents = await file.readAsString();
    print(contents);
  } else {
    print("File not found: $path");
  }
}

Future<void> readLines(String path) async {
  var file = File(path);

  if (await file.exists()) {
    var lines = await file.readAsLines();

    for (var i = 0; i < lines.length; i++) {
      print("${i + 1}: ${lines[i]}");
    }
  }
}

Future<void> countLinesAndWords(String path) async {
  var file = File(path);

  if (await file.exists()) {
    var contents = await file.readAsString();

    var lines = contents.split('\n').where((l) => l.isNotEmpty).length;
    var words = contents.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    print("Lines: $lines");
    print("Words: $words");
    print("Characters: ${contents.length}");
  }
}

Future<void> searchInFile(String path, String searchTerm) async {
  var file = File(path);

  if (await file.exists()) {
    var lines = await file.readAsLines();

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains(searchTerm)) {
        print("Found '$searchTerm' at line ${i + 1}: ${lines[i]}");
      }
    }
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/10-File-IO/exercises/file_reader.dart`

## ✅ Success Criteria

- [ ] Can read entire file
- [ ] Can read lines
- [ ] Can process file contents
- [ ] Completed file reader
