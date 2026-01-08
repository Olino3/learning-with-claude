# Tutorial 1: Getting Started with Ruby

Welcome to your first Ruby tutorial! This guide will help you set up your development environment and write your first Ruby programs.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Understand how to use the Ruby development environment
- Know how to run Ruby scripts
- Be comfortable using the interactive Ruby interpreter (IRB)
- Have written and executed your first Ruby programs

## 🚀 Setting Up Your Development Environment

This repository uses Docker and Tilt to provide a consistent Ruby development environment. You don't need to install Ruby on your local machine—everything runs in containers!

### Prerequisites

Before you begin, make sure you have:
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- [Tilt](https://docs.tilt.dev/install.html) installed (optional but recommended)

### Starting the Environment

You have two options for starting the development environment:

#### Option 1: Using Tilt (Recommended)

Tilt provides a nice UI and better development experience:

```bash
# From the repository root
tilt up
```

Or use the Makefile shortcut:

```bash
make up
```

Tilt will:
- Build the Docker containers
- Start the services
- Provide a web UI at http://localhost:10350
- Auto-reload when you change files

Press `space` to open the Tilt UI in your browser, or `ctrl+c` to stop.

#### Option 2: Using Docker Compose Directly

If you prefer not to use Tilt:

```bash
# Start in detached mode
docker-compose up -d

# Or use the Makefile
make up-docker
```

### Understanding the Containers

The development environment includes two containers:

1. **ruby-scripts**: For running Ruby scripts and applications
2. **ruby-repl**: For interactive Ruby experimentation with IRB

Both containers have:
- Ruby 3.3 installed
- Common gems (bundler, pry, irb, rspec, sinatra)
- Access to all your code via volume mounts
- Shared gem storage for efficiency

## 📝 Running Your First Ruby Script

Let's run the example "Hello World" script to verify everything works!

### Method 1: Using the Makefile

The easiest way to run a script:

```bash
make run-script SCRIPT=scripts/hello.rb
```

You should see output like:

```
Hello from Ruby!
Ruby version: 3.3.x
Platform: x86_64-linux
🎉 Your Ruby environment is working correctly!
```

### Method 2: Using Docker Compose

```bash
docker-compose exec ruby-scripts ruby scripts/hello.rb
```

### Method 3: Inside the Container

Open a bash shell in the container:

```bash
# Using the Makefile
make shell

# Or directly with docker-compose
docker-compose exec ruby-scripts bash
```

Then run the script:

```bash
ruby scripts/hello.rb
```

### Try the Basics Demo

Run a more comprehensive example that demonstrates Ruby features:

```bash
make run-script SCRIPT=scripts/demo_basics.rb
```

This script shows:
- Variables and string interpolation
- Arrays and their methods
- Hashes (key-value pairs)
- Loops and iteration
- Method definitions

## 🎮 Using the Interactive Ruby Interpreter (IRB)

IRB (Interactive Ruby) is a REPL (Read-Eval-Print Loop) that lets you experiment with Ruby code in real-time.

### Starting IRB

```bash
# Using the Makefile
make repl

# Or directly
docker-compose exec ruby-scripts irb
```

You'll see a prompt like:

```ruby
irb(main):001:0>
```

### Try These Examples

Type each line and press Enter to see the results:

```ruby
# Simple math
2 + 2

# String manipulation
"Hello".upcase

# Variables
name = "Alice"
"Hello, #{name}!"

# Arrays
fruits = ["apple", "banana", "orange"]
fruits.length
fruits.first
fruits.last

# Hashes
person = { name: "Bob", age: 30 }
person[:name]

# Methods
def greet(name)
  "Hello, #{name}!"
end

greet("Ruby Learner")

# Loops
5.times { |i| puts "Count: #{i}" }

# Exit IRB
exit
```

### IRB Tips

- Use the **up/down arrow keys** to navigate command history
- Type `exit` or press `Ctrl+D` to quit
- Use `_` to reference the last result
- Type `help` for more IRB commands

## ✍️ Writing Your First Ruby Script

Now let's create your own Ruby script!

### Step 1: Create a New Script

Create a new file called `my_first_script.rb` in the `ruby/tutorials/1-Getting-Started/` directory:

```ruby
#!/usr/bin/env ruby
# My First Ruby Script

# Print a greeting
puts "Hello! This is my first Ruby script."

# Variables
my_name = "Your Name Here"
favorite_color = "blue"

puts "My name is #{my_name}"
puts "My favorite color is #{favorite_color}"

# A simple calculation
age = 25
puts "In 5 years, I will be #{age + 5} years old"

# Working with arrays
hobbies = ["reading", "coding", "gaming"]
puts "\nMy hobbies:"
hobbies.each do |hobby|
  puts "  - #{hobby}"
end

# A simple method
def favorite_quote
  "The only way to do great work is to love what you do."
end

puts "\nFavorite quote: #{favorite_quote}"
```

### Step 2: Run Your Script

```bash
# From the repository root
make run-script SCRIPT=ruby/tutorials/1-Getting-Started/my_first_script.rb

# Or inside the container
make shell
ruby ruby/tutorials/1-Getting-Started/my_first_script.rb
```

### Step 3: Modify and Experiment

Try changing:
- The values of the variables
- Adding new hobbies to the array
- Creating a new method
- Adding more calculations

Each time you make a change, run the script again to see the results!

## 🧪 Practice Exercises

### Exercise 1: Personalized Greeting

Create a script called `greeting.rb` that:
1. Stores your name in a variable
2. Stores your city in another variable
3. Prints: "Hello! My name is [name] and I'm from [city]."

### Exercise 2: Simple Calculator

Create a script called `calculator.rb` that:
1. Defines two numbers
2. Calculates and prints their sum, difference, product, and quotient
3. Bonus: Use methods for each operation

### Exercise 3: Favorite Things

Create a script called `favorites.rb` that:
1. Creates an array of your favorite foods
2. Creates a hash with your favorite movie, book, and song
3. Prints them in a nicely formatted way

## 📚 What You Learned

Congratulations! You've completed the Getting Started tutorial. You now know:

✅ How to start and stop the development environment
✅ How to run Ruby scripts using the containers
✅ How to use IRB for interactive experimentation
✅ Basic Ruby syntax including variables, arrays, hashes, and methods
✅ How to create and run your own Ruby scripts

## 🔜 Next Steps

Now that you're comfortable with the development environment, you're ready to dive deeper into Ruby!

Check out the next tutorial: **2-Ruby-Basics** (coming soon)

## 💡 Tips for Learning

- **Experiment**: Don't be afraid to try things in IRB
- **Make mistakes**: Errors are learning opportunities
- **Practice daily**: Even 15 minutes a day builds skills
- **Read the code**: Look at the example scripts to see patterns
- **Ask questions**: Use comments in your code to document your thinking

## 🆘 Troubleshooting

### Containers won't start
```bash
# Check if containers are running
docker-compose ps

# View logs
make logs

# Rebuild containers
make build
```

### Script not found
Make sure you're running commands from the repository root directory.

### Permission errors
The containers run as root by default, so file permissions should not be an issue.

## 📖 Additional Resources

- [Official Ruby Documentation](https://www.ruby-lang.org/en/documentation/)
- [Ruby in 20 Minutes](https://www.ruby-lang.org/en/documentation/quickstart/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [Try Ruby in Browser](https://try.ruby-lang.org/)

---

Happy coding! 🎉 When you're ready, move on to the practice exercises or explore the `/scripts` directory for more examples.
