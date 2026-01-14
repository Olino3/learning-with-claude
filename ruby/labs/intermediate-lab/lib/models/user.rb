# User Model (All intermediate concepts)

require_relative '../concerns/timestampable'
require_relative '../concerns/validatable'

module BlogSystem
  class User
    include Timestampable  # Tutorial 13: Mixins
    include Validatable    # Tutorial 13 + 14: Mixins + Metaprogramming

    attr_accessor :name, :email, :bio
    attr_reader :id

    # Class-level storage (Tutorial 12: Object Model)
    @@users = []
    @@next_id = 1

    # Validation rules (Tutorial 14: Metaprogramming DSL)
    validates :name, presence: true, length: { min: 2 }
    validates :email, presence: true
    validates :email, ->(email) { email.include?("@") }

    def initialize(name:, email:, bio: nil)
      super()  # Call Timestampable#initialize
      @id = @@next_id
      @@next_id += 1
      @name = name
      @email = email
      @bio = bio
    end

    # Memoization (Tutorial 16: Idiomatic Ruby)
    def posts
      @posts ||= Post.all.select { |p| p.author_id == @id }
    end

    # Instance method using closures (Tutorial 11)
    def filter_posts(&block)
      posts.select(&block)
    end

    # Class methods (Tutorial 12: Object Model - singleton class)
    class << self
      def all
        @@users
      end

      def create(attributes)
        user = new(**attributes)
        user.validate!
        @@users << user
        user
      rescue BlogSystem::ValidationError => e
        puts "Failed to create user: #{e.message}"
        nil
      end

      def find(id)
        @@users.find { |u| u.id == id } || raise(NotFoundError.new("User", id))
      end

      # Query builder (Tutorial 14 + 16)
      def where(conditions = nil, &block)
        QueryBuilder.new(@@users).where(conditions, &block)
      end

      # Dynamic finders (Tutorial 14: Metaprogramming)
      def method_missing(method_name, *args)
        if method_name.to_s.start_with?("find_by_")
          attribute = method_name.to_s.sub("find_by_", "").to_sym
          @@users.find { |user| user.send(attribute) == args.first }
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?("find_by_") || super
      end

      def exists?(id)
        @@users.any? { |u| u.id == id }
      end

      def clear_all
        @@users.clear
        @@next_id = 1
      end
    end

    def to_s
      "User(id: #{@id}, name: #{@name}, email: #{@email})"
    end
  end
end
