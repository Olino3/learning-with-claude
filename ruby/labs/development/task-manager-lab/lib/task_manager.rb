# frozen_string_literal: true

require_relative 'task'
require_relative 'task_repository'

# TaskManager is the main service class that orchestrates task management operations.
# It implements the Service Object pattern, coordinating between the repository
# and task entities to provide high-level business operations.
#
# Design Patterns:
# - Service Object: Encapsulates business logic
# - Dependency Injection: Repository is injected, making this testable
# - Facade: Provides a simplified interface to the task management subsystem
#
# Example:
#   manager = TaskManager.new
#   task_id = manager.add_task('Buy milk', 'Get 2% milk')
#   manager.complete_task(task_id)
#   tasks = manager.list_tasks(status: :completed)
class TaskManager
  attr_reader :repository

  # Creates a new TaskManager instance
  #
  # @param repository [TaskRepository] The repository for task persistence
  #                                     (defaults to new TaskRepository)
  def initialize(repository: TaskRepository.new)
    @repository = repository
  end

  # Adds a new task to the system
  #
  # @param title [String] The task title (required)
  # @param description [String] The task description (optional)
  # @return [String] The ID of the created task
  # @raise [ArgumentError] if title is invalid
  #
  # Example:
  #   id = manager.add_task('Buy groceries', 'Milk, eggs, bread')
  def add_task(title, description = '')
    raise ArgumentError, 'Title is required' if title.nil? || title.strip.empty?

    task = Task.new(title: title.strip, description: description.strip)
    repository.save(task)
    task.id
  end

  # Lists tasks, optionally filtered by status
  #
  # @param status [Symbol, nil] Filter by status (:pending, :completed, or nil for all)
  # @return [Array<Task>] Array of matching tasks
  #
  # Example:
  #   pending_tasks = manager.list_tasks(status: :pending)
  #   all_tasks = manager.list_tasks
  def list_tasks(status: nil)
    if status.nil?
      repository.all
    else
      repository.find_by_status(status)
    end
  end

  # Marks a task as completed
  #
  # @param id [String] The task ID
  # @return [Task] The updated task
  # @raise [TaskNotFoundError] if task doesn't exist
  #
  # Example:
  #   manager.complete_task('abc123')
  def complete_task(id)
    task = find_task!(id)
    return task if task.completed?

    completed_task = task.complete
    repository.save(completed_task)
    completed_task
  end

  # Deletes a task
  #
  # @param id [String] The task ID
  # @return [Boolean] true if task was deleted
  # @raise [TaskNotFoundError] if task doesn't exist
  #
  # Example:
  #   manager.delete_task('abc123')
  def delete_task(id)
    find_task!(id) # Ensure task exists
    repository.delete(id)
  end

  # Retrieves a specific task
  #
  # @param id [String] The task ID
  # @return [Task] The found task
  # @raise [TaskNotFoundError] if task doesn't exist
  #
  # Example:
  #   task = manager.get_task('abc123')
  def get_task(id)
    find_task!(id)
  end

  # Searches for tasks by keyword
  #
  # @param keyword [String] Search term
  # @return [Array<Task>] Matching tasks
  #
  # Example:
  #   results = manager.search_tasks('milk')
  def search_tasks(keyword)
    raise ArgumentError, 'Search keyword cannot be empty' if keyword.nil? || keyword.strip.empty?

    repository.search(keyword.strip)
  end

  # Returns statistics about tasks
  #
  # @return [Hash] Task statistics
  #
  # Example:
  #   stats = manager.statistics
  #   puts "Total: #{stats[:total]}"
  #   puts "Completion rate: #{stats[:completion_rate]}%"
  def statistics
    repository.stats
  end

  # Returns a summary of current tasks
  #
  # @return [Hash] Summary information
  def summary
    stats = statistics
    {
      total_tasks: stats[:total],
      pending_tasks: stats[:pending],
      completed_tasks: stats[:completed],
      completion_rate: "#{stats[:completion_rate]}%"
    }
  end

  # Checks if any tasks exist
  #
  # @return [Boolean] true if there are any tasks
  def any_tasks?
    repository.count.positive?
  end

  # Checks if a task exists
  #
  # @param id [String] The task ID
  # @return [Boolean] true if task exists
  def task_exists?(id)
    repository.exists?(id)
  end

  private

  # Finds a task or raises an error
  #
  # @param id [String] The task ID
  # @return [Task] The found task
  # @raise [TaskNotFoundError] if task doesn't exist
  def find_task!(id)
    task = repository.find(id)
    raise TaskNotFoundError, "Task with ID '#{id}' not found" if task.nil?

    task
  end
end

# Custom error class for task not found scenarios
class TaskNotFoundError < StandardError; end
