# Exercise 3: CI/CD Integration

Automate code quality checks with CI/CD pipelines, pre-commit hooks, and automated code review.

## Objective

Set up automated linting that runs on every commit and pull request, preventing code quality regressions.

## Part 1: GitHub Actions

### Task 1.1: Basic RuboCop Workflow

Create a GitHub Actions workflow that runs RuboCop on every push.

```yaml
# .github/workflows/rubocop.yml
name: RuboCop

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  rubocop:
    runs-on: ubuntu-latest

    steps:
      # TODO: Implement workflow
      # 1. Checkout code
      # 2. Setup Ruby
      # 3. Install dependencies
      # 4. Run RuboCop
      # 5. Report results
```

<details>
<summary>Solution</summary>

```yaml
# .github/workflows/rubocop.yml
name: RuboCop

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  rubocop:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Install dependencies
        run: bundle install

      - name: Run RuboCop
        run: bundle exec rubocop --parallel

      - name: Annotate Code
        if: failure()
        run: bundle exec rubocop --format github
```
</details>

### Task 1.2: Advanced Workflow with Caching

Optimize the workflow with caching and multiple linters:

<details>
<summary>Solution</summary>

```yaml
# .github/workflows/code-quality.yml
name: Code Quality

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  rubocop:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # For changed files detection

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Cache RuboCop
        uses: actions/cache@v3
        with:
          path: ~/.cache/rubocop_cache
          key: ${{ runner.os }}-rubocop-${{ hashFiles('**/.rubocop.yml') }}
          restore-keys: |
            ${{ runner.os }}-rubocop-

      - name: Run RuboCop on changed files
        run: |
          git diff --name-only --diff-filter=ACMRTUXB origin/main... | \
          grep '\.rb$' | \
          xargs bundle exec rubocop --parallel

      - name: Run StandardRB
        run: bundle exec standardrb

      - name: Generate RuboCop Report
        if: always()
        run: |
          bundle exec rubocop --format json --out rubocop-results.json
          bundle exec rubocop --format html --out rubocop-results.html

      - name: Upload RuboCop Results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: rubocop-results
          path: |
            rubocop-results.json
            rubocop-results.html

  custom-cops:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Run Custom Cops
        run: |
          bundle exec rubocop --only Custom/NoDebugStatements
          bundle exec rubocop --only Custom/PreferServiceObjects

  quality-gate:
    runs-on: ubuntu-latest
    needs: [rubocop, custom-cops]

    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Check Quality Metrics
        run: |
          violations=$(bundle exec rubocop --format json | jq '.summary.offense_count')
          echo "Total violations: $violations"

          if [ $violations -gt 0 ]; then
            echo "❌ Quality gate failed: $violations violations found"
            exit 1
          else
            echo "✅ Quality gate passed: No violations"
          fi
```
</details>

## Part 2: Pre-commit Hooks

### Task 2.1: Simple Git Hook

Create a pre-commit hook that runs RuboCop on staged files:

```bash
# .git/hooks/pre-commit
#!/bin/bash

# TODO: Implement pre-commit hook
# 1. Get staged Ruby files
# 2. Run RuboCop on them
# 3. Exit 1 if violations found
# 4. Show helpful message
```

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

echo "Running RuboCop on staged files..."

# Get staged Ruby files
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.rb$')

if [ -z "$files" ]; then
  echo "No Ruby files to check"
  exit 0
fi

# Run RuboCop
bundle exec rubocop $files

# Check exit code
if [ $? -ne 0 ]; then
  echo ""
  echo "❌ RuboCop found issues. Please fix them before committing."
  echo ""
  echo "To auto-fix issues, run:"
  echo "  rubocop -a $files"
  echo ""
  echo "To skip this check (not recommended), use:"
  echo "  git commit --no-verify"
  echo ""
  exit 1
fi

echo "✅ RuboCop passed!"
exit 0
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```
</details>

### Task 2.2: Using Overcommit

Set up Overcommit for managed git hooks:

<details>
<summary>Solution</summary>

```ruby
# Gemfile
group :development do
  gem 'overcommit'
end
```

```bash
bundle install
overcommit --install
```

```yaml
# .overcommit.yml
PreCommit:
  RuboCop:
    enabled: true
    command: ['bundle', 'exec', 'rubocop']
    flags: ['--display-cop-names']
    on_warn: fail

  StandardRb:
    enabled: true
    command: ['bundle', 'exec', 'standardrb']

  TrailingWhitespace:
    enabled: true
    exclude:
      - 'db/schema.rb'

CommitMsg:
  TextWidth:
    enabled: true
    max_subject_width: 72
    max_body_width: 80

  CapitalizedSubject:
    enabled: true

PostCheckout:
  BundleInstall:
    enabled: true
```

Sign the configuration:
```bash
overcommit --sign
```
</details>

## Part 3: Pull Request Review Automation

### Task 3.1: Reviewdog Integration

Use Reviewdog to comment on PRs with RuboCop violations:

```yaml
# .github/workflows/reviewdog.yml
name: Reviewdog

on: [pull_request]

