# frozen_string_literal: true

class Tag < ActiveRecord::Base
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 50 }

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.downcase.strip.gsub(/\s+/, '-') if name.present?
  end
end
