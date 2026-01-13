// My first Dart script
// This simple script demonstrates basic Dart syntax

void main() {
  // Print a welcome message
  print('Welcome to Dart programming!');

  // Variables
  var name = 'Dart Learner';
  var age = 25;

  // String interpolation
  print('Hello, $name!');
  print('You are $age years old.');

  // Basic arithmetic
  var nextYear = age + 1;
  print('Next year you will be $nextYear years old.');

  // Lists
  var languages = ['Dart', 'Python', 'JavaScript', 'Ruby'];
  print('\nYou are learning: $languages');
  print('First language: ${languages.first}');

  // Functions
  print('\nCalculating...');
  var sum = add(5, 3);
  print('5 + 3 = $sum');

  print('\n🎉 Congratulations on running your first Dart script!');
}

// A simple function
int add(int a, int b) {
  return a + b;
}
