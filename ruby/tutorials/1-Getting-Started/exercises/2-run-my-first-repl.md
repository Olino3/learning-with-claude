# Exercise 2: Run My First REPL

Welcome to your second exercise! In this exercise, you'll learn how to use IRB (Interactive Ruby), which is a REPL (Read-Eval-Print Loop) for experimenting with Ruby code.

## 🎯 Objective

Learn how to use the interactive Ruby interpreter to experiment with Ruby code in real-time.

## 📋 What You'll Learn

- What a REPL is and why it's useful
- How to start and use IRB (Interactive Ruby)
- Basic Ruby commands you can try interactively
- How to experiment with code before writing scripts

## 🚀 Steps

### Step 1: Make Sure the Environment is Running

Ensure your development environment is up and running:

```bash
make up
```

### Step 2: Start the Interactive Ruby Interpreter (IRB)

Launch IRB using the Makefile command:

```bash
make repl
```

Or use Docker Compose directly:

```bash
docker compose exec ruby-env irb
```

You should see a prompt like:

```ruby
irb(main):001:0>
```

This prompt means IRB is ready for you to type Ruby code!

### Step 3: Try Your First Commands

Type each of these commands one at a time and press Enter after each one. Watch what IRB returns!

**Simple Math:**

```ruby
2 + 2
5 * 3
10 / 2
```

Notice how IRB immediately shows you the result!

**Working with Text:**

```ruby
"Hello, Ruby!"
"Hello".upcase
"WORLD".downcase
```

**Variables:**

```ruby
name = "Ruby Learner"
name
"Hello, #{name}!"
```

### Step 4: Experiment with Different Ruby Features

Now try some slightly more complex examples:

**Arrays (Lists):**

```ruby
fruits = ["apple", "banana", "orange"]
fruits
fruits.length
fruits.first
fruits.last
fruits[1]
```

**Simple Loops:**

```ruby
3.times { puts "Hello!" }
5.times { |i| puts "Count: #{i}" }
```

**Defining a Method:**

```ruby
def greet(name)
  "Hello, #{name}! Welcome to Ruby."
end

greet("Learner")
greet("World")
```

### Step 5: Understanding the REPL Workflow

Notice the pattern:
1. **Read**: IRB reads your Ruby code
2. **Eval**: IRB evaluates (runs) the code
3. **Print**: IRB prints the result
4. **Loop**: IRB waits for your next command

This is why it's called a REPL (Read-Eval-Print Loop)!

### Step 6: Useful IRB Tips

**Last Result:**

The special variable `_` holds the last result:

```ruby
10 + 5
_ * 2
```

**Multiple Lines:**

You can write multi-line code. IRB will wait for you to finish:

```ruby
def calculate(a, b)
  sum = a + b
  difference = a - b
  [sum, difference]
end

calculate(10, 3)
```

**Getting Help:**

```ruby
help
```

**Exiting IRB:**

When you're done experimenting, exit IRB by typing:

```ruby
exit
```

Or press `Ctrl+D`

### Step 7: Practice Exercise

Try to accomplish this task in IRB:

1. Create a variable called `my_age` and set it to any number
2. Calculate what your age will be in 10 years
3. Create a method called `future_age` that takes a number of years and returns your future age
4. Test your method with different values

**Solution (try yourself first!):**

```ruby
my_age = 25
my_age + 10

def future_age(current_age, years)
  current_age + years
end

future_age(my_age, 5)
future_age(my_age, 10)
future_age(my_age, 20)
```

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can start IRB using `make repl`
- [ ] You can execute basic Ruby commands in IRB
- [ ] You understand that IRB shows results immediately
- [ ] You can create variables and methods in IRB
- [ ] You know how to exit IRB

## 🎓 Key Takeaways

**When to Use IRB:**
- Testing small pieces of code before adding them to scripts
- Learning new Ruby features or methods
- Quick calculations or experiments
- Debugging: trying different approaches to solve a problem

**IRB vs Scripts:**
- **IRB**: Interactive, immediate feedback, great for learning and testing
- **Scripts**: Saved code, reusable, good for complete programs

## 🎉 Congratulations!

You now know how to use the Interactive Ruby interpreter! This is a powerful tool for:
- Learning Ruby interactively
- Testing code snippets quickly
- Experimenting with new ideas
- Debugging problems

## 🔜 Next Steps

Now that you can run scripts AND use the REPL, you're ready to start learning Ruby programming!

Continue with the main tutorial to learn more Ruby concepts, or explore the example scripts in the `/scripts` directory.

## 💡 Pro Tips

- Use IRB when you're unsure how something works
- Try ideas in IRB before writing them in scripts
- Use the up/down arrow keys to repeat previous commands
- Don't be afraid to experiment—you can't break anything in IRB!

Happy exploring! 🚀
