# Exercise 1: Methods

Master Ruby method definitions and parameter types.

## 🚀 Quick Practice

```bash
make repl
```

```ruby
# Basic method
def greet(name)
  "Hello, #{name}!"
end

# Optional parameters
def greet_optional(name = "Guest")
  "Hello, #{name}!"
end

# Keyword arguments
def create_user(name:, email:, age: 18)
  { name: name, email: email, age: age }
end

# Splat operators
def sum(*numbers)
  numbers.reduce(0, :+)
end

# Try them!
greet("Alice")
greet_optional
create_user(name: "Bob", email: "bob@example.com")
sum(1, 2, 3, 4, 5)
```

Run practice:
```bash
make run-script SCRIPT=ruby/tutorials/4-Methods-and-Blocks/exercises/methods_practice.rb
```

Complete challenge:
```bash
ruby/tutorials/4-Methods-and-Blocks/exercises/methods_challenge.rb
```

## 🎉 Next: Exercise 2 - Blocks!
