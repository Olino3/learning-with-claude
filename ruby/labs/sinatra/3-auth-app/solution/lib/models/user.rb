# frozen_string_literal: true

# User model placeholder
#
# The actual User model is defined in app.rb after database connection.
# This file documents the User model structure and methods for reference.
#
# For Python developers:
# - Similar to Django's User model or Flask-Login's UserMixin
# - BCrypt password hashing like werkzeug.security or passlib

# User Model Structure:
#
# Fields:
#   - id: Integer (primary key)
#   - email: String (unique, required)
#   - password_digest: String (BCrypt hash, required)
#   - name: String (required)
#   - remember_token: String (for persistent sessions)
#   - created_at: DateTime
#   - updated_at: DateTime
#   - last_login_at: DateTime
#
# Methods:
#   - password=(new_password): Set password (automatically hashes)
#   - authenticate(password): Verify password
#   - generate_remember_token: Create persistent session token
#   - clear_remember_token: Remove persistent session token
#   - update_last_login: Update last login timestamp
#
# Validations:
#   - email: present, unique, valid format
#   - name: present, minimum 2 characters
#   - password: present (on create), minimum 6 characters

=begin

Python equivalents:

# Django User Model
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=100)
    remember_token = models.CharField(max_length=100, blank=True)
    last_login_at = models.DateTimeField(null=True, blank=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def update_last_login(self):
        self.last_login_at = timezone.now()
        self.save()

# Flask-Login User
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    name = db.Column(db.String(100), nullable=False)
    remember_token = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    last_login_at = db.Column(db.DateTime)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def generate_remember_token(self):
        import secrets
        self.remember_token = secrets.token_urlsafe(32)
        db.session.commit()
        return self.remember_token

    def clear_remember_token(self):
        self.remember_token = None
        db.session.commit()

# FastAPI with SQLAlchemy
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from passlib.context import CryptContext
from datetime import datetime
import secrets

Base = declarative_base()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    name = Column(String, nullable=False)
    remember_token = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    last_login_at = Column(DateTime, nullable=True)

    def set_password(self, password: str):
        self.hashed_password = pwd_context.hash(password)

    def verify_password(self, password: str) -> bool:
        return pwd_context.verify(password, self.hashed_password)

    def generate_remember_token(self) -> str:
        self.remember_token = secrets.token_urlsafe(32)
        return self.remember_token

    def clear_remember_token(self):
        self.remember_token = None

    def update_last_login(self):
        self.last_login_at = datetime.utcnow()

# Pydantic models for FastAPI
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

class UserCreate(BaseModel):
    email: EmailStr
    name: str = Field(..., min_length=2, max_length=100)
    password: str = Field(..., min_length=6)

class UserResponse(BaseModel):
    id: int
    email: EmailStr
    name: str
    created_at: datetime
    last_login_at: Optional[datetime] = None

    class Config:
        from_attributes = True

=end
