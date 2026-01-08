# frozen_string_literal: true

require 'jwt'

# JWT Authentication helpers
#
# Provides token generation and verification for stateless authentication.
# Tokens are signed with a secret key and include user information.
#
# For Python developers:
# - Similar to PyJWT or python-jose for JWT handling
# - Flask-JWT-Extended or FastAPI's OAuth2PasswordBearer
# - Django REST Framework's JWT authentication

module AuthHelpers
  # Secret key for JWT signing
  # In production, use ENV['JWT_SECRET'] from environment variables
  JWT_SECRET = ENV['JWT_SECRET'] || 'your-secret-key-change-in-production'

  # Token expiration time (default: 24 hours)
  TOKEN_EXPIRATION = ENV['TOKEN_EXPIRATION']&.to_i || 86400

  # Generate a JWT token for a user
  #
  # @param user [User] the user to generate a token for
  # @return [String] the JWT token
  def generate_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: Time.now.to_i + TOKEN_EXPIRATION,
      iat: Time.now.to_i
    }

    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  # Decode and verify a JWT token
  #
  # @param token [String] the JWT token to decode
  # @return [Hash, nil] the decoded payload or nil if invalid
  def decode_token(token)
    JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
    nil
  end

  # Get the current user from the Authorization header
  #
  # @return [User, nil] the current user or nil if not authenticated
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = nil

    # Get token from Authorization header
    auth_header = request.env['HTTP_AUTHORIZATION']
    return nil unless auth_header

    # Extract token from "Bearer TOKEN" format
    token = auth_header.split(' ').last
    return nil unless token

    # Decode token and find user
    payload = decode_token(token)
    return nil unless payload

    @current_user = User.find_by(id: payload['user_id'])
  end

  # Check if user is authenticated
  #
  # @return [Boolean] true if user is authenticated
  def authenticated?
    !current_user.nil?
  end

  # Check if current user is the owner of a resource
  #
  # @param resource [Object] object with user_id attribute
  # @return [Boolean] true if current user owns the resource
  def authorized?(resource)
    return false unless authenticated?
    return false unless resource.respond_to?(:user_id)

    current_user.id == resource.user_id
  end
end

=begin

Python equivalents:

# Flask-JWT-Extended
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)
from datetime import timedelta

jwt = JWTManager(app)
app.config['JWT_SECRET_KEY'] = 'your-secret-key'
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=24)

def generate_token(user):
    return create_access_token(
        identity=user.id,
        additional_claims={'email': user.email}
    )

@jwt_required()
def protected_route():
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    return jsonify(user=user.serialize())

# FastAPI with python-jose
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from datetime import datetime, timedelta

SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1440

security = HTTPBearer()

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire, "iat": datetime.utcnow()})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    payload = decode_token(token)

    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials"
        )

    user_id = payload.get("user_id")
    user = db.query(User).filter(User.id == user_id).first()

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found"
        )

    return user

# Usage in route
@app.get("/protected")
async def protected_route(current_user: User = Depends(get_current_user)):
    return {"user": current_user.email}

# Django REST Framework JWT
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

@api_view(['POST'])
def register(request):
    user = User.objects.create_user(**request.data)
    tokens = get_tokens_for_user(user)
    return Response(tokens)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def protected_view(request):
    return Response({'user': request.user.email})

=end