jobs:
  rubocop:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Run RuboCop with Reviewdog
        uses: reviewdog/action-rubocop@v2
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          rubocop_version: gemfile
          rubocop_extensions: rubocop-performance:gemfile
```

### Task 3.2: Danger Integration

Use Danger to enforce PR standards:

```ruby
# Gemfile
group :development do
  gem 'danger'
  gem 'danger-rubocop'
end
```

```ruby
# Dangerfile
# Run RuboCop and comment inline
rubocop.lint(inline_comment: true)

# Check for large PRs
if git.lines_of_code > 500
  warn("This PR is quite large. Consider breaking it up.")
end

# Ensure PR description
if github.pr_body.length < 10
  fail("Please add a detailed PR description.")
end

# Check for tests
has_app_changes = !git.modified_files.grep(/^app/).empty?
has_test_changes = !git.modified_files.grep(/^spec/).empty?

if has_app_changes && !has_test_changes
  warn("This PR modifies app code but doesn't include tests.")
end

# Check for changelog
has_changelog = git.modified_files.include?("CHANGELOG.md")
if has_app_changes && !has_changelog
  warn("Consider updating CHANGELOG.md")
end
```

```yaml
# .github/workflows/danger.yml
name: Danger

on: [pull_request]

jobs:
  danger:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Run Danger
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: bundle exec danger
```

## Part 4: Quality Metrics Dashboard

### Task 4.1: Track Quality Over Time

Create a script to track RuboCop violations:

```ruby
# bin/quality_report
#!/usr/bin/env ruby

require 'json'
require 'date'

# Run RuboCop and get JSON output
rubocop_output = `bundle exec rubocop --format json`
results = JSON.parse(rubocop_output)

# Extract metrics
metrics = {
  date: Date.today.to_s,
  total_files: results['summary']['target_file_count'],
  inspected_files: results['summary']['inspected_file_count'],
  offense_count: results['summary']['offense_count'],
  offenses_by_severity: results['summary']['offense_count_by_severity']
}

# Append to tracking file
File.open('quality_metrics.json', 'a') do |f|
  f.puts(metrics.to_json)
end

# Print summary
puts "\n📊 Code Quality Report"
puts "=" * 50
puts "Date: #{metrics[:date]}"
puts "Files inspected: #{metrics[:inspected_files]}"
puts "Total offenses: #{metrics[:offense_count]}"
puts "\nBy severity:"
metrics[:offenses_by_severity].each do |severity, count|
  puts "  #{severity}: #{count}"
end

# Check if improved
if File.exist?('quality_metrics.json')
  lines = File.readlines('quality_metrics.json')
  if lines.length > 1
    previous = JSON.parse(lines[-2])
    change = metrics[:offense_count] - previous['offense_count']

    if change < 0
      puts "\n✅ Improved by #{change.abs} offenses!"
    elsif change > 0
      puts "\n❌ Regressed by #{change} offenses"
    else
      puts "\n➖ No change"
    end
  end
end
```

Make executable:
```bash
chmod +x bin/quality_report
```

Add to CI:
```yaml
# .github/workflows/quality-tracking.yml
- name: Generate Quality Report
  run: ./bin/quality_report

- name: Upload Metrics
  uses: actions/upload-artifact@v3
  with:
    name: quality-metrics
    path: quality_metrics.json
```

## Part 5: Full Integration Example

### Task 5.1: Complete CI/CD Pipeline

Combine everything into a comprehensive pipeline:

<details>
<summary>Complete Pipeline</summary>

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true
      - run: bundle exec rspec

  lint:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: RuboCop
        run: bundle exec rubocop --parallel

      - name: StandardRB
        run: bundle exec standardrb

  security:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Brakeman
        run: bundle exec brakeman --no-pager

  quality-gate:
    needs: [tests, lint, security]
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true

      - name: Quality Metrics
        run: ./bin/quality_report

      - name: Check Coverage
        run: |
          coverage=$(cat coverage/.last_run.json | jq '.result.line')
          if (( $(echo "$coverage < 80" | bc -l) )); then
            echo "❌ Coverage below 80%: $coverage%"
            exit 1
          fi
```
</details>

## Verification

Test your CI/CD setup:

```bash
# Test pre-commit hook locally
git add .
git commit -m "Test commit"

# Trigger GitHub Actions
git push origin feature-branch

# View workflow results
gh run list
gh run view <run-id>

# Test Danger locally
bundle exec danger pr <PR-URL>
```

## Key Learnings

- GitHub Actions automates quality checks
- Pre-commit hooks catch issues early
- Reviewdog provides inline PR comments
- Danger enforces PR standards
- Quality metrics track improvement
- Caching speeds up CI workflows
- Failed quality checks block merges

## Bonus Challenges

1. **Slack Notifications**: Send Slack alerts on quality gate failures
2. **Coverage Trending**: Track test coverage over time
3. **Performance Benchmarks**: Add performance regression detection
4. **Auto-fix PRs**: Create automated PRs to fix violations
5. **Quality Badges**: Add code quality badges to README

## Next Steps

You've completed the Code Quality Tools tutorial! Next, move on to **[Tutorial 4: Design Patterns](../../4-design-patterns/README.md)** to learn Ruby patterns for clean architecture.
