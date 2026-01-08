#!/usr/bin/env ruby
# Blog Management System - Comprehensive Intermediate Ruby Lab
# This demonstrates all intermediate Ruby concepts in one application

require_relative 'lib/errors/custom_errors'
require_relative 'lib/database/query_builder'
require_relative 'lib/models/user'
require_relative 'lib/models/post'
require_relative 'lib/models/comment'

puts "=" * 60
puts "BLOG MANAGEMENT SYSTEM - Intermediate Ruby Lab"
puts "=" * 60
puts

# Clean slate
BlogSystem::User.clear_all
BlogSystem::Post.clear_all
BlogSystem::Comment.clear_all

# ============================================================================
# SECTION 1: Mixins and Modules (Tutorial 13)
# ============================================================================
puts "SECTION 1: Mixins and Modules"
puts "-" * 60

puts "Creating users with Timestampable, Validatable concerns..."

alice = BlogSystem::User.create(
  name: "Alice Smith",
  email: "alice@example.com",
  bio: "Ruby developer and blogger"
)

bob = BlogSystem::User.create(
  name: "Bob Jones",
  email: "bob@example.com",
  bio: "Tech enthusiast"
)

puts "✓ #{alice}"
puts "  Created at: #{alice.created_at}"
puts "✓ #{bob}"
puts

# Validation example
puts "Testing validation (invalid email)..."
invalid_user = BlogSystem::User.create(
  name: "Invalid",
  email: "not-an-email"  # Missing @
)
puts "  Result: #{invalid_user.inspect}" if invalid_user.nil?
puts

# ============================================================================
# SECTION 2: Metaprogramming (Tutorial 14)
# ============================================================================
puts "SECTION 2: Metaprogramming - Dynamic Finders"
puts "-" * 60

found = BlogSystem::User.find_by_email("alice@example.com")
puts "✓ find_by_email('alice@example.com'): #{found.name}"

found = BlogSystem::User.find_by_name("Bob Jones")
puts "✓ find_by_name('Bob Jones'): #{found.email}"
puts

# ============================================================================
# SECTION 3: Blocks, Procs, and Lambdas (Tutorial 11)
# ============================================================================
puts "SECTION 3: Closures - Creating Posts with Validation"
puts "-" * 60

post1 = BlogSystem::Post.create(
  title: "Getting Started with Ruby",
  content: "Ruby is an elegant language that emphasizes simplicity and productivity. In this post, we'll explore the basics.",
  author_id: alice.id,
  published: true
)

post2 = BlogSystem::Post.create(
  title: "Advanced Ruby Patterns",
  content: "Once you master the basics, Ruby opens up a world of powerful patterns including metaprogramming and DSLs.",
  author_id: alice.id,
  published: true
)

post3 = BlogSystem::Post.create(
  title: "Ruby vs Python: A Comparison",
  content: "Both languages are excellent for different reasons. Let's compare their approaches to common problems.",
  author_id: bob.id,
  published: false
)

puts "✓ Created post: #{post1.title}"
puts "  Slug: #{post1.slug}"
puts "  Author: #{post1.author.name}"
puts "✓ Created post: #{post2.title}"
puts "✓ Created post: #{post3.title} (draft)"
puts

# ============================================================================
# SECTION 4: Idiomatic Ruby - Enumerable and Chaining (Tutorial 16)
# ============================================================================
puts "SECTION 4: Idiomatic Ruby - Query Chaining"
puts "-" * 60

# Method chaining with query builder
published_posts = BlogSystem::Post
  .where(published: true)
  .order_by(:created_at, :desc)
  .all

puts "Published posts (chainable query):"
published_posts.each do |post|
  puts "  - #{post.title} by #{post.author.name}"
end
puts

# Using blocks for complex queries
alice_posts = BlogSystem::Post.search do |post|
  post.author_id == alice.id && post.published
end

puts "Alice's published posts (using closures):"
alice_posts.each do |post|
  puts "  - #{post.title}"
end
puts

# ============================================================================
# SECTION 5: Duck Typing and Enumerable (Tutorial 16)
# ============================================================================
puts "SECTION 5: Duck Typing - Enumerable Operations"
puts "-" * 60

# Map: transform collection
titles = BlogSystem::Post.all
  .map(&:title)
  .map(&:upcase)

puts "All post titles (uppercased):"
titles.each { |title| puts "  • #{title}" }
puts

# Select: filter collection
long_posts = BlogSystem::Post.all
  .select { |p| p.content.length > 100 }

puts "Long posts (content > 100 chars): #{long_posts.count}"
puts

# Reduce: aggregate values
total_views = BlogSystem::Post.all
  .map { |p| p.increment_views.view_count }
  .reduce(:+)

puts "Total views across all posts: #{total_views}"
puts

# ============================================================================
# SECTION 6: Error Handling (Tutorial 15)
# ============================================================================
puts "SECTION 6: Error Handling"
puts "-" * 60

begin
  # Try to find non-existent post
  BlogSystem::Post.find(999)
