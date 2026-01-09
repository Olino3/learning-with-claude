# frozen_string_literal: true

# Configure SimpleCov for code coverage
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'

  add_group 'Models', 'lib/task.rb'
  add_group 'Repositories', 'lib/task_repository.rb'
  add_group 'Services', 'lib/task_manager.rb'
  add_group 'CLI', 'lib/cli.rb'

  minimum_coverage 90
end

# Load the application code
require_relative '../lib/task'
require_relative '../lib/task_repository'
require_relative '../lib/task_manager'
require_relative '../lib/cli'

# RSpec configuration
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Use expect syntax (not should syntax)
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Run specs in random order to surface order dependencies
  config.order = :random
  Kernel.srand config.seed

  # Clean up test files after each test
  config.after(:each) do
    test_files = Dir.glob('test_*.json')
    test_files.each { |file| File.delete(file) if File.exist?(file) }
  end

  # Shared context for creating test tasks
  config.shared_context 'test tasks' do
    let(:test_task) do
      Task.new(
        title: 'Test Task',
        description: 'Test Description'
      )
    end

    let(:completed_task) do
      Task.new(
        title: 'Completed Task',
        description: 'This is done',
        status: :completed,
        completed_at: Time.now
      )
    end
  end

  # Make the shared context available to all specs
  config.include_context 'test tasks', include_shared: true
end
