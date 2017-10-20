class Book < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  attr_accessor :query
  validates :user_id, presence: true
  validates :author, presence: true
  validates :title, presence: true
  validates :quality, presence: true
  validates :language, presence: true

  
  def self.search(query)
    where("LOWER(author) LIKE ?", "%#{query}%").or(where("LOWER(title) LIKE ?", "%#{query}%")).or(where("LOWER(genre) LIKE ?", "%#{query}%"))
  end

end
