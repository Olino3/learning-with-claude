// Lab 1: Dart Basics & Object-Oriented Programming
// Starter Code - Complete the TODOs

// TODO: Step 1 - Define the Book class
class Book {
  // TODO: Add instance variables (title, author, isbn)
  // Hint: Use String for title and author, String? for isbn (nullable)

  // TODO: Step 1 - Create constructor
  // Hint: Use named parameters with required keyword
  // Example: Book({required this.title, required this.author, this.isbn});

  // TODO: Step 2 - Override toString method
  // Hint: Return a formatted string like: "Title" by Author (ISBN: xxx)
  @override
  String toString() {
    // Your code here
    return '';
  }

  // TODO: Step 3 - Add matchesTitle method
  // Hint: Use toLowerCase() and contains() for case-insensitive search
  bool matchesTitle(String searchTerm) {
    // Your code here
    return false;
  }

  // TODO: Step 3 - Add matchesAuthor method
  bool matchesAuthor(String searchTerm) {
    // Your code here
    return false;
  }
}

// TODO: Step 4 - Define the Library class
class Library {
  // TODO: Add instance variables (name and books)
  // Hint: Use List<Book> for the books collection

  // TODO: Step 4 - Create constructor
  // Hint: Initialize books as empty list using initializer list
  // Example: Library(this.name) : books = [];

  // TODO: Step 4 - Add addBook method
  // Hint: Use books.add(book) and print a confirmation
  void addBook(Book book) {
    // Your code here
  }

  // TODO: Step 4 - Add bookCount getter
  // Hint: Use 'get' keyword and return books.length
  // Example: int get bookCount => books.length;

  // TODO: Step 6 - Add uniqueAuthorsCount getter
  // Hint: Use map() to get authors, toSet() to remove duplicates
  int get uniqueAuthorsCount {
    // Your code here
    return 0;
  }

  // TODO: Step 5 - Add findByTitle method
  // Hint: Use where() to filter, toList() to convert back
  List<Book> findByTitle(String searchTerm) {
    // Your code here
    return [];
  }

  // TODO: Step 5 - Add findByAuthor method
  List<Book> findByAuthor(String searchTerm) {
    // Your code here
    return [];
  }

  // TODO: Step 5 - Add listAllBooks method
  // Hint: Check if books.isEmpty, then loop with for-in or indexed for
  void listAllBooks() {
    // Your code here
  }

  // TODO: Step 6 - Add displayStatistics method
  // Hint: Print total books and unique authors
  void displayStatistics() {
    // Your code here
  }
}

void main() {
  print('=' * 70);
  print('LIBRARY MANAGEMENT SYSTEM');
  print('=' * 70);

  // TODO: Create first library
  // Example: var lib1 = Library('City Central Library');

  // TODO: Add at least 3 books to first library using named parameters
  // Example:
  // lib1.addBook(Book(
  //   title: 'The Dart Way',
  //   author: 'Kathy Walrath',
  //   isbn: '978-0321927705',
  // ));

  // TODO: Create second library

  // TODO: Add at least 3 books to second library

  // TODO: List all books in each library
  print('\n' + '=' * 70);
  print('ALL BOOKS');
  print('=' * 70);
  // lib1.listAllBooks();
  // lib2.listAllBooks();

  // TODO: Search for books by title in lib1
  print('\n' + '=' * 70);
  print('SEARCH RESULTS');
  print('=' * 70);
  // var results = lib1.findByTitle('dart');
  // Print results...

  // TODO: Search for books by author in lib2

  // TODO: Display statistics
  print('\n' + '=' * 70);
  print('STATISTICS');
  print('=' * 70);
  // lib1.displayStatistics();
  // lib2.displayStatistics();

  // TODO: Display total books across all libraries
  print('\n' + '-' * 70);
  // print('Total libraries: 2');
  // print('Total books: ${lib1.bookCount + lib2.bookCount}');
  print('=' * 70);
}
