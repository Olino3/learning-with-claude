# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'task'

# TaskRepository implements the Repository Pattern for task persistence.
# It abstracts the data storage layer, making it easy to swap implementations
# (e.g., file storage → database) without changing business logic.
#
# Design Patterns:
# - Repository Pattern: Mediates between domain and data mapping layers
# - Dependency Injection: Storage path is configurable
# - Single Responsibility: Only handles data persistence
#
# Example:
#   repo = TaskRepository.new('tasks.json')
#   task = Task.new(title: 'Learn Ruby')
#   repo.save(task)
#   found_task = repo.find(task.id)
class TaskRepository
  attr_reader :storage_path

  # Default storage location
  DEFAULT_STORAGE_PATH = 'tasks.json'

  # Creates a new TaskRepository instance
  #
  # @param storage_path [String] Path to the storage file
  def initialize(storage_path = DEFAULT_STORAGE_PATH)
    @storage_path = storage_path
    ensure_storage_file_exists
  end

  # Saves a task to the repository
  # If a task with the same ID exists, it will be updated
  #
  # @param task [Task] The task to save
  # @return [Task] The saved task
  # @raise [ArgumentError] if task is invalid
  def save(task)
    raise ArgumentError, 'Task cannot be nil' if task.nil?
    raise ArgumentError, 'Invalid task object' unless task.is_a?(Task)

    tasks = load_all_tasks
    # Remove existing task with same ID if present (upsert behavior)
    tasks.reject! { |t| t.id == task.id }
    tasks << task
    persist_tasks(tasks)
    task
  end

  # Finds a task by its ID
  #
  # @param id [String] The task ID to search for
  # @return [Task, nil] The found task or nil if not found
  def find(id)
    load_all_tasks.find { |task| task.id == id }
  end

  # Retrieves all tasks from the repository
  #
  # @return [Array<Task>] Array of all tasks
  def all
    load_all_tasks
  end

  # Filters tasks by status
  #
  # @param status [Symbol] The status to filter by (:pending or :completed)
  # @return [Array<Task>] Array of matching tasks
  def find_by_status(status)
    load_all_tasks.select { |task| task.status == status }
  end

  # Searches tasks by keyword in title or description
  #
  # @param keyword [String] The search term
  # @return [Array<Task>] Array of matching tasks
  def search(keyword)
    return [] if keyword.nil? || keyword.strip.empty?

    load_all_tasks.select { |task| task.matches?(keyword) }
  end

  # Deletes a task by ID
  #
  # @param id [String] The task ID to delete
  # @return [Boolean] true if task was deleted, false if not found
  def delete(id)
    tasks = load_all_tasks
    original_count = tasks.size
    tasks.reject! { |task| task.id == id }

    if tasks.size < original_count
      persist_tasks(tasks)
      true
    else
      false
    end
  end

  # Checks if a task exists
  #
  # @param id [String] The task ID to check
  # @return [Boolean] true if task exists
  def exists?(id)
    !find(id).nil?
  end

  # Counts total number of tasks
  #
  # @return [Integer] Total task count
  def count
    load_all_tasks.size
  end

  # Counts tasks by status
  #
  # @param status [Symbol] The status to count
  # @return [Integer] Number of tasks with given status
  def count_by_status(status)
    find_by_status(status).size
  end

  # Deletes all tasks (use with caution!)
  #
  # @return [Boolean] true if successful
  def clear
    persist_tasks([])
    true
  end

  # Returns repository statistics
  #
  # @return [Hash] Statistics about tasks
  def stats
    tasks = load_all_tasks
    {
      total: tasks.size,
      pending: tasks.count(&:pending?),
      completed: tasks.count(&:completed?),
      completion_rate: calculate_completion_rate(tasks)
    }
  end

  private

  # Loads all tasks from the storage file
  #
  # @return [Array<Task>] Array of task objects
  def load_all_tasks
    return [] unless File.exist?(storage_path)

    data = File.read(storage_path)
    return [] if data.strip.empty?

    JSON.parse(data).map { |task_hash| Task.from_h(task_hash) }
  rescue JSON::ParserError => e
    warn "Warning: Could not parse tasks file: #{e.message}"
    []
  rescue StandardError => e
    warn "Warning: Error loading tasks: #{e.message}"
    []
  end

  # Persists tasks to the storage file
  # Uses atomic write to prevent data corruption
  #
  # @param tasks [Array<Task>] Tasks to persist
  def persist_tasks(tasks)
    data = tasks.map(&:to_h).to_json
    # Atomic write: write to temp file, then rename
    temp_path = "#{storage_path}.tmp"

    File.write(temp_path, data)
    File.rename(temp_path, storage_path)
  rescue StandardError => e
    # Clean up temp file if it exists
    File.delete(temp_path) if File.exist?(temp_path)
    raise "Failed to save tasks: #{e.message}"
  end

  # Ensures the storage file exists
  def ensure_storage_file_exists
    return if File.exist?(storage_path)

    # Create parent directory if needed
    dir = File.dirname(storage_path)
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    # Create empty file
    File.write(storage_path, '[]')
  end

  # Calculates completion rate as a percentage
  #
  # @param tasks [Array<Task>] Tasks to analyze
  # @return [Float] Completion rate (0-100)
  def calculate_completion_rate(tasks)
    return 0.0 if tasks.empty?

    completed_count = tasks.count(&:completed?)
    (completed_count.to_f / tasks.size * 100).round(2)
  end
end
