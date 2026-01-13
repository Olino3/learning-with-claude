# Exercise 3: OOP Challenges

Apply all OOP concepts.

## 🎯 Challenge: Library Management System

**Create:** `/home/user/learning-with-claude/dart/tutorials/6-Object-Oriented-Programming/exercises/library.dart`

```dart
void main() {
  var library = Library();

  var book1 = Book("1984", "George Orwell", "12345");
  var book2 = Book("Brave New World", "Aldous Huxley", "67890");

  library.addItem(book1);
  library.addItem(book2);

  var member = Member("Alice", "M001");
  library.registerMember(member);

  library.borrowItem("M001", "12345");
  library.listAvailableItems();

  library.returnItem("M001", "12345");
  library.listAvailableItems();
}

abstract class LibraryItem {
  String title;
  String id;
  bool isAvailable = true;

  LibraryItem(this.title, this.id);

  void displayInfo();
}

class Book extends LibraryItem {
  String author;

  Book(String title, this.author, String id) : super(title, id);

  @override
  void displayInfo() {
    print("Book: $title by $author (ID: $id)${isAvailable ? '' : ' [Borrowed]'}");
  }
}

class Member {
  String name;
  String memberId;
  List<String> borrowedItems = [];

  Member(this.name, this.memberId);
}

class Library {
  List<LibraryItem> items = [];
  List<Member> members = [];

  void addItem(LibraryItem item) {
    items.add(item);
    print("Added: ${item.title}");
  }

  void registerMember(Member member) {
    members.add(member);
    print("Registered: ${member.name}");
  }

  void borrowItem(String memberId, String itemId) {
    var member = members.firstWhere((m) => m.memberId == memberId);
    var item = items.firstWhere((i) => i.id == itemId);

    if (item.isAvailable) {
      item.isAvailable = false;
      member.borrowedItems.add(itemId);
      print("${member.name} borrowed ${item.title}");
    } else {
      print("Item not available");
    }
  }

  void returnItem(String memberId, String itemId) {
    var member = members.firstWhere((m) => m.memberId == memberId);
    var item = items.firstWhere((i) => i.id == itemId);

    item.isAvailable = true;
    member.borrowedItems.remove(itemId);
    print("${member.name} returned ${item.title}");
  }

  void listAvailableItems() {
    print("\nAvailable items:");
    for (var item in items.where((i) => i.isAvailable)) {
      item.displayInfo();
    }
  }
}
```

**Run:** `make dart-script SCRIPT=/home/user/learning-with-claude/dart/tutorials/6-Object-Oriented-Programming/exercises/library.dart`

## ✅ Success Criteria

- [ ] Completed library system
- [ ] Used inheritance and abstraction
- [ ] Proper encapsulation

🎉 Congratulations! Ready for **Tutorial 7: Null Safety**!
