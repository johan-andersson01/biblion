class AddIndexToDonatedInBooks < ActiveRecord::Migration[5.0]
  def change
    add_index :books, :donated
  end
end
