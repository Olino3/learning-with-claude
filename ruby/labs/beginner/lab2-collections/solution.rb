# Lab 2: Collections & Iteration - Complete Solution

class Contact
  attr_accessor :name, :email, :phone, :tags

  def initialize(name, email, phone, tags = [])
    @name = name
    @email = email
    @phone = phone
    @tags = tags
  end

  def to_s
    tags_str = @tags.empty? ? "" : " [#{@tags.join(', ')}]"
    "#{@name} <#{@email}> | Phone: #{@phone}#{tags_str}"
  end

  def has_tag?(tag)
    @tags.include?(tag)
  end
end

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

  def each_contact
    @contacts.each_value { |contact| yield contact }
  end

  def find_by_name(search_term)
    @contacts.values.select { |contact| contact.name.downcase.include?(search_term.downcase) }
  end

  def find_by_tag(tag)
    @contacts.values.select { |contact| contact.has_tag?(tag) }
  end

  def all_tags
    @contacts.values.flat_map(&:tags).uniq.sort
  end

  def all_names
    @contacts.values.map(&:name)
  end

  def email_to_name_map
    @contacts.transform_values(&:name)
  end

  def group_by_initial
    @contacts.values.group_by { |contact| contact.name[0].upcase }
  end

  def to_hash_array
    @contacts.values.map do |contact|
      { name: contact.name, email: contact.email, phone: contact.phone, tags: contact.tags }
    end
  end

  def tag_counts
    @contacts.values.reduce(Hash.new(0)) do |counts, contact|
      contact.tags.each { |tag| counts[tag] += 1 }
      counts
    end
  end

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

  def find_where
    @contacts.values.select { |contact| yield contact }
  end

  def reject_where
    @contacts.values.reject { |contact| yield contact }
  end

  def any?
    @contacts.values.any? { |contact| yield contact }
  end

  def all?
    @contacts.values.all? { |contact| yield contact }
  end

  def sorted_by(attribute)
    @contacts.values.sort_by { |contact| contact.send(attribute) }
  end

  def list_all
    if @contacts.empty?
      puts "No contacts in the system."
    else
      puts "\nAll Contacts (#{count}):"
      sorted_by(:name).each_with_index do |contact, index|
        puts "  #{index + 1}. #{contact}"
      end
    end
  end
end

# Main Program
puts "=" * 70
puts " " * 20 + "CONTACT MANAGER"
puts "=" * 70

manager = ContactManager.new

# Add contacts
puts "\nAdding contacts..."
manager.add_contact(Contact.new("Alice Johnson", "alice@example.com", "555-0001", [:friend, :work]))
manager.add_contact(Contact.new("Bob Smith", "bob@gmail.com", "555-0002", [:friend, :hobby]))
manager.add_contact(Contact.new("Charlie Brown", "charlie@work.com", "555-0003", [:work, :client]))
manager.add_contact(Contact.new("Diana Prince", "diana@example.com", "555-0004", [:friend]))
manager.add_contact(Contact.new("Eve Adams", "eve@startup.io", "555-0005", [:work, :startup, :friend]))

# List all contacts
manager.list_all

# Search by name
puts "\n" + "=" * 70
puts "SEARCH BY NAME"
puts "=" * 70
results = manager.find_by_name("alice")
puts "\nSearching for 'alice':"
results.each { |c| puts "  → #{c}" }

# Search by tag
puts "\n" + "=" * 70
puts "SEARCH BY TAG"
puts "=" * 70
puts "\nContacts tagged with :work:"
manager.find_by_tag(:work).each { |c| puts "  → #{c}" }

puts "\nContacts tagged with :friend:"
manager.find_by_tag(:friend).each { |c| puts "  → #{c}" }

# Group by initial
puts "\n" + "=" * 70
puts "GROUPED BY INITIAL"
puts "=" * 70
manager.group_by_initial.each do |initial, contacts|
  puts "\n#{initial}:"
  contacts.each { |c| puts "  • #{c}" }
end

# Custom searches with blocks
puts "\n" + "=" * 70
puts "CUSTOM SEARCHES"
puts "=" * 70

puts "\nContacts with multiple tags:"
manager.find_where { |c| c.tags.length > 1 }.each { |c| puts "  → #{c}" }

puts "\nContacts with Gmail addresses:"
manager.find_where { |c| c.email.include?('@gmail.com') }.each { |c| puts "  → #{c}" }

has_startup = manager.any? { |c| c.has_tag?(:startup) }
puts "\nAny startup contacts? #{has_startup}"

# Statistics
puts "\n" + "=" * 70
puts "STATISTICS"
puts "=" * 70
manager.statistics

puts "\n" + "=" * 70
