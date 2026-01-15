# frozen_string_literal: true

require 'bcrypt'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, length: { minimum: 6 }, if: :password_required?

  before_save :normalize_email

  def password=(new_password)
    @password = new_password
    self.password_digest = BCrypt::Password.create(new_password) if new_password.present?
  end

  def password
    @password
  end

  def authenticate(attempted_password)
    BCrypt::Password.new(password_digest) == attempted_password ? self : false
  rescue BCrypt::Errors::InvalidHash
    false
  end

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end

  def password_required?
    password_digest.nil? || @password.present?
  end
end
