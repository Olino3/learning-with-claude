# frozen_string_literal: true

# JSON serialization helpers
#
# Converts model objects to JSON-friendly hashes.
# Provides consistent API response format.
#
# For Python developers:
# - Similar to Django REST Framework serializers
# - FastAPI's Pydantic models for response schemas
# - Marshmallow for Flask

module Serializers
  # Serialize a user object
  #
  # @param user [User] the user to serialize
  # @param include_stats [Boolean] include statistics
  # @return [Hash] serialized user data
  def serialize_user(user, include_stats: false)
    data = {
      id: user.id,
      email: user.email,
      name: user.name,
      created_at: user.created_at.iso8601
    }

    if include_stats
      data.merge!(
        posts_count: user.posts_count,
        published_posts_count: user.published_posts_count,
        comments_count: user.comments_count
      )
    end

    data
  end

  # Serialize a post object
  #
  # @param post [Post] the post to serialize
  # @param include_comments [Boolean] include comments
  # @return [Hash] serialized post data
  def serialize_post(post, include_comments: false)
    data = {
      id: post.id,
      title: post.title,
      content: post.content,
      excerpt: post.excerpt,
      published: post.published,
      author: {
        id: post.user.id,
        name: post.user.name,
        email: post.user.email
      },
      tags: post.tags.map { |tag| serialize_tag(tag) },
      comments_count: post.comments_count,
      created_at: post.created_at.iso8601,
      updated_at: post.updated_at.iso8601
    }

    if include_comments
      data[:comments] = post.comments.map { |comment| serialize_comment(comment) }
    end

    data
  end

  # Serialize a comment object
  #
  # @param comment [Comment] the comment to serialize
  # @return [Hash] serialized comment data
  def serialize_comment(comment)
    {
      id: comment.id,
      content: comment.content,
      author: {
        id: comment.user.id,
        name: comment.user.name
      },
      post_id: comment.post_id,
      created_at: comment.created_at.iso8601
    }
  end

  # Serialize a tag object
  #
  # @param tag [Tag] the tag to serialize
  # @return [Hash] serialized tag data
  def serialize_tag(tag)
    {
      id: tag.id,
      name: tag.name,
      posts_count: tag.posts_count
    }
  end

  # Serialize a collection with pagination metadata
  #
  # @param collection [Array] the collection to serialize
  # @param serializer [Symbol] the serializer method to use
  # @param meta [Hash] pagination metadata
  # @return [Hash] serialized collection with metadata
  def serialize_collection(collection, serializer, meta = {})
    {
      data: collection.map { |item| send(serializer, item) },
      meta: meta
    }
  end
end

=begin

Python equivalents:

# Django REST Framework Serializers
from rest_framework import serializers

class UserSerializer(serializers.ModelSerializer):
    posts_count = serializers.SerializerMethodField()
    comments_count = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'email', 'name', 'created_at', 'posts_count', 'comments_count']

    def get_posts_count(self, obj):
        return obj.posts.count()

    def get_comments_count(self, obj):
        return obj.comments.count()

class PostSerializer(serializers.ModelSerializer):
    author = UserSerializer(source='user', read_only=True)
    tags = serializers.StringRelatedField(many=True)
    comments_count = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ['id', 'title', 'content', 'published', 'author',
                  'tags', 'comments_count', 'created_at', 'updated_at']

    def get_comments_count(self, obj):
        return obj.comments.count()

class CommentSerializer(serializers.ModelSerializer):
    author = UserSerializer(source='user', read_only=True)

    class Meta:
        model = Comment
        fields = ['id', 'content', 'author', 'post_id', 'created_at']

# FastAPI with Pydantic
from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class UserResponse(BaseModel):
    id: int
    email: str
    name: str
    created_at: datetime
    posts_count: Optional[int] = None
    comments_count: Optional[int] = None

    class Config:
        from_attributes = True

class TagResponse(BaseModel):
    id: int
    name: str
    posts_count: int = 0

    class Config:
        from_attributes = True

class AuthorResponse(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        from_attributes = True

class PostResponse(BaseModel):
    id: int
    title: str
    content: str
    excerpt: str
    published: bool
    author: AuthorResponse
    tags: List[TagResponse]
    comments_count: int = 0
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class CommentResponse(BaseModel):
    id: int
    content: str
    author: AuthorResponse
    post_id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Flask with Marshmallow
from marshmallow import Schema, fields, EXCLUDE

class UserSchema(Schema):
    id = fields.Int(dump_only=True)
    email = fields.Email(required=True)
    name = fields.Str(required=True)
    created_at = fields.DateTime(dump_only=True)
    posts_count = fields.Method("get_posts_count")

    def get_posts_count(self, obj):
        return obj.posts.count()

    class Meta:
        unknown = EXCLUDE

class PostSchema(Schema):
    id = fields.Int(dump_only=True)
    title = fields.Str(required=True)
    content = fields.Str(required=True)
    published = fields.Bool()
    author = fields.Nested(UserSchema, only=['id', 'name', 'email'])
    tags = fields.List(fields.Nested('TagSchema'))
    comments_count = fields.Method("get_comments_count")
    created_at = fields.DateTime(dump_only=True)
    updated_at = fields.DateTime(dump_only=True)

    def get_comments_count(self, obj):
        return obj.comments.count()

user_schema = UserSchema()
users_schema = UserSchema(many=True)
post_schema = PostSchema()
posts_schema = PostSchema(many=True)

# Usage
@app.route('/api/posts/<int:post_id>')
def get_post(post_id):
    post = Post.query.get_or_404(post_id)
    return jsonify(post_schema.dump(post))

=end
