# Exercise 1: Run My First Script

Welcome to your first exercise! In this exercise, you'll learn how to run a Dart script using the development environment.

## 🎯 Objective

Get familiar with running Dart scripts in the containerized development environment.

## 📋 What You'll Learn

- How to start the development environment
- How to run a Dart script using different methods
- How to verify your environment is working correctly

## 🚀 Steps

### Step 1: Start the Development Environment

First, make sure your development environment is running:

```bash
# From the repository root directory
make up
```

This will start the Docker containers with Dart installed. You should see Tilt starting up and building the containers.

### Step 2: Run the Hello World Script

Now let's run your first Dart script! We've provided a simple `hello.dart` script for you to test.

**Method 1: Using the Makefile (Recommended)**

```bash
make run-dart SCRIPT=scripts/hello.dart
```

You should see output similar to:

```
Hello from Dart!
Dart version: 3.x.x (stable)
Platform: linux
🎉 Your Dart environment is working correctly!
```

**Method 2: Using Docker Compose Directly**

```bash
docker compose exec dart-env dart run scripts/hello.dart
```

**Method 3: Inside the Container**

```bash
# Open a shell inside the container
make dart-shell

# Then run the script
dart run scripts/hello.dart

# Type 'exit' when you're done
exit
```

### Step 3: Understand What Happened

When you ran the script, here's what happened:

1. The command connected to the running Docker container
2. Dart compiled and executed the `hello.dart` file
3. The script printed messages to your terminal
4. The script displayed your Dart version to confirm everything works

### Step 4: Explore the Script

Let's look at what the `hello.dart` script does. You can view it with:

```bash
cat scripts/hello.dart
```

Notice how the script:
- Uses `print()` to display text to the screen
- Shows information about your Dart environment
- Uses string interpolation with `${}`
- Imports the `dart:io` library to access platform information

## ✅ Success Criteria

You've completed this exercise when:

- [ ] You can start the development environment with `make up`
- [ ] You can run the hello.dart script and see the output
- [ ] You understand at least one method for running Dart scripts
- [ ] You can see the Dart version in the output

## 🎉 Congratulations!

You've successfully run your first Dart script! You now know how to:
- Start the development environment
- Execute Dart scripts using the containers
- Verify your environment is working

## 🔜 Next Steps

Move on to **Exercise 2: Run My First REPL** to learn about interactive Dart programming!
