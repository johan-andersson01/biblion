class SetRequestersDefaultToEmpty < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :requesters, :text, default: ""
  end
end
