# Exercise 2: Run My First REPL

Welcome to your second exercise! In this exercise, you'll learn how to use the Dart REPL (Read-Eval-Print Loop) for experimenting with Dart code.

## 🎯 Objective

Learn how to use the interactive Dart REPL to experiment with Dart code in real-time.

## 📋 What You'll Learn

- What a REPL is and why it's useful
- How to start and use the Dart REPL
- Basic Dart commands you can try interactively
- How to experiment with code before writing scripts

## 🚀 Steps

### Step 1: Make Sure the Environment is Running

Ensure your development environment is up and running:

```bash
make up
```

### Step 2: Start the Interactive Dart REPL

Launch the Dart REPL using the Makefile command:

```bash
make dart-repl
```

Or use Docker Compose directly:

```bash
docker-compose exec dart-scripts dart repl
```

You should see a prompt like:

```
>>>
```

This prompt means the Dart REPL is ready for you to type Dart code!

### Step 3: Try Your First Commands

Type each of these commands one at a time and press Enter after each one. Watch what the REPL returns!

**Simple Math:**

```dart
2 + 2
5 * 3
10 / 2
10 ~/ 3  // Integer division
```

Notice how the REPL immediately shows you the result!

**Working with Text:**

```dart
'Hello, Dart!'
'Hello'.toUpperCase()
'WORLD'.toLowerCase()
```

**Variables:**

```dart
var name = 'Dart Learner'
name
'Hello, $name!'
```

### Step 4: Experiment with Different Dart Features

Now try some slightly more complex examples:

**Lists (Arrays):**

```dart
var fruits = ['apple', 'banana', 'orange']
fruits
fruits.length
fruits.first
fruits.last
fruits[1]
```

**Simple Loops:**

```dart
for (var i = 0; i < 3; i++) {
  print('Count: $i')
}
```

**Defining a Function:**

```dart
String greet(String name) {
  return 'Hello, $name! Welcome to Dart.';
}

greet('Learner')
greet('World')
```

**Arrow Functions (Short Syntax):**

```dart
int square(int x) => x * x
square(5)
square(10)
```

### Step 5: Understanding the REPL Workflow

Notice the pattern:
1. **Read**: REPL reads your Dart code
2. **Eval**: REPL evaluates (compiles and runs) the code
3. **Print**: REPL prints the result
4. **Loop**: REPL waits for your next command

This is why it's called a REPL (Read-Eval-Print Loop)!

### Step 6: Useful REPL Tips

**Type Inference:**

Dart's type inference works in the REPL:

```dart
var number = 42  // Inferred as int
var text = 'hello'  // Inferred as String
var items = [1, 2, 3]  // Inferred as List<int>
```

**Multiple Lines:**

You can write multi-line code. The REPL will wait for you to finish:

```dart
int calculate(int a, int b) {
  var sum = a + b;
  var difference = a - b;
  return sum * difference;
}

calculate(10, 3)
```

**Collections:**

```dart
var numbers = [1, 2, 3, 4, 5]
numbers.map((n) => n * 2).toList()
numbers.where((n) => n > 2).toList()
```

**Exiting the REPL:**

When you're done experimenting, exit the REPL by typing:

```dart
exit
```

Or press `Ctrl+D`

### Step 7: Practice Exercise

Try to accomplish this task in the REPL:

1. Create a variable called `myAge` and set it to any number
2. Calculate what your age will be in 10 years
3. Create a function called `futureAge` that takes a number of years and returns your future age
4. Test your function with different values

**Solution (try yourself first!):**

```dart
var myAge = 25
myAge + 10

int futureAge(int currentAge, int years) {
  return currentAge + years;
}

futureAge(myAge, 5)
futureAge(myAge, 10)
futureAge(myAge, 20)
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can start the Dart REPL using `make dart-repl`
- [ ] You can execute basic Dart commands in the REPL
- [ ] You understand that the REPL shows results immediately
- [ ] You can create variables and functions in the REPL
- [ ] You know how to exit the REPL

## 🎓 Key Takeaways

**When to Use the REPL:**
- Testing small pieces of code before adding them to scripts
- Learning new Dart features or methods
- Quick calculations or experiments
- Debugging: trying different approaches to solve a problem

**REPL vs Scripts:**
- **REPL**: Interactive, immediate feedback, great for learning and testing
- **Scripts**: Saved code, reusable, good for complete programs

## 🎉 Congratulations!

You now know how to use the Interactive Dart REPL! This is a powerful tool for:
- Learning Dart interactively
- Testing code snippets quickly
- Experimenting with new ideas
- Debugging problems

## 🔜 Next Steps

Now that you can run scripts AND use the REPL, you're ready to start learning Dart programming!

Continue with the main tutorial to learn more Dart concepts, or explore the example scripts in the `/scripts` directory.

## 💡 Pro Tips

- Use the REPL when you're unsure how something works
- Try ideas in the REPL before writing them in scripts
- Use the up/down arrow keys to repeat previous commands
- Don't be afraid to experiment—you can't break anything in the REPL!
- Dart's type system helps catch errors early, even in the REPL

Happy exploring! 🚀
