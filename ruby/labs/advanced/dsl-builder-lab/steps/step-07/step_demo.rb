#!/usr/bin/env ruby
# Step 7: Basic Query Builder with Method Chaining

class QueryBuilder
  def initialize(table_name)
    @table = table_name
    @conditions = []
    @order_clause = nil
    @limit_value = nil
  end

  def where(conditions)
    if conditions.is_a?(Hash)
      conditions.each do |column, value|
        @conditions << "#{column} = '#{value}'"
      end
    elsif conditions.is_a?(String)
      @conditions << conditions
    end
    self  # Return self for chaining!
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
puts "Step 7: Query Builder with Method Chaining"
puts "=" * 60
puts

# Simple query
query1 = QueryBuilder.new(:users)
  .where(active: true)
  .limit(10)

puts "Query 1 (simple):"
puts "  #{query1.to_sql}"
puts

# Chained query with multiple conditions
query2 = QueryBuilder.new(:users)
  .where(active: true)
  .where("age > 18")
  .order(:created_at, :desc)
  .limit(10)

puts "Query 2 (chained conditions):"
puts "  #{query2.to_sql}"
puts

# Different table
query3 = QueryBuilder.new(:posts)
  .where(published: true)
  .where("view_count > 100")
  .order(:title)

puts "Query 3 (posts):"
puts "  #{query3.to_sql}"
puts

puts "✓ Step 7 complete!"
