class AddGooglebooksBooleanToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :googlebooks, :boolean
  end
end
