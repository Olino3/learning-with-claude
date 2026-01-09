# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Task do
  describe '#initialize' do
    it 'creates a task with required attributes' do
      task = Task.new(title: 'Buy milk', description: 'Get 2% milk')

      expect(task.title).to eq('Buy milk')
      expect(task.description).to eq('Get 2% milk')
      expect(task.status).to eq(:pending)
      expect(task.id).not_to be_nil
      expect(task.created_at).to be_a(Time)
    end

    it 'generates a unique ID if not provided' do
      task1 = Task.new(title: 'Task 1')
      task2 = Task.new(title: 'Task 2')

      expect(task1.id).not_to eq(task2.id)
      expect(task1.id).to match(/\A[a-f0-9]{8}\z/)
    end

    it 'uses provided ID if given' do
      task = Task.new(id: 'custom123', title: 'Test')

      expect(task.id).to eq('custom123')
    end

    it 'defaults description to empty string' do
      task = Task.new(title: 'Test')

      expect(task.description).to eq('')
    end

    it 'defaults status to pending' do
      task = Task.new(title: 'Test')

      expect(task.status).to eq(:pending)
    end

    it 'sets created_at to current time by default' do
      before_creation = Time.now
      task = Task.new(title: 'Test')
      after_creation = Time.now

      expect(task.created_at).to be_between(before_creation, after_creation)
    end

    it 'is immutable after creation' do
      task = Task.new(title: 'Test')

      expect(task).to be_frozen
    end
  end

  describe 'validation' do
    it 'raises error if title is nil' do
      expect {
        Task.new(title: nil)
      }.to raise_error(ArgumentError, 'Title cannot be empty')
    end

    it 'raises error if title is empty' do
      expect {
        Task.new(title: '')
      }.to raise_error(ArgumentError, 'Title cannot be empty')
    end

    it 'raises error if title is only whitespace' do
      expect {
        Task.new(title: '   ')
      }.to raise_error(ArgumentError, 'Title cannot be empty')
    end

    it 'raises error if title exceeds 100 characters' do
      long_title = 'a' * 101

      expect {
        Task.new(title: long_title)
      }.to raise_error(ArgumentError, 'Title too long (max 100 characters)')
    end

    it 'raises error if description exceeds 500 characters' do
      long_description = 'a' * 501

      expect {
        Task.new(title: 'Test', description: long_description)
      }.to raise_error(ArgumentError, 'Description too long (max 500 characters)')
    end

    it 'raises error for invalid status' do
      expect {
        Task.new(title: 'Test', status: :invalid)
      }.to raise_error(ArgumentError, 'Invalid status: invalid')
    end
  end

  describe '#complete' do
    it 'returns a new completed task' do
      original = Task.new(title: 'Test')
      completed = original.complete

      expect(completed).to be_a(Task)
      expect(completed).not_to equal(original) # Different object
      expect(completed.status).to eq(:completed)
      expect(completed.completed_at).to be_a(Time)
    end

    it 'preserves task attributes' do
      original = Task.new(id: 'test123', title: 'Test', description: 'Desc')
      completed = original.complete

      expect(completed.id).to eq(original.id)
      expect(completed.title).to eq(original.title)
      expect(completed.description).to eq(original.description)
      expect(completed.created_at).to eq(original.created_at)
    end

    it 'returns itself if already completed' do
      task = Task.new(title: 'Test', status: :completed, completed_at: Time.now)
      result = task.complete

      expect(result).to equal(task)
    end
  end

  describe '#completed?' do
    it 'returns true for completed tasks' do
      task = Task.new(title: 'Test', status: :completed, completed_at: Time.now)

      expect(task.completed?).to be true
    end

    it 'returns false for pending tasks' do
      task = Task.new(title: 'Test')

      expect(task.completed?).to be false
    end
  end

  describe '#pending?' do
    it 'returns true for pending tasks' do
      task = Task.new(title: 'Test')

      expect(task.pending?).to be true
    end

    it 'returns false for completed tasks' do
      task = Task.new(title: 'Test', status: :completed, completed_at: Time.now)

      expect(task.pending?).to be false
    end
  end

  describe '#matches?' do
    let(:task) do
      Task.new(title: 'Buy groceries', description: 'Milk and eggs')
    end

    it 'finds keyword in title' do
      expect(task.matches?('groceries')).to be true
    end

    it 'finds keyword in description' do
      expect(task.matches?('milk')).to be true
    end

    it 'is case insensitive' do
      expect(task.matches?('GROCERIES')).to be true
      expect(task.matches?('MILK')).to be true
    end

    it 'returns false for non-matching keyword' do
      expect(task.matches?('coffee')).to be false
    end

    it 'handles partial matches' do
      expect(task.matches?('grocer')).to be true
    end
  end

  describe '#to_h' do
    it 'converts task to hash' do
      task = Task.new(
        id: 'test123',
        title: 'Test',
        description: 'Desc'
      )
      hash = task.to_h

      expect(hash).to include(
        id: 'test123',
        title: 'Test',
        description: 'Desc',
        status: 'pending'
      )
      expect(hash[:created_at]).to be_a(String)
      expect(hash[:completed_at]).to be_nil
    end

    it 'includes completed_at for completed tasks' do
      completed_time = Time.now
      task = Task.new(
        title: 'Test',
        status: :completed,
        completed_at: completed_time
      )
      hash = task.to_h

      expect(hash[:completed_at]).to eq(completed_time.iso8601)
    end
  end

  describe '.from_h' do
    it 'creates task from hash' do
      hash = {
        'id' => 'test123',
        'title' => 'Test Task',
        'description' => 'Test Desc',
        'status' => 'pending',
        'created_at' => '2024-01-01T12:00:00Z',
        'completed_at' => nil
      }

      task = Task.from_h(hash)

      expect(task.id).to eq('test123')
      expect(task.title).to eq('Test Task')
      expect(task.description).to eq('Test Desc')
      expect(task.status).to eq(:pending)
      expect(task.completed_at).to be_nil
    end

    it 'handles symbol keys' do
      hash = {
        id: 'test123',
        title: 'Test',
        description: 'Desc',
        status: :pending,
        created_at: Time.now.iso8601
      }

      task = Task.from_h(hash)

      expect(task.id).to eq('test123')
      expect(task.title).to eq('Test')
    end

    it 'parses time strings' do
      time_string = '2024-01-01T12:00:00Z'
      hash = {
        'title' => 'Test',
        'status' => 'completed',
        'created_at' => time_string,
        'completed_at' => time_string
      }

      task = Task.from_h(hash)

      expect(task.created_at).to be_a(Time)
      expect(task.completed_at).to be_a(Time)
    end
  end

  describe '#to_s' do
    it 'formats pending task' do
      task = Task.new(id: 'abc12345', title: 'Test Task')

      expect(task.to_s).to eq('[○] Test Task (abc12345)')
    end

    it 'formats completed task' do
      task = Task.new(
        id: 'abc12345',
        title: 'Test Task',
        status: :completed,
        completed_at: Time.now
      )

      expect(task.to_s).to eq('[✓] Test Task (abc12345)')
    end
  end

  describe '#inspect' do
    it 'provides detailed string representation' do
      task = Task.new(id: 'abc123', title: 'Test')

      expect(task.inspect).to eq('#<Task id=abc123 title="Test" status=pending>')
    end
  end
end
