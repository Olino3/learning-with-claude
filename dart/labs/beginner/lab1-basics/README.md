# Lab 1: Dart Basics & Object-Oriented Programming

Build a simple book library system to learn Dart's core object-oriented features.

## 🎯 Learning Objectives

By the end of this lab, you'll understand:

- How to define classes and create objects in Dart
- Constructors and named parameters
- Getters and setters
- Null safety basics
- String interpolation
- Collections (Lists) and iteration
- Arrow functions and functional programming basics

## 🏃 Running the Lab

### Step-by-Step Learning (Recommended)

Follow the progressive steps in this README to build the book library system incrementally. Each step builds on the previous one.

**Estimated Time**: 1-2 hours

### Quick Start with Dart

Run the starter code:
```bash
# From repository root
dart run dart/labs/beginner/lab1-basics/starter.dart
```

Or using make:
```bash
make dart-shell
# Inside container:
dart run dart/labs/beginner/lab1-basics/starter.dart
```

### Run the Solution

To see the complete working solution:
```bash
# View the solution file
cat dart/labs/beginner/lab1-basics/solution.dart

# Run it
dart run dart/labs/beginner/lab1-basics/solution.dart
```

### How to Practice

1. **Read each step** in this README
2. **Write the code** in `starter.dart` (or create your own file)
3. **Test your code** by running it with `dart run`
4. **Compare with solution** in `solution.dart` if you get stuck

---

## 📚📋 What You'll Build

A book library system with:

- `Book` class to represent individual books
- `Library` class to manage a collection of books
- Ability to add and search for books
- Statistics about the library
- Null-safe code using Dart's type system

## 🚀 Progressive Steps

### Step 1: Create the Book Class

Let's start by creating a `Book` class with basic attributes.

**Task**: Create a `Book` class with title, author, and ISBN using Dart's constructor syntax.

```dart
class Book {
  // Instance variables with types
  String title;
  String author;
  String isbn;

  // Constructor with positional parameters
  Book(this.title, this.author, this.isbn);
}
```

**Test it**:

```dart
void main() {
  var book = Book("The Dart Way", "Kathy Walrath", "978-0321927705");
  print(book.title);  // => The Dart Way
  print(book.author); // => Kathy Walrath
}
```

**🐍 Python Equivalent**:

```python
class Book:
    def __init__(self, title, author, isbn):
        self.title = title
        self.author = author
        self.isbn = isbn
```

**💎 Ruby Equivalent**:

```ruby
class Book
  attr_accessor :title, :author, :isbn
  
  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
  end
end
```

**💡 Dart Notes**:

- Dart requires **explicit types** (unlike Python/Ruby)
- `Book(this.title, this.author, this.isbn)` is shorthand for assigning constructor parameters to instance variables
- No need for `self` or `@` prefix for instance variables in Dart

---

### Step 2: Add a String Representation

Make books display nicely when printed.

**Task**: Override the `toString` method (equivalent to Python's `__str__` or Ruby's `to_s`).

```dart
class Book {
  String title;
  String author;
  String isbn;

  Book(this.title, this.author, this.isbn);

  // Override toString for nice display
  @override
  String toString() {
    return '"$title" by $author (ISBN: $isbn)';
  }
}
```

**Test it**:

```dart
void main() {
  var book = Book("The Dart Way", "Kathy Walrath", "978-0321927705");
  print(book); // => "The Dart Way" by Kathy Walrath (ISBN: 978-0321927705)
}
```

**💡 Dart Notes**:

- `@override` annotation indicates you're overriding a parent class method
- String interpolation uses `$variable` or `${expression}`
- Use double quotes `""` or single quotes `''` (both work for interpolation)
- No escaping needed inside strings for double quotes when using single quotes

---

### Step 3: Add Instance Methods

Add methods that operate on individual book instances.

**Task**: Add methods to check if a book matches a search term.

