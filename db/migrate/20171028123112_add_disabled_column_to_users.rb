class AddDisabledColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :disabled, :boolean
  end
end
