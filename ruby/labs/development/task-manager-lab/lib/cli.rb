# frozen_string_literal: true

require_relative 'task_manager'

# CLI (Command Line Interface) provides an interactive shell for the Task Manager.
# It handles user input, command parsing, and output formatting.
#
# Design Patterns:
# - Command Pattern: Each command is parsed and executed
# - Facade: Simplifies interaction with TaskManager
# - Single Responsibility: Only handles UI/UX concerns
#
# Example:
#   cli = CLI.new
#   cli.start # Starts interactive shell
class CLI
  attr_reader :task_manager

  # ANSI color codes for terminal output
  COLORS = {
    green: "\e[32m",
    red: "\e[31m",
    yellow: "\e[33m",
    blue: "\e[34m",
    cyan: "\e[36m",
    reset: "\e[0m"
  }.freeze

  # Creates a new CLI instance
  #
  # @param task_manager [TaskManager] The task manager service (injected for testing)
  def initialize(task_manager: TaskManager.new)
    @task_manager = task_manager
    @running = false
  end

  # Starts the interactive CLI
  def start
    @running = true
    display_welcome
    display_help

    while @running
      print_prompt
      input = gets&.chomp
      break if input.nil? # Handle Ctrl+D

      process_command(input)
    end

    display_goodbye
  end

  private

  # Processes a user command
  #
  # @param input [String] The user input
  def process_command(input)
    parts = parse_input(input)
    command = parts[0]&.downcase
    args = parts[1..]

    case command
    when 'add'
      handle_add(args)
    when 'list'
      handle_list(args)
    when 'complete'
      handle_complete(args)
    when 'delete'
      handle_delete(args)
    when 'show'
      handle_show(args)
    when 'search'
      handle_search(args)
    when 'stats'
      handle_stats
    when 'help'
      display_help
    when 'exit', 'quit'
      @running = false
    when ''
      # Empty input, do nothing
    else
      puts colorize("Unknown command: #{command}. Type 'help' for available commands.", :red)
    end
  rescue StandardError => e
    puts colorize("Error: #{e.message}", :red)
  end

  # Handles the 'add' command
  def handle_add(args)
    if args.length < 2
      puts colorize('Usage: add <title> <description>', :yellow)
      return
    end

    title = args[0]
    description = args[1..].join(' ')

    id = task_manager.add_task(title, description)
    puts colorize("✓ Task added successfully! ID: #{id}", :green)
  end

  # Handles the 'list' command
  def handle_list(args)
    status = args[0]&.to_sym if args[0] && %w[pending completed].include?(args[0])

    tasks = task_manager.list_tasks(status: status)

    if tasks.empty?
      status_text = status ? " (#{status})" : ''
      puts colorize("No tasks found#{status_text}.", :yellow)
      return
    end

    display_tasks(tasks, status)
  end

  # Handles the 'complete' command
  def handle_complete(args)
    if args.empty?
      puts colorize('Usage: complete <task_id>', :yellow)
      return
    end

    id = args[0]
    task = task_manager.complete_task(id)
    puts colorize("✓ Task '#{task.title}' marked as completed!", :green)
  end

  # Handles the 'delete' command
  def handle_delete(args)
    if args.empty?
      puts colorize('Usage: delete <task_id>', :yellow)
      return
    end

    id = args[0]
    task = task_manager.get_task(id) # Get task before deleting for display
    task_manager.delete_task(id)
    puts colorize("✓ Task '#{task.title}' deleted successfully!", :green)
  end

  # Handles the 'show' command
  def handle_show(args)
    if args.empty?
      puts colorize('Usage: show <task_id>', :yellow)
      return
    end

    id = args[0]
    task = task_manager.get_task(id)
    display_task_details(task)
  end

  # Handles the 'search' command
  def handle_search(args)
    if args.empty?
      puts colorize('Usage: search <keyword>', :yellow)
      return
    end

    keyword = args.join(' ')
    tasks = task_manager.search_tasks(keyword)

    if tasks.empty?
      puts colorize("No tasks found matching '#{keyword}'.", :yellow)
      return
    end

    puts colorize("\nSearch results for '#{keyword}':", :cyan)
    display_tasks(tasks)
  end

  # Handles the 'stats' command
  def handle_stats
    stats = task_manager.summary
    puts colorize("\n📊 Task Statistics:", :cyan)
    puts "  Total Tasks: #{stats[:total_tasks]}"
    puts "  Pending: #{colorize(stats[:pending_tasks].to_s, :yellow)}"
    puts "  Completed: #{colorize(stats[:completed_tasks].to_s, :green)}"
    puts "  Completion Rate: #{stats[:completion_rate]}"
    puts
  end

  # Displays a list of tasks
  def display_tasks(tasks, status = nil)
    header = status ? "#{status.to_s.capitalize} Tasks" : 'All Tasks'
    puts colorize("\n#{header} (#{tasks.size}):", :cyan)
    puts '-' * 60

    tasks.each do |task|
      status_symbol = task.completed? ? colorize('✓', :green) : colorize('○', :yellow)
      id_str = colorize(task.id[0..7], :blue)
      puts "#{status_symbol} [#{id_str}] #{task.title}"
    end
    puts
  end

  # Displays detailed information about a task
  def display_task_details(task)
    puts colorize("\n📋 Task Details:", :cyan)
    puts "  ID: #{colorize(task.id, :blue)}"
    puts "  Title: #{task.title}"
    puts "  Description: #{task.description.empty? ? '(none)' : task.description}"
    puts "  Status: #{format_status(task.status)}"
    puts "  Created: #{format_time(task.created_at)}"
    puts "  Completed: #{task.completed_at ? format_time(task.completed_at) : 'Not yet'}"
    puts
  end

  # Formats a status symbol with color
  def format_status(status)
    case status
    when :pending
      colorize('○ Pending', :yellow)
    when :completed
      colorize('✓ Completed', :green)
    else
      status.to_s
    end
  end

  # Formats a timestamp
  def format_time(time)
    time.strftime('%Y-%m-%d %H:%M:%S')
  end

  # Parses user input into command and arguments
  # Handles quoted strings as single arguments
  def parse_input(input)
    # Simple parsing: split on spaces, but respect quoted strings
    parts = []
    current = ''
    in_quotes = false

    input.each_char do |char|
      case char
      when '"'
        in_quotes = !in_quotes
      when ' '
        if in_quotes
          current += char
        elsif !current.empty?
          parts << current
          current = ''
        end
      else
        current += char
      end
    end

    parts << current unless current.empty?
    parts
  end

  # Colorizes text for terminal output
  def colorize(text, color)
    return text unless COLORS.key?(color)

    "#{COLORS[color]}#{text}#{COLORS[:reset]}"
  end

  # Displays welcome message
  def display_welcome
    puts colorize("\n" + '=' * 60, :cyan)
    puts colorize('  Task Manager - Interactive CLI', :cyan)
    puts colorize('=' * 60, :cyan)
    puts
  end

  # Displays help information
  def display_help
    puts colorize('Available Commands:', :cyan)
    puts "  #{colorize('add', :green)} <title> <description>  - Add a new task"
    puts "  #{colorize('list', :green)} [status]             - List tasks (all/pending/completed)"
    puts "  #{colorize('complete', :green)} <id>             - Mark task as completed"
    puts "  #{colorize('delete', :green)} <id>               - Delete a task"
    puts "  #{colorize('show', :green)} <id>                 - Show task details"
    puts "  #{colorize('search', :green)} <keyword>          - Search tasks by keyword"
    puts "  #{colorize('stats', :green)}                     - Show task statistics"
    puts "  #{colorize('help', :green)}                      - Show this help message"
    puts "  #{colorize('exit', :green)}                      - Exit application"
    puts
    puts 'Examples:'
    puts '  add "Buy groceries" "Milk, eggs, bread"'
    puts '  list pending'
    puts '  complete abc12345'
    puts '  search milk'
    puts
  end

  # Displays goodbye message
  def display_goodbye
    puts colorize("\nGoodbye! Your tasks have been saved.", :cyan)
  end

  # Displays the command prompt
  def print_prompt
    print colorize('task-manager> ', :blue)
  end
end
