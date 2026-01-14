# Lab 2: Collections & Iteration

Build a contact management system to master Ruby's collections and enumerable methods.

## 🎯 Learning Objectives

By the end of this lab, you'll understand:
- Working with arrays and hashes
- Understanding blocks, procs, and yield
- Iterating with `each`, `map`, `select`, `reject`, `reduce`
- The difference between symbols and strings
- Hash manipulation and transformation

## � Running the Lab

### Step-by-Step Learning (Recommended)

Follow the progressive steps in this README to build the contact management system incrementally.

**Estimated Time**: 1.5-2.5 hours

### Quick Start with Make

Run the complete solution:
```bash
make beginner-lab NUM=2
```

This runs `solution.rb` which demonstrates all concepts.

### How to Practice

1. **Create your own file** (e.g., `my_contacts.rb`) in this directory
2. **Follow each step** in this README to build the system
3. **Test your code** with:
   ```bash
   make run-script SCRIPT=ruby/labs/beginner/lab2-collections/my_contacts.rb
   ```
4. **Compare with** `solution.rb` when complete

---

## �📋 What You'll Build

A contact management system with:
- `Contact` class to represent individual contacts
- `ContactManager` class with hash-based storage
- Search, filter, and group operations
- Export contacts in various formats

## 🚀 Progressive Steps

### Step 1: Create the Contact Class

**Task**: Create a `Contact` class with name, email, phone, and tags.

```ruby
class Contact
  attr_accessor :name, :email, :phone, :tags

  def initialize(name, email, phone, tags = [])
    @name = name
    @email = email
    @phone = phone
    @tags = tags  # Array of symbols
  end

  def to_s
    "#{@name} <#{@email}> | Phone: #{@phone}"
  end

  def has_tag?(tag)
    @tags.include?(tag)
  end
end
```

**💡 Ruby Notes**:
- Default parameter: `tags = []`
- Symbols (`:friend`, `:work`) are immutable identifiers
- Use symbols for tags/categories (more efficient than strings)

---

### Step 2: Create ContactManager with Hash Storage

**Task**: Store contacts in a hash keyed by email for fast lookup.

```ruby
class ContactManager
  attr_reader :contacts

  def initialize
    @contacts = {}  # Hash: email => Contact object
  end

  def add_contact(contact)
    @contacts[contact.email] = contact
    puts "✓ Added: #{contact.name}"
  end

  def find_by_email(email)
    @contacts[email]
  end

  def count
    @contacts.length
  end
end
```

**🐍 Python Equivalent**:
```python
class ContactManager:
    def __init__(self):
        self.contacts = {}  # dict: email -> Contact object
```

---

### Step 3: Add Iteration and Filtering Methods

**Task**: Implement methods using Ruby's enumerable powers.

```ruby
class ContactManager
  attr_reader :contacts

  def initialize
    @contacts = {}
  end

  def add_contact(contact)
    @contacts[contact.email] = contact
    puts "✓ Added: #{contact.name}"
  end

  def find_by_email(email)
    @contacts[email]
  end

  def count
    @contacts.length
  end

  # Iterate over all contacts
  def each_contact
    @contacts.each_value do |contact|
      yield contact  # Pass contact to the block
    end
  end

  # Find contacts by name (partial match)
  def find_by_name(search_term)
    @contacts.values.select do |contact|
      contact.name.downcase.include?(search_term.downcase)
    end
  end

  # Find contacts with specific tag
  def find_by_tag(tag)
    @contacts.values.select { |contact| contact.has_tag?(tag) }
  end

  # Get all unique tags across contacts
  def all_tags
    @contacts.values.flat_map(&:tags).uniq.sort
  end
end
```

**Test it**:
```ruby
manager = ContactManager.new
manager.add_contact(Contact.new("Alice", "alice@example.com", "555-0001", [:friend, :work]))
manager.add_contact(Contact.new("Bob", "bob@example.com", "555-0002", [:friend]))

# Iterate with a block
manager.each_contact do |contact|
  puts contact
end

# Find by tag
friends = manager.find_by_tag(:friend)
puts "Found #{friends.length} friends"
```

