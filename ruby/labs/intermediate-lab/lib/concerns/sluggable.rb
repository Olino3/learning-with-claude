# Sluggable Concern (Tutorial 13: Mixins with prepend)
# Generates URL-friendly slugs from titles

module Sluggable
  def self.included(base)
    base.class_eval do
      attr_reader :slug
    end
  end

  def generate_slug(text)
    @slug = text
      .to_s
      .downcase
      .strip
      .gsub(/\s+/, '-')
      .gsub(/[^\w-]/, '')
      .gsub(/-+/, '-')
  end

  def to_slug
    @slug
  end
end
