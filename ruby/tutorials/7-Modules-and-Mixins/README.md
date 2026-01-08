# Tutorial 7: Modules and Mixins

Learn Ruby's powerful composition model!

## 📋 Learning Objectives

- Create and use modules
- Include modules in classes (mixins)
- Understand namespacing
- Use module methods
- Extend classes with modules

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| Module | `.py` file | `module` `end` |
| Import | `import module` | `include Module` |
| Mixin | Multiple inheritance | `include Module` |
| Namespace | `module.func()` | `Module::func` |

## 📝 Modules

```ruby
# Module as namespace
module Math
  PI = 3.14159

  def self.circle_area(radius)
    PI * radius ** 2
  end
end

puts Math::PI
puts Math.circle_area(5)

# Module as mixin
module Greetable
  def greet
    "Hello, I'm #{@name}"
  end
end

class Person
  include Greetable  # Add greet method to Person

  def initialize(name)
    @name = name
  end
end

person = Person.new("Alice")
puts person.greet

# Extend (adds to class, not instances)
module ClassMethods
  def total_count
    @@count
  end
end

class User
  extend ClassMethods
  @@count = 0
end

puts User.total_count
```

> **📘 Python Note:**
> - Modules are like Python's mix of modules and multiple inheritance
> - `include` adds instance methods
> - `extend` adds class methods
> - Mixins are Ruby's answer to multiple inheritance

## ✍️ Exercise

👉 **[Start Exercise: Modules](exercises/modules.md)**

## 📚 What You Learned

✅ Module creation and usage
✅ Mixins with include
✅ Namespacing with ::
✅ extend for class methods

## 🔜 Next: Tutorial 8 - Error Handling
