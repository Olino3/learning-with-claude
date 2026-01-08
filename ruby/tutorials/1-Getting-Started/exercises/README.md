# Getting Started - Practice Exercises

This directory contains practice exercises to reinforce what you learned in the Getting Started tutorial.

## Exercises

### 1. greeting.rb
**Difficulty**: ⭐ Easy

Create a personalized greeting script.

**Requirements**:
- Store your name in a variable
- Store your city in another variable
- Print a greeting using both variables

**Run it**:
```bash
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/exercises/greeting.rb
```

---

### 2. calculator.rb
**Difficulty**: ⭐⭐ Medium

Build a simple calculator that performs basic arithmetic operations.

**Requirements**:
- Define two numbers
- Calculate and print sum, difference, product, and quotient
- **Bonus**: Create methods for each operation

**Run it**:
```bash
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/exercises/calculator.rb
```

---

### 3. favorites.rb
**Difficulty**: ⭐⭐ Medium

Create a script that displays your favorite things in a formatted way.

**Requirements**:
- Create an array of favorite foods
- Create a hash with favorite movie, book, and song
- Print everything in a nicely formatted layout

**Run it**:
```bash
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/exercises/favorites.rb
```

---

## Tips

- The provided solutions are examples—feel free to modify them!
- Try solving the exercises yourself before looking at the solutions
- Experiment with different formatting and output styles
- Use IRB to test small pieces of code before adding to your scripts

## Running Exercises

From the repository root:

```bash
# Run a specific exercise
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/exercises/greeting.rb

# Or open a shell and run multiple exercises
make shell
ruby ruby/tutorials/1-Getting-Started/exercises/greeting.rb
ruby ruby/tutorials/1-Getting-Started/exercises/calculator.rb
ruby ruby/tutorials/1-Getting-Started/exercises/favorites.rb
```

## Challenge Yourself

Once you've completed these exercises, try:

1. **Combining concepts**: Create a script that uses arrays, hashes, and methods together
2. **User input**: Research how to get user input with `gets.chomp` and make interactive scripts
3. **More complex logic**: Add conditional statements (if/else) to your scripts
4. **Refactoring**: Take your scripts and make them more efficient or readable

Happy coding! 🚀
