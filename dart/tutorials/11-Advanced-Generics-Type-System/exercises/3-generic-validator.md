# Exercise 3: Generic Validation Framework

Build a type-safe validation framework for validating data.

## 📝 Requirements

Create a validation system with:

1. `Validator<T>` - Abstract class for validators
2. `ValidationResult<T>` - Sealed class for success/failure results
3. Built-in validators: `NotNull<T>`, `StringLength`, `NumberRange<T extends num>`
4. Ability to combine multiple validators

## 🎯 Example Usage

```dart
void main() {
  // String validation
  var nameValidator = StringLength(min: 2, max: 50);
  var result1 = nameValidator.validate('Alice');
  print(result1);  // Valid(Alice)
  
  var result2 = nameValidator.validate('A');
  print(result2);  // Invalid([Length must be between 2 and 50])
  
  // Number validation
  var ageValidator = NumberRange<int>(min: 0, max: 150);
  print(ageValidator.validate(30));   // Valid(30)
  print(ageValidator.validate(-5));   // Invalid([Value must be between 0 and 150])
  
  // Combined validators
  var combined = CombinedValidator<String>([
    NotNull<String>(),
    StringLength(min: 5),
  ]);
  
  print(combined.validate('Hello'));  // Valid(Hello)
  print(combined.validate('Hi'));     // Invalid([Length must be at least 5])
}
```

## 💡 Hints

- Use sealed classes for `ValidationResult<T>`
- Create `Valid<T>` and `Invalid<T>` subclasses
- Store error messages in a list
- Use type bounds where appropriate

## ✅ Solution

<details>
<summary>Click to reveal solution</summary>

```dart
// Result type
sealed class ValidationResult<T> {
  const ValidationResult();
}

class Valid<T> extends ValidationResult<T> {
  final T value;
  const Valid(this.value);
  
  @override
  String toString() => 'Valid($value)';
}

class Invalid<T> extends ValidationResult<T> {
  final List<String> errors;
  const Invalid(this.errors);
  
  @override
  String toString() => 'Invalid($errors)';
}

// Base validator
abstract class Validator<T> {
  ValidationResult<T> validate(T? value);
}

// Not null validator
class NotNull<T> extends Validator<T> {
  @override
  ValidationResult<T> validate(T? value) {
    if (value == null) {
      return Invalid(['Value cannot be null']);
    }
    return Valid(value);
  }
}

// String length validator
class StringLength extends Validator<String> {
  final int? min;
  final int? max;
  
  StringLength({this.min, this.max});
  
  @override
  ValidationResult<String> validate(String? value) {
    if (value == null) {
      return Invalid(['Value cannot be null']);
    }
    
    List<String> errors = [];
    
    if (min != null && value.length < min!) {
      errors.add('Length must be at least $min');
    }
    
    if (max != null && value.length > max!) {
      errors.add('Length must be at most $max');
    }
    
    if (min != null && max != null && errors.isEmpty) {
      // If both specified, provide combined message
      if (value.length < min! || value.length > max!) {
        errors.add('Length must be between $min and $max');
      }
    }
    
    return errors.isEmpty ? Valid(value) : Invalid(errors);
  }
}

// Number range validator
class NumberRange<T extends num> extends Validator<T> {
  final T? min;
  final T? max;
  
  NumberRange({this.min, this.max});
  
  @override
  ValidationResult<T> validate(T? value) {
    if (value == null) {
      return Invalid(['Value cannot be null']);
    }
    
    List<String> errors = [];
    
    if (min != null && value < min!) {
      errors.add('Value must be at least $min');
    }
    
    if (max != null && value > max!) {
      errors.add('Value must be at most $max');
    }
    
    if (min != null && max != null && errors.isEmpty) {
      if (value < min! || value > max!) {
        errors.add('Value must be between $min and $max');
      }
    }
    
    return errors.isEmpty ? Valid(value) : Invalid(errors);
  }
}

// Combined validator
class CombinedValidator<T> extends Validator<T> {
  final List<Validator<T>> validators;
  
  CombinedValidator(this.validators);
  
  @override
  ValidationResult<T> validate(T? value) {
    List<String> allErrors = [];
    
    for (var validator in validators) {
      var result = validator.validate(value);
      if (result is Invalid<T>) {
        allErrors.addAll(result.errors);
      }
    }
    
    return allErrors.isEmpty 
        ? Valid(value as T) 
        : Invalid(allErrors);
  }
}

void main() {
  // String validation
  print('=== String Validation ===');
  var nameValidator = StringLength(min: 2, max: 50);
  print(nameValidator.validate('Alice'));  // Valid
  print(nameValidator.validate('A'));      // Invalid
  
  // Number validation
  print('\n=== Number Validation ===');
  var ageValidator = NumberRange<int>(min: 0, max: 150);
  print(ageValidator.validate(30));   // Valid
  print(ageValidator.validate(-5));   // Invalid
  print(ageValidator.validate(200));  // Invalid
  
  // Combined validation
  print('\n=== Combined Validation ===');
  var combined = CombinedValidator<String>([
    NotNull<String>(),
    StringLength(min: 5),
  ]);
  
  print(combined.validate('Hello World'));  // Valid
  print(combined.validate('Hi'));           // Invalid
  print(combined.validate(null));           // Invalid
}
```

</details>

## 🚀 Bonus Challenges

1. Add a `RegexValidator` for pattern matching
2. Create an `EmailValidator` that validates email addresses
3. Add a `CustomValidator<T>` that takes a predicate function
4. Implement a `map` method to transform validated values
5. Add async validators for things like checking if a username exists
