class RemoveSwapsFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :swaps, :integer
  end
end
