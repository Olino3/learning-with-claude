# frozen_string_literal: true

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :user, presence: true

  scope :published, -> { where(published: true) }
  scope :drafts, -> { where(published: false) }
  scope :recent, -> { order(created_at: :desc) }
end

class PostTag < ActiveRecord::Base
  self.table_name = 'post_tags'
  belongs_to :post
  belongs_to :tag
end
