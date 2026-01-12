# Lab 1: Ruby Basics & Object-Oriented Programming
# Starter Code - Complete the TODOs

# TODO: Step 1 - Define the Book class with attr_accessor
class Book
  # Add attr_accessor for title, author, isbn

  def initialize(title, author, isbn)
    # Initialize instance variables
  end

  # TODO: Step 2 - Add to_s method
  def to_s
    # Return a formatted string representation
  end

  # TODO: Step 3 - Add search methods
  def matches_title?(search_term)
    # Check if title contains search_term (case-insensitive)
  end

  def matches_author?(search_term)
    # Check if author contains search_term (case-insensitive)
  end
end

# TODO: Step 4 - Define the Library class
class Library
  # Add attr_reader for name and books

  # TODO: Step 6 - Add class variable to track all libraries
  # @@all_libraries = []

  def initialize(name)
    # Initialize instance variables
    # Add self to @@all_libraries
  end

  # TODO: Step 6 - Add class methods
  # def self.all
  # end

  # def self.total_books
  # end

  # TODO: Step 4 - Add instance methods
  def add_book(book)
    # Add book to @books array
    # Print confirmation message
  end

  def book_count
    # Return the number of books
  end

  # TODO: Step 5 - Add search methods
  def find_by_title(search_term)
    # Return array of books matching title
  end

  def find_by_author(search_term)
    # Return array of books matching author
  end

  def list_all_books
    # List all books or print "empty" message
  end

  # TODO: Step 6 - Add statistics method
  def statistics
    # Print statistics about the library
  end
end

# Main program - Complete this after implementing the classes
puts "=" * 50
puts "LIBRARY MANAGEMENT SYSTEM"
puts "=" * 50

# Create first library
lib1 = Library.new("City Central Library")

# Add books to first library
# TODO: Add at least 3 books

# Create second library
lib2 = Library.new("University Library")

# Add books to second library
# TODO: Add at least 3 books

# List all books in each library
# TODO: Call list_all_books on each library

# Search for books
puts "\n" + "=" * 50
puts "SEARCH RESULTS"
puts "=" * 50

# TODO: Search for books by title in lib1

# TODO: Search for books by author in lib2

# Display statistics
puts "\n" + "=" * 50
puts "STATISTICS"
puts "=" * 50

# TODO: Display statistics for each library

# TODO: Display total books across all libraries
