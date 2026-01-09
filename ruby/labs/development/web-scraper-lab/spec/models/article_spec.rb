# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Article do
  describe '#initialize' do
    it 'creates an article with required attributes' do
      article = Article.new(
        title: 'Test Article',
        url: 'https://example.com/article'
      )

      expect(article.title).to eq('Test Article')
      expect(article.url).to eq('https://example.com/article')
      expect(article.author).to be_nil
      expect(article.content).to eq('')
    end

    it 'creates an article with all attributes' do
      time = Time.now
      article = Article.new(
        title: 'Test',
        url: 'https://example.com/test',
        author: 'John Doe',
        published_at: time,
        content: 'Content here',
        excerpt: 'Excerpt here'
      )

      expect(article.author).to eq('John Doe')
      expect(article.published_at).to eq(time)
      expect(article.content).to eq('Content here')
      expect(article.excerpt).to eq('Excerpt here')
    end

    it 'is frozen after creation' do
      article = Article.new(title: 'Test', url: 'https://example.com')

      expect(article).to be_frozen
    end

    it 'raises error for missing title' do
      expect {
        Article.new(title: '', url: 'https://example.com')
      }.to raise_error(ArgumentError, /Title cannot be empty/)
    end

    it 'raises error for missing URL' do
      expect {
        Article.new(title: 'Test', url: '')
      }.to raise_error(ArgumentError, /URL cannot be empty/)
    end

    it 'raises error for invalid URL format' do
      expect {
        Article.new(title: 'Test', url: 'not-a-url')
      }.to raise_error(ArgumentError, /Invalid URL format/)
    end
  end

  describe '#has_author?' do
    it 'returns true when author is present' do
      article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        author: 'John Doe'
      )

      expect(article.has_author?).to be true
    end

    it 'returns false when author is nil' do
      article = Article.new(title: 'Test', url: 'https://example.com')

      expect(article.has_author?).to be false
    end

    it 'returns false when author is empty string' do
      article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        author: '   '
      )

      expect(article.has_author?).to be false
    end
  end

  describe '#word_count' do
    it 'counts words in content' do
      article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        content: 'This is a test article with ten words here now'
      )

      expect(article.word_count).to eq(10)
    end

    it 'returns 0 for empty content' do
      article = Article.new(title: 'Test', url: 'https://example.com')

      expect(article.word_count).to eq(0)
    end
  end

  describe '#reading_time_minutes' do
    it 'estimates reading time' do
      # 400 words = 2 minutes at 200 wpm
      words = (['word'] * 400).join(' ')
      article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        content: words
      )

      expect(article.reading_time_minutes).to eq(2)
    end

    it 'rounds up partial minutes' do
      # 250 words = 1.25 minutes, should round to 2
      words = (['word'] * 250).join(' ')
      article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        content: words
      )

      expect(article.reading_time_minutes).to eq(2)
    end
  end

  describe '#to_h' do
    it 'converts article to hash' do
      time = Time.parse('2024-01-15 10:00:00 UTC')
      article = Article.new(
        title: 'Test',
        url: 'https://example.com',
        author: 'John',
        published_at: time,
        content: 'Content'
      )

      hash = article.to_h

      expect(hash[:title]).to eq('Test')
      expect(hash[:url]).to eq('https://example.com')
      expect(hash[:author]).to eq('John')
      expect(hash[:published_at]).to eq(time.iso8601)
    end
  end

  describe '.from_h' do
    it 'creates article from hash' do
      hash = {
        title: 'Test Article',
        url: 'https://example.com/test',
        author: 'Jane Doe',
        published_at: '2024-01-15T10:00:00Z',
        content: 'Test content',
        excerpt: 'Test excerpt'
      }

      article = Article.from_h(hash)

      expect(article.title).to eq('Test Article')
      expect(article.author).to eq('Jane Doe')
      expect(article.published_at).to be_a(Time)
    end
  end

  describe '#to_json' do
    it 'converts article to JSON string' do
      article = Article.new(
        title: 'Test',
        url: 'https://example.com'
      )

      json = article.to_json

      expect(json).to be_a(String)
      expect(JSON.parse(json)['title']).to eq('Test')
    end
  end

  describe '#to_csv' do
    it 'converts article to CSV row' do
      article = Article.new(
        title: 'Test Article',
        url: 'https://example.com',
        author: 'John Doe'
      )

      csv = article.to_csv

      expect(csv).to include('Test Article')
      expect(csv).to include('https://example.com')
      expect(csv).to include('John Doe')
    end

    it 'escapes commas in fields' do
      article = Article.new(
        title: 'Test, Article',
        url: 'https://example.com'
      )

      csv = article.to_csv

      expect(csv).to include('"Test, Article"')
    end
  end
end
