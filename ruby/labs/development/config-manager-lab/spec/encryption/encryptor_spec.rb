# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Encryptor do
  let(:key) { Encryptor.generate_key }
  let(:encryptor) { described_class.new(key: key) }

  describe '#encrypt and #decrypt' do
    it 'encrypts and decrypts data' do
      plaintext = 'secret-password-123'
      encrypted = encryptor.encrypt(plaintext)
      decrypted = encryptor.decrypt(encrypted)

      expect(decrypted).to eq(plaintext)
      expect(encrypted).not_to eq(plaintext)
    end

    it 'produces different ciphertext for same plaintext' do
      plaintext = 'same-secret'
      encrypted1 = encryptor.encrypt(plaintext)
      encrypted2 = encryptor.encrypt(plaintext)

      expect(encrypted1).not_to eq(encrypted2)
    end
  end

  describe 'error handling' do
    it 'raises error for nil plaintext' do
      expect {
        encryptor.encrypt(nil)
      }.to raise_error(Encryptor::EncryptionError)
    end

    it 'raises error for invalid encrypted data' do
      expect {
        encryptor.decrypt('invalid-data')
      }.to raise_error(Encryptor::DecryptionError)
    end

    it 'raises error for wrong key length' do
      expect {
        described_class.new(key: 'short')
      }.to raise_error(Encryptor::EncryptionError, /must be 32 bytes/)
    end
  end

  describe '.generate_key' do
    it 'generates a 32-byte key' do
      key = described_class.generate_key

      expect(key.bytesize).to eq(32)
    end

    it 'generates different keys each time' do
      key1 = described_class.generate_key
      key2 = described_class.generate_key

      expect(key1).not_to eq(key2)
    end
  end

  describe '.generate_key_hex' do
    it 'generates hex-encoded key' do
      hex_key = described_class.generate_key_hex

      expect(hex_key).to match(/\A[0-9a-f]{64}\z/)
    end
  end
end
