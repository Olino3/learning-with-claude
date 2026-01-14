# frozen_string_literal: true

# Message model placeholder
#
# The actual Message model is defined in app.rb and chat_server.rb
# after database connection.
#
# For Python developers:
# - Similar to Django Message model or Flask-SQLAlchemy Message
# - Represents a chat message in a room

# Message Model Structure:
#
# Fields:
#   - id: Integer (primary key)
#   - room_id: Integer (foreign key to rooms)
#   - username: String (required) - sender's username
#   - content: Text (required) - message content
#   - created_at: DateTime
#
# Associations:
#   - belongs_to :room - the room this message belongs to
#
# Methods:
#   - to_hash: Serialize message to JSON-friendly hash

=begin

Python equivalents:

# Django Message Model
from django.db import models

class Message(models.Model):
    room = models.ForeignKey('Room', on_delete=models.CASCADE, related_name='messages')
    username = models.CharField(max_length=100)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']
        indexes = [
            models.Index(fields=['room', 'created_at']),
        ]

    def __str__(self):
        return f"{self.username}: {self.content[:50]}"

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'content': self.content,
            'created_at': self.created_at.isoformat()
        }

# SQLAlchemy Message Model
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Index
from sqlalchemy.orm import relationship
from datetime import datetime

class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True)
    room_id = Column(Integer, ForeignKey('rooms.id'), nullable=False)
    username = Column(String(100), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    room = relationship("Room", back_populates="messages")

    __table_args__ = (
        Index('idx_messages_room_created', 'room_id', 'created_at'),
    )

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'content': self.content,
            'created_at': self.created_at.isoformat()
        }

# Pydantic model for FastAPI
from pydantic import BaseModel, Field
from datetime import datetime

class MessageBase(BaseModel):
    username: str = Field(..., min_length=1, max_length=100)
    content: str = Field(..., min_length=1)

class MessageCreate(MessageBase):
    room_id: int

class MessageResponse(MessageBase):
    id: int
    room_id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Flask-SocketIO Message Handler
@socketio.on('message')
def handle_message(data):
    room_id = data['room_id']
    username = data['username']
    content = data['content']

    # Save to database
    message = Message(
        room_id=room_id,
        username=username,
        content=content
    )
    db.session.add(message)
    db.session.commit()

    # Broadcast to room
    emit('message', message.to_dict(), room=str(room_id))

# Django Channels Message Handler
async def receive(self, text_data):
    data = json.loads(text_data)

    # Save to database
    message = await database_sync_to_async(Message.objects.create)(
        room_id=data['room_id'],
        username=data['username'],
        content=data['content']
    )

    # Broadcast to room group
    await self.channel_layer.group_send(
        self.room_group_name,
        {
            'type': 'chat_message',
            'message': message.to_dict()
        }
    )

=end
