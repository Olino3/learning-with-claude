# frozen_string_literal: true

# Room model placeholder
#
# The actual Room model is defined in app.rb and chat_server.rb
# after database connection.
#
# For Python developers:
# - Similar to Django Room model or Flask-SQLAlchemy Room
# - Represents a chat room/channel

# Room Model Structure:
#
# Fields:
#   - id: Integer (primary key)
#   - name: String (unique, required) - room identifier
#   - description: String (optional) - room description
#   - created_at: DateTime
#
# Associations:
#   - has_many :messages - all messages in this room
#
# Methods:
#   - to_hash: Serialize room to JSON-friendly hash
#   - message_count: Count of messages in room

=begin

Python equivalents:

# Django Room Model
from django.db import models

class Room(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.name

    @property
    def message_count(self):
        return self.messages.count()

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'created_at': self.created_at.isoformat(),
            'message_count': self.message_count
        }

# SQLAlchemy Room Model
from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

class Room(Base):
    __tablename__ = "rooms"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    messages = relationship("Message", back_populates="room", cascade="all, delete-orphan")

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'created_at': self.created_at.isoformat(),
            'message_count': len(self.messages)
        }

# Pydantic model for FastAPI
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class RoomBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None

class RoomCreate(RoomBase):
    pass

class RoomResponse(RoomBase):
    id: int
    created_at: datetime
    message_count: int = 0

    class Config:
        from_attributes = True

=end
