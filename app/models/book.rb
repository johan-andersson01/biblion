class Book < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  attr_accessor :query
  validates :user_id, presence: true
  validates :author, presence: true
  validates :title, presence: true
  validates :cover, presence: true
  validates :quality, presence: true
  validates :language, presence: true
  validates :user_description, length: { maximum: 140 }

end
