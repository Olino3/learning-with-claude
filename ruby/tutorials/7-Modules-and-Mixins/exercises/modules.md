# Exercise: Modules and Mixins

## Practice

```ruby
module Flyable
  def fly
    "#{@name} is flying!"
  end
end

class Bird
  include Flyable

  def initialize(name)
    @name = name
  end
end

bird = Bird.new("Eagle")
puts bird.fly
```

Run:
```bash
make run-script SCRIPT=ruby/tutorials/7-Modules-and-Mixins/exercises/modules_practice.rb
```

## 🎉 Tutorial 7 Complete!
