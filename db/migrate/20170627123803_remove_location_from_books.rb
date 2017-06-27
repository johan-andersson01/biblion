class RemoveLocationFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :location
  end
end
