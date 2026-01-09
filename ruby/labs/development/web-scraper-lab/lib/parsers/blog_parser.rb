# frozen_string_literal: true

require_relative 'html_parser'
require_relative '../models/article'

# BlogParser implements parsing logic for blog-style websites.
# It expects HTML with article elements containing title, author, date, etc.
#
# Expected HTML structure:
#   <article class="post">
#     <h2 class="post-title"><a href="/article-url">Title</a></h2>
#     <div class="post-meta">
#       <span class="author">Author Name</span>
#       <time datetime="2024-01-01">Jan 1, 2024</time>
#     </div>
#     <div class="post-excerpt">Article excerpt...</div>
#     <div class="post-content">Full content...</div>
#   </article>
#
# Example:
#   parser = BlogParser.new
#   article_data = parser.parse(html)
class BlogParser < HtmlParser
  # CSS selectors for blog elements
  SELECTORS = {
    articles: 'article.post',
    title: 'h2.post-title a, h2.post-title',
    title_link: 'h2.post-title a',
    author: '.post-meta .author, .author, [rel="author"]',
    date: 'time, .post-date, .published',
    excerpt: '.post-excerpt, .excerpt',
    content: '.post-content, .entry-content, .content'
  }.freeze

  # Parses blog HTML and returns article data
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
    raise ParseError, "Failed to parse blog HTML: #{e.message}"
  end

  private

  # Parses a single article element
  #
  # @param element [Nokogiri::XML::Element] Article element
  # @param doc [Nokogiri::HTML::Document] Full document (for base URL)
  # @return [Hash, nil] Article data hash or nil if invalid
  def parse_article(element, doc)
    title_element = element.at_css(SELECTORS[:title])
    title = extract_text(title_element)

    return nil if title.nil? || title.empty?

    link_element = element.at_css(SELECTORS[:title_link]) || title_element
    url = extract_attribute(link_element, 'href')

    return nil if url.nil? || url.empty?

    article_data = {
      title: title,
      url: url,
      author: extract_author(element),
      published_at: extract_published_date(element),
      excerpt: extract_text(element.at_css(SELECTORS[:excerpt])),
      content: extract_text(element.at_css(SELECTORS[:content]))
    }

    validate_article_data(article_data)
    article_data
  rescue ParseError => e
    warn "Skipping invalid article: #{e.message}"
    nil
  end

  # Extracts author from article element
  #
  # @param element [Nokogiri::XML::Element]
  # @return [String, nil]
  def extract_author(element)
    author_element = element.at_css(SELECTORS[:author])
    extract_text(author_element)
  end

  # Extracts and parses publication date
  #
  # @param element [Nokogiri::XML::Element]
  # @return [Time, nil]
  def extract_published_date(element)
    date_element = element.at_css(SELECTORS[:date])
    return nil if date_element.nil?

    # Try datetime attribute first (semantic HTML)
    date_string = date_element['datetime'] || extract_text(date_element)
    parse_date(date_string)
  end
end
