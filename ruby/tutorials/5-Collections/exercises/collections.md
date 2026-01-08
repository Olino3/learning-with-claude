# Exercise: Collections

Master arrays and hashes!

## Practice

```bash
make repl
```

```ruby
# Arrays
numbers = [1, 2, 3, 4, 5]
numbers.map { |n| n * 2 }
numbers.select { |n| n.even? }
numbers.reduce(:+)

# Hashes
user = { name: "Alice", age: 30 }
user[:email] = "alice@example.com"
user.keys
user.values
user.each { |k, v| puts "#{k}: #{v}" }
```

Run practice:
```bash
make run-script SCRIPT=ruby/tutorials/5-Collections/exercises/collections_practice.rb
```

Complete challenge:
```bash
ruby/tutorials/5-Collections/exercises/collections_challenge.rb
```

## 🎉 Tutorial 5 Complete!
