# frozen_string_literal: true

module Serializers
  def serialize_user(user, include_stats: false)
    data = {
      id: user.id,
      email: user.email,
      name: user.name,
      created_at: user.created_at.iso8601
    }

    if include_stats
      data.merge!(
        posts_count: user.posts.count,
        published_posts_count: user.posts.where(published: true).count,
        comments_count: user.comments.count
      )
    end

    data
  end

  def serialize_post(post, include_comments: false)
    data = {
      id: post.id,
      title: post.title,
      content: post.content,
      excerpt: post.content.length > 150 ? "#{post.content[0...150]}..." : post.content,
      published: post.published,
      author: {
        id: post.user.id,
        name: post.user.name,
        email: post.user.email
      },
      tags: post.tags.map { |tag| serialize_tag(tag) },
      comments_count: post.comments.count,
      created_at: post.created_at.iso8601,
      updated_at: post.updated_at.iso8601
    }

    if include_comments
      data[:comments] = post.comments.map { |comment| serialize_comment(comment) }
    end

    data
  end

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

  def serialize_tag(tag)
    {
      id: tag.id,
      name: tag.name,
      posts_count: tag.posts.count
    }
  end
end
