# Comment Model

require_relative '../concerns/timestampable'
require_relative '../concerns/validatable'

module BlogSystem
  class Comment
    include Timestampable
    include Validatable

    attr_accessor :content, :author_id, :post_id, :parent_id
    attr_reader :id

    @@comments = []
    @@next_id = 1

    validates :content, presence: true, length: { min: 1, max: 500 }
    validates :author_id, ->(id) { User.exists?(id) }

    def initialize(content:, author_id:, post_id:, parent_id: nil)
      super()
      @id = @@next_id
      @@next_id += 1
      @content = content
      @author_id = author_id
      @post_id = post_id
      @parent_id = parent_id
    end

    def author
      @author ||= User.find(author_id)
    rescue NotFoundError
      nil
    end

    def post
      @post ||= Post.find(post_id)
    rescue NotFoundError
      nil
    end

    def replies
      @@comments.select { |c| c.parent_id == @id }
    end

    class << self
      def all
        @@comments
      end

      def create(attributes)
        comment = new(**attributes)
        comment.validate!
        @@comments << comment
        comment
      rescue BlogSystem::ValidationError => e
        puts "Failed to create comment: #{e.message}"
        nil
      end

      def find(id)
        @@comments.find { |c| c.id == id } || raise(NotFoundError.new("Comment", id))
      end

      def where(conditions = nil, &block)
        QueryBuilder.new(@@comments).where(conditions, &block)
      end

      def clear_all
        @@comments.clear
        @@next_id = 1
      end
    end

    def to_s
      "Comment(id: #{@id}, author: #{author&.name}, post: #{post_id})"
    end
  end
end
