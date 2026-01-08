# Exercise 2: Blocks, Procs, and Lambdas

Master Ruby's unique block feature!

## 🚀 Quick Practice

```ruby
# Blocks with each
[1, 2, 3].each { |n| puts n * 2 }

# Methods with yield
def my_method
  yield if block_given?
end

my_method { puts "Block!" }

# Procs
my_proc = Proc.new { |x| x * 2 }
my_proc.call(5)

# Lambdas
my_lambda = ->(x) { x * 2 }
my_lambda.call(5)
```

Run practice:
```bash
make run-script SCRIPT=ruby/tutorials/4-Methods-and-Blocks/exercises/blocks_practice.rb
```

## 🎉 Tutorial 4 Complete!
