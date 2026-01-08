# Query Builder (Tutorial 14: Metaprogramming + Tutorial 16: Idiomatic Ruby)
# Chainable query interface using method chaining

module BlogSystem
  class QueryBuilder
    def initialize(collection)
      @collection = collection
      @filters = []
      @sort_by = nil
      @sort_order = :asc
      @limit_value = nil
    end

    # Chainable where clause (Tutorial 16: Idiomatic Ruby)
    def where(conditions = nil, &block)
      if block_given?
        @filters << block
      elsif conditions.is_a?(Hash)
        @filters << lambda do |item|
          conditions.all? { |key, value| item.send(key) == value }
        end
      end
      self
    end

    def order_by(attribute, direction = :asc)
      @sort_by = attribute
      @sort_order = direction
      self
    end

    def limit(count)
      @limit_value = count
      self
    end

    # Execute the query (Tutorial 16: Enumerable)
    def all
      results = @collection.select do |item|
        @filters.all? { |filter| filter.call(item) }
      end

      if @sort_by
        results = results.sort_by { |item| item.send(@sort_by) }
        results = results.reverse if @sort_order == :desc
      end

      results = results.first(@limit_value) if @limit_value

      results
    end

    def first
      all.first
    end

    def count
      all.count
    end

    # method_missing for dynamic finders (Tutorial 14: Metaprogramming)
    def method_missing(method_name, *args)
      method_str = method_name.to_s

      if method_str.start_with?("find_by_")
        attribute = method_str.sub("find_by_", "").to_sym
        @collection.find { |item| item.send(attribute) == args.first }
      elsif method_str.start_with?("find_all_by_")
        attribute = method_str.sub("find_all_by_", "").to_sym
        @collection.select { |item| item.send(attribute) == args.first }
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_str = method_name.to_s
      method_str.start_with?("find_by_", "find_all_by_") || super
    end
  end
end
