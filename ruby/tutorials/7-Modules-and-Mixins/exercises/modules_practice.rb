#!/usr/bin/env ruby
# Modules Practice

puts "=== Modules Practice ==="
puts

module Swimmable
  def swim
    "#{@name} is swimming"
  end
end

module Flyable
  def fly
    "#{@name} is flying"
  end
end

class Duck
  include Swimmable
  include Flyable

  def initialize(name)
    @name = name
  end
end

duck = Duck.new("Donald")
puts duck.swim
puts duck.fly

puts "\n=== Practice Complete ==="
