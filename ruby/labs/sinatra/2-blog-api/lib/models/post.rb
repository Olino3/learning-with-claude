# frozen_string_literal: true

# Post model representing blog posts
#
# A post belongs to a user (author) and can have many comments and tags.
# Posts can be published or in draft state.
#
# For Python developers:
# - Similar to Django's Post model with ForeignKey relationships
# - has_many through is like Django's ManyToManyField
# - Scopes are similar to Django's QuerySet methods

class Post < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :user, presence: true

  # Scopes
  scope :published, -> { where(published: true) }
  scope :drafts, -> { where(published: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  # Callbacks
  before_save :set_published_at, if: :published_changed_to_true?

  # Instance methods
  def author_name
    user&.name
  end

  def comments_count
    comments.count
  end

  def tag_names
    tags.pluck(:name)
  end

  def excerpt(length = 150)
    content.length > length ? "#{content[0...length]}..." : content
  end

  def published?
    published
  end

  def draft?
    !published
  end

  private

  def published_changed_to_true?
    published && published_changed?
  end

  def set_published_at
    self.updated_at = Time.current
  end
end

# Many-to-many join model
class PostTag < ActiveRecord::Base
  self.table_name = 'post_tags'
  belongs_to :post
  belongs_to :tag
end

=begin

Python equivalents:

# Django Post Model
from django.db import models
from django.contrib.auth.models import User

class Post(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    published = models.BooleanField(default=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posts')
    tags = models.ManyToManyField('Tag', related_name='posts')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.title

    @property
    def author_name(self):
        return self.user.name

    def excerpt(self, length=150):
        return self.content[:length] + '...' if len(self.content) > length else self.content

# SQLAlchemy Post Model (Flask/FastAPI)
from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

class Post(Base):
    __tablename__ = "posts"

    id = Column(Integer, primary_key=True)
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    published = Column(Boolean, default=False)
    user_id = Column(Integer, ForeignKey('users.id'))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="posts")
    comments = relationship("Comment", back_populates="post", cascade="all, delete-orphan")
    tags = relationship("Tag", secondary="post_tags", back_populates="posts")

    @property
    def author_name(self):
        return self.user.name if self.user else None

    def excerpt(self, length=150):
        return self.content[:length] + '...' if len(self.content) > length else self.content

    @classmethod
    def get_published(cls, db_session):
        return db_session.query(cls).filter(cls.published == True).all()

# Pydantic schema for FastAPI
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class PostBase(BaseModel):
    title: str = Field(..., min_length=5, max_length=255)
    content: str = Field(..., min_length=10)
    published: bool = False

class PostCreate(PostBase):
    tags: Optional[List[str]] = []

class PostResponse(PostBase):
    id: int
    user_id: int
    author_name: str
    tags: List[str]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

=end
