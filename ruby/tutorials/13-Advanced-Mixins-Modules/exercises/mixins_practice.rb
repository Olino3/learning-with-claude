#!/usr/bin/env ruby
# Advanced Mixins and Modules Practice Script

puts "=== Advanced Mixins and Modules Practice ==="
puts

# Section 1: Include - Adding Instance Methods
puts "1. Include - Adding Instance Methods"
puts "-" * 40

module Swimmable
  def swim
    "#{name} is swimming"
  end
end

module Flyable
  def fly
    "#{name} is flying"
  end
end

class Duck
  include Swimmable
  include Flyable

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

duck = Duck.new("Donald")
puts duck.swim
puts duck.fly

puts "\nDuck.ancestors:"
Duck.ancestors.each { |a| puts "  - #{a}" }
puts

# Section 2: Extend - Adding Class Methods
puts "2. Extend - Adding Class Methods"
puts "-" * 40

module Findable
  def find(id)
    "Finding record with id: #{id}"
  end

  def all
    "Getting all records"
  end

  def count
    42
  end
end

class User
  extend Findable

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

puts User.find(1)
puts User.all
puts "User.count = #{User.count}"

puts "\nUser instance doesn't have these methods:"
user = User.new("Alice")
puts "user.respond_to?(:find) = #{user.respond_to?(:find)}"
puts

# Section 3: Extend on Individual Instances
puts "3. Extend on Individual Instances"
puts "-" * 40

module SuperPowers
  def fly
    "#{self} is flying!"
  end

  def invisibility
    "#{self} is invisible!"
  end
end

hero1 = "Superman"
hero2 = "Batman"

hero1.extend(SuperPowers)

puts hero1.fly
puts hero1.invisibility
puts "hero2.respond_to?(:fly) = #{hero2.respond_to?(:fly)}"
puts

# Section 4: Prepend - Method Override
puts "4. Prepend - Method Override"
puts "-" * 40

module Logging
  def save
    puts "  [LOG] About to save"
    result = super
    puts "  [LOG] Save completed"
    result
  end
end

class Document
  prepend Logging

  def save
    puts "  [SAVE] Saving document to disk"
    true
  end
end

doc = Document.new
puts "Calling doc.save:"
doc.save

puts "\nDocument.ancestors:"
Document.ancestors.first(5).each { |a| puts "  - #{a}" }
puts

# Section 5: Include vs Prepend
puts "5. Include vs Prepend Comparison"
puts "-" * 40

module GreetingModule
  def greet
    "Hello from module"
  end
end

class WithInclude
  include GreetingModule

  def greet
    "Hello from WithInclude class"
  end
end

class WithPrepend
  prepend GreetingModule

  def greet
    "Hello from WithPrepend class"
  end
end

puts "WithInclude: #{WithInclude.new.greet}"  # Class wins
puts "WithPrepend: #{WithPrepend.new.greet}"  # Module wins
puts

# Section 6: Module Hooks - included
puts "6. Module Hooks - included"
puts "-" * 40

module Trackable
  def self.included(base)
    puts "  Trackable included in #{base}"
    base.extend(ClassMethods)
  end

  def track_view
    "Tracking view for #{self.class}"
  end

  module ClassMethods
    def track_all
      "Tracking all #{self} instances"
    end
  end
end

class Article
  include Trackable
end

puts "\nUsing instance method:"
article = Article.new
puts article.track_view

puts "\nUsing class method:"
puts Article.track_all
puts

# Section 7: The Concern Pattern
puts "7. The Concern Pattern (Rails-style)"
puts "-" * 40

module Commentable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      attr_accessor :comments
    end
  end

  # Instance methods
  def add_comment(text)
    @comments ||= []
    @comments << { text: text, time: Time.now }
  end

  def comment_count
    @comments&.length || 0
  end

  def latest_comment
    @comments&.last
  end

  # Class methods
  module ClassMethods
    def most_commented
      "Finding most commented #{self}..."
    end

    def without_comments
      "Finding #{self} without comments..."
    end
  end
end

class BlogPost
  include Commentable

  attr_reader :title

  def initialize(title)
    @title = title
  end
end

