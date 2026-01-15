// Lab 2: Collections & Iteration - Complete Solution

/// Represents a contact with name, email, phone, and tags.
class Contact {
  String name;
  String email;
  String phone;
  Set<String> tags;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    Set<String>? tags,
  }) : tags = tags ?? {};

  @override
  String toString() {
    final tagStr = tags.isEmpty ? '' : ' [${tags.join(', ')}]';
    return '$name <$email> | Phone: $phone$tagStr';
  }

  bool hasTag(String tag) {
    return tags.contains(tag);
  }
}

/// Manages a collection of contacts with search and analytics features.
class ContactManager {
  final Map<String, Contact> _contacts = {};

  void addContact(Contact contact) {
    _contacts[contact.email] = contact;
    print('✓ Added: ${contact.name}');
  }

  Contact? findByEmail(String email) {
    return _contacts[email];
  }

  int get count => _contacts.length;

  List<Contact> get allContacts => _contacts.values.toList();

  /// Iterate over all contacts with a callback
  void forEachContact(void Function(Contact) action) {
    _contacts.values.forEach(action);
  }

  /// Find contacts by name (partial match, case-insensitive)
  List<Contact> findByName(String searchTerm) {
    final lower = searchTerm.toLowerCase();
    return _contacts.values
        .where((contact) => contact.name.toLowerCase().contains(lower))
        .toList();
  }

  /// Find contacts with specific tag
  List<Contact> findByTag(String tag) {
    return _contacts.values
        .where((contact) => contact.hasTag(tag))
        .toList();
  }

  /// Get all unique tags across contacts
  Set<String> get allTags {
    return _contacts.values
        .expand((contact) => contact.tags)  // Flatten tags from all contacts
        .toSet();
  }

  /// Get list of all names
  List<String> get allNames {
    return _contacts.values.map((contact) => contact.name).toList();
  }

  /// Get Map of email => name
  Map<String, String> get emailToNameMap {
    return _contacts.map((email, contact) => MapEntry(email, contact.name));
  }

  /// Group contacts by first letter of name
  Map<String, List<Contact>> groupByInitial() {
    final grouped = <String, List<Contact>>{};
    
    for (final contact in _contacts.values) {
      final initial = contact.name[0].toUpperCase();
      grouped.putIfAbsent(initial, () => []).add(contact);
    }
    
    return grouped;
  }

  /// Get contacts as List of Maps (for export)
  List<Map<String, dynamic>> toMapList() {
    return _contacts.values.map((contact) => {
      'name': contact.name,
      'email': contact.email,
      'phone': contact.phone,
      'tags': contact.tags.toList(),
    }).toList();
  }

  /// Count contacts by tag using fold
  Map<String, int> tagCounts() {
    return _contacts.values.fold<Map<String, int>>(
      {},
      (counts, contact) {
        for (final tag in contact.tags) {
          counts[tag] = (counts[tag] ?? 0) + 1;
        }
        return counts;
      },
    );
  }

  /// Display statistics about contacts
  void statistics() {
    final total = count;
    final tags = allTags.toList()..sort();

    print('\nContact Manager Statistics:');
    print('  Total contacts: $total');
    print('  Total unique tags: ${tags.length}');
    print('  Tags: ${tags.join(', ')}');

    print('\n  Tag Distribution:');
    final counts = tagCounts();
    counts.forEach((tag, count) {
      final percentage = (count / total * 100).toStringAsFixed(1);
      print('    $tag: $count ($percentage%)');
    });
  }

  /// Find contacts matching a custom condition
  List<Contact> findWhere(bool Function(Contact) predicate) {
    return _contacts.values.where(predicate).toList();
  }

  /// Check if any contact matches condition
  bool any(bool Function(Contact) predicate) {
    return _contacts.values.any(predicate);
  }

  /// Check if all contacts match condition
  bool every(bool Function(Contact) predicate) {
    return _contacts.values.every(predicate);
  }

  /// Sort contacts by name (using cascade notation)
  List<Contact> sortedByName() {
    return allContacts..sort((a, b) => a.name.compareTo(b.name));
  }

  /// List all contacts sorted by name
  void listAll() {
    if (_contacts.isEmpty) {
      print('No contacts in the system.');
    } else {
      print('\nAll Contacts ($count):');
      final sorted = sortedByName();
      for (var i = 0; i < sorted.length; i++) {
        print('  ${i + 1}. ${sorted[i]}');
      }
    }
  }
}

