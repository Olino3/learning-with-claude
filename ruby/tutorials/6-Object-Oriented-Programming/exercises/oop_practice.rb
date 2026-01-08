#!/usr/bin/env ruby
# OOP Practice

puts "=== OOP Practice ==="
puts

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def greet
    "Hello, I'm #{@name}, #{@age} years old"
  end
end

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

person = Person.new("Alice", 30)
puts person.greet

employee = Employee.new("Bob", 25, "E123")
puts employee.greet

puts "\n=== Practice Complete ==="
