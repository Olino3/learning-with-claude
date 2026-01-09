# frozen_string_literal: true

require 'json'
require 'time'

# Article represents a scraped article entity.
# It's a simple data object (Value Object) that holds article information.
#
# Design Patterns:
# - Value Object: Immutable data structure
# - Data Transfer Object: Moves data between layers
#
# Example:
#   article = Article.new(
#     title: 'Ruby Tips',
#     url: 'https://example.com/ruby-tips',
#     author: 'Jane Doe'
#   )
class Article
  attr_reader :title, :url, :author, :published_at, :content, :excerpt

  # Creates a new Article instance
  #
  # @param title [String] Article title (required)
  # @param url [String] Article URL (required)
  # @param author [String] Author name (optional)
  # @param published_at [Time] Publication date (optional)
  # @param content [String] Full article content (optional)
  # @param excerpt [String] Article excerpt/summary (optional)
  def initialize(title:, url:, author: nil, published_at: nil, content: '', excerpt: '')
    @title = title
    @url = url
    @author = author
    @published_at = published_at
    @content = content
    @excerpt = excerpt

    validate!
    freeze # Make immutable
  end

  # Checks if article has an author
  #
  # @return [Boolean]
  def has_author?
    !author.nil? && !author.strip.empty?
  end

  # Checks if article has publication date
  #
  # @return [Boolean]
  def has_published_date?
    !published_at.nil?
  end

  # Checks if article has content
  #
  # @return [Boolean]
  def has_content?
    !content.nil? && !content.strip.empty?
  end

  # Returns word count of content
  #
  # @return [Integer]
  def word_count
    return 0 unless has_content?

    content.split.size
  end

  # Estimates reading time in minutes
  # Assumes 200 words per minute
  #
  # @return [Integer]
  def reading_time_minutes
    return 0 unless has_content?

    (word_count / 200.0).ceil
  end

  # Converts article to hash
  #
  # @return [Hash]
  def to_h
    {
      title: title,
      url: url,
      author: author,
      published_at: published_at&.iso8601,
      content: content,
      excerpt: excerpt,
      word_count: word_count,
      reading_time: reading_time_minutes
    }
  end

  # Converts article to JSON
  #
  # @return [String]
  def to_json(*_args)
    JSON.generate(to_h)
  end

  # Converts article to CSV row
  #
  # @return [String]
  def to_csv
    [
      escape_csv(title),
      url,
      escape_csv(author || ''),
      published_at&.iso8601 || '',
      word_count
    ].join(',')
  end

  # String representation
  #
  # @return [String]
  def to_s
    author_str = has_author? ? " by #{author}" : ''
    "#{title}#{author_str} - #{url}"
  end

  # Detailed inspection
  #
  # @return [String]
  def inspect
    "#<Article title=\"#{title}\" url=\"#{url}\" author=\"#{author}\">"
  end

  # Creates an Article from a hash
  #
  # @param hash [Hash] Article data
  # @return [Article]
  def self.from_h(hash)
    new(
      title: hash[:title] || hash['title'],
      url: hash[:url] || hash['url'],
      author: hash[:author] || hash['author'],
      published_at: parse_time(hash[:published_at] || hash['published_at']),
      content: hash[:content] || hash['content'] || '',
      excerpt: hash[:excerpt] || hash['excerpt'] || ''
    )
  end

  # CSV header row
  #
  # @return [String]
  def self.csv_header
    'Title,URL,Author,Published At,Word Count'
  end

  private

  # Validates article attributes
  #
  # @raise [ArgumentError] if validation fails
  def validate!
    raise ArgumentError, 'Title cannot be empty' if title.nil? || title.strip.empty?
    raise ArgumentError, 'URL cannot be empty' if url.nil? || url.strip.empty?
    raise ArgumentError, 'Invalid URL format' unless valid_url?(url)
  end

  # Checks if URL is valid
  #
  # @param url [String]
  # @return [Boolean]
  def valid_url?(url)
    url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  end

  # Escapes CSV fields
  #
  # @param field [String]
  # @return [String]
  def escape_csv(field)
    return '' if field.nil?

    # Escape quotes and wrap in quotes if needed
    if field.include?(',') || field.include?('"') || field.include?("\n")
      "\"#{field.gsub('"', '""')}\""
    else
      field
    end
  end

  # Parses time from string or returns time object
  #
  # @param time [String, Time, nil]
  # @return [Time, nil]
  def self.parse_time(time)
    return nil if time.nil?
    return time if time.is_a?(Time)

    Time.parse(time)
  rescue ArgumentError
    nil
  end
end
