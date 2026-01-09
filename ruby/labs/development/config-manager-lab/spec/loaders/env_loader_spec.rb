# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EnvLoader do
  let(:loader) { described_class.new(env_file: 'nonexistent.env') }

  describe '#load' do
    it 'loads environment variables' do
      config = loader.load

      expect(config).to be_a(Hash)
      expect(config).to include('PATH')
    end
  end

  describe '.sensitive_key?' do
    it 'identifies sensitive keys' do
      expect(described_class.sensitive_key?('API_KEY')).to be true
      expect(described_class.sensitive_key?('PASSWORD')).to be true
      expect(described_class.sensitive_key?('SECRET_TOKEN')).to be true
      expect(described_class.sensitive_key?('DATABASE_URL')).to be false
    end
  end

  describe '.mask_value' do
    it 'masks sensitive values' do
      expect(described_class.mask_value('API_KEY', 'secret')).to eq('[MASKED]')
      expect(described_class.mask_value('PORT', '3000')).to eq('3000')
    end
  end

  describe '.to_env_format' do
    it 'converts hash to .env format' do
      config = { 'KEY1' => 'value1', 'KEY2' => 'value with spaces' }
      result = described_class.to_env_format(config)

      expect(result).to include('KEY1=value1')
      expect(result).to include('KEY2="value with spaces"')
    end
  end
end