post = BlogPost.new("Ruby Modules")
post.add_comment("Great post!")
post.add_comment("Thanks for sharing!")

puts "#{post.title} has #{post.comment_count} comments"
puts "Latest: #{post.latest_comment[:text]}"
puts BlogPost.most_commented
puts

# Section 8: Multiple Modules with Hooks
puts "8. Multiple Modules with Hooks"
puts "-" * 40

module Timestampable
  def self.included(base)
    puts "  Timestampable included"
    base.class_eval do
      attr_accessor :created_at, :updated_at
    end
  end

  def touch
    @updated_at = Time.now
  end
end

module Sluggable
  def self.included(base)
    puts "  Sluggable included"
  end

  def to_slug
    @title&.downcase&.gsub(/\s+/, '-')
  end
end

class Page
  include Timestampable
  include Sluggable

  attr_accessor :title

  def initialize(title)
    @title = title
    @created_at = Time.now
    @updated_at = Time.now
  end
end

puts "\nCreating page:"
page = Page.new("Hello World")
puts "Slug: #{page.to_slug}"
puts

# Section 9: Module Composition
puts "9. Module Composition"
puts "-" * 40

module Validatable
  def valid?
    errors.empty?
  end

  def errors
    @errors ||= []
  end

  def add_error(message)
    @errors ||= []
    @errors << message
  end
end

module Persistable
  def save
    return false unless valid?
    puts "  Saving #{self.class}..."
    true
  end

  def destroy
    puts "  Deleting #{self.class}..."
    true
  end
end

class Record
  include Validatable
  include Persistable

  attr_accessor :name

  def validate
    add_error("Name can't be blank") if name.nil? || name.empty?
  end
end

record = Record.new
record.name = ""
record.validate
puts "Valid? #{record.valid?}"
puts "Errors: #{record.errors.inspect}"

record.name = "Valid Name"
@errors = nil  # Reset
puts "After fixing: Valid? #{record.valid?}"
record.save
puts

# Section 10: Namespacing
puts "10. Namespacing with Modules"
puts "-" * 40

module API
  module V1
    class User
      def self.endpoint
        "/api/v1/users"
      end

      def to_json
        '{"version": "1.0"}'
      end
    end
  end

  module V2
    class User
      def self.endpoint
        "/api/v2/users"
      end

      def to_json
        '{"version": "2.0", "enhanced": true}'
      end
    end
  end
end

puts "V1 endpoint: #{API::V1::User.endpoint}"
puts "V1 JSON: #{API::V1::User.new.to_json}"

puts "V2 endpoint: #{API::V2::User.endpoint}"
puts "V2 JSON: #{API::V2::User.new.to_json}"
puts

# Section 11: Abstract Methods
puts "11. Abstract Methods Pattern"
puts "-" * 40

module Searchable
  def search(query)
    raise NotImplementedError, "#{self.class} must implement #search"
  end

  def search_all
    search("*")
  end
end

class Database
  include Searchable

  def search(query)
    "Searching database for: #{query}"
  end
end

class Cache
  include Searchable

  def search(query)
    "Searching cache for: #{query}"
  end
end

db = Database.new
puts db.search("users")
puts db.search_all

cache = Cache.new
puts cache.search("config")
puts

# Section 12: Template Method Pattern
puts "12. Template Method Pattern"
puts "-" * 40

module Workflow
  def execute
    before_execute
    result = perform
    after_execute
    result
  end

  def before_execute
    puts "  Starting workflow..."
  end

  def perform
    raise NotImplementedError, "Must implement #perform"
  end

  def after_execute
    puts "  Workflow complete!"
  end
end

class EmailWorkflow
  include Workflow

  def perform
    puts "  Sending email..."
    "Email sent"
  end
end

class DataProcessingWorkflow
  include Workflow

  def perform
    puts "  Processing data..."
    "Data processed"
  end

  def after_execute
    super
    puts "  Data saved to disk"
  end
end

puts "Email workflow:"
result = EmailWorkflow.new.execute
puts "Result: #{result}\n\n"

puts "Data processing workflow:"
result = DataProcessingWorkflow.new.execute
puts "Result: #{result}"
puts

# Section 13: Module with Configuration
puts "13. Module with Configuration"
puts "-" * 40

