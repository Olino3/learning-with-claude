// Lab 1: Dart Basics & Object-Oriented Programming
// Complete Solution

class Book {
  String title;
  String author;
  String? isbn; // Nullable for flexibility

  // Named parameters for clarity
  Book({
    required this.title,
    required this.author,
    this.isbn,
  });

  @override
  String toString() {
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

class Library {
  String name;
  List<Book> books;

  Library(this.name) : books = [];

  void addBook(Book book) {
    books.add(book);
    print('✓ Added: $book');
  }

  int get bookCount => books.length;

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

void main() {
  print('=' * 70);
  print(' ' * 20 + 'LIBRARY MANAGEMENT SYSTEM');
  print('=' * 70);

  // Create first library
  var lib1 = Library('City Central Library');
  print('\n📚 Created: ${lib1.name}');

  // Add books to first library
  lib1.addBook(Book(
    title: 'The Dart Way',
    author: 'Kathy Walrath',
    isbn: '978-0321927705',
  ));
  lib1.addBook(Book(
    title: 'Dart in Action',
    author: 'Chris Buckett',
    isbn: '978-1617290862',
  ));
  lib1.addBook(Book(
    title: 'Dart Up and Running',
    author: 'Kathy Walrath',
    isbn: '978-1449330897',
  ));

  // Create second library
  var lib2 = Library('University Library');
  print('\n📚 Created: ${lib2.name}');

  // Add books to second library
  lib2.addBook(Book(
    title: 'Flutter in Action',
    author: 'Eric Windmill',
    isbn: '978-1617296147',
  ));
  lib2.addBook(Book(
    title: 'Programming Dart',
    author: 'Chris Buckett',
    isbn: '978-1937785277',
  ));
  lib2.addBook(Book(
    title: 'Learning Dart',
    author: 'Dzenan Ridjanovic',
    isbn: '978-1849697415',
  ));
  lib2.addBook(Book(
    title: 'Dart for Absolute Beginners',
    author: 'David Kopec',
    isbn: '978-1430264811',
  ));

  // List all books in each library
  print('\n' + '=' * 70);
  print(' ' * 28 + 'ALL BOOKS');
  print('=' * 70);
  lib1.listAllBooks();
  lib2.listAllBooks();

  // Search for books
  print('\n' + '=' * 70);
  print(' ' * 26 + 'SEARCH RESULTS');
  print('=' * 70);

  print('\n🔍 Searching for books with "Dart" in title at ${lib1.name}:');
  var results = lib1.findByTitle('dart');
  if (results.isEmpty) {
    print('  No books found.');
  } else {
    for (var book in results) {
      print('  → $book');
    }
  }

  print('\n🔍 Searching for books by "Buckett" at ${lib2.name}:');
  results = lib2.findByAuthor('buckett');
  if (results.isEmpty) {
    print('  No books found.');
  } else {
    for (var book in results) {
      print('  → $book');
    }
  }

  // Display statistics
  print('\n' + '=' * 70);
  print(' ' * 30 + 'STATISTICS');
  print('=' * 70);
  lib1.displayStatistics();
  lib2.displayStatistics();

  print('\n' + '-' * 70);
  print('Total libraries: 2');
  print('Total books across all libraries: ${lib1.bookCount + lib2.bookCount}');
  print('=' * 70);
}
