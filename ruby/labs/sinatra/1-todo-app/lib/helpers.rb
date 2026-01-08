# frozen_string_literal: true

# View helper methods for the Todo application
#
# These helpers make views cleaner and more maintainable by
# extracting common formatting and display logic.
#
# For Python developers:
# - Similar to Django template filters or Flask template functions
# - Jinja2 custom filters would be the closest equivalent

module TodoHelpers
  # Format a date/time in a human-readable format
  # Example: format_date(Time.now) => "Jan 8, 2026 at 3:45 PM"
  def format_date(datetime)
    return '' unless datetime
    datetime.strftime('%b %d, %Y at %I:%M %p')
  end

  # Format a date as "X days ago" or "Today"
  def relative_date(datetime)
    return '' unless datetime

    diff = Time.now - datetime
    days = (diff / 86400).to_i

    case days
    when 0
      'Today'
    when 1
      'Yesterday'
    when 2..6
      "#{days} days ago"
    when 7..13
      '1 week ago'
    when 14..29
      "#{days / 7} weeks ago"
    else
      format_date(datetime)
    end
  end

  # Generate a category badge with the category's color
  # Returns HTML for a colored badge
  def category_badge(category)
    return '<span class="badge badge-secondary">No Category</span>' unless category

    <<~HTML
      <span class="badge" style="background-color: #{category.color}">
        #{h(category.name)}
      </span>
    HTML
  end

  # Generate a status badge for a task
  def task_status_badge(task)
    if task.completed
      '<span class="badge badge-success">✓ Completed</span>'
    else
      '<span class="badge badge-warning">○ Active</span>'
    end
  end

  # Generate a priority indicator (if we add priority field)
  def priority_indicator(priority)
    colors = { high: '#dc3545', medium: '#ffc107', low: '#28a745' }
    color = colors[priority.to_sym] || '#6c757d'

    <<~HTML
      <span class="priority-dot" style="background-color: #{color}"
            title="#{priority.capitalize} priority"></span>
    HTML
  end

  # Truncate text to a specific length
  def truncate(text, length = 50)
    return '' unless text
    text.length > length ? "#{text[0...length]}..." : text
  end

  # Pluralize a word based on count
  # Example: pluralize(5, 'task') => "5 tasks"
  def pluralize(count, singular, plural = nil)
    plural ||= "#{singular}s"
    word = count == 1 ? singular : plural
    "#{count} #{word}"
  end

  # Escape HTML to prevent XSS attacks
  # Sinatra provides 'h' but we can alias it for clarity
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
  alias h escape_html

  # Generate a task class based on status
  def task_row_class(task)
    classes = ['task-row']
    classes << 'completed' if task.completed
    classes << 'recent' if task.respond_to?(:recent?) && task.recent?
    classes.join(' ')
  end

  # Generate filter link with active state
  def filter_link(text, filter_value)
    current_filter = params[:filter] || 'all'
    active = current_filter == filter_value ? 'active' : ''

    <<~HTML
      <a href="/tasks?filter=#{filter_value}" class="filter-link #{active}">
        #{h(text)}
      </a>
    HTML
  end

  # Generate category filter link
  def category_filter_link(category)
    current_category = params[:category]
    active = current_category == category.id.to_s ? 'active' : ''

    <<~HTML
      <a href="/tasks?category=#{category.id}" class="category-link #{active}">
        #{category_badge(category)}
      </a>
    HTML
  end

  # Format completion percentage
  def completion_percentage(completed, total)
    return 0 if total.zero?
    ((completed.to_f / total) * 100).round
  end

  # Generate a progress bar
  def progress_bar(percentage)
    color = case percentage
            when 0...33 then '#dc3545'
            when 33...66 then '#ffc107'
            else '#28a745'
            end

    <<~HTML
      <div class="progress">
        <div class="progress-bar" style="width: #{percentage}%; background-color: #{color}">
          #{percentage}%
        </div>
      </div>
    HTML
  end

  # Check if current page matches path
  def current_page?(path)
    request.path_info == path
  end

  # Generate active class for navigation
  def nav_active(path)
    current_page?(path) ? 'active' : ''
  end

  # Render flash messages
  def flash_messages
    return '' if flash.empty?

    flash.map do |type, message|
      alert_class = case type.to_sym
                    when :success then 'alert-success'
                    when :error then 'alert-danger'
                    when :warning then 'alert-warning'
                    when :info then 'alert-info'
                    else 'alert-info'
                    end

      <<~HTML
        <div class="alert #{alert_class} alert-dismissible fade show" role="alert">
          #{h(message)}
          <button type="button" class="close" data-dismiss="alert">
            <span>&times;</span>
          </button>
        </div>
      HTML
    end.join("\n")
  end

  # Generate a form error message
  def error_for(object, field)
    return '' unless object && object.respond_to?(:errors)
    errors = object.errors.on(field)
    return '' unless errors

    <<~HTML
      <div class="invalid-feedback d-block">
        #{h(errors.join(', '))}
      </div>
    HTML
  end
end

# For Python developers, here's how similar helpers would look:

=begin

# Flask template functions (in app.py):
from datetime import datetime

@app.template_filter('format_date')
def format_date(dt):
    if not dt:
        return ''
    return dt.strftime('%b %d, %Y at %I:%M %p')

@app.template_filter('pluralize')
def pluralize(count, singular, plural=None):
    if plural is None:
        plural = f"{singular}s"
    return f"{count} {singular if count == 1 else plural}"

# Django template filters (in templatetags/todo_filters.py):
from django import template
from django.utils.html import format_html

register = template.Library()

@register.filter
def category_badge(category):
    if not category:
        return format_html('<span class="badge badge-secondary">No Category</span>')
    return format_html(
        '<span class="badge" style="background-color: {};">{}</span>',
        category.color,
        category.name
    )

@register.simple_tag
def progress_bar(percentage):
    colors = {
        range(0, 33): '#dc3545',
        range(33, 66): '#ffc107',
        range(66, 101): '#28a745'
    }
    color = next((v for k, v in colors.items() if percentage in k), '#6c757d')

    return format_html(
        '<div class="progress">'
        '<div class="progress-bar" style="width: {}%; background-color: {}">'
        '{}%</div></div>',
        percentage, color, percentage
    )

=end
