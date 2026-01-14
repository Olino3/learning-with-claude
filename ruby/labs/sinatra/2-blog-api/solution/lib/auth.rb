# frozen_string_literal: true

require 'jwt'

module AuthHelpers
  JWT_SECRET = ENV['JWT_SECRET'] || 'blog-api-secret-change-in-production'
  TOKEN_EXPIRATION = ENV['TOKEN_EXPIRATION']&.to_i || 86400

  def generate_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: Time.now.to_i + TOKEN_EXPIRATION,
      iat: Time.now.to_i
    }
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
    nil
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = nil

    auth_header = request.env['HTTP_AUTHORIZATION']
    return nil unless auth_header

    token = auth_header.split(' ').last
    return nil unless token

    payload = decode_token(token)
    return nil unless payload

    @current_user = User.find_by(id: payload['user_id'])
  end

  def authenticated?
    !current_user.nil?
  end
end
