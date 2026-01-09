# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ArticleDecorator do
  let(:article) do
    Article.new(
      title: 'Ruby Programming',
      url: 'https://example.com/ruby',
      author: 'Jane Doe',
      published_at: Time.parse('2024-01-15 10:00:00'),
      content: 'Ruby is a dynamic programming language that is easy to learn and powerful to use.',
      excerpt: 'Learn Ruby programming'
    )
  end

  let(:decorator) { described_class.new(article) }

  describe '#formatted_title' do
    it 'decorates the title' do
      expect(decorator.formatted_title).to eq('★ Ruby Programming ★')
    end
  end

  describe '#summary' do
    it 'returns full text when shorter than max_length' do
      short_article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        content: 'Short content'
      )
      decorator = described_class.new(short_article)

      expect(decorator.summary(100)).to eq('Short content')
    end

    it 'truncates long text with ellipsis' do
      summary = decorator.summary(20)

      expect(summary).to end_with('...')
      expect(summary.length).to be <= 23 # 20 + "..."
    end

    it 'prefers excerpt over content' do
      summary = decorator.summary(100)

      expect(summary).to eq('Learn Ruby programming')
    end

    it 'returns empty string when no content or excerpt' do
      minimal_article = Article.new(
        title: 'Test',
        url: 'https://example.com'
      )
      decorator = described_class.new(minimal_article)

      expect(decorator.summary).to eq('')
    end
  end

  describe '#reading_time' do
    it 'formats reading time for short articles' do
      short_article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        content: 'Short'
      )
      decorator = described_class.new(short_article)

      expect(decorator.reading_time).to eq('Less than 1 min read')
    end

    it 'formats reading time for longer articles' do
      long_content = (['word'] * 400).join(' ')
      long_article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        content: long_content
      )
      decorator = described_class.new(long_article)

      expect(decorator.reading_time).to match(/\d+ min read/)
    end
  end

  describe '#formatted_date' do
    it 'formats publication date' do
      expect(decorator.formatted_date).to eq('January 15, 2024')
    end

    it 'returns placeholder when no date' do
      minimal_article = Article.new(
        title: 'Test',
        url: 'https://example.com'
      )
      decorator = described_class.new(minimal_article)

      expect(decorator.formatted_date).to eq('Date unknown')
    end
  end

  describe '#byline' do
    it 'includes author and date' do
      expect(decorator.byline).to eq('By Jane Doe • January 15, 2024')
    end

    it 'handles missing author' do
      article_no_author = Article.new(
        title: 'Test',
        url: 'https://example.com',
        published_at: Time.parse('2024-01-15')
      )
      decorator = described_class.new(article_no_author)

      expect(decorator.byline).to eq('January 15, 2024')
    end

    it 'handles missing date' do
      article_no_date = Article.new(
        title: 'Test',
        url: 'https://example.com',
        author: 'John Doe'
      )
      decorator = described_class.new(article_no_date)

      expect(decorator.byline).to eq('By John Doe')
    end

    it 'returns placeholder when no metadata' do
      minimal_article = Article.new(
        title: 'Test',
        url: 'https://example.com'
      )
      decorator = described_class.new(minimal_article)

      expect(decorator.byline).to eq('No byline information')
    end
  end

  describe '#formatted_output' do
    it 'returns multi-line formatted text' do
      output = decorator.formatted_output

      expect(output).to include('★ Ruby Programming ★')
      expect(output).to include('By Jane Doe')
      expect(output).to include('Read more:')
      expect(output).to include('Reading time:')
    end
  end

  describe '#to_markdown' do
    it 'converts article to markdown' do
      markdown = decorator.to_markdown

      expect(markdown).to include('# Ruby Programming')
      expect(markdown).to include('By Jane Doe')
      expect(markdown).to include('[Read original article]')
    end
  end

  describe '#to_html' do
    it 'converts article to HTML' do
      html = decorator.to_html

      expect(html).to include('<article>')
      expect(html).to include('<h1>Ruby Programming</h1>')
      expect(html).to include('Jane Doe')
      expect(html).to include('</article>')
    end

    it 'escapes HTML entities' do
      article_with_html = Article.new(
        title: 'Test <script>',
        url: 'https://example.com'
      )
      decorator = described_class.new(article_with_html)

      html = decorator.to_html

      expect(html).to include('&lt;script&gt;')
      expect(html).not_to include('<script>')
    end
  end

  describe 'method delegation' do
    it 'delegates unknown methods to article' do
      expect(decorator.title).to eq(article.title)
      expect(decorator.author).to eq(article.author)
      expect(decorator.url).to eq(article.url)
    end

    it 'responds to article methods' do
      expect(decorator).to respond_to(:title)
      expect(decorator).to respond_to(:author)
      expect(decorator).to respond_to(:word_count)
    end
  end
end
