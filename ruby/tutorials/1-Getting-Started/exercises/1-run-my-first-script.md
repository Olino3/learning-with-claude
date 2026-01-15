# Exercise 1: Run My First Script

Welcome to your first exercise! In this exercise, you'll learn how to run a Ruby script using the development environment.

## 🎯 Objective

Get familiar with running Ruby scripts in the containerized development environment.

## 📋 What You'll Learn

- How to start the development environment
- How to run a Ruby script using different methods
- How to verify your environment is working correctly

## 🚀 Steps

### Step 1: Start the Development Environment

First, make sure your development environment is running:

```bash
# From the repository root directory
make up
```

This will start the Docker containers with Ruby installed. You should see Tilt starting up and building the containers.

### Step 2: Run the Hello World Script

Now let's run your first Ruby script! We've provided a simple `hello.rb` script for you to test.

**Method 1: Using the Makefile (Recommended)**

```bash
make run-script SCRIPT=scripts/hello.rb
```

You should see output similar to:

```
Hello from Ruby!
Ruby version: 3.4.7
Platform: x86_64-linux
🎉 Your Ruby environment is working correctly!
```

**Method 2: Using Docker Compose Directly**

```bash
docker compose exec ruby-env ruby scripts/hello.rb
```

**Method 3: Inside the Container**

```bash
# Open a shell inside the container
make shell

# Then run the script
ruby scripts/hello.rb

# Type 'exit' when you're done
exit
```

### Step 3: Understand What Happened

When you ran the script, here's what happened:

1. The command connected to the running Docker container
2. Ruby interpreted and executed the `hello.rb` file
3. The script printed messages to your terminal
4. The script displayed your Ruby version to confirm everything works

### Step 4: Explore the Script

Let's look at what the `hello.rb` script does. You can view it with:

```bash
cat scripts/hello.rb
```

Notice how the script:
- Uses `puts` to print text to the screen
- Shows information about your Ruby environment
- Uses string interpolation with `#{}`

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can start the development environment with `make up`
- [ ] You can run the hello.rb script and see the output
- [ ] You understand at least one method for running Ruby scripts
- [ ] You can see the Ruby version (3.4.7) in the output

## 🎉 Congratulations!

You've successfully run your first Ruby script! You now know how to:
- Start the development environment
- Execute Ruby scripts using the containers
- Verify your environment is working

## 🔜 Next Steps

Move on to **Exercise 2: Run My First REPL** to learn about interactive Ruby programming!
