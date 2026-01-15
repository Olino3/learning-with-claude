#!/usr/bin/env ruby
# Exercise Validation Script
# Validates Ruby exercise files for syntax, execution, and basic idiom checks

require 'open3'
require 'fileutils'

class ExerciseValidator
  COLORS = {
    green: "\e[32m",
    red: "\e[31m",
    yellow: "\e[33m",
    blue: "\e[34m",
    reset: "\e[0m"
  }

  def initialize(path)
    @path = File.expand_path(path)
    @errors = []
    @warnings = []
    @passes = []
  end

  def validate
    puts "#{color(:blue)}Validating: #{@path}#{color(:reset)}"
    puts "=" * 70
    puts

    if File.directory?(@path)
      validate_directory
    elsif File.file?(@path)
      validate_file(@path)
    else
      error("Path not found: #{@path}")
      return false
    end

    print_summary
    @errors.empty?
  end

  private

  def validate_directory
    ruby_files = Dir.glob(File.join(@path, '**', '*.rb'))

    if ruby_files.empty?
      error("No Ruby files found in #{@path}")
      return
    end

    puts "Found #{ruby_files.size} Ruby file(s) to validate"
    puts

    ruby_files.each do |file|
      validate_file(file)
      puts
    end
  end

  def validate_file(file)
    relative_path = file.sub(Dir.pwd + '/', '')
    puts "#{color(:blue)}Checking: #{relative_path}#{color(:reset)}"

    # Check 1: File exists and is readable
    unless File.readable?(file)
      error("File not readable: #{file}")
      return
    end
    pass("File is readable")

    # Check 2: Has shebang for executable files
    content = File.read(file)
    if content.lines.first&.start_with?('#!/usr/bin/env ruby')
      pass("Has shebang line")
    else
      warning("Missing shebang line (#!/usr/bin/env ruby)")
    end

    # Check 3: Syntax check
    if check_syntax(file)
      pass("Syntax is valid")
    else
      error("Syntax errors found")
      return # Don't continue if syntax is broken
    end

    # Check 4: Run the file
    if execute_file(file)
      pass("Executes without errors")
    else
      error("Runtime errors encountered")
    end

    # Check 5: Basic idiom checks
    check_idioms(content, relative_path)

    # Check 6: Has examples/documentation
    if has_examples?(content)
      pass("Contains example code")
    else
      warning("No clear examples found (look for 'Example' comments)")
    end
  end

  def check_syntax(file)
    stdout, stderr, status = Open3.capture3("ruby", "-c", file)

    if status.success?
      true
    else
      error("Syntax check failed:")
      stderr.each_line do |line|
        puts "  #{color(:red)}#{line}#{color(:reset)}"
      end
      false
    end
  end

  def execute_file(file)
    # Run with a timeout to prevent infinite loops
    stdout, stderr, status = Open3.capture3("timeout", "10s", "ruby", file)

    if status.success?
      # File ran successfully
      true
    elsif status.exitstatus == 124
      error("Execution timeout (possible infinite loop)")
      false
    else
      error("Execution failed:")
      stderr.each_line.first(10).each do |line|
        puts "  #{color(:red)}#{line}#{color(:reset)}"
      end
      false
    end
  rescue => e
    error("Failed to execute: #{e.message}")
    false
  end

  def check_idioms(content, file_path)
    # Check for Python-style patterns that should use Ruby idioms

    # Anti-pattern: for...in loops (should use .each)
    if content.match?(/^\s*for\s+\w+\s+in\s+/)
      warning("Found 'for...in' loop - consider using .each instead (more idiomatic)")
    end

    # Anti-pattern: explicit return everywhere
    explicit_returns = content.scan(/^\s+return\s+/).count
    total_methods = content.scan(/^\s+def\s+/).count
    if total_methods > 0 && explicit_returns > total_methods * 0.8
      warning("Many explicit returns found - Ruby uses implicit returns")
    end

    # Good pattern: Using blocks
    if content.match?(/\.(each|map|select|reject|find)\s+(\{|do)/)
      pass("Uses Ruby blocks/iterators (idiomatic)")
    end

    # Good pattern: Symbols
    if content.match?(/:[\w]+/)
      pass("Uses symbols (idiomatic)")
    end

    # Check for Python Note comments (good for learning files)
    if file_path.include?('/tutorials/') || file_path.include?('/exercises/')
      if content.include?('Python Note:') || content.include?('Python:')
        pass("Includes Python comparisons (good for learning)")
      end
    end

    # Check for proper structure in practice files
    if file_path.include?('/exercises/') && file_path.include?('_practice.rb')
      unless content.include?('Example ')
        warning("Exercise file should include numbered examples (Example 1, Example 2, etc.)")
      end

      unless content.include?('=' * 70) || content.include?('-' * 70)
        warning("Consider adding visual separators (===== or -----) for readability")
      end
    end
  end

  def has_examples?(content)
    # Check for example markers
    content.include?('Example ') ||
    content.include?('# Example:') ||
    content.match?(/# \d+\./)
  end

  def pass(message)
    @passes << message
    puts "  #{color(:green)}✓#{color(:reset)} #{message}"
  end

  def warning(message)
    @warnings << message
    puts "  #{color(:yellow)}⚠#{color(:reset)} #{message}"
  end

  def error(message)
    @errors << message
    puts "  #{color(:red)}✗#{color(:reset)} #{message}"
  end

  def color(name)
    COLORS[name] || COLORS[:reset]
  end

  def print_summary
    puts
    puts "=" * 70
    puts "#{color(:blue)}SUMMARY#{color(:reset)}"
    puts "=" * 70
    puts "#{color(:green)}Passed: #{@passes.size}#{color(:reset)}"
    puts "#{color(:yellow)}Warnings: #{@warnings.size}#{color(:reset)}"
    puts "#{color(:red)}Errors: #{@errors.size}#{color(:reset)}"
    puts

    if @errors.empty?
      puts "#{color(:green)}✓ Validation passed!#{color(:reset)}"
    else
      puts "#{color(:red)}✗ Validation failed#{color(:reset)}"
      puts
      puts "Errors:"
      @errors.each do |err|
        puts "  - #{err}"
      end
    end

    if @warnings.any?
      puts
      puts "Warnings (non-blocking):"
      @warnings.each do |warn|
        puts "  - #{warn}"
      end
    end

    puts
  end
end

# Main execution
if ARGV.empty?
  puts "Usage: ruby validate_exercise.rb <path>"
  puts
  puts "Examples:"
  puts "  ruby validate_exercise.rb ruby/tutorials/5-Collections/exercises/collections_practice.rb"
  puts "  ruby validate_exercise.rb ruby/tutorials/5-Collections/"
  puts "  ruby validate_exercise.rb ruby/tutorials/"
  exit 1
end

path = ARGV[0]
validator = ExerciseValidator.new(path)
success = validator.validate

exit(success ? 0 : 1)
