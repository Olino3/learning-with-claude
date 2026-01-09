# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConfigValidator do
  let(:schema) do
    {
      'DATABASE_URL' => { type: :string, required: true },
      'PORT' => { type: :integer, required: false, default: 3000 },
      'ENABLE_SSL' => { type: :boolean, required: false }
    }
  end

  let(:validator) { described_class.new(schema) }

  describe '#validate!' do
    it 'validates valid configuration' do
      config = {
        'DATABASE_URL' => 'postgres://localhost/db',
        'PORT' => 3000
      }

      expect(validator.validate!(config)).to be true
    end

    it 'raises error for missing required field' do
      config = { 'PORT' => 3000 }

      expect {
        validator.validate!(config)
      }.to raise_error(ConfigValidator::ValidationError, /DATABASE_URL is required/)
    end

    it 'raises error for wrong type' do
      config = {
        'DATABASE_URL' => 'postgres://localhost/db',
        'PORT' => 'not-a-number'
      }

      expect {
        validator.validate!(config)
      }.to raise_error(ConfigValidator::ValidationError, /must be of type integer/)
    end

    it 'allows optional missing fields' do
      config = {
        'DATABASE_URL' => 'postgres://localhost/db'
      }

      expect(validator.validate!(config)).to be true
    end
  end

  describe '#valid?' do
    it 'returns true for valid config' do
      config = { 'DATABASE_URL' => 'postgres://localhost/db' }

      expect(validator.valid?(config)).to be true
    end

    it 'returns false for invalid config' do
      config = { 'PORT' => 3000 }

      expect(validator.valid?(config)).to be false
    end
  end

  describe '#valid_key?' do
    it 'validates individual keys' do
      expect(validator.valid_key?('PORT', 3000)).to be true
      expect(validator.valid_key?('PORT', 'invalid')).to be false
    end
  end
end