rescue BlogSystem::NotFoundError => e
  puts "✗ #{e.full_message}"
end

begin
  # Try to create invalid post
  BlogSystem::Post.create(
    title: "Too short",  # Less than 5 characters
    content: "Also too short",  # Less than 10 characters
    author_id: alice.id
  )
rescue BlogSystem::ValidationError => e
  puts "✗ Validation failed: #{e.errors.inspect}"
end

begin
  # Try to publish already published post
  post1.publish!
rescue BlogSystem::PermissionError => e
  puts "✗ #{e.message}"
end
puts

# ============================================================================
# SECTION 7: Comments System
# ============================================================================
puts "SECTION 7: Comments with Nested Relationships"
puts "-" * 60

comment1 = BlogSystem::Comment.create(
  content: "Great post! Very informative.",
  author_id: bob.id,
  post_id: post1.id
)

comment2 = BlogSystem::Comment.create(
  content: "Thanks for the feedback!",
  author_id: alice.id,
  post_id: post1.id,
  parent_id: comment1.id  # Reply to comment1
)

puts "✓ Comment by #{comment1.author.name}: '#{comment1.content}'"
puts "  └─ Reply by #{comment2.author.name}: '#{comment2.content}'"
puts

# ============================================================================
# SECTION 8: Memoization (Tutorial 16)
# ============================================================================
puts "SECTION 8: Memoization"
puts "-" * 60

puts "First call to post1.author (loads from User):"
author1 = post1.author
puts "  Author: #{author1.name}"

puts "Second call to post1.author (memoized):"
author2 = post1.author
puts "  Author: #{author2.name}"
puts "  Same object? #{author1.object_id == author2.object_id}"
puts

# ============================================================================
# SECTION 9: Complex Queries with Closures (Tutorial 11)
# ============================================================================
puts "SECTION 9: Complex Queries with Closures"
puts "-" * 60

# Use closure to filter
alice_long_posts = alice.filter_posts do |post|
  post.content.length > 100 && post.published
end

puts "Alice's long published posts:"
alice_long_posts.each do |post|
  puts "  - #{post.title} (#{post.content.length} chars)"
end
puts

# ============================================================================
# SECTION 10: Object Model - Class Methods (Tutorial 12)
# ============================================================================
puts "SECTION 10: Object Model - Class vs Instance"
puts "-" * 60

puts "Class methods (singleton class):"
puts "  Total users: #{BlogSystem::User.all.count}"
puts "  Total posts: #{BlogSystem::Post.all.count}"
puts "  Published posts: #{BlogSystem::Post.published.count}"
puts "  Total comments: #{BlogSystem::Comment.all.count}"
puts

# ============================================================================
# SECTION 11: Practical Example - Dashboard
# ============================================================================
puts "SECTION 11: Dashboard - Idiomatic Ruby Showcase"
puts "-" * 60

dashboard_data = {
  total_users: BlogSystem::User.all.count,
  total_posts: BlogSystem::Post.all.count,
  published_posts: BlogSystem::Post.published.count,
  total_comments: BlogSystem::Comment.all.count,
  top_authors: BlogSystem::Post.all
    .group_by(&:author_id)
    .transform_values(&:count)
    .sort_by { |_, count| -count }
    .first(3)
    .map { |author_id, count|
      author = BlogSystem::User.find(author_id)
      { name: author.name, posts: count }
    },
  recent_posts: BlogSystem::Post
    .where(published: true)
    .order_by(:created_at, :desc)
    .limit(3)
    .all
    .map { |p| { title: p.title, author: p.author.name, views: p.view_count } }
}

puts "Dashboard Statistics:"
puts "  Users: #{dashboard_data[:total_users]}"
puts "  Posts: #{dashboard_data[:total_posts]} (#{dashboard_data[:published_posts]} published)"
puts "  Comments: #{dashboard_data[:total_comments]}"
puts

puts "Top Authors:"
dashboard_data[:top_authors].each do |author|
  puts "  - #{author[:name]}: #{author[:posts]} posts"
end
puts

puts "Recent Posts:"
dashboard_data[:recent_posts].each do |post|
  puts "  - '#{post[:title]}' by #{post[:author]} (#{post[:views]} views)"
end
puts

# ============================================================================
# SUMMARY
# ============================================================================
puts "=" * 60
puts "LAB COMPLETE - All Intermediate Concepts Demonstrated!"
puts "=" * 60
puts
puts "Concepts covered:"
puts "  ✓ Tutorial 11: Blocks, Procs, and Lambdas (closures, filters)"
puts "  ✓ Tutorial 12: Ruby Object Model (class methods, inheritance)"
puts "  ✓ Tutorial 13: Mixins and Modules (concerns, shared behavior)"
puts "  ✓ Tutorial 14: Metaprogramming (dynamic finders, DSL)"
puts "  ✓ Tutorial 15: Error Handling (custom exceptions, validation)"
puts "  ✓ Tutorial 16: Idiomatic Ruby (enumerable, chaining, memoization)"
puts
puts "🎉 Congratulations on completing the intermediate Ruby lab!"
puts
