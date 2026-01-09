# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RedisCache do
  let(:cache) { described_class.new(namespace: 'test') }

  describe '#set and #get' do
    it 'stores and retrieves values' do
      cache.set('key', { data: 'value' })
      result = cache.get('key')

      expect(result).to eq({ 'data' => 'value' })
    end
  end

  describe '#fetch' do
    it 'returns cached value if present' do
      cache.set('key', 'cached')
      result = cache.fetch('key') { 'computed' }

      expect(result).to eq('cached')
    end

    it 'computes and caches value if missing' do
      result = cache.fetch('key') { 'computed' }

      expect(result).to eq('computed')
      expect(cache.get('key')).to eq('computed')
    end
  end

  describe '#delete' do
    it 'removes key from cache' do
      cache.set('key', 'value')
      cache.delete('key')

      expect(cache.get('key')).to be_nil
    end
  end

  describe '#exists?' do
    it 'returns true for existing keys' do
      cache.set('key', 'value')

      expect(cache.exists?('key')).to be true
    end

    it 'returns false for missing keys' do
      expect(cache.exists?('missing')).to be false
    end
  end
end