```dart
class Book {
  String title;
  String author;
  String isbn;

  Book(this.title, this.author, this.isbn);

  @override
  String toString() {
    return '"$title" by $author (ISBN: $isbn)';
  }

  // Search methods with case-insensitive matching
  bool matchesTitle(String searchTerm) {
    return title.toLowerCase().contains(searchTerm.toLowerCase());
  }

  bool matchesAuthor(String searchTerm) {
    return author.toLowerCase().contains(searchTerm.toLowerCase());
  }
}
```

**Test it**:

```dart
void main() {
  var book = Book("The Dart Way", "Kathy Walrath", "978-0321927705");
  print(book.matchesTitle("dart"));    // => true
  print(book.matchesAuthor("walrath")); // => true
  print(book.matchesTitle("python"));   // => false
}
```

**🐍 Python Comparison**:

```python
# Python
def matches_title(self, search_term):
    return search_term.lower() in self.title.lower()
```

**💎 Ruby Comparison**:

```ruby
# Ruby uses ? suffix for predicate methods
def matches_title?(search_term)
  @title.downcase.include?(search_term.downcase)
end
```

**💡 Dart Notes**:

- Method names use `camelCase` (not `snake_case` like Python/Ruby)
- No `?` suffix convention for boolean methods (unlike Ruby)
- `bool` is the explicit return type
- `contains()` checks substring inclusion (like Python's `in` or Ruby's `include?`)

---

### Step 4: Create the Library Class

Now let's create a `Library` class to manage multiple books.

**Task**: Create a `Library` class with a list of books.

```dart
class Library {
  String name;
  List<Book> books; // Typed list of Book objects

  Library(this.name) : books = []; // Initialize books as empty list

  void addBook(Book book) {
    books.add(book);
    print('✓ Added: $book');
  }

  int get bookCount => books.length;
}
```

**Test it**:

```dart
void main() {
  var library = Library("City Central Library");
  var book1 = Book("The Dart Way", "Kathy Walrath", "978-0321927705");
  var book2 = Book("Dart in Action", "Chris Buckett", "978-1617290862");

  library.addBook(book1);
  library.addBook(book2);
  print('Total books: ${library.bookCount}'); // => Total books: 2
}
```

**💡 Dart Notes**:

- `List<Book>` is a **typed list** (only accepts Book objects)
- `: books = []` is an **initializer list** (runs before constructor body)
- `get bookCount =>` defines a **getter** with arrow syntax
- `void` explicitly states method returns nothing
- `add()` appends to list (like Python's `append()` or Ruby's `<<`)

**🐍 Python Comparison**:

```python
class Library:
    def __init__(self, name):
        self.name = name
        self.books = []  # Untyped list
```

**💎 Ruby Comparison**:

```ruby
class Library
  attr_reader :name, :books
  
  def initialize(name)
    @name = name
    @books = []
  end
end
```

---

### Step 5: Add Search Functionality

Implement methods to search the library.

**Task**: Add search methods and book listing to the `Library` class.

```dart
class Library {
  String name;
  List<Book> books;

  Library(this.name) : books = [];

  void addBook(Book book) {
    books.add(book);
    print('✓ Added: $book');
  }

  int get bookCount => books.length;

  // Search methods returning filtered lists
  List<Book> findByTitle(String searchTerm) {
    return books.where((book) => book.matchesTitle(searchTerm)).toList();
  }

  List<Book> findByAuthor(String searchTerm) {
    return books.where((book) => book.matchesAuthor(searchTerm)).toList();
  }

  void listAllBooks() {
    if (books.isEmpty) {
      print('The library is empty.');
    } else {
      print('\n$name - Books:');
      for (var i = 0; i < books.length; i++) {
        print('  ${i + 1}. ${books[i]}');
      }
    }
  }
}
```

**Test it**:

```dart
void main() {
  var library = Library("City Central Library");
  library.addBook(Book("The Dart Way", "Kathy Walrath", "978-0321927705"));
  library.addBook(Book("Dart in Action", "Chris Buckett", "978-1617290862"));

  library.listAllBooks();

  var results = library.findByTitle("dart");
  print('\nFound ${results.length} books with "dart" in title:');
  for (var book in results) {
    print('  → $book');
  }
}
```

