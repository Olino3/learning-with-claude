# Exercise 3: Null Safety Challenges

Apply all null safety concepts.

## 🎯 Challenge: Safe Data Parser

**Create:** `/home/user/learning-with-claude/dart/tutorials/7-Null-Safety/exercises/data_parser.dart`

```dart
void main() {
  var data = {
    "name": "Alice",
    "age": "30",
    "scores": "95,87,92"
  };

  var parser = DataParser(data);
  parser.parse();

  var invalidData = {
    "name": "Bob",
    "age": "invalid",
  };

  var parser2 = DataParser(invalidData);
  parser2.parse();
}

class DataParser {
  Map<String, String> data;

  DataParser(this.data);

  void parse() {
    print("\nParsing data:");

    var name = getName();
    print("Name: ${name ?? 'Unknown'}");

    var age = getAge();
    print("Age: ${age ?? 'Invalid'}");

    var scores = getScores();
    if (scores != null && scores.isNotEmpty) {
      var avg = scores.reduce((a, b) => a + b) / scores.length;
      print("Average score: ${avg.toStringAsFixed(1)}");
    } else {
      print("No scores available");
    }
  }

  String? getName() {
    return data["name"];
  }

  int? getAge() {
    var ageStr = data["age"];
    if (ageStr == null) return null;

    return int.tryParse(ageStr);
  }

  List<int>? getScores() {
    var scoresStr = data["scores"];
    if (scoresStr == null || scoresStr.isEmpty) return null;

    var parts = scoresStr.split(',');
    var scores = <int>[];

    for (var part in parts) {
      var score = int.tryParse(part.trim());
      if (score != null) {
        scores.add(score);
      }
    }

    return scores.isEmpty ? null : scores;
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/7-Null-Safety/exercises/data_parser.dart`

## 🎯 Challenge 2: Validation

Create a validator with null safety:

```dart
class Validator {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    if (!email.contains("@")) {
      return "Invalid email format";
    }
    return null;  // null = valid
  }

  static String? validateAge(int? age) {
    if (age == null) return "Age is required";
    if (age < 0 || age > 120) return "Invalid age";
    return null;
  }
}

// Test
print(Validator.validateEmail("test@example.com"));  // null (valid)
print(Validator.validateEmail("invalid"));           // "Invalid email format"
print(Validator.validateAge(25));                    // null (valid)
print(Validator.validateAge(-5));                    // "Invalid age"
```

## ✅ Success Criteria

- [ ] Completed data parser
- [ ] Handle null values safely
- [ ] Use all null operators appropriately
- [ ] Proper error handling with null

🎉 Congratulations! Ready for **Tutorial 8: Error Handling**!
