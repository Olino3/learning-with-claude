# Ruby Scripts

This directory contains example Ruby scripts for testing and learning.

## Available Scripts

### `hello.rb`
A simple "Hello World" script that verifies your Ruby environment is working correctly.

**Usage:**
```bash
# In the ruby-scripts container
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
# In the ruby-scripts container
ruby scripts/demo_basics.rb
```

## Running Scripts

There are several ways to run these scripts:

### 1. Using Docker Compose directly:
```bash
docker-compose exec ruby-scripts ruby scripts/hello.rb
```

### 2. Inside the container:
```bash
docker-compose exec ruby-scripts bash
ruby scripts/hello.rb
```

### 3. Using Tilt:
Start Tilt and then exec into the container from your terminal or use the Tilt UI.

## Creating Your Own Scripts

1. Create a new `.rb` file in this directory
2. Add the shebang line: `#!/usr/bin/env ruby`
3. Write your Ruby code
4. Run it using the methods above

Happy coding! 🚀
