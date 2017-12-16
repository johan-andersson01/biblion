class AddTagsToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :tags, :text
  end
end
