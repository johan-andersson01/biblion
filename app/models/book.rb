class Book < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  attr_accessor :query
  validates :user_id, presence: true
  validates :author, presence: true, length: {minimum: 4, maximum: 100}
  validates :title, presence: true, length: {minimum: 2, maximum: 150}
  validates :quality, presence: true, length: {maximum: 15}
  validates :genre, presence: true, length: {maximum: 30}
  validates :language, presence: true, length: {maximum: 30}

  
  def self.search(query)
    where("LOWER(author) LIKE ?", "%#{query}%").or(where("LOWER(title) LIKE ?", "%#{query}%")).or(where("LOWER(genre) LIKE ?", "%#{query}%"))
  end

end
