# frozen_string_literal: true

require 'openssl'
require 'base64'

# Encryptor provides secure encryption and decryption of sensitive data
# using AES-256-GCM encryption.
#
# Design Patterns:
# - Service Object: Encapsulates encryption logic
# - Singleton: Can be used as a shared service
#
# Example:
#   encryptor = Encryptor.new(key: 'your-32-byte-key-here')
#   encrypted = encryptor.encrypt('secret')
#   decrypted = encryptor.decrypt(encrypted)
class Encryptor
  CIPHER_TYPE = 'aes-256-gcm'
  KEY_LENGTH = 32 # 256 bits

  class EncryptionError < StandardError; end

  class DecryptionError < StandardError; end

  attr_reader :key

  # Creates a new Encryptor
  #
  # @param key [String] Encryption key (32 bytes)
  def initialize(key: nil)
    @key = key || ENV['ENCRYPTION_KEY'] || generate_key
    validate_key!
  end

  # Encrypts plaintext
  #
  # @param plaintext [String] Text to encrypt
  # @return [String] Base64-encoded encrypted data
  # @raise [EncryptionError] if encryption fails
  def encrypt(plaintext)
    raise EncryptionError, 'Plaintext cannot be nil' if plaintext.nil?

    cipher = OpenSSL::Cipher.new(CIPHER_TYPE)
    cipher.encrypt
    cipher.key = key

    # Generate random IV
    iv = cipher.random_iv

    # Encrypt
    encrypted = cipher.update(plaintext) + cipher.final

    # Get authentication tag
    tag = cipher.auth_tag

    # Combine IV + tag + encrypted data and encode
    combined = iv + tag + encrypted
    Base64.strict_encode64(combined)
  rescue StandardError => e
    raise EncryptionError, "Encryption failed: #{e.message}"
  end

  # Decrypts encrypted data
  #
  # @param encrypted_data [String] Base64-encoded encrypted data
  # @return [String] Decrypted plaintext
  # @raise [DecryptionError] if decryption fails
  def decrypt(encrypted_data)
    raise DecryptionError, 'Encrypted data cannot be nil' if encrypted_data.nil?

    # Decode from Base64
    combined = Base64.strict_decode64(encrypted_data)

    # Extract IV (16 bytes), tag (16 bytes), and ciphertext
    iv = combined[0...16]
    tag = combined[16...32]
    ciphertext = combined[32..]

    # Decrypt
    decipher = OpenSSL::Cipher.new(CIPHER_TYPE)
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
    decipher.auth_tag = tag

    decipher.update(ciphertext) + decipher.final
  rescue StandardError => e
    raise DecryptionError, "Decryption failed: #{e.message}"
  end

  # Generates a random encryption key
  #
  # @return [String] Random 32-byte key
  def self.generate_key
    OpenSSL::Random.random_bytes(KEY_LENGTH)
  end

  # Generates a human-readable key (hex-encoded)
  #
  # @return [String] Hex-encoded key
  def self.generate_key_hex
    generate_key.unpack1('H*')
  end

  private

  # Generates a key if not provided
  def generate_key
    self.class.generate_key
  end

  # Validates encryption key
  def validate_key!
    raise EncryptionError, 'Encryption key is required' if key.nil?
    raise EncryptionError, "Key must be #{KEY_LENGTH} bytes" if key.bytesize != KEY_LENGTH
  end
end
