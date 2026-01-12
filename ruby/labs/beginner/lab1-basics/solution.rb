# Lab 1: Ruby Basics & Object-Oriented Programming
# Complete Solution

class Book
  attr_accessor :title, :author, :isbn

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
  end

  def to_s
    "\"#{@title}\" by #{@author} (ISBN: #{@isbn})"
  end

  def matches_title?(search_term)
    @title.downcase.include?(search_term.downcase)
  end

  def matches_author?(search_term)
    @author.downcase.include?(search_term.downcase)
  end
end

class Library
  attr_reader :name, :books

  @@all_libraries = []

  def initialize(name)
    @name = name
    @books = []
    @@all_libraries << self
  end

  def self.all
    @@all_libraries
  end

  def self.total_books
    @@all_libraries.sum { |library| library.book_count }
  end

  def add_book(book)
    @books << book
    puts "✓ Added: #{book}"
  end

  def book_count
    @books.length
  end

  def find_by_title(search_term)
    @books.select { |book| book.matches_title?(search_term) }
  end

  def find_by_author(search_term)
    @books.select { |book| book.matches_author?(search_term) }
  end

  def list_all_books
    if @books.empty?
      puts "The library is empty."
    else
      puts "\n#{@name} - Books:"
      @books.each_with_index do |book, index|
        puts "  #{index + 1}. #{book}"
      end
    end
  end

  def statistics
    puts "\n#{@name} Statistics:"
    puts "  Total books: #{book_count}"
    puts "  Unique authors: #{@books.map(&:author).uniq.length}"
  end
end

# Main program
puts "=" * 60
puts " " * 15 + "LIBRARY MANAGEMENT SYSTEM"
puts "=" * 60

# Create first library
lib1 = Library.new("City Central Library")
puts "\nCreated: #{lib1.name}"

# Add books to first library
lib1.add_book(Book.new("The Ruby Way", "Hal Fulton", "978-0321714633"))
lib1.add_book(Book.new("Eloquent Ruby", "Russ Olsen", "978-0321584106"))
lib1.add_book(Book.new("Programming Ruby", "Dave Thomas", "978-1934356081"))

# Create second library
lib2 = Library.new("University Library")
puts "\nCreated: #{lib2.name}"

# Add books to second library
lib2.add_book(Book.new("Metaprogramming Ruby", "Paolo Perrotta", "978-1941222126"))
lib2.add_book(Book.new("Ruby Under a Microscope", "Pat Shaughnessy", "978-1593275273"))
lib2.add_book(Book.new("Confident Ruby", "Avdi Grimm", "978-0692040201"))
lib2.add_book(Book.new("Design Patterns in Ruby", "Russ Olsen", "978-0321490452"))

# List all books in each library
puts "\n" + "=" * 60
puts " " * 20 + "ALL BOOKS"
puts "=" * 60
lib1.list_all_books
lib2.list_all_books

# Search for books
puts "\n" + "=" * 60
puts " " * 18 + "SEARCH RESULTS"
puts "=" * 60

puts "\nSearching for books with 'Ruby' in title at #{lib1.name}:"
results = lib1.find_by_title("ruby")
if results.empty?
  puts "  No books found."
else
  results.each { |book| puts "  → #{book}" }
end

puts "\nSearching for books by 'Olsen' at #{lib2.name}:"
results = lib2.find_by_author("olsen")
if results.empty?
  puts "  No books found."
else
  results.each { |book| puts "  → #{book}" }
end

# Display statistics
puts "\n" + "=" * 60
puts " " * 22 + "STATISTICS"
puts "=" * 60
lib1.statistics
lib2.statistics

puts "\n" + "-" * 60
puts "Total libraries: #{Library.all.length}"
puts "Total books across all libraries: #{Library.total_books}"
puts "=" * 60
