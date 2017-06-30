class ChangeGooglebooksColumnToString < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :googlebooks, :string
  end
end
