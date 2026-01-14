# Query Builder DSL - SQL query builder with fluent interface

class QueryBuilder
  attr_reader :table
  
  def initialize(table)
    @table = table
    @wheres = []
    @joins = []
    @orders = []
    @group_by = []
    @having = []
    @limit_value = nil
    @offset_value = nil
    @select_fields = ["*"]
  end
  
  # SELECT clause
  def select(*fields)
    @select_fields = fields
    self
  end
  
  # WHERE clause
  def where(condition = nil, &block)
    if block
      # Block-based condition
      @wheres << block
    elsif condition.is_a?(Hash)
      # Hash condition
      condition.each do |key, value|
        @wheres << "#{key} = '#{value}'"
      end
    elsif condition.is_a?(String)
      # String condition
      @wheres << condition
    end
    self
  end
  
  # JOIN clause
  def join(table, on:)
    @joins << "INNER JOIN #{table} ON #{on}"
    self
  end
  
  def left_join(table, on:)
    @joins << "LEFT JOIN #{table} ON #{on}"
    self
  end
  
  # ORDER BY clause
  def order(field, direction = :asc)
    @orders << "#{field} #{direction.to_s.upcase}"
    self
  end
  
  # GROUP BY clause
  def group(*fields)
    @group_by += fields
    self
  end
  
  # HAVING clause
  def having(condition)
    @having << condition
    self
  end
  
  # LIMIT clause
  def limit(n)
    @limit_value = n
    self
  end
  
  # OFFSET clause
  def offset(n)
    @offset_value = n
    self
  end
  
  # Generate SQL
  def to_sql
    sql = "SELECT #{@select_fields.join(', ')} FROM #{@table}"
    
    # Add JOINs
    sql += " #{@joins.join(' ')}" unless @joins.empty?
    
    # Add WHERE clause
    unless @wheres.empty?
      where_conditions = @wheres.map do |w|
        w.is_a?(String) ? w : "(custom condition)"
      end
      sql += " WHERE #{where_conditions.join(' AND ')}"
    end
    
    # Add GROUP BY
    sql += " GROUP BY #{@group_by.join(', ')}" unless @group_by.empty?
    
    # Add HAVING
    sql += " HAVING #{@having.join(' AND ')}" unless @having.empty?
    
    # Add ORDER BY
    sql += " ORDER BY #{@orders.join(', ')}" unless @orders.empty?
    
    # Add LIMIT
    sql += " LIMIT #{@limit_value}" if @limit_value
    
    # Add OFFSET
    sql += " OFFSET #{@offset_value}" if @offset_value
    
    sql
  end
  
  # Execute query (simulated)
  def execute
    puts "Executing: #{to_sql}"
    []  # Return empty array for demo
  end
  
  # Pretty print
  def inspect
    to_sql
  end
  
  # Class method to start query
  def self.from(table)
    new(table)
  end
end

# Model with query builder
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
  
  def self.select(*fields)
    all.select(*fields)
  end
  
  def self.find(id)
    where(id: id).limit(1)
  end
  
  def self.find_by(conditions)
    where(conditions).limit(1)
  end
end

# Example models
class User < Model
end

class Post < Model
end

class Comment < Model
end
