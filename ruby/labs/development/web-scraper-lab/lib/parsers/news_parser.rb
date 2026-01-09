# frozen_string_literal: true

require_relative 'html_parser'
require_relative '../models/article'

# NewsParser implements parsing logic for news-style websites.
# It expects HTML with article elements containing headline, byline, etc.
#
# Expected HTML structure:
#   <div class="article">
#     <h3 class="headline"><a href="/article">Headline</a></h3>
#     <p class="byline">By <span class="author">Reporter Name</span></p>
#     <time class="timestamp">2024-01-01T12:00:00Z</time>
#     <p class="summary">Article summary...</p>
#   </div>
#
# Example:
#   parser = NewsParser.new
#   article_data = parser.parse(html)
class NewsParser < HtmlParser
  # CSS selectors for news elements
  SELECTORS = {
    articles: '.article, article, .news-item',
    headline: '.headline a, .headline, h3 a, h2 a',
    headline_link: '.headline a, h3 a, h2 a',
    byline: '.byline, .by, .author-line',
    author: '.author, .reporter, [itemprop="author"]',
    timestamp: '.timestamp, time, .published, [itemprop="datePublished"]',
    summary: '.summary, .lead, .description',
    body: '.article-body, .story-body, .content'
  }.freeze

  # Parses news HTML and returns article data
  #
  # @param html [String] HTML content
  # @return [Array<Hash>] Array of article data hashes
  def parse(html)
    doc = document(html)
    articles = doc.css(SELECTORS[:articles])

    articles.map do |article_element|
      parse_article(article_element, doc)
    end.compact
  rescue StandardError => e
    raise ParseError, "Failed to parse news HTML: #{e.message}"
  end

  private

  # Parses a single article element
  #
  # @param element [Nokogiri::XML::Element] Article element
  # @param doc [Nokogiri::HTML::Document] Full document
  # @return [Hash, nil] Article data hash or nil if invalid
  def parse_article(element, doc)
    headline_element = element.at_css(SELECTORS[:headline])
    title = extract_text(headline_element)

    return nil if title.nil? || title.empty?

    link_element = element.at_css(SELECTORS[:headline_link]) || headline_element
    url = extract_attribute(link_element, 'href')

    return nil if url.nil? || url.empty?

    article_data = {
      title: title,
      url: url,
      author: extract_author(element),
      published_at: extract_published_date(element),
      excerpt: extract_text(element.at_css(SELECTORS[:summary])),
      content: extract_text(element.at_css(SELECTORS[:body]))
    }

    validate_article_data(article_data)
    article_data
  rescue ParseError => e
    warn "Skipping invalid article: #{e.message}"
    nil
  end

  # Extracts author from article element
  # Handles both direct author elements and byline parsing
  #
  # @param element [Nokogiri::XML::Element]
  # @return [String, nil]
  def extract_author(element)
    # Try direct author element first
    author_element = element.at_css(SELECTORS[:author])
    return extract_text(author_element) if author_element

    # Try extracting from byline
    byline_element = element.at_css(SELECTORS[:byline])
    return nil unless byline_element

    byline_text = extract_text(byline_element)
    extract_author_from_byline(byline_text)
  end

  # Extracts author name from byline text
  # Handles formats like "By John Doe" or "John Doe, Reporter"
  #
  # @param byline [String]
  # @return [String, nil]
  def extract_author_from_byline(byline)
    return nil if byline.nil? || byline.empty?

    # Remove common prefixes
    author = byline.gsub(/^By\s+/i, '')
                   .gsub(/^Written by\s+/i, '')
                   .split(',').first # Remove suffixes like ", Reporter"
                   .strip

    author.empty? ? nil : author
  end

  # Extracts and parses publication date
  #
  # @param element [Nokogiri::XML::Element]
  # @return [Time, nil]
  def extract_published_date(element)
    date_element = element.at_css(SELECTORS[:timestamp])
    return nil if date_element.nil?

    # Try various date attributes
    date_string = date_element['datetime'] ||
                  date_element['content'] ||
                  extract_text(date_element)

    parse_date(date_string)
  end
end
