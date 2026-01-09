# frozen_string_literal: true

require 'securerandom'
require 'time'

# Task represents a single task entity in the task management system.
# This is a Value Object that encapsulates task data and behavior.
#
# Design Patterns:
# - Value Object: Immutable object defined by its attributes
# - Data Validation: Ensures data integrity at creation time
#
# Example:
#   task = Task.new(
#     title: 'Buy groceries',
#     description: 'Milk, eggs, bread'
#   )
#   puts task.title # => "Buy groceries"
#   puts task.status # => :pending
class Task
  attr_reader :id, :title, :description, :status, :created_at, :completed_at

  # Status constants for type safety
  VALID_STATUSES = %i[pending completed].freeze

  # Creates a new Task instance
  #
  # @param id [String] Unique identifier (auto-generated if not provided)
  # @param title [String] Task title (required, max 100 chars)
  # @param description [String] Task description (optional, max 500 chars)
  # @param status [Symbol] Task status (:pending or :completed)
  # @param created_at [Time] Creation timestamp
  # @param completed_at [Time, nil] Completion timestamp
  #
  # @raise [ArgumentError] if validation fails
  def initialize(id: nil, title:, description: '', status: :pending,
                 created_at: Time.now, completed_at: nil)
    @id = id || generate_id
    @title = title
    @description = description
    @status = status
    @created_at = created_at
    @completed_at = completed_at

    validate!
    freeze # Make immutable after creation
  end

  # Marks the task as completed
  # Returns a new Task instance (immutable pattern)
  #
  # @return [Task] New task with completed status
  def complete
    return self if completed?

    Task.new(
      id: id,
      title: title,
      description: description,
      status: :completed,
      created_at: created_at,
      completed_at: Time.now
    )
  end

  # Checks if the task is completed
  #
  # @return [Boolean] true if status is :completed
  def completed?
    status == :completed
  end

  # Checks if the task is pending
  #
  # @return [Boolean] true if status is :pending
  def pending?
    status == :pending
  end

  # Searches for a keyword in title or description
  #
  # @param keyword [String] Search term
  # @return [Boolean] true if keyword is found (case-insensitive)
  def matches?(keyword)
    search_text = "#{title} #{description}".downcase
    search_text.include?(keyword.downcase)
  end

  # Converts task to a hash for serialization
  #
  # @return [Hash] Task data as hash
  def to_h
    {
      id: id,
      title: title,
      description: description,
      status: status.to_s,
      created_at: created_at.iso8601,
      completed_at: completed_at&.iso8601
    }
  end

  # Creates a Task from a hash (deserialization)
  #
  # @param hash [Hash] Task data
  # @return [Task] New task instance
  def self.from_h(hash)
    new(
      id: hash['id'] || hash[:id],
      title: hash['title'] || hash[:title],
      description: hash['description'] || hash[:description] || '',
      status: (hash['status'] || hash[:status]).to_sym,
      created_at: parse_time(hash['created_at'] || hash[:created_at]),
      completed_at: parse_time(hash['completed_at'] || hash[:completed_at])
    )
  end

  # String representation of the task
  #
  # @return [String] Formatted task information
  def to_s
    status_symbol = completed? ? '✓' : '○'
    "[#{status_symbol}] #{title} (#{id})"
  end

  # Detailed string representation
  #
  # @return [String] Detailed task information
  def inspect
    "#<Task id=#{id} title=\"#{title}\" status=#{status}>"
  end

  private

  # Generates a unique ID for the task
  #
  # @return [String] 8-character unique ID
  def generate_id
    SecureRandom.hex(4)
  end

  # Validates task attributes
  #
  # @raise [ArgumentError] if validation fails
  def validate!
    raise ArgumentError, 'Title cannot be empty' if title.nil? || title.strip.empty?
    raise ArgumentError, 'Title too long (max 100 characters)' if title.length > 100
    raise ArgumentError, 'Description too long (max 500 characters)' if description.length > 500
    raise ArgumentError, "Invalid status: #{status}" unless VALID_STATUSES.include?(status)
  end

  # Parses a time string or returns the time object
  #
  # @param time [String, Time, nil] Time to parse
  # @return [Time, nil] Parsed time or nil
  def self.parse_time(time)
    return nil if time.nil?
    return time if time.is_a?(Time)

    Time.parse(time)
  rescue ArgumentError
    nil
  end
end
