# frozen_string_literal: true

# Database models for the Todo application
#
# This file defines the data models using Sequel ORM:
# - Category: Groups tasks into categories (Work, Personal, etc.)
# - Task: Individual todo items with title, description, and completion status
#
# For Python developers:
# - Similar to SQLAlchemy models or Django ORM models
# - Sequel provides ActiveRecord-like pattern for Ruby
# - Associations: one_to_many / many_to_one like SQLAlchemy relationships

# Note: The actual model classes are defined in app.rb after database connection
# This file can be extended to include additional model methods and validations

module TodoModels
  # Model extensions and custom methods can go here

  module TaskExtensions
    # Check if task is overdue (if we add due_date feature)
    def overdue?
      due_date && due_date < Date.today && !completed
    end

    # Get task age in days
    def age_in_days
      ((Time.now - created_at) / 86400).to_i
    end

    # Toggle completion status
    def toggle!
      update(completed: !completed)
    end

    # Mark as complete
    def mark_complete!
      update(completed: true)
    end

    # Mark as incomplete
    def mark_incomplete!
      update(completed: false)
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

# Example of how to extend models (can be uncommented if models are defined here):
# class Task < Sequel::Model
#   include TodoModels::TaskExtensions
# end
#
# class Category < Sequel::Model
#   include TodoModels::CategoryExtensions
# end

# For Python developers, here's how similar models would look in different frameworks:

=begin

# Flask-SQLAlchemy equivalent:
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)
    color = db.Column(db.String(7), nullable=False, default='#007bff')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    tasks = db.relationship('Task', backref='category', lazy=True)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    completed = db.Column(db.Boolean, default=False)
    category_id = db.Column(db.Integer, db.ForeignKey('category.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

# Django ORM equivalent:
from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    color = models.CharField(max_length=7, default='#007bff')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = 'categories'

class Task(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    completed = models.BooleanField(default=False)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='tasks')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

=end
