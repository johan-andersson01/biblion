class FixDefaultValueForUserDisabled < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :disabled, :boolean, default: false
  end
end
