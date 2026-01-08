# frozen_string_literal: true

# Comment model representing comments on blog posts
#
# A comment belongs to both a post and a user.
# Provides threaded discussion capabilities.
#
# For Python developers:
# - Similar to Django Comment model with ForeignKey relationships
# - Can be extended to support nested comments (self-referential)

class Comment < ActiveRecord::Base
  # Associations
  belongs_to :post
  belongs_to :user

  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :post, presence: true
  validates :user, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :for_post, ->(post_id) { where(post_id: post_id) }

  # Instance methods
  def author_name
    user&.name
  end

  def post_title
    post&.title
  end

  def short_content(length = 50)
    content.length > length ? "#{content[0...length]}..." : content
  end
end

=begin

Python equivalents:

# Django Comment Model
from django.db import models

class Comment(models.Model):
    content = models.TextField(max_length=1000)
    post = models.ForeignKey('Post', on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='comments')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Comment by {self.user.name} on {self.post.title}"

    @property
    def author_name(self):
        return self.user.name

# SQLAlchemy Comment Model
from sqlalchemy import Column, Integer, Text, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

class Comment(Base):
    __tablename__ = "comments"

    id = Column(Integer, primary_key=True)
    content = Column(Text, nullable=False)
    post_id = Column(Integer, ForeignKey('posts.id'))
    user_id = Column(Integer, ForeignKey('users.id'))
    created_at = Column(DateTime, default=datetime.utcnow)

    post = relationship("Post", back_populates="comments")
    user = relationship("User", back_populates="comments")

    @property
    def author_name(self):
        return self.user.name if self.user else None

# Pydantic schema for FastAPI
from pydantic import BaseModel, Field
from datetime import datetime

class CommentBase(BaseModel):
    content: str = Field(..., min_length=1, max_length=1000)

class CommentCreate(CommentBase):
    post_id: int

class CommentResponse(CommentBase):
    id: int
    post_id: int
    user_id: int
    author_name: str
    created_at: datetime

    class Config:
        from_attributes = True

=end
