# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

RSpec.describe TaskRepository do
  let(:test_storage_path) { 'test_tasks.json' }
  let(:repository) { TaskRepository.new(test_storage_path) }

  after(:each) do
    File.delete(test_storage_path) if File.exist?(test_storage_path)
  end

  describe '#initialize' do
    it 'creates a new repository with default path' do
      repo = TaskRepository.new

      expect(repo.storage_path).to eq(TaskRepository::DEFAULT_STORAGE_PATH)
    end

    it 'creates a new repository with custom path' do
      expect(repository.storage_path).to eq(test_storage_path)
    end

    it 'creates storage file if it does not exist' do
      expect(File.exist?(test_storage_path)).to be true
    end

    it 'initializes with empty array' do
      expect(repository.all).to eq([])
    end
  end

  describe '#save' do
    it 'saves a new task' do
      task = Task.new(title: 'Test Task', description: 'Test Desc')
      result = repository.save(task)

      expect(result).to eq(task)
      expect(repository.find(task.id)).to eq(task)
    end

    it 'updates an existing task (upsert)' do
      task = Task.new(title: 'Original', description: 'Original Desc')
      repository.save(task)

      updated_task = Task.new(
        id: task.id,
        title: 'Updated',
        description: 'Updated Desc'
      )
      repository.save(updated_task)

      found = repository.find(task.id)
      expect(found.title).to eq('Updated')
      expect(repository.all.size).to eq(1)
    end

    it 'raises error if task is nil' do
      expect {
        repository.save(nil)
      }.to raise_error(ArgumentError, 'Task cannot be nil')
    end

    it 'raises error if not a Task object' do
      expect {
        repository.save('not a task')
      }.to raise_error(ArgumentError, 'Invalid task object')
    end

    it 'persists data to file' do
      task = Task.new(title: 'Test')
      repository.save(task)

      # Create new repository instance to test persistence
      new_repo = TaskRepository.new(test_storage_path)
      expect(new_repo.find(task.id)).not_to be_nil
    end
  end

  describe '#find' do
    it 'finds a task by ID' do
      task = Task.new(title: 'Test')
      repository.save(task)

      found = repository.find(task.id)
      expect(found).not_to be_nil
      expect(found.id).to eq(task.id)
      expect(found.title).to eq(task.title)
    end

    it 'returns nil if task not found' do
      expect(repository.find('nonexistent')).to be_nil
    end
  end

  describe '#all' do
    it 'returns empty array when no tasks' do
      expect(repository.all).to eq([])
    end

    it 'returns all tasks' do
      task1 = Task.new(title: 'Task 1')
      task2 = Task.new(title: 'Task 2')

      repository.save(task1)
      repository.save(task2)

      all_tasks = repository.all
      expect(all_tasks.size).to eq(2)
      expect(all_tasks.map(&:id)).to contain_exactly(task1.id, task2.id)
    end
  end

  describe '#find_by_status' do
    before do
      @pending_task = Task.new(title: 'Pending Task')
      @completed_task = Task.new(
        title: 'Completed Task',
        status: :completed,
        completed_at: Time.now
      )

      repository.save(@pending_task)
      repository.save(@completed_task)
    end

    it 'finds pending tasks' do
      pending = repository.find_by_status(:pending)

      expect(pending.size).to eq(1)
      expect(pending.first.id).to eq(@pending_task.id)
    end

    it 'finds completed tasks' do
      completed = repository.find_by_status(:completed)

      expect(completed.size).to eq(1)
      expect(completed.first.id).to eq(@completed_task.id)
    end

    it 'returns empty array if no matches' do
      repository.clear
      expect(repository.find_by_status(:pending)).to eq([])
    end
  end

  describe '#search' do
    before do
      repository.save(Task.new(title: 'Buy milk', description: 'From store'))
      repository.save(Task.new(title: 'Buy eggs', description: 'One dozen'))
      repository.save(Task.new(title: 'Clean house', description: 'Living room'))
    end

    it 'searches by keyword in title' do
      results = repository.search('Buy')

      expect(results.size).to eq(2)
      expect(results.map(&:title)).to all(start_with('Buy'))
    end

    it 'searches by keyword in description' do
      results = repository.search('room')

      expect(results.size).to eq(1)
      expect(results.first.title).to eq('Clean house')
    end

    it 'is case insensitive' do
      results = repository.search('BUY')

      expect(results.size).to eq(2)
    end

    it 'returns empty array for empty keyword' do
      expect(repository.search('')).to eq([])
      expect(repository.search('   ')).to eq([])
    end

    it 'returns empty array for nil keyword' do
      expect(repository.search(nil)).to eq([])
    end

    it 'returns empty array when no matches' do
      results = repository.search('nonexistent')

      expect(results).to eq([])
    end
  end

  describe '#delete' do
    it 'deletes a task by ID' do
      task = Task.new(title: 'Test')
      repository.save(task)

      result = repository.delete(task.id)

      expect(result).to be true
      expect(repository.find(task.id)).to be_nil
    end

    it 'returns false if task not found' do
      result = repository.delete('nonexistent')

      expect(result).to be false
    end

    it 'persists deletion to file' do
      task = Task.new(title: 'Test')
      repository.save(task)
      repository.delete(task.id)

      # Create new repository instance to test persistence
      new_repo = TaskRepository.new(test_storage_path)
      expect(new_repo.find(task.id)).to be_nil
    end
  end

  describe '#exists?' do
    it 'returns true if task exists' do
      task = Task.new(title: 'Test')
      repository.save(task)

      expect(repository.exists?(task.id)).to be true
    end

    it 'returns false if task does not exist' do
      expect(repository.exists?('nonexistent')).to be false
    end
  end

  describe '#count' do
    it 'returns 0 for empty repository' do
      expect(repository.count).to eq(0)
    end

    it 'returns total number of tasks' do
      repository.save(Task.new(title: 'Task 1'))
      repository.save(Task.new(title: 'Task 2'))
      repository.save(Task.new(title: 'Task 3'))

      expect(repository.count).to eq(3)
    end
  end

  describe '#count_by_status' do
    before do
      repository.save(Task.new(title: 'Pending 1'))
      repository.save(Task.new(title: 'Pending 2'))
      repository.save(Task.new(
                        title: 'Completed',
                        status: :completed,
                        completed_at: Time.now
                      ))
    end

    it 'counts pending tasks' do
      expect(repository.count_by_status(:pending)).to eq(2)
    end

    it 'counts completed tasks' do
      expect(repository.count_by_status(:completed)).to eq(1)
    end
  end

  describe '#clear' do
    it 'deletes all tasks' do
      repository.save(Task.new(title: 'Task 1'))
      repository.save(Task.new(title: 'Task 2'))

      result = repository.clear

      expect(result).to be true
      expect(repository.all).to eq([])
    end

    it 'persists clearing to file' do
      repository.save(Task.new(title: 'Task'))
      repository.clear

      # Create new repository instance to test persistence
      new_repo = TaskRepository.new(test_storage_path)
      expect(new_repo.all).to eq([])
    end
  end

  describe '#stats' do
    it 'returns statistics for empty repository' do
      stats = repository.stats

      expect(stats).to eq({
                            total: 0,
                            pending: 0,
                            completed: 0,
                            completion_rate: 0.0
                          })
    end

    it 'returns statistics with tasks' do
      repository.save(Task.new(title: 'Pending 1'))
      repository.save(Task.new(title: 'Pending 2'))
      repository.save(Task.new(
                        title: 'Completed',
                        status: :completed,
                        completed_at: Time.now
                      ))

      stats = repository.stats

      expect(stats[:total]).to eq(3)
      expect(stats[:pending]).to eq(2)
      expect(stats[:completed]).to eq(1)
      expect(stats[:completion_rate]).to eq(33.33)
    end
  end

  describe 'error handling' do
    it 'handles corrupted JSON file' do
      File.write(test_storage_path, 'invalid json {{{')

      # Should return empty array and not crash
      expect(repository.all).to eq([])
    end

    it 'handles missing file gracefully' do
      File.delete(test_storage_path)

      # Should recreate file
      expect(repository.all).to eq([])
      expect(File.exist?(test_storage_path)).to be true
    end
  end

  describe 'atomic writes' do
    it 'uses temporary file for atomic writes' do
      task = Task.new(title: 'Test')
      repository.save(task)

      # Temp file should not exist after save
      expect(File.exist?("#{test_storage_path}.tmp")).to be false
    end
  end
end
