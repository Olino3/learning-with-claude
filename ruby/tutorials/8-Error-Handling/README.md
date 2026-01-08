# Tutorial 8: Error Handling

Master Ruby's exception handling!

## 📋 Learning Objectives

- Catch exceptions with begin/rescue
- Raise exceptions
- Ensure cleanup with ensure
- Create custom exceptions
- Use retry for error recovery

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| Try/catch | `try:` `except:` | `begin` `rescue` `end` |
| Finally | `finally:` | `ensure` |
| Raise | `raise Exception()` | `raise StandardError` |
| Custom exception | `class E(Exception):` | `class E < StandardError` |

## 📝 Exception Handling

```ruby
# Basic rescue
begin
  result = 10 / 0
rescue ZeroDivisionError => e
  puts "Error: #{e.message}"
end

# Multiple rescue blocks
begin
  # code
rescue ArgumentError => e
  puts "Argument error: #{e}"
rescue StandardError => e
  puts "Standard error: #{e}"
end

# Ensure (always runs)
begin
  file = File.open("data.txt")
  # process file
rescue IOError => e
  puts "IO error: #{e}"
ensure
  file.close if file
end

# Raise exceptions
def divide(a, b)
  raise ArgumentError, "Divisor cannot be zero" if b == 0
  a / b
end

# Custom exceptions
class CustomError < StandardError
end

raise CustomError, "Something went wrong"

# Retry
attempts = 0
begin
  attempts += 1
  # risky operation
  raise "Failed" if attempts < 3
rescue => e
  retry if attempts < 3
  puts "Failed after 3 attempts"
end
```

> **📘 Python Note:**
> - `begin/rescue/ensure/end` is like `try/except/finally`
> - `rescue => e` captures exception
> - `retry` re-executes begin block (Python doesn't have this)
> - Create exceptions by inheriting from StandardError

## ✍️ Exercise

👉 **[Start Exercise: Error Handling](exercises/errors.md)**

## 📚 What You Learned

✅ begin/rescue/ensure/end
✅ Raising exceptions
✅ Custom exception classes
✅ retry for error recovery

## 🔜 Next: Tutorial 9 - File I/O
