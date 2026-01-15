#!/usr/bin/env dart
// Tutorial 15: Code Generation and Annotations Practice

void main() {
  print("=" * 70);
  print("CODE GENERATION AND ANNOTATIONS PRACTICE");
  print("=" * 70);

  // Example 1: Built-in Annotations
  print("\nExample 1: Built-in Annotations");
  annotationsExample();

  // Example 2: Custom Annotations (definition only)
  print("\nExample 2: Custom Annotations");
  customAnnotationsExample();

  // Checkpoint
  print("\n" + "=" * 70);
  print("CHECKPOINT: Complete the following challenges");
  print("=" * 70);
  
  print("Note: Code generation requires build_runner and generators.");
  print("These challenges focus on understanding the concepts:");
  print("");
  print("TODO: Challenge 1 - Define custom validation annotations");
  print("TODO: Challenge 2 - Design a serializable class structure");
  print("TODO: Challenge 3 - Plan a code generator for ToString");
}

void annotationsExample() {
  var api = API();
  api.newMethod();
  // Uncomment to see deprecation warning:
  // api.oldMethod();
}

void customAnnotationsExample() {
  var input = UserInput(name: "Alice", email: "alice@example.com");
  print("Created user input: ${input.name}");
  
  print("\nNote: Custom annotations would be processed by a code generator");
  print("to create validation logic at build time.");
}

// Example of using built-in annotations
class API {
  void newMethod() {
    print("Using new API method");
  }
  
  @deprecated
  void oldMethod() {
    print("This method is deprecated");
  }
  
  @Deprecated('Use newMethod() instead')
  void legacyMethod() {
    print("Legacy method - use newMethod() instead");
  }
}

// Custom annotation definitions
class Validate {
  final String pattern;
  const Validate(this.pattern);
}

class Required {
  const Required();
}

class MaxLength {
  final int length;
  const MaxLength(this.length);
}

// Class using custom annotations
class UserInput {
  @Required()
  @MaxLength(100)
  final String name;
  
  @Required()
  @Validate(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
  final String email;
  
  @MaxLength(20)
  final String? phone;
  
  UserInput({
    required this.name,
    required this.email,
    this.phone,
  });
}

// Example of what generated code might look like
extension UserInputValidation on UserInput {
  List<String> validate() {
    var errors = <String>[];
    
    // Generated validation logic (conceptual)
    if (name.isEmpty) {
      errors.add('name is required');
    }
    if (name.length > 100) {
      errors.add('name exceeds max length');
    }
    if (email.isEmpty) {
      errors.add('email is required');
    }
    
    return errors;
  }
}
