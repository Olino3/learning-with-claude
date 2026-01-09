# Lab 2: Web Scraper

A production-quality web scraping application demonstrating advanced Ruby design patterns including Service Objects, Decorator Pattern, and Strategy Pattern.

## Learning Objectives

After completing this lab, you will understand:

- **Service Objects**: Encapsulate complex business logic
- **Decorator Pattern**: Add functionality to objects dynamically
- **Strategy Pattern**: Interchangeable parsing algorithms
- **Web Scraping**: Using Nokogiri and HTTParty
- **HTTP Mocking**: Testing with WebMock and VCR
- **Error Handling**: Robust error handling for network operations
- **Separation of Concerns**: Clean architecture with distinct layers

## Project Structure

```
web-scraper-lab/
├── bin/
│   └── scraper               # CLI entry point
├── lib/
│   ├── web_scraper.rb        # Main orchestrator
│   ├── services/
│   │   └── scrape_service.rb # Core scraping logic
│   ├── decorators/
│   │   └── article_decorator.rb # Decorator for formatting
│   ├── models/
│   │   └── article.rb        # Article entity
│   └── parsers/
│       ├── html_parser.rb    # Base parser
│       ├── blog_parser.rb    # Blog-specific parser
│       └── news_parser.rb    # News-specific parser
├── spec/
│   ├── spec_helper.rb
│   ├── fixtures/             # Mock HTML responses
│   ├── web_scraper_spec.rb
│   └── ...
├── .rspec
├── .rubocop.yml
├── Gemfile
├── Rakefile
└── README.md
```

## Design Patterns Demonstrated

### 1. Service Object Pattern
The `ScrapeService` encapsulates the complex logic of fetching and parsing web content. This keeps the main `WebScraper` class simple and focused.

```ruby
# Service handles all scraping logic
service = ScrapeService.new(parser: BlogParser.new)
articles = service.scrape(url)
```

### 2. Decorator Pattern
The `ArticleDecorator` adds presentation logic to Article objects without modifying the Article class.

```ruby
# Decorate article for enhanced display
decorated = ArticleDecorator.new(article)
puts decorated.formatted_title  # Adds formatting
puts decorated.summary          # Generates summary
```

### 3. Strategy Pattern
Different parser strategies can be swapped at runtime for different website structures.

```ruby
# Use different parsers for different sites
blog_parser = BlogParser.new
news_parser = NewsParser.new

service = ScrapeService.new(parser: blog_parser)
```

## Setup Instructions

### Prerequisites
- Ruby 3.0 or higher
- Bundler gem installed

### Installation

1. **Navigate to the lab directory**:
   ```bash
   cd ruby/labs/development/web-scraper-lab
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Run tests to verify setup**:
   ```bash
   bundle exec rspec
   ```

4. **Make the CLI executable** (optional):
   ```bash
   chmod +x bin/scraper
   ```

## Usage Examples

### Using the CLI

```bash
# Scrape a blog
./bin/scraper blog https://example.com/blog

# Scrape a news site
./bin/scraper news https://example.com/news

# Save results to file
./bin/scraper blog https://example.com/blog --output results.json

# Specify maximum articles
./bin/scraper blog https://example.com/blog --limit 10
```

### Programmatic Usage

```ruby
require_relative 'lib/web_scraper'

# Create scraper with blog parser
scraper = WebScraper.new(parser_type: :blog)

# Scrape articles
articles = scraper.scrape('https://example.com/blog')

# Display with decorator
articles.each do |article|
  decorated = ArticleDecorator.new(article)
  puts decorated.formatted_output
end

# Convert to different formats
puts articles.first.to_json
puts articles.first.to_csv
```

### Using Different Parsers

```ruby
# Create scraper with news parser
news_scraper = WebScraper.new(parser_type: :news)
news_articles = news_scraper.scrape('https://news-site.com')

# Or inject custom parser
custom_parser = MyCustomParser.new
scraper = WebScraper.new(parser: custom_parser)
```

## Testing Instructions

### Run All Tests

```bash
bundle exec rspec
```

### Run with Mocked HTTP Responses

Tests use WebMock to mock HTTP requests, so no real network calls are made:

```ruby
# Tests automatically use mocked responses
RSpec.describe ScrapeService do
  it 'scrapes articles' do
    # WebMock intercepts this and returns fixture data
    articles = service.scrape('https://example.com')
    expect(articles.size).to eq(5)
  end
