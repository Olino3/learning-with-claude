# frozen_string_literal: true

# Model extensions for the Todo application
module TodoModels
  module TaskExtensions
    # Get task age in days
    def age_in_days
      ((Time.now - created_at) / 86400).to_i
    end

    # Toggle completion status
    def toggle!
      update(completed: !completed)
    end

    # Get a short description (first 50 chars)
    def short_description
      return '' unless description
      description.length > 50 ? "#{description[0..47]}..." : description
    end

    # Check if task is recent (created in last 24 hours)
    def recent?
      created_at > Time.now - 86400
    end
  end

  module CategoryExtensions
    # Get completed tasks count for this category
    def completed_count
      tasks.count { |t| t.completed }
    end

    # Get active tasks count for this category
    def active_count
      tasks.count { |t| !t.completed }
    end

    # Get completion percentage
    def completion_percentage
      return 0 if tasks.empty?
      (completed_count.to_f / tasks.count * 100).round
    end

    # Get category with task counts
    def summary
      {
        id: id,
        name: name,
        color: color,
        total: tasks.count,
        completed: completed_count,
        active: active_count,
        percentage: completion_percentage
      }
    end
  end
end
