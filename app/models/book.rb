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

   before_validation { self.language = expand_language_code }
   before_validation { self.language = language.capitalize if language.present? }

  def self.search(query)
    unless query.nil?
      query.downcase!
      query.strip!
      query = "%#{query}%"
      where("LOWER(author) LIKE ?", query)
        .or(where("LOWER(title) LIKE ?", query))
        .or(where("LOWER(genre) LIKE ?", query))
        .or(where("LOWER(tags) LIKE ?", query))
    end
  end

  private

  def expand_language_code
    case language
    when 'sv'
      'Svenska'
    when 'en'
      'Engelska'
    when 'da'
      'Danska'
    when 'no'
      'norska'
    when 'fi'
      'Finska'
    else
      language
    end
  end
end
