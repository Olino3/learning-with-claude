# frozen_string_literal: true

class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :post, presence: true
  validates :user, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