**💡 Ruby Notes**:
- `yield` passes control to the block provided by the caller
- `flat_map` maps and flattens the result (like Python's `itertools.chain`)
- `&:tags` is shorthand for `{ |c| c.tags }`

---

### Step 4: Add Mapping and Transformation

**Task**: Transform contact data into different formats.

```ruby
class ContactManager
  # ... previous methods ...

  # Get array of all names
  def all_names
    @contacts.values.map(&:name)
  end

  # Get hash of email => name
  def email_to_name_map
    @contacts.transform_values(&:name)
  end

  # Group contacts by first letter of name
  def group_by_initial
    @contacts.values.group_by { |contact| contact.name[0].upcase }
  end

  # Get contacts as simple hash array (for export)
  def to_hash_array
    @contacts.values.map do |contact|
      {
        name: contact.name,
        email: contact.email,
        phone: contact.phone,
        tags: contact.tags
      }
    end
  end
end
```

**Test it**:
```ruby
manager.add_contact(Contact.new("Alice", "alice@example.com", "555-0001", [:friend]))
manager.add_contact(Contact.new("Bob", "bob@example.com", "555-0002", [:work]))
manager.add_contact(Contact.new("Anna", "anna@example.com", "555-0003", [:friend]))

grouped = manager.group_by_initial
grouped.each do |initial, contacts|
  puts "#{initial}: #{contacts.map(&:name).join(', ')}"
end
# Output:
# A: Alice, Anna
# B: Bob
```

**💡 Ruby Notes**:
- `transform_values` transforms hash values, keeping keys the same
- `group_by` returns a hash with grouped items
- Hash syntax: `{ key: value }` is shorthand for `{ :key => value }`

---

### Step 5: Add Reduction and Aggregation

**Task**: Use `reduce` for aggregation operations.

```ruby
class ContactManager
  # ... previous methods ...

  # Count contacts by tag
  def tag_counts
    @contacts.values.reduce(Hash.new(0)) do |counts, contact|
      contact.tags.each { |tag| counts[tag] += 1 }
      counts
    end
  end

  # Get statistics
  def statistics
    total = count
    tags = all_tags

    puts "\nContact Manager Statistics:"
    puts "  Total contacts: #{total}"
    puts "  Total tags: #{tags.length}"
    puts "  Tags: #{tags.join(', ')}"

    puts "\n  Tag Distribution:"
    tag_counts.each do |tag, count|
      percentage = (count.to_f / total * 100).round(1)
      puts "    #{tag}: #{count} (#{percentage}%)"
    end
  end
end
```

**Test it**:
```ruby
manager.add_contact(Contact.new("Alice", "alice@example.com", "555-0001", [:friend, :work]))
manager.add_contact(Contact.new("Bob", "bob@example.com", "555-0002", [:friend]))
manager.add_contact(Contact.new("Charlie", "charlie@example.com", "555-0003", [:work, :client]))

manager.statistics
```

**🐍 Python Equivalent**:
```python
from functools import reduce
from collections import Counter

# Ruby's reduce
result = reduce(lambda acc, item: acc + item, numbers, 0)

# Ruby's tag_counts
tag_counts = Counter(tag for contact in contacts for tag in contact.tags)
```

**💡 Ruby Notes**:
- `reduce` (aka `inject`) accumulates a result
- `Hash.new(0)` creates a hash with default value of 0
- `to_f` converts to float for division

---

### Step 6: Add Block-Based Search and Chaining

**Task**: Allow flexible searching with custom blocks.

```ruby
class ContactManager
  # ... previous methods ...

  # Find contacts matching a custom condition (block)
  def find_where
    @contacts.values.select { |contact| yield contact }
  end

  # Reject contacts matching a condition
  def reject_where
    @contacts.values.reject { |contact| yield contact }
  end

  # Check if any contact matches condition
  def any?
    @contacts.values.any? { |contact| yield contact }
  end

  # Check if all contacts match condition
  def all?
    @contacts.values.all? { |contact| yield contact }
  end

  # Sort contacts by a given attribute
  def sorted_by(attribute)
    @contacts.values.sort_by { |contact| contact.send(attribute) }
  end
end
```

**Test it**:
```ruby
# Find contacts with multiple tags
multi_tag_contacts = manager.find_where { |c| c.tags.length > 1 }

# Check if any contact has a specific domain
has_gmail = manager.any? { |c| c.email.include?('@gmail.com') }

# Sort by name
sorted = manager.sorted_by(:name)
```

**💡 Ruby Notes**:
- `yield` can be called with the block provided by caller
- `send(:method_name)` dynamically calls a method
- `sort_by` is more efficient than `sort` with a custom comparator

---

## 🎯 Final Challenge

Create a complete contact management system that:
1. Adds at least 5 contacts with various tags
2. Demonstrates all search methods
3. Shows grouping by initial
4. Displays tag statistics
5. Uses custom block-based searches

**Starter Code**: See `starter.rb`

**Solution**: See `solution.rb`

---

## ✅ Checklist

Before moving to Lab 3, make sure you understand:

- [ ] Hash creation and manipulation
- [ ] Symbols vs strings (when to use each)
- [ ] `each`, `map`, `select`, `reject`, `reduce`
- [ ] Blocks: `{ }` vs `do...end` syntax
- [ ] `yield` to pass control to a block
- [ ] Method chaining with enumerable methods
- [ ] `flat_map`, `group_by`, `transform_values`
- [ ] Hash shortcuts: `{ key: value }` syntax
- [ ] `&:method` shorthand

---

## 🐍 Python Comparison

| Ruby | Python |
|------|--------|
| `array.select { }` | `[x for x in array if ...]` |
| `array.map { }` | `[f(x) for x in array]` |
| `array.reduce { }` | `functools.reduce()` |
| `hash.transform_values` | `{k: f(v) for k, v in dict.items()}` |
| `array.group_by { }` | `itertools.groupby()` |
| `yield` | `yield` (but different usage) |
| `:symbol` | No direct equivalent |
| `flat_map` | `itertools.chain.from_iterable()` |

---

**Excellent work!** You've mastered Ruby collections. Ready for Lab 3? → [Methods & Modules](../lab3-methods-modules/README.md)
