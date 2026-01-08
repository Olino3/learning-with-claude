# Tutorial 9: File I/O and String Processing

Master file operations and text processing!

## 📋 Learning Objectives

- Read and write files
- Process text line by line
- Use File and IO classes
- Work with paths
- Parse and format data

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| Read file | `open('f').read()` | `File.read('f')` |
| Write file | `open('f', 'w')` | `File.write('f', data)` |
| With block | `with open() as f:` | `File.open() { \|f\| }` |
| Read lines | `f.readlines()` | `f.readlines` |
| Check exists | `os.path.exists()` | `File.exist?()` |

## 📝 File Operations

```ruby
# Read entire file
content = File.read("file.txt")

# Write file
File.write("output.txt", "Hello, World!")

# Read with block (auto-closes)
File.open("file.txt", "r") do |file|
  content = file.read
  puts content
end

# Read line by line
File.foreach("file.txt") do |line|
  puts line
end

# Read all lines
lines = File.readlines("file.txt")

# Write with block
File.open("output.txt", "w") do |file|
  file.puts "Line 1"
  file.puts "Line 2"
end

# Append to file
File.open("log.txt", "a") do |file|
  file.puts "Log entry"
end

# Check file exists
if File.exist?("file.txt")
  puts "File exists"
end

# File info
puts File.size("file.txt")
puts File.mtime("file.txt")  # modification time
```

## ✍️ Exercise

👉 **[Start Exercise: File I/O](exercises/fileio.md)**

## 📚 What You Learned

✅ Read and write files
✅ File.open with blocks
✅ Line-by-line processing
✅ File existence and metadata

## 🔜 Next: Tutorial 10 - Ruby Idioms
