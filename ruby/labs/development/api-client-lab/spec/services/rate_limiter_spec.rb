# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RateLimiter do
  let(:limiter) { described_class.new(max_requests: 5, window: 60) }

  describe '#check_limit' do
    it 'allows requests within limit' do
      5.times { expect(limiter.check_limit('user1')).to be true }
    end

    it 'denies requests exceeding limit' do
      5.times { limiter.increment('user1') }

      expect(limiter.check_limit('user1')).to be false
    end
  end

  describe '#within_limit' do
    it 'executes block when within limit' do
      result = limiter.within_limit('user1') { 'executed' }

      expect(result).to eq('executed')
    end

    it 'raises error when limit exceeded' do
      5.times { limiter.increment('user1') }

      expect {
        limiter.within_limit('user1') { 'should not run' }
      }.to raise_error(RateLimiter::RateLimitExceededError)
    end
  end

  describe '#remaining' do
    it 'returns remaining requests' do
      3.times { limiter.increment('user1') }

      expect(limiter.remaining('user1')).to eq(2)
    end
  end

  describe '#info' do
    it 'returns rate limit information' do
      info = limiter.info('user1')

      expect(info[:limit]).to eq(5)
      expect(info[:remaining]).to eq(5)
    end
  end
end
