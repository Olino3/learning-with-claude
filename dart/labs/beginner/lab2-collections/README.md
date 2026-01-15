# Lab 2: Collections & Iteration

Build a contact management system to master Dart's collections and functional methods.

## 🎯 Learning Objectives

By the end of this lab, you'll understand:
- Working with Lists, Maps, and Sets (typed collections)
- Null safety with collections
- Iterating with `forEach`, `map`, `where`, `reduce`, `fold`
- Collection literals and the spread operator (`...`)
- Cascade notation (`..`) for fluent APIs
- The difference between `map` and `toList()`
- Set operations for unique collections

## 🏃 Running the Lab

### Step-by-Step Learning (Recommended)

Follow the progressive steps in this README to build the contact management system incrementally.

**Estimated Time**: 1.5-2.5 hours

### Quick Start

Run the complete solution:
```bash
cd dart/labs/beginner/lab2-collections
dart run solution.dart
```

This demonstrates all collection concepts.

### How to Practice

1. **Use the starter file**: `starter.dart` has TODO comments to guide you
2. **Follow each step** in this README to build the system
3. **Test your code** with:
   ```bash
   dart run starter.dart
   ```
4. **Compare with** `solution.dart` when complete

---

## 📋 What You'll Build

A contact management system with:
- `Contact` class to represent individual contacts
- `ContactManager` class with Map-based storage
- Search, filter, and group operations using collection methods
- Tag management with Sets for uniqueness
- Statistics and analytics with reduce/fold

## 🚀 Progressive Steps

### Step 1: Create the Contact Class

**Task**: Create a `Contact` class with name, email, phone, and tags.

```dart
class Contact {
  String name;
  String email;
  String phone;
  Set<String> tags;  // Set ensures unique tags

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    Set<String>? tags,  // Nullable parameter
  }) : tags = tags ?? {};  // Default to empty Set

  @override
  String toString() {
    final tagStr = tags.isEmpty ? '' : ' [${tags.join(', ')}]';
    return '$name <$email> | Phone: $phone$tagStr';
  }

  bool hasTag(String tag) {
    return tags.contains(tag);
  }
}
```

