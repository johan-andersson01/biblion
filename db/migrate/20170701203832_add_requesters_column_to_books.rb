class AddRequestersColumnToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :requesters, :string
  end
end
