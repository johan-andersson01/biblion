class DropRequestersColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :requesters
  end
end