// Main Program
void main() {
  print('=' * 70);
  print(' ' * 20 + 'CONTACT MANAGER');
  print('=' * 70);

  final manager = ContactManager();

  // Adding contacts (demonstrating Set literals for tags)
  print('\nAdding contacts...');
  manager.addContact(Contact(
    name: 'Alice Johnson',
    email: 'alice@example.com',
    phone: '555-0001',
    tags: {'friend', 'work'},
  ));
  manager.addContact(Contact(
    name: 'Bob Smith',
    email: 'bob@gmail.com',
    phone: '555-0002',
    tags: {'friend', 'hobby'},
  ));
  manager.addContact(Contact(
    name: 'Charlie Brown',
    email: 'charlie@work.com',
    phone: '555-0003',
    tags: {'work', 'client'},
  ));
  manager.addContact(Contact(
    name: 'Diana Prince',
    email: 'diana@example.com',
    phone: '555-0004',
    tags: {'friend'},
  ));
  manager.addContact(Contact(
    name: 'Eve Adams',
    email: 'eve@startup.io',
    phone: '555-0005',
    tags: {'work', 'startup', 'friend'},
  ));

  // List all contacts
  manager.listAll();

  // Search by name
  print('\n${'=' * 70}');
  print('SEARCH BY NAME');
  print('=' * 70);
  final results = manager.findByName('alice');
  print('\nSearching for \'alice\':');
  for (final contact in results) {
    print('  → $contact');
  }

  // Search by tag
  print('\n${'=' * 70}');
  print('SEARCH BY TAG');
  print('=' * 70);
  print('\nContacts tagged with \'work\':');
  for (final contact in manager.findByTag('work')) {
    print('  → $contact');
  }

  print('\nContacts tagged with \'friend\':');
  for (final contact in manager.findByTag('friend')) {
    print('  → $contact');
  }

  // Group by initial
  print('\n${'=' * 70}');
  print('GROUPED BY INITIAL');
  print('=' * 70);
  final grouped = manager.groupByInitial();
  grouped.forEach((initial, contacts) {
    print('\n$initial:');
    for (final contact in contacts) {
      print('  • $contact');
    }
  });

  // Custom searches with predicates
  print('\n${'=' * 70}');
  print('CUSTOM SEARCHES');
  print('=' * 70);

  print('\nContacts with multiple tags:');
  final multiTag = manager.findWhere((c) => c.tags.length > 1);
  for (final contact in multiTag) {
    print('  → $contact');
  }

  print('\nContacts with Gmail addresses:');
  final gmailContacts = manager.findWhere((c) => c.email.contains('@gmail.com'));
  for (final contact in gmailContacts) {
    print('  → $contact');
  }

  final hasStartup = manager.any((c) => c.hasTag('startup'));
  print('\nAny startup contacts? $hasStartup');

  final allHavePhone = manager.every((c) => c.phone.isNotEmpty);
  print('All contacts have phone numbers? $allHavePhone');

  // Demonstrate spread operator and collection literals
  print('\n${'=' * 70}');
  print('COLLECTION LITERALS & SPREAD OPERATOR');
  print('=' * 70);

  // Get all tags from first 3 contacts using spread
  final firstThreeEmails = ['alice@example.com', 'bob@gmail.com', 'charlie@work.com'];
  final combinedTags = <String>{
    for (final email in firstThreeEmails)
      if (manager.findByEmail(email) != null)
        ...manager.findByEmail(email)!.tags
  };
  print('\nCombined tags from first 3 contacts: ${combinedTags.join(', ')}');

  // Collection if - get only work contacts
  final workContacts = [
    for (final contact in manager.allContacts)
      if (contact.hasTag('work'))
        contact.name
  ];
  print('Work contacts: ${workContacts.join(', ')}');

  // Statistics
  print('\n${'=' * 70}');
  print('STATISTICS');
  print('=' * 70);
  manager.statistics();

  // Demonstrate cascade notation
  print('\n${'=' * 70}');
  print('CASCADE NOTATION EXAMPLE');
  print('=' * 70);
  
  // Create and configure a contact using cascades
  final newContact = Contact(
    name: 'Frank Miller',
    email: 'frank@example.com',
    phone: '555-0006',
  )
    ..tags.add('friend')
    ..tags.add('hobby')
    ..tags.add('gaming');
  
  print('\nCreated with cascade: $newContact');

  print('\n${'=' * 70}');
}
