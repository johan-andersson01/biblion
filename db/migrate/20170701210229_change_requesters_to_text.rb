class ChangeRequestersToText < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :requesters, :text
  end
end
