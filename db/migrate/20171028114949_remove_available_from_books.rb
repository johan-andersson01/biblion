class RemoveAvailableFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :available, :boolean
  end
end