**💡 Dart Notes**:

- `where()` filters a list (like Python's list comprehension or Ruby's `select`)
- `(book) => expression` is an **arrow function** (like lambda)
- `toList()` converts the Iterable back to a List
- `isEmpty` is a getter checking if list is empty
- `for (var i = 0; ...)` is traditional C-style loop
- `for (var book in books)` is enhanced for-each loop

**🐍 Python Comparison**:

```python
# Python list comprehension
def find_by_title(self, search_term):
    return [book for book in self.books if book.matches_title(search_term)]
```

**💎 Ruby Comparison**:

```ruby
# Ruby select with block
def find_by_title(search_term)
  @books.select { |book| book.matches_title?(search_term) }
end
```

---

### Step 6: Add Statistics with Getters

Add a statistics method to show library information.

**Task**: Add a statistics method that calculates unique authors.

```dart
class Library {
  String name;
  List<Book> books;

  Library(this.name) : books = [];

  void addBook(Book book) {
    books.add(book);
    print('✓ Added: $book');
  }

  int get bookCount => books.length;

  // Getter for unique authors count
  int get uniqueAuthorsCount {
    var authors = books.map((book) => book.author).toSet();
    return authors.length;
  }

  List<Book> findByTitle(String searchTerm) {
    return books.where((book) => book.matchesTitle(searchTerm)).toList();
  }

  List<Book> findByAuthor(String searchTerm) {
    return books.where((book) => book.matchesAuthor(searchTerm)).toList();
  }

  void listAllBooks() {
    if (books.isEmpty) {
      print('The library is empty.');
    } else {
      print('\n$name - Books:');
      for (var i = 0; i < books.length; i++) {
        print('  ${i + 1}. ${books[i]}');
      }
    }
  }

  void displayStatistics() {
    print('\n$name Statistics:');
    print('  Total books: $bookCount');
    print('  Unique authors: $uniqueAuthorsCount');
  }
}
```

**Test it**:

```dart
void main() {
  var lib = Library("City Central");
  lib.addBook(Book("The Dart Way", "Kathy Walrath", "978-0321927705"));
  lib.addBook(Book("Dart in Action", "Chris Buckett", "978-1617290862"));
  lib.addBook(Book("Dart Up and Running", "Kathy Walrath", "978-1449330897"));

  lib.displayStatistics();
  // Output:
  // City Central Statistics:
  //   Total books: 3
  //   Unique authors: 2
}
```

**💡 Dart Notes**:

- `map()` transforms each element (like Python/Ruby map)
- `toSet()` creates a Set (removes duplicates)
- Getters use `get` keyword and can have computation
- Getters are accessed like properties: `lib.bookCount` (no parentheses)

**🐍 Python Comparison**:

```python
@property
def unique_authors_count(self):
    authors = {book.author for book in self.books}
    return len(authors)
```

**💎 Ruby Comparison**:

```ruby
def unique_authors_count
  @books.map(&:author).uniq.length
end
```

---

### Step 7: Add Null Safety (Dart-Specific)

Dart's null safety prevents null reference errors at compile time.

**Task**: Make ISBN optional using nullable types.

```dart
class Book {
  String title;
  String author;
  String? isbn; // Nullable string with ?

  // Named parameters for clarity
  Book({
    required this.title,
    required this.author,
    this.isbn, // Optional parameter
  });

  @override
  String toString() {
    // Handle null ISBN gracefully
    var isbnText = isbn != null ? '(ISBN: $isbn)' : '(No ISBN)';
    return '"$title" by $author $isbnText';
  }

  bool matchesTitle(String searchTerm) {
    return title.toLowerCase().contains(searchTerm.toLowerCase());
  }

  bool matchesAuthor(String searchTerm) {
    return author.toLowerCase().contains(searchTerm.toLowerCase());
  }
}
```

**Test it**:

