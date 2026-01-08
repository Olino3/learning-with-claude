# Timestampable Concern (Tutorial 13: Mixins and Modules)
# Automatically adds created_at and updated_at timestamps

module Timestampable
  def self.included(base)
    base.class_eval do
      attr_reader :created_at, :updated_at
    end
  end

  def initialize(*args, **kwargs)
    @created_at = Time.now
    @updated_at = Time.now
    super
  end

  def touch
    @updated_at = Time.now
    self
  end
end
