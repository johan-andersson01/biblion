class FixDisabledDefaultValue < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :disabled, :boolean
    add_column :users, :disabled, :boolean, default: false
  end
end
