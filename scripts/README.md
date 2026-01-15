# Scripts

This directory contains example Ruby and Dart scripts for testing and learning.

## Available Scripts

### `hello.rb`
A simple "Hello World" Ruby script that verifies your Ruby environment is working correctly.

**Usage:**
```bash
# In the ruby-env container
ruby scripts/hello.rb
```

### `demo_basics.rb`
Demonstrates fundamental Ruby concepts including:
- Variables and string interpolation
- Arrays and array methods
- Hashes (Ruby's key-value data structure)
- Iteration and loops
- Method definitions

**Usage:**
```bash
# In the ruby-env container
ruby scripts/demo_basics.rb
```

### `hello.dart`
A simple "Hello World" Dart script that verifies your Dart environment is working correctly.

**Usage:**
```bash
# In the dart-env container
dart run scripts/hello.dart
```

## Running Scripts

There are several ways to run these scripts:

### Ruby Scripts

#### 1. Using Docker Compose directly:
```bash
docker compose exec ruby-env ruby scripts/hello.rb
```

#### 2. Inside the container:
```bash
docker compose exec ruby-env bash
ruby scripts/hello.rb
```

### Dart Scripts

#### 1. Using Docker Compose directly:
```bash
docker compose exec dart-env dart run scripts/hello.dart
```

#### 2. Inside the container:
```bash
docker compose exec dart-env bash
dart run scripts/hello.dart
```

### 3. Using Tilt:
Start Tilt and then exec into the container from your terminal or use the Tilt UI.

## Creating Your Own Scripts

### Ruby Scripts
1. Create a new `.rb` file in this directory
2. Add the shebang line: `#!/usr/bin/env ruby`
3. Write your Ruby code
4. Run it using `make run-script SCRIPT=scripts/your-script.rb`

### Dart Scripts
1. Create a new `.dart` file in this directory
2. Write your Dart code with a `main()` function
3. Run it using `make run-dart SCRIPT=scripts/your-script.dart`

Happy coding! 🚀
