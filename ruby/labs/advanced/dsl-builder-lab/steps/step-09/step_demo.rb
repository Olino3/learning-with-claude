#!/usr/bin/env ruby
# Step 9: Complete Query Builder with Joins

class QueryBuilder
  def initialize(table_name)
    @table = table_name
    @select_fields = ["*"]
    @conditions = []
    @joins = []
    @order_clause = nil
    @limit_value = nil
    @offset_value = nil
  end

  def select(*fields)
    @select_fields = fields
    self
  end

  def where(conditions = nil, &block)
    if block_given?
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

  # NEW: Join support
  def join(table, on:)
    @joins << "INNER JOIN #{table} ON #{on}"
    self
  end

  def left_join(table, on:)
    @joins << "LEFT JOIN #{table} ON #{on}"
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

  def offset(count)
    @offset_value = count
    self
  end

  def to_sql
    sql = "SELECT #{@select_fields.join(', ')} FROM #{@table}"

    # Add JOINs
    sql += " #{@joins.join(' ')}" unless @joins.empty?

    # Add WHERE
    unless @conditions.empty?
      sql += " WHERE #{@conditions.join(' AND ')}"
    end

    sql += " ORDER BY #{@order_clause}" if @order_clause
    sql += " LIMIT #{@limit_value}" if @limit_value
    sql += " OFFSET #{@offset_value}" if @offset_value

    sql
  end

  def self.from(table)
    new(table)
  end
end

class ColumnProxy
  def initialize(column)
    @column = column
  end

  def >(value) = "#{@column} > #{value}"
  def <(value) = "#{@column} < #{value}"
  def ==(value) = "#{@column} = '#{value}'"
  def >=(value) = "#{@column} >= #{value}"
  def <=(value) = "#{@column} <= #{value}"
end

class ConditionBuilder
  def method_missing(method_name, *args)
    ColumnProxy.new(method_name.to_s)
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end

# Model base class
class Model
  def self.table_name
    name.downcase + "s"
  end

  def self.all
    QueryBuilder.from(table_name)
  end

  def self.where(*args, &block)
    all.where(*args, &block)
  end

  def self.order(*args)
    all.order(*args)
  end

  def self.limit(n)
    all.limit(n)
  end
end

class User < Model; end
class Post < Model; end

# Test it
puts "=" * 60
puts "Step 9: Complete Query Builder with Joins"
puts "=" * 60
puts

# Query with joins
query1 = QueryBuilder.from(:posts)
  .select("posts.*", "users.name as author_name")
  .join(:users, on: "posts.user_id = users.id")
  .where(published: true)
  .order(:created_at, :desc)
  .limit(10)

puts "Query 1 (with JOIN):"
puts "  #{query1.to_sql}"
puts

# Left join example
query2 = QueryBuilder.from(:users)
  .select("users.*", "COUNT(posts.id) as post_count")
  .left_join(:posts, on: "users.id = posts.user_id")
  .where("users.active = 'true'")

puts "Query 2 (LEFT JOIN):"
puts "  #{query2.to_sql}"
puts

# Using Model class
query3 = User
  .where(active: true)
  .order(:name)
  .limit(20)

puts "Query 3 (via Model class):"
puts "  #{query3.to_sql}"
puts

# Pagination example
query4 = Post
  .where(published: true)
  .order(:created_at, :desc)
  .limit(10)
  .offset(20)

puts "Query 4 (pagination - page 3):"
puts "  #{query4.to_sql}"
puts

puts "=" * 60
puts "✓ Step 9 complete! DSL Builder Lab finished!"
puts "=" * 60
