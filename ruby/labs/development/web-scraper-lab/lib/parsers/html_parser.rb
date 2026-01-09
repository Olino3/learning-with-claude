# frozen_string_literal: true

require 'nokogiri'

# HtmlParser is the base class for all parser strategies.
# It implements the Strategy Pattern, allowing different parsing
# algorithms to be swapped at runtime.
#
# Design Patterns:
# - Strategy Pattern: Defines a family of algorithms
# - Template Method: Defines the skeleton of parsing operation
#
# Example:
#   class CustomParser < HtmlParser
#     def parse(html)
#       # Custom parsing logic
#     end
#   end
class HtmlParser
  # Custom error for parsing failures
  class ParseError < StandardError; end

  # Parses HTML and returns an array of Article data hashes
  # Subclasses must implement this method
  #
  # @param html [String] The HTML content to parse
  # @return [Array<Hash>] Array of article data hashes
  # @raise [NotImplementedError] if not overridden
  def parse(html)
    raise NotImplementedError, "#{self.class} must implement #parse"
  end

  protected

  # Helper: Creates a Nokogiri document from HTML
  #
  # @param html [String] HTML content
  # @return [Nokogiri::HTML::Document]
  def document(html)
    Nokogiri::HTML(html)
  end

  # Helper: Extracts text from element, removing extra whitespace
  #
  # @param element [Nokogiri::XML::Element, nil] The element to extract from
  # @return [String, nil] Cleaned text or nil
  def extract_text(element)
    return nil if element.nil?

    element.text.strip.gsub(/\s+/, ' ')
  end

  # Helper: Extracts attribute from element
  #
  # @param element [Nokogiri::XML::Element, nil] The element
  # @param attribute [String] The attribute name
  # @return [String, nil] Attribute value or nil
  def extract_attribute(element, attribute)
    return nil if element.nil?

    element[attribute]
  end

  # Helper: Parses date from text
  #
  # @param date_text [String, nil] Date string
  # @return [Time, nil] Parsed time or nil
  def parse_date(date_text)
    return nil if date_text.nil? || date_text.strip.empty?

    Time.parse(date_text)
  rescue ArgumentError
    nil
  end

  # Helper: Validates that required fields are present
  #
  # @param article_data [Hash] Article data hash
  # @raise [ParseError] if validation fails
  def validate_article_data(article_data)
    raise ParseError, 'Article must have a title' if article_data[:title].nil? || article_data[:title].empty?
    raise ParseError, 'Article must have a URL' if article_data[:url].nil? || article_data[:url].empty?
  end

  # Helper: Ensures URL is absolute
  #
  # @param url [String] URL (relative or absolute)
  # @param base_url [String] Base URL for resolving relative URLs
  # @return [String] Absolute URL
  def absolute_url(url, base_url)
    return url if url.start_with?('http://', 'https://')

    URI.join(base_url, url).to_s
  rescue URI::InvalidURIError
    url
  end
end
