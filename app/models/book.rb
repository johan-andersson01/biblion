class Book < ApplicationRecord
  searchable do
   text :title, :author, :genre
   string  :sort_title do
     title.downcase.gsub(/^(an?|the)/, '')
   end
 end
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  attr_accessor :query
  validates :user_id, presence: true
  validates :author, presence: true
  validates :title, presence: true
  validates :quality, presence: true
  validates :language, presence: true

end
