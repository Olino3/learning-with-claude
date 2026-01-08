# Exercise: File I/O

## Practice

```ruby
# Write to file
File.write("test.txt", "Hello, Ruby!")

# Read from file
content = File.read("test.txt")
puts content

# Process lines
File.open("test.txt") do |file|
  file.each_line do |line|
    puts line.upcase
  end
end
```

Run:
```bash
make run-script SCRIPT=ruby/tutorials/9-File-IO/exercises/fileio_practice.rb
```

## 🎉 Tutorial 9 Complete!
