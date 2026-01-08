#!/usr/bin/env ruby
# Loops and Iterators Challenge

puts "=== Loops and Iterators Challenge ==="
puts

# Challenge 1: Convert While to Iterator
puts "Challenge 1: Refactor to Use Iterators"
puts "-" * 40

# TODO: Rewrite this using .times instead of while
# i = 0
# while i < 10
#   puts i
#   i += 1
# end

# Your iterator version:

puts

# Challenge 2: Array Transformation
puts "Challenge 2: Transform and Filter"
puts "-" * 40

def process_numbers(numbers)
  # TODO: Return array of numbers that are:
  # 1. Greater than 5
  # 2. Multiplied by 3
  # 3. Sorted in descending order
  # Use method chaining with select, map, and sort

  # Your code here:

end

# Test (uncomment):
# p process_numbers([1, 5, 8, 3, 12, 6, 9])  # => [36, 27, 24, 18]
puts

# Challenge 3: FizzBuzz with Iterators
puts "Challenge 3: FizzBuzz the Ruby Way"
puts "-" * 40

def fizzbuzz(n)
  # TODO: Print FizzBuzz from 1 to n using .times or .upto
  # Use case/when or if/elsif for the logic

  # Your code here:

end

# Test (uncomment):
# fizzbuzz(20)
puts

# Challenge 4: Sum of Squares
puts "Challenge 4: Calculate Sum of Squares"
puts "-" * 40

def sum_of_squares(numbers)
  # TODO: Calculate sum of squares for numbers > 3
  # Example: [1, 2, 3, 4, 5] => 4² + 5² = 41
  # Use select, map, and reduce

  # Your code here:

end

# Test (uncomment):
# puts sum_of_squares([1, 2, 3, 4, 5])  # => 41
puts

# Challenge 5: Word Processing
puts "Challenge 5: Text Analysis"
puts "-" * 40

def analyze_words(text)
  # TODO: Return hash with:
  # - :total_words
  # - :long_words (length > 5)
  # - :capitalized_words
  # Use split, select, and count

  # Your code here:

end

# Test (uncomment):
# text = "The Quick Brown Fox Jumps Over The Lazy Dog"
# p analyze_words(text)
puts

puts "=== Solutions ==="
puts "Check: ruby/tutorials/3-Control-Flow/exercises/loops_solution.rb"
