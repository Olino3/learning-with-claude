# frozen_string_literal: true

require_relative '../models/article'

# ArticleDecorator adds presentation logic to Article objects without
# modifying the Article class itself.
#
# Design Patterns:
# - Decorator Pattern: Adds functionality to objects dynamically
# - Single Responsibility: Article handles data, Decorator handles presentation
#
# Example:
#   article = Article.new(title: 'Ruby Tips', url: 'https://...')
#   decorated = ArticleDecorator.new(article)
#   puts decorated.formatted_title  # "★ Ruby Tips ★"
#   puts decorated.summary(50)       # First 50 chars + "..."
class ArticleDecorator
  attr_reader :article

  # Creates a new decorator for an article
  #
  # @param article [Article] The article to decorate
  def initialize(article)
    @article = article
  end

  # Delegates missing methods to the wrapped article
  def method_missing(method_name, *args, &block)
    if article.respond_to?(method_name)
      article.send(method_name, *args, &block)
    else
      super
    end
  end

  # Responds to methods from the wrapped article
  def respond_to_missing?(method_name, include_private = false)
    article.respond_to?(method_name) || super
  end

  # Returns a formatted title with decoration
  #
  # @return [String]
  def formatted_title
    "★ #{article.title} ★"
  end

  # Returns a summary of content
  # Truncates content to specified length and adds ellipsis
  #
  # @param max_length [Integer] Maximum length (default: 100)
  # @return [String]
  def summary(max_length = 100)
    text = article.excerpt.empty? ? article.content : article.excerpt
    return '' if text.empty?

    if text.length <= max_length
      text
    else
      "#{text[0...max_length].strip}..."
    end
  end

  # Returns reading time as formatted string
  #
  # @return [String]
  def reading_time
    minutes = article.reading_time_minutes
    return 'Less than 1 min read' if minutes.zero?

    "#{minutes} min read"
  end

  # Returns formatted publication date
  #
  # @return [String]
  def formatted_date
    return 'Date unknown' unless article.has_published_date?

    article.published_at.strftime('%B %d, %Y')
  end

  # Returns formatted byline
  #
  # @return [String]
  def byline
    parts = []
    parts << "By #{article.author}" if article.has_author?
    parts << formatted_date if article.has_published_date?

    parts.empty? ? 'No byline information' : parts.join(' • ')
  end

  # Returns a formatted output suitable for display
  #
  # @return [String]
  def formatted_output
    output = []
    output << formatted_title
    output << '=' * (article.title.length + 4)
    output << byline
    output << ''
    output << summary(200)
    output << ''
    output << "Read more: #{article.url}"
    output << "Reading time: #{reading_time}"

    output.join("\n")
  end

  # Returns a compact one-line summary
  #
  # @return [String]
  def one_liner
    author_part = article.has_author? ? " (#{article.author})" : ''
    "#{article.title}#{author_part} - #{summary(50)}"
  end

  # Returns a markdown-formatted representation
  #
  # @return [String]
  def to_markdown
    md = []
    md << "# #{article.title}"
    md << ''
    md << byline if article.has_author? || article.has_published_date?
    md << ''
    md << article.content unless article.content.empty?
    md << ''
    md << "[Read original article](#{article.url})"

    md.join("\n")
  end

  # Returns an HTML-formatted representation
  #
  # @return [String]
  def to_html
    html = []
    html << '<article>'
    html << "  <h1>#{escape_html(article.title)}</h1>"

    if article.has_author? || article.has_published_date?
      html << '  <div class="byline">'
      html << "    <span class=\"author\">#{escape_html(article.author)}</span>" if article.has_author?
      html << "    <time>#{formatted_date}</time>" if article.has_published_date?
      html << '  </div>'
    end

    unless article.content.empty?
      html << "  <div class=\"content\">#{escape_html(article.content)}</div>"
    end

    html << "  <a href=\"#{escape_html(article.url)}\">Read more</a>"
    html << '</article>'

    html.join("\n")
  end

  # Returns a styled terminal output with colors
  #
  # @param colors [Boolean] Whether to include ANSI colors (default: true)
  # @return [String]
  def to_terminal(colors: true)
    if colors
      title_color = "\e[1;36m" # Cyan, bold
      meta_color = "\e[0;33m"  # Yellow
      reset = "\e[0m"
    else
      title_color = meta_color = reset = ''
    end

    output = []
    output << "#{title_color}#{formatted_title}#{reset}"
    output << "#{meta_color}#{byline}#{reset}"
    output << ''
    output << summary(150)
    output << ''
    output << "#{article.url} (#{reading_time})"

    output.join("\n")
  end

  # Returns article statistics
  #
  # @return [Hash]
  def stats
    {
      title_length: article.title.length,
      has_author: article.has_author?,
      has_date: article.has_published_date?,
      has_content: article.has_content?,
      word_count: article.word_count,
      reading_time: reading_time,
      content_completeness: calculate_completeness
    }
  end

  private

  # Calculates content completeness as a percentage
  #
  # @return [Float]
  def calculate_completeness
    score = 0
    score += 25 if article.has_author?
    score += 25 if article.has_published_date?
    score += 25 if !article.excerpt.empty?
    score += 25 if article.has_content?

    score.to_f
  end

  # Escapes HTML entities
  #
  # @param text [String]
  # @return [String]
  def escape_html(text)
    return '' if text.nil?

    text.gsub('&', '&amp;')
        .gsub('<', '&lt;')
        .gsub('>', '&gt;')
        .gsub('"', '&quot;')
        .gsub("'", '&#39;')
  end
end
