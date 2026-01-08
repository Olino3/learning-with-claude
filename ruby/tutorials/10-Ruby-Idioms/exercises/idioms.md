# Exercise: Ruby Idioms

## Practice Idiomatic Ruby

```ruby
# ✅ Use symbols for hash keys
user = { name: "Alice", age: 30 }

# ✅ Use iterators
5.times { |i| puts i }

# ✅ Statement modifiers
puts "Hello" if condition

# ✅ Method chaining
result = [1, 2, 3, 4, 5]
  .select { |n| n.even? }
  .map { |n| n * 2 }

# ✅ Safe navigation
email = user&.profile&.email
```

Run:
```bash
make run-script SCRIPT=ruby/tutorials/10-Ruby-Idioms/exercises/idioms_practice.rb
```

## 🎉 All Tutorials Complete!

Congratulations on finishing the Ruby Beginner Tutorial series!