end
```

### Using VCR for Real Request Recording

```bash
# Record real HTTP interactions (once)
VCR_MODE=all bundle exec rspec

# Then replay them in future tests
bundle exec rspec
```

### Run Specific Tests

```bash
bundle exec rspec spec/services/scrape_service_spec.rb
bundle exec rspec spec/decorators/article_decorator_spec.rb
```

### Coverage Report

```bash
bundle exec rspec
open coverage/index.html
```

## Key Components Explained

### Article Model (Entity)
A simple data structure representing a scraped article:

```ruby
article = Article.new(
  title: 'Understanding Ruby',
  url: 'https://example.com/article',
  author: 'Jane Doe',
  published_at: Time.now,
  content: 'Full article content...'
)
```

### HTML Parser (Strategy Pattern)
Base class for parsing strategies:

```ruby
class HtmlParser
  def parse(html)
    raise NotImplementedError
  end
end

class BlogParser < HtmlParser
  def parse(html)
    # Blog-specific parsing logic
  end
end
```

### Scrape Service (Service Object)
Coordinates fetching and parsing:

```ruby
service = ScrapeService.new(
  parser: BlogParser.new,
  max_retries: 3,
  timeout: 30
)

articles = service.scrape(url)
```

### Article Decorator
Adds formatting without modifying Article:

```ruby
decorator = ArticleDecorator.new(article)
decorator.formatted_title    # "★ Understanding Ruby ★"
decorator.summary(100)        # First 100 chars + "..."
decorator.reading_time        # "5 min read"
```

## Extending the Lab

### Beginner Exercises
1. Add a `category` field to Articles
2. Implement filtering by date range
3. Add a `tags` array to Articles
4. Create a `PlainTextDecorator` for terminal output

### Intermediate Exercises
5. Implement a `ForumParser` for forum websites
6. Add pagination support (scrape multiple pages)
7. Create an `HTMLDecorator` for generating HTML output
8. Add rate limiting to prevent overwhelming servers

### Advanced Exercises
9. Implement concurrent scraping with threads
10. Add a caching layer (Redis or file-based)
11. Create a DSL for defining parsers declaratively
12. Implement content deduplication

## Error Handling

The scraper includes robust error handling:

```ruby
begin
  articles = scraper.scrape(url)
rescue WebScraper::NetworkError => e
  puts "Network error: #{e.message}"
  retry if e.retryable?
rescue WebScraper::ParseError => e
  puts "Parse error: #{e.message}"
  # Log and continue
end
```

## Best Practices Demonstrated

1. **Dependency Injection**: Parsers are injected, not hard-coded
2. **Interface Segregation**: Small, focused classes
3. **Open/Closed Principle**: Easy to extend with new parsers
4. **Single Responsibility**: Each class has one clear purpose
5. **DRY**: Shared logic in base classes
6. **Testability**: All components are easily testable

## Common Issues & Solutions

### Issue: "Connection refused" errors
**Solution**: Tests use WebMock, so this shouldn't happen. If it does, check that WebMock is properly configured in `spec_helper.rb`.

### Issue: "No route matches" in parser
**Solution**: Update the parser's CSS selectors to match the HTML structure in the fixtures.

### Issue: Empty results
**Solution**: Check that the HTML fixtures in `spec/fixtures/` contain the expected structure.

## Real-World Applications

This lab demonstrates patterns used in production scrapers for:

- **Price monitoring**: Track product prices across websites
- **News aggregation**: Collect articles from multiple sources
- **Job boards**: Aggregate job listings
- **Real estate**: Monitor property listings
- **Academic research**: Collect data for analysis

## Additional Resources

- [Nokogiri Documentation](https://nokogiri.org/)
- [HTTParty GitHub](https://github.com/jnunemaker/httparty)
- [WebMock Documentation](https://github.com/bblimke/webmock)
- [Decorator Pattern](https://refactoring.guru/design-patterns/decorator)
- [Strategy Pattern](https://refactoring.guru/design-patterns/strategy)

## Ethical Scraping Guidelines

When scraping websites, always:

1. Check the website's `robots.txt` file
2. Respect rate limits and add delays between requests
3. Identify your bot with a proper User-Agent
4. Cache responses to minimize requests
5. Comply with the website's Terms of Service

## License

This lab is part of the Learning with Claude Ruby curriculum and is provided for educational purposes.
