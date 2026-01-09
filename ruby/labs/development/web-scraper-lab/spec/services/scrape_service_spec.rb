# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ScrapeService do
  let(:parser) { BlogParser.new }
  let(:service) { described_class.new(parser: parser) }
  let(:url) { 'https://example.com/blog' }
  let(:blog_html) { load_fixture('blog_sample.html') }

  describe '#scrape' do
    before do
      stub_request(:get, url)
        .to_return(status: 200, body: blog_html)
    end

    it 'fetches and parses articles' do
      articles = service.scrape(url)

      expect(articles).to be_an(Array)
      expect(articles.size).to eq(3)
      expect(articles.first).to be_an(Article)
    end

    it 'returns Article objects with correct data' do
      articles = service.scrape(url)
      first_article = articles.first

      expect(first_article.title).to eq('10 Ruby Tips for Beginners')
      expect(first_article.author).to eq('Jane Smith')
      expect(first_article.url).to eq('/articles/ruby-tips')
    end
  end

  describe '#fetch' do
    context 'successful request' do
      before do
        stub_request(:get, url)
          .to_return(status: 200, body: '<html>Success</html>')
      end

      it 'returns HTML content' do
        html = service.fetch(url)

        expect(html).to eq('<html>Success</html>')
      end

      it 'includes custom User-Agent header' do
        service.fetch(url)

        expect(WebMock).to have_requested(:get, url)
          .with(headers: { 'User-Agent' => service.user_agent })
      end
    end

    context 'HTTP errors' do
      it 'raises HttpError for 404' do
        stub_request(:get, url).to_return(status: 404)

        expect {
          service.fetch(url)
        }.to raise_error(ScrapeService::HttpError, /404/)
      end

      it 'raises HttpError for 500' do
        stub_request(:get, url).to_return(status: 500)

        expect {
          service.fetch(url)
        }.to raise_error(ScrapeService::HttpError, /500/)
      end
    end

    context 'network errors' do
      it 'retries on timeout and eventually fails' do
        stub_request(:get, url).to_timeout

        expect {
          service.fetch(url)
        }.to raise_error(ScrapeService::TimeoutError)
      end

      it 'raises NetworkError for connection refused' do
        stub_request(:get, url).to_raise(Errno::ECONNREFUSED)

        expect {
          service.fetch(url)
        }.to raise_error(ScrapeService::NetworkError, /Network error/)
      end
    end

    context 'retries' do
      it 'retries on server errors' do
        stub_request(:get, url)
          .to_return({ status: 500 }, { status: 200, body: 'Success' })

        html = service.fetch(url)

        expect(html).to eq('Success')
        expect(WebMock).to have_requested(:get, url).twice
      end
    end
  end

  describe 'configuration' do
    it 'accepts custom max_retries' do
      service = described_class.new(parser: parser, max_retries: 5)

      expect(service.max_retries).to eq(5)
    end

    it 'accepts custom timeout' do
      service = described_class.new(parser: parser, timeout: 60)

      expect(service.timeout).to eq(60)
    end

    it 'accepts custom user_agent' do
      custom_ua = 'CustomBot/1.0'
      service = described_class.new(parser: parser, user_agent: custom_ua)

      expect(service.user_agent).to eq(custom_ua)
    end
  end
end
