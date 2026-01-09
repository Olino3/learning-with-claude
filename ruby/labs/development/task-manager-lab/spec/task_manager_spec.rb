# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TaskManager do
  let(:repository) { TaskRepository.new('test_task_manager.json') }
  let(:manager) { TaskManager.new(repository: repository) }

  after(:each) do
    File.delete('test_task_manager.json') if File.exist?('test_task_manager.json')
  end

  describe '#initialize' do
    it 'creates a manager with default repository' do
      manager = TaskManager.new

      expect(manager.repository).to be_a(TaskRepository)
    end

    it 'creates a manager with injected repository' do
      expect(manager.repository).to eq(repository)
    end
  end

  describe '#add_task' do
    it 'adds a new task and returns its ID' do
      id = manager.add_task('Buy milk', 'Get 2% milk')

      expect(id).to be_a(String)
      expect(id).not_to be_empty
    end

    it 'saves task to repository' do
      id = manager.add_task('Test Task', 'Description')
      task = repository.find(id)

      expect(task).not_to be_nil
      expect(task.title).to eq('Test Task')
      expect(task.description).to eq('Description')
    end

    it 'trims whitespace from title and description' do
      id = manager.add_task('  Test  ', '  Desc  ')
      task = repository.find(id)

      expect(task.title).to eq('Test')
      expect(task.description).to eq('Desc')
    end

    it 'handles empty description' do
      id = manager.add_task('Test')
      task = repository.find(id)

      expect(task.description).to eq('')
    end

    it 'raises error for nil title' do
      expect {
        manager.add_task(nil)
      }.to raise_error(ArgumentError, 'Title is required')
    end

    it 'raises error for empty title' do
      expect {
        manager.add_task('')
      }.to raise_error(ArgumentError, 'Title is required')
    end

    it 'raises error for whitespace-only title' do
      expect {
        manager.add_task('   ')
      }.to raise_error(ArgumentError, 'Title is required')
    end
  end

  describe '#list_tasks' do
    before do
      @pending_id = manager.add_task('Pending Task', 'Not done yet')
      @completed_id = manager.add_task('Completed Task', 'All done')
      manager.complete_task(@completed_id)
    end

    it 'lists all tasks when no status specified' do
      tasks = manager.list_tasks

      expect(tasks.size).to eq(2)
    end

    it 'lists pending tasks' do
      tasks = manager.list_tasks(status: :pending)

      expect(tasks.size).to eq(1)
      expect(tasks.first.id).to eq(@pending_id)
    end

    it 'lists completed tasks' do
      tasks = manager.list_tasks(status: :completed)

      expect(tasks.size).to eq(1)
      expect(tasks.first.id).to eq(@completed_id)
    end

    it 'returns empty array when no tasks' do
      repository.clear

      expect(manager.list_tasks).to eq([])
    end
  end

  describe '#complete_task' do
    it 'marks a task as completed' do
      id = manager.add_task('Test Task')
      completed = manager.complete_task(id)

      expect(completed.status).to eq(:completed)
      expect(completed.completed_at).to be_a(Time)
    end

    it 'persists completion to repository' do
      id = manager.add_task('Test Task')
      manager.complete_task(id)

      task = repository.find(id)
      expect(task.status).to eq(:completed)
    end

    it 'returns task if already completed' do
      id = manager.add_task('Test Task')
      first_complete = manager.complete_task(id)
      second_complete = manager.complete_task(id)

      expect(second_complete.id).to eq(first_complete.id)
      expect(second_complete.completed_at).to eq(first_complete.completed_at)
    end

    it 'raises error if task not found' do
      expect {
        manager.complete_task('nonexistent')
      }.to raise_error(TaskNotFoundError, "Task with ID 'nonexistent' not found")
    end
  end

  describe '#delete_task' do
    it 'deletes a task' do
      id = manager.add_task('Test Task')
      result = manager.delete_task(id)

      expect(result).to be true
      expect(repository.find(id)).to be_nil
    end

    it 'raises error if task not found' do
      expect {
        manager.delete_task('nonexistent')
      }.to raise_error(TaskNotFoundError, "Task with ID 'nonexistent' not found")
    end
  end

  describe '#get_task' do
    it 'retrieves a task by ID' do
      id = manager.add_task('Test Task', 'Description')
      task = manager.get_task(id)

      expect(task).to be_a(Task)
      expect(task.id).to eq(id)
      expect(task.title).to eq('Test Task')
    end

    it 'raises error if task not found' do
      expect {
        manager.get_task('nonexistent')
      }.to raise_error(TaskNotFoundError, "Task with ID 'nonexistent' not found")
    end
  end

  describe '#search_tasks' do
    before do
      manager.add_task('Buy milk', 'Get 2% milk')
      manager.add_task('Buy eggs', 'One dozen')
      manager.add_task('Clean kitchen', 'Dishes and floor')
    end

    it 'searches for tasks by keyword' do
      results = manager.search_tasks('Buy')

      expect(results.size).to eq(2)
      expect(results.map(&:title)).to all(start_with('Buy'))
    end

    it 'searches in description' do
      results = manager.search_tasks('floor')

      expect(results.size).to eq(1)
      expect(results.first.title).to eq('Clean kitchen')
    end

    it 'is case insensitive' do
      results = manager.search_tasks('MILK')

      expect(results.size).to eq(1)
    end

    it 'trims whitespace from keyword' do
      results = manager.search_tasks('  Buy  ')

      expect(results.size).to eq(2)
    end

    it 'raises error for empty keyword' do
      expect {
        manager.search_tasks('')
      }.to raise_error(ArgumentError, 'Search keyword cannot be empty')
    end

    it 'raises error for nil keyword' do
      expect {
        manager.search_tasks(nil)
      }.to raise_error(ArgumentError, 'Search keyword cannot be empty')
    end
  end

  describe '#statistics' do
    it 'returns stats for empty manager' do
      stats = manager.statistics

      expect(stats[:total]).to eq(0)
      expect(stats[:pending]).to eq(0)
      expect(stats[:completed]).to eq(0)
      expect(stats[:completion_rate]).to eq(0.0)
    end

    it 'returns stats with tasks' do
      manager.add_task('Pending 1')
      manager.add_task('Pending 2')
      id = manager.add_task('Completed')
      manager.complete_task(id)

      stats = manager.statistics

      expect(stats[:total]).to eq(3)
      expect(stats[:pending]).to eq(2)
      expect(stats[:completed]).to eq(1)
      expect(stats[:completion_rate]).to eq(33.33)
    end
  end

  describe '#summary' do
    it 'returns a formatted summary' do
      manager.add_task('Task 1')
      id = manager.add_task('Task 2')
      manager.complete_task(id)

      summary = manager.summary

      expect(summary[:total_tasks]).to eq(2)
      expect(summary[:pending_tasks]).to eq(1)
      expect(summary[:completed_tasks]).to eq(1)
      expect(summary[:completion_rate]).to eq('50.0%')
    end
  end

  describe '#any_tasks?' do
    it 'returns false when no tasks' do
      expect(manager.any_tasks?).to be false
    end

    it 'returns true when tasks exist' do
      manager.add_task('Test')

      expect(manager.any_tasks?).to be true
    end
  end

  describe '#task_exists?' do
    it 'returns true if task exists' do
      id = manager.add_task('Test')

      expect(manager.task_exists?(id)).to be true
    end

    it 'returns false if task does not exist' do
      expect(manager.task_exists?('nonexistent')).to be false
    end
  end

  describe 'integration scenarios' do
    it 'handles complete workflow' do
      # Add tasks
      id1 = manager.add_task('Buy groceries', 'Milk, eggs, bread')
      id2 = manager.add_task('Pay bills', 'Electric and water')
      id3 = manager.add_task('Call mom', 'Wish happy birthday')

      # List all tasks
      expect(manager.list_tasks.size).to eq(3)

      # Complete some tasks
      manager.complete_task(id1)
      manager.complete_task(id2)

      # Check pending tasks
      pending = manager.list_tasks(status: :pending)
      expect(pending.size).to eq(1)
      expect(pending.first.id).to eq(id3)

      # Check completed tasks
      completed = manager.list_tasks(status: :completed)
      expect(completed.size).to eq(2)

      # Search tasks
      results = manager.search_tasks('bills')
      expect(results.size).to eq(1)
      expect(results.first.title).to eq('Pay bills')

      # Delete task
      manager.delete_task(id3)
      expect(manager.list_tasks.size).to eq(2)

      # Check statistics
      stats = manager.statistics
      expect(stats[:total]).to eq(2)
      expect(stats[:completed]).to eq(2)
      expect(stats[:completion_rate]).to eq(100.0)
    end
  end
end
