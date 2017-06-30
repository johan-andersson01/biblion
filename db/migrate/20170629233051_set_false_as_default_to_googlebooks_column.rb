class SetFalseAsDefaultToGooglebooksColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :googlebooks, :boolean, default: false
  end
end
