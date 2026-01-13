# Exercise 3: Error Handling Challenges

Apply comprehensive error handling.

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/8-Error-Handling/exercises/file_processor.dart`

```dart
void main() {
  var processor = FileProcessor();

  processor.processFile("data.txt");
  processor.processFile("");
  processor.processFile("locked.txt");
}

class FileException implements Exception {
  final String message;
  FileException(this.message);

  @override
  String toString() => "FileException: $message";
}

class FileProcessor {
  void processFile(String filename) {
    print("\nProcessing: $filename");

    try {
      validateFilename(filename);
      openFile(filename);
      readFile(filename);
      print("Success: $filename processed");
    } on FileException catch (e) {
      print("File error: ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
    } finally {
      print("Cleanup for $filename");
    }
  }

  void validateFilename(String filename) {
    if (filename.isEmpty) {
      throw FileException("Filename cannot be empty");
    }
  }

  void openFile(String filename) {
    if (filename == "locked.txt") {
      throw FileException("File is locked");
    }
    print("File opened: $filename");
  }

  void readFile(String filename) {
    print("Reading file: $filename");
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/8-Error-Handling/exercises/file_processor.dart`

## ✅ Success Criteria

- [ ] Comprehensive error handling
- [ ] Custom exceptions
- [ ] Proper cleanup with finally

🎉 Ready for **Tutorial 9: Async Programming**!
