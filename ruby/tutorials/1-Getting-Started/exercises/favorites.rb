#!/usr/bin/env ruby
# Exercise 3: Favorite Things
# Create a script that stores and displays your favorite things

# TODO: Create an array of your favorite foods
favorite_foods = ["pizza", "sushi", "chocolate"]

# TODO: Create a hash with your favorite movie, book, and song
favorites = {
  movie: "The Matrix",
  book: "1984",
  song: "Bohemian Rhapsody"
}

# TODO: Print them in a nicely formatted way
puts "=" * 40
puts "My Favorite Things"
puts "=" * 40
puts ""

puts "🍕 Favorite Foods:"
favorite_foods.each_with_index do |food, index|
  puts "  #{index + 1}. #{food}"
end
puts ""

puts "🎬 Favorite Movie: #{favorites[:movie]}"
puts "📚 Favorite Book: #{favorites[:book]}"
puts "🎵 Favorite Song: #{favorites[:song]}"
puts ""

puts "=" * 40
