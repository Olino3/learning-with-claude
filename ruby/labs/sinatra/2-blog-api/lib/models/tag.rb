# frozen_string_literal: true

# Tag model for categorizing blog posts
#
# Tags have a many-to-many relationship with posts through post_tags.
# Provides organization and filtering capabilities for posts.
#
# For Python developers:
# - Similar to Django Tag model with ManyToMany relationship
# - has_many through is like Django's through table

class Tag < ActiveRecord::Base
  # Associations
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  # Validations
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 50 },
                   format: { with: /\A[a-z0-9\-]+\z/,
                            message: 'only allows lowercase letters, numbers, and hyphens' }

  # Callbacks
  before_validation :normalize_name

  # Scopes
  scope :popular, -> { joins(:posts).group('tags.id').order('COUNT(posts.id) DESC') }
  scope :alphabetical, -> { order(:name) }

  # Instance methods
  def posts_count
    posts.count
  end

  def published_posts_count
    posts.where(published: true).count
  end

  def to_param
    name
  end

  private

  def normalize_name
    self.name = name.downcase.strip.gsub(/\s+/, '-') if name.present?
  end
end

=begin

Python equivalents:

# Django Tag Model
from django.db import models

class Tag(models.Model):
    name = models.CharField(max_length=50, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.name

    @property
    def posts_count(self):
        return self.posts.count()

    def clean(self):
        self.name = self.name.lower().strip().replace(' ', '-')

# SQLAlchemy Tag Model
from sqlalchemy import Column, Integer, String, DateTime, Table
from sqlalchemy.orm import relationship
from datetime import datetime

# Many-to-many association table
post_tags = Table('post_tags', Base.metadata,
    Column('post_id', Integer, ForeignKey('posts.id')),
    Column('tag_id', Integer, ForeignKey('tags.id'))
)

class Tag(Base):
    __tablename__ = "tags"

    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    posts = relationship("Post", secondary=post_tags, back_populates="tags")

    @property
    def posts_count(self):
        return len(self.posts)

    @classmethod
    def get_popular(cls, db_session, limit=10):
        return (db_session.query(cls)
                .join(post_tags)
                .group_by(cls.id)
                .order_by(db.func.count(post_tags.c.post_id).desc())
                .limit(limit)
                .all())

# Pydantic schema for FastAPI
from pydantic import BaseModel, Field, validator
from datetime import datetime

class TagBase(BaseModel):
    name: str = Field(..., min_length=2, max_length=50)

    @validator('name')
    def normalize_name(cls, v):
        return v.lower().strip().replace(' ', '-')

class TagCreate(TagBase):
    pass

class TagResponse(TagBase):
    id: int
    posts_count: int = 0
    created_at: datetime

    class Config:
        from_attributes = True

# MongoDB with Mongoengine (alternative)
from mongoengine import Document, StringField, DateTimeField, ListField, ReferenceField
from datetime import datetime

class Tag(Document):
    name = StringField(required=True, unique=True, max_length=50)
    created_at = DateTimeField(default=datetime.utcnow)

    meta = {
        'collection': 'tags',
        'ordering': ['name']
    }

    def clean(self):
        self.name = self.name.lower().strip().replace(' ', '-')

    @property
    def posts_count(self):
        return Post.objects(tags=self).count()

=end
