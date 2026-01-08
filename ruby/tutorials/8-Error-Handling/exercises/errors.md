# Exercise: Error Handling

## Practice

```ruby
def safe_divide(a, b)
  begin
    a / b
  rescue ZeroDivisionError
    "Cannot divide by zero"
  end
end

puts safe_divide(10, 2)
puts safe_divide(10, 0)
```

Run:
```bash
make run-script SCRIPT=ruby/tutorials/8-Error-Handling/exercises/errors_practice.rb
```

## 🎉 Tutorial 8 Complete!
