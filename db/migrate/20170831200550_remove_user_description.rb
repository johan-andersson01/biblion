class RemoveUserDescription < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :user_description
  end
end