```dart
void main() {
  // With ISBN
  var book1 = Book(
    title: "The Dart Way",
    author: "Kathy Walrath",
    isbn: "978-0321927705",
  );
  print(book1); // => "The Dart Way" by Kathy Walrath (ISBN: 978-0321927705)

  // Without ISBN
  var book2 = Book(
    title: "My Diary",
    author: "Anonymous",
  );
  print(book2); // => "My Diary" by Anonymous (No ISBN)
}
```

**💡 Dart Null Safety Notes**:

- `String?` means "String or null" (nullable type)
- `String` alone is non-nullable (guaranteed to have a value)
- `required` keyword makes named parameters mandatory
- Named parameters use `{...}` in constructor
- Call with `Book(title: "...", author: "...")`
- Check null with `isbn != null` before using
- This prevents NullPointerExceptions at compile time!

**🐍 Python Comparison**:

```python
# Python (with type hints)
from typing import Optional

class Book:
    def __init__(self, title: str, author: str, isbn: Optional[str] = None):
        self.title = title
        self.author = author
        self.isbn = isbn  # Can be None
```

**💎 Ruby Comparison**:

```ruby
# Ruby (no built-in null safety)
class Book
  attr_accessor :title, :author, :isbn
  
  def initialize(title:, author:, isbn: nil)
    @title = title
    @author = author
    @isbn = isbn  # Can be nil
  end
end
```

---

## 🎯 Final Challenge

Now put it all together! Create a complete working program.

**Task**: Write a program that:

1. Creates two libraries
2. Adds at least 3 books to each library (use named parameters)
3. Lists all books in each library
4. Searches for books by title and author
5. Displays statistics for each library

**Starter Code**: See `starter.dart`

**Solution**: See `solution.dart` (try yourself first!)

---

## ✅ Checklist

Before moving to Lab 2, make sure you understand:

- [ ] How to define a class with typed properties
- [ ] Constructor shorthand: `Book(this.title, this.author)`
- [ ] Named parameters with `required` keyword
- [ ] Null safety: `String` vs `String?`
- [ ] Getters with `get` keyword
- [ ] String interpolation with `$variable` and `${expression}`
- [ ] Typed collections: `List<Type>`
- [ ] List methods: `add()`, `where()`, `map()`, `toList()`, `toSet()`
- [ ] Arrow functions: `(x) => x * 2`
- [ ] The `@override` annotation

---

## 🐍 Python Comparison Summary

| Dart | Python | Ruby |
|------|--------|------|
| `Book(this.title)` | `self.title = title` | `@title = title` |
| `String toString()` | `def __str__(self)` | `def to_s` |
| `String?` (nullable) | `Optional[str]` | No built-in |
| `required` parameter | Required param | `required:` keyword arg |
| `get bookCount => ...` | `@property` | `attr_reader` or method |
| `List<Book>` | `list` (untyped) | `Array` (untyped) |
| `(x) => x * 2` | `lambda x: x * 2` | `{ \|x\| x * 2 }` |
| `books.where(...)` | `[b for b in books if ...]` | `books.select { ... }` |
| `books.map(...)` | `[f(b) for b in books]` | `books.map { ... }` |
| `camelCase` | `snake_case` | `snake_case` |

---

## 🎨 Dart-Specific Features Learned

### 1. **Null Safety** (Dart 2.12+)
- Prevents null errors at compile time
- `Type?` for nullable, `Type` for non-nullable
- `required` for mandatory named parameters

### 2. **Named Parameters**
- More readable: `Book(title: "...", author: "...")`
- Can be required or optional
- Better than positional for many parameters

### 3. **Constructor Shorthand**
- `Book(this.title, this.author)` auto-assigns
- Saves boilerplate code
- Cleaner than Python/Ruby

### 4. **Getters**
- Computed properties with `get` keyword
- Called like properties (no `()`)
- Can have logic, not just return fields

### 5. **Typed Collections**
- `List<Book>` ensures type safety
- Compile-time checking prevents errors
- Better IDE support and autocomplete

---

**Great job!** You've learned Dart's OOP basics with null safety. Ready for more? Check out the next lab in the series!
