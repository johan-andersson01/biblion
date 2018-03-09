class AddIndexTagsGenreAuthorInBooks < ActiveRecord::Migration[5.0]
  def change
    add_index :books, :tags
    add_index :books, :genre
    add_index :books, :author
  end
end
