# Lab 1: Ruby Basics & Object-Oriented Programming

Build a simple book library system to learn Ruby's core object-oriented features.

## 🎯 Learning Objectives

By the end of this lab, you'll understand:

- How to define classes and create objects
- Instance variables and methods
- Class variables and class methods
- Basic inheritance
- Ruby's string interpolation
- Method chaining basics

## � Running the Lab

### Step-by-Step Learning (Recommended)

Follow the progressive steps in this README to build the book library system incrementally. Each step builds on the previous one.

**Estimated Time**: 1-2 hours

### Quick Start with Make

Run the starter code:
```bash
make beginner-lab NUM=1
```

This runs `starter.rb` which provides a template to start coding.

### Run the Solution

To see the complete working solution:
```bash
# View the solution file
cat ruby/labs/beginner/lab1-basics/solution.rb

# Or run it directly
make run-script SCRIPT=ruby/labs/beginner/lab1-basics/solution.rb
```

### How to Practice

1. **Read each step** in this README
2. **Write the code** in `starter.rb` (or create your own file)
3. **Test your code** by running `make beginner-lab NUM=1`
4. **Compare with solution** in `solution.rb` if you get stuck

---

## �📋 What You'll Build

A book library system with:

- `Book` class to represent individual books
- `Library` class to manage a collection of books
- Ability to add, remove, and search for books
- Statistics about the library

## 🚀 Progressive Steps

### Step 1: Create the Book Class

Let's start by creating a `Book` class with basic attributes.

**Task**: Create a `Book` class with a title, author, and ISBN.

```ruby
class Book
  # Create getter and setter methods for title, author, and isbn
  attr_accessor :title, :author, :isbn

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
  end
end
```

**Test it**:

```ruby
book = Book.new("The Ruby Way", "Hal Fulton", "978-0321714633")
puts book.title  # => "The Ruby Way"
puts book.author # => "Hal Fulton"
```

**🐍 Python Equivalent**:

```python
class Book:
    def __init__(self, title, author, isbn):
        self.title = title
        self.author = author
        self.isbn = isbn
```

---

### Step 2: Add a String Representation

Make books display nicely when printed.

