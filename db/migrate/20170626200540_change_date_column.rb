class ChangeDateColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :year, :datetime
  end
end
