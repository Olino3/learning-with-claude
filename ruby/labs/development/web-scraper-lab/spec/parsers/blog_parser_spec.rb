# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BlogParser do
  let(:parser) { described_class.new }
  let(:blog_html) { load_fixture('blog_sample.html') }

  describe '#parse' do
    it 'parses blog articles from HTML' do
      results = parser.parse(blog_html)

      expect(results).to be_an(Array)
      expect(results.size).to eq(3)
    end

    it 'extracts article titles' do
      results = parser.parse(blog_html)

      expect(results[0][:title]).to eq('10 Ruby Tips for Beginners')
      expect(results[1][:title]).to eq('Complete Guide to RSpec Testing')
      expect(results[2][:title]).to eq('Ruby Design Patterns')
    end

    it 'extracts article URLs' do
      results = parser.parse(blog_html)

      expect(results[0][:url]).to eq('/articles/ruby-tips')
      expect(results[1][:url]).to eq('/articles/testing-guide')
    end

    it 'extracts authors' do
      results = parser.parse(blog_html)

      expect(results[0][:author]).to eq('Jane Smith')
      expect(results[1][:author]).to eq('John Doe')
      expect(results[2][:author]).to eq('Alice Johnson')
    end

    it 'extracts publication dates' do
      results = parser.parse(blog_html)

      expect(results[0][:published_at]).to be_a(Time)
      expect(results[0][:published_at].year).to eq(2024)
      expect(results[0][:published_at].month).to eq(1)
      expect(results[0][:published_at].day).to eq(15)
    end

    it 'extracts excerpts' do
      results = parser.parse(blog_html)

      expect(results[0][:excerpt]).to include('Learn essential Ruby programming')
    end

    it 'extracts content' do
      results = parser.parse(blog_html)

      expect(results[0][:content]).to include('Ruby is a dynamic')
    end

    it 'handles empty HTML' do
      results = parser.parse('<html><body></body></html>')

      expect(results).to eq([])
    end

    it 'raises ParseError for invalid HTML structure' do
      expect {
        parser.parse('invalid html {{{')
      }.to raise_error(HtmlParser::ParseError)
    end

    it 'skips articles with missing required fields' do
      html = '<article class="post"><div>No title or link</div></article>'
      results = parser.parse(html)

      expect(results).to eq([])
    end
  end
end
