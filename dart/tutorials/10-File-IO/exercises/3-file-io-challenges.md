# Exercise 3: File I/O Challenges

Apply all file I/O concepts.

## 📝 Script: `/home/user/learning-with-claude/dart/tutorials/10-File-IO/exercises/text_processor.dart`

```dart
import 'dart:io';

void main() async {
  // Create test file
  var inputFile = File('/tmp/input.txt');
  await inputFile.writeAsString("""
The quick brown fox jumps over the lazy dog.
Dart is a great programming language.
Learning Dart is fun and rewarding.
This is a test file with multiple lines.
  """.trim());

  print("=== Word Count ===");
  await wordCount('/tmp/input.txt');

  print("\n=== Find and Replace ===");
  await findAndReplace('/tmp/input.txt', 'Dart', 'Dart Programming');

  print("\n=== Sort Lines ===");
  await sortLines('/tmp/input.txt');

  print("\n=== Statistics ===");
  await fileStatistics('/tmp/input.txt');
}

Future<void> wordCount(String path) async {
  var file = File(path);

  if (await file.exists()) {
    var contents = await file.readAsString();

    var lines = contents.split('\n').where((l) => l.isNotEmpty).length;
    var words = contents.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    var chars = contents.length;

    print("Lines: $lines");
    print("Words: $words");
    print("Characters: $chars");
  }
}

Future<void> findAndReplace(String path, String find, String replace) async {
  var file = File(path);

  if (await file.exists()) {
    var contents = await file.readAsString();
    var modified = contents.replaceAll(find, replace);

    var outputFile = File('/tmp/replaced.txt');
    await outputFile.writeAsString(modified);

    print("Replaced '$find' with '$replace'");
    print("Output: ${outputFile.path}");

    // Show snippet
    var lines = modified.split('\n').take(2);
    print("Preview:");
    for (var line in lines) {
      print("  $line");
    }
  }
}

Future<void> sortLines(String path) async {
  var file = File(path);

  if (await file.exists()) {
    var lines = await file.readAsLines();
    var nonEmpty = lines.where((l) => l.trim().isNotEmpty).toList();

    nonEmpty.sort();

    var outputFile = File('/tmp/sorted.txt');
    await outputFile.writeAsString(nonEmpty.join('\n'));

    print("Sorted ${nonEmpty.length} lines");
    print("Output: ${outputFile.path}");
  }
}

Future<void> fileStatistics(String path) async {
  var file = File(path);

  if (await file.exists()) {
    var contents = await file.readAsString();
    var lines = contents.split('\n').where((l) => l.isNotEmpty);

    var wordCounts = <String, int>{};

    for (var line in lines) {
      var words = line
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(RegExp(r'\s+'));

      for (var word in words) {
        if (word.isNotEmpty) {
          wordCounts[word] = (wordCounts[word] ?? 0) + 1;
        }
      }
    }

    // Top 5 words
    var sorted = wordCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    print("Top 5 words:");
    for (var i = 0; i < 5 && i < sorted.length; i++) {
      print("  ${sorted[i].key}: ${sorted[i].value}");
    }

    // Save stats
    var statsFile = File('/tmp/stats.txt');
    var stats = StringBuffer();
    stats.writeln("File Statistics:");
    stats.writeln("Total unique words: ${wordCounts.length}");
    stats.writeln("\nWord frequencies:");
    for (var entry in sorted) {
      stats.writeln("${entry.key}: ${entry.value}");
    }

    await statsFile.writeAsString(stats.toString());
    print("\nStats saved to: ${statsFile.path}");
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/10-File-IO/exercises/text_processor.dart`

## 🎯 Additional Challenge: CSV Processor

Create a CSV processor:

```dart
import 'dart:io';

class CsvProcessor {
  Future<List<Map<String, String>>> read(String path) async {
    var file = File(path);
    var lines = await file.readAsLines();

    if (lines.isEmpty) return [];

    var headers = lines.first.split(',');
    var rows = <Map<String, String>>[];

    for (var i = 1; i < lines.length; i++) {
      var values = lines[i].split(',');
      var row = <String, String>{};

      for (var j = 0; j < headers.length && j < values.length; j++) {
        row[headers[j]] = values[j];
      }

      rows.add(row);
    }

    return rows;
  }

  Future<void> write(String path, List<Map<String, String>> data) async {
    if (data.isEmpty) return;

    var file = File(path);
    var buffer = StringBuffer();

    var headers = data.first.keys.toList();
    buffer.writeln(headers.join(','));

    for (var row in data) {
      var values = headers.map((h) => row[h] ?? '');
      buffer.writeln(values.join(','));
    }

    await file.writeAsString(buffer.toString());
  }
}

// Test
void main() async {
  var processor = CsvProcessor();

  var data = [
    {'name': 'Alice', 'age': '30', 'city': 'NYC'},
    {'name': 'Bob', 'age': '25', 'city': 'LA'},
    {'name': 'Charlie', 'age': '35', 'city': 'Chicago'},
  ];

  await processor.write('/tmp/people.csv', data);
  print("CSV written");

  var readData = await processor.read('/tmp/people.csv');
  print("Read ${readData.length} rows");

  for (var row in readData) {
    print(row);
  }
}
```

## ✅ Success Criteria

- [ ] Completed text processor
- [ ] Can process and analyze files
- [ ] Can transform file contents
- [ ] Completed CSV processor challenge

🎉 **Congratulations! You've completed all Dart tutorials!**

## 🎓 What's Next?

You now have comprehensive Dart knowledge! Consider:
1. Building real projects with Dart
2. Exploring Flutter for mobile apps
3. Learning Dart server frameworks (shelf, conduit)
4. Contributing to Dart packages

**Great job completing all 10 tutorials!**