module Configurable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def config
      @config ||= {}
    end

    def configure
      yield config if block_given?
    end
  end

  def config
    self.class.config
  end
end

class Application
  include Configurable
end

Application.configure do |config|
  config[:app_name] = "MyApp"
  config[:version] = "1.0.0"
  config[:debug] = true
  config[:max_connections] = 100
end

app = Application.new
puts "App name: #{app.config[:app_name]}"
puts "Version: #{app.config[:version]}"
puts "Debug mode: #{app.config[:debug]}"
puts "Max connections: #{app.config[:max_connections]}"
puts

# Section 14: Method Lookup Order
puts "14. Method Lookup Order with Multiple Modules"
puts "-" * 40

module A
  def test
    "From module A"
  end
end

module B
  def test
    "From module B"
  end
end

module C
  def test
    "From module C"
  end
end

class ComplexDemo
  prepend A     # Highest priority
  include B     # Medium
  include C     # Lower

  def test
    "From class"
  end
end

puts "Method called: #{ComplexDemo.new.test}"
puts "\nLookup order:"
ComplexDemo.ancestors.first(6).each { |a| puts "  - #{a}" }
puts

# Section 15: Dependency Injection via Modules
puts "15. Dependency Injection via Modules"
puts "-" * 40

module Logger
  def log(message)
    puts "  [LOG] #{Time.now}: #{message}"
  end
end

module DatabaseConnection
  def connection
    @connection ||= "DB Connection ##{object_id}"
  end
end

module Queryable
  def self.included(base)
    base.include(DatabaseConnection)
    base.include(Logger)
  end

  def query(sql)
    log("Executing query: #{sql}")
    "#{connection}: #{sql} => Results"
  end
end

class Model
  include Queryable

  def find_all
    query("SELECT * FROM models")
  end
end

model = Model.new
puts model.find_all
puts

# Section 16: Mixin with State
puts "16. Mixin with Instance State"
puts "-" * 40

module Cacheable
  def cache
    @cache ||= {}
  end

  def cache_get(key)
    cache[key]
  end

  def cache_set(key, value)
    cache[key] = value
  end

  def cache_clear
    @cache = {}
  end
end

class ExpensiveCalculator
  include Cacheable

  def calculate(n)
    cached = cache_get(n)
    return cached if cached

    puts "  Computing expensive calculation for #{n}..."
    result = n * n * n
    cache_set(n, result)
    result
  end
end

calc = ExpensiveCalculator.new
puts "First call (computes): #{calc.calculate(5)}"
puts "Second call (cached): #{calc.calculate(5)}"
puts "Third call (cached): #{calc.calculate(5)}"
puts "New number (computes): #{calc.calculate(10)}"
puts

# Section 17: Module with both Instance and Singleton Methods
puts "17. Module with Instance and Singleton Methods"
puts "-" * 40

module Statistics
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Instance methods
  def average(numbers)
    numbers.sum / numbers.length.to_f
  end

  def median(numbers)
    sorted = numbers.sort
    mid = sorted.length / 2
    sorted.length.odd? ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2.0
  end

  # Class methods
  module ClassMethods
    def pi
      3.14159
    end

    def e
      2.71828
    end
  end
end

class MathHelper
  include Statistics
end

helper = MathHelper.new
puts "Average of [1,2,3,4,5]: #{helper.average([1, 2, 3, 4, 5])}"
puts "Median of [1,2,3,4,5]: #{helper.median([1, 2, 3, 4, 5])}"
puts "PI constant: #{MathHelper.pi}"
puts "E constant: #{MathHelper.e}"
puts

puts "=== Practice Complete! ==="
puts
puts "Key Takeaways for Python Developers:"
puts "1. include: Adds instance methods (like multiple inheritance)"
puts "2. extend: Adds class methods (singleton methods)"
puts "3. prepend: Overrides methods with super capability"
puts "4. Hooks: self.included/extended/prepended for metaprogramming"
puts "5. Concern pattern: Mix instance + class methods elegantly"
puts "6. Module lookup: Simple ancestor chain (vs Python's complex MRO)"
puts "7. Namespacing: Use :: to access nested modules/classes"
puts
