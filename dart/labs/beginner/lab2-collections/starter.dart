// Lab 2: Collections & Iteration - Starter Template
// Complete the TODOs to build a Contact Manager System

/// Represents a contact with name, email, phone, and tags.
class Contact {
  // TODO: Add properties for name, email, phone, and tags
  // Hint: Use Set<String> for tags to ensure uniqueness
  // Hint: name, email, phone should be String
  
  // TODO: Create a constructor with named parameters
  // Hint: Use 'required' for mandatory parameters
  // Hint: Make tags nullable (Set<String>?) with default empty Set
  Contact({
    // Your code here
  });

  // TODO: Override toString() to display contact info
  // Format: "Name <email> | Phone: phone [tag1, tag2]"
  @override
  String toString() {
    // Your code here
    return '';
  }

  // TODO: Implement hasTag method to check if contact has a specific tag
  bool hasTag(String tag) {
    // Your code here
    return false;
  }
}

/// Manages a collection of contacts with search and analytics features.
class ContactManager {
  // TODO: Create a private Map to store contacts (email => Contact)
  // Hint: Use Map<String, Contact> with underscore for private
  
  // TODO: Implement addContact method
  // Store contact using email as key
  // Print: "✓ Added: {name}"
  void addContact(Contact contact) {
    // Your code here
  }

  // TODO: Implement findByEmail method
  // Return the contact or null if not found
  // Hint: Return type should be Contact?
  Contact? findByEmail(String email) {
    // Your code here
    return null;
  }

  // TODO: Create a getter for count
  // Return the number of contacts
  int get count {
    // Your code here
    return 0;
  }

  // TODO: Create a getter for allContacts
  // Return all contacts as a List
  List<Contact> get allContacts {
    // Your code here
    return [];
  }

  // TODO: Implement forEachContact to iterate over all contacts
  // Accept a callback function and apply it to each contact
  void forEachContact(void Function(Contact) action) {
    // Your code here
  }

  // TODO: Implement findByName for partial, case-insensitive search
  // Hint: Use .where() to filter and .toLowerCase() for case-insensitive
  List<Contact> findByName(String searchTerm) {
    // Your code here
    return [];
  }

  // TODO: Implement findByTag to get all contacts with a specific tag
  // Hint: Use .where() and the hasTag method
  List<Contact> findByTag(String tag) {
    // Your code here
    return [];
  }

  // TODO: Create allTags getter to get all unique tags
  // Hint: Use .expand() to flatten tags from all contacts
  // Hint: Convert to Set with .toSet() for uniqueness
  Set<String> get allTags {
    // Your code here
    return {};
  }

  // TODO: Create allNames getter to get list of all contact names
  // Hint: Use .map() to transform contacts to names
  List<String> get allNames {
    // Your code here
    return [];
  }

  // TODO: Implement groupByInitial to group contacts by first letter
  // Return Map<String, List<Contact>>
  // Hint: Use putIfAbsent or fold
  Map<String, List<Contact>> groupByInitial() {
    // Your code here
    return {};
  }

  // TODO: Implement tagCounts to count how many contacts have each tag
  // Return Map<String, int>
  // Hint: Use .fold() to build the counts map
  Map<String, int> tagCounts() {
    // Your code here
    return {};
  }

  // TODO: Implement statistics method to display:
  // - Total contacts
  // - Total unique tags
  // - List of tags
  // - Tag distribution (tag: count (percentage%))
  void statistics() {
    // Your code here
  }

  // TODO: Implement findWhere to filter with custom predicate
  // Accept a function that returns bool for each contact
  List<Contact> findWhere(bool Function(Contact) predicate) {
    // Your code here
    return [];
  }

  // TODO: Implement any to check if any contact matches condition
  bool any(bool Function(Contact) predicate) {
    // Your code here
    return false;
  }

  // TODO: Implement every to check if all contacts match condition
  bool every(bool Function(Contact) predicate) {
    // Your code here
    return false;
  }

  // TODO: Implement sortedByName to return contacts sorted by name
  // Hint: Use ..sort() with cascade notation
  List<Contact> sortedByName() {
    // Your code here
    return [];
  }

  // TODO: Implement listAll to display all contacts
  // Show "No contacts" if empty, otherwise list sorted by name
  void listAll() {
    // Your code here
  }
}

// Main Program
void main() {
  print('=' * 70);
  print(' ' * 20 + 'CONTACT MANAGER');
  print('=' * 70);

  final manager = ContactManager();

  // TODO: Add 5 contacts with various tags
  // Example:
  // manager.addContact(Contact(
  //   name: 'Alice Johnson',
  //   email: 'alice@example.com',
  //   phone: '555-0001',
  //   tags: {'friend', 'work'},
  // ));
  
  print('\nAdding contacts...');
  // Your code here

  // TODO: List all contacts
  // Your code here

  // TODO: Search by name
  print('\n${'=' * 70}');
  print('SEARCH BY NAME');
  print('=' * 70);
  // Your code here

  // TODO: Search by tag (search for 'work' and 'friend')
  print('\n${'=' * 70}');
  print('SEARCH BY TAG');
  print('=' * 70);
  // Your code here

  // TODO: Group contacts by initial letter
  print('\n${'=' * 70}');
  print('GROUPED BY INITIAL');
  print('=' * 70);
  // Your code here

  // TODO: Custom searches
  // - Find contacts with multiple tags
  // - Find contacts with Gmail addresses
  // - Check if any contact has 'startup' tag
  print('\n${'=' * 70}');
  print('CUSTOM SEARCHES');
  print('=' * 70);
  // Your code here

  // TODO: Demonstrate spread operator and collection literals
  // - Combine tags from first few contacts using spread
  // - Use collection-if to filter work contacts
  print('\n${'=' * 70}');
  print('COLLECTION LITERALS & SPREAD OPERATOR');
  print('=' * 70);
  // Your code here

  // TODO: Display statistics
  print('\n${'=' * 70}');
  print('STATISTICS');
  print('=' * 70);
  // Your code here

  // TODO: Demonstrate cascade notation
  // Create a new contact and add tags using cascades
  print('\n${'=' * 70}');
  print('CASCADE NOTATION EXAMPLE');
  print('=' * 70);
  // Your code here

  print('\n${'=' * 70}');
}
