class Book < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :author, presence: true
  validates :title, presence: true
  validates :year, presence: true
  validates :cover, presence: true
  validates :user_description, length: { maximum: 140 }

end
