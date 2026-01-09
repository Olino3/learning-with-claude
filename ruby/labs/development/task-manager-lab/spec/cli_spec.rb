# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

RSpec.describe CLI do
  let(:repository) { TaskRepository.new('test_cli.json') }
  let(:task_manager) { TaskManager.new(repository: repository) }
  let(:cli) { CLI.new(task_manager: task_manager) }

  after(:each) do
    File.delete('test_cli.json') if File.exist?('test_cli.json')
  end

  describe '#initialize' do
    it 'creates CLI with default task manager' do
      cli = CLI.new

      expect(cli.task_manager).to be_a(TaskManager)
    end

    it 'creates CLI with injected task manager' do
      expect(cli.task_manager).to eq(task_manager)
    end
  end

  describe 'command processing' do
    # Helper method to simulate command input
    def process_command(command)
      # Capture output
      output = StringIO.new
      original_stdout = $stdout
      $stdout = output

      # Send command directly to private method for testing
      cli.send(:process_command, command)

      $stdout = original_stdout
      output.string
    end

    describe 'add command' do
      it 'adds a task with title and description' do
        output = process_command('add "Buy milk" "Get 2% milk"')

        expect(output).to include('Task added successfully')
        expect(task_manager.list_tasks.size).to eq(1)
      end

      it 'shows usage for incomplete command' do
        output = process_command('add')

        expect(output).to include('Usage: add <title> <description>')
      end

      it 'shows usage for missing description' do
        output = process_command('add "Title only"')

        expect(output).to include('Usage: add <title> <description>')
      end
    end

    describe 'list command' do
      before do
        @pending_id = task_manager.add_task('Pending Task', 'Not done')
        @completed_id = task_manager.add_task('Completed Task', 'Done')
        task_manager.complete_task(@completed_id)
      end

      it 'lists all tasks' do
        output = process_command('list')

        expect(output).to include('All Tasks')
        expect(output).to include('Pending Task')
        expect(output).to include('Completed Task')
      end

      it 'lists pending tasks only' do
        output = process_command('list pending')

        expect(output).to include('Pending Tasks')
        expect(output).to include('Pending Task')
        expect(output).not_to include('Completed Task')
      end

      it 'lists completed tasks only' do
        output = process_command('list completed')

        expect(output).to include('Completed Tasks')
        expect(output).to include('Completed Task')
        expect(output).not_to include('Pending Task')
      end

      it 'shows message when no tasks' do
        repository.clear
        output = process_command('list')

        expect(output).to include('No tasks found')
      end
    end

    describe 'complete command' do
      it 'marks a task as completed' do
        id = task_manager.add_task('Test Task')
        output = process_command("complete #{id}")

        expect(output).to include('marked as completed')
        expect(task_manager.get_task(id).completed?).to be true
      end

      it 'shows usage when no ID provided' do
        output = process_command('complete')

        expect(output).to include('Usage: complete <task_id>')
      end

      it 'shows error for non-existent task' do
        output = process_command('complete nonexistent')

        expect(output).to include('Error')
      end
    end

    describe 'delete command' do
      it 'deletes a task' do
        id = task_manager.add_task('Test Task')
        output = process_command("delete #{id}")

        expect(output).to include('deleted successfully')
        expect(task_manager.task_exists?(id)).to be false
      end

      it 'shows usage when no ID provided' do
        output = process_command('delete')

        expect(output).to include('Usage: delete <task_id>')
      end

      it 'shows error for non-existent task' do
        output = process_command('delete nonexistent')

        expect(output).to include('Error')
      end
    end

    describe 'show command' do
      it 'displays task details' do
        id = task_manager.add_task('Test Task', 'Test Description')
        output = process_command("show #{id}")

        expect(output).to include('Task Details')
        expect(output).to include('Test Task')
        expect(output).to include('Test Description')
        expect(output).to include(id)
      end

      it 'shows usage when no ID provided' do
        output = process_command('show')

        expect(output).to include('Usage: show <task_id>')
      end

      it 'shows error for non-existent task' do
        output = process_command('show nonexistent')

        expect(output).to include('Error')
      end
    end

    describe 'search command' do
      before do
        task_manager.add_task('Buy milk', 'Get 2% milk')
        task_manager.add_task('Buy eggs', 'One dozen')
        task_manager.add_task('Clean house', 'Living room')
      end

      it 'searches for tasks' do
        output = process_command('search Buy')

        expect(output).to include("Search results for 'Buy'")
        expect(output).to include('Buy milk')
        expect(output).to include('Buy eggs')
      end

      it 'shows message when no matches' do
        output = process_command('search nonexistent')

        expect(output).to include('No tasks found matching')
      end

      it 'shows usage when no keyword provided' do
        output = process_command('search')

        expect(output).to include('Usage: search <keyword>')
      end
    end

    describe 'stats command' do
      it 'displays statistics' do
        task_manager.add_task('Task 1')
        id = task_manager.add_task('Task 2')
        task_manager.complete_task(id)

        output = process_command('stats')

        expect(output).to include('Task Statistics')
        expect(output).to include('Total Tasks: 2')
        expect(output).to include('Pending:')
        expect(output).to include('Completed:')
        expect(output).to include('Completion Rate:')
      end
    end

    describe 'help command' do
      it 'displays help information' do
        output = process_command('help')

        expect(output).to include('Available Commands')
        expect(output).to include('add')
        expect(output).to include('list')
        expect(output).to include('complete')
        expect(output).to include('delete')
        expect(output).to include('Examples')
      end
    end

    describe 'unknown command' do
      it 'shows error message' do
        output = process_command('invalid')

        expect(output).to include('Unknown command')
      end
    end

    describe 'empty command' do
      it 'does nothing silently' do
        output = process_command('')

        expect(output).to be_empty
      end
    end
  end

  describe 'input parsing' do
    def parse_input(input)
      cli.send(:parse_input, input)
    end

    it 'parses simple command' do
      result = parse_input('list')

      expect(result).to eq(['list'])
    end

    it 'parses command with arguments' do
      result = parse_input('complete abc123')

      expect(result).to eq(['complete', 'abc123'])
    end

    it 'parses quoted strings as single arguments' do
      result = parse_input('add "Buy milk" "Get 2% milk"')

      expect(result).to eq(['add', 'Buy milk', 'Get 2% milk'])
    end

    it 'handles mixed quoted and unquoted arguments' do
      result = parse_input('search "ruby programming"')

      expect(result).to eq(['search', 'ruby programming'])
    end

    it 'handles multiple spaces' do
      result = parse_input('list    pending')

      expect(result).to eq(['list', 'pending'])
    end
  end

  describe 'output formatting' do
    def colorize(text, color)
      cli.send(:colorize, text, color)
    end

    it 'adds color codes' do
      result = colorize('Test', :green)

      expect(result).to include('Test')
      expect(result).to include("\e[")
    end

    it 'handles unknown colors' do
      result = colorize('Test', :invalid)

      expect(result).to eq('Test')
    end
  end
end