**💡 Dart Notes**:
- `required` keyword for mandatory named parameters
- `Set<String>?` means nullable Set (null safety)
- `??` is the null-coalescing operator (like Python's `or`)
- Sets automatically handle uniqueness (unlike Lists)

**🐍 Python Comparison**:
```python
# Python
class Contact:
    def __init__(self, name, email, phone, tags=None):
        self.tags = tags or set()  # Default to empty set

# Dart uses named parameters and null safety
Contact(name: 'Alice', email: 'alice@example.com', phone: '555-0001')
```

**💎 Ruby Comparison**:
```ruby
# Ruby uses array for tags
def initialize(name, email, phone, tags = [])
  @tags = tags
end

# Dart uses Set and named parameters
Contact(name: 'Alice', email: 'alice@example.com', phone: '555-0001', tags: {'friend'})
```

---

### Step 2: Create ContactManager with Map Storage

**Task**: Store contacts in a Map keyed by email for fast lookup.

```dart
class ContactManager {
  final Map<String, Contact> _contacts = {};

  void addContact(Contact contact) {
    _contacts[contact.email] = contact;
    print('✓ Added: ${contact.name}');
  }

  Contact? findByEmail(String email) {
    return _contacts[email];  // Returns null if not found
  }

  int get count => _contacts.length;

  // Get all contacts as a list
  List<Contact> get allContacts => _contacts.values.toList();
}
```

**💡 Dart Notes**:
- `final` means the reference can't change (but contents can)
- `_contacts` (underscore) makes it private
- `Contact?` means the return type is nullable
- Getters use `get` keyword (no parentheses when calling)
- `.values` returns an `Iterable`, `.toList()` converts to `List`

**🐍 Python Equivalent**:
```python
class ContactManager:
    def __init__(self):
        self._contacts = {}  # dict: email -> Contact object
    
    @property
    def count(self):
        return len(self._contacts)
```

---

### Step 3: Add Iteration and Filtering Methods

**Task**: Implement methods using Dart's collection methods.

```dart
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

  // Iterate over all contacts with a callback
  void forEachContact(void Function(Contact) action) {
    _contacts.values.forEach(action);
  }

  // Find contacts by name (partial match, case-insensitive)
  List<Contact> findByName(String searchTerm) {
    final lower = searchTerm.toLowerCase();
    return _contacts.values
        .where((contact) => contact.name.toLowerCase().contains(lower))
        .toList();
  }

  // Find contacts with specific tag
  List<Contact> findByTag(String tag) {
    return _contacts.values
        .where((contact) => contact.hasTag(tag))
        .toList();
  }

  // Get all unique tags across contacts
  Set<String> get allTags {
    return _contacts.values
        .expand((contact) => contact.tags)  // Like flatMap
        .toSet();  // Convert to Set for uniqueness
  }
}
```

**Test it**:
```dart
final manager = ContactManager();
manager.addContact(Contact(
  name: 'Alice',
  email: 'alice@example.com',
  phone: '555-0001',
  tags: {'friend', 'work'},
));
manager.addContact(Contact(
  name: 'Bob',
  email: 'bob@example.com',
  phone: '555-0002',
  tags: {'friend'},
));

// Iterate with a callback
manager.forEachContact((contact) {
  print(contact);
});

// Find by tag
final friends = manager.findByTag('friend');
print('Found ${friends.length} friends');
```

**💡 Dart Notes**:
- `where()` filters items (like Ruby's `select`, Python's `filter`)
- `expand()` flattens nested collections (like Ruby's `flat_map`)
- `.toList()` and `.toSet()` convert Iterables to concrete collections
- Method chaining is common and readable

**💎 Ruby Comparison**:
```ruby
# Ruby
@contacts.values.select { |c| c.has_tag?(tag) }

# Dart
_contacts.values.where((c) => c.hasTag(tag)).toList();
```

**🐍 Python Comparison**:
```python
# Python
[c for c in contacts.values() if c.has_tag(tag)]

# Dart
_contacts.values.where((c) => c.hasTag(tag)).toList();
```

---

### Step 4: Add Mapping and Transformation

**Task**: Transform contact data into different formats.

```dart
class ContactManager {
  // ... previous methods ...

  // Get list of all names
  List<String> get allNames {
    return _contacts.values.map((contact) => contact.name).toList();
  }

  // Get Map of email => name
  Map<String, String> get emailToNameMap {
    return _contacts.map((email, contact) => MapEntry(email, contact.name));
  }

  // Group contacts by first letter of name
  Map<String, List<Contact>> groupByInitial() {
    final grouped = <String, List<Contact>>{};
    
    for (final contact in _contacts.values) {
      final initial = contact.name[0].toUpperCase();
      grouped.putIfAbsent(initial, () => []).add(contact);
    }
    
    return grouped;
  }

  // Alternative: Using fold for grouping
  Map<String, List<Contact>> groupByInitialFunctional() {
    return _contacts.values.fold<Map<String, List<Contact>>>(
      {},
      (grouped, contact) {
        final initial = contact.name[0].toUpperCase();
        (grouped[initial] ??= []).add(contact);
        return grouped;
      },
    );
  }

  // Get contacts as List of Maps (for export)
  List<Map<String, dynamic>> toMapList() {
    return _contacts.values.map((contact) => {
      'name': contact.name,
      'email': contact.email,
      'phone': contact.phone,
      'tags': contact.tags.toList(),
    }).toList();
  }
}
```

**Test it**:
```dart
manager.addContact(Contact(name: 'Alice', email: 'alice@example.com', phone: '555-0001', tags: {'friend'}));
manager.addContact(Contact(name: 'Bob', email: 'bob@example.com', phone: '555-0002', tags: {'work'}));
manager.addContact(Contact(name: 'Anna', email: 'anna@example.com', phone: '555-0003', tags: {'friend'}));

final grouped = manager.groupByInitial();
grouped.forEach((initial, contacts) {
  print('$initial: ${contacts.map((c) => c.name).join(', ')}');
});
// Output:
// A: Alice, Anna
// B: Bob
```

**💡 Dart Notes**:
- `map()` on Maps requires returning `MapEntry` objects
- `putIfAbsent()` adds key if missing, returns the value
- `fold()` is like `reduce()` but can return a different type
- `<String, List<Contact>>{}` is a typed empty Map literal
- `??=` assigns only if the value is null

**💎 Ruby Comparison**:
```ruby
# Ruby has built-in group_by
contacts.values.group_by { |c| c.name[0].upcase }

# Dart needs manual grouping or use fold
_contacts.values.fold({}, (grouped, contact) { ... });
```

---

### Step 5: Add Reduction and Aggregation

**Task**: Use `fold` and `reduce` for aggregation operations.

```dart
class ContactManager {
  // ... previous methods ...

  // Count contacts by tag
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

  // Get statistics
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
}
```

**Test it**:
```dart
manager.addContact(Contact(name: 'Alice', email: 'alice@example.com', phone: '555-0001', tags: {'friend', 'work'}));
manager.addContact(Contact(name: 'Bob', email: 'bob@example.com', phone: '555-0002', tags: {'friend'}));
manager.addContact(Contact(name: 'Charlie', email: 'charlie@example.com', phone: '555-0003', tags: {'work', 'client'}));

manager.statistics();
```

**🐍 Python Equivalent**:
```python
from functools import reduce
from collections import Counter

# Dart's fold
result = reduce(lambda acc, item: acc + item, numbers, 0)

# Dart's tagCounts
tag_counts = Counter(tag for contact in contacts for tag in contact.tags)
```

**💡 Dart Notes**:
- `fold<T>(initial, callback)` requires type parameter for return type
- `reduce()` requires same type as elements, `fold()` can return different type
- `..` is cascade notation - calls method on same object, returns object
- `toStringAsFixed(1)` formats float to 1 decimal place

**💎 Ruby Comparison**:
```ruby
# Ruby
contacts.reduce(Hash.new(0)) do |counts, contact|
  contact.tags.each { |tag| counts[tag] += 1 }
  counts
end

# Dart
contacts.fold<Map<String, int>>({}, (counts, contact) {
  for (final tag in contact.tags) {
    counts[tag] = (counts[tag] ?? 0) + 1;
  }
  return counts;
});
```

---

### Step 6: Add Advanced Filtering and Boolean Checks

**Task**: Implement `any`, `every`, and custom filtering.

```dart
class ContactManager {
  // ... previous methods ...

  // Find contacts matching a custom condition
  List<Contact> findWhere(bool Function(Contact) predicate) {
    return _contacts.values.where(predicate).toList();
  }

  // Check if any contact matches condition
  bool any(bool Function(Contact) predicate) {
    return _contacts.values.any(predicate);
  }

  // Check if all contacts match condition
  bool every(bool Function(Contact) predicate) {
    return _contacts.values.every(predicate);
  }

  // Sort contacts by a field (using custom comparator)
  List<Contact> sortedByName() {
    final contacts = allContacts;
    contacts.sort((a, b) => a.name.compareTo(b.name));
    return contacts;
  }

  // Using cascade notation for sorting
  List<Contact> sortedByNameCascade() {
    return allContacts..sort((a, b) => a.name.compareTo(b.name));
  }
}
```

**Test it**:
```dart
// Find contacts with multiple tags
final multiTag = manager.findWhere((c) => c.tags.length > 1);

// Check if any contact has Gmail
final hasGmail = manager.any((c) => c.email.contains('@gmail.com'));

// Check if all contacts have phone numbers
final allHavePhone = manager.every((c) => c.phone.isNotEmpty);

// Sort by name
final sorted = manager.sortedByName();
```

**💡 Dart Notes**:
- `bool Function(Contact)` is a function type (predicate)
- `any()` returns true if at least one element matches
- `every()` returns true only if all elements match (like Ruby's `all?`)
- Cascade `..` returns the object, not the method result
- `compareTo()` is used for sorting (returns -1, 0, or 1)

---

### Step 7: Demonstrate the Spread Operator and Collection Literals

**Task**: Use modern Dart collection features.

```dart
class ContactManager {
  // ... previous methods ...

  // Merge tags from multiple contacts using spread operator
  Set<String> mergeTagsFrom(List<String> emails) {
    return {
      for (final email in emails)
        if (_contacts[email] != null)
          ..._contacts[email]!.tags
    };
  }

  // Create a filtered copy of contacts using collection if
  List<Contact> getActiveContacts({required bool workOnly}) {
    return [
      for (final contact in _contacts.values)
        if (!workOnly || contact.hasTag('work'))
          contact
    ];
  }

  // Demonstrate various collection literals
  void demonstrateCollectionLiterals() {
    // List literal
    final names = ['Alice', 'Bob', 'Charlie'];
    
    // Map literal
    final emailMap = {
      'alice@example.com': 'Alice',
      'bob@example.com': 'Bob',
    };
    
    // Set literal
    final tags = {'friend', 'work', 'family'};
    
    // Spread operator
    final allNames = [...names, ...manager.allNames];
    
    // Collection if
    final filteredNames = [
      for (final name in names)
        if (name.startsWith('A'))
          name
    ];
    
    // Collection for
    final uppercased = [for (final name in names) name.toUpperCase()];
  }
}
```

**💡 Dart Notes**:
- `...` is the spread operator (spreads collection into another)
- `for` and `if` can be used inside collection literals
- `!` asserts non-null (use carefully!)
- Collection literals are concise and type-safe

**🐍 Python Comparison**:
```python
# Python list comprehension
filtered = [name for name in names if name.startswith('A')]

# Dart collection-if
final filtered = [for (final name in names) if (name.startsWith('A')) name];

# Python extend
all_names = names + manager.all_names

# Dart spread
final allNames = [...names, ...manager.allNames];
```

---

## 🎯 Final Challenge

Create a complete contact management system that:
1. Adds at least 5 contacts with various tags
2. Demonstrates all search methods (`where`, `any`, `every`)
3. Shows grouping by initial letter
4. Displays tag statistics using `fold`
5. Uses the spread operator and collection literals
6. Demonstrates cascade notation

**Starter Code**: See `starter.dart`

**Solution**: See `solution.dart`

---

## ✅ Checklist

Before moving to Lab 3, make sure you understand:

- [ ] Map creation and manipulation
- [ ] List vs Set (when to use each)
- [ ] Null safety: `Type?`, `??`, `!`
- [ ] Collection methods: `forEach`, `map`, `where`, `reduce`, `fold`
- [ ] `any()` and `every()` for boolean checks
- [ ] `expand()` for flattening (like `flatMap`)
- [ ] Method chaining with `.toList()` and `.toSet()`
- [ ] Typed collections: `List<T>`, `Map<K, V>`, `Set<T>`
- [ ] Spread operator: `...`
- [ ] Collection if and for
- [ ] Cascade notation: `..`
- [ ] Named parameters with `required`

---

## 🐍 Python Comparison

| Dart | Python | Ruby |
|------|--------|------|
| `.where((x) => ...)` | `[x for x in list if ...]` | `.select { }` |
| `.map((x) => ...)` | `[f(x) for x in list]` | `.map { }` |
| `.reduce(fn)` | `functools.reduce()` | `.reduce { }` |
| `.fold(init, fn)` | `functools.reduce(fn, list, init)` | `.reduce(init) { }` |
| `.expand((x) => ...)` | `itertools.chain.from_iterable()` | `.flat_map { }` |
| `.any((x) => ...)` | `any(... for x in list)` | `.any? { }` |
| `.every((x) => ...)` | `all(... for x in list)` | `.all? { }` |
| `{...set1, ...set2}` | `set1 \| set2` | `set1 + set2` |
| `Type?` (nullable) | `Optional[Type]` or `Type \| None` | N/A |
| `value ?? default` | `value or default` | `value \|\| default` |

---

## 💡 Key Dart Concepts

**Null Safety**:
```dart
String? nullable = null;           // Can be null
String nonNull = nullable ?? 'hi'; // Provide default
print(nullable!.length);           // Assert non-null (unsafe!)
```

**Cascade Notation**:
```dart
// Without cascade
var contact = Contact(name: 'Alice', email: 'alice@example.com', phone: '555-0001');
contact.tags.add('friend');
contact.tags.add('work');

// With cascade
var contact = Contact(name: 'Alice', email: 'alice@example.com', phone: '555-0001')
  ..tags.add('friend')
  ..tags.add('work');
```

**Collection Literals**:
```dart
// Collection if
final list = [1, 2, if (condition) 3, 4];

// Collection for
final squares = [for (var i in [1, 2, 3]) i * i];

// Spread
final combined = [...list1, ...list2];
```

---

**Excellent work!** You've mastered Dart collections. Ready for more? → Continue exploring Dart labs!