**Task**: Add a `to_s` method (equivalent to Python's `__str__`).

```ruby
class Book
  attr_accessor :title, :author, :isbn

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
  end

  # Add this method
  def to_s
    "\"#{@title}\" by #{@author} (ISBN: #{@isbn})"
  end
end
```

**Test it**:

```ruby
book = Book.new("The Ruby Way", "Hal Fulton", "978-0321714633")
puts book  # => "The Ruby Way" by Hal Fulton (ISBN: 978-0321714633)
```

**💡 Ruby Notes**:

- `to_s` is automatically called when printing an object
- String interpolation with `#{}` is Ruby's way of formatting strings
- Use `""` for interpolation (not `''`)

---

### Step 3: Add Instance Methods

Add methods that operate on individual book instances.

**Task**: Add methods to check if a book matches a search term.

```ruby
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

  # Add these methods
  def matches_title?(search_term)
    @title.downcase.include?(search_term.downcase)
  end

  def matches_author?(search_term)
    @author.downcase.include?(search_term.downcase)
  end
end
```

**Test it**:

```ruby
book = Book.new("The Ruby Way", "Hal Fulton", "978-0321714633")
puts book.matches_title?("ruby")    # => true
puts book.matches_author?("fulton") # => true
puts book.matches_title?("python")  # => false
```

---

### Step 4: Create the Library Class

Now let's create a `Library` class to manage multiple books.

**Task**: Create a `Library` class with an array of books.

```ruby
class Library
  attr_reader :name, :books

  def initialize(name)
    @name = name
    @books = []
  end

  def add_book(book)
    @books << book
    puts "Added: #{book}"
  end

  def book_count
    @books.length
  end
end
```

**Test it**:

```ruby
library = Library.new("City Central Library")
book1 = Book.new("The Ruby Way", "Hal Fulton", "978-0321714633")
book2 = Book.new("Eloquent Ruby", "Russ Olsen", "978-0321584106")

library.add_book(book1)
library.add_book(book2)
puts "Total books: #{library.book_count}"  # => Total books: 2
```

**💡 Ruby Notes**:

- `attr_reader` creates only getter methods (read-only)
- `<<` is the array append operator (like Python's `append()`)
- Arrays start empty and grow dynamically

---

### Step 5: Add Search Functionality

Implement methods to search the library.

**Task**: Add search methods to the `Library` class.

```ruby
class Library
  attr_reader :name, :books

  def initialize(name)
    @name = name
    @books = []
  end

  def add_book(book)
    @books << book
    puts "Added: #{book}"
  end

  def book_count
    @books.length
  end

  # Add these methods
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
        puts "#{index + 1}. #{book}"
      end
    end
  end
end
```

**Test it**:

```ruby
library = Library.new("City Central Library")
library.add_book(Book.new("The Ruby Way", "Hal Fulton", "978-0321714633"))
library.add_book(Book.new("Eloquent Ruby", "Russ Olsen", "978-0321584106"))

library.list_all_books

results = library.find_by_title("ruby")
puts "\nFound #{results.length} books with 'ruby' in title:"
results.each { |book| puts "  - #{book}" }
```

**💡 Ruby Notes**:

- `select` filters an array (like Python's list comprehension with `if`)
- Blocks `{ |item| ... }` are like Python's lambda functions
- `each_with_index` is like Python's `enumerate()`

---

### Step 6: Add Class Methods and Statistics

Add class-level methods and statistics tracking.

**Task**: Add class methods to track all libraries and provide statistics.

```ruby
class Library
  attr_reader :name, :books

  # Class variable to track all libraries
  @@all_libraries = []

  def initialize(name)
    @name = name
    @books = []
    @@all_libraries << self
  end

  # Class method to get all libraries
  def self.all
    @@all_libraries
  end

  # Class method to get total books across all libraries
  def self.total_books
    @@all_libraries.sum { |library| library.book_count }
  end

  def add_book(book)
    @books << book
    puts "Added: #{book}"
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
        puts "#{index + 1}. #{book}"
      end
    end
  end

  def statistics
    puts "\n#{@name} Statistics:"
    puts "  Total books: #{book_count}"
    puts "  Unique authors: #{@books.map(&:author).uniq.length}"
  end
end
```

**Test it**:

```ruby
lib1 = Library.new("City Central")
lib1.add_book(Book.new("The Ruby Way", "Hal Fulton", "978-0321714633"))
lib1.add_book(Book.new("Eloquent Ruby", "Russ Olsen", "978-0321584106"))

lib2 = Library.new("University Library")
lib2.add_book(Book.new("Programming Ruby", "Dave Thomas", "978-1934356081"))

puts "Total libraries: #{Library.all.length}"
puts "Total books across all libraries: #{Library.total_books}"

lib1.statistics
```

**💡 Ruby Notes**:

- `@@variable` is a class variable (shared across all instances)
- `self.method_name` defines a class method (like Python's `@classmethod`)
- `map(&:method)` is shorthand for `map { |item| item.method }`
- `uniq` removes duplicates (like Python's `set()`)

---

## 🎯 Final Challenge

Now put it all together! Create a complete working program.

**Task**: Write a program that:

1. Creates two libraries
2. Adds at least 3 books to each library
3. Lists all books in each library
4. Searches for books by title and author
5. Displays statistics for each library
6. Shows total books across all libraries

**Starter Code**: See `starter.rb`

**Solution**: See `solution.rb` (try yourself first!)

---

## ✅ Checklist

Before moving to Lab 2, make sure you understand:

- [ ] How to define a class with `class ClassName`
- [ ] How `initialize` works (constructor)
- [ ] The difference between `@instance` and `@@class` variables
- [ ] How `attr_accessor`, `attr_reader`, and `attr_writer` work
- [ ] Instance methods vs class methods (`self.method_name`)
- [ ] String interpolation with `"#{expression}"`
- [ ] Basic array methods: `<<`, `length`, `select`, `each`
- [ ] Blocks: `{ |param| code }` vs `do |param| code end`

---

## 🐍 Python Comparison Summary

| Ruby | Python |
|------|--------|
| `initialize` | `__init__` |
| `to_s` | `__str__` |
| `attr_accessor :name` | `@property` + setter |
| `@@class_var` | Class variable |
| `self.class_method` | `@classmethod` |
| `array << item` | `list.append(item)` |
| `{ \|x\| x * 2 }` | `lambda x: x * 2` |
| `array.select` | list comprehension with `if` |
| `array.map` | list comprehension or `map()` |

---

**Great job!** You've learned Ruby's OOP basics. Ready for Lab 2? → [Collections & Iteration](../lab2-collections/README.md)
