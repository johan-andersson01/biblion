class AddOwnersCommentToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :comment, :text
  end
end
