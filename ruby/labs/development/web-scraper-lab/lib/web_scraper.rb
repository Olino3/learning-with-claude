# frozen_string_literal: true

require_relative 'services/scrape_service'
require_relative 'parsers/blog_parser'
require_relative 'parsers/news_parser'
require_relative 'decorators/article_decorator'

# WebScraper is the main facade that provides a simple interface
# to the web scraping subsystem.
#
# Design Patterns:
# - Facade Pattern: Provides simplified interface to complex subsystem
# - Factory Pattern: Creates appropriate parser based on type
#
# Example:
#   scraper = WebScraper.new(parser_type: :blog)
#   articles = scraper.scrape('https://example.com')
#
#   # With decorator
#   articles.each do |article|
#     decorated = scraper.decorate(article)
#     puts decorated.formatted_output
#   end
class WebScraper
  attr_reader :service, :parser

  # Available parser types
  PARSER_TYPES = {
    blog: BlogParser,
    news: NewsParser
  }.freeze

  # Creates a new WebScraper
  #
  # @param parser_type [Symbol] Type of parser (:blog or :news)
  # @param parser [HtmlParser] Custom parser instance (overrides parser_type)
  # @param options [Hash] Additional options for ScrapeService
  def initialize(parser_type: :blog, parser: nil, **options)
    @parser = parser || create_parser(parser_type)
    @service = ScrapeService.new(parser: @parser, **options)
  end

  # Scrapes a URL and returns Article objects
  #
  # @param url [String] URL to scrape
  # @return [Array<Article>] Array of scraped articles
  def scrape(url)
    service.scrape(url)
  end

  # Decorates an article with presentation logic
  #
  # @param article [Article] Article to decorate
  # @return [ArticleDecorator] Decorated article
  def decorate(article)
    ArticleDecorator.new(article)
  end

  # Scrapes and returns decorated articles
  #
  # @param url [String] URL to scrape
  # @return [Array<ArticleDecorator>] Array of decorated articles
  def scrape_and_decorate(url)
    scrape(url).map { |article| decorate(article) }
  end

  # Exports articles to JSON
  #
  # @param articles [Array<Article>] Articles to export
  # @return [String] JSON string
  def export_json(articles)
    require 'json'
    JSON.pretty_generate(articles.map(&:to_h))
  end

  # Exports articles to CSV
  #
  # @param articles [Array<Article>] Articles to export
  # @return [String] CSV string
  def export_csv(articles)
    lines = [Article.csv_header]
    lines += articles.map(&:to_csv)
    lines.join("\n")
  end

  # Saves articles to a file
  #
  # @param articles [Array<Article>] Articles to save
  # @param filename [String] Output filename
  # @param format [Symbol] Format (:json or :csv)
  def save_to_file(articles, filename, format: :json)
    content = case format
              when :json
                export_json(articles)
              when :csv
                export_csv(articles)
              else
                raise ArgumentError, "Unsupported format: #{format}"
              end

    File.write(filename, content)
  end

  private

  # Creates a parser based on type
  #
  # @param type [Symbol] Parser type
  # @return [HtmlParser] Parser instance
  def create_parser(type)
    parser_class = PARSER_TYPES[type]
    raise ArgumentError, "Unknown parser type: #{type}" unless parser_class

    parser_class.new
  end
end
