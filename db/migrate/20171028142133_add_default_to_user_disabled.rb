class AddDefaultToUserDisabled < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :disabled, :boolean, default: 0
  end
end
