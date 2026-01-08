# Tutorial 10: Ruby Idioms and Best Practices

Master idiomatic Ruby code!

## 📋 Learning Objectives

- Write idiomatic Ruby code
- Use Ruby conventions
- Follow the Ruby style guide
- Understand common patterns
- Write clean, readable Ruby

## 💎 Ruby Idioms

### 1. Use Symbols for Identifiers
```ruby
# ❌ Not idiomatic
user = { "name" => "Alice", "age" => 30 }

# ✅ Idiomatic
user = { name: "Alice", age: 30 }
```

### 2. Prefer Iterators Over Loops
```ruby
# ❌ Not idiomatic
for i in 0...5
  puts i
end

# ✅ Idiomatic
5.times { |i| puts i }
(0...5).each { |i| puts i }
```

### 3. Use Statement Modifiers
```ruby
# ❌ Verbose
if user.authenticated?
  show_dashboard
end

# ✅ Concise
show_dashboard if user.authenticated?
```

### 4. Leverage Truthiness
```ruby
# ❌ Explicit nil check
if value != nil
  do_something
end

# ✅ Idiomatic
if value
  do_something
end

# ✅ Even better for collections
if items.any?
  process_items
end
```

### 5. Use Safe Navigation
```ruby
# ❌ Nested nil checks
if user && user.profile && user.profile.email
  send_email(user.profile.email)
end

# ✅ Safe navigation
send_email(user&.profile&.email) if user&.profile&.email
```

### 6. Prefer Block Form for Open
```ruby
# ❌ Manual close
file = File.open("data.txt")
content = file.read
file.close

# ✅ Auto-closes
File.open("data.txt") do |file|
  content = file.read
end
```

### 7. Use Meaningful Method Names
```ruby
# ✅ Predicate methods end with ?
def valid?
  !errors.any?
end

# ✅ Dangerous methods end with !
def save!
  raise unless save
end
```

### 8. Method Chaining
```ruby
# ✅ Chain for clarity
users
  .select { |u| u.active? }
  .map { |u| u.email }
  .sort
  .uniq
```

### 9. Use Implicit Returns
```ruby
# ❌ Explicit return (unnecessary)
def add(a, b)
  return a + b
end

# ✅ Implicit return
def add(a, b)
  a + b
end
```

### 10. Prefer Single-line Blocks with {}
```ruby
# ✅ Single-line
numbers.map { |n| n * 2 }

# ✅ Multi-line
numbers.map do |n|
  result = n * 2
  result + 1
end
```

## 📝 Best Practices

1. **Use 2-space indentation**
2. **Keep methods short (< 10 lines)**
3. **Use descriptive variable names**
4. **Comment why, not what**
5. **Follow the Ruby Style Guide**
6. **Write tests**
7. **Use gems for common tasks**
8. **Prefer composition over inheritance**
9. **Use modules for shared behavior**
10. **Keep it simple (KISS)**

## ✍️ Exercise

👉 **[Start Exercise: Ruby Idioms](exercises/idioms.md)**

## 📚 What You Learned

✅ Ruby conventions and idioms
✅ When to use symbols vs strings
✅ Prefer iterators over loops
✅ Statement modifiers for clarity
✅ Method chaining patterns
✅ Ruby style guide basics

## 🎉 Congratulations!

You've completed all 10 Ruby tutorials! You're now ready to write idiomatic Ruby code.

## 🔜 Next Steps

- Build projects in Ruby
- Explore Ruby gems
- Read open-source Ruby code
- Practice on Exercism or LeetCode
- Learn Rails or other Ruby frameworks

## 📖 Resources

- [Ruby Style Guide](https://rubystyle.guide/)
- [Ruby Documentation](https://ruby-doc.org/)
- [RubyGems](https://rubygems.org/)
- [Exercism Ruby Track](https://exercism.org/tracks/ruby)

---

**Congratulations on completing the Ruby Beginner Tutorials!** 🎉
