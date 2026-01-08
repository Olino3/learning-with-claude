# Post Model (All intermediate concepts)

require_relative '../concerns/timestampable'
require_relative '../concerns/validatable'
require_relative '../concerns/sluggable'

module BlogSystem
  class Post
    include Timestampable  # Tutorial 13: Mixins
    include Validatable    # Tutorial 13 + 14
    include Sluggable      # Tutorial 13

    attr_accessor :title, :content, :author_id, :published, :view_count
    attr_reader :id

    @@posts = []
    @@next_id = 1

    # Validation DSL (Tutorial 14: Metaprogramming)
    validates :title, presence: true, length: { min: 5, max: 200 }
    validates :content, presence: true, length: { min: 10 }
    validates :author_id, ->(id) { User.exists?(id) }

    def initialize(title:, content:, author_id:, published: false)
      super()  # Call Timestampable#initialize
      @id = @@next_id
      @@next_id += 1
      @title = title
      @content = content
      @author_id = author_id
      @published = published
      @view_count = 0

      # Generate slug (Tutorial 13: Sluggable)
      generate_slug(title)
    end

    # Lazy loading with memoization (Tutorial 16: Idiomatic Ruby)
    def author
      @author ||= User.find(author_id)
    rescue NotFoundError
      nil
    end

    def comments
      @comments ||= Comment.all.select { |c| c.post_id == @id }
    end

    # Business logic with error handling (Tutorial 15)
    def publish!
      raise PermissionError, "Post already published" if @published

      @published = true
      touch
      self
    end

    def increment_views
      @view_count += 1
      self
    end

    # Search using closures (Tutorial 11: Blocks, Procs, Lambdas)
    def self.search(&block)
      @@posts.select(&block)
    end

    # Class methods (Tutorial 12: Object Model)
    class << self
      def all
        @@posts
      end

      def published
        @@posts.select(&:published)
      end

      def create(attributes)
        post = new(**attributes)
        post.validate!
        @@posts << post
        post
      rescue BlogSystem::ValidationError => e
        puts "Failed to create post: #{e.message}"
        nil
      end

      def find(id)
        @@posts.find { |p| p.id == id } || raise(NotFoundError.new("Post", id))
      end

      def find_by_slug(slug)
        @@posts.find { |p| p.slug == slug }
      end

      # Query builder (Tutorial 16: Idiomatic Ruby)
      def where(conditions = nil, &block)
        QueryBuilder.new(@@posts).where(conditions, &block)
      end

      # Dynamic finders (Tutorial 14: Metaprogramming)
      def method_missing(method_name, *args)
        if method_name.to_s.start_with?("find_by_")
          attribute = method_name.to_s.sub("find_by_", "").to_sym
          @@posts.find { |post| post.send(attribute) == args.first }
        elsif method_name.to_s.start_with?("find_all_by_")
          attribute = method_name.to_s.sub("find_all_by_", "").to_sym
          @@posts.select { |post| post.send(attribute) == args.first }
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_str = method_name.to_s
        method_str.start_with?("find_by_", "find_all_by_") || super
      end

      def clear_all
        @@posts.clear
        @@next_id = 1
      end
    end

    def to_s
      status = @published ? "Published" : "Draft"
      "Post(id: #{@id}, title: '#{@title}', author: #{author&.name}, #{status}, views: #{@view_count})"
    end
  end
end
