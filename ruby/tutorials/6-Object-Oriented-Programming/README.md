# Tutorial 6: Object-Oriented Programming

Master Ruby's elegant OOP features!

## 📋 Learning Objectives

- Define classes and create objects
- Use instance and class variables
- Implement inheritance
- Understand attr_accessor, attr_reader, attr_writer
- Work with class methods and self

## 🐍➡️🔴 Coming from Python

| Concept | Python | Ruby |
|---------|--------|------|
| Define class | `class MyClass:` | `class MyClass` `end` |
| Constructor | `def __init__(self):` | `def initialize` |
| Instance var | `self.name = x` | `@name = x` |
| Class var | `MyClass.count = 0` | `@@count = 0` |
| Inheritance | `class B(A):` | `class B < A` |
| Super | `super().__init__()` | `super` |
| Private method | `def __method():` | `private` |

## 📝 Classes and Objects

```ruby
# Basic class
class Person
  def initialize(name, age)
    @name = name  # Instance variable
    @age = age
  end

  def greet
    "Hello, I'm #{@name}, #{@age} years old"
  end
end

# Create instance
person = Person.new("Alice", 30)
puts person.greet

# Attribute accessors (getters/setters)
class Person
  attr_reader :name      # Getter only
  attr_writer :age       # Setter only
  attr_accessor :email   # Both getter and setter

  def initialize(name, age)
    @name = name
    @age = age
  end
end

person = Person.new("Alice", 30)
puts person.name           # Getter
person.email = "alice@example.com"  # Setter
puts person.email

# Class methods and variables
class User
  @@count = 0  # Class variable

  def initialize(name)
    @name = name
    @@count += 1
  end

  def self.count  # Class method
    @@count
  end
end

User.new("Alice")
User.new("Bob")
puts User.count  # => 2

# Inheritance
class Employee < Person
  attr_accessor :employee_id

  def initialize(name, age, employee_id)
    super(name, age)
    @employee_id = employee_id
  end

  def greet
    "#{super}, ID: #{@employee_id}"
  end
end

emp = Employee.new("Alice", 30, "E123")
puts emp.greet
```

> **📘 Python Note:**
> - `initialize` is like `__init__`
> - `@var` is like `self.var`
> - `@@var` is class variable
> - `attr_accessor` creates getters/setters automatically
> - Inheritance uses `<` instead of parentheses

## ✍️ Exercise

👉 **[Start Exercise: OOP](exercises/oop.md)**

## 📚 What You Learned

✅ Classes and objects
✅ Instance variables (@var)
✅ Class variables (@@var)
✅ Attribute accessors
✅ Inheritance with super
✅ Class methods (self.method_name)

## 🔜 Next: Tutorial 7 - Modules and Mixins
