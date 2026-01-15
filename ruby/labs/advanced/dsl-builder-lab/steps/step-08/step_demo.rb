#!/usr/bin/env ruby
# Step 8: Block-Based Conditions

class ColumnProxy
  attr_reader :column

  def initialize(column)
    @column = column
  end

  def >(value)
    "#{@column} > #{value}"
  end

  def <(value)
    "#{@column} < #{value}"
  end

  def ==(value)
    "#{@column} = '#{value}'"
  end

  def >=(value)
    "#{@column} >= #{value}"
  end

  def <=(value)
    "#{@column} <= #{value}"
  end

  def like(value)
    "#{@column} LIKE '#{value}'"
  end
end

class ConditionBuilder
  def initialize
    @parts = []
  end

  def method_missing(method_name, *args)
    ColumnProxy.new(method_name.to_s)
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end

class QueryBuilder
  def initialize(table_name)
    @table = table_name
    @conditions = []
    @order_clause = nil
    @limit_value = nil
  end

  # Updated where to support blocks
  def where(conditions = nil, &block)
    if block_given?
      # Block-based condition
      builder = ConditionBuilder.new
      condition = builder.instance_eval(&block)
      @conditions << condition
    elsif conditions.is_a?(Hash)
      conditions.each do |column, value|
        @conditions << "#{column} = '#{value}'"
      end
    elsif conditions.is_a?(String)
      @conditions << conditions
    end
    self
  end

  def order(column, direction = :asc)
    @order_clause = "#{column} #{direction.to_s.upcase}"
    self
  end

  def limit(count)
    @limit_value = count
    self
  end

  def to_sql
    sql = "SELECT * FROM #{@table}"

    unless @conditions.empty?
      sql += " WHERE #{@conditions.join(' AND ')}"
    end

    sql += " ORDER BY #{@order_clause}" if @order_clause
    sql += " LIMIT #{@limit_value}" if @limit_value

    sql
  end
end

# Test it
puts "=" * 60
puts "Step 8: Block-Based Query Conditions"
puts "=" * 60
puts

# Block-based where clause
query1 = QueryBuilder.new(:users)
  .where { age > 18 }
  .where { status == "active" }
  .limit(10)

puts "Query 1 (block conditions):"
puts "  #{query1.to_sql}"
puts

# Mix of hash and block conditions
query2 = QueryBuilder.new(:posts)
  .where(published: true)
  .where { view_count >= 100 }
  .order(:created_at, :desc)

puts "Query 2 (mixed conditions):"
puts "  #{query2.to_sql}"
puts

# Complex conditions
query3 = QueryBuilder.new(:products)
  .where { price < 100 }
  .where { stock > 0 }
  .where(category: "electronics")

puts "Query 3 (complex filtering):"
puts "  #{query3.to_sql}"
puts

puts "✓ Step 8 complete!"
